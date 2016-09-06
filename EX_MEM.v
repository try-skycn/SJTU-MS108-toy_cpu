module EX_MEM(
	input	wire						clk,				//= clk
	input	wire						rst,				//= rst

	input	wire[`MEM_OP_BUS]			ex_memop,			//= ID_EX::ex_memop
	input	wire[`WORD_BUS]				ex_result,			//= EX::o_result
	input	wire[`MEM_ADDR_BUS]			ex_memAddr,			//= 0
	input	wire[`REG_ADDR_BUS]			ex_regDest,			//= ID_EX::ex_dest

	output	reg	[`MEM_OP_BUS]			mem_memop,			//= mem_memop
	output	wire						mem_memWriteEnable,	//= mem_memWriteEnable
	output	wire						mem_memReadEnable,	//= mem_memReadEnable
	output	reg	[`MEM_ADDR_HIGH_BUS]	mem_memAddr,		//= mem_memAddr
	output	reg	[`MEM_SEL_BUS]			mem_memSel,			//= mem_memSel
	
	output	reg	[`WORD_BUS]				mem_result,			//= mem_result
	output	reg	[`REG_ADDR_BUS]			mem_regDest			//= mem_regDest
);

	assign mem_memWriteEnable = mem_memop[2] & (~ mem_memop[3]);
	assign mem_memReadEnable = mem_memop[2] & mem_memop[3];

	always @(posedge clk) begin
		if (rst) begin
			mem_memAddr <= 0;
			mem_memSel <= 0;
			mem_regDest <= 0;
			mem_result <= 0;
		end else begin
			case (ex_memop)
				`MEM_OP_WRITE_REG: begin
					mem_memAddr <= 0;
					mem_memSel <= 4'b0000;

					mem_regDest <= ex_regDest;
					mem_result <= ex_result;
				end
				default: begin
					mem_memAddr <= 0;
					mem_memSel <= 4'b0000;

					mem_regDest <= `REG_ZERO;
					mem_result <= `ZERO_WORD;
				end
			endcase
		end
	end

endmodule
