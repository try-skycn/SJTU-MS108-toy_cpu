module MEM(
	input	wire					memReadEnable,	//= EX_MEM::mem_ramReadEnable
	input	wire[`WORD_BUS]			loaddata,		//= i_ramLoadData
	input	wire[`MEM_LOADOP_BUS]	loadop,			//= EX_MEM::mem_loadop
	input	wire[`MEM_ADDR_LOW_BUS]	lowaddr,		//= EX_MEM::mem_ramLowAddr
	input	wire[`WORD_BUS]			exresult,		//= EX_MEM::mem_exresult

	output	wire[`WORD_BUS]			result			//= memResult
);

			reg	[`WORD_BUS]			loadresult;

	assign result = memReadEnable ? loadresult : exresult;

	always @(*) begin
		case (loadop)
			`MEM_LOADOP_LB: begin
				case (lowaddr)
					2'b00: loadresult <= {24'b0, loaddata[ 7 : 0 ]};
					2'b01: loadresult <= {24'b0, loaddata[15 : 8 ]};
					2'b10: loadresult <= {24'b0, loaddata[23 : 16]};
					2'b11: loadresult <= {24'b0, loaddata[31 : 24]};
				endcase
			end
			`MEM_LOADOP_LBU: begin
				case (lowaddr)
					2'b00: loadresult <= {{24{loaddata[ 7]}}, loaddata[ 7 : 0 ]};
					2'b01: loadresult <= {{24{loaddata[15]}}, loaddata[15 : 8 ]};
					2'b10: loadresult <= {{24{loaddata[23]}}, loaddata[23 : 16]};
					2'b11: loadresult <= {{24{loaddata[31]}}, loaddata[31 : 24]};
				endcase
			end
			`MEM_LOADOP_LH: begin
				case (lowaddr[1])
					1'b0: loadresult <= {16'b0, loaddata[15 : 0 ]};
					1'b1: loadresult <= {16'b0, loaddata[31 : 16]};
				endcase
			end
			`MEM_LOADOP_LHU: begin
				case (lowaddr[1])
					1'b0: loadresult <= {{16{loaddata[15]}}, loaddata[15 : 0 ]};
					1'b1: loadresult <= {{16{loaddata[31]}}, loaddata[31 : 16]};
				endcase
			end
			`MEM_LOADOP_LW: loadresult <= loaddata;
			default: loadresult <= `ZERO_WORD;
		endcase
	end

endmodule
