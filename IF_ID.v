`include "define.v"

module IF_ID(
	input	wire					clk,
	input	wire					rst,

	input	wire[`INST_ADDR_BUS]	if_pc,
	input	wire[`INST_BUS]			if_Inst,

	output	reg	[`INST_ADDR_BUS]	id_pc,
	output	reg	[`RAW_OPCODE_BUS]	id_opcode,
	output	reg	[`REG_BUS]			id_rs,
	output	reg	[`REG_BUS]			id_rt,
	output	reg	[`REG_BUS]			id_rd,
	output	reg	[`WORD_BUS]			id_Imm
);

	always @(posedge clk) begin
		if (rst) begin
			id_pc <= `ZERO_WORD;
			id_inst <= `ZERO_WORD;
			id_Read1 <= 0;
			id_Read2 <= 0;
			id_Imm <= 0;
		end else begin
			id_pc <= if_pc;
			id_inst <= if_inst;
			id_Read1 <= if_inst[`REG_SRC1_BUS];
			id_Read2 <= if_inst[`REG_SRC2_BUS];
			id_Imm <= {{16{if_inst[15]}}, if_inst[`IMM_BUS]};
		end
	end

endmodule
