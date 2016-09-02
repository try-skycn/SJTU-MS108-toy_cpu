`include "timescale.v"

`define ENABLE					1'b1
`define DISABLE					1'b0

`define ACTIVATE				1'b1
`define DISACTIVATE				1'b0

`define ZERO_WORD				32'h0

`define INST_ADDR_WIDTH			32
`define INST_ADDR_BUS			`INST_ADDR_WIDTH - 1 : 0

`define INST_WIDTH				32
`define INST_BUS				`INST_WIDTH - 1 : 0

`define WORD_WIDTH				32
`define WORD_BUS				31 : 0

`define REG_NUM					32
`define REG_NUM_LOG				5
`define REG_BUS					`REG_NUM_LOG - 1 : 0

`define MEM_ADDR_NUM_LOG		32
`define MEM_ADDR_BUS			`MEM_ADDR_NUM_LOG - 1 : 0

`define MEM_LEN_NUM				4
`define MEM_LEN_NUM_LOG			2
`define MEM_LEN_BUS				`MEM_LEN_NUM_LOG - 1 : 0

`define INST_OPCODE_BUS			31 : 26
`define INST_RS_BUS				25 : 21
`define INST_RT_BUS				20 : 16
`define INST_RD_BUS				15 : 11
`define INST_SHAMT_BUS			10 : 6
`define INST_FUNCT_BUS			 5 : 0
`define INST_IMM_BUS			15 : 0
`define INST_ADDRESS_BUS		25 : 0

`define RAW_OPCODE_BUS			 6 : 0
`define RAW_SHAMT_BUS			 5 : 0
`define RAW_FUNCT_BUS			 5 : 0

// For ID OP

// For ALU OP

`define ALU_OP_WIDTH			8
`define ALU_OP_BUS				`ALU_OP_WIDTH - 1 : 0

// For Calculating Chip Selection
`define ALU_CHIP_NUM			8
`define ALU_CHIP_NUM_LOG		3
`define ALU_CHIP_BUS			`ALU_OP_WIDTH - 1 : `ALU_OP_WIDTH - `ALU_CHIP_NUM_LOG

`define ALU_NULL				`ALU_CHIP_NUM_LOG'b000
`define ALU_LOGIC				`ALU_CHIP_NUM_LOG'b001
`define ALU_ARITH				`ALU_CHIP_NUM_LOG'b010

// For Calculating OP

// For MEM OP

`define MEM_OP_NUM				4
`define MEM_OP_NUM_LOG			2
`define MEM_OP_BUS				`MEM_OP_NUM_LOG - 1 : 0

`define MEM_ACCESS				0
`define REG_ACCESS				1

`define MEM_OP_NULL				`MEM_OP_NUM_LOG'b00
`define MEM_OP_STORE			`MEM_OP_NUM_LOG'b01
`define MEM_OP_LOAD				`MEM_OP_NUM_LOG'b11
`define MEM_OP_WRITE_REG		`MEM_OP_NUM_LOG'b10