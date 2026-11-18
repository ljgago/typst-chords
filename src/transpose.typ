// Transposition module for chordx
// Handles key-to-key, Nashville Number System, and semitone chord transposition.

#let sharp-notes = ("C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B")
#let flat-notes  = ("C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B")

// Pitch class mapping for chromatic note spelling
#let note-to-semitone = (
  "B#": 0, "C": 0, "Dbb": 0,
  "C#": 1, "Db": 1, "Bx": 1,
  "D": 2, "C##": 2, "Cx": 2, "Ebb": 2,
  "D#": 3, "Eb": 3,
  "E": 4, "Dx": 4, "Fb": 4,
  "E#": 5, "F": 5, "Gbb": 5,
  "F#": 6, "Gb": 6, "Ex": 6,
  "G": 7, "Fx": 7, "Abb": 7,
  "G#": 8, "Ab": 8,
  "A": 9, "Gx": 9, "Bbb": 9,
  "A#": 10, "Bb": 10,
  "B": 11, "Ax": 11, "Cb": 11,
)

// Diatonic scales for all 15 major keys
#let major-scales = (
  "C":  ("C", "D", "E", "F", "G", "A", "B"),
  "G":  ("G", "A", "B", "C", "D", "E", "F#"),
  "D":  ("D", "E", "F#", "G", "A", "B", "C#"),
  "A":  ("A", "B", "C#", "D", "E", "F#", "G#"),
  "E":  ("E", "F#", "G#", "A", "B", "C#", "D#"),
  "B":  ("B", "C#", "D#", "E", "F#", "G#", "A#"),
  "F#": ("F#", "G#", "A#", "B", "C#", "D#", "E#"),
  "C#": ("C#", "D#", "E#", "F#", "G#", "A#", "B#"),
  "F":  ("F", "G", "A", "Bb", "C", "D", "E"),
  "Bb": ("Bb", "C", "D", "Eb", "F", "G", "A"),
  "Eb": ("Eb", "F", "G", "Ab", "Bb", "C", "D"),
  "Ab": ("Ab", "Bb", "C", "Db", "Eb", "F", "G"),
  "Db": ("Db", "Eb", "F", "Gb", "Ab", "Bb", "C"),
  "Gb": ("Gb", "Ab", "Bb", "Cb", "Db", "Eb", "F"),
  "Cb": ("Cb", "Db", "Eb", "Fb", "Gb", "Ab", "Bb"),
)

// Diatonic scales for all 15 natural minor keys
#let minor-scales = (
  "Am":  ("A", "B", "C", "D", "E", "F", "G"),
  "Em":  ("E", "F#", "G", "A", "B", "C", "D"),
  "Bm":  ("B", "C#", "D", "E", "F#", "G", "A"),
  "F#m": ("F#", "G#", "A", "B", "C#", "D", "E"),
  "C#m": ("C#", "D#", "E", "F#", "G#", "A", "B"),
  "G#m": ("G#", "A#", "B", "C#", "D#", "E", "F#"),
  "D#m": ("D#", "E#", "F#", "G#", "A#", "B", "C#"),
  "A#m": ("A#", "B#", "C#", "D#", "E#", "F#", "G#"),
  "Dm":  ("D", "E", "F", "G", "A", "Bb", "C"),
  "Gm":  ("G", "A", "Bb", "C", "D", "Eb", "F"),
  "Cm":  ("C", "D", "Eb", "F", "G", "Ab", "Bb"),
  "Fm":  ("F", "G", "Ab", "Bb", "C", "Db", "Eb"),
  "Bbm": ("Bb", "C", "Db", "Eb", "F", "Gb", "Ab"),
  "Ebm": ("Eb", "F", "Gb", "Ab", "Bb", "Cb", "Db"),
  "Abm": ("Ab", "Bb", "Cb", "Db", "Eb", "Fb", "Gb"),
)

