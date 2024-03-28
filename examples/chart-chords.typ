#import "../lib.typ": *

#set document(date: none)
#set page(width: auto, height: auto, margin: 0pt)

#let chart-chord-normal = chart-chord.with(size: 18pt)
#let chart-chord-round = chart-chord.with(style: "round", size: 1.5em)

#rect(
  stroke: none,
  radius: 3pt,
  inset: (x: 10pt, y: 10pt),
  fill: white, [
    #chart-chord-normal(tabs: "x32o1o", fingers: "n32n1n")[C]
    #h(2em)
    #chart-chord-normal(tabs: "ooo3", fingers: "ooo3")[C]
    #h(4em)
    #chart-chord-round(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115")[Cm]
    #h(2em)
    #chart-chord-round(tabs: "onnn", fingers: "n111", capos: "313")[Cm]
  ]
)
