#import "../typst-canvas/canvas.typ": canvas

#let set-graph-chords(strings: 6, font: "Linux Libertine") = {
  return (
    frets: 5,
    fret-number: none,
    capos: (),
    fingers: (),
    notes,
    chord-name
  ) => {
    box(
      canvas({
        import "../typst-canvas/draw.typ": *

        let mute(col) = {
          let offset = 5pt * col
          line((offset - 1.5pt, 2.5pt), (offset + 1.5pt, 5.5pt))
          line((offset - 1.5pt, 5.5pt), (offset + 1.5pt, 2.5pt))
        }

        // Draws the grid
        let draw-grid(row, col, number) = {
          let step = 5pt
          let limit = 0.26pt

          // Show or hide guitar nut
          if number == none or number == 1 {
            stroke(black + 2pt)
            line((-limit, 0.4pt), (step * (col - 1) + limit, 0.4pt))
          }

          content((-5pt, -2.5pt), text(8pt)[#number])
          stroke(black + 0.5pt)

          let i = 0
          while i < col {
            let x = i * step
            line((x, 0pt), (x, -5pt * (row - 1)))
            i += 1
          }

          let i = 0
          while i < row {
            let y = i * step
            line((-0.2pt, -y), (step * (col - 1) + 0.2pt, -y))
            i += 1
          }
        }

        // Draws notes: (x) for mute, (0) for air notes and (number) for finger notes
        let draw-notes(points) = {
          for (row, col) in points.zip((0, 1, 2, 3, 4, 5, 6, 7, 8, 9)) {
            if row == "x" {
              fill(none)
              stroke(black + 0.5pt)
              mute(col)
            } else if row == 0 {
              fill(none)
              stroke(black + 0.5pt)
              circle((5pt * col, 4pt), radius: 0.06)
            } else if type(row) == "integer" {
              fill(black)
              stroke(none)
              circle((5pt * col, 2.5pt - 5pt * row), radius: 0.06)
            }
          }
        }

        // Draws a capo list
        let draw-capos(size, points) = {
          fill(none)
          stroke(black + 3.3pt)

          for (fret, start, end) in points {
            line(
              ((size - start) * 5pt, 2.5pt - fret * 5pt),
              ((size - end) * 5pt, 2.5pt - fret * 5pt),
              mark-end: "o",
              mark-begin: "o",
              mark-size: 0.001
            )
          }
        }

        // Draw finger numbers
        let draw-fingers(points) = {
          for (finger, col) in points.zip((0, 1, 2, 3, 4, 5)) {
            if type(finger) == "integer" and finger > 0 and finger < 6 {
              content((5pt * col, -(frets * 5pt + 3pt)), text(6pt)[#finger])
            }
          }
        }

        draw-grid(frets + 1, strings, fret-number)
        draw-notes(notes)
        draw-capos(strings, capos)
        draw-fingers(fingers)

        let space = 14pt
        if fingers.len() == 0 {
          space = 10pt
        }

        content((2.5pt * (strings - 1), -(frets * 5pt + space)), text(12pt, font: font)[#chord-name])
      })
    )
  }
}

#let set-single-chords(..text-style) = {
  return (body, chord-name) => {
    box(
      canvas({
        import "../typst-canvas/draw.typ": *
        content((0, 18pt), text(..text-style)[#chord-name], anchor: "center")
        content((0, 0), body)
      })
    )
  }
}
