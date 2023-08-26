#import "../lib.typ": *

#set page(width: 285pt, height: 95pt)

#let chart-chord = new-chart-chords(scale: 1.5)
#let chart-chord-round = new-chart-chords(style: "round", scale: 1.5)

#chart-chord(tabs: "x32o1o", fingers: "n32n1n")[C]
#h(2em)
#chart-chord(tabs: "ooo3", fingers: "ooo3")[C]
#h(4em)
#chart-chord-round(tabs: "xn332n", fingers: "o13421", fret-number: 3, capos: "115")[Cm]
#h(2em)
#chart-chord-round(tabs: "onnn", fingers: "n111", capos: "313")[Cm]
