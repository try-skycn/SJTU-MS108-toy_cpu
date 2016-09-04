`include "define.v"

module RegFile(
	input	wire						clk,
	input	wire						rst,

	input	wire						writeEnable,
	input	wire[`REG_ADDR_BUS]			writeAddr,
	input	wire[`WORD_BUS]				writeValue,

	input	wire[`REG_ADDR_BUS]			readAddrLeft,
	output	reg	[`WORD_BUS]				readValueLeft,

	input	wire[`REG_ADDR_BUS]			readAddrRight,
	output	reg	[`WORD_BUS]				readValueRight
);

			reg	[`WORD_BUS]				registers[`REG_NUM - 1 : 0];

			integer						i;

	always @(posedge clk) begin
		if (rst) begin
			for (i = 0; i < `REG_NUM; i = i + 1) begin
				registers[i] <= 0;
			end
		end
	end

	always @(negedge clk) begin
		if (~rst) begin
			if (writeEnable && writeAddr != `REG_ZERO) begin
				registers[writeAddr] <= writeValue;
			end
		end
	end

	always @(*) begin
		if (rst) begin
			readValueLeft <= 0;
		end else begin
			readValueLeft <= registers[readAddrLeft];
		end
	end

	always @(*) begin
		if (rst) begin
			readValueRight <= 0;
		end else begin
			readValueRight <= registers[readAddrRight];
		end
	end

endmodule