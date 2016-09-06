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
	wire[`INST_BUS]				id_inst;			// id_inst

	// ID
	wire						id_readEnableLeft;	// o_readEnableLeft
	wire						id_readEnableRight;	// o_readEnableRight
	wire[`EX_OP_BUS]			id_exop;			// o_exop
	wire[`REG_ADDR_BUS]			id_dest;			// o_dest
	wire[`WORD_BUS]				id_srcLeft;			// o_srcLeft
	wire[`WORD_BUS]				id_srcRight;		// o_srcRight

	// RegFile
	wire[`WORD_BUS]				readValueLeft;		// readValueLeft
	wire[`WORD_BUS]				readValueRight;		// readValueRight
	wire						id_stall;			// stall

	// ID_EX
	wire[`INST_BUS]				ex_inst;			// ex_inst
	wire[`EX_OP_HIGH_BUS]		ex_alusel;			// ex_alusel
	wire[`EX_OP_LOW_BUS]		ex_aluop;			// ex_aluop
	wire[`WORD_BUS]				ex_srcLeft;			// ex_srcLeft
	wire[`WORD_BUS]				ex_srcRight;		// ex_srcRight
	wire[`MEM_OP_BUS]			ex_memop;			// ex_memop
	wire[`REG_ADDR_BUS]			ex_dest;			// ex_dest
	wire						ex_writeEnable;		// ex_writeEnable

	// ALU_LOGIC
	wire[`WORD_BUS]				aluLogic_result;	// result
	wire						aluLogic_we;		// o_we
	wire[`WORD_BUS]				aluLogic_hi;		// o_hi
	wire[`WORD_BUS]				aluLogic_lo;		// o_lo

	// HILO
	wire[`WORD_BUS]				lo;					// hi
	wire[`WORD_BUS]				hi;					// lo

	// EX
	wire[`WORD_BUS]				ex_result;			// o_result

	// EX_MEM
	wire[`MEM_OP_BUS]			mem_memop;			// mem_memop
	wire						mem_memWriteEnable;	// mem_memWriteEnable
	wire						mem_memReadEnable;	// mem_memReadEnable
	wire[`MEM_ADDR_HIGH_BUS]	mem_memAddr;		// mem_memAddr
	wire[`MEM_SEL_BUS]			mem_memSel;			// mem_memSel
	wire[`WORD_BUS]				mem_result;			// mem_result
	wire[`REG_ADDR_BUS]			mem_regDest;		// mem_regDest

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
		.id_inst(id_inst)
	);

	ID inst__ID(
		.i_pc(id_pc),
		.i_inst(id_inst),
		.o_readEnableLeft(id_readEnableLeft),
		.o_readEnableRight(id_readEnableRight),
		.o_exop(id_exop),
		.o_dest(id_dest),
		.i_readValueLeft(readValueLeft),
		.i_readValueRight(readValueRight),
		.o_srcLeft(id_srcLeft),
		.o_srcRight(id_srcRight)
	);

	RegFile inst__RegFile(
		.clk(clk),
		.rst(rst),
		.writeEnable(1'b1),
		.writeAddr(wb_regDest),
		.writeResult(wb_result),
		.readEnableLeft(id_readEnableLeft),
		.readAddrLeft(id_inst [`INST_RS_BUS]),
		.readValueLeft(readValueLeft),
		.readEnableRight(id_readEnableRight),
		.readAddrRight(id_inst [`INST_RT_BUS]),
		.readValueRight(readValueRight),
		.exDest(ex_dest),
		.exResult(ex_result),
		.exWriteEnable(ex_writeEnable),
		.memDest(mem_regDest),
		.memResult(mem_result),
		.stall(id_stall)
	);

	ID_EX inst__ID_EX(
		.clk(clk),
		.rst(rst),
		.id_inst(id_inst),
		.id_exop(id_exop),
		.id_srcLeft(id_srcLeft),
		.id_srcRight(id_srcRight),
		.id_dest(id_dest),
		.ex_inst(ex_inst),
		.ex_alusel(ex_alusel),
		.ex_aluop(ex_aluop),
		.ex_srcLeft(ex_srcLeft),
		.ex_srcRight(ex_srcRight),
		.ex_memop(ex_memop),
		.ex_dest(ex_dest),
		.ex_writeEnable(ex_writeEnable)
	);

	ALU_LOGIC inst__ALU_LOGIC(
		.aluEnable(ex_alusel == `EX_HIGH_LOGIC),
		.op(ex_aluop),
		.srcLeft(ex_srcLeft),
		.srcRight(ex_srcRight),
		.result(aluLogic_result),
		.hi(lo),
		.lo(hi),
		.o_we(aluLogic_we),
		.o_hi(aluLogic_hi),
		.o_lo(aluLogic_lo)
	);

	HILO inst__HILO(
		.clk(clk),
		.rst(rst),
		.we(aluLogic_we),
		.i_hi(aluLogic_hi),
		.i_lo(aluLogic_lo),
		.hi(lo),
		.lo(hi)
	);

	EX inst__EX(
		.i_aluLogic(aluLogic_result),
		.o_result(ex_result)
	);

	EX_MEM inst__EX_MEM(
		.clk(clk),
		.rst(rst),
		.ex_memop(ex_memop),
		.ex_result(ex_result),
		.ex_memAddr(0),
		.ex_regDest(ex_dest),
		.mem_memop(mem_memop),
		.mem_memWriteEnable(mem_memWriteEnable),
		.mem_memReadEnable(mem_memReadEnable),
		.mem_memAddr(mem_memAddr),
		.mem_memSel(mem_memSel),
		.mem_result(mem_result),
		.mem_regDest(mem_regDest)
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
