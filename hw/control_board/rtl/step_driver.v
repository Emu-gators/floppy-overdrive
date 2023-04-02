/* Floppy Overdrive - Sub-Level Entity
 *
 * File: step_driver.v
 * Author: Thomas Le <thomas.le@ufl.edu>
 * Created: Nov. 17, 2022
 *
 * This module handles the control logic for the 4 stepper motor coils.
 * When a valid step signal is recieved, the current coil is shifted
 * left or right, moving the stepper motor one 'step' in a particular direction.
 */

module step_driver(
	input wire clk,
	input wire rst,

	input wire step,
	input wire dir,
	
	input wire tr0,
	input wire en,
	
	output wire [3:0] coils
	);

	// Stepper motor coils
	reg [3:0] coil_state_r;
	assign coils = coil_state_r;

	// Inputs
	reg stepdel_r; // Delayed version of step, used for checking for edge of signal
	reg dir_r; // Direction signal

	always @(posedge clk) begin
		if(rst == 1'b1) begin
			coil_state_r <= 4'b0001;
			stepdel_r <= 1'b1;
			dir_r <= 1'b1;
		end else begin
			// Wait for rising edge of step pulse and drive is enabled (previously 0, now 1)
			if(en && ~stepdel_r && step) begin 
				if(dir_r == 1'b0) begin // dir = low: step towards center, coils 1>2>3>4>1...
					case(coil_state_r)
						4'b0001: coil_state_r <= 4'b0010;
						4'b0010: coil_state_r <= 4'b0100;
						4'b0100: coil_state_r <= 4'b1000;
						4'b1000: coil_state_r <= 4'b0001;
						default: coil_state_r <= 4'b0001;
					endcase
				end else if(dir_r == 1'b1) begin // dir = high: step towards edge, coils 4>3>2>1>4...
					case(coil_state_r)
						4'b0001: coil_state_r <= 4'b1000;
						4'b0010: coil_state_r <= 4'b0001;
						4'b0100: coil_state_r <= 4'b0010;
						4'b1000: coil_state_r <= 4'b0100;
						default: coil_state_r <= 4'b0001;
					endcase
				end
			end
			
			// If drive is enabled and step pulse is in progress, register current direction signal
			else if(en && ~stepdel_r) begin
				dir_r <= dir;
			end
			
			// Register the current step pulse every cycle to compare in the next cycle
			stepdel_r <= step;
		end
	end
endmodule
