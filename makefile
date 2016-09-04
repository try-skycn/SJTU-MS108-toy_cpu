FILE=MIPS
TB = $(FILE)_tb

TESTDIR = ./tmp

all: clean dump.vcd

wave: dump.vcd
	open $< -a Scansion

dump.vcd: $(TESTDIR)/$(TB)
	vvp $< -vcd

$(TESTDIR)/$(TB): ./testbench/$(TB).v *.v
	iverilog -o $@ $^

.PHONY: comp
comp: ./compile/rom.s
	cd compile && python main.py

clean:
	-rm $(TESTDIR)/*
	-rm *.vcd
