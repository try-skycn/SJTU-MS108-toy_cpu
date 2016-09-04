`include "define.v"

module MIPS(
	input	wire	clk,
	input	wire	rst
);

	wire[`INST_ADDR_BUS]	instAddr;
	wire[`INST_BUS]			inst;
	wire					romChipEnable;

	CPU inst_CPU(
		.clk(clk),
		.rst(rst),
		.o_chipEnable(romChipEnable),
		.o_romAddr(instAddr),
		.i_romInst(inst)
	);

	InstRom inst_InstRom(
		.chipEnable(romChipEnable),
		.addr(instAddr),
		.inst(inst)
	);

endmodule
