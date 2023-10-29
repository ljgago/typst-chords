# =================================================================================================
.PHONY: compile

## Compile
compile:
	typst compile examples/chart-chords.typ examples/chart-chords.svg -f svg --root .
	typst compile examples/piano-chords.typ examples/piano-chords.svg -f svg --root .
	typst compile examples/single-chords.typ examples/single-chords.svg -f svg --root .
	# Full example
	typst compile examples/jingle-bells.typ examples/jingle-bells.pdf --root .
# =================================================================================================
