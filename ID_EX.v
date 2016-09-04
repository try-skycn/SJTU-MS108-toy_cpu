`include "define.v"

module ID_EX(
	input	wire					clk,
	input	wire					rst,

	input	wire[`EX_OP_BUS]		id_exop,
	input	wire[`WORD_BUS]			id_srcLeft,
	input	wire[`WORD_BUS]			id_srcRight,
	input	wire[`WORD_BUS]			id_offset,
	input	wire[`REG_ADDR_BUS]		id_dest,

	output	reg	[`ALU_NUM]			ex_alusel,
	output	reg	[`EX_OP_LOW_BUS]	ex_aluop,
	output	reg	[`WORD_BUS]			ex_srcLeft,
	output	reg	[`WORD_BUS]			ex_srcRight,
	output	reg	[`WORD_BUS]			ex_offset,

	output	reg	[`MEM_OP_BUS]		ex_memop,
	output	reg	[`REG_ADDR_BUS]		ex_dest,
	output	reg						ex_writeEnable
);

	always @(posedge clk) begin
		if (rst) begin
			ex_alusel <= `ALU_NOP;
			ex_aluop <= `EX_SPECIAL_NOP;
			ex_srcLeft <= `ZERO_WORD;
			ex_srcRight <= `ZERO_WORD;
			ex_imm <= 16'b0;
			ex_memop <= `MEM_OP_NOP;
			ex_dest <= `REG_ZERO;
			ex_writeEnable <= `DISABLE;
		end else begin
			ex_srcLeft <= id_srcLeft;
			ex_srcRight <= id_srcRight;
			ex_offset <= id_offset;
			ex_dest <= id_dest;

			ex_aluop <= id_exop[`EX_OP_LOW_BUS];
			case (id_exop[`EX_OP_HIGH_BUS])
				`EX_HIGH_LOGIC: begin
					ex_alusel <= `ALU_LOGIC;
					ex_memop <= `MEM_OP_WRITE_REG;
					ex_writeEnable <= `ENABLE;
				end
				default: begin
					ex_alusel <= `ALU_NOP;
					ex_memop <= `MEM_OP_NOP;
					ex_writeEnable <= `DISABLE;
				end
			endcase
		end
	end

endmodule
