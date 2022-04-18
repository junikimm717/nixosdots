%.pdf:
	latexmk -pdf $*.tex

PDFTARGETS=template.pdf

TARGETS=$(PDFTARGETS)

pdf: $(PDFTARGETS)

all: $(TARGETS)

clean:
	rm -rf $(TARGETS)

wipe:
	rm -rf ./pythontex-files-template
	ls template.* | grep -vE "^template\.(bib|tex)$$" | xargs -r rm -rf

watch:
	latexmk -pdf -pvc
	
.PHONY: pdf docx all clean junk watch wipe
