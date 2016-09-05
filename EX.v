module EX(
	input	wire	[`WORD_BUS]			i_aluLogic,		//= ALU_LOGIC::result
	output	triand	[`WORD_BUS]			o_result		//= ex_result
);
	
	assign o_result = i_aluLogic;

endmodule
