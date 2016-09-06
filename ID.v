`define	HSEL_BUS		1 : 0
`define HSEL_REG		2'b00
`define HSEL_SA			2'b01
`define	HSEL_ZEIMM		2'b10
`define HSEL_SEIMM		2'b11

`define LSEL_BUS		2 : 0
`define LSEL_REG		3'b000
`define LSEL_SA			3'b001
`define	LSEL_ZEIMM		3'b010
`define LSEL_SEIMM		3'b011
`define LSEL_EX			3'b101
`define	LSEL_MEM		3'b110

module ID(
	input	wire[`INST_ADDR_BUS]	i_pc,				//= IF_ID::id_pc
	input	wire[`INST_BUS]			i_inst,				//= IF_ID::id_inst

	output	reg						o_readEnableLeft,	//= id_readEnableLeft
	output	reg						o_readEnableRight,	//= id_readEnableRight
	output	reg	[`EX_OP_BUS]		o_exop,				//= id_exop
	output	reg	[`REG_ADDR_BUS]		o_dest,				//= id_dest

	input	wire[`WORD_BUS]			i_readValueLeft,	//= RegFile::readValueLeft
	input	wire[`WORD_BUS]			i_readValueRight,	//= RegFile::readValueRight

	output	wire[`WORD_BUS]			o_srcLeft,			//= id_srcLeft
	output	wire[`WORD_BUS]			o_srcRight			//= id_srcRight
);

			reg	[`WORD_BUS]			imm;

	assign o_srcLeft = o_readEnableLeft ? i_readValueLeft : imm;
	assign o_srcRight = o_readEnableRight ? i_readValueRight : imm;

	always @(*) begin
		case (i_inst[`INST_OPCODE_BUS])
			`ID_OPCODE_RTYPE: begin
				case (i_inst[`INST_FUNCT_BUS])
					`ID_FUNCT_AND: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						imm <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_AND};
						o_dest <= i_inst[`INST_RD_BUS];
					end
					`ID_FUNCT_OR: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						imm <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_OR};
						o_dest <= i_inst[`INST_RD_BUS];
					end
					`ID_FUNCT_XOR: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						imm <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_XOR};
						o_dest <= i_inst[`INST_RD_BUS];
					end
					`ID_FUNCT_NOR: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						imm <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_NOR};
						o_dest <= i_inst[`INST_RD_BUS];
					end
					`ID_FUNCT_SLL: begin
						o_readEnableLeft <= `DISABLE;
						o_readEnableRight <= `ENABLE;
						imm <= {27'h0, i_inst[`INST_SHAMT_BUS]};

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHLEFT};
						o_dest <= i_inst[`INST_RD_BUS];
					end
					`ID_FUNCT_SLLV: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						imm <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHLEFT};
						o_dest <= i_inst[`INST_RD_BUS];
					end
					`ID_FUNCT_SRL: begin
						o_readEnableLeft <= `DISABLE;
						o_readEnableRight <= `ENABLE;
						imm <= {27'h0, i_inst[`INST_SHAMT_BUS]};

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTLOG};
						o_dest <= i_inst[`INST_RD_BUS];
					end
					`ID_FUNCT_SRLV: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						imm <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTLOG};
						o_dest <= i_inst[`INST_RD_BUS];
					end
					`ID_FUNCT_SRA: begin
						o_readEnableLeft <= `DISABLE;
						o_readEnableRight <= `ENABLE;
						imm <= {27'h0, i_inst[`INST_SHAMT_BUS]};

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTARI};
						o_dest <= i_inst[`INST_RD_BUS];
					end
					`ID_FUNCT_SRAV: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						imm <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTARI};
						o_dest <= i_inst[`INST_RD_BUS];
					end
					default: begin
						o_readEnableLeft <= `DISABLE;
						o_readEnableRight <= `DISABLE;
						imm <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_SPECIAL, `EX_SPECIAL_NOP};
						o_dest <= `REG_ZERO;
					end
				endcase
			end
			`ID_OPCODE_ORI: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `DISABLE;
				imm <= {16'h0, i_inst[`INST_IMM_BUS]};

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_OR};
				o_dest <= i_inst[`INST_RT_BUS];
			end
			`ID_OPCODE_XORI: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `DISABLE;
				imm <= {16'h0, i_inst[`INST_IMM_BUS]};

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_XOR};
				o_dest <= i_inst[`INST_RT_BUS];
			end
			`ID_OPCODE_ANDI: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `DISABLE;
				imm <= {16'h0, i_inst[`INST_IMM_BUS]};

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_AND};
				o_dest <= i_inst[`INST_RT_BUS];
			end
			`ID_OPCODE_LUI: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `DISABLE;
				imm <= {16'h0, i_inst[`INST_IMM_BUS]};

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_LUI};
				o_dest <= i_inst[`INST_RT_BUS];
			end
			default: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `DISABLE;
				imm <= 32'h0;

				o_exop <= {`EX_HIGH_SPECIAL, `EX_SPECIAL_NOP};
				o_dest <= `REG_ZERO;
			end
		endcase
	end

endmodule
