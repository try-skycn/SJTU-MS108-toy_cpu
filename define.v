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

`define REG_NUM					32
`define REG_NUM_LOG				5
`define REG_BUS					`REG_NUM_LOG - 1 : 0

`define REG_SRC1_BUS			25 : 21
`define REG_SRC2_BUS			20 : 16			