#import "@preview/tidy:0.4.3"
#import "assets/template.typ": design, custom

#set document(date: none)
#show link: underline

#show: design.with(
  title: "chordx",
  subtitle: "A package to write song lyrics with chord diagrams in Typst.",
  authors: (
    "Leonardo Javier Gago",
  ),
  date: "July 9, 2026",
  version: toml("../typst.toml").package.version,
  url: "https://github.com/ljgago/typst-chords"
)

#show raw.where(lang: "typ-lang"): it => {
  custom(raw(it.text, lang: "typ"))
}

#show raw.where(lang: "sh-lang"): it => {
  custom(raw(it.text, lang: "sh"))
}

#pagebreak()

#outline(indent: auto, depth: 3)

#pagebreak()

= Reference

== Chart Chords

#{
  let module = tidy.parse-module(read("../src/chart.typ"))
  tidy.show-module(module, sort-functions: none)
}

==== Example:

```typ-lang
#import "@preview/chordx:0.8.0": chart-chord

#let chart-chord-sharp = chart-chord.with(size: 18pt)
#let chart-chord-round = chart-chord.with(size: 18pt, design: "round")

// Design "sharp"
#chart-chord-sharp(tabs: "x32o1o", fingers: "n32n1n")[C]
#chart-chord-sharp(tabs: "ooo3", fingers: "ooo3")[C]

// Desigh "round" with position "bottom"
#chart-chord-round(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115", position: "bottom")[Cm]
#chart-chord-round(tabs: "onnn", fingers: "n111", capos: "313", position: "bottom")[Cm]

// Design "round" with background color in chord name
#chart-chord-round(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115", background: silver)[Cm]
#chart-chord-round(tabs: "onnn", fingers: "n111", capos: "313", background: silver)[Cm]
```

