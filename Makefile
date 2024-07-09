# =================================================================================================
# Generates svg images
images:
	typst compile examples/chart-chords.typ examples/chart-chords.svg -f svg --root .
	typst compile examples/piano-chords.typ examples/piano-chords.svg -f svg --root .
	typst compile examples/single-chords.typ examples/single-chords.svg -f svg --root .

# Generates full example
example:
	typst compile examples/jingle-bells.typ examples/jingle-bells.pdf --root .

# Generates documentation
docs:
	typst compile docs/chordx-docs.typ docs/chordx-docs.pdf --root .

# Build all
build: images example docs

.PHONY: images example docs build
# =================================================================================================
