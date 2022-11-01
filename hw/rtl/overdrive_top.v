/* Floppy Overdrive - Top-Level Entity
 *
 * File: overdrive_top.v
 * Author: Thomas Le <thomas.le@ufl.edu>, Chase Ruskin
 * Created: Nov. 1, 2022
 *
 * This module contains the top-level entity for the Floopy Overdrive System,
 * including the pins required for the standard 34-pin interface, various motor
 * controls, sensors, and ADC for interfacing with the R/W heads.
 */

module overdrive_top(
    // Clock, reset
    input wire clk,
    input wire rst,

    // Interface pins
    input wire dens_sel,        // Pin 2 - Density select
    input wire in_use,          // Pin 4 - In Use / Head Load
    output wire index,          // Pin 8 - Index
    input wire [3:0] drive_sel, // Pins 6, 10-14 - Drive Select 0-3
    input wire motor_on,        // Pin 16 - Motor on
    input wire dir_sel,         // Pin 18 - Direction select
    input wire step,            // Pin 20 - Step head
    input wire wr_data,         // Pin 22 - Write data (unused?)
    input wire wr_gate,         // Pin 24 - Write gate (unused?)
    output wire track_0,        // Pin 26 - Track 00 sensor
    output wire wr_protect,     // Pin 28 - Write protect sensor
    output wire rd_data,        // Pin 30 - Read data
    input wire side_sel,        // Pin 32 - Side select
    output wire ready,          // Pin 34 - Drive ready

    // Motor controls
    output wire spindle, // Spindle motor driver
    output wire step_motor, // Stepper motor driver
    output wire head_load, // Head load solenoid

    // Sensors
    input wire ind_sens,
    input wire t00_sens,
    input wire wp_sens,

    // Head ADC interfaces
    output wire hd0_clk,
    input wire hd0_data,
    output wire hd0_cs,

    output wire hd1_clk,
    input wire hd1_data,
    output wire hd1_cs,

    // Misc.
    output wire front_LED
);

    wire [6:0] int_trk_count; // Communicate current track count between submodules
    //wire int_wr_gate, int_ers_gate; // Communicate write and erase gate states between submodules (unused)

    // Read-Write Circuit
    // Handles communicating with R/W magnetic heads to get data from the disk
    // and convert it into data pulses for the floppy bus.
    overdrive_rw rw_circ(
        .clk(clk),
        .rst(rst),
        
        // External interface
        .side_sel(side_sel),
        .wr_data(wr_data),
        .rd_data(rd_data),

        // Head 0 interface
        .hd0_clk(hd0_clk),
        .hd0_data(hd0_data),
        .hd0_cs(hd0_cs),

        // Head 1 interface
        .hd1_clk(hd1_clk),
        .hd1_data(hd1_data),
        .hd1_cs(hd1_cs),

        // Submodule communication
        //.int_wr_gate(int_wr_gate),
        //.int_ers_gate(int_ers_gate),
        .int_trk_count(int_trk_count),
    );

    // Controller Circuit
    // Handles control signals from the input bus and sensors and controls
    // the motorized components as necessary.
    overdrive_ctrl ctrl_circ(
        .clk(clk),
        .rst(rst),

        // External interface
        .dens_sel(dens_sel),
        .in_use(in_use),
        .index(index),
        .drive_sel(drive_sel),
        .motor_on(motor_on),
        .dir_sel(dir_sel),
        .step(step),
        //.wr_gate(wr_gate),
        .track_0(track_0),
        .wr_protect(wr_protect),
        .ready(ready),

        // Motors
        .spindle(spindle),
        .step_motor(step_motor),
        .head_load(head_load)

        // Sensors
        .ind_sens(ind_sens),
        .t00_sens(t00_sens),
        .wp_sens(wp_sens),
        .front_LED(front_LED),

        // Submodule communication
        .int_trk_count(int_trk_count),
        //.int_wr_gate_r(int_wr_gate),
        //.int_ers_gate(int_ers_gate),
    );

endmodule