#{
  import "../lib.typ": chart-chord

  let chart-chord-sharp = chart-chord.with(size: 18pt)
  let chart-chord-round = chart-chord.with(size: 18pt, design: "round")

  v(1em)
  chart-chord-sharp(tabs: "x32o1o", fingers: "n32n1n")[C]
  h(2em)
  chart-chord-sharp(tabs: "ooo3", fingers: "ooo3")[C]
  h(1fr)
  chart-chord-round(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115", position: "bottom")[Cm]
  h(2em)
  chart-chord-round(tabs: "onnn", fingers: "n111", capos: "313", position: "bottom")[Cm]
  h(1fr)
  chart-chord-round(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115", background: silver)[Cm]
  h(2em)
  chart-chord-round(tabs: "onnn", fingers: "n111", capos: "313", background: silver)[Cm]
  v(2em)
}

==== Example:

```typ-lang
#import "@preview/chordx:0.8.0": chart-chord

// Shows only the chords with transpose = 2
#let transpose = 2

// Chords for transpose = 0
#let chart-chord-sharp-tr0 = chart-chord.with(
  size: 18pt,
  for-transpose: 0,
  show-transpose: transpose,
)
#let chart-chord-round-tr0 = chart-chord.with(
  design: "round",
  size: 1.5em,
  for-transpose: 0,
  show-transpose: transpose,
)

// Chords for transpose = 2
#let chart-chord-sharp-tr2 = chart-chord.with(
  size: 18pt,
  for-transpose: 2,
  show-transpose: transpose,
)
#let chart-chord-round-tr2 = chart-chord.with(
  design: "round",
  size: 1.5em,
  for-transpose: 2,
  show-transpose: transpose,
)

// Design "sharp"
#chart-chord-sharp-tr0(tabs: "x32o1o", fingers: "n32n1n")[C]
#chart-chord-sharp-tr2(tabs: "xxo232", fingers: "nnn132")[D]

#chart-chord-sharp-tr0(tabs: "ooo3", fingers: "ooo3")[C]
#chart-chord-sharp-tr2(tabs: "222o", fingers: "123o")[D]

// Desigh "round" with position "bottom"
#chart-chord-round-tr0(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115", position: "bottom")[Cm]
#chart-chord-round-tr2(tabs: "xxo231", fingers: "ooo231", position: "bottom")[Dm]

#chart-chord-round-tr0(tabs: "onnn", fingers: "n111", capos: "313", position: "bottom")[Cm]
#chart-chord-round-tr2(tabs: "221o", fingers: "231n", position: "bottom")[Dm]

// Design "round" with background color in chord name
#chart-chord-round-tr0(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115", background: silver)[Cm]
#chart-chord-round-tr2(tabs: "xxo231", fingers: "ooo231", background: silver)[Dm]

#chart-chord-round-tr0(tabs: "onnn", fingers: "n111", capos: "313", background: silver)[Cm]
#chart-chord-round-tr2(tabs: "221o", fingers: "231n", background: silver)[Dm]
```

#{
  import "../lib.typ": chart-chord

  let transpose = 2

  let chart-chord-sharp-tr0 = chart-chord.with(size: 18pt, for-transpose: 0, show-transpose: transpose)
  let chart-chord-round-tr0 = chart-chord.with(design: "round", size: 1.5em, for-transpose: 0, show-transpose: transpose)

  let chart-chord-sharp-tr2 = chart-chord.with(size: 18pt, for-transpose: 2, show-transpose: 2)
  let chart-chord-round-tr2 = chart-chord.with(design: "round", size: 1.5em, for-transpose: 2, show-transpose: transpose)

  v(1em)
  chart-chord-sharp-tr0(tabs: "x32o1o", fingers: "n32n1n")[C]
  chart-chord-sharp-tr2(tabs: "xxo232", fingers: "nnn132")[D]
  h(2em)
  chart-chord-sharp-tr0(tabs: "ooo3", fingers: "ooo3")[C]
  chart-chord-sharp-tr2(tabs: "222o", fingers: "123o")[D]
  h(1fr)
  chart-chord-round-tr0(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115", position: "bottom")[Cm]
  chart-chord-round-tr2(tabs: "xxo231", fingers: "ooo231", position: "bottom")[Dm]
  h(2em)
  chart-chord-round-tr0(tabs: "onnn", fingers: "n111", capos: "313", position: "bottom")[Cm]
  chart-chord-round-tr2(tabs: "221o", fingers: "231n", position: "bottom")[Dm]
  h(1fr)
  chart-chord-round-tr0(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115", background: silver)[Cm]
  chart-chord-round-tr2(tabs: "xxo231", fingers: "ooo231", background: silver)[Dm]
  h(2em)
  chart-chord-round-tr0(tabs: "onnn", fingers: "n111", capos: "313", background: silver)[Cm]
  chart-chord-round-tr2(tabs: "221o", fingers: "231n", background: silver)[Dm]
}


#pagebreak()

== Piano Chords

#{
  let module = tidy.parse-module(read("../src/piano.typ"))
  tidy.show-module(module, sort-functions: none)
}

==== Example:

```typ-lang
#import "@preview/chordx:0.8.0": piano-chord

#let piano-chord-sharp = piano-chord.with(layout: "F", size: 18pt)
#let piano-chord-round = piano-chord.with(layout: "F", size: 18pt, design: "round")

#piano-chord-sharp(keys: "B1, D2#, F2#", fill-key: blue)[B]
#piano-chord-round(keys: "B1, D2#, F2#", fill-key: yellow, position: "top")[B]
#piano-chord-round(keys: "B1, D2#, F2#", fill-key: red, background: silver)[B]
```

#{
  import "../lib.typ": piano-chord

  set align(center)

  let piano-chord-sharp = piano-chord.with(layout: "F", size: 18pt)
  let piano-chord-round = piano-chord.with(layout: "F", size: 18pt, design: "round")

  v(1em)
  piano-chord-sharp(keys: "B1, D2#, F2#", fill-key: blue)[B]
  h(1fr)
  piano-chord-round(keys: "B1, D2#, F2#", fill-key: yellow, position: "bottom")[B]
  h(1fr)
  piano-chord-round(keys: "B1, D2#, F2#", fill-key: red, background: silver)[B]
  v(2em)
}

