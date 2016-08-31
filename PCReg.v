`include "define.v"

module PCReg(clk, rst, pc, chipEnable);

	input	wire							clk;
	input	wire							rst;

	output	reg	[`INST_ADDR_WIDTH - 1 : 0]	pc = 0;
	output	reg								chipEnable;
	
	always @(clk) begin
		if (rst) begin
			chipEnable <= `DISABLE;
		end else begin
			chipEnable <= `ENABLE;
		end
	end

	always @ (posedge clk) begin
		if (chipEnable) begin
			pc <= pc + 4'h4;
		end else begin
			pc <= `ZERO_WORD;
		end
	end

endmodule
