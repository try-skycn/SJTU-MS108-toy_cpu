module CPU(
	input	wire					clk,				//= clk
	input	wire					rst,				//= rst

	output	wire					o_romEnable,		//= romEnable
	output	wire[`INST_ADDR_BUS]	o_romAddr,			//= romAddr
	input	wire[`INST_BUS]			i_romInst,			//= InstRom::inst

	output	wire					o_ramReadEnable,	//= ramReadEnable
	output	wire					o_ramWriteEnable,	//= ramWriteEnable
	output	wire[`MEM_ADDR_BUS]		o_ramAddr,			//= ramAddr
	output	wire[`MEM_SEL_BUS]		o_ramSel,			//= ramSel
	output	wire[`WORD_BUS]			o_ramStoreData,		//= ramStoreData
	input	wire[`WORD_BUS]			i_ramLoadData		//= DataRam::loadData
);

	// CTRL
	wire					ctrl_stall_if;		// stall_if
	wire					ctrl_stall_id;		// stall_id
	wire					ctrl_stall_ex;		// stall_ex
	wire					ctrl_stall_mem;		// stall_mem

	// PCReg
	wire[`INST_ADDR_BUS]	pc;					// pc

	// IF_ID
	wire[`INST_ADDR_BUS]	id_pc;				// id_pc
	wire[`INST_BUS]			id_inst;			// id_inst

	// ID
	wire					id_readEnableLeft;	// o_readEnableLeft
	wire					id_readEnableRight;	// o_readEnableRight
	wire[`EX_OP_BUS]		id_exop;			// o_exop
	wire[`REG_ADDR_BUS]		id_dest;			// o_dest
	wire[`WORD_BUS]			id_srcLeft;			// o_srcLeft
	wire[`WORD_BUS]			id_srcRight;		// o_srcRight
	wire					id_takeBranch;		// o_takeBranch
	wire[`INST_BUS]			id_nPC;				// o_jpc

	// RegFile
	wire[`WORD_BUS]			readValueLeft;		// readValueLeft
	wire[`WORD_BUS]			readValueRight;		// readValueRight
	wire					id_stall;			// stall

	// ID_EX
	wire[`INST_BUS]			ex_inst;			// ex_inst
	wire[`EX_OP_HIGH_BUS]	ex_alusel;			// ex_alusel
	wire[`EX_OP_LOW_BUS]	ex_aluop;			// ex_aluop
	wire[`WORD_BUS]			ex_srcLeft;			// ex_srcLeft
	wire[`WORD_BUS]			ex_srcRight;		// ex_srcRight
	wire[`MEM_OP_BUS]		ex_memop;			// ex_memop
	wire[`REG_ADDR_BUS]		ex_dest;			// ex_dest
	wire					ex_writeEnable;		// ex_writeEnable

	// ALU_LOGIC
	wire[`WORD_BUS]			aluLogic_result;	// result
	wire					aluLogic_we;		// o_we
	wire[`WORD_BUS]			aluLogic_hi;		// o_hi
	wire[`WORD_BUS]			aluLogic_lo;		// o_lo

	// ALU_ARITH
	wire[`WORD_BUS]			aluArith_result;	// result
	wire					aluArith_overflow;	// overflow
	wire					aluArith_we;		// o_we
	wire[`WORD_BUS]			aluArith_hi;		// o_hi
	wire[`WORD_BUS]			aluArith_lo;		// o_lo

	// ALU_MEMACC
	wire[`WORD_BUS]			aluMemacc_result;	// result
	wire[`MEM_ADDR_BUS]		aluMemacc_ramAddr;	// ramAddr
	wire[`MEM_SEL_BUS]		aluMemacc_ramSel;	// ramSel
	wire[`MEM_LOADOP_BUS]	aluMemacc_loadop;	// loadop

	// HILO
	wire[`WORD_BUS]			lo;					// hi
	wire[`WORD_BUS]			hi;					// lo

	// EX
	wire[`WORD_BUS]			ex_result;			// o_result

	// EX_MEM
	wire[`MEM_OP_BUS]		mem_memop;			// mem_memop
	wire[`WORD_BUS]			mem_exresult;		// mem_exresult
	wire					mem_ramReadEnable;	// mem_ramReadEnable
	wire[`MEM_ADDR_BUS]		mem_ramAddr;		// mem_ramAddr
	wire[`MEM_LOADOP_BUS]	mem_loadop;			// mem_loadop
	wire[`MEM_ADDR_LOW_BUS]	mem_ramLowAddr;		// mem_ramLowAddr
	wire					mem_regWriteEnable;	// mem_regWriteEnable
	wire[`REG_ADDR_BUS]		mem_regDest;		// mem_regDest

	// MEM
	wire[`WORD_BUS]			memResult;			// result

	CTRL inst__CTRL(
		.stall_req_id(id_stall),
		.stall_req_ex(1'b0),
		.stall_req_mem(1'b0),
		.stall_if(ctrl_stall_if),
		.stall_id(ctrl_stall_id),
		.stall_ex(ctrl_stall_ex),
		.stall_mem(ctrl_stall_mem)
	);

	PCReg inst__PCReg(
		.clk(clk),
		.rst(rst),
		.stall_if(ctrl_stall_if),
		.takeBranch(id_takeBranch),
		.jpc(id_nPC),
		.pc(pc),
		.romEnable(o_romEnable)
	);

	IF_ID inst__IF_ID(
		.clk(clk),
		.rst(rst),
		.kill(id_takeBranch),
		.stall_if(ctrl_stall_if),
		.stall_id(ctrl_stall_id),
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
		.o_srcRight(id_srcRight),
		.o_takeBranch(id_takeBranch),
		.o_jpc(id_nPC)
	);

	RegFile inst__RegFile(
		.clk(clk),
		.rst(rst),
		.writeEnable(mem_regWriteEnable),
		.writeAddr(mem_regDest),
		.writeResult(memResult),
		.readEnableLeft(id_readEnableLeft),
		.readAddrLeft(id_inst [`INST_RS_BUS]),
		.readValueLeft(readValueLeft),
		.readEnableRight(id_readEnableRight),
		.readAddrRight(id_inst [`INST_RT_BUS]),
		.readValueRight(readValueRight),
		.exDest(ex_dest),
		.exResult(ex_result),
		.exWriteEnable(ex_writeEnable),
		.stall(id_stall)
	);

	ID_EX inst__ID_EX(
		.clk(clk),
		.rst(rst),
		.stall_id(ctrl_stall_id),
		.stall_ex(ctrl_stall_ex),
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

	ALU_ARITH inst__ALU_ARITH(
		.aluEnable(ex_alusel == `EX_HIGH_ARITH),
		.op(ex_aluop),
		.srcLeft(ex_srcLeft),
		.srcRight(ex_srcRight),
		.result(aluArith_result),
		.overflow(aluArith_overflow),
		.hi(lo),
		.lo(hi),
		.o_we(aluArith_we),
		.o_hi(aluArith_hi),
		.o_lo(aluArith_lo)
	);

	ALU_MEMACC inst__ALU_MEMACC(
		.aluEnable(ex_alusel == `EX_HIGH_MEMACC),
		.op(ex_aluop),
		.srcLeft(ex_srcLeft),
		.srcRight(ex_srcRight),
		.ex_inst(ex_inst),
		.result(aluMemacc_result),
		.ramAddr(aluMemacc_ramAddr),
		.ramSel(aluMemacc_ramSel),
		.loadop(aluMemacc_loadop)
	);

	HILO inst__HILO(
		.clk(clk),
		.rst(rst),
		.we(aluLogic_we | aluArith_we),
		.i_hi(aluLogic_hi | aluArith_hi),
		.i_lo(aluLogic_lo | aluArith_lo),
		.hi(lo),
		.lo(hi)
	);

	EX inst__EX(
		.i_aluLogic(aluLogic_result),
		.i_aluArith(aluArith_result),
		.i_aluMemacc(aluMemacc_result),
		.o_result(ex_result)
	);

	EX_MEM inst__EX_MEM(
		.clk(clk),
		.rst(rst),
		.stall_ex(ctrl_stall_ex),
		.stall_mem(ctrl_stall_mem),
		.ex_memop(ex_memop),
		.ex_result(ex_result),
		.ex_ramAddr(aluMemacc_ramAddr),
		.ex_ramSel(aluMemacc_ramSel),
		.ex_loadop(aluMemacc_loadop),
		.ex_regDest(ex_dest),
		.mem_memop(mem_memop),
		.mem_exresult(mem_exresult),
		.mem_ramWriteEnable(o_ramWriteEnable),
		.mem_ramReadEnable(mem_ramReadEnable),
		.mem_ramAddr(mem_ramAddr),
		.mem_ramSel(o_ramSel),
		.mem_loadop(mem_loadop),
		.mem_ramLowAddr(mem_ramLowAddr),
		.mem_regWriteEnable(mem_regWriteEnable),
		.mem_regDest(mem_regDest)
	);

	MEM inst__MEM(
		.memReadEnable(mem_ramReadEnable),
		.loaddata(i_ramLoadData),
		.loadop(mem_loadop),
		.lowaddr(mem_ramLowAddr),
		.exresult(mem_exresult),
		.result(memResult)
	);


assign o_romAddr = pc;

assign o_ramReadEnable = mem_ramReadEnable;
assign o_ramAddr = mem_ramAddr;
assign o_ramStoreData = mem_exresult;

	initial begin
		$dumpvars(0, clk, rst);
	end

endmodule
