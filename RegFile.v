`include "define.v"

module RegFile(
	clk,
	writeEnable, writeAddr, writeValue,
	readAddr1, readValue1,
	readAddr2, readValue2
);

	input	wire						clk;

	input	wire						writeEnable;
	input	wire[`REG_NUM_LOG - 1 : 0]	writeAddr;
	input	wire[`WORD_WIDTH - 1 : 0]	writeValue;

	input	wire[`REG_NUM_LOG - 1 : 0]	readAddr1;
	output	reg	[`WORD_WIDTH - 1 : 0]	readValue1 = 0;

	input	wire[`REG_NUM_LOG - 1 : 0]	readAddr2;
	output	reg	[`WORD_WIDTH - 1 : 0]	readValue2 = 0;

			reg	[`WORD_WIDTH - 1 : 0]	registers[`REG_NUM - 1 : 0];

	initial begin
		$readmemb("RegistersInit.bin", registers);
	end

	always @(negedge clk) begin
		if (writeEnable && writeAddr != 0) begin
			registers[writeAddr] <= writeValue;
		end
	end

	always @(*) begin
		readValue1 <= registers[readAddr1];
	end

	always @(*) begin
		readValue2 <= registers[readAddr2];
	end

endmodule