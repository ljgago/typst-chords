#import "../lib.typ": single-chord

#set document(date: none)
#set page(width: auto, height: auto, margin: 0pt)
#set text(14pt)

#let chord1 = single-chord.with(
  font: "PT Sans",
  size: 12pt,
  inner-gap: 0.2em,
  outer-gap: 0.6em,
  weight: "semibold",
  background: silver,
  transpose: 1,
)

#let chord2 = single-chord.with(
  font: "PT Sans",
  size: 12pt,
  inner-gap: 0.2em,
  outer-gap: 0.6em,
  weight: "semibold",
  background: silver,
  accidental: "flat",
  flat-symbol: sym.flat,
  transpose: -1,
)

#rect(
  stroke: none,
  radius: 3pt,
  inset: (x: 10pt, y: 10pt),
  fill: white,
  [
    #chord1[Lorem][C][0] ipsum #chord1[dolor][D\#m][2] sit amet \
    #chord1[consectetur][Gbm7][5] adipiscing #chord1[elit.][B#super("9")][] \

    #chord2[Consectetur][D#sym.sharp m#super("+")][11] adipiscing elit #chord2[quisque][Asus4][2] \
    #chord2[*_faucibus_*][B#sub("sus4")][8] ex sapien #chord2[#underline("vitae.")][D][2] \
  ],
)
