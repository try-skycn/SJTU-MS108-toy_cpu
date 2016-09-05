`include "define.v"

module MEM_WB(
	input	wire					clk,			//= clk
	input	wire					rst,			//= rst

	input	wire[`REG_ADDR_BUS]		mem_regDest,	//= EX_MEM::mem_regDest
	input	wire[`WORD_BUS]			mem_result,		//= EX_MEM::mem_result

	output	reg	[`REG_ADDR_BUS]		wb_regDest,		//= wb_regDest
	output	reg	[`WORD_BUS]			wb_result		//= wb_result
);

	always @(posedge clk) begin
		if (rst) begin
			wb_regDest <= 0;
			wb_result <= 0;
		end else begin
			wb_regDest <= mem_regDest;
			wb_result <= mem_result;
		end
	end

endmodule
