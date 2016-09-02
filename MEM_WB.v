`include "define.v"

module MEM_WB(
	clk, rst,
	mem_regDest, mem_value,
	wb_regDest, wb_value
);
	
	input	wire					clk;
	input	wire					rst;

	input	wire[`REG_BUS]			mem_regDest;
	input	wire[`WORD_BUS]			mem_value;

	output	reg	[`REG_BUS]			wb_regDest;
	output	reg	[`WORD_BUS]			wb_value;

	always @(posedge clk) begin
		if (rst) begin
			wb_regDest <= 0;
			wb_value <= 0;
		end else begin
			wb_regDest <= mem_regDest;
			wb_value <= mem_value;
		end
	end

endmodule
