module step_driver_deb(
	input wire clk,
	input wire rst,

	input wire step,
	input wire dir,
	
	input wire tr0,
	input wire en,
	
	output wire [3:0] coils
	);
	
localparam integer DELAY_COUNT = 25;
	
reg [3:0] coil_state_r, next_coil;

reg [7:0] count_r, next_count;

assign coils = coil_state_r;

reg [2:0] state_r, next_state;

always @(posedge clk) begin
	if(rst == 1'b1) begin
		coil_state_r <= 4'b0001;
		state_r <= 3'b0;
		count_r <= 8'b00000000;
	end else begin
		state_r <= next_state;
		coil_state_r <= next_coil;
		count_r <= next_count;
	end
end

always @* begin
	next_state = state_r;
	next_coil = coil_state_r;
	next_count = count_r;
	
	case(state_r)
		3'b000: begin // START
			if(en && ~step) begin // Pulse goes low and drive is enabled
				next_state = 3'b001; // Go to COUNT
				next_count = DELAY_COUNT[7:0]; // Restart counter
			end
		end
		
		3'b001: begin // COUNT
			if(count_r == 8'd0) begin
				next_state = 3'b010; // Go to CHECK
			end else begin
				next_count = count_r - 8'b00000001;
			end
		end
		
		3'b010: begin // CHECK
			if(step) begin // Bounced
				next_state = 3'b000; // Go to START
			end else begin
				next_state = 3'b011; // Go to WAIT
			end
		end
		
		3'b011: begin // WAIT
			if(step) begin // Wait until rising edge
				if(dir == 1'b0) begin // LOW: step towards center, coils 1>2>3>4>1...
					case(coil_state_r)
						4'b0001: next_coil = 4'b0010;
						4'b0010: next_coil = 4'b0100;
						4'b0100: next_coil = 4'b1000;
						4'b1000: next_coil = 4'b0001;
						default: next_coil = 4'b0001;
					endcase
				end else if(dir == 1'b1 && tr0 == 1'b0) begin // HIGH: step towards edge, coils 4>3>2>1>4...
					case(coil_state_r)
						4'b0001: next_coil = 4'b1000;
						4'b0010: next_coil = 4'b0001;
						4'b0100: next_coil = 4'b0010;
						4'b1000: next_coil = 4'b0100;
						default: next_coil = 4'b0001;
					endcase
				end
			
				next_state = 3'b000; // Go to START
			end
		end
		
		default: next_coil = 3'b000;
	endcase
end

endmodule // step_driver_deb