// Major scale semitone offsets from tonic for degrees 1..7:
// 1: 0, 2: 2, 3: 4, 4: 5, 5: 7, 6: 9, 7: 11
#let major-degree-semitones = (0, 2, 4, 5, 7, 9, 11)

// Natural minor scale semitone offsets from tonic for degrees 1..7:
// 1: 0, 2: 2, 3: 3, 4: 5, 5: 7, 6: 8, 7: 10
#let minor-degree-semitones = (0, 2, 3, 5, 7, 8, 10)

// Normalizes accidental characters in a string
#let normalize-accidentals(s) = {
  s.replace(str(sym.sharp), "#").replace(str(sym.flat), "b")
}

// Parses and normalizes key strings (e.g. "C", "Am", "F# minor", "Nashville")
#let parse-scale-key(key-input) = {
  if key-input == none or key-input == auto {
    return none
  }
  assert(type(key-input) == str, message: "key must be a string, got " + repr(type(key-input)))
  let clean = key-input.trim()
  let lower-clean = lower(clean)
  if lower-clean in ("nashville", "nns", "numbers", "number") {
    return (
      is-nashville: true,
      name: "Nashville",
    )
  }

  clean = normalize-accidentals(clean)

  let is-minor = false
  if clean.ends-with(" minor") or clean.ends-with(" Minor") {
    clean = clean.slice(0, -6).trim()
    is-minor = true
  } else if clean.ends-with(" major") or clean.ends-with(" Major") {
    clean = clean.slice(0, -6).trim()
    is-minor = false
  } else if clean.ends-with("min") and clean.len() > 3 {
    clean = clean.slice(0, -3).trim()
    is-minor = true
  } else if clean.ends-with("maj") and clean.len() > 3 {
    clean = clean.slice(0, -3).trim()
    is-minor = false
  } else if clean.ends-with("m") and clean.len() > 1 {
    clean = clean.slice(0, -1).trim()
    is-minor = true
  }

  let root = upper(clean.slice(0, 1))
  let acc = if clean.len() > 1 { clean.slice(1) } else { "" }
  let tonic = root + acc

  let key-lookup = if is-minor { tonic + "m" } else { tonic }
  let scale = none
  if is-minor {
    if key-lookup in minor-scales {
      scale = minor-scales.at(key-lookup)
    }
  } else {
    if key-lookup in major-scales {
      scale = major-scales.at(key-lookup)
    }
  }

  assert(tonic in note-to-semitone, message: "unknown key or note: " + key-input)

  let semitone = note-to-semitone.at(tonic)
  let prefer-accidental = "sharp"
  if key-lookup in ("F", "Bb", "Eb", "Ab", "Db", "Gb", "Cb", "Dm", "Gm", "Cm", "Fm", "Bbm", "Ebm", "Abm") {
    prefer-accidental = "flat"
  }

  return (
    is-nashville: false,
    name: key-lookup,
    tonic: tonic,
    mode: if is-minor { "minor" } else { "major" },
    semitone: semitone,
    scale: scale,
    accidental: prefer-accidental,
  )
}

