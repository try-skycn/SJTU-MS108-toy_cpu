module RegFile(
	input	wire						clk,				//= clk
	input	wire						rst,				//= rst

	input	wire						writeEnable,		//= EX_MEM::mem_regWriteEnable
	input	wire[`REG_ADDR_BUS]			writeAddr,			//= EX_MEM::mem_regDest
	input	wire[`WORD_BUS]				writeResult,		//= MEM::result

	input	wire						readEnableLeft,		//= ID::o_readEnableLeft
	input	wire[`REG_ADDR_BUS]			readAddrLeft,		//= IF_ID::id_inst [`INST_RS_BUS]
	output	reg	[`WORD_BUS]				readValueLeft,		//= readValueLeft

	input	wire						readEnableRight,	//= ID::o_readEnableRight
	input	wire[`REG_ADDR_BUS]			readAddrRight,		//= IF_ID::id_inst [`INST_RT_BUS]
	output	reg	[`WORD_BUS]				readValueRight,		//= readValueRight

	input	wire[`REG_ADDR_BUS]			exDest,				//= ID_EX::ex_dest
	input	wire[`WORD_BUS]				exResult,			//= EX::o_result
	input	wire						exWriteEnable,		//= ID_EX::ex_writeEnable

	output	wire						stall				//= id_stall
);

			reg	[`WORD_BUS]				registers[`REG_NUM - 1 : 0];
			reg							leftStall;
			reg							rightStall;

	assign stall = leftStall | rightStall;

	always @(posedge clk) begin
		if (rst) begin
       			for (i = 0; i < `REG_NUM; i = i + 1) begin
       				registers[i] <= 0;
       			end
		end else begin
			if (writeEnable && writeAddr != `REG_ZERO) begin
				registers[writeAddr] <= writeResult;
			end
		end
	end

	always @(*) begin
		leftStall <= `DISABLE;
		if (readEnableLeft) begin
			if (readAddrLeft == `REG_ZERO) begin
				readValueLeft <= `ZERO_WORD;
			end else if (readAddrLeft == exDest) begin
				if (exWriteEnable) begin
					readValueLeft <= exResult;
				end else begin
					readValueLeft <= `ZERO_WORD;
					leftStall <= `ENABLE;
				end
			end else if (readAddrLeft == writeAddr) begin
				readValueLeft <= writeResult;
			end else begin
				readValueLeft <= registers[readAddrLeft];
			end
		end else begin
			readValueLeft <= `ZERO_WORD;
		end
	end

	always @(*) begin
		rightStall <= `DISABLE;
		if (readEnableRight) begin
			if (readAddrRight == `REG_ZERO) begin
				readValueRight <= `ZERO_WORD;
			end else if (readAddrRight == exDest) begin
				if (exWriteEnable) begin
					readValueRight <= exResult;
				end else begin
					readValueRight <= `ZERO_WORD;
					rightStall <= `ENABLE;
				end
			end else if (readAddrRight == writeAddr) begin
				readValueRight <= writeResult;
			end else begin
				readValueRight <= registers[readAddrRight];
			end
		end else begin
			readValueRight <= `ZERO_WORD;
		end
	end

	integer i;
	initial begin
		for (i = 1; i < 5; i = i + 1) begin
			$dumpvars(0, registers[i]);
		end
		$dumpvars(0, writeEnable, writeAddr, writeResult);
	end

endmodule