`include "define.v"

module CPU(
	input	wire					clk,
	input	wire					rst,

	output	wire					o_chipEnable,
	output	wire[`INST_ADDR_BUS]	o_romAddr,
	input	wire[`INST_BUS]			i_romInst
);

/*
	compile module PCReg

	compile module IF_ID
	compile module ID
	compile module RegFile

	compile module ID_EX
	compile module ALU_LOGIC
	compile module EX

	compile module EX_MEM

	compile module MEM_WB
*/

assign o_romAddr = pc;

endmodule