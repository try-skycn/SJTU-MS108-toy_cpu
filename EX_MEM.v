`include "define.v"

module EX_MEM(
	clk, rst,
	ex_memOp, ex_memAddr, ex_memLen, ex_regDest, ex_value,
	mem_memOp, mem_memAddr, mem_memLen, mem_regDest, mem_value
);
	
	input	wire					clk;
	input	wire					rst;

	input	wire[`MEM_OP_BUS]		ex_memOp;
	input	wire[`MEM_ADDR_BUS]		ex_memAddr;
	input	wire[`MEM_LEN_BUS]		ex_memLen;
	input	wire[`REG_BUS]			ex_regDest;
	input	wire[`WORD_BUS]			ex_value;

	output	reg	[`MEM_OP_BUS]		mem_memOp;
	output	reg	[`MEM_ADDR_BUS]		mem_memAddr;
	output	reg	[`MEM_LEN_BUS]		mem_memLen;
	output	reg	[`REG_BUS]			mem_regDest;
	output	reg	[`WORD_BUS]			mem_value;

	always @(posedge clk) begin
		if (rst) begin
			mem_memOp <= 0;
			mem_memAddr <= 0;
			mem_memLen <= 0;
			mem_regDest <= 0;
			mem_value <= 0;
		end else begin
			mem_memOp <= ex_memOp;
			mem_memAddr <= ex_memAddr;
			mem_memLen <= ex_memLen;
			mem_regDest <= ex_regDest;
			mem_value <= ex_value;
		end
	end

endmodule
