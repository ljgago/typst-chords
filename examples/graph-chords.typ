#import "../lib.typ": *

#let guitar-chord = new-graph-chords()
#let ukulele-chord = new-graph-chords(strings: 4)

#set page(width: 90pt, height: 65pt)

#guitar-chord(
  capos: ((2, 1, 5),),
  fingers: (0, 1, 2, 3, 4, 1),
  ("x", "n", 4, 4, 4, "n")
)[B]
#h(20pt)
#ukulele-chord(
  capos: ((2, 1, 2),),
  fingers: (3, 2, 1, 1),
  (4, 3, "n", "n")
)[B]
