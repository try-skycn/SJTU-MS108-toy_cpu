`include "define.v"

module CPU(
	input	wire					clk,
	input	wire					rst,

	output	wire					o_chipEnable,
	output	wire[`INST_ADDR_BUS]	o_romAddr,
	input	wire[`INST_BUS]			i_romInst,
);

	// PCReg
	wire[`INST_ADDR_BUS]		pc;

	// IF_ID
	wire[`INST_ADDR_BUS]		id_pc;
	wire[`RAW_OPCODE_BUS]		id_opcode;
	wire[`RAW_SHAMT_BUS]		id_sa;
	wire[`RAW_FUNCT_BUS]		id_fn;
	wire[`REG_BUS]				id_rs;
	wire[`REG_BUS]				id_rt;
	wire[`REG_BUS]				id_rd;
	wire[`WORD_BUS]				id_imm;
	wire[`RAW_TARGET_BUS]		id_target;

	// ID
	wire[`REG_ADDR_BUS]			o_readAddrLeft;
	wire[`REG_ADDR_BUS]			o_readAddrRight;

	// RegFile
	wire[`WORD_WIDTH - 1 : 0]	readValueLeft;
	wire[`WORD_WIDTH - 1 : 0]	readValueRight;

	PCReg inst_PCReg(
		.clk(clk),
		.rst(clk),

		.pc(pc),
		.chipEnable(o_chipEnable)
	);

	IF_ID inst_IF_ID(
		.clk(clk),
		.rst(clk),

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

	ID inst_ID(
		.i_pc(id_pc),
		.i_opcode(id_opcode),
		.i_sa(id_sa),
		.i_fn(id_fn),
		.i_rs(id_rs),
		.i_rt(id_rt),
		.i_rd(id_rd),
		.i_imm(id_imm),
		.i_target(id_target),

		.o_readAddrLeft(o_readAddrLeft),
		.o_readAddrRight(o_readAddrRight),

		.i_readVall(readValueLeft),
		.i_readValr(readValueRight),
		.i_exDest(),
		.i_exResult(),
		.i_exWriteEnable(),
		.i_memDest(),
		.i_memResult(),

		.o_exop(),
		.o_srcl(),
		.o_srcr(),
		.o_offset(),
		.o_dest(),

		.stall()
	);

	RegFile inst_RegFile(
		.clk(clk),
		.rst(clk),

		.writeEnable(),
		.writeAddr(),
		.writeValue(),

		.readAddrLeft(),
		.readValueLeft(readValueLeft),

		.readAddrRight(),
		.readValueRight(readValueRight)
	);

	ID_EX inst_ID_EX(
		.clk(clk),
		.rst(clk),

		.id_exop(),
		.id_srcl(),
		.id_srcr(),
		.id_offset(),
		.id_dest(),

		.ex_alusel(),
		.ex_aluop(),
		.ex_srcl(),
		.ex_srcr(),
		.ex_offset(),

		.ex_memop(),
		.ex_dest(),
		.ex_writeEnable()
	);

	ALU_LOGIC inst_ALU_LOGIC(
		.aluEnable();
		.op(),
		.srcl(),
		.srcr(),

		.result()
	);

	EX_MEM inst_EX_MEM(
		.clk(clk),
		.rst(clk),

		.ex_memOp(),
		.ex_result(),
		.ex_memAddr(),
		.ex_regDest(),

		.mem_memWriteEnable(),
		.mem_memReadEnable(),
		.mem_memAddr(),
		.mem_memSel(),
	
		.mem_result(),
		.mem_regDest(),
		.mem_resultSel()
	);

	MEM_WB inst_MEM_WB(
		.clk(clk),
		.rst(clk),

		.mem_regDest(),
		.mem_value(),

		.wb_regDest(),
		.wb_value()
	);

endmodule
