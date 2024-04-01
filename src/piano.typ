#import "./utils.typ": size-to-scale, parse-input-string, top-border-rect, top-border-rounded, total-bounds

// A dictionary with the key names for the white-keys and their indices
#let white-keys-dict = (
  "C1": 0,
  "D1": 1,
  "E1": 2,
  "F1": 3,
  "G1": 4,
  "A1": 5,
  "B1": 6,  "C2b": 6,
  "C2": 7,  "B1#": 7,
  "D2": 8,
  "E2": 9,  "F2b": 9,
  "F2": 10, "E2#": 10,
  "G2": 11,
  "A2": 12,
  "B2": 13, "C3b": 13,
  "C3": 14, "B2#": 14,
  "D3": 15,
  "E3": 16, "F3b": 16,
)

// A dictionary with the key names for the black-keys and their indices
#let black-keys-dict = (
  "C1#": 1,  "D1b": 1,
  "D1#": 2,  "E1b": 2,
  "F1#": 4,  "G1b": 4,
  "G1#": 5,  "A1b": 5,
  "A1#": 6,  "B1b": 6,
  "C2#": 8,  "D2b": 8,
  "D2#": 9,  "E2b": 9,
  "F2#": 11, "G2b": 11,
  "G2#": 12, "A2b": 12,
  "A2#": 13, "B2b": 13,
  "C3#": 15, "D3b": 15,
  "D3#": 16, "E3b": 16,
)

// Returns the indices of a key array of white-keys-dict or black-keys-dict
#let keys-to-array-index(dict, key-array) = {
  key-array
    .map(k => dict.at(k, default: none))
    .filter(k => k != none)
}

// Remove the number of the key name (C1# -> C#)
#let normalize-key-name(key) = {
  return key.replace(regex("\d+"), "").replace(regex("b$"), "\u{266D}")
}

// Gets the indices min and max of the layout
#let piano-limits-from-layout(layout) = {
  return if layout == "C" {
    (min: 0, max: 9)
  } else if (layout == "2C") {
    (min: 0, max: 13)
  } else if layout == "F" {
    (min: 3, max: 13)
  } else { // "2F"
    (min: 3, max: 16)
  }
}

// Returns the white-keys amount in the layout
#let white-keys-amount-from-layout(layout) = {
  return if layout == "C" {
    10
  } else if layout == "F" {
    11
  } else {
    14
  }
}

// Returns the black-keys amount in the layout
#let black-keys-index-from-layout(layout) = {
  return if layout in ("C", "2C") {
    ( left: (1, 4, 8, 11), mid: (5, 12), right: (2, 6, 9, 13) )
  } else {
    ( left: (4, 8, 11, 15), mid: (5, 12), right: (6, 9, 13, 16) )
  }
}

// Draws the piano
#let draw-piano(self) = {
  // draws the white-keys
  let elements = {
    for i in range(self.white-keys.amount) {
      let key-pressed = i + self.limit.min
      let fill-color = if key-pressed in self.tabs.white-keys-index { self.fill } else { white }
      let dx = i * self.white-keys.width

      let radius-style = if self.style == "normal" {
        0pt
      } else {
        if i == 0 {
          (bottom: self.round, top-left: self.round)
        } else if i == self.white-keys.amount - 1 {
          (bottom: self.round, top-right: self.round)
        } else {
          (bottom: self.round)
        }
      }

      place(
        dx: dx,
        rect(
          width: self.white-keys.width,
          height: self.white-keys.height,
          radius: radius-style,
          stroke: self.stroke,
          fill: fill-color
        )
      )
    }

    // draw the black-keys
    for i in range(self.white-keys.amount) {
      let key-pressed = i + self.limit.min
      let fill-color = if key-pressed in self.tabs.black-keys-index {self.fill} else {black}
      let base = i * self.white-keys.width - self.black-keys.width / 2
      let dx = 0pt

      if key-pressed in self.black-keys.left {
        dx = base - self.black-keys.shift
      } else if key-pressed in self.black-keys.mid {
        dx = base
      } else if key-pressed in self.black-keys.right {
        dx = base + self.black-keys.shift
      } else {
        continue
      }

      place(
        dx: dx,
        rect(
          width: self.black-keys.width,
          height: self.black-keys.height,
          radius: if self.style == "normal" {0pt} else {(bottom: self.round)},
          stroke: self.stroke,
          fill: fill-color
        )
      )
    }
  }

  return (
    bounds: (
      dx: 0pt,
      dy: 0pt,
      width: self.piano.width,
      height: self.piano.height
    ),
    elements: elements
  )
}

