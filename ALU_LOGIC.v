`include "define.v"

module ALU_LOGIC(
	input	wire					aluEnable,
	input	wire[`EX_OP_LOW_BUS]	op,
	input	wire[`WORD_BUS]			srcLeft,
	input	wire[`WORD_BUS]			srcRight,

	output	reg	[`WORD_BUS]			result
);

	always @(*) begin
		if (aluEnable) begin
			case (op)
				`EX_LOGIC_AND: result <= srcLeft & srcRight;
				`EX_LOGIC_OR: result <= srcLeft | srcRight;
				`EX_LOGIC_XOR: result <= srcLeft ^ srcRight;
				`EX_LOGIC_NOR: result <= ~(srcLeft | srcRight);
				`EX_LOGIC_LUI: result <= {srcRight[15 : 0], 16'b0};
				default: result <= `ZERO_WORD;
			endcase
		end else begin
			result <= `ZERO_WORD;
		end
	end

endmodule