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
	output	wire[`WORD_BUS]			o_srcRight,			//= id_srcRight

	output	reg						o_takeBranch,		//= id_takeBranch
	output	reg	[`INST_BUS]			o_jpc				//= id_nPC
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

			wire					eq;
			wire					ne;
			wire					nez;
			wire					gez;
			wire					gtz;
			wire					ltz;
			wire					lez;

	assign eq = (o_srcLeft == o_srcRight);
	assign ne = ~eq;
	assign nez = |o_srcLeft;
	assign ltz = o_srcLeft[31];
	assign gez = ~ltz;
	assign gtz = gez & nez;
	assign lez = ltz | (~nez);

			wire[`INST_ADDR_BUS]	npc;
			wire[`INST_ADDR_BUS]	jtarget;
			wire[`INST_ADDR_BUS]	jrtarget;
			wire[`INST_ADDR_BUS]	btarget;

	assign npc = i_pc + 4;
	assign jtarget = {npc[31 : 28], target, 2'b00};
	assign jrtarget = o_srcLeft;
	assign btarget = npc + {seimm[31: 2], 2'b00};

	always @(*) begin
		o_readEnableLeft <= `DISABLE;
		o_readEnableRight <= `DISABLE;
		immediate <= `ZERO_WORD;

		o_exop <= {`EX_HIGH_SPECIAL, `EX_SPECIAL_NOP};
		o_dest <= `REG_ZERO;

		o_takeBranch <= `DISABLE;
		o_jpc <= `ZERO_WORD;
		case (i_inst[`INST_OPCODE_BUS])
			`ID_OPCODE_RTYPE: begin
				case (i_inst[`INST_FUNCT_BUS])
				// for logic operations
					`ID_FUNCT_AND: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_AND};
						o_dest <= rd;
					end
					`ID_FUNCT_OR: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_OR};
						o_dest <= rd;
					end
					`ID_FUNCT_XOR: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_XOR};
						o_dest <= rd;
					end
					`ID_FUNCT_NOR: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_NOR};
						o_dest <= rd;
					end
				// for shift operations
					`ID_FUNCT_SLL: begin
						if (|sa) begin
							immediate <= zesa;
							o_readEnableRight <= `ENABLE;

							o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHLEFT};
							o_dest <= rd;
						end
					end
					`ID_FUNCT_SLLV: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHLEFT};
						o_dest <= rd;
					end
					`ID_FUNCT_SRL: begin
						if (|sa) begin
							immediate <= zesa;
							o_readEnableRight <= `ENABLE;

							o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTLOG};
							o_dest <= rd;
						end
					end
					`ID_FUNCT_SRLV: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTLOG};
						o_dest <= rd;
					end
					`ID_FUNCT_SRA: begin
						if (|sa) begin
							immediate <= zesa;
							o_readEnableRight <= `ENABLE;

							o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTARI};
							o_dest <= rd;
						end
					end
					`ID_FUNCT_SRAV: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTARI};
						o_dest <= rd;
					end
				// for move operations
					`ID_FUNCT_MFHI: begin
						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_FROMHI};
						o_dest <= rd;
					end
					`ID_FUNCT_MFLO: begin
						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_FROMLO};
						o_dest <= rd;
					end
					`ID_FUNCT_MTHI: begin
						o_readEnableLeft <= `ENABLE;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_TOHI};
					end
					`ID_FUNCT_MTLO: begin
						o_readEnableLeft <= `ENABLE;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_TOLO};
					end
				// for arithmetic operations
					`ID_FUNCT_ADD: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_ADD};
						o_dest <= rd;
					end
					`ID_FUNCT_ADDU: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_ADDU};
						o_dest <= rd;
					end
					`ID_FUNCT_SUB: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_SUB};
						o_dest <= rd;
					end
					`ID_FUNCT_SUBU: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_SUBU};
						o_dest <= rd;
					end
					`ID_FUNCT_MULT: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_MULT};
					end
					`ID_FUNCT_MULTU: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_MULTU};
					end
					`ID_FUNCT_SLT: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_SLT};
						o_dest <= rd;
					end
					`ID_FUNCT_SLTU: begin
						o_readEnableLeft <= `ENABLE;
						o_readEnableRight <= `ENABLE;

						o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_SLTU};
					end
				// for jump operations
					`ID_FUNCT_JR: begin
						o_readEnableLeft <= `ENABLE;

						o_takeBranch <= `ENABLE;
						o_jpc <= jrtarget;
					end
					`ID_FUNCT_JALR: begin
						o_readEnableLeft <= `ENABLE;
						immediate <= npc;

						o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_SELRIGHT};
						o_dest <= `REG_RA;

						o_takeBranch <= `ENABLE;
						o_jpc <= jrtarget;
					end
					default: begin
					end
				endcase
			end
		// for logic operations
			`ID_OPCODE_ORI: begin
				o_readEnableLeft <= `ENABLE;
				immediate <= zeimm;

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_OR};
				o_dest <= rt;
			end
			`ID_OPCODE_XORI: begin
				o_readEnableLeft <= `ENABLE;
				immediate <= zeimm;

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_XOR};
				o_dest <= rt;
			end
			`ID_OPCODE_ANDI: begin
				o_readEnableLeft <= `ENABLE;
				immediate <= zeimm;

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_AND};
				o_dest <= rt;
			end
			`ID_OPCODE_LUI: begin
				immediate <= {imm, 16'h0};

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_OR};
				o_dest <= rt;
			end
		// for arithmetic operations
			`ID_OPCODE_ADDI: begin
				o_readEnableLeft <= `ENABLE;
				immediate <= seimm;

				o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_ADD};
				o_dest <= rt;
			end
			`ID_OPCODE_ADDIU: begin
				o_readEnableLeft <= `ENABLE;
				immediate <= seimm;

				o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_ADDU};
				o_dest <= rt;
			end
			`ID_OPCODE_SLTI: begin
				o_readEnableLeft <= `ENABLE;
				immediate <= seimm;

				o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_SLT};
				o_dest <= rt;
			end
			`ID_OPCODE_SLTIU: begin
				o_readEnableLeft <= `ENABLE;
				immediate <= seimm;

				o_exop <= {`EX_HIGH_ARITH, `EX_ARITH_SLTU};
				o_dest <= rt;
			end
		// for jump operations
			`ID_OPCODE_J: begin
				o_takeBranch <= `ENABLE;
				o_jpc <= jtarget;
			end
			`ID_OPCODE_JAL: begin
				immediate <= npc;

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_OR};
				o_dest <= `REG_RA;

				o_takeBranch <= `ENABLE;
				o_jpc <= jtarget;
			end
		// for branch operations
			`ID_OPCODE_BEQ: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `ENABLE;

				o_takeBranch <= eq;
				o_jpc <= btarget;
			end
			`ID_OPCODE_BNE: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `ENABLE;

				o_takeBranch <= ne;
				o_jpc <= btarget;
			end
			`ID_OPCODE_BGTZ: begin
				o_readEnableLeft <= `ENABLE;

				o_takeBranch <= gtz;
				o_jpc <= btarget;
			end
			`ID_OPCODE_BLEZ: begin
				o_readEnableLeft <= `ENABLE;

				o_takeBranch <= lez;
				o_jpc <= btarget;
			end
			`ID_OPCODE_BRANCH: begin
				case (rt)
					`ID_RT_BLTZ: begin
						o_readEnableLeft <= `ENABLE;

						o_takeBranch <= ltz;
						o_jpc <= btarget;
					end
					`ID_RT_BGEZ: begin
						o_readEnableLeft <= `ENABLE;

						o_takeBranch <= gez;
						o_jpc <= btarget;
					end
					default: begin
					end
				endcase
			end
		// for load operations
			`ID_OPCODE_LB: begin
				o_readEnableLeft <= `ENABLE;

				o_exop <= {`EX_HIGH_MEMACC, `EX_MEMACC_LB};
				o_dest <= rt;
			end
			`ID_OPCODE_LBU: begin
				o_readEnableLeft <= `ENABLE;

				o_exop <= {`EX_HIGH_MEMACC, `EX_MEMACC_LBU};
				o_dest <= rt;
			end
			`ID_OPCODE_LH: begin
				o_readEnableLeft <= `ENABLE;

				o_exop <= {`EX_HIGH_MEMACC, `EX_MEMACC_LH};
				o_dest <= rt;
			end
			`ID_OPCODE_LHU: begin
				o_readEnableLeft <= `ENABLE;

				o_exop <= {`EX_HIGH_MEMACC, `EX_MEMACC_LHU};
				o_dest <= rt;
			end
			`ID_OPCODE_LW: begin
				o_readEnableLeft <= `ENABLE;

				o_exop <= {`EX_HIGH_MEMACC, `EX_MEMACC_LW};
				o_dest <= rt;
			end
		// for store operations
			`ID_OPCODE_SB: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `ENABLE;

				o_exop <= {`EX_HIGH_MEMACC, `EX_MEMACC_SB};
				o_dest <= rt;
			end
			`ID_OPCODE_SH: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `ENABLE;

				o_exop <= {`EX_HIGH_MEMACC, `EX_MEMACC_SH};
				o_dest <= rt;
			end
			`ID_OPCODE_SW: begin
				o_readEnableLeft <= `ENABLE;
				o_readEnableRight <= `ENABLE;

				o_exop <= {`EX_HIGH_MEMACC, `EX_MEMACC_SW};
				o_dest <= rt;
			end
			default: begin
			end
		endcase
	end

endmodule
