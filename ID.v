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

			wire[`INST_OPCODE_BUS]		opcode;
			wire[`INST_RS_BUS]			rs;
			wire[`INST_RT_BUS]			rt;
			wire[`INST_RD_BUS]			rd;
			wire[`INST_SHAMT_BUS]		sa;
			wire[`INST_FUNCT_BUS]		fn;
			wire[`INST_IMM_BUS]			imm;
			wire[`INST_TARGET_BUS]		target;

	assign {opcode, rs, rt, rd, sa, fn} = i_inst;
	assign imm = i_inst[`INST_IMM_BUS];
	assign target = i_inst[`INST_TARGET_BUS];

			wire[`WORD_BUS]				seimm;
			wire[`WORD_BUS]				zeimm;
			wire[`WORD_BUS]				zesa;

	assign seimm = {{32{imm[15]}}, imm};
	assign zeimm = {32'h0, imm};
	assign zesa = {27'h0, sa};

			reg	[`WORD_BUS]			immediate;

	assign o_srcLeft = o_readEnableLeft ? i_readValueLeft : immediate;
	assign o_srcRight = o_readEnableRight ? i_readValueRight : immediate;

	always @(*) begin
		case (i_inst[`INST_OPCODE_BUS])
			`ID_OPCODE_RTYPE: begin
				case (i_inst[`INST_FUNCT_BUS])
				// for logic operations
					`ID_FUNCT_AND: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_AND};
						o_dest <= rd;
					end
					`ID_FUNCT_OR: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_OR};
						o_dest <= rd;
					end
					`ID_FUNCT_XOR: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_XOR};
						o_dest <= rd;
					end
					`ID_FUNCT_NOR: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_NOR};
						o_dest <= rd;
					end
				// for shift operations
					`ID_FUNCT_SLL: begin
						o_readEnableLeft <= `DISABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= zesa;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHLEFT};
						o_dest <= rd;
					end
					`ID_FUNCT_SLLV: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHLEFT};
						o_dest <= rd;
					end
					`ID_FUNCT_SRL: begin
						o_readEnableLeft <= `DISABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= zesa;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTLOG};
						o_dest <= rd;
					end
					`ID_FUNCT_SRLV: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTLOG};
						o_dest <= rd;
					end
					`ID_FUNCT_SRA: begin
						o_readEnableLeft <= `DISABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= zesa;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTARI};
						o_dest <= rd;
					end
					`ID_FUNCT_SRAV: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTARI};
						o_dest <= rd;
					end
				// for move operations
					`ID_FUNCT_MFHI: begin
						o_readEnableLeft <= `DISABLE;
						o_readEnableRight <= `DISABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_FROMHI};
						o_dest <= rd;
					end
					`ID_FUNCT_MFLO: begin
						o_readEnableLeft <= `DISABLE;
						o_readEnableRight <= `DISABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_FROMLO};
						o_dest <= rd;
					end
					`ID_FUNCT_MTHI: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `DISABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_TOHI};
						o_dest <= `REG_ZERO;
					end
					`ID_FUNCT_MTLO: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `DISABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_TOLO};
						o_dest <= `REG_ZERO;
					end
				// for arithmetic operations
					`ID_FUNCT_ADD: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_ADD};
						o_dest <= rd;
					end
					`ID_FUNCT_ADDU: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_ADDU};
						o_dest <= rd;
					end
					`ID_FUNCT_SUB: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_SUB};
						o_dest <= rd;
					end
					`ID_FUNCT_SUBU: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_SUBU};
						o_dest <= rd;
					end
					`ID_FUNCT_MULT: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_MULT};
						o_dest <= `REG_ZERO;
					end
					`ID_FUNCT_MULTU: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_MULTU};
						o_dest <= `REG_ZERO;
					end
					`ID_FUNCT_SLT: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_SLT};
						o_dest <= rd;
					end
					`ID_FUNCT_SLTU: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_SLTU};
						o_dest <= `REG_ZERO;
					end
					default: begin
						o_readEnableLeft <= `DISABLE;
						o_readEnableRight <= `DISABLE;
						immediate <= `ZERO_WORD;

						o_exop <= {`EX_HIGH_SPECIAL, `EX_SPECIAL_NOP};
						o_dest <= `REG_ZERO;
					end
				endcase
			end
		// for logic operations
			`ID_OPCODE_ORI: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `DISABLE;
				immediate <= zeimm;

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_OR};
				o_dest <= rt;
			end
			`ID_OPCODE_XORI: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `DISABLE;
				immediate <= zeimm;

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_XOR};
				o_dest <= rt;
			end
			`ID_OPCODE_ANDI: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `DISABLE;
				immediate <= zeimm;

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_AND};
				o_dest <= rt;
			end
			`ID_OPCODE_LUI: begin
				o_readEnableLeft <= `DISABLE;
				o_readEnableRight <= `DISABLE;
				immediate <= {imm, 16'h0};

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_OR};
				o_dest <= rt;
			end
		// for arithmetic operations
			`ID_OPCODE_ADDI: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `DISABLE;
				immediate <= seimm;

				o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_ADD};
				o_dest <= rt;
			end
			`ID_OPCODE_ADDIU: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `DISABLE;
				immediate <= seimm;

				o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_ADDU};
				o_dest <= rt;
			end
			`ID_OPCODE_SLTI: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `DISABLE;
				immediate <= seimm;

				o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_SLT};
				o_dest <= rt;
			end
			`ID_OPCODE_SLTIU: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `DISABLE;
				immediate <= seimm;

				o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_SLTU};
				o_dest <= rt;
			end
			default: begin
				o_readEnableLeft <= `DISABLE;
				o_readEnableRight <= `DISABLE;
				immediate <= `ZERO_WORD;

				o_exop <= {`EX_HIGH_SPECIAL, `EX_SPECIAL_NOP};
				o_dest <= `REG_ZERO;
			end
		endcase
	end

endmodule
