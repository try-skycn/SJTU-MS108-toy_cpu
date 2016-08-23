`define RstEnable					1'b1
`define RstDisable					1'b0

`define WriteEnable					1'b1
`define WriteDisable				1'b0

`define ReadEnable					1'b1
`define ReadDisable					1'b0

`define ChipEnable					1'b1
`define ChipDisable					1'b0

`define InstValid				1'b0
`define InstInvalid				1'b1

`define ZeroWord				32'h0

`define AluOpBus				7:0
`define AluSelBus				2:0

`define LogTrue					1'b1
`define LogFalse				1'b0

// Things related to instructions

`define EXE_ORI					6'b001101
`define EXE_NOP					6'b000000

// ALU op
`define EXE_OR_OP				8'b00100101
`eefine EXE_NOP_OP				8`b00000000

// ALU sel
`define EXE_RES_LOGIC			3'b001
`define EXE_RES_NOP				3'b000

// Things related to ROM
`define InstAddrBus				31:0
`define InstBus					31:0
`define InstMemNum				131071
`define InstMemNumLog2			17

// Things related to Regfile
`define RegAddrBus				4:0
`define RegBus					31:0
`define RegWidth				32
`define DoubleRegWidth			64
`define DoubleRegBus			63:0
`define RegNum					32
`define RegNumLog2				5
`define NOPRegAddr				5'b0
