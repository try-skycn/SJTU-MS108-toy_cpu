`include "define.v"

module RegFile(
	input	wire						clk,				//= clk
	input	wire						rst,				//= rst

	input	wire						writeEnable,		//= 1'b1
	input	wire[`REG_ADDR_BUS]			writeAddr,			//= MEM_WB::wb_regDest
	input	wire[`WORD_BUS]				writeResult,		//= MEM_WB::wb_result

	input	wire[`REG_ADDR_BUS]			readAddrLeft,		//= ID::o_readAddrLeft
	output	reg	[`WORD_BUS]				readValueLeft,		//= readValueLeft

	input	wire[`REG_ADDR_BUS]			readAddrRight,		//= ID::o_readAddrRight
	output	reg	[`WORD_BUS]				readValueRight		//= readValueRight
);

			reg	[`WORD_BUS]				registers[`REG_NUM - 1 : 0];

			integer						i;

	always @(posedge clk) begin
		if (rst) begin
			for (i = 0; i < `REG_NUM; i = i + 1) begin
				registers[i] <= 0;
			end
		end
	end

	always @(negedge clk) begin
		if (~rst) begin
			if (writeEnable && writeAddr != `REG_ZERO) begin
				registers[writeAddr] <= writeResult;
			end
		end
	end

	always @(*) begin
		if (rst) begin
			readValueLeft <= 0;
		end else begin
			readValueLeft <= registers[readAddrLeft];
		end
	end

	always @(*) begin
		if (rst) begin
			readValueRight <= 0;
		end else begin
			readValueRight <= registers[readAddrRight];
		end
	end

endmodule