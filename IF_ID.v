`include "define.v"

module IF_ID(
	clk, rst,
	ifPC, ifInst,
	idPC, idInst
);
	
	input	wire					clk;
	input	wire					rst;

	input	wire[`INST_ADDR_BUS]	ifPC;
	input	wire[`INST_BUS]			ifInst;

	output	reg	[`INST_ADDR_BUS]	idPC = 0;
	output	reg	[`INST_BUS]			idInst = 0;

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
