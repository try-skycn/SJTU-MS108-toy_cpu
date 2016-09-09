module ALU_ARITH(
	input	wire					aluEnable,	//= ID_EX::ex_alusel == `EX_HIGH_ARITH
	input	wire[`EX_OP_LOW_BUS]	op,			//= ID_EX::ex_aluop
	input	wire[`WORD_BUS]			srcLeft,	//=	ID_EX::ex_srcLeft
	input	wire[`WORD_BUS]			srcRight,	//= ID_EX::ex_srcRight

	output	reg	[`WORD_BUS]			result,		//= aluArith_result
	output	reg						overflow,	//= aluArith_overflow

	input	wire[`WORD_BUS]			hi,			//=	HILO::hi
	input	wire[`WORD_BUS]			lo,			//= HILO::lo
	output	reg						o_we,		//= aluArith_we
	output	reg	[`WORD_BUS]			o_hi,		//= aluArith_hi
	output	reg	[`WORD_BUS]			o_lo		//= aluArith_lo
);

			wire[`WORD_BUS]			addResult;
			wire					addOverflow;
			wire[`WORD_BUS]			subResult;
			wire					subOverflow;
			wire[`WORD_BUS]			lessResult;
			wire[`WORD_BUS]			unsignedLessResult;
			wire[`WORD_BUS]			hi_mulResult;
			wire[`WORD_BUS]			lo_mulResult;
			wire[`WORD_BUS]			hi_unsignedMulResult;
			wire[`WORD_BUS]			lo_unsignedMulResult;

	assign addResult = srcLeft + srcRight;
	assign addOverflow = (srcLeft[31] == srcRight[31]) & (srcLeft[31] != addResult[31]);

	assign subResult = srcLeft - srcRight;
	assign subOverflow = (srcLeft[31] != srcRight[31]) & (srcLeft[31] != addResult[31]);

	assign unsignedLessResult = srcLeft < srcRight;
	assign lessResult = (srcLeft[31] == srcRight[31]) ? ~srcLeft[31] : unsignedLessResult;

	assign {hi_mulResult, lo_mulResult} = {{32{srcLeft[31]}}, srcLeft} * {{32{srcRight[31]}}, srcRight};
	assign {hi_unsignedMulResult, lo_unsignedMulResult} = {32'h0, srcLeft} * {32'h0, srcRight};

	always @(*) begin
		if (aluEnable) begin
			o_hi <= `ZERO_WORD;
			o_lo <= `ZERO_WORD;
			o_we <= `DISABLE;
			case (op)
				`EX_ARITH_ADD: begin
					result <= addResult;
					overflow <= addOverflow;
				end
				`EX_ARITH_ADDU: begin
					result <= addResult;
					overflow <= `DISABLE;
				end
				`EX_ARITH_SUB: begin
					result <= subResult;
					overflow <= subOverflow;
				end
				`EX_ARITH_SUBU: begin
					result <= subResult;
					overflow <= `DISABLE;
				end
				`EX_ARITH_SLT: begin
					result <= {31'h0, lessResult};
					overflow <= `DISABLE;
				end
				`EX_ARITH_SLTU: begin
					result <= {31'h0, unsignedLessResult};
					overflow <= `DISABLE;
				end
				`EX_ARITH_MULT: begin
					result <= `ZERO_WORD;
					{o_hi, o_lo} <= {hi_mulResult, lo_mulResult};
					o_we <= `ENABLE;
				end
				`EX_ARITH_MULTU: begin
					result <= `ZERO_WORD;
					{o_hi, o_lo} <= {hi_unsignedMulResult, lo_unsignedMulResult};
					o_we <= `ENABLE;
				end
			endcase
		end else begin
			result <= `ZERO_WORD;
			o_hi <= `ZERO_WORD;
			o_lo <= `ZERO_WORD;
			o_we <= `DISABLE;
		end
	end

endmodule
