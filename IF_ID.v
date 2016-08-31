`include "define.v"

module IF_ID(
	clk, rst,
	ifPC, ifInst,
	idPC, idInst
);
	
	input	wire								clk;
	input	wire								rst;

	input	wire[`INST_ADDR_WIDTH - 1 : 0]		ifPC;
	input	wire[`INST_WIDTH - 1 : 0]			ifInst;

	output	reg	[`INST_ADDR_WIDTH - 1 : 0]		idPC = 0;
	output	reg	[`INST_WIDTH - 1 : 0]			idInst = 0;

	always @(posedge clk) begin
		if (rst) begin
			idPC <= `ZERO_WORD;
			idInst <= `ZERO_WORD;
		end else begin
			idPC <= ifPC;
			idInst <= ifInst;
		end
	end

endmodule
