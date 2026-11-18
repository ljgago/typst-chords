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
    #text(16pt, weight: "bold")[Nashville Number System (NNS) Transposition] \ \

    // 1. Nashville notation as INPUT transposed into G Major
    #text(12pt, weight: "semibold", fill: purple.darken(20%))[1. Nashville as Input -> Rendered in G Major:] \
    #let stanza-from-nash-g = stanza-chord.with(
      font: "PT Sans",
      size: 11pt,
      weight: "semibold",
      background: rgb("f3e8fd"),
      from: "Nashville",
      to: "G",
    )
    #stanza-from-nash-g("
     1               4               5       1
    Amazing grace how sweet the sound that saved a wretch like me!
     1/3     6m      4       5/7     2m      5       1       b7
    I once was lost but now am found, was blind but now I see.
    ")

    #v(1em)

    // 2. The exact same Nashville input transposed into D Major
    #text(12pt, weight: "semibold", fill: purple.darken(20%))[2. Same Nashville Input -> Rendered in D Major:] \
    #let stanza-from-nash-d = stanza-chord.with(
      font: "PT Sans",
      size: 11pt,
      weight: "semibold",
      background: rgb("e8f0fe"),
      from: "Nashville",
      to: "D",
    )
    #stanza-from-nash-d("
     1               4               5       1
    Amazing grace how sweet the sound that saved a wretch like me!
     1/3     6m      4       5/7     2m      5       1       b7
    I once was lost but now am found, was blind but now I see.
    ")

    #v(1em)

    // 3. Standard Chords (G Major) as INPUT -> Rendered as Nashville Notation
    #text(12pt, weight: "semibold", fill: purple.darken(20%))[3. Standard Chords in G -> Rendered as Nashville Numbers:] \
    #let stanza-to-nash = stanza-chord.with(
      font: "PT Sans",
      size: 11pt,
      weight: "semibold",
      background: rgb("e6f4ea"),
      from: "G",
      to: "Nashville",
    )
    #stanza-to-nash("
     G               C               D       G
    Amazing grace how sweet the sound that saved a wretch like me!
     G/B     Em      C       D/F#    Am      D       G       F
    I once was lost but now am found, was blind but now I see.
    ")

    #v(1em)

    // 4. Minor Key with Nashville Notation (A minor)
    #text(12pt, weight: "semibold", fill: purple.darken(20%))[4. Minor Key (A minor) -> Nashville Notation Output:] \
    #let stanza-minor-nash = stanza-chord.with(
      font: "PT Sans",
      size: 11pt,
      weight: "semibold",
      background: rgb("fef7e0"),
      from: "Am",
      to: "Nashville",
    )
    #stanza-minor-nash("
     Am              Dm              Em      Am
    In the shadow of the mountains, through the night
     C               F               G       Am
    Voices whisper in the stillness, seeking light.
    ")
  ]
)
