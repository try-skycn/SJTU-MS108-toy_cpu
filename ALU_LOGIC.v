module ALU_LOGIC(
	input	wire					aluEnable,	//= ID_EX::ex_alusel == `EX_HIGH_LOGIC
	input	wire[`EX_OP_LOW_BUS]	op,			//= ID_EX::ex_aluop
	input	wire[`WORD_BUS]			srcLeft,	//=	ID_EX::ex_srcLeft
	input	wire[`WORD_BUS]			srcRight,	//= ID_EX::ex_srcRight

	output	reg	[`WORD_BUS]			result,		//= aluLogic_result

	input	wire[`WORD_BUS]			hi,			//=	HILO::hi
	input	wire[`WORD_BUS]			lo,			//= HILO::lo
	output	reg						o_we,		//= aluLogic_we
	output	reg	[`WORD_BUS]			o_hi,		//= aluLogic_hi
	output	reg	[`WORD_BUS]			o_lo		//= aluLogic_lo
);

	always @(*) begin
		if (aluEnable) begin
			o_hi <= `ZERO_WORD;
			o_lo <= `ZERO_WORD;
			o_we <= `DISABLE;
			case (op)
				`EX_LOGIC_AND: result <= srcLeft & srcRight;
				`EX_LOGIC_OR: result <= srcLeft | srcRight;
				`EX_LOGIC_XOR: result <= srcLeft ^ srcRight;
				`EX_LOGIC_NOR: result <= ~(srcLeft | srcRight);
				`EX_LOGIC_SHLEFT: result <= srcRight << srcLeft[4 : 0];
				`EX_LOGIC_SHRIGHTLOG: result <= srcRight >> srcLeft[4 : 0];
				`EX_LOGIC_SHRIGHTARI: result <= ({32{srcRight[31]}} << (6'd32 - {1'b0, srcLeft[4 : 0]})) | (srcRight >> srcLeft[4 : 0]);
				`EX_LOGIC_FROMHI: result <= hi;
				`EX_LOGIC_FROMLO: result <= lo;
				`EX_LOGIC_TOHI: begin
					result <= `ZERO_WORD;
					o_hi <= srcLeft;
					o_lo <= lo;
					o_we <= `ENABLE;
				end
				`EX_LOGIC_TOLO: begin
					result <= `ZERO_WORD;
					o_hi <= hi;
					o_lo <= srcLeft;
					o_we <= `ENABLE;
				end
				default: result <= `ZERO_WORD;
			endcase
		end else begin
			result <= `ZERO_WORD;
			o_we <= `DISABLE;
			o_hi <= `ZERO_WORD;
			o_lo <= `ZERO_WORD;
		end
	end

endmodule