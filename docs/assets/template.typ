#let acent(body) = box(
  fill: luma(85%),
  radius: 2pt,
  outset: (y: 4pt, x: 2pt)
)[#body]

#let design(
  title: "",
  subtitle: "",
  authors: (),
  url: none,
  date: none,
  version: none,
  body,
) = {
  // Set the document's basic properties.
  set document(author: authors, title: title)
  set text(font: "Linux Libertine", lang: "en")
  set heading(numbering: numbering("1.", 1))

  show heading.where(): it => {
    if it.level in (1, 2, 3) {
      block(it, above: 1.2em, below: 1.2em)
    } else {
      block(it.body, above: 1.2em, below: 1.2em)
    }
  }

  show link: set text(fill: rgb("#1e8f6f"))

  v(4em)

  // Title row.
  align(center)[
    #v(10em)
    #block(text(weight: 700, 5em, title))
    #v(4em, weak: true)
    #block(text(1.0em, subtitle))
    #v(30em, weak: true)
    v#version #h(2.6cm) #date
    #v(1.5em, weak: true)
    #block(link(url))
    #v(1.5em, weak: true)
  ]

  // Author information.
  pad(
    top: 0.5em,
    x: 2em,
    grid(
      columns: (1fr,) * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(center, strong(author))),
    ),
  )

  v(3cm, weak: true)

  // Main body.
  set par(justify: true)
  v(10em)

  // Configure page properties.
  set page(
    numbering: "1 / 1",
    header: locate(loc => {
      let i = counter(page).at(loc).first()

      if i in (1, 2) {
        return
      }

      if calc.odd(i) {
        h(1fr) + text(0.95em, smallcaps(title))
      } else {
        text(0.95em, smallcaps(title))
      }
    }),
  )

  body
}

// Custom syntax highlighting for "typ"
#let custom(source) = {
  set raw(theme: "halcyon.tmTheme")
  show raw: it => block(
    width: 100%,
    fill: rgb("#24292e"),
    inset: 8pt,
    radius: 5pt,
    text(fill: rgb("#f6f8fa"), it),
  )
  source
}
