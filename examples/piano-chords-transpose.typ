#import "../lib.typ": piano-chord

#set document(date: none)
#set page(width: auto, height: auto, margin: 0pt)

#let transpose = 2

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

#rect(
  stroke: none,
  radius: 3pt,
  inset: (x: 10pt, y: 10pt),
  fill: white,
  [
    #piano-chord-sharp-tr0(keys: "B1, D2#, F2#", fill-key: blue)[B]
    #piano-chord-sharp-tr2(keys: "C2#, F2, G2#", fill-key: blue)[C\#]
    #h(2em)
    #piano-chord-round-tr0(keys: "B1, D2#, F2#", fill-key: yellow, position: "bottom")[B]
    #piano-chord-round-tr2(keys: "C2#, F2, G2#", fill-key: yellow, position: "bottom")[C\#]
    #h(2em)
    #piano-chord-round-tr0(keys: "B1, D2#, F2#", fill-key: red, background: silver)[B]
    #piano-chord-round-tr2(keys: "C2#, F2, G2#", fill-key: red, background: silver)[C\#]
  ],
)
