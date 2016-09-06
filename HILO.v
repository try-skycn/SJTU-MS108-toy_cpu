module HILO(
	input	wire					clk,	//= clk
	input	wire					rst,	//= rst

	input	wire					we,		//= ALU_LOGIC::o_we
	input	wire[`WORD_BUS]			i_hi,	//= ALU_LOGIC::o_hi
	input	wire[`WORD_BUS]			i_lo,	//= ALU_LOGIC::o_lo

	output	reg	[`WORD_BUS]			hi,		//= lo
	output	reg	[`WORD_BUS]			lo		//= hi
);

	always @(posedge clk) begin
		if (rst) begin
			hi <= `ZERO_WORD;
			lo <= `ZERO_WORD;
		end else if (we) begin
			hi <= i_hi;
			lo <= i_lo;
		end
	end

endmodule
