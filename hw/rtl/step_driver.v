module step_driver(
	input wire clk,
	input wire rst,

	input wire step,
	input wire dir,
	
	input wire tr0,
	input wire en,
	
	output wire [3:0] coils
	);
	
reg [3:0] coil_state_r;
reg stepdel_r, dir_r;

assign coils = coil_state_r;

always @(posedge clk) begin
	if(rst == 1'b1) begin
		coil_state_r <= 4'b0001;
		stepdel_r <= 1'b1;
		dir_r <= 1'b1;
	end else begin
		if(en && ~stepdel_r && step) begin // Rising edge of step pulse
			if(dir_r == 1'b0) begin // LOW: step towards center, coils 1>2>3>4>1...
				case(coil_state_r)
					4'b0001: coil_state_r <= 4'b0010;
					4'b0010: coil_state_r <= 4'b0100;
					4'b0100: coil_state_r <= 4'b1000;
					4'b1000: coil_state_r <= 4'b0001;
					default: coil_state_r <= 4'b0001;
				endcase
			end else if(dir_r == 1'b1 && tr0 == 1'b0) begin // HIGH: step towards edge, coils 4>3>2>1>4...
				case(coil_state_r)
					4'b0001: coil_state_r <= 4'b1000;
					4'b0010: coil_state_r <= 4'b0001;
					4'b0100: coil_state_r <= 4'b0010;
					4'b1000: coil_state_r <= 4'b0100;
					default: coil_state_r <= 4'b0001;
				endcase
			end
		end else if(en && ~stepdel_r) begin
			dir_r <= dir;
		end
		
		stepdel_r <= step;
	end
end

endmodule
