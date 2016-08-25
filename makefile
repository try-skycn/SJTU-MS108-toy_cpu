FILE=pc_reg
TB = $(FILE)_tb

all: clean $(TB).vcd

$(TB).vcd: $(TB)
	vvp $< -vcd

$(TB): ./testbench/$(TB).v
	iverilog -o $@ $^

clean:
	-rm $(TB) $(TB).vcd
