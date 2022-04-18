%.pdf:
	pdflatex $*.tex

template.pdf:
	latexmk -pdf template.tex

%.docx:
	pandoc -o $*.docx $*.tex

PDFTARGETS=template.pdf

WORDTARGETS=template.docx

TARGETS=$(PDFTARGETS)

pdf: $(PDFTARGETS) junk

docx: $(WORDTARGETS)

all: $(TARGETS)

clean: junk
	rm -rf $(TARGETS)

junk:
	ls template.* | grep -vE "^template\.(bib|tex)$$" | xargs -r rm -rf
	rm -rf *.aux *.log

watch:
	latexmk -pdf -pvc
	
.PHONY: pdf docx all clean junk watch
