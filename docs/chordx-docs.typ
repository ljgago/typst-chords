#import "@preview/tidy:0.2.0"
#import "assets/template.typ": design, custom

#set document(date: none)
#show link: underline

#show: design.with(
  title: "chordx",
  subtitle: "A package to write song lyrics with chord diagrams in Typst.",
  authors: (
    "Leonardo Javier Gago",
  ),
  date: "March 1, 2024",
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

#let chart-chord = chart-chord.with(size: 18pt)
#let chart-chord-round = chart-chord.with(style: "round", size: 18pt)

#chart-chord(tabs: "x32o1o", fingers: "n32n1n")[C]
#h(2em)
#chart-chord(tabs: "ooo3", fingers: "ooo3")[C]
#h(4em)
#chart-chord-round(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115")[Cm]
#h(2em)
#chart-chord-round(tabs: "onnn", fingers: "n111", capos: "313")[Cm]
```

#{
  import "../src/chart.typ": chart-chord

  let chart-chord = chart-chord.with(size: 18pt)
  let chart-chord-round = chart-chord.with(style: "round", size: 18pt)

  v(1em)
  chart-chord(tabs: "x32o1o", fingers: "n32n1n")[C]
  h(2em)
  chart-chord(tabs: "ooo3", fingers: "ooo3")[C]
  h(4em)
  chart-chord-round(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115")[Cm]
  h(2em)
  chart-chord-round(tabs: "onnn", fingers: "n111", capos: "313")[Cm]
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

#let piano-chord-normal = piano-chord.with(layout: "F", size: 18pt)
#let piano-chord-round = piano-chord.with(layout: "F", size: 18pt, style: "round")

#piano-chord-normal(keys: "B1, D2#, F2#", fill: blue)[B]
#h(4em)
#piano-chord-round(keys: "B1, D2#, F2#", fill: red)[B]
```

#{
  import "../src/piano.typ": piano-chord

  let piano-chord-normal = piano-chord.with(layout: "F", size: 16pt)
  let piano-chord-round = piano-chord.with(layout: "F", size: 18pt, style: "round")

  v(1em)
  piano-chord-normal(keys: "B1, D2#, F2#", fill: blue)[B]
  h(4em)
  piano-chord-round(keys: "B1, D2#, F2#", fill: red)[B]
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
  background-fill: silver
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
    background-fill: silver
  )

  [
    #chord[Jingle][G][2] bells, jingle bells, jingle #chord[all][C][2] the #chord[way!][G][2] \
    #chord[Oh][C][] what fun it #chord[is][G][] to ride \
    In a #chord[one-horse][A7][2] open #chord[sleigh,][D7][3] hey!
  ]
}
