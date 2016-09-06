`define ENABLE					1'b1
`define DISABLE					1'b0

`define WORD_WIDTH				32
`define WORD_BUS				31 : 0
`define ZERO_WORD				32'h0

`define HALFWORD_WIDTH			16
`define HALFWORD_BUS			15 : 0
`define ZERO_HALFWORD			16'h0

`define INST_ADDR_WIDTH			32
`define INST_ADDR_BUS			31 : 0
`define INST_ADDR_HIGH_BUS		31 : 2

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

// For ID OP

`define ID_OPCODE_RTYPE			6'b000000

`define ID_OPCODE_ADDI			6'b001000
`define ID_OPCODE_ADDIU			6'b001001
`define ID_OPCODE_ANDI			6'b001100
`define ID_OPCODE_BEQ			6'b000100
`define ID_OPCODE_BRANCH		6'b000001
`define ID_OPCODE_BGTZ			6'b000111
`define ID_OPCODE_BLEZ			6'b000110
`define ID_OPCODE_BNE			6'b000101
`define ID_OPCODE_LB			6'b100000
`define ID_OPCODE_LBU			6'b100100
`define ID_OPCODE_LH			6'b100001
`define ID_OPCODE_LHU			6'b100101
`define ID_OPCODE_LUI			6'b001111
`define ID_OPCODE_LW			6'b100011
`define ID_OPCODE_LWC1			6'b110001
`define ID_OPCODE_ORI			6'b001101
`define ID_OPCODE_SB			6'b101000
`define ID_OPCODE_SLTI			6'b001010
`define ID_OPCODE_SLTIU			6'b001011
`define ID_OPCODE_SH			6'b101001
`define ID_OPCODE_SW			6'b101011
`define ID_OPCODE_SWC1			6'b111001
`define ID_OPCODE_XORI			6'b001110

`define ID_OPCODE_J				6'b000010
`define ID_OPCODE_JAL			6'b000011

`define ID_RT_BLTZ				5'b00000
`define ID_RT_BGEZ				5'b00001

`define ID_FUNCT_NOP			6'b000000
`define ID_FUNCT_ADD			6'b100000
`define ID_FUNCT_ADDU			6'b100001
`define ID_FUNCT_AND			6'b100100
`define ID_FUNCT_BREAK			6'b001101
`define ID_FUNCT_DIV			6'b011010
`define ID_FUNCT_DIVU			6'b011011
`define ID_FUNCT_JALR			6'b001001
`define ID_FUNCT_JR				6'b001000
`define ID_FUNCT_MFHI			6'b010000
`define ID_FUNCT_MFLO			6'b010010
`define ID_FUNCT_MTHI			6'b010001
`define ID_FUNCT_MTLO			6'b010011
`define ID_FUNCT_MULT			6'b011000
`define ID_FUNCT_MULTU			6'b011001
`define ID_FUNCT_NOR			6'b100111
`define ID_FUNCT_OR				6'b100101
`define ID_FUNCT_SLL			6'b000000
`define ID_FUNCT_SLLV			6'b000100
`define ID_FUNCT_SLT			6'b101010
`define ID_FUNCT_SLTU			6'b101011
`define ID_FUNCT_SRA			6'b000011
`define ID_FUNCT_SRAV			6'b000111
`define ID_FUNCT_SRL			6'b000010
`define ID_FUNCT_SRLV			6'b000110
`define ID_FUNCT_SUB			6'b100010
`define ID_FUNCT_SUBU			6'b100011
`define ID_FUNCT_SYSCALL		6'b001100
`define ID_FUNCT_XOR			6'b100110

// For EX OP

`define EX_OP_WIDTH				 8
`define EX_OP_BUS				 7 : 0
`define EX_OP_HIGH_BUS			 7 : 4
`define EX_OP_LOW_BUS			 3 : 0

`define EX_HIGH_SPECIAL			4'b0000
`define EX_HIGH_LOGIC			4'b1000
`define EX_HIGH_ARITH			4'b1001
`define EX_HIGH_BRANCH			4'b1100
`define EX_HIGH_MEMACC			4'b1101
`define EX_HIGH_CP0				4'b1110
`define EX_HIGH_EXCEPTION		4'b1111

`define EX_SPECIAL_NOP			4'b0000

`define EX_LOGIC_AND			4'b0000
`define EX_LOGIC_OR				4'b0001
`define EX_LOGIC_XOR			4'b0010
`define EX_LOGIC_NOR			4'b0011
`define EX_LOGIC_SHLEFT			4'b0111
`define EX_LOGIC_SHRIGHTLOG		4'b0110
`define EX_LOGIC_SHRIGHTARI		4'b0100
`define EX_LOGIC_FROMHI			4'b1000
`define EX_LOGIC_FROMLO			4'b1010
`define EX_LOGIC_TOHI			4'b1001
`define EX_LOGIC_TOLO			4'b1011
`define EX_LOGIC_SELLEFT		4'b1100
`define EX_LOGIC_SELRIGHT		4'b1101

`define EX_ARITH_ADD			4'b0000
`define EX_ARITH_ADDU			4'b1000
`define EX_ARITH_SUB			4'b0010
`define EX_ARITH_SUBU			4'b1010
`define EX_ARITH_SLT			4'b0100
`define EX_ARITH_SLTU			4'b1100
`define EX_ARITH_MULT			4'b0001
`define EX_ARITH_MULTU			4'b1001

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

`define MEM_SEL_REGVAL			1'b0
`define MEM_SEL_LOAD			1'b1