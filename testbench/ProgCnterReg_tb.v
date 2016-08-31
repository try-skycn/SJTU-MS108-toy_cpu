`include "ProgCnterReg.v"
`timescale 1ns/1ns

module ProgCnterReg_tb;
	reg clock = 1;
	reg reset = 0;

	ProgCnterReg regTest(.clock(clock), .reset(reset));

	initial begin
		forever #1 clock = ~clock;
	end

	initial begin
		forever #3 reset = ~reset;
	end

	initial begin
		$dumpfile("ProgCnterReg_tb.vcd");
		$dumpvars;
		#30 $finish;
	end
endmodule
