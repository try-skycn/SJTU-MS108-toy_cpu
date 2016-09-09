`define INST_MEM_NUM	32

module InstRom(
	input	wire					chipEnable,		//= CPU::o_romEnable
	input	wire[`INST_ADDR_BUS]	addr,			//= CPU::o_romAddr
	output	reg	[`INST_BUS]			inst			//= romInst
);

	reg	[`INST_BUS]		instMem[0 : `INST_MEM_NUM - 1];

	initial $readmemh("./compile/rom.txt", instMem);

	always @(*) begin
		if (chipEnable == `ENABLE) begin
			inst <= instMem[addr[`INST_ADDR_HIGH_BUS]];
		end else begin
			inst <= `ZERO_WORD;
		end
	end

	initial begin
		$dumpvars(0, addr, inst);
	end

endmodule
