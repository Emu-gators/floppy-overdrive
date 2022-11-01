/* Floppy Overdrive - Sub-Level Entity
 *
 * File: rw_circ.v
 * Author: Thomas Le <thomas.le@ufl.edu>, Chase Ruskin
 * Created: Nov. 1, 2022
 *
 * This module handles communicating with R/W magnetic heads to get data from 
 * the disk and converts it into data pulses for the floppy bus.
 */

module rw_circ(
    // Clock, reset
    input wire clk,
    input wire rst,

    // External interface
    input wire side_sel,        // Pin 32 - Side select
    input wire wr_data,         // Pin 22 - Write data (unused?)
    output wire rd_data,        // Pin 30 - Read data

    // Head 0 interface
    output wire hd0_clk,
    input wire hd0_data,
    output wire hd0_cs,

    // Head 1 interface
    output wire hd1_clk,
    input wire hd1_data,
    output wire hd1_cs,

    // Submodule communication
    input wire int_trk_count,
    // input wire int_wr_gate,
    // input wire int_ers_gate,
);

endmodule