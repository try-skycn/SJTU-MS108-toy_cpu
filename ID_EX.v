module ID_EX(
	input	wire					clk,				//= clk
	input	wire					rst,				//= rst

	input	wire[`EX_OP_BUS]		id_exop,			//= ID::o_exop
	input	wire[`WORD_BUS]			id_srcLeft,			//= ID::o_srcLeft
	input	wire[`WORD_BUS]			id_srcRight,		//= ID::o_srcRight
	input	wire[`WORD_BUS]			id_offset,			//= ID::o_offset
	input	wire[`REG_ADDR_BUS]		id_dest,			//= ID::o_dest

	output	reg	[`ALU_SEL_BUS]		ex_alusel,			//= ex_alusel
	output	reg	[`EX_OP_LOW_BUS]	ex_aluop,			//= ex_aluop
	output	reg	[`WORD_BUS]			ex_srcLeft,			//= ex_srcLeft
	output	reg	[`WORD_BUS]			ex_srcRight,		//= ex_srcRight
	output	reg	[`WORD_BUS]			ex_offset,			//= ex_offset

	output	reg	[`MEM_OP_BUS]		ex_memop,			//= ex_memop
	output	reg	[`REG_ADDR_BUS]		ex_dest,			//= ex_dest
	output	reg						ex_writeEnable		//= ex_writeEnable
);

	always @(posedge clk) begin
		if (rst) begin
			ex_alusel <= `ALU_NOP;
			ex_aluop <= `EX_SPECIAL_NOP;
			ex_srcLeft <= `ZERO_WORD;
			ex_srcRight <= `ZERO_WORD;
			ex_offset <= 16'b0;
			ex_memop <= `MEM_OP_NOP;
			ex_dest <= `REG_ZERO;
			ex_writeEnable <= `DISABLE;
		end else begin
			ex_srcLeft <= id_srcLeft;
			ex_srcRight <= id_srcRight;
			ex_offset <= id_offset;
			ex_dest <= id_dest;

			ex_aluop <= id_exop[`EX_OP_LOW_BUS];
			case (id_exop[`EX_OP_HIGH_BUS])
				`EX_HIGH_LOGIC: begin
					ex_alusel <= `ALU_LOGIC;
					ex_memop <= `MEM_OP_WRITE_REG;
					ex_writeEnable <= `ENABLE;
				end
				default: begin
					ex_alusel <= `ALU_NOP;
					ex_memop <= `MEM_OP_NOP;
					ex_writeEnable <= `DISABLE;
				end
			endcase
		end
	end

endmodule