==== Example:

```typ-lang
#import "@preview/chordx:0.8.0": piano-chord

// Shows only the chords with transpose = 2
#let transpose = 2

// Chords for transpose = 0
#let piano-chord-sharp-tr0 = piano-chord.with(
  layout: "F",
  size: 18pt,
  for-transpose: 0,
  show-transpose: transpose,
)
#let piano-chord-round-tr0 = piano-chord.with(
  layout: "F",
  size: 1.5em,
  design: "round",
  for-transpose: 0,
  show-transpose: transpose,
)

// Chords for transpose = 2
#let piano-chord-sharp-tr2 = piano-chord.with(
  layout: "F",
  size: 18pt,
  for-transpose: 2,
  show-transpose: transpose,
)
#let piano-chord-round-tr2 = piano-chord.with(
  layout: "F",
  size: 1.5em,
  design: "round",
  for-transpose: 2,
  show-transpose: transpose,
)

#piano-chord-sharp-tr0(keys: "B1, D2#, F2#", fill-key: blue)[B]
#piano-chord-sharp-tr2(keys: "C2#, F2, G2#", fill-key: blue)[C\#]

#piano-chord-round-tr0(keys: "B1, D2#, F2#", fill-key: yellow, position: "bottom")[B]
#piano-chord-round-tr2(keys: "C2#, F2, G2#", fill-key: yellow, position: "bottom")[C\#]

#piano-chord-round-tr0(keys: "B1, D2#, F2#", fill-key: red, background: silver)[B]
#piano-chord-round-tr2(keys: "C2#, F2, G2#", fill-key: red, background: silver)[C\#]
```

#{
  import "../lib.typ": piano-chord

  set align(center)

  let transpose = 2

  let piano-chord-sharp-tr0 = piano-chord.with(
    layout: "F",
    size: 18pt,
    for-transpose: 0,
    show-transpose: transpose,
  )
  let piano-chord-round-tr0 = piano-chord.with(
    layout: "F",
    size: 1.5em,
    design: "round",
    for-transpose: 0,
    show-transpose: transpose,
  )

  let piano-chord-sharp-tr2 = piano-chord.with(
    layout: "F",
    size: 18pt,
    for-transpose: 2,
    show-transpose: transpose,
  )
  let piano-chord-round-tr2 = piano-chord.with(
    layout: "F",
    size: 1.5em,
    design: "round",
    for-transpose: 2,
    show-transpose: transpose,
  )

  v(1em)
  piano-chord-sharp-tr0(keys: "B1, D2#, F2#", fill-key: blue)[B]
  piano-chord-sharp-tr2(keys: "C2#, F2, G2#", fill-key: blue)[C\#]
  h(1fr)
  piano-chord-round-tr0(keys: "B1, D2#, F2#", fill-key: yellow, position: "bottom")[B]
  piano-chord-round-tr2(keys: "C2#, F2, G2#", fill-key: yellow, position: "bottom")[C\#]
  h(1fr)
  piano-chord-round-tr0(keys: "B1, D2#, F2#", fill-key: red, background: silver)[B]
  piano-chord-round-tr2(keys: "C2#, F2, G2#", fill-key: red, background: silver)[C\#]
  v(2em)
}

#pagebreak()

== Single Chords

#{
  let module = tidy.parse-module(read("../src/single.typ"))
  tidy.show-module(module, sort-functions: none)
}

==== Example: <single-chord-example>

```typ-lang
#import "@preview/chordx:0.8.0": single-chord

#let chord = single-chord.with(
  font: "PT Sans",
  size: 10pt,
  weight: "semibold",
  background: silver,
)

#chord[Jingle][G][2] bells, jingle bells, jingle #chord[all][C][2] the #chord[way!][G][2] \
#chord[Oh][C][] what fun it #chord[is][G][] to ride \
In a #chord[one-horse][A7][2] open #chord[sleigh,][D7][3] hey!
```

#{
  import "../lib.typ": single-chord

  let chord = single-chord.with(
    font: "PT Sans",
    size: 10pt,
    weight: "semibold",
    background: silver
  )

  [
    #chord[Jingle][G][2] bells, jingle bells, jingle #chord[all][C][2] the #chord[way!][G][2] \
    #chord[Oh][C][] what fun it #chord[is][G][] to ride \
    In a #chord[one-horse][A7][2] open #chord[sleigh,][D7][3] hey! \ \
  ]
}

