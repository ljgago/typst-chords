#import "../lib.typ": *

#set page(width: 320pt, height: 95pt)

#let piano-chord = new-piano-chords(layout: "F", scale: 1.5)
#let piano-chord-round = new-piano-chords(layout: "F", scale: 1.5, style: "round")

#piano-chord(keys: "B1, D2#, F2#", fill: blue)[B]
#h(4em)
#piano-chord-round(keys: "B1, D2#, F2#", fill: red)[B]
