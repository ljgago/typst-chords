#import "../lib.typ": *

#set document(date: none)
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

#let gchord = chart-chord.with(style: "rounded", size: 14pt)
#let chord = single-chord.with(
  font: "PT Sans",
  size: 12pt,
  weight: "semibold",
  background: silver
)

= Jingle Bells / #text(weight: "regular")[_Christmas Song_]

#v(2em)
#gchord(tabs: "32ooo3", fingers: "21ooo3")[G]
#h(1fr)
#gchord(tabs: "x32o1o", fingers: "o32o1o")[C]
#h(1fr)
#gchord(tabs: "xo221o", fingers: "oo231o")[Am]
#h(1fr)
#gchord(tabs: "xxo212", fingers: "ooo213")[D7]
#h(1fr)
#gchord(tabs: "xxo232", fingers: "ooo132")[D]
#h(1fr)
#gchord(tabs: "xo2o2o", fingers: "oo1o2o")[A7]
#v(1em)

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

