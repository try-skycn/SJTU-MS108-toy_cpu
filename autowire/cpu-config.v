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

/*
	compile module CTRL
	
	compile module PCReg

	compile module IF_ID
	compile module ID
	compile module RegFile

	compile module ID_EX
	compile module ALU_LOGIC
	compile module ALU_ARITH
	compile module ALU_MEMACC
	compile module HILO
	compile module EX

	compile module EX_MEM
	compile module MEM
*/

assign o_romAddr = pc;

assign o_ramReadEnable = mem_ramReadEnable;
assign o_ramAddr = mem_ramAddr;
assign o_ramStoreData = mem_exresult;

	initial begin
		$dumpvars(0, clk, rst);
	end

endmodule