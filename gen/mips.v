`include "define.v"

module MIPS(
	input	wire	clk,
	input	wire	rst
);

	// CPU
	wire					romEnable;		// o_romEnable
	wire[`INST_ADDR_BUS]	romAddr;		// o_romAddr
	wire					ramReadEnable;	// o_ramReadEnable
	wire					ramWriteEnable;	// o_ramWriteEnable
	wire[`MEM_ADDR_BUS]		ramAddr;		// o_ramAddr
	wire[`MEM_SEL_BUS]		ramSel;			// o_ramSel
	wire[`WORD_BUS]			ramStoreData;	// o_ramStoreData

	// InstRom
	wire[`INST_BUS]			romInst;		// inst

	// DataRam
	wire[`WORD_BUS]			ramLoadData;	// loadData

	CPU inst__CPU(
		.clk(clk),
		.rst(rst),
		.o_romEnable(romEnable),
		.o_romAddr(romAddr),
		.i_romInst(romInst),
		.o_ramReadEnable(ramReadEnable),
		.o_ramWriteEnable(ramWriteEnable),
		.o_ramAddr(ramAddr),
		.o_ramSel(ramSel),
		.o_ramStoreData(ramStoreData),
		.i_ramLoadData(ramLoadData)
	);

	InstRom inst__InstRom(
		.chipEnable(romEnable),
		.addr(romAddr),
		.inst(romInst)
	);

	DataRam inst__DataRam(
		.clk(clk),
		.re(ramReadEnable),
		.we(ramWriteEnable),
		.addr(ramAddr),
		.sel(ramSel),
		.storeData(ramStoreData),
		.loadData(ramLoadData)
	);


endmodule
