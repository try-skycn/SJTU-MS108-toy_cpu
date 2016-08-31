FILE=IF_ID
TB = $(FILE)_tb

TESTDIR = ./test

all: clean dump.vcd

wave: dump.vcd
	open $< -a Scansion

dump.vcd: $(TESTDIR)/$(TB)
	vvp $< -vcd

$(TESTDIR)/$(TB): ./testbench/$(TB).v
	iverilog -o $@ $^

clean:
	-rm $(TESTDIR)/*
	-rm *.vcd
