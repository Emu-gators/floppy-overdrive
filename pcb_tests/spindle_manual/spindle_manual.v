/* File: spindle_manual.v
 * Author: Thomas Le <thomas.le@ufl.edu>
 * Created: Mar. 22, 2023
 */

module top(
    // External interface
    input wire dens_sel,        // Pin 2 - Density select
    input wire motor_on,        // Pin 16 - Motor on

    // Motors 
    output wire spin_en,    // Spindle motor enable
	output wire spin_ss    // Spindle speed select (1 = 360rpm, 0 = 300 rpm)
);

// Spindle logic - enable and speed select
// Enable motor when disk inserted and enabled on bus
assign spin_en = ~motor_on; // Motor enable is independent signal, active-low
assign spin_ss = dens_sel; // Dependent on density select (HI = 360, LO = 300)

endmodule
