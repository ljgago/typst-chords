#import "../lib.typ": *

#set align(center)
#set page(
  margin: (top: 2.5cm, bottom: 2.5cm),
  numbering: "1 / 1",
  header: locate(loc => {
    set text(11pt)
    let elems = query(
      selector(heading).before(loc),
      loc,
    )
    let title = smallcaps[_Jingle Bells_]
    let artist = smallcaps[_Christmas Song_]
    if elems != () {
      let body = elems.last().body
      title + h(1fr) + artist
    }
  })
)

#let gchord = new-graph-chords()
#let chord = new-single-chords(style: "italic", weight: "semibold")

= Jingle Bells / #text(weight: "regular")[_Christmas Song_]

#v(30pt)
#gchord(fingers: (2, 1, 0, 0, 0, 3), (3, 2, 0, 0, 0, 3))[G]
#h(1fr)
#gchord(fingers: (0, 3, 2, 0, 1, 0), ("x", 3, 2, 0, 1, 0))[C]
#h(1fr)
#gchord(fingers: (0, 0, 2, 3, 1, 0), ("x", 0, 2, 2, 1, 0))[Am]
#h(1fr)
#gchord(fingers: (0, 0, 0, 2, 1, 3), ("x", "x", 0, 2, 1, 2))[D7]
#h(1fr)
#gchord(fingers: (0, 0, 0, 1, 3, 2), ("x", "x", 0, 2, 3, 2))[D]
#h(1fr)
#gchord(fingers: (0, 0, 1, 0, 2, 0), ("x", 0, 2, 0, 2, 0))[A7]
#v(30pt)

#set align(left)
#set text(14pt)

#smallcaps[[Verse]] \
#chord[Dashing][G][2] through the snow, in a one-horse open #chord[sleigh,][C][3] \
#chord[O'er][Am][2] the fields we #chord[go,][D7][] laughing all the #chord[way.][G][] \
#chord[Bells][G][2] on bob-tails ring, making spirits #chord[bright,][C][3] \
What #chord[fun][Am][2] it is to #chord[ride][D][2] and sing a #chord[sleighing][D7][3] song #chord[tonight.][G][3] #chord[Oh!][D7][]

\

#smallcaps[[Chorus]] \
#chord[Jingle][G][2] bells, jingle bells, jingle #chord[all][C][] the #chord[way!][G][] \
#chord[Oh][C][] what fun it #chord[is][G][] to ride \
In a #chord[one-horse][A7][2] open #chord[sleigh,][D7][3] hey! \
#chord[Jingle][G][2] bells, jingle bells, jingle #chord[all][C][] the #chord[way!][G][] \
#chord[Oh][C][] what fun it #chord[is][G][] to ride \
In a #chord[one-horse][D7][2] open #chord[sleigh][G][3]

\

#smallcaps[[Verse]] \
A day or two ago, I thought I'd take a ride \
And soon Miss Fanny Bright was seated by my side \
The horse was lean and lank, misfortune seemed his lot \
We ran into a drifted bank and there we got upsot. Oh!

#pagebreak()

#smallcaps[[Chorus]] \
Jingle bells, jingle bells, jingle all the way! \
Oh what fun it is to ride \
In a one-horse open sleigh, hey! \
Jingle bells, jingle bells, jingle all the way! \
Oh what fun it is to ride \
In a one-horse open sleigh

\

#smallcaps[[Verse]] \
A day or two ago, the story I must tell \
I went out on the snow and on my back I fell \
A gent was riding by in a one-horse open sleigh \
He laughed at me as I there lay but quickly drove away. Oh!

\

#smallcaps[[Chorus]] \
Jingle bells, jingle bells, jingle all the way! \
Oh what fun it is to ride \
In a one-horse open sleigh, hey! \
Jingle bells, jingle bells, jingle all the way! \
Oh what fun it is to ride \
In a one-horse open sleigh

\

#smallcaps[[Verse]] \
Now the ground is white, go it while you're young \
Take the girls along and sing this sleighing song \
Just bet a bobtailed bay, two forty as his speed \
Hitch him to an open sleigh and crack! you'll take the lead. Oh! \

\

#smallcaps[[Chorus]] \
Jingle bells, jingle bells, jingle all the way! \
Oh what fun it is to ride \
In a one-horse open sleigh, hey! \
Jingle bells, jingle bells, jingle all the way! \
Oh what fun it is to ride \
In a one-horse open sleigh

