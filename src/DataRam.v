`define RAM_MEM_NUM		32
`define RAM_MEM_NUM_LOG	 5
`define RAM_ADDR_WIDTH	 7
`define RAM_ADDR_BUS	 6 : 2

module DataRam(
	input	wire					clk,		//= clk
	input	wire					re,			//= CPU::o_ramReadEnable
	input	wire					we,			//= CPU::o_ramWriteEnable
	input	wire[`MEM_ADDR_BUS]		addr,		//= CPU::o_ramAddr
	input	wire[`MEM_SEL_BUS]		sel,		//= CPU::o_ramSel
	input	wire[`WORD_BUS]			storeData,	//= CPU::o_ramStoreData
	output	reg	[`WORD_BUS]			loadData	//= ramLoadData
);

			reg	[`WORD_BUS]			ram[0 : `RAM_MEM_NUM - 1];

			wire[`RAM_ADDR_BUS]		validaddr;

	assign validaddr = addr[`RAM_ADDR_BUS];

	integer i;
	initial begin
		for (i = 0; i < `RAM_MEM_NUM; i = i + 1) begin
			ram[i] <= 0;
		end
		for (i = 0; i < 4; i = i + 1) begin
			$dumpvars(0, ram[i]);
		end
	end

	always @(posedge clk) begin
		if (we) begin
			if (sel[0]) begin
				ram[validaddr][ 7 : 0 ] <= storeData[ 7 : 0 ];
			end
			if (sel[1]) begin
				ram[validaddr][15 : 8 ] <= storeData[15 : 8 ];
			end
			if (sel[2]) begin
				ram[validaddr][23 : 16] <= storeData[23 : 16];
			end
			if (sel[3]) begin
				ram[validaddr][31 : 24] <= storeData[31 : 24];
			end
		end
	end

	always @(*) begin
		if (re) begin
			loadData <= ram[validaddr];
		end else begin
			loadData <= `ZERO_WORD;
		end
	end

endmodule