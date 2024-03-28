#import "../lib.typ": *

#set document(date: none)
#set page(width: auto, height: auto, margin: 0pt)

#let piano-chord-normal = piano-chord.with(layout: "F", size: 18pt)
#let piano-chord-round = piano-chord.with(layout: "F", size: 1.5em, style: "round")

#rect(
  stroke: none,
  radius: 3pt,
  inset: (x: 10pt, y: 10pt),
  fill: white, [
    #piano-chord-normal(keys: "B1, D2#, F2#", fill: blue)[B]
    #h(4em)
    #piano-chord-round(keys: "B1, D2#, F2#", fill: red)[B]
  ]
)
