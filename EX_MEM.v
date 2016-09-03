`include "define.v"

module EX_MEM(
	input	wire					clk,
	input	wire					rst,

	input	wire[`MEM_OP_BUS]		ex_memOp,
	input	wire[`MEM_ADDR_BUS]		ex_memAddr,
	input	wire[`REG_BUS]			ex_regDest,
	input	wire[`WORD_BUS]			ex_value,

	output	reg						mem_memWriteEnable,
	output	reg						mem_memReadEnable,
	output	reg	[`MEM_ADDR_BUS]		mem_memAddr,
	output	reg	[`MEM_LEN_BUS]		mem_memSel,
	
	output	reg						mem_regWriteEnable,
	output	reg	[`REG_BUS]			mem_regDest,
	output	reg	[`WORD_BUS]			mem_value,
	output	reg						mem_valSel
);

	always @(posedge clk) begin
		if (rst) begin
			mem_memWriteEnable <= 0;
			mem_memReadEnable <= 0;
			mem_memAddr <= 0;
			mem_memSel <= 0;
			mem_regWriteEnable <= 0;
			mem_regDest <= 0;
			mem_value <= 0;
			mem_valSel <= 0;
		end else begin
			case (ex_memOp)
				`MEM_OP_WRITE_REG: begin
					mem_memWriteEnable <= `DISABLE;
					mem_memReadEnable <= `DISABLE;
					mem_memAddr <= 0;
					mem_memSel <= 0;

					mem_regWriteEnable <= `ENABLE;
					mem_regDest <= ex_regDest;
					mem_value <= ex_value;
					mem_valSel <= `MEM_SEL_REGVAL;
				end
			endcase
		end
	end

endmodule
