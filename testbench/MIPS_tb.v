`include "timescale.v"
`include "define.v"

module MIPS_tb;

	reg	clk;
	reg	rst;

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	initial begin
		rst = `ENABLE;
		#15
		rst = `DISABLE;
	end

	MIPS instMIPS(.clk(clk), .rst(rst));

	initial begin
		$dumpvars;
		#100 $finish;
	end

endmodule
