`include "IF_ID.v"

module IF_ID_tb;

	reg clk = 0;
	reg rst = 1;

	reg[`INST_ADDR_BUS]		ifPC = 0;
	reg[`INST_BUS]			ifInst = 0;

	IF_ID IF_ID_test(.clk(clk), .rst(rst), .ifPC(ifPC), .ifInst(ifInst));

	initial begin
		forever #2 clk = ~clk;
	end

	initial begin
		#3
		rst = 0;

		#2
		ifPC <= 15;
		ifInst <= 23;
	end

	initial begin
		$dumpvars;
		#30 $finish;
	end

endmodule
