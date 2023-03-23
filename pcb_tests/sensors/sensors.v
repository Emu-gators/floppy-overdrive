/* File: sensors.v
 * Author: Thomas Le <thomas.le@ufl.edu>
 * Created: Mar. 22, 2023
 */

module top(
    // External interface
    output wire index,          // Pin 8 - Index
    output wire track_0,        // Pin 26 - Track 00 sensor
    output wire wr_protect,     // Pin 28 - Write protect sensor

    // Sensors
    input wire ind_sens, // Low on TRUE (hole present), High on FALSE
    input wire t00_sens, // Low on FALSE (not at tr0), High on TRUE
    input wire wpr_sens, // Low on FALSE (notch present), High on TRUE
    input wire dsk_sens, // Low on FALSE (disk not present), High on TRUE
);

// Bus outputs are active-low

// Index sensor output
assign index = ~(~ind_sens);

// Track 0 sensor output
assign track_0 = ~(t00_sens);

// Write-protect sensor output
assign wr_protect = ~(wpr_sens);

endmodule