// Parses a chord string into its constituent parts:
// (is-nashville: bool, root: str, acc: str, degree: int, suffix: str, bass: str, bass-is-nashville: bool, bass-acc: str, bass-degree: int)
#let parse-chord-string(chord-str) = {
  let s = normalize-accidentals(chord-str.trim())
  let slash-idx = s.position("/")
  let main-str = s
  let bass-str = none
  if slash-idx != none {
    main-str = s.slice(0, slash-idx).trim()
    bass-str = s.slice(slash-idx + 1).trim()
  }

  // Check if main-str is Nashville (e.g. "1", "6m", "b7", "#4m7b5", "2-", "57")
  let nash-match = main-str.match(regex("^([#b]?)([1-7])(.*)$"))
  let main-is-nash = false
  let root = ""
  let acc = ""
  let degree = 0
  let suffix = ""

  if nash-match != none {
    main-is-nash = true
    acc = nash-match.captures.at(0)
    degree = int(nash-match.captures.at(1))
    suffix = nash-match.captures.at(2)
    root = acc + str(degree)
  } else {
    // Standard chord: note [A-G] + optional accidental (#, b, ##, bb, x) + suffix
    let note-match = main-str.match(regex("^([A-G])(##|bb|x|[#b])?(.*)$"))
    if note-match != none {
      let letter = note-match.captures.at(0)
      acc = if note-match.captures.at(1) != none { note-match.captures.at(1) } else { "" }
      root = letter + acc
      suffix = note-match.captures.at(2)
    } else {
      // Unrecognized chord format, return as unparsed
      return (
        recognized: false,
        raw: chord-str,
      )
    }
  }

  // Parse bass part if present
  let bass-is-nash = false
  let bass-acc = ""
  let bass-degree = 0
  let bass-root = ""

  if bass-str != none and bass-str.len() > 0 {
    let b-nash-match = bass-str.match(regex("^([#b]?)([1-7])$"))
    if b-nash-match != none {
      bass-is-nash = true
      bass-acc = b-nash-match.captures.at(0)
      bass-degree = int(b-nash-match.captures.at(1))
      bass-root = bass-acc + str(bass-degree)
    } else {
      let b-note-match = bass-str.match(regex("^([A-G])(##|bb|x|[#b])?$"))
      if b-note-match != none {
        let b-letter = b-note-match.captures.at(0)
        bass-acc = if b-note-match.captures.at(1) != none { b-note-match.captures.at(1) } else { "" }
        bass-root = b-letter + bass-acc
      } else {
        bass-root = bass-str
      }
    }
  }

  return (
    recognized: true,
    is-nashville: main-is-nash,
    root: root,
    acc: acc,
    degree: degree,
    suffix: suffix,
    bass: bass-root,
    bass-is-nashville: bass-is-nash,
    bass-acc: bass-acc,
    bass-degree: bass-degree,
  )
}

// Spells a semitone pitch class in a target key
#let spell-semitone(pitch, target-key, accidental-pref) = {
  let p = calc.rem(pitch + 120, 12)
  if target-key != none and target-key.scale != none {
    for note in target-key.scale {
      if note in note-to-semitone and note-to-semitone.at(note) == p {
        return note
      }
    }
  }
  let pref = "sharp"
  if accidental-pref in ("sharp", "flat") {
    pref = accidental-pref
  } else if target-key != none and "accidental" in target-key {
    pref = target-key.accidental
  }
  if pref == "sharp" {
    sharp-notes.at(p)
  } else {
    flat-notes.at(p)
  }
}

// Transposes a note from one standard key to another, or by a semitone amount
#let transpose-note-to-key(note, from-key, to-key, amount: 0, accidental-pref: "sharp") = {
  let clean-note = normalize-accidentals(note)
  if clean-note not in note-to-semitone {
    return note
  }

  // Key-to-key transposition
  if from-key != none and to-key != none and not from-key.is-nashville and not to-key.is-nashville {
    // Check if diatonic in from-key
    if from-key.scale != none and to-key.scale != none and from-key.mode == to-key.mode and clean-note in from-key.scale {
      let idx = from-key.scale.position(x => x == clean-note)
      if idx != none {
        return to-key.scale.at(idx)
      }
    }

    // Otherwise transpose by semitone difference
    let delta = calc.rem(to-key.semitone - from-key.semitone + 120, 12)
    let cur-pitch = note-to-semitone.at(clean-note)
    let target-pitch = calc.rem(cur-pitch + delta, 12)
    return spell-semitone(target-pitch, to-key, accidental-pref)
  }

  // Pure semitone transposition
  let cur-pitch = note-to-semitone.at(clean-note)
  let target-pitch = calc.rem(cur-pitch + amount + 120, 12)
  return spell-semitone(target-pitch, to-key, accidental-pref)
}

