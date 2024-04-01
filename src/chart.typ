#import "./utils.typ": size-to-scale, parse-input-string, top-border-rect, top-border-rounded, total-bounds

// Draws a horizontal border that indicates the starting of the fretboard
#let draw-nut(self) = {
  let size = (
    width: self.grid.width,
    height: 1.2pt * self.scale
  )

  let elements = {
    if self.fret in (none, 1) {
      if self.style == "normal" {
        top-border-rect(size, self.stroke, self.scale)
      } else {
        top-border-rounded(size, self.stroke, self.scale)
      }
    }
  }

  return (
    bounds: (
      dx: 0pt,
      dy: 0pt,
      width: size.width,
      height: size.height
    ),
    elements: elements
  )
}

// Draws a grid with a width = (length of tabs) and height = (number of frets)
#let draw-grid(self) = {
  let radius = (bottom: 1pt * self.scale, top: 1pt * self.scale)

  let elements = {
    place(
      rect(
        width: self.grid.width,
        height: self.grid.height,
        radius: if self.style == "normal" {0pt} else {radius},
        stroke: self.stroke
      )
    )

    // draws the vertical lines
    for i in range(self.grid.cols - 1) {
      let x = (i + 1) * self.step
      place(
        line(
          start: (x, 0pt),
          end: (x, self.grid.height),
          stroke: self.stroke
        )
      )
    }

    // draws the horizontal lines
    for i in range(self.grid.rows - 1) {
      let y = (i + 1) * self.step
      place(
        line(
          start: (0pt, y),
          end: (self.grid.width, y),
          stroke: self.stroke
        )
      )
    }
  }

  return (
    bounds: (
      dx: 0pt,
      dy: 0pt,
      width: self.grid.width,
      height: self.grid.height
    ),
    elements: elements
  )
}

// Draws the tabs over the grid
#let draw-tabs(self) = {
  let radius = 1.7pt * self.scale

  let elements = {
    for (tab, col) in self.tabs.zip(range(self.tabs.len())) {
      if type(tab) == "string" and lower(tab) == "x" {
        let offset = col * self.step
        place(
          line(
            start: (offset - 1.5pt * self.scale, -2.5pt * self.scale),
            end: (offset + 1.5pt * self.scale, -5.5pt * self.scale),
            stroke: self.stroke
          )
        )
        place(
          line(
            start: (offset - 1.5pt * self.scale, -5.5pt * self.scale),
            end: (offset + 1.5pt * self.scale, -2.5pt * self.scale),
            stroke: self.stroke
          )
        )
        continue
      }
      if (type(tab) == str and lower(tab) == "o") {
        place(
          dx: self.step * col - radius,
          dy: -4pt * self.scale - radius,
          circle(radius: radius, stroke: self.stroke)
        )
        continue
      }
      if type(tab) == int and tab > 0 and tab <= self.frets-amount {
        place(
          dx: self.step * col - radius,
          dy: self.step * tab - radius - 2.5pt * self.scale,
          circle(radius: radius, stroke: none, fill: black)
        )
        continue
      }
    }
  }

  return (
    bounds: (
      dx: 0pt,
      dy: -(4pt * self.scale + radius),
      width: self.grid.width,
      height: 2 * radius
    ),
    elements: elements
  )
}

// Draws a capo list
//
// capo = (fret, start, end)
// fret: fret position
// start: lowest starting string
// end: highest ending string
#let draw-capos(self) = {
  let size = self.tabs.len()

  let elements = {
    for (fret, start, end, ..) in self.capos {
      if start > size {
        start = size
      }
      if end > size {
        end = size
      }
      place(
        dy: fret * self.step - 2.5pt * self.scale,
        line(
          start: ((size - start) * self.step, 0pt),
          end: ((size - end) * self.step, 0pt),
          stroke: (paint: black, thickness: 3.4pt * self.scale, cap: "round")
        )
      )
    }
  }

  return (
    bounds: (
      dx: 0pt,
      dy: 0pt,
      width: 0pt,
      height: 0pt
    ),
    elements: elements
  )
}

