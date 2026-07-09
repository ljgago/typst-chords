#import "../lib.typ": chart-chord

#set document(date: none)
#set page(width: auto, height: auto, margin: 0pt)

#let transpose = 2

#let chart-chord-sharp-tr0 = chart-chord.with(
  size: 18pt,
  for-transpose: 0,
  show-transpose: transpose,
)
#let chart-chord-round-tr0 = chart-chord.with(
  design: "round",
  size: 1.5em,
  for-transpose: 0,
  show-transpose: transpose,
)

#let chart-chord-sharp-tr2 = chart-chord.with(
  size: 18pt,
  for-transpose: 2,
  show-transpose: transpose,
)
#let chart-chord-round-tr2 = chart-chord.with(
  design: "round",
  size: 1.5em,
  for-transpose: 2,
  show-transpose: transpose,
)

#rect(
  stroke: none,
  radius: 3pt,
  inset: (x: 10pt, y: 10pt),
  fill: white,
  [
    #chart-chord-sharp-tr0(tabs: "x32o1o", fingers: "n32n1n")[C]
    #chart-chord-sharp-tr2(tabs: "xxo232", fingers: "nnn132")[D]
    #h(2em)
    #chart-chord-sharp-tr0(tabs: "ooo3", fingers: "ooo3")[C]
    #chart-chord-sharp-tr2(tabs: "222o", fingers: "123o")[D]
    #h(4em)
    #chart-chord-round-tr0(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115", position: "bottom")[Cm]
    #chart-chord-round-tr2(tabs: "xxo231", fingers: "ooo231", position: "bottom")[Dm]
    #h(2em)
    #chart-chord-round-tr0(tabs: "onnn", fingers: "n111", capos: "313", position: "bottom")[Cm]
    #chart-chord-round-tr2(tabs: "221o", fingers: "231n", position: "bottom")[Dm]
    #h(4em)
    #chart-chord-round-tr0(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115", background: silver)[Cm]
    #chart-chord-round-tr2(tabs: "xxo231", fingers: "ooo231", background: silver)[Dm]
    #h(2em)
    #chart-chord-round-tr0(tabs: "onnn", fingers: "n111", capos: "313", background: silver)[Cm]
    #chart-chord-round-tr2(tabs: "221o", fingers: "231n", background: silver)[Dm]
  ],
)
