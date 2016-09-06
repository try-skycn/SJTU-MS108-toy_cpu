`include "define.v"

`define INST_MEM_NUM	16

module InstRom(
	input	wire					chipEnable,
	input	wire[`INST_ADDR_BUS]	addr,
	output	reg	[`INST_BUS]			inst
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

endmodule
