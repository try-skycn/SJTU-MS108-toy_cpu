	// PCReg
	wire[`INST_ADDR_WIDTH - 1 : 0]	PCReg__pc
	wire							PCReg__chipEnable

	// IF_ID
	wire[`INST_ADDR_BUS]			IF_ID__id_pc
	wire[`RAW_OPCODE_BUS]			IF_ID__id_opcode
	wire[`RAW_SHAMT_BUS]			IF_ID__id_sa
	wire[`RAW_FUNCT_BUS]			IF_ID__id_fn
	wire[`REG_BUS]					IF_ID__id_rs
	wire[`REG_BUS]					IF_ID__id_rt
	wire[`REG_BUS]					IF_ID__id_rd
	wire[`WORD_BUS]					IF_ID__id_imm
	wire[`RAW_TARGET_BUS]			IF_ID__id_target

	// ID
	wire[`REG_ADDR_BUS]				ID__o_readAddrLeft
	wire[`REG_ADDR_BUS]				ID__o_readAddrRight
	wire[`EX_OP_BUS]				ID__o_exop
	wire[`WORD_BUS]					ID__o_srcLeft
	wire[`WORD_BUS]					ID__o_srcRight
	wire[`WORD_BUS]					ID__o_offset
	wire[`REG_ADDR_BUS]				ID__o_dest
	wire							ID__stall

	// RegFile
	wire[`WORD_WIDTH - 1 : 0]		RegFile__readValueLeft
	wire[`WORD_WIDTH - 1 : 0]		RegFile__readValueRight

	// ID_EX
	wire[`ALU_NUM]					ID_EX__ex_alusel
	wire[`EX_OP_LOW_BUS]			ID_EX__ex_aluop
	wire[`WORD_BUS]					ID_EX__ex_srcLeft
	wire[`WORD_BUS]					ID_EX__ex_srcRight
	wire[`WORD_BUS]					ID_EX__ex_offset
	wire[`MEM_OP_BUS]				ID_EX__ex_memop
	wire[`REG_ADDR_BUS]				ID_EX__ex_dest
	wire							ID_EX__ex_writeEnable

	// ALU_LOGIC
	wire[`WORD_BUS]					ALU_LOGIC__result

	// EX_MEM
	wire							EX_MEM__mem_memWriteEnable
	wire							EX_MEM__mem_memReadEnable
	wire[`MEM_ADDR_HIGH_BUS]		EX_MEM__mem_memAddr
	wire[`MEM_SEL_BUS]				EX_MEM__mem_memSel
	wire[`WORD_BUS]					EX_MEM__mem_result
	wire[`REG_ADDR_BUS]				EX_MEM__mem_regDest
	wire							EX_MEM__mem_resultSel

	// MEM_WB
	wire[`REG_BUS]					MEM_WB__wb_regDest
	wire[`WORD_BUS]					MEM_WB__wb_value

	PCReg inst_PCReg(
		.clk(clk),
		.rst(rst),
		.pc(PCReg__pc),
		.chipEnable(PCReg__chipEnable)
	);

	IF_ID inst_IF_ID(
		.clk(clk),
		.rst(rst),
		.if_pc(),
		.if_inst(),
		.id_pc(IF_ID__id_pc),
		.id_opcode(IF_ID__id_opcode),
		.id_sa(IF_ID__id_sa),
		.id_fn(IF_ID__id_fn),
		.id_rs(IF_ID__id_rs),
		.id_rt(IF_ID__id_rt),
		.id_rd(IF_ID__id_rd),
		.id_imm(IF_ID__id_imm),
		.id_target(IF_ID__id_target)
	);

	ID inst_ID(
		.i_pc(),
		.i_opcode(),
		.i_sa(),
		.i_fn(),
		.i_rs(),
		.i_rt(),
		.i_rd(),
		.i_imm(),
		.i_target(),
		.o_readAddrLeft(ID__o_readAddrLeft),
		.o_readAddrRight(ID__o_readAddrRight),
		.i_readValueLeft(),
		.i_readValueRight(),
		.i_exDest(),
		.i_exResult(),
		.i_exWriteEnable(),
		.i_memDest(),
		.i_memResult(),
		.o_exop(ID__o_exop),
		.o_srcLeft(ID__o_srcLeft),
		.o_srcRight(ID__o_srcRight),
		.o_offset(ID__o_offset),
		.o_dest(ID__o_dest),
		.stall(ID__stall)
	);

	RegFile inst_RegFile(
		.clk(clk),
		.rst(rst),
		.writeEnable(),
		.writeAddr(),
		.writeValue(),
		.readAddrLeft(),
		.readValueLeft(RegFile__readValueLeft),
		.readAddrRight(),
		.readValueRight(RegFile__readValueRight)
	);

	ID_EX inst_ID_EX(
		.clk(clk),
		.rst(rst),
		.id_exop(),
		.id_srcLeft(),
		.id_srcRight(),
		.id_offset(),
		.id_dest(),
		.ex_alusel(ID_EX__ex_alusel),
		.ex_aluop(ID_EX__ex_aluop),
		.ex_srcLeft(ID_EX__ex_srcLeft),
		.ex_srcRight(ID_EX__ex_srcRight),
		.ex_offset(ID_EX__ex_offset),
		.ex_memop(ID_EX__ex_memop),
		.ex_dest(ID_EX__ex_dest),
		.ex_writeEnable(ID_EX__ex_writeEnable)
	);

	ALU_LOGIC inst_ALU_LOGIC(
		.aluEnable;(),
		.op(),
		.srcLeft(),
		.srcRight(),
		.result(ALU_LOGIC__result)
	);

	EX_MEM inst_EX_MEM(
		.clk(clk),
		.rst(rst),
		.ex_memOp(),
		.ex_result(),
		.ex_memAddr(),
		.ex_regDest(),
		.mem_memWriteEnable(EX_MEM__mem_memWriteEnable),
		.mem_memReadEnable(EX_MEM__mem_memReadEnable),
		.mem_memAddr(EX_MEM__mem_memAddr),
		.mem_memSel(EX_MEM__mem_memSel),
		.mem_result(EX_MEM__mem_result),
		.mem_regDest(EX_MEM__mem_regDest),
		.mem_resultSel(EX_MEM__mem_resultSel)
	);

	MEM_WB inst_MEM_WB(
		.clk(clk),
		.rst(rst),
		.mem_regDest(),
		.mem_value(),
		.wb_regDest(MEM_WB__wb_regDest),
		.wb_value(MEM_WB__wb_value)
	);

