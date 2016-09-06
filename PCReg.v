module PCReg(
	input	wire							clk,		//= clk
	input	wire							rst,		//= rst

	input	wire							stall_if,	//= `DISABLE

	input	wire							takeBranch,	//= ID::o_takeBranch
	input	wire[`INST_ADDR_BUS]			jpc,		//= ID::o_jpc

	output	reg	[`INST_ADDR_BUS]			pc,			//= pc
	output	reg								chipEnable	//=> o_chipEnable
);

			reg	[`INST_ADDR_BUS]			npc;
	
	always @(posedge clk) begin
		if (rst) begin
			chipEnable <= `DISABLE;
			pc <= `ZERO_WORD;
			npc <= `ZERO_WORD;
		end else if (~stall_if) begin
			chipEnable <= `ENABLE;
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
