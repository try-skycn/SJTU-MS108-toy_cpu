FILE=RegFile
TB = $(FILE)_tb

all: clean $(TB).vcd

wave:
	open $(TB).vcd -a Scansion

$(TB).vcd: $(TB)
	vvp $< -vcd

$(TB): ./testbench/$(TB).v
	iverilog -o $@ $^

clean:
	-rm $(TB) $(TB).vcd
