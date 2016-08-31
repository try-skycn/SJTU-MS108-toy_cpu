`include "TwoMux.v"

module TwoMux_tb;

	reg[`WORD_BUS]	src0 = 0;
	reg[`WORD_BUS]	src1 = 0;
	reg sel = 1;

	TwoMux twoMux_test(.src0(src0), .src1(src1), .sel(sel));

	initial begin
		src0 <= 32;
		src1 <= 78;
		#5
		sel <= 0;
		#5
		src1 <= 65;
		src0 <= 28;
		#5
		sel <= 1;
	end

	initial begin
		$dumpvars;
		#30 $finish;
	end

endmodule
