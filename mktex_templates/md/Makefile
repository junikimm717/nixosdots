%.pdf:
	pandoc -o $*.pdf $*.md

PDFTARGETS=template.pdf

WORDTARGETS=template.docx

# put template.docx into targets if necessary.

TARGETS=$(PDFTARGETS)

all: $(TARGETS)
	
clean:
	rm -rf $(TARGETS)
