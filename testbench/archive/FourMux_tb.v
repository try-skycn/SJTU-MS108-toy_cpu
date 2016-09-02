`include "FourMux.v"

module FourMux_tb;

	reg[`WORD_BUS]	src0 = 0;
	reg[`WORD_BUS]	src1 = 0;
	reg[`WORD_BUS]	src2 = 0;
	reg[`WORD_BUS]	src3 = 0;
	reg[1 : 0] sel = 1;

	FourMux FourMux_test(.src0(src0), .src1(src1), .src2(src2), .src3(src3), .sel(sel));

	initial begin
		src0 <= 32;
		src1 <= 78;
		src2 <= 102;
		src3 <= 17;
		#5
		sel <= 3;
		#5
		src2 <= 65;
		src3 <= 28;
		#5
		sel <= 2;
	end

	initial begin
		$dumpvars;
		#30 $finish;
	end

endmodule
