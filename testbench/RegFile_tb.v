`include "RegFile.v"

module RegFile_tb;

	reg							clk = 0;

	reg							writeEnable = 0;
	reg	[`REG_NUM_LOG - 1 : 0]	writeAddr = 0;
	reg	[`WORD_WIDTH - 1 : 0]	writeValue = 0;

	reg	[`REG_NUM_LOG - 1 : 0]	readAddr1 = 0;

	reg	[`REG_NUM_LOG - 1 : 0]	readAddr2 = 0;

	RegFile regFileTest(.clk(clk),
						.writeEnable(writeEnable), .writeAddr(writeAddr), .writeValue(writeValue),
						.readAddr1(readAddr1),
						.readAddr2(readAddr2));

	initial begin
		forever #5 clk = ~clk;
	end

	initial begin
		$dumpfile("RegFile_tb.vcd");
		$dumpvars;
		#50 $finish;
	end

	initial begin
		readAddr1 = 3;
		readAddr2 = 2;

		#5
		writeAddr <= 3;
		writeValue <= 37;
		writeEnable <= `ENABLE;

		#10
		writeAddr <= 2;
		writeValue <= 15;
		writeEnable <= `ENABLE;

		// #8
		// readAddr2 = 4;
	end

endmodule
