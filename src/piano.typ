#import "./utils.typ": parse-input-string, top-border-normal, top-border-round
#let style-typ = style // name change

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

#let keys-to-array-index(dict, key-array) = {
  key-array
    .map(k => dict.at(k, default: none))
    .filter(k => k != none)
}

#let normalize-key-name(key) = {
  return key.replace(regex("\d+"), "").replace(regex("b$"), "\u{266D}")
}

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

#let white-keys-amount-from-layout(layout) = {
  return if layout == "C" {
    10
  } else if layout == "F" {
    11
  } else {
    14
  }
}

#let black-keys-index-from-layout(layout) = {
  return if layout in ("C", "2C") {
    ( left: (1, 4, 8, 11), mid: (5, 12), right: (2, 6, 9, 13) )
  } else {
    ( left: (4, 8, 11, 15), mid: (5, 12), right: (6, 9, 13, 16) )
  }
}


//
// Functions to render
//

//
// Draws the piano
//
#let draw-piano(self) = {
  // draws the white-keys
  for i in range(self.white-keys.amount) {
    let key-pressed = i + self.limit.min
    let fill-color = if key-pressed in self.tabs.white-keys-index {self.color} else {white}
    let x = i * self.white-keys.width

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
      dx: x,
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
    let fill-color = if key-pressed in self.tabs.black-keys-index {self.color} else {black}
    let base = i * self.white-keys.width - self.black-keys.width / 2
    let x = 0pt

    if key-pressed in self.black-keys.left {
      x = base - self.black-keys.shift
    } else if key-pressed in self.black-keys.mid {
      x = base
    } else if key-pressed in self.black-keys.right {
      x = base + self.black-keys.shift
    } else {
      continue
    }

    place(
      dx: x,
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

//
// Draws border top
//
#let draw-top-border(self) = {
  let size = (
    width: self.piano.width,
    height: 1.2pt * self.scale
  )

  if self.style == "normal" {
    top-border-normal(size, self.stroke, self.scale)
  } else {
    top-border-round(size, self.stroke, self.scale)
  }
}

//
// Draws tabs
//
#let draw-tabs(self) = {
  // draws tabs on white-keys chord
  for i in self.tabs.white-keys-index {
    if i < self.limit.min or i > self.limit.max {
      continue
    }

    let radius = 1.7pt * self.scale
    let x = (i - self.limit.min + 0.5) * self.white-keys.width - radius
    let y = self.piano.height - 4pt * self.scale - radius

    place(dx: x, dy: y, circle(radius: radius, stroke: none, fill: black))
  }

  // draws tabs on black-keys chord
  for i in self.tabs.black-keys-index {
    if i < self.limit.min or i > self.limit.max {
      continue
    }

    let radius = 1.7pt * self.scale
    let x = 0pt
    let y = self.black-keys.height - 3.5pt * self.scale - radius
    let base = (i - self.limit.min) * self.white-keys.width - radius

    if i in self.black-keys.left {
      x = base - self.black-keys.shift
    } else if i in self.black-keys.mid {
      x = base
    } else if i in self.black-keys.right {
      x = base + self.black-keys.shift
    } else {
      continue
    }

    place(dx: x, dy: y, circle(radius: radius, stroke: none, fill: black))
  }
}

