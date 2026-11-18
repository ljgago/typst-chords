#import "../lib.typ": (
  single-chord,
  stanza-chord,
  transpose-chord,
  set-transpose,
  set-chord-transposition,
  chord-transposition-state,
)

#set document(date: none)
#set page(width: auto, height: auto, margin: 10pt)
#set text(14pt)

// Assert helper
#let assert-eq(actual, expected, desc) = {
  assert(actual == expected, message: desc + ": expected '" + repr(expected) + "', got '" + repr(actual) + "'")
}

// -------------------------------------------------------------------------------------------------
// Unit tests for transposition engine
// -------------------------------------------------------------------------------------------------

// 1. Normal chords
#assert-eq(transpose-chord("C", from: "C", to: "G"), "G", "C from C to G")
#assert-eq(transpose-chord("E", from: "C", to: "G"), "B", "E from C to G")
#assert-eq(transpose-chord("F", from: "C", to: "G"), "C", "F from C to G")
#assert-eq(transpose-chord("C", from: "C", to: "D"), "D", "C from C to D")

// 2. Complex chords
#assert-eq(transpose-chord("C#", from: "C", to: "D"), "D#", "C# from C to D")
#assert-eq(transpose-chord("Dm", from: "C", to: "G"), "Am", "Dm from C to G")
#assert-eq(transpose-chord("E#m", from: "C#", to: "D"), "F#m", "E#m from C# to D")
#assert-eq(transpose-chord("E#m7b5", from: "C#", to: "D"), "F#m7b5", "E#m7b5 from C# to D")
#assert-eq(transpose-chord("Bbmaj7", from: "F", to: "G"), "Cmaj7", "Bbmaj7 from F to G")
#assert-eq(transpose-chord("Asus4", from: "A", to: "D"), "Dsus4", "Asus4 from A to D")

// 3. Slash chords
#assert-eq(transpose-chord("C#/A", from: "C", to: "G"), "G#/E", "C#/A from C to G")
#assert-eq(transpose-chord("C#/A", from: "A", to: "D"), "F#/D", "C#/A from A to D")
#assert-eq(transpose-chord("E#m/G", from: "C#", to: "D"), "F#m/G#", "E#m/G from C# to D")
#assert-eq(transpose-chord("G/B", from: "G", to: "C"), "C/E", "G/B from G to C")
#assert-eq(transpose-chord("1/3", from: "Nashville", to: "G"), "G/B", "1/3 to G")
#assert-eq(transpose-chord("5/7", from: "Nashville", to: "G"), "D/F#", "5/7 to G")
#assert-eq(transpose-chord("G/B", from: "G", to: "Nashville"), "1/3", "G/B to Nash")
#assert-eq(transpose-chord("D/F#", from: "G", to: "Nashville"), "5/7", "D/F# to Nash")
#assert-eq(transpose-chord("C#/A", from: "A", to: "Nashville"), "3/1", "C#/A to Nash")

// 4. Nashville notation in and out
#assert-eq(transpose-chord("1", from: "Nashville", to: "C"), "C", "Nash 1 to C")
#assert-eq(transpose-chord("2m", from: "Nashville", to: "C"), "Dm", "Nash 2m to C")
#assert-eq(transpose-chord("3m", from: "Nashville", to: "G"), "Bm", "Nash 3m to G")
#assert-eq(transpose-chord("4", from: "Nashville", to: "F"), "Bb", "Nash 4 to F")
#assert-eq(transpose-chord("5", from: "Nashville", to: "D"), "A", "Nash 5 to D")
#assert-eq(transpose-chord("6m", from: "Nashville", to: "G"), "Em", "Nash 6m to G")
#assert-eq(transpose-chord("7dim", from: "Nashville", to: "C"), "Bdim", "Nash 7dim to C")
#assert-eq(transpose-chord("b7", from: "Nashville", to: "C"), "Bb", "Nash b7 to C")
#assert-eq(transpose-chord("b7", from: "Nashville", to: "G"), "F", "Nash b7 to G")
#assert-eq(transpose-chord("6-", from: "Nashville", to: "G"), "Em", "Nash 6- to G")

#assert-eq(transpose-chord("C", from: "C", to: "Nashville"), "1", "C to 1")
#assert-eq(transpose-chord("Dm", from: "C", to: "Nashville"), "2m", "Dm to 2m")
#assert-eq(transpose-chord("Em", from: "C", to: "Nashville"), "3m", "Em to 3m")
#assert-eq(transpose-chord("F", from: "C", to: "Nashville"), "4", "F to 4")
#assert-eq(transpose-chord("G", from: "C", to: "Nashville"), "5", "G to 5")
#assert-eq(transpose-chord("Am", from: "C", to: "Nashville"), "6m", "Am to 6m")
#assert-eq(transpose-chord("Bdim", from: "C", to: "Nashville"), "7dim", "Bdim to 7dim")
#assert-eq(transpose-chord("Bb", from: "C", to: "Nashville"), "b7", "Bb to b7")