// Converts a note in a key to Nashville notation degree
#let note-to-nashville(note, from-key, accidental-pref: "sharp") = {
  let clean-note = normalize-accidentals(note)
  if clean-note not in note-to-semitone or from-key == none or from-key.is-nashville {
    return note
  }

  let tonic-semi = from-key.semitone
  let note-semi = note-to-semitone.at(clean-note)
  let offset = calc.rem(note-semi - tonic-semi + 120, 12)

  // Diatonic check in major key
  if from-key.mode == "major" and from-key.scale != none and clean-note in from-key.scale {
    let idx = from-key.scale.position(x => x == clean-note)
    if idx != none {
      return str(idx + 1)
    }
  }

  // Chromatic/diatonic mapping relative to major tonic
  // 0: 1, 1: b2, 2: 2, 3: b3, 4: 3, 5: 4, 6: #4 (or b5), 7: 5, 8: b6, 9: 6, 10: b7, 11: 7
  let pref = from-key.accidental
  if accidental-pref in ("sharp", "flat") {
    pref = accidental-pref
  }

  if offset == 0 { "1" }
  else if offset == 1 { if accidental-pref == "sharp" { "#1" } else { "b2" } }
  else if offset == 2 { "2" }
  else if offset == 3 { "b3" }
  else if offset == 4 { "3" }
  else if offset == 5 { "4" }
  else if offset == 6 { if accidental-pref == "flat" { "b5" } else { "#4" } }
  else if offset == 7 { "5" }
  else if offset == 8 { if accidental-pref == "sharp" and from-key.mode != "minor" { "#5" } else { "b6" } }
  else if offset == 9 { "6" }
  else if offset == 10 { "b7" }
  else if offset == 11 { "7" }
  else { str(offset) }
}

// Converts a Nashville degree to a note in the target key
#let nashville-to-note(deg-acc, deg-num, to-key, accidental-pref: "sharp") = {
  if to-key == none or to-key.is-nashville {
    return deg-acc + str(deg-num)
  }

  // Base note from scale degree
  if to-key.scale != none and deg-num >= 1 and deg-num <= 7 {
    let base-note = to-key.scale.at(deg-num - 1)
    if deg-acc == "" {
      return base-note
    }

    let base-pitch = note-to-semitone.at(base-note)
    let alt = 0
    if deg-acc == "#" { alt = 1 }
    else if deg-acc == "b" { alt = -1 }

    let target-pitch = calc.rem(base-pitch + alt + 120, 12)
    let pref = if deg-acc == "b" { "flat" } else if deg-acc == "#" { "sharp" } else { accidental-pref }
    return spell-semitone(target-pitch, to-key, pref)
  }

  // Fallback using major interval offsets from tonic
  let semitone-offset = major-degree-semitones.at(deg-num - 1)
  if deg-acc == "#" { semitone-offset += 1 }
  else if deg-acc == "b" { semitone-offset -= 1 }

  let target-pitch = calc.rem(to-key.semitone + semitone-offset + 120, 12)
  let pref = if deg-acc == "b" { "flat" } else if deg-acc == "#" { "sharp" } else { accidental-pref }
  return spell-semitone(target-pitch, to-key, pref)
}

