/* Floppy Overdrive - Controller Test Harness
 *
 * File: circ_test_top.v
 * Author: Thomas Le <thomas.le@ufl.edu>
 * Created: Nov. 15, 2022
 *
 * This is a top-level entity solely for testing the mechanical
 * control circuit of the system using user-controlled switches,
 * connected directly to the headers of the drive's components.
 */

module circ_test_top(
	input wire clk,

	// DE-10 Inputs
	input wire motor_sw,    // SW1
	input wire speed_sw,    // SW2
	input wire step_out_sw, // KEY0
	input wire step_in_sw,  // KEY1
	input wire reset_sw,    // SW0
	
	// Floppy sensor Inputs
	input wire tr0_sens,
	input wire dsk_sens,
	input wire wpr_sens,
	input wire ind_sens,
	
	// Spindle motor outputs
	output wire spin_en, // 1 = motor on, 0 = motor off
	output wire spin_ss, // 1 = 360rpm (HD), 0 = 300rpm (DD)
	
	// Stepper motor 4-coil output, to ULN2003C
	output wire [3:0] step_coil,
	output wire [3:0] step_LED, // LED5-8
	
	// Monitor LEDs
	output wire dsk_LED, // LED0
	output wire wpr_LED, // LED1
	output wire ind_LED, // LED2
	output wire tr0_LED, // LED3
	output wire rdy_LED, // LED4
	output wire pnl_LED, // Floppy front panel
	
	output wire other_LED // LED9
	);
	
wire dir; // DIR = 1 when stepping out, switches are active low
assign dir = ~step_out_sw;

wire step;
assign step = step_in_sw & step_out_sw; // Step on either press

wire [6:0] track;

assign other_LED = step;

assign step_LED = step_coil;
	
ctrl_circ U_TEST(
	.clk(clk), //TODO??
	.rst(reset_sw),
	.dens_sel(speed_sw),
	.in_use(1'b1),
	.index(ind_LED),
	.drive_sel(4'b0010), // Hard-wired to disk 1
	.motor_on(motor_sw),
	.dir_sel(dir),
	.step(step),
	.track_0(tr0_LED),
	.wr_protect(wpr_LED),
	.ready(rdy_LED),
	.spin_en(spin_en),
	.spin_ss(spin_ss),
	.ind_sens(ind_sens),
	.t00_sens(tr0_sens),
	.wpr_sens(wpr_sens),
	.dsk_sens(dsk_sens),
	.step_drv(step_coil),
	.front_LED(pnl_LED),
	.trk_count(track), //TODO output LEDs
	.dsk_LED(dsk_LED)
	);
	
endmodule