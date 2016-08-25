`include "define.v"

module pc_reg(
	input wire clk,
	input wire rst,

	output reg[`InstAddrBus] pc = 32'h0,
	output reg ce = 1'b1
);
	
	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			ce <= `ChipDisable;
		end else begin
			ce <= `ChipEnable;
		end
	end

	always @ (posedge clk) begin
		if (ce == `ChipEnable) begin
			pc <= pc + 4'h4;
		end else begin
			pc <= `ZeroWord;
		end
	end

endmodule
