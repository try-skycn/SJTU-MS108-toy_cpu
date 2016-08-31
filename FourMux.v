`include "define.v"

module FourMux(
	src0, src1, src2, src3,
	sel,
	out
);

	input	wire[`WORD_BUS]		src0;
	input	wire[`WORD_BUS]		src1;
	input	wire[`WORD_BUS]		src2;
	input	wire[`WORD_BUS]		src3;
	input	wire[1 : 0]			sel;

	output	reg	[`WORD_BUS]		out;

	always @(*) begin
		case (sel)
			0: out <= src0;
			1: out <= src1;
			2: out <= src2;
			3: out <= src3;
		endcase
	end

endmodule
