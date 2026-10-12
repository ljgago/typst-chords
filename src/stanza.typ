#import "./single.typ": single-chord

// Lesson learned: Counting the bytes in a string, works only until
// the first non-ASCII character appears. For example a German umlaut
// like 'Ä' consists of two bytes and would therefore be miscounted as
// two characters.
// The solution to this is to only work on the grapheme clusters, which
// can be derived from a string using the str.clusters() method. See:
// https://typst.app/docs/reference/foundations/str/#definitions-clusters
// And for more details about what grapheme clusters are:
// https://doc.rust-lang.org/book/ch08-02-strings.html#bytes-scalar-values-and-grapheme-clusters

// Splits a line into words, noting their index, content and length.
// -> array((index: int, word: str))
#let parse-line(line) = {
  assert.eq(type(line), str)
  let graphemes = line.clusters()
  let words = ()
  let index = 0
  let current-word = ""
  let word-index = -1
  while(index < graphemes.len()) {
    //if not line.slice(index, count: 1) == " " {
    // Above will fail, if there are multi-byte characters, e.g. German umlauts.
    // See https://doc.rust-lang.org/book/ch08-02-strings.html#bytes-scalar-values-and-grapheme-clusters
    // and https://typst.app/docs/reference/foundations/str/
    // But we can't just use typsts iterating grapheme-based iterator over strings, because we need
    // the indices (not the grapheme count) to slice the string.
    if not graphemes.at(index) == " " {
      if current-word == "" {
        // Previously not in a word and now a non-space --> This index is the start of a new word.
        word-index = index
      }
      current-word = current-word + graphemes.at(index)
    } else {
      if current-word.len() > 0 {
        // Now a space and previously in a word --> This is the index behind a word.
        let word = (
          "index" : word-index,
          "text" : current-word
        )
        words.push(word)
      }
      current-word = ""
    }
    index += 1
  }
  if current-word.len() > 0 {
    // The line ended on a word.
    let word = (
      "index" : word-index,
      "text" : current-word
    )
    words.push(word)
  }
  words
}

// Processes a pair of annotated lyric- and chord-words into a line of content
#let process-line-pair(..single-chord-params, custom-typesets, pair) = {
  assert.eq(type(custom-typesets), dictionary)
  let chord = single-chord.with(..single-chord-params)
  let line = []
  let chord-words = parse-line(pair.chords)
  let lyric-words = parse-line(pair.lyrics)
  let chord-index = 0
  let lyric-index = 0
  let split-word = false // We'll need to know if words were split, so we can omit the space!
  while lyric-index < lyric-words.len() {
    // lyric-words.len() will change between iterations, if merging or splitting happens!
    let lyric-word = lyric-words.at(lyric-index)
    if chord-index < chord-words.len() and chord-words.at(chord-index).index <= lyric-word.index+lyric-word.text.clusters().len() {
      // Detailed processing only, if there are more chords AND the next chord starts above this lyric!
      let chord-word = chord-words.at(chord-index)
      
      // ========== Merge Words================================================
      // We will merge, if:
      //   - another lyric-word is available 
      //   - the current chord-word reaches over the next lyric-word 
      if (lyric-index+1) < lyric-words.len() {
        let end-of-chord-word = chord-word.index + chord-word.text.clusters().len()
        let start-of-next-word = lyric-words.at(lyric-index+1).index
        if end-of-chord-word > start-of-next-word {
          lyric-word.text = lyric-word.text + " " + lyric-words.at(lyric-index+1).text
          let removed = lyric-words.remove(lyric-index+1)
          // This is a horrible trap: removed isn't used for anything. But if the
          // return value of remove() isn't stored away, it will move upwards,
          // and at the end the method will unsuccessfully try to join it (a dictionary)
          // and the actual return value (line, of type content)-
        }
      }
      
      // ========== Split Words================================================
      // We will split, if:
      // - another chord-word is available
      // - the next-chord-word starts before the end of the current lyric-word
      if chord-words.len() > (chord-index+1) {
        let end-of-this-word = lyric-word.index + lyric-word.text.clusters().len()
        let start-of-next-chord = chord-words.at(chord-index+1).index
        if start-of-next-chord <= end-of-this-word {
          split-word = true
          let new-index = start-of-next-chord
          let slice-index = start-of-next-chord - lyric-word.index
          let old-text = ""
          let new-text = ""
          let cluster-index = 0
          for cluster in lyric-word.text.clusters() {
            if cluster-index < slice-index {
              old-text = old-text + cluster
            } else {
              new-text = new-text + cluster
            }
            cluster-index = cluster-index + 1
          }
          let new-lyric-word = (
            "index" : new-index,
            "text" : new-text
          )
          lyric-word.text = old-text
          lyric-words.insert(lyric-index+1, new-lyric-word)
        }
      }

      // ========== Process Word ==============================================
      let chord-pos = [#str(chord-word.index - lyric-word.index + 1)]
      // The weird casting of chord-pos should not be necessary. That's an issue with single-chord.
      line = [#line;#chord[#lyric-word.text][#custom-typesets.at(chord-word.text, default: [#chord-word.text])][#chord-pos]]
      chord-index += 1 // One chord was used, increase index.
    } else {
      // No more chords, still need to print the rest of the words...
      line = [#line;#lyric-word.text]
    }
    if not split-word {
        line = [#line ] 
    }
    split-word = false
    lyric-index += 1 // One lyric was used, increase index.
  }

  // If there are any chords after the last lyric-word, this will display them:
  while chord-index < chord-words.len() {
    let chord-word = chord-words.at(chord-index)
    line = [#line;~~#chord[~][#custom-typesets.at(chord-word.text, default: [#chord-word.text])][]]
    chord-index += 1
  }

  line
}

/// A helper method, to simplify entering entire stanzas, without having to type a complete
/// single-chord command for each chord.
/// -> content
#let stanza-chord(
  /// Embeds all the parameters of the `single-chord` function, including the native *text*
  /// parameters from the standard library of *typst*. *Optional*.
  /// -> auto
  ..single-chord-params,

  /// If true, linebreaks of the input will be replicated in the output. If false,
  /// the output will be without explicit linebreaks.
  /// The default value is true, because in many lyrics use cases a line represents
  /// a verse. *Optional*.
  /// -> bool
  preserve-linebreaks: true,

  /// Dictionary with custom typesets for chords. (Keys: `str` with chord name as in the input; Values: `content` as expected in the output.) *Optional*.
  /// -> dictionary
  custom-typesets: (:),

  /// The stanza. Lines of chords and lines of text alternating. *Required*.
  /// -> str
  stanza
) = context {
  assert.eq(type(preserve-linebreaks), bool)
  assert.eq(type(custom-typesets), dictionary)
  assert.eq(type(stanza), str)

  // Split the input in pairs of one line with chords and one line with lyrics:
  let lines = stanza
    .split("\n")
    .filter(line => line != "");
  let line-pairs = ()
  let line-pair = (:)
  for line in lines.chunks(2, exact: true) {
    line-pair.insert("chords", line.at(0))
    line-pair.insert("lyrics", line.at(1))
    line-pairs.push(line-pair)
  }

  let output = []
  for line-pair in line-pairs {
    let current-line = process-line-pair(..single-chord-params, custom-typesets, line-pair)
    if preserve-linebreaks {
      output = [#output;#linebreak();#current-line;]
    } else {
      output = [#output;~#current-line;]
    }
  }

  output
}
