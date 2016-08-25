`include "pc_reg.v"
`timescale 1ns/1ns

module pc_reg_tb;
	reg clk = 1;
	reg rst = 0;

	pc_reg reg_test(.clk(clk), .rst(rst));

	initial begin
		forever #1 clk = ~clk;
	end

	initial begin
		forever #3 rst = ~rst;
	end

	initial begin
		$dumpfile("pc_reg_tb.vcd");
		$dumpvars;
		#10 $finish;
	end
endmodule
