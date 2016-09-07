module EX_MEM(
	input	wire						clk,				//= clk
	input	wire						rst,				//= rst

	input	wire[`MEM_OP_BUS]			ex_memop,			//= ID_EX::ex_memop
	input	wire[`WORD_BUS]				ex_result,			//= EX::o_result
	input	wire[`MEM_ADDR_BUS]			ex_ramAddr,			//= ALU_MEMACC::ramAddr
	input	wire[`MEM_SEL_BUS]			ex_ramSel,			//= ALU_MEMACC::ramSel
	input	wire[`MEM_LOADOP_BUS]		ex_loadop,			//= ALU_MEMACC::loadop
	input	wire[`REG_ADDR_BUS]			ex_regDest,			//= ID_EX::ex_dest

	output	reg	[`MEM_OP_BUS]			mem_memop,			//= mem_memop
	output	reg	[`WORD_BUS]				mem_exresult,		//= mem_exresult

	output	wire						mem_ramWriteEnable,	//=> o_ramWriteEnable
	output	wire						mem_ramReadEnable,	//= mem_ramReadEnable
	output	reg	[`MEM_ADDR_HIGH_BUS]	mem_ramAddr,		//= mem_ramAddr
	output	reg	[`MEM_SEL_BUS]			mem_ramSel,			//=> o_ramSel
	output	reg	[`MEM_LOADOP_BUS]		mem_loadop,			//= mem_loadop
	output	wire[`MEM_ADDR_LOW_BUS]		mem_ramLowAddr,		//= mem_ramLowAddr
	
	output	wire						mem_regWriteEnable,	//= mem_regWriteEnable
	output	reg	[`REG_ADDR_BUS]			mem_regDest			//= mem_regDest
);

	assign mem_memWriteEnable = (mem_memop == `MEM_OP_STORE);
	assign mem_memReadEnable = (mem_memop == `MEM_OP_LOAD);
	assign mem_ramLowAddr = mem_ramAddr[`MEM_ADDR_LOW_BUS];
	assign mem_regWriteEnable = mem_memop[`MEM_REGENABLE];

	always @(posedge clk) begin
		if (rst) begin
			mem_memop <= 0;
			mem_exresult <= `ZERO_WORD;
			mem_ramAddr <= `ZERO_WORD;
			mem_ramSel <= 4'b0000;
			mem_loadop <= `MEM_LOADOP_NOP;
			mem_regDest <= `REG_ZERO;
		end else begin
			mem_memop <= ex_memop;
			mem_exresult <= ex_result;

			mem_ramAddr <= ex_ramAddr;
			mem_ramSel <= ex_ramSel;
			mem_loadop <= ex_loadop;

			mem_regDest <= ex_regDest;
		end
	end

endmodule
