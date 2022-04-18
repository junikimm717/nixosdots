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

clean:
	rm -rf $(TARGETS)
	rm -rf template.pytxcode
	rm -rf ./pythontex-files-template

wipe: clean
	ls template.* | grep -vE "\.tex|\.bib" | xargs -r rm -rf

watch:
	latexmk -pdf -pvc
	
.PHONY: pdf docx all clean watch wipe
