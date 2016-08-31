module ProgCnterReg(clock, reset, progCnter, chipEnable);

	`include "Params.v"

	input	wire							clock;
	input	wire							reset;

	output	reg	[INST_ADDR_WIDTH - 1 : 0]	progCnter;
	output	reg								chipEnable;
	
	always @ (*) begin
		chipEnable <= ~reset;
	end

	always @ (posedge clock) begin
		if (chipEnable == ENABLE) begin
			progCnter <= progCnter + 4'h4;
		end else begin
			progCnter <= ZERO_WORD;
		end
	end

endmodule
