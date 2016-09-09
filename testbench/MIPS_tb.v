`timescale 1ns/1ns
`include "./src/define.v"

module MIPS_tb;

	reg	clk;
	reg	rst;

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	initial begin
		rst = `ENABLE;
		#13
		rst = `DISABLE;
	end

	MIPS instMIPS(.clk(clk), .rst(rst));

	initial begin
		#500 $finish;
	end

endmodule
