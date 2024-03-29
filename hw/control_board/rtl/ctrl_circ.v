/* Floppy Overdrive - Sub-Level Entity
 *
 * File: ctrl_circ.v
 * Author: Thomas Le <thomas.le@ufl.edu>, Chase Ruskin
 * Created: Nov. 1, 2022
 *
 * This module handles control signals from the input bus and sensors. It also
 * controls the motorized components as necessary.
 */

module ctrl_circ(
    // Clock, reset
    input wire clk,
    input wire rst,

    // FDC interface
    input wire dens_sel,        // Pin 2 - Density select
    input wire in_use,          // Pin 4 - In Use / Head Load
    output wire index,          // Pin 8 - Index
    input wire [3:0] drive_sel, // Pins 6, 10-14 - Drive Select 0-3
    input wire motor_on,        // Pin 16 - Motor on
    input wire dir_sel,         // Pin 18 - Direction select
    input wire step,            // Pin 20 - Step head
    // input wire wr_gate,      // Pin 24 - Write gate (currently unused)
    output wire track_0,        // Pin 26 - Track 00 sensor
    output wire wr_protect,     // Pin 28 - Write protect sensor
    output wire ready,          // Pin 34 - Drive ready

    // Motors 
    output wire spin_en,        // Spindle motor enable
	output wire spin_ss,        // Spindle speed select (1 = 360rpm/High Density, 0 = 300rpm/Double Density)
    output wire [3:0] step_drv, // To 4-coil stepper motor driver (ULN2003C)
    // output wire head_load,   // Head load solenoid (currently unused)

    // Sensors
    input wire ind_sens, // Low on TRUE (hole present), High on FALSE
    input wire t00_sens, // Low on FALSE (not at tr0), High on TRUE
    input wire wpr_sens, // Low on FALSE (notch present), High on TRUE
	input wire dsk_sens, // Low on FALSE (disk not present), High on TRUE
	 
	 // Misc. outputs
    output wire front_LED, // Floppy front panel
	output wire dsk_LED // Extra LED for verifying the disk sensor 
);

    localparam DRIVE_NUM = 1; // Can be changed to determine the drive number 

    wire enable = ~drive_sel[DRIVE_NUM]; // The drive is enabled when the respective drive select line is low

    // Stepper motor control - implemented in step_driver_deb.v
    step_driver_deb U_DRIVER(
        .clk(clk),
        .rst(rst),
        .step(step),
        .dir(dir_sel),
        .tr0(t00_sens),
        .en(enable),
        .coils(step_drv)
    );

    // Spindle motor control - controls when motor is enabled and speed of the motor
    assign spin_en = ~motor_on; // Motor enable is an active-low signal, independent from the drive select
    assign spin_ss = dens_sel; // Drive speed is dependent on the density select signal

    // Sensor outputs - sent over FDC bus
    // All outputs should be active-low and are only output when the drive is enabled

    // Index sensor output
    assign index = ~(~ind_sens & enable); // The index sensor in this drive is active-low, so ind_sens must be inverted

    // Track 0 sensor output
    assign track_0 = ~(t00_sens & enable);

    // Write-protect sensor output
    assign wr_protect = ~(wpr_sens & enable);

    // Ready signal logic
    // This signal varies throughout different drives and FDCs, and this logic may need to be modified to account for this.
    assign ready = 1'b0; // Not used

    // Front panel LED
    assign front_LED = spin_en; // The front panel LED should be enabled when the motor is spinning

    // Disk inserted sensor
    assign dsk_LED = dsk_sens;

endmodule