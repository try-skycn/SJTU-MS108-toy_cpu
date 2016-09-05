module EX_MEM(
	input	wire						clk,				//= clk
	input	wire						rst,				//= rst

	input	wire[`MEM_OP_BUS]			ex_memop,			//= ID_EX::ex_memop
	input	wire[`WORD_BUS]				ex_result,			//= EX::o_result
	input	wire[`MEM_ADDR_BUS]			ex_memAddr,			//= 0
	input	wire[`REG_ADDR_BUS]			ex_regDest,			//= ID_EX::ex_dest

	output	reg							mem_memWriteEnable,	//= mem_memWriteEnable
	output	reg							mem_memReadEnable,	//= mem_memReadEnable
	output	reg	[`MEM_ADDR_HIGH_BUS]	mem_memAddr,		//= mem_memAddr
	output	reg	[`MEM_SEL_BUS]			mem_memSel,			//= mem_memSel
	
	output	reg	[`WORD_BUS]				mem_result,			//= mem_result
	output	reg	[`REG_ADDR_BUS]			mem_regDest,		//= mem_regDest
	output	reg							mem_resultSel		//= mem_resultSel
);

	always @(posedge clk) begin
		if (rst) begin
			mem_memWriteEnable <= 0;
			mem_memReadEnable <= 0;
			mem_memAddr <= 0;
			mem_memSel <= 0;
			mem_regDest <= 0;
			mem_result <= 0;
			mem_resultSel <= 0;
		end else begin
			case (ex_memop)
				`MEM_OP_WRITE_REG: begin
					mem_memWriteEnable <= `DISABLE;
					mem_memReadEnable <= `DISABLE;
					mem_memAddr <= 0;
					mem_memSel <= 4'b0000;

					mem_regDest <= ex_regDest;
					mem_result <= ex_result;
					mem_resultSel <= `MEM_SEL_REGVAL;
				end
				default: begin
					mem_memWriteEnable <= `DISABLE;
					mem_memReadEnable <= `DISABLE;
					mem_memAddr <= 0;
					mem_memSel <= 4'b0000;

					mem_regDest <= `REG_ZERO;
					mem_result <= `ZERO_WORD;
					mem_resultSel <= `MEM_SEL_REGVAL;
				end
			endcase
		end
	end

endmodule