// 5. Minor scales
#assert-eq(transpose-chord("Am", from: "Am", to: "Em"), "Em", "Am to Em")
#assert-eq(transpose-chord("Dm", from: "Am", to: "Em"), "Am", "Dm to Am")
#assert-eq(transpose-chord("C", from: "Am", to: "Em"), "G", "C to G")
#assert-eq(transpose-chord("Am/G", from: "Am", to: "Em"), "Em/D", "Am/G to Em")
#assert-eq(transpose-chord("Am", from: "Am", to: "Nashville"), "1m", "Am to Nash")
#assert-eq(transpose-chord("Dm", from: "Am", to: "Nashville"), "4m", "Dm to Nash")
#assert-eq(transpose-chord("C", from: "Am", to: "Nashville"), "b3", "C to Nash")
#assert-eq(transpose-chord("F", from: "Am", to: "Nashville"), "b6", "F to Nash")
#assert-eq(transpose-chord("G", from: "Am", to: "Nashville"), "b7", "G to Nash")

// 6. All 15 Major Keys and 15 Minor Keys
#let major-keys = ("C", "G", "D", "A", "E", "B", "F#", "C#", "F", "Bb", "Eb", "Ab", "Db", "Gb", "Cb")
#for k in major-keys {
  assert-eq(transpose-chord("C", from: "C", to: k), k, "C to " + k)
  assert-eq(transpose-chord("1", from: "Nashville", to: k), k, "1 to " + k)
  assert-eq(transpose-chord(k, from: k, to: "Nashville"), "1", k + " to 1")
}

#let minor-keys = ("Am", "Em", "Bm", "F#m", "C#m", "G#m", "D#m", "A#m", "Dm", "Gm", "Cm", "Fm", "Bbm", "Ebm", "Abm")
#for k in minor-keys {
  assert-eq(transpose-chord("Am", from: "Am", to: k), k, "Am to " + k)
  assert-eq(transpose-chord("1m", from: "Nashville", to: k), k, "1m to " + k)
  assert-eq(transpose-chord(k, from: k, to: "Nashville"), "1m", k + " to 1m")
}

// 7. Semitone backward compatibility
#assert-eq(transpose-chord("C", amount: 1), "C#", "C + 1")
#assert-eq(transpose-chord("C", amount: -1, accidental: "flat"), "B", "C - 1")
#assert-eq(transpose-chord("C#/A", amount: 1), "D/A#", "C#/A + 1")
#assert-eq(transpose-chord("E#m7b5", amount: 1), "F#m7b5", "E#m7b5 + 1")

// -------------------------------------------------------------------------------------------------
// Visual rendering test cases
// -------------------------------------------------------------------------------------------------

#let chord1 = single-chord.with(
  font: "PT Sans",
  size: 12pt,
  inner-gap: 0.2em,
  outer-gap: 0.6em,
  weight: "semibold",
  background: silver,
  transpose: 1,
)

#let chord2 = single-chord.with(
  font: "PT Sans",
  size: 12pt,
  inner-gap: 0.2em,
  outer-gap: 0.6em,
  weight: "semibold",
  background: silver,
  accidental: "flat",
  flat-symbol: sym.flat,
  transpose: -1,
)

#let chord-key = single-chord.with(
  font: "PT Sans",
  size: 12pt,
  inner-gap: 0.2em,
  outer-gap: 0.6em,
  weight: "semibold",
  background: rgb("e6f4ea"),
  from: "C",
  to: "G",
)

#let chord-nash = single-chord.with(
  font: "PT Sans",
  size: 12pt,
  inner-gap: 0.2em,
  outer-gap: 0.6em,
  weight: "semibold",
  background: rgb("f3e8fd"),
  from: "Nashville",
  to: "D",
)

#rect(
  stroke: none,
  radius: 3pt,
  inset: (x: 10pt, y: 10pt),
  fill: white,
  [
    #chord1[Lorem][C][0] ipsum #chord1[dolor][D\#m][2] sit amet \
    #chord1[consectetur][Gbm7][5] adipiscing #chord1[elit.][B#super("9")][] \

    #chord2[Consectetur][D#sym.sharp m#super("+")][11] adipiscing elit #chord2[quisque][Asus4][2] \
    #chord2[*_faucibus_*][B#sub("sus4")][8] ex sapien #chord2[#underline("vitae.")][D][2] \

    #v(0.5em)
    #chord-key[Transposed][C][1] from #chord-key[C][Dm][1] to #chord-key[G][C\#/A][1] with #chord-key[slash][E\#m7b5][1] \
    #chord-nash[Nashville][1][1] numbers #chord-nash[in][4][1] action #chord-nash[rendered][1/3][1] in #chord-nash[D][5/7][1]
  ],
)
