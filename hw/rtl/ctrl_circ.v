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

    // External interface
    input wire dens_sel,        // Pin 2 - Density select
    input wire in_use,          // Pin 4 - In Use / Head Load
    output wire index,          // Pin 8 - Index
    input wire [3:0] drive_sel, // Pins 6, 10-14 - Drive Select 0-3
    input wire motor_on,        // Pin 16 - Motor on
    input wire dir_sel,         // Pin 18 - Direction select
    input wire step,            // Pin 20 - Step head
    // input wire wr_gate,         // Pin 24 - Write gate (unused?)
    output wire track_0,        // Pin 26 - Track 00 sensor
    output wire wr_protect,     // Pin 28 - Write protect sensor
    output wire ready,          // Pin 34 - Drive ready

    // Motors 
    output wire spindle,        // Spindle motor driver
    output wire step_motor,     // Stepper motor driver
    output wire head_load,      // Head load solenoid

    // Sensors
    input wire ind_sens,
    input wire t00_sens,
    input wire wp_sens,
    output wire front_LED,      // misc. LED visual on floppy drive front panel

    // Submodule communication
    output wire int_trk_count,
    // output wire int_wr_gate,
    // output wire int_ers_gate,
);

endmodule