// Draws border top
#let draw-top-border(self) = {
  let size = (
    width: self.piano.width,
    height: 1.2pt * self.scale
  )

  let elements = {
    if self.style == "rect" {
      top-border-rect(size, self.stroke, self.scale)
    } else {
      top-border-rounded(size, self.stroke, self.scale)
    }
  }

  return (
    bounds: (
      dx: 0pt,
      dy: -size.height,
      width: size.width,
      height: size.height
    ),
    elements: elements
  )
}

// Draws tabs or dots over the piano
#let draw-tabs(self) = {
  // draws tabs on white-keys chord
  let elements = {
    for i in self.tabs.white-keys-index {
      if i < self.limit.min or i > self.limit.max {
        continue
      }

      let radius = 1.7pt * self.scale
      let dx = (i - self.limit.min + 0.5) * self.white-keys.width - radius
      let dy = self.piano.height - 4pt * self.scale - radius

      place(dx: dx, dy: dy, circle(radius: radius, stroke: none, fill: black))
    }

    // draws tabs on black-keys chord
    for i in self.tabs.black-keys-index {
      if i < self.limit.min or i > self.limit.max {
        continue
      }

      let radius = 1.7pt * self.scale
      let dx = 0pt
      let dy = self.black-keys.height - 3.5pt * self.scale - radius
      let base = (i - self.limit.min) * self.white-keys.width - radius

      if i in self.black-keys.left {
        dx = base - self.black-keys.shift
      } else if i in self.black-keys.mid {
        dx = base
      } else if i in self.black-keys.right {
        dx = base + self.black-keys.shift
      } else {
        continue
      }

      place(dx: dx, dy: dy, circle(radius: radius, stroke: none, fill: black))
    }
  }

  return (
    bounds: (
      dx: 0pt,
      dy: 0pt,
      width: self.piano.width,
      height: self.piano.height
    ),
    elements: elements
  )
}

