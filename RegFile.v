`include "define.v"

module RegFile(
	clk, rst,
	writeEnable, writeAddr, writeValue,
	readAddr1, readValue1,
	readAddr2, readValue2
);

	input	wire						clk;
	input	wire						rst;

	input	wire						writeEnable;
	input	wire[`REG_NUM_LOG - 1 : 0]	writeAddr;
	input	wire[`WORD_WIDTH - 1 : 0]	writeValue;

	input	wire[`REG_NUM_LOG - 1 : 0]	readAddr1;
	output	reg	[`WORD_WIDTH - 1 : 0]	readValue1;

	input	wire[`REG_NUM_LOG - 1 : 0]	readAddr2;
	output	reg	[`WORD_WIDTH - 1 : 0]	readValue2;

			reg	[`WORD_WIDTH - 1 : 0]	registers[`REG_NUM - 1 : 0];

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
			if (writeEnable && writeAddr != 0) begin
				registers[writeAddr] <= writeValue;
			end
		end
	end

	always @(*) begin
		if (rst) begin
			readValue1 <= 0;
		end else begin
			readValue1 <= registers[readAddr1];
		end
	end

	always @(*) begin
		if (rst) begin
			readValue2 <= 0;
		end else begin
			readValue2 <= registers[readAddr2];
		end
	end

endmodule