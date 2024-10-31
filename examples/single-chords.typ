#import "../lib.typ": single-chord

#set document(date: none)
#set page(width: auto, height: auto, margin: 0pt)
#set text(14pt)

#let chord = single-chord.with(
  font: "PT Sans",
  size: 12pt,
  weight: "semibold",
  background: silver
)

#rect(
  stroke: none,
  radius: 3pt,
  inset: (x: 10pt, y: 10pt),
  fill: white, [
    #chord[Jingle][G][2] bells, jingle bells, jingle #chord[all][C][] the #chord[way!][G][2] \
    #chord[Oh][C][] what fun it #chord[is][G][] to ride \
    In a #chord[one-horse][A7][2] open #chord[sleigh,][D7][3] hey!
  ]
)
