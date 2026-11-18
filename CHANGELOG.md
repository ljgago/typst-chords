# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

- Key-to-key chord transposition for `single-chord` and `stanza-chord` supporting all 15 major and 15 natural minor scales with proper diatonic note spelling.
- Support for complex chord qualities (e.g. `C#`, `Dm`, `E#m`, `E#m7b5`, `Bbmaj7`, `Asus4`, `Gdim7`).
- Full support for slash chords (e.g. `C#/A`, `E#m/G`, `1/3`, `5/7`), transposing both the root chord and bass note.
- Support for the Nashville Number System (NNS) both as input notation (converting scale degrees `1`..`7`, `1/3`, `6m`, `b7` to chords in any target key) and as output notation (converting standard chords to Nashville numbers).
- New document-wide transposition function `#set-transpose(from: ..., to: ...)` (and alias `set-chord-transposition`) using Typst context-aware state.
- New exported functions `transpose-chord`, `set-transpose`, `set-chord-transposition`, and `chord-transposition-state` in `lib.typ`.
- New parameters `from-key`, `to-key`, `from`, `to` in `single-chord` and `stanza-chord`.
- New comprehensive examples: `examples/key-transpose.typ` and `examples/nashville-notation.typ`.
- Expanded test suite in `examples/tests.typ` validating all major and minor scales, complex chords, slash chords, and Nashville notation.

## [v0.8.0](https://github.com/ljgago/typst-chords/compare/v0.7.0...v0.8.0) - 2026-07-09

## Added

- Support to show chords before the lyrics for `single-chord` using `position: 0`.
- New automatic transpose for `single-chord`.
- New manual transpose for `chart-chord` and `piano-chord`.

## [v0.7.0](https://github.com/ljgago/typst-chords/compare/v0.6.1...v0.7.0) - 2026-05-03

## Changed

- Added `inner-gap` and `outer-gap` parameters in `single-chord` to adjust the chord name offset.

## [v0.6.1](https://github.com/ljgago/typst-chords/compare/v0.6.0...v0.6.1) - 2025-11-17

### Changed

- Measure the whole word instead of the characters in single chord.

## [v0.6.0](https://github.com/ljgago/typst-chords/compare/v0.5.0...v0.6.0) - 2025-03-11

### Changed

- Replaced the deprecated string type comparation with the new syntaxis.
- Replaced the deprecated path function in favor of the curve function.
- Updated documentation with tidy v0.4.2

## [v0.5.0](https://github.com/ljgago/typst-chords/compare/v0.4.0...v0.5.0) - 2024-10-31

### Changed

- Repaced the default font `Linux Libertine` deprecated in typst v0.12.0 with the new default font `Libertinus Serif`.
- Replaced `locate` callback function deprecated in typst v0.12.0 with location context in documentation template and examples.

## [v0.4.0](https://github.com/ljgago/typst-chords/compare/v0.3.0...v0.4.0) - 2024-07-09

### Added

- New `background` parameter, now in `chart-chord`, `piano-chord` and `single-chord`. Add a background color on the chord name.
- New `position` parameter in `chart-chord`, `piano-chord`. Now the chart can be below or above of the chord name.
- New `..text-params` in `chart-chord`, `piano-chord` and `single-chord`. It embeds the native text parameters from the standard library of typst.

### Changed

- Renamed `new-chart-chords`, `new-piano-chords` and `new-single-chords` functions by `chart-chord`, `piano-chord` and `single-chord` removing the closure functions. Use the [with](https://typst.app/docs/reference/foundations/function/#definitions-with) property for preset the parameters.
- Renamed `style` parameter by `design` to avoid name collision with the native text parameters. The possible values of `design` are `"sharp"` and `"round"`
- Renamed `fill` parameter by `fill-key` to avoid name collision with the native text parameters.
- Replaced the `styles-measure` syntax by the new [context-measure](https://typst.app/docs/reference/context/) added in Typst v0.11.0.
- Refactored the render and the graphic objects, now each object calculates its own relative position.

### Removed

- Removed `size` as a specific parameter. `size` is included in the native *text* parameters in `..text-params`.

## [v0.3.0](https://github.com/ljgago/typst-chords/compare/v0.2.0...v0.3.0) - 2024-03-01

### Changed

- Renamed `frets` parameter by `frets-amount`.
- Renamed `fret-number` parameter by `fret`.
- Renamed `color` parameter by `fill`.
- Replaced `scale` parameter by `size`. You can use the same functionality using `em` units.
- Replaced new types released in Typst v0.8.0.

## [v0.2.0](https://github.com/ljgago/typst-chords/compare/v0.1.0...v0.2.0) - 2023-08-25

### Added

- New file structure.
- New piano chords.
- Options to scale the graphs.
- New round style.

### Changed

- Renamed new-graph-chords to new-chart-chords.
- Replaced array inputs by string inputs (thanks to `conchord` for the ideas).

### Removed

- Removed dependency of CeTZ, uses only native functions.

## [v0.1.0](https://github.com/ljgago/typst-chords/compare/v0.1.0...v0.1.0) - 2023-07-16

### Added

- Added graph chords.
- Added single chords.

### Changed

- The single chords show the chord name over a specific character or word.
