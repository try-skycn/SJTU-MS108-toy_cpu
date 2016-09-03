`include "define.v"

module EX_LOGIC(
	input	wire[`EX_OP_BUS]	op,
	input	wire[`WORD_BUS]		src0,
	input	wire[`WORD_BUS]		src1,

	output	reg	[`WORD_BUS]		val
);

	always @(*) begin
		if (op[`EX_OP_CATE_BUS] == `EX_CATE_LOGIC) begin
			case (op[`EX_OP_CONCRETE_BUS])
				`EX_LOGIC_AND: val <= src0 & src1;
				`EX_LOGIC_OR: val <= src0 | src1;
				`EX_LOGIC_XOR: val <= src0 ^ src1;
				`EX_LOGIC_LUI: val <= {src1[15 : 0], 16{0}};
			endcase
		end else begin
			val <= 0;
		end
	end

endmodule