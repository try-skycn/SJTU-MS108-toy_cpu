`include "define.v"

module ALU_LOGIC(
	input	wire					aluEnable;
	input	wire[`EX_OP_LOW_BUS]	op,
	input	wire[`WORD_BUS]			srcl,
	input	wire[`WORD_BUS]			srcr,

	output	reg	[`WORD_BUS]			result
);

	always @(*) begin
		if (aluEnable) begin
			case (op[`EX_OP_CONCRETE_BUS])
				`EX_LOGIC_AND: val <= srcl & srcr;
				`EX_LOGIC_OR: val <= srcl | srcr;
				`EX_LOGIC_XOR: val <= srcl ^ srcr;
				`EX_LOGIC_NOR: val <= ~(srcl | srcr);
				`EX_LOGIC_LUI: val <= {srcr[15 : 0], 16{0}};
				default: val <= `ZERO_WORD;
			endcase
		end else begin
			result <= `ZERO_WORD;
		end
	end

endmodule