`include "timescale.v"

`define ENABLE					1'b1
`define DISABLE					1'b0

`define ZERO_WORD				32'h0

`define WORD_WIDTH				32
`define WORD_BUS				31 : 0

`define INST_ADDR_WIDTH			32
`define INST_ADDR_BUS			31 : 0

`define REG_NUM					32
`define REG_ADDR_WIDTH			 5
`define REG_ADDR_BUS			 4 : 0

`define REG_ZERO				5'b00000
`define REG_RA					5'b11111

`define MEM_ADDR_WIDTH			32
`define MEM_ADDR_BUS			31 : 0
`define MEM_ADDR_HIGH_BUS		31 : 2
`define MEM_ADDR_LOW_BUS		 1 : 0
`define MEM_SEL_BUS				 4 : 0

`define INST_WIDTH				32
`define INST_BUS				31 : 0
`define INST_OPCODE_BUS			31 : 26
`define INST_RS_BUS				25 : 21
`define INST_RT_BUS				20 : 16
`define INST_RD_BUS				15 : 11
`define INST_SHAMT_BUS			10 : 6
`define INST_FUNCT_BUS			 5 : 0
`define INST_IMM_BUS			15 : 0
`define INST_TARGET_BUS			25 : 0

`define RAW_OPCODE_BUS			 6 : 0
`define RAW_SHAMT_BUS			 5 : 0
`define RAW_FUNCT_BUS			 5 : 0

// For ID OP

// For EX OP

`define EX_OP_WIDTH				 8
`define EX_OP_BUS				 7 : 0
`define EX_OP_HIGH_BUS			 7 : 4
`define EX_OP_LOW_BUS			 3 : 0

`define EX_HIGH_SPECIAL			4'b0000
`define EX_HIGH_LOGIC			4'b1000
`define EX_HIGH_SHIFT			4'b1001
`define EX_HIGH_MOVE			4'b1010
`define EX_HIGH_ARITH			4'b1011
`define EX_HIGH_BRANCH			4'b1100
`define EX_HIGH_MEMACC			4'b1101
`define EX_HIGH_CP0				4'b1110
`define EX_HIGH_EXCEPTION		4'b1111

`define EX_SPECIAL_NOP			4'b0000

`define EX_LOGIC_AND			4'b0000
`define EX_LOGIC_OR				4'b0001
`define EX_LOGIC_XOR			4'b0010
`define EX_LOGIC_NOR			4'b0011
`define EX_LOGIC_LUI			4'b1000

`define ALU_NUM					 8
`define ALU_NOP					8'b00000000
`define ALU_LOGIC				8'b10000000
`define ALU_SHIFT				8'b01000000

// For MEM OP

`define MEM_OP_WIDTH			4
`define MEM_OP_BUS				3 : 0

`define MEM_OP_NOP				4'b0000

`define MEM_OP_STORE_BYTE		4'b0101
`define MEM_OP_STORE_HALFWORD	4'b0110
`define MEM_OP_STORE_WORD		4'b0111

`define MEM_OP_LOAD_BYTE		4'b1101
`define MEM_OP_LOAD_HALFWORD	4'b1110
`define MEM_OP_LOAD_WORD		4'b1111

`define MEM_OP_WRITE_REG		4'b1000

`define MEM_SEL_REGVAL			2'b0
`define MEM_SEL_LOAD			2'b1