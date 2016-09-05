module PCReg(
	input	wire							clk,		//= clk
	input	wire							rst,		//= rst

	output	reg	[`INST_ADDR_BUS]			pc,			//= pc
	output	reg								chipEnable	//=> o_chipEnable
);
	
	always @(posedge clk) begin
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