// Transposes a single parsed chord string
#let transpose-chord-string(
  chord-str,
  from: none,
  to: none,
  amount: 0,
  accidental: "sharp",
  sharp-symbol: "#",
  flat-symbol: "b",
) = {
  let parsed-from = parse-scale-key(from)
  let parsed-to = parse-scale-key(to)

  let chord-info = parse-chord-string(chord-str)
  if not chord-info.recognized {
    return chord-str
  }

  let new-root = ""
  let new-suffix = chord-info.suffix
  let new-bass = none

  // Case 1: Input is Nashville notation
  if chord-info.is-nashville or (parsed-from != none and parsed-from.is-nashville) {
    if parsed-to != none and not parsed-to.is-nashville {
      // Nashville to target key
      new-root = nashville-to-note(chord-info.acc, chord-info.degree, parsed-to, accidental-pref: accidental)
      if new-suffix == "-" {
        new-suffix = "m"
      }
      if chord-info.bass != none and chord-info.bass.len() > 0 {
        if chord-info.bass-is-nashville {
          new-bass = nashville-to-note(chord-info.bass-acc, chord-info.bass-degree, parsed-to, accidental-pref: accidental)
        } else {
          new-bass = chord-info.bass
        }
      }
    } else {
      // Nashville to Nashville: keep or transpose degree
      new-root = chord-info.root
      new-bass = chord-info.bass
    }
  }
  // Case 2: Output is Nashville notation
  else if parsed-to != none and parsed-to.is-nashville {
    let eff-from = if parsed-from != none { parsed-from } else { parse-scale-key("C") }
    new-root = note-to-nashville(chord-info.root, eff-from, accidental-pref: accidental)
    if chord-info.bass != none and chord-info.bass.len() > 0 {
      new-bass = note-to-nashville(chord-info.bass, eff-from, accidental-pref: accidental)
    }
  }
  // Case 3: Standard note-to-note transposition (key-to-key or semitone)
  else {
    new-root = transpose-note-to-key(chord-info.root, parsed-from, parsed-to, amount: amount, accidental-pref: accidental)
    if chord-info.bass != none and chord-info.bass.len() > 0 {
      new-bass = transpose-note-to-key(chord-info.bass, parsed-from, parsed-to, amount: amount, accidental-pref: accidental)
    }
  }

  // Construct final transposed chord string
  let result = new-root + new-suffix
  if new-bass != none and new-bass.len() > 0 {
    result += "/" + new-bass
  }

  // Replace sharp and flat symbols according to preference
  if sharp-symbol != "#" {
    result = result.replace("#", str(sharp-symbol))
  }
  if flat-symbol != "b" {
    result = result.replace("b", str(flat-symbol))
  }

  return result
}

// Parses content or strings into clusters/parts, transposing chords while preserving markup
#let join-content-strings(acc, item) = {
  if type(item) == str and acc.len() > 0 and type(acc.last()) == str {
    acc.slice(0, -1) + (acc.last() + item,)
  } else {
    acc + (item,)
  }
}

#let parse-chord-content-array(data) = {
  if type(data) == str {
    return (data,)
  }
  if data.has("text") {
    return (data.at("text"),)
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
    let res = ()
    for item in data.at("children") {
      res += parse-chord-content-array(item)
    }
    return res
  }
  return (data,)
}

