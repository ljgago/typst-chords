#import "@preview/tidy:0.3.0"
#import "assets/template.typ": design, custom

#set document(date: none)
#show link: underline

#show: design.with(
  title: "chordx",
  subtitle: "A package to write song lyrics with chord diagrams in Typst.",
  authors: (
    "Leonardo Javier Gago",
  ),
  date: "July 9, 2024",
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
#import "@preview/chordx:0.4.0": *

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
  import "../src/chart.typ": chart-chord

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

#pagebreak()

== Piano Chords

#{
  let module = tidy.parse-module(read("../src/piano.typ"))
  tidy.show-module(module, sort-functions: none)
}

==== Example:

```typ-lang
#import "@preview/chordx:0.4.0": *

#let piano-chord-sharp = piano-chord.with(layout: "F", size: 18pt)
#let piano-chord-round = piano-chord.with(layout: "F", size: 18pt, design: "round")

#piano-chord-sharp(keys: "B1, D2#, F2#", fill-key: blue)[B]
#piano-chord-round(keys: "B1, D2#, F2#", fill-key: yellow, position: "top")[B]
#piano-chord-round(keys: "B1, D2#, F2#", fill-key: red, background: silver)[B]
```

#{
  import "../src/piano.typ": piano-chord

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

#pagebreak()

== Single Chords

#{
  let module = tidy.parse-module(read("../src/single.typ"))
  tidy.show-module(module, sort-functions: none)
}

==== Example:

```typ-lang
#import "@preview/chordx:0.4.0": *

#let chord = single-chord.with(
  font: "PT Sans",
  size: 10pt,
  weight: "semibold",
  background: silver
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
    background: silver
  )

  [
    #chord[Jingle][G][2] bells, jingle bells, jingle #chord[all][C][2] the #chord[way!][G][2] \
    #chord[Oh][C][] what fun it #chord[is][G][] to ride \
    In a #chord[one-horse][A7][2] open #chord[sleigh,][D7][3] hey!
  ]
}
