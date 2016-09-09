`define EX_OPERAND(LEFT, RIGHT, IMM, EXOPHIGH, EXOPLOW, DEST, BRANCH, JUMPPC) begin\
			o_readEnableLeft <= LEFT;\
			o_readEnableRight <= RIGHT;\
			immediate <= IMM;\
			o_exop <= {EXOPHIGH, EXOPLOW};\
			o_dest <= DEST;\
			o_takeBranch <= BRANCH;\
			o_jpc <= JUMPPC;\
		end

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
			wire[`WORD_BUS]				upperimm;
			wire[`WORD_BUS]				zesa;

	assign seimm = {{32{imm[15]}}, imm};
	assign zeimm = {32'h0, imm};
	assign upperimm = {imm, 16'h0};
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
	assign btarget = npc + {seimm[29: 0], 2'b00};

	always @(*) begin
		o_readEnableLeft <= `DISABLE;
		o_readEnableRight <= `DISABLE;
		immediate <= `ZERO_WORD;

		o_exop <= {`EX_HIGH_SPECIAL, `EX_SPECIAL_NOP};
		o_dest <= `REG_ZERO;

		o_takeBranch <= `DISABLE;
		o_jpc <= `ZERO_WORD;
		case (opcode)
		`ID_OPCODE_RTYPE: begin
			case (fn)
			// for logic operations
			`ID_FUNCT_AND:          `EX_OPERAND(1, 1,        0,  `EX_HIGH_LOGIC, `EX_LOGIC_AND       ,      rd,   0, 0       )
			`ID_FUNCT_OR:           `EX_OPERAND(1, 1,        0,  `EX_HIGH_LOGIC, `EX_LOGIC_OR        ,      rd,   0, 0       )
			`ID_FUNCT_XOR:          `EX_OPERAND(1, 1,        0,  `EX_HIGH_LOGIC, `EX_LOGIC_XOR       ,      rd,   0, 0       )
			`ID_FUNCT_NOR:          `EX_OPERAND(1, 1,        0,  `EX_HIGH_LOGIC, `EX_LOGIC_NOR       ,      rd,   0, 0       )
			// for shift operations
			`ID_FUNCT_SLL: if (|sa) `EX_OPERAND(0, 1,     zesa,  `EX_HIGH_LOGIC, `EX_LOGIC_SHLEFT    ,      rd,   0, 0       )
			`ID_FUNCT_SRL: if (|sa) `EX_OPERAND(0, 1,     zesa,  `EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTLOG,      rd,   0, 0       )
			`ID_FUNCT_SRA: if (|sa) `EX_OPERAND(0, 1,     zesa,  `EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTARI,      rd,   0, 0       )
			`ID_FUNCT_SLLV:         `EX_OPERAND(1, 1,        0,  `EX_HIGH_LOGIC, `EX_LOGIC_SHLEFT    ,      rd,   0, 0       )
			`ID_FUNCT_SRLV:         `EX_OPERAND(1, 1,        0,  `EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTLOG,      rd,   0, 0       )
			`ID_FUNCT_SRAV:         `EX_OPERAND(1, 1,        0,  `EX_HIGH_LOGIC, `EX_LOGIC_SHRIGHTARI,      rd,   0, 0       )
			// for move operations
			`ID_FUNCT_MFHI:         `EX_OPERAND(0, 0,        0,  `EX_HIGH_LOGIC, `EX_LOGIC_FROMHI    ,      rd,   0, 0       )
			`ID_FUNCT_MFLO:         `EX_OPERAND(0, 0,        0,  `EX_HIGH_LOGIC, `EX_LOGIC_FROMLO    ,      rd,   0, 0       )
			`ID_FUNCT_MTHI:         `EX_OPERAND(1, 0,        0,  `EX_HIGH_LOGIC, `EX_LOGIC_TOHI      ,       0,   0, 0       )
			`ID_FUNCT_MTLO:         `EX_OPERAND(1, 0,        0,  `EX_HIGH_LOGIC, `EX_LOGIC_TOLO      ,       0,   0, 0       )
			// for arithmetic operations
			`ID_FUNCT_ADD:          `EX_OPERAND(1, 1,        0,  `EX_HIGH_ARITH, `EX_ARITH_ADD       ,      rd,   0, 0       )
			`ID_FUNCT_ADDU:         `EX_OPERAND(1, 1,        0,  `EX_HIGH_ARITH, `EX_ARITH_ADDU      ,      rd,   0, 0       )
			`ID_FUNCT_SUB:          `EX_OPERAND(1, 1,        0,  `EX_HIGH_ARITH, `EX_ARITH_SUB       ,      rd,   0, 0       )
			`ID_FUNCT_SUBU:         `EX_OPERAND(1, 1,        0,  `EX_HIGH_ARITH, `EX_ARITH_SUBU      ,      rd,   0, 0       )
			`ID_FUNCT_MULT:         `EX_OPERAND(1, 1,        0,  `EX_HIGH_ARITH, `EX_ARITH_MULT      ,       0,   0, 0       )
			`ID_FUNCT_MULTU:        `EX_OPERAND(1, 1,        0,  `EX_HIGH_ARITH, `EX_ARITH_MULTU     ,       0,   0, 0       )
			// for comparison operations
			`ID_FUNCT_SLT:          `EX_OPERAND(1, 1,        0,  `EX_HIGH_ARITH, `EX_ARITH_SLT       ,      rd,   0, 0       )
			`ID_FUNCT_SLTU:         `EX_OPERAND(1, 1,        0,  `EX_HIGH_ARITH, `EX_ARITH_SLTU      ,      rd,   0, 0       )
			// for jump operations
			`ID_FUNCT_JR:           `EX_OPERAND(1, 0,        0,         4'b0000,  4'b0000            ,       0,   1, jrtarget)
			`ID_FUNCT_JALR:         `EX_OPERAND(1, 0,      npc,  `EX_HIGH_LOGIC, `EX_LOGIC_SELRIGHT  , `REG_RA,   1, jrtarget)
			endcase
		end
		// for logic operations
		`ID_OPCODE_ORI:             `EX_OPERAND(1, 0,    zeimm,  `EX_HIGH_LOGIC, `EX_LOGIC_OR        ,      rt,   0, 0       )
		`ID_OPCODE_XORI:            `EX_OPERAND(1, 0,    zeimm,  `EX_HIGH_LOGIC, `EX_LOGIC_XOR       ,      rt,   0, 0       )
		`ID_OPCODE_ANDI:            `EX_OPERAND(1, 0,    zeimm,  `EX_HIGH_LOGIC, `EX_LOGIC_AND       ,      rt,   0, 0       )
		`ID_OPCODE_LUI:             `EX_OPERAND(0, 0, upperimm,  `EX_HIGH_LOGIC, `EX_LOGIC_OR        ,      rt,   0, 0       )
		// for arithmetic operations
		`ID_OPCODE_ADDI:            `EX_OPERAND(1, 0,    seimm,  `EX_HIGH_ARITH, `EX_ARITH_ADD       ,      rt,   0, 0       )
		`ID_OPCODE_ADDIU:           `EX_OPERAND(1, 0,    seimm,  `EX_HIGH_ARITH, `EX_ARITH_ADDU      ,      rt,   0, 0       )
		// for comparison operations
		`ID_OPCODE_SLTI:            `EX_OPERAND(1, 0,    seimm,  `EX_HIGH_ARITH, `EX_ARITH_SLT       ,      rt,   0, 0       )
		`ID_OPCODE_SLTIU:           `EX_OPERAND(1, 0,    seimm,  `EX_HIGH_ARITH, `EX_ARITH_SLTU      ,      rt,   0, 0       )
		// for jump operations
		`ID_OPCODE_J:               `EX_OPERAND(0, 0,        0,         4'b0000,  4'b0000            ,       0,   1,  jtarget)
		`ID_OPCODE_JAL:             `EX_OPERAND(0, 0,      npc,  `EX_HIGH_LOGIC, `EX_LOGIC_OR        , `REG_RA,   1,  jtarget)
		// for branch operations
		`ID_OPCODE_BEQ:             `EX_OPERAND(1, 1,        0,         4'b0000,  4'b0000            ,       0,  eq, btarget )
		`ID_OPCODE_BNE:             `EX_OPERAND(1, 1,        0,         4'b0000,  4'b0000            ,       0,  ne, btarget )
		`ID_OPCODE_BGTZ:            `EX_OPERAND(1, 0,        0,         4'b0000,  4'b0000            ,       0, gtz, btarget )
		`ID_OPCODE_BLEZ:            `EX_OPERAND(1, 0,        0,         4'b0000,  4'b0000            ,       0, lez, btarget )
		`ID_OPCODE_BRANCH: begin
			case (rt)
			`ID_RT_BLTZ:            `EX_OPERAND(1, 0,        0,         4'b0000,  4'b0000            ,       0, ltz, btarget )
			`ID_RT_BGEZ:            `EX_OPERAND(1, 0,        0,         4'b0000,  4'b0000            ,       0, gez, btarget )
			endcase
		end
		// for load operations
		`ID_OPCODE_LB:              `EX_OPERAND(1, 0,        0, `EX_HIGH_MEMACC, `EX_MEMACC_LB       ,      rt,   0, 0       )
		`ID_OPCODE_LBU:             `EX_OPERAND(1, 0,        0, `EX_HIGH_MEMACC, `EX_MEMACC_LBU      ,      rt,   0, 0       )
		`ID_OPCODE_LH:              `EX_OPERAND(1, 0,        0, `EX_HIGH_MEMACC, `EX_MEMACC_LH       ,      rt,   0, 0       )
		`ID_OPCODE_LHU:             `EX_OPERAND(1, 0,        0, `EX_HIGH_MEMACC, `EX_MEMACC_LHU      ,      rt,   0, 0       )
		`ID_OPCODE_LW:              `EX_OPERAND(1, 0,        0, `EX_HIGH_MEMACC, `EX_MEMACC_LW       ,      rt,   0, 0       )
		// for store operations
		`ID_OPCODE_SB:              `EX_OPERAND(1, 1,        0, `EX_HIGH_MEMACC, `EX_MEMACC_SB       ,       0,   0, 0       )
		`ID_OPCODE_SH:              `EX_OPERAND(1, 1,        0, `EX_HIGH_MEMACC, `EX_MEMACC_SH       ,       0,   0, 0       )
		`ID_OPCODE_SW:              `EX_OPERAND(1, 1,        0, `EX_HIGH_MEMACC, `EX_MEMACC_SW       ,       0,   0, 0       )
		endcase
	end

	initial begin
		$dumpvars(1, o_dest, o_takeBranch, o_jpc);
	end

endmodule
