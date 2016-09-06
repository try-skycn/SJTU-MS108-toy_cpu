module EX(
	input	wire	[`WORD_BUS]			i_aluLogic,		//= ALU_LOGIC::result
	input	wire	[`WORD_BUS]			i_aluArith,		//= ALU_ARITH::result
	output	trior	[`WORD_BUS]			o_result		//= ex_result
);
	
	assign o_result = i_aluLogic;
	assign o_result = i_aluArith;

endmodule
