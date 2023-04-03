/* Floppy Overdrive - Sub-Level Entity
 *
 * File: step_driver_deb.v
 * Author: Thomas Le <thomas.le@ufl.edu>
 * Created: Jan. 20, 2023
 *
 * This module handles the control logic for the 4 stepper motor coils.
 * When a valid step signal is recieved, the current coil is shifted
 * left or right, moving the stepper motor one 'step' in a particular direction.
 *
 * Unlike step_driver.v, this module adds a CHECK and COUNT state to ensure that
 * the step pulse is of a minimum length. This prevents the motor from stepping
 * when bounces occur on the step input.
 */

module step_driver_deb(
	input wire clk,
	input wire rst,

	input wire step,
	input wire dir,
	
	input wire tr0,
	input wire en,
	
	output wire [3:0] coils
	);
	
	localparam DELAY_COUNT = 8'd500; // Defines length of delay before checking for bounce

	// Stepper motor coils
	reg [3:0] coil_state_r, next_coil; 
	assign coils = coil_state_r;

	// Counter for bounce delay
	reg [7:0] count_r, next_count;

	// FSM states and state register
	localparam LOAD  = 3'b000;
	localparam START = 3'b001;
	localparam COUNT = 3'b010;
	localparam CHECK = 3'b011;
	localparam WAIT  = 3'b100;
	localparam STEP  = 3'b101;
	reg [2:0] state_r, next_state;

	// Step and direction inputs for dual-flop synchronizers
	reg step_del_r, step_r;
	reg dir_del_r, dir_r;

	always @(posedge clk, posedge rst) begin
		if(rst == 1'b1) begin
			coil_state_r <= 4'b0001;
			state_r <= 3'b000;
			count_r <= 8'b00000000;
			step_del_r <= 1'b1;
			step_r <= 1'b1;
			dir_del_r <= 1'b1;
			dir_r <= 1'b1;
		end else begin
			state_r <= next_state;
			coil_state_r <= next_coil;
			count_r <= next_count;
			
			// Dual-flop synchronizer, prevents possible metastability on step signal
			step_del_r <= step;
			step_r <= step_del_r;
			
			// Dual-flop for direction signal
			dir_del_r <= dir;
			dir_r <= dir_del_r;
		end
	end

	always @* begin
		next_state = state_r;
		next_coil = coil_state_r;
		next_count = count_r;
		
		case(state_r)
			LOAD: begin // Makes sure first coil is energized at start of execution
				next_coil = 4'b0001;
				next_state = START;
			end

			START: begin
				if((en == 1'b1) && (step_r == 1'b0)) begin // If the step line goes low and the drive is enabled
					next_state = COUNT; // Go to COUNT
					next_count = DELAY_COUNT; // Start counter from max. value
					//next_coil  = 4'b1010;
				end
			end
			
			COUNT: begin
				if(count_r == 8'd0) begin // If end of timer is reached
					next_state = CHECK; // Go to CHECK
				end else begin
					next_count = count_r - 8'b00000001; // Count down from 0
				end
			end
			
			CHECK: begin
				if(step_r == 1'b1) begin // Step line is no longer low, implies bounce
					next_state = START; // Go to START
				end else begin
					next_state = WAIT; // Go to WAIT
				end
			end
			
			WAIT: begin
				if(step_r == 1'b1) begin // Wat to step until the rising edge of the step signal
					next_state = STEP; // Go to STEP
				end
			end
			
			STEP: begin
				if(dir_r == 1'b0) begin // dir = low: step towards center of disk, coils 1>2>3>4>1...
					case(coil_state_r)
						4'b0001: next_coil = 4'b0010;
						4'b0010: next_coil = 4'b0100;
						4'b0100: next_coil = 4'b1000;
						4'b1000: next_coil = 4'b0001;
						default: next_coil = 4'b0001;
					endcase
				end else if(dir_r == 1'b1) begin // dir - high: step towards edge of disk, coils 4>3>2>1>4...
					case(coil_state_r)
						4'b0001: next_coil = 4'b1000;
						4'b0010: next_coil = 4'b0001;
						4'b0100: next_coil = 4'b0010;
						4'b1000: next_coil = 4'b0100;
						default: next_coil = 4'b0001;
					endcase
				end
			
				next_state = START; // Go to START
			end
			
			default: begin // Undefined state
				next_state = START; // Go to START
				next_count = 8'b0; // Clear counter
			end
		endcase
	end
endmodule // step_driver_deb
