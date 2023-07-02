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
  return (body, chord-name, body-char-pos) => {
    box(
      style(body-styles => {
        canvas({
          import "../typst-canvas/draw.typ": *

          let word = body.fields().values().at(0)
          let word-char-pos = body-char-pos.fields().values().at(0)
          let sum = 0pt
          let total = 0pt
          let offset = 0pt
          let anchor = "center"

          if type(word-char-pos) != "array" and int(word-char-pos) != 0 {
            // computes the width of the word until the (word-char-pos - 1) index
            for i in range(int(word-char-pos) - 1) {
              sum += measure([#word.at(i)], body-styles).width
            }
            total = measure(body, body-styles).width

            // gets the offset to center the first character of the chord
            // with the selected character of the word
            let chord-char = chord-name.fields().values().at(0).at(0)

            let chord-char-width = measure(text(..text-style)[#chord-char], body-styles).width
            let word-char-width = measure([#word.at(int(word-char-pos) - 1)], body-styles).width

            offset = (chord-char-width - word-char-width) / 2
            anchor = "left"
          }

          content((sum - (total / 2) - offset, 18pt), text(..text-style)[#chord-name], anchor: anchor)
          content((0pt, 0pt), body)
        })
      })
    )
  }
}

