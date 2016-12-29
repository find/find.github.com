RSTS=$(wildcard src/*.rst)
HTMLS=$(addsuffix .html,$(basename $(notdir $(RSTS))))
STYLE=style.css
TEMPLATE=template.txt
EXTRA=-s --input-encoding=utf-8 --output-encoding=utf-8 --syntax-highlight=short
ARGS=--stylesheet=$(STYLE) --link-stylesheet --template=$(TEMPLATE) $(EXTRA)

.SUFFIXES: .html .rst

all: $(HTMLS)

%.html: src/%.rst $(TEMPLATE)
	rst2html.py $(ARGS) $< $@

