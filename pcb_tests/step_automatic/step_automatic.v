/* File: step_automatic.v
 * Author: Thomas Le <thomas.le@ufl.edu>
 * Created: Mar. 29, 2023
 *
 * Note: DO NOT have the stepper motor connected to the board
 * while running this code to prevent damage ot the drive.
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
reg [3:0] step_drv;

wire pll_clk;
wire locked;
pll U_PLL(.clock_in(clk), .global_clock(pll_clk), .locked(locked));

/* Counter register */
reg [31:0] counter = 32'b0;

localparam TIMER_HALF = 5000000;
localparam TIMER_FULL = TIMER_HALF*2;

/* Increment coil on every edge of the incoming 50MHz PLL clk */
always @ (posedge pll_clk, posedge rst) begin
    if(rst == 1'b1) begin
        counter <= 32'd0;
        step_drv <= 4'b0001;
    end
    else begin
        counter <= counter + 1;

        if(counter > TIMER_FULL) begin
            counter <= 32'b0;

            case(step_drv)
                4'b0001: begin
                    if(dir_sel == 1'b0) begin
                        step_drv <= 4'b1000;
                    end
                    else begin
                        step_drv <= 4'b0010;
                    end
                end

                4'b0010: begin
                    if(dir_sel == 1'b0) begin
                        step_drv <= 4'b0001;
                    end
                    else begin
                        step_drv <= 4'b0100;
                    end
                end

                4'b0100: begin
                    if(dir_sel == 1'b0) begin
                        step_drv <= 4'b0010;
                    end
                    else begin
                        step_drv <= 4'b1000;
                    end
                end

                4'b1000: begin
                    if(dir_sel == 1'b0) begin
                        step_drv <= 4'b0100;
                    end
                    else begin
                        step_drv <= 4'b0001;
                    end
                end

                default: step_drv <= 4'b0001;
            endcase
        end
    end
end

assign step_0 = step_drv[0];
assign step_1 = step_drv[1];
assign step_2 = step_drv[2];
assign step_3 = step_drv[3];

endmodule
