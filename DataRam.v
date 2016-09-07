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

			reg	[`BYTE_BUS]			ram0[0 : `RAM_MEM_NUM - 1];
			reg	[`BYTE_BUS]			ram1[0 : `RAM_MEM_NUM - 1];
			reg	[`BYTE_BUS]			ram2[0 : `RAM_MEM_NUM - 1];
			reg	[`BYTE_BUS]			ram3[0 : `RAM_MEM_NUM - 1];

			wire[`RAM_ADDR_BUS]		realaddr;

	assign realaddr = addr[`RAM_ADDR_BUS];

	always @(posedge clk) begin
		if (we) begin
			if (sel[0]) begin
				ram0[realaddr] <= storeData[ 7 : 0 ];
			end
			if (sel[1]) begin
				ram1[realaddr] <= storeData[15 : 8 ];
			end
			if (sel[2]) begin
				ram2[realaddr] <= storeData[23 : 16];
			end
			if (sel[3]) begin
				ram3[realaddr] <= storeData[31 : 24];
			end
		end
	end

	always @(*) begin
		if (re) begin
			loadData <= {ram3[realaddr], ram2[realaddr], ram1[realaddr], ram0[realaddr]};
		end else begin
			loadData <= `ZERO_WORD;
		end
	end

endmodule