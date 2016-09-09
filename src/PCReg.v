module PCReg(
	input	wire							clk,		//= clk
	input	wire							rst,		//= rst

	input	wire							stall_if,	//= CTRL::stall_if

	input	wire							takeBranch,	//= ID::o_takeBranch
	input	wire[`INST_ADDR_BUS]			jpc,		//= ID::o_jpc

	output	reg	[`INST_ADDR_BUS]			pc,			//= pc
	output	reg								romEnable	//=> o_romEnable
);

			reg	[`INST_ADDR_BUS]			npc;
	
	always @(posedge clk) begin
		if (rst) begin
			romEnable <= `DISABLE;
			pc <= `ZERO_WORD;
			npc <= `ZERO_WORD;
		end else if (~stall_if) begin
			romEnable <= `ENABLE;
			if (takeBranch) begin
				pc <= jpc;
				npc <= jpc + 4;
			end else begin
				pc <= npc;
				npc <= npc + 4;
			end
		end
	end

endmodule
