RSTS=$(wildcard *.rst)
HTMLS=${RSTS:.rst=.html}
STYLE=style.css
TEMPLATE=template.txt
EXTRA=-s --input-encoding=cp936 --output-encoding=utf-8

.SUFFIXES: .html .rst

all: $(HTMLS)

%.html: %.rst $(TEMPLATE)
	rst2html.py $< --stylesheet=$(STYLE) --link-stylesheet --template=$(TEMPLATE) $(EXTRA) > $@