==== Example:

```typ-lang
// Chords with automatic transpose

#let chord = single-chord.with(
  font: "PT Sans",
  size: 10pt,
  weight: "semibold",
  background: silver,
  accidental: "sharp",
  sharp-symbol: "#",
  transpose: 1,
)

#chord[Jingle][G][2] bells, jingle bells, jingle #chord[all][C][2] the #chord[way!][G][2] \
#chord[Oh][C][] what fun it #chord[is][G][] to ride \
In a #chord[one-horse][A7][2] open #chord[sleigh,][D7][3] hey!
```

#{
  import "../src/single.typ": single-chord

  let chord = single-chord.with(
    font: "PT Sans",
    size: 10pt,
    weight: "semibold",
    background: silver,
    accidental: "sharp",
    sharp-symbol: "#",
    transpose: 1,
  )

  [
    #chord[Jingle][G][2] bells, jingle bells, jingle #chord[all][C][2] the #chord[way!][G][2] \
    #chord[Oh][C][] what fun it #chord[is][G][] to ride \
    In a #chord[one-horse][A7][2] open #chord[sleigh,][D7][3] hey! \ \
  ]
}


==== Example:

```typ-lang
// Chord name placed before the body with `position: 0`
// Chords with whitespace characters

#chord[Lorem][G][0] ipsum dolor #chord[sit][C][]. ~ #chord[~][G][] ~ #chord[~][C][] ~ #chord[~][G][] \
```

#{
  import "../src/single.typ": single-chord

  let chord = single-chord.with(
    font: "PT Sans",
    size: 10pt,
    weight: "semibold",
    background: silver,
  )

  [
    #chord[Lorem][G][0] ipsum dolor #chord[sit][C][] amet consectetur #chord[adipiscing][G][] elit. ~ #chord[~][G][] ~ #chord[~][C][] ~ #chord[~][G][]
  ]
}

#pagebreak()

== Chorded Stanza

#{
  let module = tidy.parse-module(read("../src/stanza.typ"))
  tidy.show-module(module, sort-functions: none)
}

