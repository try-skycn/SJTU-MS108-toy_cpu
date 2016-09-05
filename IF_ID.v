module IF_ID(
	input	wire					clk,		//= clk
	input	wire					rst,		//= rst

	input	wire[`INST_ADDR_BUS]	if_pc,		//= PCReg::pc
	input	wire[`INST_BUS]			if_inst,	//= i_romInst

	output	reg	[`INST_ADDR_BUS]	id_pc,		//= id_pc
	output	reg	[`RAW_OPCODE_BUS]	id_opcode,	//= id_opcode
	output	reg	[`RAW_SHAMT_BUS]	id_sa,		//= id_sa
	output	reg	[`RAW_FUNCT_BUS]	id_fn,		//= id_fn
	output	reg	[`REG_ADDR_BUS]		id_rs,		//= id_rs
	output	reg	[`REG_ADDR_BUS]		id_rt,		//= id_rt
	output	reg	[`REG_ADDR_BUS]		id_rd,		//= id_rd
	output	reg	[`INST_IMM_BUS]			id_imm,		//= id_imm
	output	reg	[`RAW_TARGET_BUS]	id_target	//= id_target
);

	always @(posedge clk) begin
		if (rst) begin
			id_pc <= 0;
			id_opcode <= 0;
			id_sa <= 0;
			id_fn <= 0;
			id_rs <= 0;
			id_rt <= 0;
			id_rd <= 0;
			id_imm <= 0;
		end else begin
			id_pc <= if_pc;
			id_opcode <= if_inst[`INST_OPCODE_BUS];
			id_sa <= if_inst[`INST_SHAMT_BUS];
			id_fn <= if_inst[`INST_FUNCT_BUS];
			id_rs <= if_inst[`INST_RS_BUS];
			id_rt <= if_inst[`INST_RT_BUS];
			id_rd <= if_inst[`INST_RD_BUS];
			id_imm <= if_inst[`INST_IMM_BUS];
		end
	end

endmodule
