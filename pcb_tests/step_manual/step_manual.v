/* File: step_manual.v
 * Author: Thomas Le <thomas.le@ufl.edu>
 * Created: Mar. 22, 2023
 */

module top(
    // Clock
    input wire clk,

    // External interface
    input wire dir_sel, // Pin 18 - Direction select
    input wire step,    // Pin 20 - Step head

    // Motors 
    output wire step_0, // To 4-coil stepper motor driver (ULN2003C)
    output wire step_1,
    output wire step_2,
    output wire step_3,

    // Sensors
    input wire t00_sens // Low on FALSE (not at tr0), High on TRUE
);

wire enable = 1'b1;
wire rst = 1'b0;
wire [3:0] step_drv;

wire pll_clk;
wire locked;
pll U_PLL(.clock_in(clk), .global_clock(pll_clk), .locked(locked));

step_driver_deb U_DRIVER(
	.clk(pll_clk),
	.rst(rst),
	.step(step),
	.dir(dir_sel),
	.tr0(tr00_sens),
	.en(enable),
	.coils(step_drv)
);

assign step_0 = step_drv[0];
assign step_1 = step_drv[1];
assign step_2 = step_drv[2];
assign step_3 = step_drv[3];

endmodule