/// Transposes a chord from one key to another, to/from Nashville notation, or by semitones.
/// Supports normal chords, complex qualities (e.g. `m7b5`, `maj7`), and slash chords (e.g. `C\#/A`, `1/3`).
/// -> str | content
#let transpose-chord(
  /// Chord name to transpose. *Required*.
  /// -> str | content
  name,

  /// Transposition arguments: `from`, `to`, `amount`, `accidental`, `sharp-symbol`, `flat-symbol`.
  /// -> auto
  ..args,
) = {
  let pos = args.pos()
  let named = args.named()

  let amount = 0
  let from = none
  let to = none
  let accidental = "sharp"
  let sharp-symbol = "#"
  let flat-symbol = "b"

  if "amount" in named { amount = named.at("amount") }
  if "from" in named { from = named.at("from") }
  if "to" in named { to = named.at("to") }
  if "from-key" in named and named.at("from-key") != auto { from = named.at("from-key") }
  if "to-key" in named and named.at("to-key") != auto { to = named.at("to-key") }
  if "accidental" in named { accidental = named.at("accidental") }
  if "accidental-prefer" in named { accidental = named.at("accidental-prefer") }
  if "sharp-symbol" in named { sharp-symbol = named.at("sharp-symbol") }
  if "flat-symbol" in named { flat-symbol = named.at("flat-symbol") }

  if pos.len() > 0 {
    amount = pos.at(0)
  }
  if pos.len() > 1 {
    if type(pos.at(1)) == str {
      accidental = pos.at(1)
    }
  }
  if pos.len() > 2 {
    sharp-symbol = pos.at(2)
  }
  if pos.len() > 3 {
    flat-symbol = pos.at(3)
  }
  // If no transposition configured, return name directly
  let from-k = parse-scale-key(from)
  let to-k = parse-scale-key(to)

  if from-k == none and to-k == none and amount == 0 {
    return name
  }

  if from-k != none and to-k != none and not from-k.is-nashville and not to-k.is-nashville and from-k.name == to-k.name and amount == 0 {
    return name
  }

  // If input is a string
  if type(name) == str {
    return transpose-chord-string(
      name,
      from: from,
      to: to,
      amount: amount,
      accidental: accidental,
      sharp-symbol: sharp-symbol,
      flat-symbol: flat-symbol,
    )
  }

  // For content input: extract parts and fold consecutive strings
  let parts = parse-chord-content-array(name)
    .fold((), (acc, item) => join-content-strings(acc, item))

  if parts.len() == 1 and type(parts.at(0)) == str {
    let res = transpose-chord-string(
      parts.at(0),
      from: from,
      to: to,
      amount: amount,
      accidental: accidental,
      sharp-symbol: sharp-symbol,
      flat-symbol: flat-symbol,
    )
    return text(res)
  }

  // Complex content with markup (e.g. superscripts, subscripts)
  let result = ()
  for item in parts {
    if type(item) == str {
      if item.starts-with("/") and item.len() > 1 {
        let bass-only = item.slice(1)
        let tr-bass = transpose-chord-string(
          bass-only,
          from: from,
          to: to,
          amount: amount,
          accidental: accidental,
          sharp-symbol: sharp-symbol,
          flat-symbol: flat-symbol,
        )
        result.push(text("/" + tr-bass))
      } else {
        let tr = transpose-chord-string(
          item,
          from: from,
          to: to,
          amount: amount,
          accidental: accidental,
          sharp-symbol: sharp-symbol,
          flat-symbol: flat-symbol,
        )
        result.push(text(tr))
      }
    } else {
      result.push(item)
    }
  }

  return result.join()
}

// Global document-wide state for chord transposition
#let chord-transposition-state = state("chordx-transposition", (
  from: none,
  to: none,
  amount: 0,
  accidental: "sharp",
  sharp-symbol: "#",
  flat-symbol: "b",
))

/// Configures chord transposition document-wide or within a show rule.
/// Supports basic major and minor scales, semitone offsets, and Nashville Number System.
/// -> content
#let set-transpose(
  /// Source key or scale (e.g. "C", "Am", "Nashville"). *Optional*.
  /// -> str | none
  from: none,

  /// Target key or scale (e.g. "G", "F\#m", "Nashville"). *Optional*.
  /// -> str | none
  to: none,

  /// Number of semitones to transpose (if transposing by interval instead of key). *Optional*.
  /// -> int | none
  amount: none,

  /// Preferred accidental for chromatic notes ("sharp" or "flat"). *Optional*.
  /// -> str | auto
  accidental: auto,

  /// Custom sharp symbol (e.g. "\#" or sym.sharp). *Optional*.
  /// -> str | symbol | auto
  sharp-symbol: auto,

  /// Custom flat symbol (e.g. "b" or sym.flat). *Optional*.
  /// -> str | symbol | auto
  flat-symbol: auto,

  /// Optional body when used as a show rule or block wrapper. *Optional*.
  /// -> content | none
  body: none,
) = {
  let update = chord-transposition-state.update(old => (
    from: if from != none { from } else { old.from },
    to: if to != none { to } else { old.to },
    amount: if amount != none { amount } else { old.amount },
    accidental: if accidental != auto { accidental } else { old.accidental },
    sharp-symbol: if sharp-symbol != auto { sharp-symbol } else { old.sharp-symbol },
    flat-symbol: if flat-symbol != auto { flat-symbol } else { old.flat-symbol },
  ))
  if body != none {
    update + body
  } else {
    update
  }
}

/// Alias for `set-transpose`. Configures chord transposition document-wide.
/// -> content
#let set-chord-transposition = set-transpose
