module ID_EX(
	input	wire					clk,				//= clk
	input	wire					rst,				//= rst

	input	wire					stall_id,			//= CTRL::stall_id
	input	wire					stall_ex,			//= CTRL::stall_ex

	input	wire[`INST_BUS]			id_inst,			//= IF_ID::id_inst
	input	wire[`EX_OP_BUS]		id_exop,			//= ID::o_exop
	input	wire[`WORD_BUS]			id_srcLeft,			//= ID::o_srcLeft
	input	wire[`WORD_BUS]			id_srcRight,		//= ID::o_srcRight
	input	wire[`REG_ADDR_BUS]		id_dest,			//= ID::o_dest

	output	reg	[`INST_BUS]			ex_inst,			//= ex_inst
	output	reg	[`EX_OP_HIGH_BUS]	ex_alusel,			//= ex_alusel
	output	reg	[`EX_OP_LOW_BUS]	ex_aluop,			//= ex_aluop
	output	reg	[`WORD_BUS]			ex_srcLeft,			//= ex_srcLeft
	output	reg	[`WORD_BUS]			ex_srcRight,		//= ex_srcRight

	output	reg	[`MEM_OP_BUS]		ex_memop,			//= ex_memop
	output	reg	[`REG_ADDR_BUS]		ex_dest,			//= ex_dest
	output	reg						ex_writeEnable		//= ex_writeEnable
);

	always @(posedge clk) begin
		if (rst) begin
			ex_inst <= `ZERO_WORD;
			ex_alusel <= `EX_HIGH_SPECIAL;
			ex_aluop <= `EX_SPECIAL_NOP;
			ex_srcLeft <= `ZERO_WORD;
			ex_srcRight <= `ZERO_WORD;
			ex_memop <= `MEM_OP_NOP;
			ex_dest <= `REG_ZERO;
			ex_writeEnable <= `DISABLE;
		end else if (stall_ex) begin
		end else if (stall_id) begin
			ex_inst <= `ZERO_WORD;
			ex_alusel <= `EX_HIGH_SPECIAL;
			ex_aluop <= `EX_SPECIAL_NOP;
			ex_srcLeft <= `ZERO_WORD;
			ex_srcRight <= `ZERO_WORD;
			ex_memop <= `MEM_OP_NOP;
			ex_dest <= `REG_ZERO;
			ex_writeEnable <= `DISABLE;
		end else begin
			ex_inst <= id_inst;
			{ex_alusel, ex_aluop} <= id_exop;
			ex_srcLeft <= id_srcLeft;
			ex_srcRight <= id_srcRight;
			ex_dest <= id_dest;
			case (id_exop[`EX_OP_HIGH_BUS])
				`EX_HIGH_LOGIC: begin
					ex_memop <= `MEM_OP_WRITE_REG;
					ex_writeEnable <= `ENABLE;
				end
				`EX_HIGH_ARITH: begin
					ex_memop <= `MEM_OP_WRITE_REG;
					ex_writeEnable <= `ENABLE;
				end
				`EX_HIGH_MEMACC: begin
					ex_memop <= {id_exop[3], 1'b1};
					ex_writeEnable <= `DISABLE;
				end
				default: begin
					ex_memop <= `MEM_OP_NOP;
					ex_writeEnable <= `DISABLE;
				end
			endcase
		end
	end

	initial begin
		$dumpvars(0, id_srcLeft, id_srcRight, ex_dest);
	end

endmodule
