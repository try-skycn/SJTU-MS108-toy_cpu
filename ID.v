`include "define.v"

`define	HSEL_BUS		1 : 0
`define HSEL_ZERO		2'b00
`define HSEL_REG		2'b01
`define	HSEL_IMM		2'b10

`define LSEL_BUS		2 : 0
`define LSEL_ZERO		3'b000
`define LSEL_REG		3'b001
`define	LSEL_IMM		3'b010
`define LSEL_EX			3'b101
`define	LSEL_MEM		3'b110

module ID(
	input	wire[`INST_ADDR_BUS]	i_pc,
	input	wire[`RAW_OPCODE_BUS]	i_opcode,
	input	wire[`RAW_SHAMT_BUS]	i_sa,
	input	wire[`RAW_FUNCT_BUS]	i_fn,
	input	wire[`REG_ADDR_BUS]		i_rs,
	input	wire[`REG_ADDR_BUS]		i_rt,
	input	wire[`REG_ADDR_BUS]		i_rd,
	input	wire[`WORD_BUS]			i_imm,
	input	wire[`RAW_TARGET_BUS]	i_target,

	output	reg	[`REG_ADDR_BUS]		o_readAddrLeft,
	output	reg	[`REG_ADDR_BUS]		o_readAddrRight,

	input	wire[`WORD_BUS]			i_readValueLeft,
	input	wire[`WORD_BUS]			i_readValueRight,
	input	wire[`REG_ADDR_BUS]		i_exDest,
	input	wire[`WORD_BUS]			i_exResult,
	input	wire					i_exWriteEnable,
	input	wire[`REG_ADDR_BUS]		i_memDest,
	input	wire[`WORD_BUS]			i_memResult,

	output	reg	[`EX_OP_BUS]		o_exop,
	output	reg	[`WORD_BUS]			o_srcLeft,
	output	reg	[`WORD_BUS]			o_srcRight,
	output	reg	[`WORD_BUS]			o_offset,
	output	reg	[`REG_ADDR_BUS]		o_dest,

	output	wire					stall
);

			reg						leftStall;
			reg						rightStall;

			reg	[`HSEL_BUS]			srcLeftHighSel;
			reg	[`HSEL_BUS]			srcRightHighSel;

			reg	[`LSEL_BUS]			srcLeftLowSel;
			reg	[`LSEL_BUS]			srcRightLowSel;

	assign stall = leftStall & rightStall;

	always @(*) begin
		case (i_opcode)
			`ID_OPCODE_RTYPE: begin
				case (i_sa)
					default: begin
						o_readAddrLeft <= `REG_ZERO;
						o_readAddrRight <= `REG_ZERO;

						o_exop <= {`EX_HIGH_SPECIAL, `EX_SPECIAL_NOP};
						srcLeftHighSel <= `HSEL_ZERO;
						srcRightHighSel <= `HSEL_ZERO;
						o_offset <= `ZERO_WORD;
						o_dest <= `REG_ZERO;
					end
				endcase
			end
			`ID_OPCODE_ORI: begin
				o_readAddrLeft <= i_rs;
				o_readAddrRight <= `REG_ZERO;

				o_exop <= {`EX_HIGH_LOGIC, `EX_LOGIC_OR};
				srcLeftHighSel <= `HSEL_REG;
				srcRightHighSel <= `HSEL_IMM;
				o_offset <= `ZERO_WORD;
				o_dest <= i_rt;
			end
			default: begin
				o_readAddrLeft <= `REG_ZERO;
				o_readAddrRight <= `REG_ZERO;

				o_exop <= {`EX_HIGH_SPECIAL, `EX_SPECIAL_NOP};
				srcLeftHighSel <= `HSEL_ZERO;
				srcRightHighSel <= `HSEL_ZERO;
				o_offset <= `ZERO_WORD;
				o_dest <= `REG_ZERO;
			end
		endcase
	end

	always @(*) begin
		leftStall <= `DISABLE;
		if (srcLeftHighSel == `HSEL_REG) begin
			if (o_readAddrLeft == `REG_ZERO) begin
				srcLeftLowSel <= `LSEL_ZERO;
			end else if (o_readAddrLeft == i_exDest) begin
				if (i_exWriteEnable) begin
					srcLeftLowSel <= `LSEL_EX;
				end else begin
					srcLeftLowSel <= `LSEL_ZERO;
					leftStall <= `ENABLE;
				end
			end else if (o_readAddrLeft == i_memDest) begin
				srcLeftLowSel <= `LSEL_MEM;
			end else begin
				srcLeftLowSel <= `LSEL_REG;
			end
		end else begin
			srcLeftLowSel <= {1'b0, srcLeftHighSel};
		end
	end

	always @(*) begin
		rightStall <= `DISABLE;
		if (srcRightHighSel == `HSEL_REG) begin
			if (o_readAddrRight == `REG_ZERO) begin
				srcRightLowSel <= `LSEL_ZERO;
			end else if (o_readAddrRight == i_exDest) begin
				if (i_exWriteEnable) begin
					srcRightLowSel <= `LSEL_EX;
				end else begin
					srcRightLowSel <= `LSEL_ZERO;
					rightStall <= `ENABLE;
				end
			end else if (o_readAddrRight == i_memDest) begin
				srcRightLowSel <= `LSEL_MEM;
			end else begin
				srcRightLowSel <= `LSEL_REG;
			end
		end else begin
			srcRightLowSel <= {1'b0, srcRightHighSel};
		end
	end

	always @(*) begin
		case (srcLeftLowSel)
			`LSEL_REG: o_srcLeft <= i_readValueLeft;
			`LSEL_IMM: o_srcLeft <= i_imm;
			`LSEL_EX: o_srcLeft <= i_exResult;
			`LSEL_MEM: o_srcLeft <= i_memResult;
			default: o_srcLeft <= `ZERO_WORD;
		endcase
	end

	always @(*) begin
		case (srcRightLowSel)
			`LSEL_REG: o_srcRight <= i_readValueRight;
			`LSEL_IMM: o_srcRight <= i_imm;
			`LSEL_EX: o_srcRight <= i_exResult;
			`LSEL_MEM: o_srcRight <= i_memResult;
			default: o_srcRight <= `ZERO_WORD;
		endcase
	end

endmodule
