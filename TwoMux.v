`include "define.v"

module TwoMux(src0, src1, sel, out);

	input	wire[`WORD_BUS]		src0;
	input	wire[`WORD_BUS]		src1;
	input	wire				sel;

	output	reg	[`WORD_BUS]		out;

	always @(*) begin
		case (sel)
			0: out <= src0;
			1: out <= src1;
		endcase
	end

endmodule
