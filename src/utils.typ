// Gets the relative scale from a size of length type
#let size-to-scale(size, default) = {
  let length-type = repr(size).match(regex("pt|mm|cm|in|em")).text

  if length-type == "em" {
    size.em
  } else {
    size / default
  }
}

// Gets the string from a content data
#let parse-content(content-data) = {
  if content-data.has("text") {
    return content-data.at("text").clusters()
  }
  if content-data.has("double") {
    return (content-data,)
  }
  if content-data.has("children") {
    for item in content-data.at("children") {
      parse-content(item)
    }
  }
  if content-data.has("body") {
    parse-content(content-data.at("body"))
  }
  if content-data.has("base") {
    parse-content(content-data.at("base"))
  }
  if content-data.has("equation") {
    parse-content(content-data.at("equation"))
  }
}

// Checks if the string contains only numbers
#let has-number(string) = {
  if string.trim().matches(regex("^\d+$")).len() != 0 {
    true
  } else {
    false
  }
}

// Parses different string inputs to array
//
// 123|234 == 1,2,3 | 2,3,4 => ((1,2,3), (2,3,4))
// "x32o1o" == x,3,2,o,1,o => ("x",3,2,"o",1,"o")
#let parse-input-string(string) = {
  let to-int-or-ignore(s) = {
    if s.matches(regex("^\d+$")).len() != 0 {int(s)} else {s}
  }

  string = string.trim().replace(regex("\s"), "")

  if string.contains("|") {
      string.split("|").map(parse-input-string)
  } else if string.contains(",") {
      string.split(",").map(to-int-or-ignore)
  } else {
      string.codepoints().map(to-int-or-ignore)
  }
}

// Draws a border with sharp corners
#let top-border-sharp(size, stroke, scale) = {
  place(
    dy: -size.height,
    rect(
      width: size.width,
      height: size.height,
      stroke: stroke,
      fill: black
    )
  )
}

// Draws a border with round corners
#let top-border-round(size, stroke, scale, radius) = {
  // radius
  let r = radius
  // Bézier control segment
  let n = 4 / 3 * r * calc.tan(90deg / 4)

  place(
    dy: r - size.height,
    curve(
      fill: black,
      stroke: stroke,
      curve.move((0pt, 0pt)),
      curve.cubic((0pt, -n), (r - n, -r), (r, -r), relative: true),
      curve.line((size.width - r * 2, 0pt), relative: true),
      curve.cubic((n , 0pt), (r, n), (r, r), relative: true),
      curve.line((0pt, size.height), relative: true),
      curve.cubic((0pt, -n), (-n , -r), (-r, -r), relative: true),
      curve.line((r * 2 - size.width, 0pt), relative: true),
      curve.cubic((-n, 0pt), (-r, n), (-r, r), relative: true),
      curve.line((0pt, -size.height), relative: true),
      curve.close()
    )
  )
}

#let total-bounds(b1, b2) = {
  let dx = calc.min(b1.dx, b2.dx)
  let dy = calc.min(b1.dy, b2.dy)

  return (
    dx: dx,
    dy: dy,
    width: calc.max(b1.dx + b1.width, b2.dx + b2.width) - dx,
    height: calc.max(b1.dy + b1.height, b2.dy + b2.height) - dy
  )
}

#let set-default-arguments(args) = {
  let size = 12pt
  let font = "Libertinus Serif"

  if "size" in args.keys() {
    (size,) = args
  }

  if "font" in args.keys() {
    (font,) = args
  }

  return (
    ..args,
    size: size,
    font: font
  )
}

// Note list with sharp and flat accidentals
#let sharp-notes = ("C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B")
#let flat-notes  = ("C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B")

// A dictionary with the full notes and their indices
#let full-notes-dict = (
  "C":  0, "B#": 0,
  "C#": 1, "Db": 1,
  "D":  2,
  "D#": 3, "Eb": 3,
  "E":  4, "Fb": 4,
  "F":  5, "E#": 5,
  "F#": 6, "Gb": 6,
  "G":  7,
  "G#": 8, "Ab": 8,
  "A":  9,
  "A#": 10, "Bb": 10,
  "B":  11, "Cb": 11,
)

// generate an array of characters of text fields preserving the order of other fields
// [D#super("9")/C] == children: ([D], super(body: [9]), [/C])
// return: ("D", super(body: [9]), "/", "C")
#let parse-content-array(data) = {
  if data.has("text") {
    return data.at("text").clusters()
  }
  if data.has("body") {
    return (data,)
  }
  if data.has("base") {
    return (data,)
  }
  if data.has("equation") {
    return (data,)
  }
  if data.has("children") {
    for item in data.at("children") {
      parse-content-array(item)
    }
  }
}

// the normal join does not
#let join-strings(acc, item) = {
  if type(item) == str and acc.len() > 0 and type(acc.last()) == str {
    acc.slice(0, -1) + (acc.last() + item,)
  } else {
    acc + (item,)
  }
}

#let transpose-note(name, amount, config) = {
  name.replace(
    regex("([A-G])(#|b|" + sym.sharp + "|" + sym.flat + ")?"),
    match => {
      let note = match.captures.at(0)
      let accidental = match.captures.at(1)

      if accidental == str(sym.sharp) { accidental = "#" }
      if accidental == str(sym.flat) { accidental = "b" }
      if accidental == none { accidental = "" }

      let full-note = note + accidental

      if full-note in full-notes-dict {
        let current = full-notes-dict.at(full-note)
        let new-value = calc.rem(current + amount + 12, 12)

        if config.accidental-prefer == "sharp" {
          return sharp-notes.at(new-value).replace("#", config.sharp-symbol)
        } else {
          return flat-notes.at(new-value).replace("b", config.flat-symbol)
        }
      }

      return match.text
    }
  )
}

#let transpose-or-ignore(item, amount, config) = {
  if type(item) == str {
    text(transpose-note(item, amount, config))
  } else {
    item
  }
}

// Transposes a chord using custom symbols and accidental preferences
#let transpose-chord(name, amount, accidental-prefer, sharp-symbol, flat-symbol) = {
  if amount == 0 {
    return name
  }

  let config = (
    accidental-prefer: accidental-prefer,
    sharp-symbol: sharp-symbol,
    flat-symbol: flat-symbol
  )

  parse-content-array(name)
    .fold((), (acc, item) => join-strings(acc, item))
    .map(item => transpose-or-ignore(item, amount, config))
    .join()
}
