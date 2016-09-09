module ALU_MEMACC(
	input	wire					aluEnable,	//= ID_EX::ex_alusel == `EX_HIGH_MEMACC
	input	wire[`EX_OP_LOW_BUS]	op,			//= ID_EX::ex_aluop
	input	wire[`WORD_BUS]			srcLeft,	//=	ID_EX::ex_srcLeft
	input	wire[`WORD_BUS]			srcRight,	//= ID_EX::ex_srcRight
	input	wire[`INST_BUS]			ex_inst,	//= ID_EX::ex_inst

	output	reg	[`WORD_BUS]			result,		//= aluMemacc_result

	output	reg	[`MEM_ADDR_BUS]		ramAddr,	//= aluMemacc_ramAddr
	output	reg	[`MEM_SEL_BUS]		ramSel,		//= aluMemacc_ramSel
	output	reg	[`MEM_LOADOP_BUS]	loadop		//= aluMemacc_loadop
);

			wire[`WORD_BUS]			offset;
			wire[`MEM_ADDR_BUS]		addr;

	assign offset = {{16{ex_inst[15]}}, ex_inst[15 : 0]};
	assign addr = srcLeft + offset;

			wire					addr1;
			wire					addr0;
			wire[`MEM_SEL_BUS]		ramByteSel;
			wire[`MEM_SEL_BUS]		ramHalfwordSel;
			wire[`MEM_SEL_BUS]		signHalfwordSel;

	assign addr1 = addr[1];
	assign addr0 = addr[0];
	assign ramByteSel = addr1 ? (addr0 ? 4'b1000 : 4'b0100) : (addr0 ? 4'b0010 : 4'b0001);
	assign ramHalfwordSel = addr1 ? 4'b1100 : 4'b0011;
	assign signHalfwordSel = addr1 ? 4'b1000 : 4'b0010;

	always @(*) begin
		if (aluEnable) begin
			result <= `ZERO_WORD;

			ramAddr <= addr;
			ramSel <= 4'b0000;
			loadop <= `MEM_LOADOP_NOP;
			case (op)
				`EX_MEMACC_LB,
				`EX_MEMACC_LBU,
				`EX_MEMACC_LH,
				`EX_MEMACC_LHU,
				`EX_MEMACC_LW: loadop <= op[`MEM_LOADOP_BUS];
				`EX_MEMACC_SB: begin
					result <= {4{srcRight[ 7 : 0]}};
					ramSel <= ramByteSel;
				end
				`EX_MEMACC_SH: begin
					result <= {2{srcRight[15 : 0]}};
					ramSel <= ramHalfwordSel;
				end
				`EX_MEMACC_SW: begin
					result <= srcRight;
					ramSel <= 4'b1111;
				end
			endcase
		end else begin
			result <= `ZERO_WORD;
			ramAddr <= `ZERO_WORD;
			ramSel <= 4'b0000;
			loadop <= `MEM_LOADOP_NOP;
		end
	end

	initial begin
		$dumpvars(0, loadop, ramAddr, ramSel);
	end

endmodule
