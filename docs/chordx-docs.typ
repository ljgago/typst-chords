#import "@preview/tidy:0.1.0"
#import "assets/template.typ": design, custom
#show link: underline

#show: design.with(
  title: "chordx",
  subtitle: "A package to write song lyrics with chord diagrams in Typst.",
  authors: (
    "Leonardo Javier Gago",
  ),
  date: "August 25, 2023",
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
#import "@preview/chordx:0.2.0": *

#let chart-chord = new-chart-chords(scale: 1.5)
#let chart-chord-round = new-chart-chords(style: "round", scale: 1.5)

#chart-chord(tabs: "x32o1o", fingers: "n32n1n")[C]
#h(2em)
#chart-chord(tabs: "ooo3", fingers: "ooo3")[C]
#h(4em)
#chart-chord-round(tabs: "xn332n", fingers: "o13421", fret-number: 3, capos: "115")[Cm]
#h(2em)
#chart-chord-round(tabs: "onnn", fingers: "n111", capos: "313")[Cm]
```

#{
  import "../src/chart.typ": new-chart-chords

  let chart-chord = new-chart-chords(scale: 1.5)
  let chart-chord-round = new-chart-chords(style: "round", scale: 1.5)

  v(1em)
  chart-chord(tabs: "x32o1o", fingers: "n32n1n")[C]
  h(2em)
  chart-chord(tabs: "ooo3", fingers: "ooo3")[C]
  h(4em)
  chart-chord-round(tabs: "xn332n", fingers: "o13421", fret-number: 3, capos: "115")[Cm]
  h(2em)
  chart-chord-round(tabs: "onnn", fingers: "n111", capos: "313")[Cm]
  v(2em)
}

== Piano Chords

#{
  let module = tidy.parse-module(read("../src/piano.typ"))
  tidy.show-module(module, sort-functions: none)
}

==== Example:

```typ-lang
#import "@preview/chordx:0.2.0": *

#let piano-chord = new-piano-chords(layout: "F", scale: 1.5)
#let piano-chord-round = new-piano-chords(layout: "F", scale: 1.5, style: "round")

#piano-chord(keys: "B1, D2#, F2#", color: blue)[B]
#h(4em)
#piano-chord-round(keys: "B1, D2#, F2#", color: red)[B]
```

#{
  import "../src/piano.typ": new-piano-chords

  let piano-chord = new-piano-chords(layout: "F", scale: 1.5)
  let piano-chord-round = new-piano-chords(layout: "F", scale: 1.5, style: "round")

  v(1em)
  piano-chord(keys: "B1, D2#, F2#", color: blue)[B]
  h(4em)
  piano-chord-round(keys: "B1, D2#, F2#", color: red)[B]
  v(2em)
}

== Single Chords

#{
  let module = tidy.parse-module(read("../src/single.typ"))
  tidy.show-module(module, sort-functions: none)
}

==== Example:

```typ-lang
#import "@preview/chordx:0.2.0": *

#let chord = new-single-chords(style: "italic", weight: "semibold")

#chord[Jingle][G][2] bells, jingle bells, jingle #chord[all][C][2] the #chord[way!][G][2] \
#chord[Oh][C][] what fun it #chord[is][G][] to ride \
In a #chord[one-horse][A7][2] open #chord[sleigh,][D7][3] hey!
```

#{
  import "../src/single.typ": new-single-chords

  let chord = new-single-chords(style: "italic", weight: "semibold")

  [
    #chord[Jingle][G][2] bells, jingle bells, jingle #chord[all][C][1] the #chord[way!][G][2] \
    #chord[Oh][C][] what fun it #chord[is][G][] to ride \
    In a #chord[one-horse][A7][2] open #chord[sleigh,][D7][3] hey!
  ]
}
