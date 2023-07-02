#import "../chords.typ": *

#let guitar-chord = set-graph-chords()
#let ukulele-chord = set-graph-chords(strings: 4)

#guitar-chord(
  capos: ((2, 1, 5),),
  fingers: (0, 1, 2, 3, 4, 1),
  ("x", "n", 4, 4, 4, "n")
)[B]

#ukulele-chord(
  capos: ((2, 1, 2),),
  fingers: (3, 2, 1, 1),
  (4, 3, "n", "n")
)[B]
