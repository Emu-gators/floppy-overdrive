/*
 *  
 *  Modified by Thomas Le, Spring 2023
 *  Copyright(C) 2018 Gerald Coe, Devantech Ltd <gerry@devantech.co.uk>
 * 
 *  Permission to use, copy, modify, and/or distribute this software for any purpose with or
 *  without fee is hereby granted, provided that the above copyright notice and 
 *  this permission notice appear in all copies.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO
 *  THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. 
 *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL 
 *  DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
 *  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN 
 *  CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 * 
 */


// Pulse the Floppy bus pins at 1 kHz
/* module */
module top (
    input clk,
    output bus0,
    output bus1,
    output bus2,
    output bus3,
    output bus4,
    output bus5,
    output bus6,
    output bus7,
    output bus8,
    output bus9,
    output bus10,
    output bus11,
    output bus12,
    output bus13,
    output bus14,
    output bus15
    );

    /* I/O */
    wire [15:0] bus_out;

    localparam TIMER_HALF = 50000;
    localparam TIMER_FULL = TIMER_HALF*2;

    /* Counter register */
    reg [31:0] counter = 32'b0;

    wire pll_clk;
    wire locked;
    pll U_PLL(.clock_in(clk), .global_clock(pll_clk), .locked(locked));

    /* LED drivers - counter is inverted for display because leds are active low */
    always @* begin
        if(counter < TIMER_HALF) begin
            bus_out = {16{1'b0}};
        end
        else begin
            bus_out = {16{1'b1}};
        end
    end


    /* Count up on every edge of the incoming 50MHz PLL clk */
    always @ (posedge pll_clk) begin
        counter <= counter + 1;

        if(counter > TIMER_FULL) begin
            counter <= 32'b0;
        end
    end

    assign bus0 = bus_out[0];
    assign bus1 = bus_out[1];
    assign bus2 = bus_out[2];
    assign bus3 = bus_out[3];
    assign bus4 = bus_out[4];
    assign bus5 = bus_out[5];
    assign bus6 = bus_out[6];
    assign bus7 = bus_out[7];
    assign bus8 = bus_out[8];
    assign bus9 = bus_out[9];
    assign bus10 = bus_out[10];
    assign bus11 = bus_out[11];
    assign bus12 = bus_out[12];
    assign bus13 = bus_out[13];
    assign bus14 = bus_out[14];
    assign bus15 = bus_out[15];

endmodule
