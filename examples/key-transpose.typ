#import "../lib.typ": single-chord, stanza-chord, set-transpose

#set document(date: none)
#set page(width: auto, height: auto, margin: 15pt)
#set text(font: "PT Sans", 12pt)

#rect(
  stroke: 1pt + luma(200),
  radius: 4pt,
  inset: (x: 15pt, y: 15pt),
  fill: white,
  [
    #text(16pt, weight: "bold")[Key-to-Key Chord Transposition] \ \

    // 1. Stanza chord in original key (C major)
    #text(12pt, weight: "semibold", fill: blue.darken(20%))[Original Key (C Major):] \
    #let stanza-orig = stanza-chord.with(
      font: "PT Sans",
      size: 11pt,
      weight: "semibold",
      background: rgb("e8f0fe"),
    )
    #stanza-orig("
     C               Dm              G       C
    Amazing grace how sweet the sound that saved a wretch like me!
     C               F       C/E     Dm      G       C
    I once was lost but now am found, was blind but now I see.
    ")

    #v(1em)

    // 2. Transposed to G major via .with(from: "C", to: "G")
    #text(12pt, weight: "semibold", fill: blue.darken(20%))[Transposed to G Major (header configuration):] \
    #let stanza-g = stanza-chord.with(
      font: "PT Sans",
      size: 11pt,
      weight: "semibold",
      background: rgb("e6f4ea"),
      from: "C",
      to: "G",
    )
    #stanza-g("
     C               Dm              G       C
    Amazing grace how sweet the sound that saved a wretch like me!
     C               F       C/E     Dm      G       C
    I once was lost but now am found, was blind but now I see.
    ")

    #v(1em)

    // 3. Complex and Slash Chords Transposition
    #text(12pt, weight: "semibold", fill: blue.darken(20%))[Complex and Slash Chords (from C\# Major to D Major):] \
    #let chord-complex = single-chord.with(
      font: "PT Sans",
      size: 11pt,
      weight: "semibold",
      background: rgb("fef7e0"),
      from: "C#",
      to: "D",
    )
    [
      #chord-complex[Normal][C\#][1] chord,
      #chord-complex[minor][E\#m][1] chord,
      #chord-complex[half-diminished][E\#m7b5][1] chord,
      #chord-complex[slash][C\#/A][1] chord, and
      #chord-complex[slash minor][E\#m/G][1] chord.
    ]

    #v(1.5em)

    // 4. Document-wide Transposition using #set-transpose
    #text(12pt, weight: "semibold", fill: blue.darken(20%))[Document-wide Transposition (#set-transpose(from: "C", to: "Eb")):] \
    #set-transpose(from: "C", to: "Eb")

    #let stanza-docwide = stanza-chord.with(
      font: "PT Sans",
      size: 11pt,
      weight: "semibold",
      background: rgb("fce8e6"),
    )
    #stanza-docwide("
     C               Dm              G       C
    Amazing grace how sweet the sound that saved a wretch like me!
    ")
  ]
)
