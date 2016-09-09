module CTRL(
	input	wire						stall_req_id,	//= RegFile::stall
	input	wire						stall_req_ex,	//= 1'b0
	input	wire						stall_req_mem,	//= 1'b0

	output	wire						stall_if,		//= ctrl_stall_if
	output	wire						stall_id,		//= ctrl_stall_id
	output	wire						stall_ex,		//= ctrl_stall_ex
	output	wire						stall_mem		//= ctrl_stall_mem
);

			reg	[`STALL_SIGNAL_BUS]		stall_signal;

	assign stall_if  = stall_signal[`STALL_IF ];
	assign stall_id  = stall_signal[`STALL_ID ];
	assign stall_ex  = stall_signal[`STALL_EX ];
	assign stall_mem = stall_signal[`STALL_MEM];

	always @(*) begin
		if (stall_req_mem) begin
			stall_signal <= `STALL_FROM_MEM;
		end else if (stall_req_ex) begin
			stall_signal <= `STALL_FROM_EX;
		end else if (stall_req_id) begin
			stall_signal <= `STALL_FROM_ID;
		end else begin
			stall_signal <= `NO_STALL;
		end
	end

	initial begin
		$dumpvars(0, stall_signal);
	end

endmodule