==== Example
Consider above example on printing "Jingle Bells" with chords (#ref(<single-chord-example>)).
`stanza-chord` provides a more comfortable way of entering the song:

```typ-lang
#import "@preview/chordx:0.8.0": stanza-chord

#let stanza = stanza-chord.with(
  font: "PT Sans",
  size: 10pt,
  weight: "semibold",
  background: silver,
  preserve-linebreaks: true
)

#stanza("
 G                                   C      G
Jingle bells, jingle bells, jingle all the way!
C              G
Oh what fun it is to ride
      A7              D7
In a one-horse open sleigh, hey!
")
```

#{
  import "../src/stanza.typ": stanza-chord

  let stanza = stanza-chord.with(
    font: "PT Sans",
    size: 10pt,
    weight: "semibold",
    background: silver,
    preserve-linebreaks: true
  )

  stanza("
   G                                   C      G
  Jingle bells, jingle bells, jingle all the way!
  C              G
  Oh what fun it is to ride
        A7              D7
  In a one-horse open sleigh, hey!
  ")
}
#linebreak()

In any text-editor with a mono spaced font, you just enter
the text with the cords in the line above. The `stanza-chord`
function will automatically convert it into corresponding
calls to the `single-chord` function.

*Note*
- The input has to be a pure String (hence the parantheses and quotation marks instead of square brackets) and consist of an even number of lines, where the odd numbered lines contain the chords and the even numbered lines the lyrics.
- The input string may be any valid UTF-8 string. Multi-byte characters are counted correctly.
- Automatically centering a chord on a word (as done in `single-chord` by leaving the position empty) is not possible this way, because the first character of the chord name is always exactly above one character of a lyric word.

==== Custom chord typesetting
If you want to print chord names with special typesets, e.g. 'C#sym.flat;5', that can't
be input directly, you can provide a mapping between the input string
and the desired out output string.

```typ-lang
#import "@preview/chordx:0.8.0": stanza-chord

#let stanza = stanza-chord.with(
  font: "PT Sans",
  size: 10pt,
  weight: "semibold",
  background: silver,
  preserve-linebreaks: false,
  custom-typesets: (
    "D9": [D#super[9]],
    "C+": [C#super[+]],
    "G#": [G#symbol.sharp]
    )
)

#stanza("
D9    C+          G#
Lorem ipsum dolor sit amet,
F9         E+         A#
consetetur sadipscing elitr...
")
```

#{
  import "../src/stanza.typ": stanza-chord

 let stanza = stanza-chord.with(
  font: "PT Sans",
  size: 10pt,
  weight: "semibold",
  background: silver,
  preserve-linebreaks: false,
  custom-typesets: (
    "D9": [D#super[9]],
    "C+": [C#super[+]],
    "G#": [G#sym.sharp]
    )
)

stanza("
D9    C+          G#
Lorem ipsum dolor sit amet,
F9         E+         A#
consetetur sadipscing elitr...
")
}
#linebreak()

*Note*
- The difference in the rendering between the first and the second sets of chords is the usage of custom typeset mappings.
- In this example, `preseve-linebreaks` has been disabled, so that the two input lines are rendered as one output line.
- Custom typesets and automatic transposing are mutually exclusive.

==== Special scenarios
The `stanza-chord` function can handle a few special scenarios.
While this section is mostly about the internal working of the
`stanza-chord` function, it might be of relevance when you're
applying more complex design features (e.g. automatically placing
a frame around each individual word).
#{
  import "../src/single.typ": single-chord
  import "../src/stanza.typ": stanza-chord

  let chord = single-chord.with(
    font: "PT Sans",
    size: 10pt,
    weight: "semibold",
    background: silver
  )
  let stanza = stanza-chord.with(
    font: "PT Sans",
    size: 10pt,
    weight: "semibold",
    background: silver,
    preserve-linebreaks: true
  )
  [
    
    *Merging words*: In a situation, where the name of a chord, is longer than the
    word itself (such that it hangs over the next chord), the
    two words will be merged into one. For example.:
    ```typ-lang
    #stanza("
    Esus4
    Oh what ...
    ")
    ```
    will be merged into a single word that is handed to `single-chord`:
    ```typ-lang
    #chord[Oh what][Esus4][1] ...
    ```
    resulting in: #linebreak()
  ]
  chord[Oh what][Esus4][1];[ ...];linebreak()
  [
    #linebreak() This differs from the unmerged version:
    ```typ-lang
    #chord[Oh][Esus4][1] what ...
    ```
    which would result in an unnecessary long whitespace: #linebreak()
  ]
  chord[Oh][Esus4][1];[ what ...];linebreak()
  [
    You can avoid the merging of words, by increasing the spaces on the input:
    ```typ-lang
    #stanza("
    Esus4
    Oh   what ...
    ")
    ```
  ]

  [
    *Splitting words*: If you have a word that is so long that it needs multiple chords above it,
    it will be split automatically into multiple sub-words, which are passed 
    to the `single-chord` function. Let's use the German word for DNA as
    an example:
    ```typ-lang
    #stanza("
    A     D   G      C
    Desoxyribonukleinsäure
    ")
    ```
    will be converted to:
    ```typ-lang
    #chord[Desoxy][A][1]#chord[ribo][D][1]#chord[nuklein][G][1]#chord[säure][C][1]
    ```
    and rendered like:
  ]
  stanza("
    A     D   G      C9
    Desoxyribonukleinsäure
  ")
}