#import "../lib.typ": *

#set document(date: none)
#set page(width: auto, height: auto, margin: 0pt)

#let piano-chord-sharp = piano-chord.with(layout: "F", size: 18pt)
#let piano-chord-round = piano-chord.with(layout: "F", size: 1.5em, design: "round")

#rect(
  stroke: none,
  radius: 3pt,
  inset: (x: 10pt, y: 10pt),
  fill: white, [
    #piano-chord-sharp(keys: "B1, D2#, F2#", fill-key: blue)[B]
    #h(2em)
    #piano-chord-round(keys: "B1, D2#, F2#", fill-key: yellow, position: "bottom")[B]
    #h(2em)
    #piano-chord-round(keys: "B1, D2#, F2#", fill-key: red, background: silver)[B]
  ]
)