// Draws pressed note names
#let draw-key-notes(self) = {
  let gap-note = 1.8pt * self.scale

  let elements = {
    // white-keys
    let white-keys = self.keys
      .map(key => (white-keys-dict.at(key, default: none), normalize-key-name(key)) )
      .filter(arr => arr.at(0) != none)

    for (i, key-name) in white-keys {
      if i < self.limit.min or i > self.limit.max {
        continue
      }

      let dx = (i - self.limit.min + 0.5) * self.white-keys.width
      let dy = self.piano.height + gap-note

      place(dx: dx, dy: dy, place(center + top, text(6pt * self.scale)[#key-name]),
      )
    }

    // black-keys
    let black-keys = self.keys
      .map(key => (black-keys-dict.at(key, default: none), normalize-key-name(key)) )
      .filter(arr => arr.at(0) != none)

    for (i, key-name) in black-keys {
      if i < self.limit.min or i > self.limit.max {
        continue
      }

      let dx = 0pt
      let dy = -(self.top-border-height + gap-note)
      let base = (i - self.limit.min) * self.white-keys.width

      if i in self.black-keys.left {
        dx = base - self.black-keys.shift
      } else if i in self.black-keys.mid {
        dx = base
      } else if i in self.black-keys.right {
        dx = base + self.black-keys.shift
      } else {
        continue
      }

      place(dx: dx, dy: dy, place(center + bottom, text(6pt * self.scale)[#key-name]))
    }
  }

  let border = 1.2pt * self.scale

  let size = (:)
  size.key = measure(text(6pt * self.scale)[~])
  size.total = (
    width: self.piano.width,
    height: self.piano.height + (gap-note + size.key.height) * 2 + border
  )

  return (
    bounds: (
      dx: 0pt,
      dy: -(gap-note + size.key.height + border),
      width: size.total.width,
      height: size.total.height
    ),
    elements: elements
  )
}

// Draws the chord name below the piano
#let draw-name(self) = {
  let size = (:)
  size.name = measure(text(12pt * self.scale)[#self.name])
  let vertical-gap = 10pt * self.scale

  let dx = self.piano.width / 2
  let dy = self.piano.height + vertical-gap
  let anchor = top

  if self.position == "top" {
    let border = 1.2pt * self.scale
    dx = self.piano.width / 2
    dy = -(vertical-gap + border)
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

  if self.position == "top" {
    dy -= size.name.height
  }

  dx = (self.piano.width - size.name.width) / 2

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

// Render the piano
#let render(self) = context {
  let objects = (
    draw-piano(self),
    draw-top-border(self),
    draw-tabs(self),
    draw-key-notes(self),
    draw-name(self),
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

/// Generates a piano chord.
///
/// - keys (string): Keys chord notes from *C1* to *E3* (Depends on your layout). *Optional*.
/// #parbreak() Example: ```js "C1, E1b, G1"``` (Cm chord)
///
/// - layout (string): Sets the layout and size of the piano, ```js "C"```, ```js "2C"```, ```js "F"```, ```js "2F"```. *Optional*.
///  - ```js "C"```: the piano layout starts from key *C1* to *E2* (17 keys).
///  - ```js "2C"```: the piano layout starts from key *C1* to *B2* (24 keys, two octaves).
///  - ```js "F"```: the piano layout starts from key *F1* to *B2* (19 keys).
///  - ```js "2F"```: the piano layout stars from key *F1* to *E3* (24 keys, two octaves).
///
/// - fill (color): Sets the fill color of the pressed key. *Optional*.
///
/// - size (length): Sets the size. The default value is set to the chord name's font size. *Optional*.
///
/// - style (string): Sets the piano style. *Optional*.
///  - ```js "rect```: piano with rect angles.
///  - ```js "rounded```: piano with rounded angles.
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
#let piano-chord(
  keys: "",
  layout: "C",
  fill: gray,
  size: 12pt,
  style: "rect",
  position: "bottom",
  font: "Linux Libertine",
  background: rgb(0, 0, 0, 0),
  name
) = {
  assert.eq(type(keys), str)
  assert.eq(type(fill), color)
  assert.eq(type(size), length)
  assert(upper(layout) in ("C", "2C", "F", "2F"), message: "`layout` must to be \"C\", \"2C\", \"F\" or \"2F\"")
  assert(style in ("rect", "rounded"), message: "`style` must to be \"rect\" or \"rounded\"")
  assert(type(name) in (str, content), message: "type of `name` must to be `str` or `content`")

  set text(font: font)

  let scale = size-to-scale(size, 12pt)
  let step = 7.5pt
  let layout = upper(layout)
  let white-keys-amount = white-keys-amount-from-layout(layout)
  let black-keys-index = black-keys-index-from-layout(layout)
  let piano-limits = piano-limits-from-layout(layout)
  let keys = parse-input-string(keys)

  let self = (
    white-keys: (
      width: step * scale,
      height: 25pt * scale,
      amount: white-keys-amount,
    ),
    black-keys: (
      width: (step / 3) * scale * 2,
      height: 17pt * scale,
      shift: 1pt * scale,             // small shifting of the black-keys
      left: black-keys-index.left,    // black-keys index with left shift
      mid: black-keys-index.mid,      // black-keys index without shift
      right: black-keys-index.right,  // black-keys index with right shift
    ),
    piano: (
      width: white-keys-amount * step * scale,
      height: 25pt * scale
    ),
    tabs: (
      white-keys-index: keys-to-array-index(white-keys-dict, keys),
      black-keys-index: keys-to-array-index(black-keys-dict, keys)
    ),
    position: position,
    background: background,
    round: 1pt * scale,
    stroke: black + 0.5pt * scale,
    top-border-height: 1.1pt * scale,
    keys: keys,
    scale: scale,
    limit: piano-limits,
    style: style,
    fill: fill,
    name: name,
  )

  render(self)
}
