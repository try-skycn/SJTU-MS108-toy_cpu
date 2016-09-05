`include "define.v"

module CPU(
	input	wire					clk,
	input	wire					rst,

	output	wire					o_chipEnable,
	output	wire[`INST_ADDR_BUS]	o_romAddr,
	input	wire[`INST_BUS]			i_romInst
);

	// PCReg
	wire[`INST_ADDR_BUS]		pc;					// pc

	// IF_ID
	wire[`INST_ADDR_BUS]		id_pc;				// id_pc
	wire[`RAW_OPCODE_BUS]		id_opcode;			// id_opcode
	wire[`RAW_SHAMT_BUS]		id_sa;				// id_sa
	wire[`RAW_FUNCT_BUS]		id_fn;				// id_fn
	wire[`REG_ADDR_BUS]			id_rs;				// id_rs
	wire[`REG_ADDR_BUS]			id_rt;				// id_rt
	wire[`REG_ADDR_BUS]			id_rd;				// id_rd
	wire[`WORD_BUS]				id_imm;				// id_imm
	wire[`RAW_TARGET_BUS]		id_target;			// id_target

	// ID
	wire[`REG_ADDR_BUS]			id_readAddrLeft;	// o_readAddrLeft
	wire[`REG_ADDR_BUS]			id_readAddrRight;	// o_readAddrRight
	wire[`EX_OP_BUS]			id_exop;			// o_exop
	wire[`WORD_BUS]				id_srcLeft;			// o_srcLeft
	wire[`WORD_BUS]				id_srcRight;		// o_srcRight
	wire[`WORD_BUS]				id_offset;			// o_offset
	wire[`REG_ADDR_BUS]			id_dest;			// o_dest
	wire						id_stall;			// o_stall

	// RegFile
	wire[`WORD_BUS]				readValueLeft;		// readValueLeft
	wire[`WORD_BUS]				readValueRight;		// readValueRight

	// ID_EX
	wire[`ALU_SEL_BUS]			ex_alusel;			// ex_alusel
	wire[`EX_OP_LOW_BUS]		ex_aluop;			// ex_aluop
	wire[`WORD_BUS]				ex_srcLeft;			// ex_srcLeft
	wire[`WORD_BUS]				ex_srcRight;		// ex_srcRight
	wire[`WORD_BUS]				ex_offset;			// ex_offset
	wire[`MEM_OP_BUS]			ex_memop;			// ex_memop
	wire[`REG_ADDR_BUS]			ex_dest;			// ex_dest
	wire						ex_writeEnable;		// ex_writeEnable

	// ALU_LOGIC
	wire[`WORD_BUS]				aluLogic_result;	// result

	// EX_MEM
	wire						mem_memWriteEnable;	// mem_memWriteEnable
	wire						mem_memReadEnable;	// mem_memReadEnable
	wire[`MEM_ADDR_HIGH_BUS]	mem_memAddr;		// mem_memAddr
	wire[`MEM_SEL_BUS]			mem_memSel;			// mem_memSel
	wire[`WORD_BUS]				mem_result;			// mem_result
	wire[`REG_ADDR_BUS]			mem_regDest;		// mem_regDest
	wire						mem_resultSel;		// mem_resultSel

	// MEM_WB
	wire[`REG_ADDR_BUS]			wb_regDest;			// wb_regDest
	wire[`WORD_BUS]				wb_result;			// wb_result

	PCReg inst__PCReg(
		.clk(clk),
		.rst(rst),
		.pc(pc),
		.chipEnable(o_chipEnable)
	);

	IF_ID inst__IF_ID(
		.clk(clk),
		.rst(rst),
		.if_pc(pc),
		.if_inst(i_romInst),
		.id_pc(id_pc),
		.id_opcode(id_opcode),
		.id_sa(id_sa),
		.id_fn(id_fn),
		.id_rs(id_rs),
		.id_rt(id_rt),
		.id_rd(id_rd),
		.id_imm(id_imm),
		.id_target(id_target)
	);

	ID inst__ID(
		.i_pc(id_pc),
		.i_opcode(id_opcode),
		.i_sa(id_sa),
		.i_fn(id_fn),
		.i_rs(id_rs),
		.i_rt(id_rt),
		.i_rd(id_rd),
		.i_imm(id_imm),
		.i_target(id_target),
		.o_readAddrLeft(id_readAddrLeft),
		.o_readAddrRight(id_readAddrRight),
		.i_readValueLeft(readValueLeft),
		.i_readValueRight(readValueRight),
		.i_exDest(ex_dest),
		.i_exResult(aluLogic_result),
		.i_exWriteEnable(ex_writeEnable),
		.i_memDest(mem_regDest),
		.i_memResult(mem_result),
		.o_exop(id_exop),
		.o_srcLeft(id_srcLeft),
		.o_srcRight(id_srcRight),
		.o_offset(id_offset),
		.o_dest(id_dest),
		.o_stall(id_stall)
	);

	RegFile inst__RegFile(
		.clk(clk),
		.rst(rst),
		.writeEnable(1'b1),
		.writeAddr(wb_regDest),
		.writeResult(wb_result),
		.readAddrLeft(id_readAddrLeft),
		.readValueLeft(readValueLeft),
		.readAddrRight(id_readAddrRight),
		.readValueRight(readValueRight)
	);

	ID_EX inst__ID_EX(
		.clk(clk),
		.rst(rst),
		.id_exop(id_exop),
		.id_srcLeft(id_srcLeft),
		.id_srcRight(id_srcRight),
		.id_offset(id_offset),
		.id_dest(id_dest),
		.ex_alusel(ex_alusel),
		.ex_aluop(ex_aluop),
		.ex_srcLeft(ex_srcLeft),
		.ex_srcRight(ex_srcRight),
		.ex_offset(ex_offset),
		.ex_memop(ex_memop),
		.ex_dest(ex_dest),
		.ex_writeEnable(ex_writeEnable)
	);

	ALU_LOGIC inst__ALU_LOGIC(
		.aluEnable(ex_alusel [`ALU_SEL_LOGIC]),
		.op(ex_aluop),
		.srcLeft(ex_srcLeft),
		.srcRight(ex_srcRight),
		.result(aluLogic_result)
	);

	EX_MEM inst__EX_MEM(
		.clk(clk),
		.rst(rst),
		.ex_memop(ex_memop),
		.ex_result(aluLogic_result),
		.ex_memAddr(0),
		.ex_regDest(ex_dest),
		.mem_memWriteEnable(mem_memWriteEnable),
		.mem_memReadEnable(mem_memReadEnable),
		.mem_memAddr(mem_memAddr),
		.mem_memSel(mem_memSel),
		.mem_result(mem_result),
		.mem_regDest(mem_regDest),
		.mem_resultSel(mem_resultSel)
	);

	MEM_WB inst__MEM_WB(
		.clk(clk),
		.rst(rst),
		.mem_regDest(mem_regDest),
		.mem_result(mem_result),
		.wb_regDest(wb_regDest),
		.wb_result(wb_result)
	);


assign o_romAddr = pc;

endmodule
