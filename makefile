FILE=MIPS
TB = $(FILE)_tb

TESTDIR = ./tmp

all: clean comp cpu mips dump.vcd

wave: dump.vcd
	@open $< -a Scansion

dump.vcd: $(TESTDIR)/$(TB)
	@vvp $< -vcd

$(TESTDIR)/$(TB): ./testbench/$(TB).v *.v
	iverilog -o $@ $^

.PHONY: comp
comp: ./compile/rom.s
	cd compile && python main.py

.PHONY: cpu
cpu:
	cd gen && python3 comp.py cpu-config.v .. > cpu.v && cp cpu.v ../CPU.v

.PHONY: mips
mips:
	cd gen && python3 comp.py mips-config.v .. > mips.v && cp mips.v ../MIPS.v

.PHONY: clean
clean:
	@-rm $(TESTDIR)/* *.vcd
