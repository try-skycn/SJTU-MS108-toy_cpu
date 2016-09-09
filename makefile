FILE=MIPS
TB = $(FILE)_tb

ROOT = .

TESTBENCHDIR = ./testbench
COMPILEDIR = ./compile
AUTOWIREDIR = ./autowire
TESTDIR = ./tmp
SRCDIR = ./src

all: clean comp cpu mips $(ROOT)/dump.vcd

.PHONY: wave
wave: $(ROOT)/dump.vcd
	# @open $< -a Scansion
	@open $< -a gtkwave

$(ROOT)/dump.vcd: $(TESTDIR)/$(TB)
	@vvp $< -vcd > /dev/null
	mv dump.vcd $@

$(TESTDIR)/$(TB): $(TESTBENCHDIR)/$(TB).v $(SRCDIR)/*.v
	iverilog -o $@ $^

.PHONY: comp
comp: $(COMPILEDIR)/rom.s
	cd $(COMPILEDIR) && python main.py

.PHONY: cpu
cpu:
	python3 $(AUTOWIREDIR)/comp.py $(AUTOWIREDIR)/cpu-config.v $(SRCDIR) > $(SRCDIR)/CPU.v

.PHONY: mips
mips:
	python3 $(AUTOWIREDIR)/comp.py $(AUTOWIREDIR)/mips-config.v $(SRCDIR) > $(SRCDIR)/MIPS.v

.PHONY: clean
clean:
	@-rm $(TESTDIR)/* $(ROOT)/*.vcd
