`include "PCReg.v"
`timescale 1ns/1ns

module PCReg_tb;
	reg clk = 0;
	reg rst = 0;

	PCReg regTest(.clk(clk), .rst(rst));

	initial begin
		forever #5 clk = ~clk;
	end

	initial begin
		#12
		rst = 1;
	end

	initial begin
		$dumpvars;
		#30 $finish;
	end
endmodule
