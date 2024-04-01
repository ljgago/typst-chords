#import "../lib.typ": *

#set document(date: none)
#set page(width: auto, height: auto, margin: 0pt)

#let chart-chord-rect = chart-chord.with(size: 18pt)
#let chart-chord-rounded = chart-chord.with(style: "rounded", size: 1.5em)

#rect(
  stroke: none,
  radius: 3pt,
  inset: (x: 10pt, y: 10pt),
  fill: white, [
    #chart-chord-rect(tabs: "x32o1o", fingers: "n32n1n")[C]
    #h(2em)
    #chart-chord-rect(tabs: "ooo3", fingers: "ooo3")[C]
    #h(4em)
    #chart-chord-rounded(tabs: "xn332n", fingers: "o13421", fret: 3, capos: "115")[Cm]
    #h(2em)
    #chart-chord-rounded(tabs: "onnn", fingers: "n111", capos: "313")[Cm]
  ]
)
