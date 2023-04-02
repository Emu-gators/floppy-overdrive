/* Floppy Overdrive - Testing Top-Level Circuit
 *
 * File: ctrl_test_top.v
 * Author: Thomas Le <thomas.le@ufl.edu>
 * Created: Nov. 17, 2022
 *
 * This module wraps just the control circuit in a top-level entity,
 * which can be used for controlling the drive mechanically with an FDC,
 * although no data will be returned.
 *
 * This circuit is designed for the iceWerx module and should be used 
 * on the current revision of the breakout PCB.
 */

module ctrl_test_top(
	input wire clk,       // Pin P7

	// FDC Inputs
	input wire motor_in,  // Pin N14
	input wire dens_in,   // Pin E12
	input wire step_in,   // Pin P8
	input wire dir_in,    // Pin M12
	//input wire drive_sel, // Currently ignored (see sel_manual below)
	
	// Floppy sensor Inputs
	input wire tr0_sens, // Pin D3
	input wire dsk_sens, // Pin A3
	input wire wpr_sens, // Pin A4
	input wire ind_sens, // Pin A1
	
	// Spindle motor outputs
	output wire spin_en, // Pin M6
	output wire spin_ss, // Pin M7
	
	// Stepper motor outputs, to ULN2003C
	output wire step_0,  // Pin C5
	output wire step_1,  // Pin C4
	output wire step_2,  // Pin A2
	output wire step_3,  // Pin B1
	
	// Sensor outputs
	output wire tr0_out, // Pin L14
	output wire ind_out, // Pin G12
	output wire wpr_out, // Pin K14

	// Green LED for inserted disk
	output wire dsk_LED  // Pin M4
	);

	// Stepper motor coils
	// These inputs must be set as individual pins to work with the iceStorm toolchain
	wire [3:0] step_coil;
	assign step_0 = step_0[0];
	assign step_1 = step_1[1];
	assign step_2 = step_2[2];
	assign step_3 = step_3[3];

	// PLL Module - See Lattice iCE40 documentation
	// This module brings the 12 MHz clock up to 50 MHz, which was the speed initially used for this circuit.
	// The control circuit will likely work at 12 MHz, but this has not been tested.
	wire pll_clk;
    wire locked;
    pll U_PLL(.clock_in(clk), .global_clock(pll_clk), .locked(locked));

	// Drive select signals - manually set the to drive 1, so the circuit is always enabled.
	wire [3:0] sel_manual;
	assign sel_manual = 4'b1101; // Drive 1 set to low
	
	// Instantiate the control circuit module
	ctrl_circ U_TEST(
		.clk(pll_clk),
		.rst(1'b1), // PCB has on-board reset
		.dens_sel(dens_in),
		.index(ind_out),
		.drive_sel(sel_manual),
		.motor_on(motor_in),
		.dir_sel(dir_in),
		.step(step_in),
		.track_0(tr0_out),
		.wr_protect(wpr_out),
		.spin_en(spin_en),
		.spin_ss(spin_ss),
		.ind_sens(ind_sens),
		.t00_sens(tr0_sens),
		.wpr_sens(wpr_sens),
		.dsk_sens(dsk_sens),
		.step_drv(step_coil),
		.dsk_LED(dsk_LED)
		);
		
endmodule