//
// Draws notes
//
#let draw-key-notes(self) = {
  let gap-note = 1.8pt * self.scale

  // white-keys
  let white-keys = self.keys
    .map(key => (white-keys-dict.at(key, default: none), normalize-key-name(key)) )
    .filter(arr => arr.at(0) != none)

  for (i, key-name) in white-keys {
    if i < self.limit.min or i > self.limit.max {
      continue
    }

    let x = (i - self.limit.min + 0.5) * self.white-keys.width
    let y = self.piano.height + gap-note

    place(dx: x, dy: y, place(center + top, text(6pt * self.scale)[#key-name]),
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

    let x = 0pt
    let y = -(self.top-border-height + gap-note)
    let base = (i - self.limit.min) * self.white-keys.width

    if i in self.black-keys.left {
      x = base - self.black-keys.shift
    } else if i in self.black-keys.mid {
      x = base
    } else if i in self.black-keys.right {
      x = base + self.black-keys.shift
    } else {
      continue
    }

    place(dx: x, dy: y, place(center + bottom, text(6pt * self.scale)[#key-name]))
  }
}

//
// Draws the chord name
//
#let draw-name(self) = {
  let x = self.piano.width / 2
  let y = self.piano.height + self.vertical-gap-name
  place(dx: x, dy: y, place(center + horizon, text(12pt * self.scale)[#self.name]))
}

//
// Render
//
#let render(self) = {
  style-typ(styles => {
    let chord-name-size = measure(text(12pt * self.scale)[#self.name], styles)
    let note-name-size = measure(text(6pt * self.scale)[#self.keys], styles)

    let canvas = (
      width: calc.max(self.piano.width, chord-name-size.width),
      height: self.piano.height + self.vertical-gap-name + chord-name-size.height / 2 + note-name-size.height + self.top-border-height * 2,
      dx: calc.max((chord-name-size.width - self.piano.width) / 2, 0pt),
      dy: -(self.piano.height + self.vertical-gap-name + chord-name-size.height / 2)
    )

    box(
      width: canvas.width,
      height: canvas.height,
      place(
        left + bottom,
        dx: canvas.dx,
        dy: canvas.dy, {
          draw-piano(self)
          draw-top-border(self)
          draw-tabs(self)
          draw-key-notes(self)
          draw-name(self)
        }
      )
    )
  })
}

/// Return a new function with default parameters to generate piano chords.
///
/// - layout (string): Preset of layout and piano size, ```js "C"```, ```js "2C"```, ```js "F"```, ```js "2F"```. *Optional*.
///  - ```js "C"```: the piano layout starts from key *C1* to *E2* (17 keys).
///  - ```js "2C"```: the piano layout starts from key *C1* to *B2* (24 keys, two octaves).
///  - ```js "F"```: the piano layout starts from key *F1* to *B2* (19 keys).
///  - ```js "2F"```: the piano layout stars from key *F1* to *E3* (24 keys, two octaves).
/// - scale (integer, float): Presets the scale. *Optional*.
/// - color (color): Presets the pressed key color. *Optional*.
/// - style (string): Sets the piano style. *Optional*.
///  - ```js "normal```: piano with right angles.
///  - ```js "round```: piano with round angles.
/// - font (string): Text font name. *Optional*.
/// -> function
#let new-piano-chords(
  layout: "C",
  scale: 1,
  color: gray,
  style: "normal",
  font: "Linux Libertine"
) = {
  /// Is the returned function by *new-piano-chords*.
  ///
  /// - keys (string): Keys chord notes from *C1* to *E3*. *Optional*.
  /// #parbreak() Example: ```js "C1, E1b, G1"``` - (Cm chord)
  /// - color (color): the pressed key color. *Optional*.
  /// - layout (string): Preset of layout and piano size, ```js "C"```, ```js "2C"```, ```js "F"```, ```js "2F"```. *Optional*.
  ///  - ```js "C"```: the piano layout starts from key *C1* to *E2* (17 keys).
  ///  - ```js "2C"```: the piano layout starts from key *C1* to *B2* (24 keys, two octaves).
  ///  - ```js "F"```: the piano layout starts from key *F1* to *B2* (19 keys).
  ///  - ```js "2F"```: the piano layout stars from key *F1* to *E3* (24 keys, two octaves).
  /// - scale (integer, float): Sets the scale. *Optional*.
  /// - name (string, content): Shows the chord name. *Required*.
  /// -> content
  let piano-chord(
    keys: "",
    color: color,
    layout: layout,
    scale: scale,
    name
  ) = {
    assert.eq(type(keys), "string")
    assert.eq(type(color), "color")
    assert(type(scale) in ("integer", "float"), message: "type of `scale` must to be a \"integer\" or \"float\"")
    assert(upper(layout) in ("C", "2C", "F", "2F"), message: "`layout` must to be \"C\", \"2C\", \"F\" or \"2F\"")
    assert(style in ("normal", "round"), message: "`style` must to be \"normal\" or \"round\"")
    assert(type(name) in ("string", "content"), message: "type of `name` must to be \"string\" or \"content\"")

    set text(font: font)

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
      round: 1pt * scale,
      stroke: black + 0.5pt * scale,
      vertical-gap-name: 14pt * scale,
      top-border-height: 1.1pt * scale,
      keys: keys,
      scale: scale,
      limit: piano-limits,
      style: style,
      color: color,
      name: name,
    )

    render(self)
  }
  return piano-chord
}
