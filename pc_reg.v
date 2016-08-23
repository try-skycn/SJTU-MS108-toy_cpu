module pc_reg(
	input wire clk,
	input wire rst,

	output reg[`InstAddrBus] pc,
	output reg ce
);

	always @ (postedge clk) begin
		if (rst == `RstEnable) begin
			ce <= `ChipDisable;
		end else begin
			ce <= `ChipEnable;
		end
	end

	always @ (postedge clk) begin
		if (ce == `ChipEnable) begin
			pc <= pc + 4'h4;
		end else begin
			pc <= 32'h0
		end
	end

endmodule