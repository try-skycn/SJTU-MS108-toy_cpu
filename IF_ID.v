`include "define.v"

module IF_ID(
	clk, rst,
	ifPC, ifInst,
	idPC, idInst, idRead1, idRead2
);
	
	input	wire					clk;
	input	wire					rst;

	input	wire[`INST_ADDR_BUS]	ifPC;
	input	wire[`INST_BUS]			ifInst;

	output	reg	[`INST_ADDR_BUS]	idPC = 0;
	output	reg	[`INST_BUS]			idInst = 0;
	output	reg	[`REG_BUS]			idRead1 = 0;
	output	reg	[`REG_BUS]			idRead2 = 0;

	always @(posedge clk) begin
		if (rst) begin
			idPC <= `ZERO_WORD;
			idInst <= `ZERO_WORD;
			idRead1 <= 0;
			idRead2 <= 0;
		end else begin
			idPC <= ifPC;
			idInst <= ifInst;
			idRead1 <= ifInst[`REG_SRC1_BUS];
			idRead2 <= ifInst[`REG_SRC2_BUS];
		end
	end

endmodule