// Draws the finger numbers below the grid
#let draw-fingers(self) = {
  let size = self.tabs.len()

  let elements = {
    for (finger, col) in self.fingers.zip(range(size)) {
      if type(finger) == int and finger > 0 and finger < 6 {
        place(
          left + top,
          dx: col * self.step - 1.3pt * self.scale,
          dy: self.grid.height + 1.5pt * self.scale,
          text(6pt * self.scale)[#finger])
      }
    }
  }

  let (dx, dy, width, height) = (0pt, 0pt, 0pt, 0pt)

  if self.fingers.len() != 0 {
    let size = measure(text(6pt * self.scale)[~])

    dy = self.grid.height + 1.5pt * self.scale
    width = size.width
    height = size.height
  }

  return (
    bounds: (
      dx: dx,
      dy: dy,
      width: width,
      height: height
    ),
    elements: elements
  )
}

// Draws the fret start number that indicates the starting position of the fretboard
#let draw-fret(self) = {
  let dx = -3pt * self.scale
  let dy = self.step / 2 - 0.2pt * self.scale
  let size = measure(text(8pt * self.scale)[#self.fret])

  let elements = {
    place(left + top,
      dx: dx,
      dy: dy,
      place(right + horizon, text(8pt * self.scale)[#self.fret])
    )
  }

  return (
    bounds: (
      dx: dx - size.width,
      dy: dy,
      width: size.width,
      height: size.height
    ),
    elements: elements
  )
}

// Draws the chord name below the grid and finger numbers
#let draw-name(self) = {
  let vertical-gap = {
    if self.position == "bottom" and self.fingers.len() == 0 {
      5pt * self.scale
    } else {
      10pt * self.scale
    }
  }

  let anchor = top
  let dx = self.grid.width / 2
  let dy = self.grid.height + vertical-gap

  if self.position == "top" {
    dy = -vertical-gap
    anchor = bottom
  }

  let elements = {
    place(
      center + anchor,
      dx: dx,
      dy: dy,
      box(
        fill: self.background,
        outset: 2pt * self.scale,
        radius: 2pt * self.scale,
        text(12pt * self.scale)[#self.name]
      )
    )
  }

  let size = (:)
  size.name = measure(text(12pt * self.scale)[#self.name])
  size.fret = measure(text(8pt * self.scale)[#self.fret])
  size.graph = (
    width: self.tabs.len() * self.step,
    height: self.frets-amount * self.step
  )

  dx = (self.grid.width - size.name.width) / 2

  if self.position == "top" {
    dy -= size.name.height
  }

  return (
    bounds: (
      dx: dx,
      dy: dy,
      width: size.name.width,
      height: size.name.height
    ),
    elements: elements
  )
}

// Render the chart
#let render(self) = context {
  let objects = (
    draw-nut(self),
    draw-grid(self),
    draw-tabs(self),
    draw-capos(self),
    draw-fingers(self),
    draw-fret(self),
    draw-name(self)
  )

  let init = (
    bounds: (dx: 0pt, dy: 0pt, width: 0pt, height: 0pt),
    elements: []
  )

  let (bounds, elements) = objects.fold(
    init,
    (acc, (bounds, elements)) => {
      return (
        bounds: total-bounds(acc.bounds, bounds),
        elements: acc.elements + elements
      )
    }
  )

  box(
    width: bounds.width,
    height: bounds.height,
    place(
      left + top,
      dx: -bounds.dx,
      dy: -bounds.dy, {
        elements
      }
    )
  )
}

/// Generates a chart chord for stringed instruments.
///
/// - tabs (string): Shows the tabs on the chart. *Optional*.
///  - *x*: mute note.
///  - *o*: air note.
///  - *n*: without note.
///  - *number*: note position on the fret.
///
/// The string length of tabs defines the number of strings on the instrument.
///  #parbreak() Example:
///  - ```js "x32o1o"``` - (6 strings - C Guitar chord).
///  - ```js "ooo3"``` - (4 strings - C Ukulele chord).
///
/// - fingers (string): Shows the finger numbers. *Optional*.
///  - *n*, *x*, *o*: without finger,
///  - *number*: one finger
///  #parbreak() Example: ```js "n32n1n"``` - (Fingers for guitar chord: C)
///
/// - capos (string): Adds one or many capos on the chart. *Optional*.
///  - 1#super[st] digit -- *fret*: fret position.
///  - 2#super[nd] digit -- *start*: lowest starting string.
///  - 3#super[rd] digit -- *end*: highest ending string.
///  #parbreak() Example: ```js "115"``` $\u{2261}$ ```js "1,1,5"``` $=>$ ```js "fret,start,end"```
///  #parbreak() With ```js "|"``` you can add capos:
///  #parbreak() Example: ```js "115|312"``` $\u{2261}$ ```js "1,1,5|3,1,2"``` $=>$ ```js "fret,start,end|fret,start,end"```
///
/// - fret (integer): Shows the fret number that indicates the starting position of the fretboard. *Optional*.
///
/// - frets-amount (integer): Sets the frets amount (the grid rows). *Optional*.
///
/// - size (length): Sets the chart size. The default value is set to the chord name's font size. *Optional*.
///
/// - style (string): Sets the chart style. *Optional*.
///  - ```js "rect"```: chart with rect angles.
///  - ```js "rounded"```: chart with rounded angles.
///
/// - position (string): Sets the chord name position. *Optional*.
///  - ```js "bottom"```: chord name in the bottom position.
///  - ```js "top"```: chord name in the top position.
///
/// - font (string): Sets the name of the text font. *Optional*.
///
/// - background (color): Sets the background color of the chord name. *Optional*.
///
/// - name (string, content): Shows the chord name. *Required*.
///
/// -> content
#let chart-chord(
  tabs: "",
  fingers: "",
  capos: "",
  fret: none,
  frets-amount: 5,
  size: 12pt,
  style: "rect",
  position: "bottom",
  font: "Linux Libertine",
  background: rgb(0, 0, 0, 0),
  name
) = {
  assert.eq(type(tabs), str)
  assert.eq(type(fingers), str)
  assert.eq(type(capos), str)
  assert.eq(type(frets-amount), int)
  assert.eq(type(size), length)
  assert.eq(type(background), color)
  assert(type(fret) == int or fret == none, message: "type of 'fret' must to be 'int' or 'none'")
  assert(type(name) in (str, content), message: "type of 'name' must to be 'str' or 'content'")
  assert(style in ("rect", "rounded"), message: "'style' must to be '\"rect\"' or '\"rounded\"'")
  assert(position in ("bottom", "top"), message: "'position' must to be '\"bottom\"' or '\"top\"'")

  let tabs = parse-input-string(tabs)
  let fingers = parse-input-string(fingers)
  let capos = parse-input-string(capos)
  if capos.len() != 0 and type(capos.first()) != "array" {
    capos = (capos,)
  }

  let scale = size-to-scale(size, 12pt)
  let step = 5pt * scale
  let stroke = black + 0.5pt * scale

  set text(font: font)

  let self = (
    grid: (
      width: (tabs.len() - 1) * step,
      height: frets-amount * step,
      rows: frets-amount,
      cols: tabs.len() - 1,
    ),
    scale: scale,
    step: step,
    stroke: black + 0.5pt * scale,
    position: position,
    background: background,
    style: style,
    tabs: tabs,
    fingers: fingers,
    capos: capos,
    frets-amount: frets-amount,
    fret: fret,
    name: name,
  )

  render(self)
}
