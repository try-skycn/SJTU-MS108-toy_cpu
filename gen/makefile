MAINFILE=CPU

all: comp
	cp output.v ../$(MAINFILE).v

.PHONY: comp
comp:
	python3 comp.py config.v .. > output.v
	