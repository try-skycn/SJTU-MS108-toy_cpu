`include "define.v"

module ID_EX(
	clk, rst,
	id_exOp, id_src1, id_src2, id_regDest, id_writeReg,
	ex_exOp, ex_regDest, ex_writeReg
);
	
	input	wire					clk;
	input	wire					rst;

	input	wire[`ALU_OP_BUS]		id_exOp;
	input	wire[`WORD_BUS]			id_src1;
	input	wire[`WORD_BUS]			id_src2;
	input	wire[`REG_BUS]			id_regDest;
	input	wire					id_writeReg;

	output	reg	[`ALU_OP_BUS]		ex_exOp;
	output	reg	[`REG_BUS]			ex_regDest;
	output	reg						ex_writeReg;

	always @(posedge clk) begin
		if (rst) begin
			ex_exOp <= 0;
			ex_regDest <= 0;
			ex_writeReg <= 0;
		end else begin
			ex_regDest <= id_regDest;
			case (id_exOp[`ALU_CHIP_BUS])
				`ALU_CHIP_LOGIC:
			endcase
		end
	end

endmodule
