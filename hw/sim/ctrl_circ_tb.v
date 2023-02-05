/* Floppy Overdrive - Sub-Level Entity Testbench
 *
 * File: ctrl_circ_tb.v
 * Author: Thomas Le <thomas.le@ufl.edu>
 * Created: Feb. 5, 2023
 *
 * Simulation testbench for the controller circuit entity.
 */

 `timescale 1ns/10ps

 module ctrl_circ_tb;
    reg clk, rst;

    // External interface
    reg dens_sel;        // Pin 2 - Density select
    wire index;           // Pin 8 - Index
    reg [3:0] drive_sel; // Pins 6, 10-14 - Drive Select 0-3
    reg motor_on;        // Pin 16 - Motor on
    reg dir_sel;         // Pin 18 - Direction select
    reg step;            // Pin 20 - Step head
    wire track_0;         // Pin 26 - Track 00 sensor
    wire wr_protect;      // Pin 28 - Write protect sensor

    // Motors 
    wire spin_en;    // Spindle motor enable
    wire spin_ss;    // Spindle speed select (1 = 360rpm, 0 = 300 rpm)
    wire [3:0] step_drv; // To 4-coil stepper motor driver (ULN2003C)

    // Sensors
    reg ind_sens;
    reg t00_sens;
    reg wpr_sens;
    reg dsk_sens;

    ctrl_circ U_CTRL(.clk, .rst, .dens_sel(dens_sel), .index(index), .drive_sel(drive_sel), .motor_on(motor_on),
                     .dir_sel(dir_sel), .step(step), .track_0(track_0), .wr_protect(wr_protect),
                     .spin_en(spin_en), .spin_ss(spin_ss), .step_drv(step_drv), .ind_sens(ind_sens),
                     .t00_sens(t00_sens), .wpr_sens(wpr_sens), .dsk_sens(dsk_sens));

    localparam half_clock = 50;
    localparam full_clock = 100; // 10 MHz
    localparam step_time = 500000; // 0.55 ms;
    localparam drive_num = 1;

    // Clock pulse gen
    always
    begin
        clk = 1'b1;
        #half_clock;
        clk = 1'b0;
        #half_clock;
    end

    always @(posedge clk)
    begin
        // Reset inputs
        rst = 1'b1;
        drive_sel = 4'b1111; // Drive disabled
        dens_sel = 1'b1;
        motor_on = 1'b1;
        dir_sel = 1'b1;
        step = 1'b1;
        ind_sens = 1'b1; // HIGH on FALSE
        t00_sens = 1'b0; // LOW on FALSE
        wpr_sens = 1'b0; // LOW on FALSE
        dsk_sens = 1'b0; // LOW on FALSE
        #full_clock
        #full_clock

        // Drive disabled - no inputs or outputs should be read
        rst = 1'b0;

        // Motor test - independent of drive select
        motor_on = 1'b0;
        #full_clock;
        if(spin_en != 1'b1)
            $display("No select: Motor not turned on at high speed");
        else if(spin_ss != 1'b1)
            $display("No select: Motor on, not set to high speed");
        
        dens_sel = 1'b0;
        #full_clock;
        if(spin_en != 1'b1)
            $display("No select: Motor not turned on at low speed");
        else if(spin_ss != 1'b0)
            $display("No select: Motor on, not set to low speed");
        
        motor_on = 1'b1;
        dens_sel = 1'b1;

        // Sensor tests
        if(index != 1'b1)
            $display("No select: Index output when no input present");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when no input present");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when no input present");

        // Index alone
        ind_sens = 1'b0;
        #full_clock;
        if(index != 1'b1)
            $display("No select: Index output when drive is not selected");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when input present on index");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when input present on index");

        // Track 0 alone
        ind_sens = 1'b1;
        t00_sens = 1'b1;
        #full_clock;
        if(index != 1'b1)
            $display("No select: Index output when input present on t00");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when drive is not selected");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when input present on t00");

        // Write protect alone
        t00_sens = 1'b0;
        wpr_sens = 1'b1;
        #full_clock;
        if(index != 1'b1)
            $display("No select: Index output when input present on write protect");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when input present on write protect");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when drive is not selected");

        // Index and track 0
        ind_sens = 1'b0;
        t00_sens = 1'b1;
        wpr_sens = 1'b0;
        #full_clock;
        if(index != 1'b1)
            $display("No select: Index output when drive is not selected");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when drive is not selected");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when input present on index and t00");

        // Index and write protect
        ind_sens = 1'b0;
        t00_sens = 1'b0;
        wpr_sens = 1'b1;
        #full_clock;
        if(index != 1'b1)
            $display("No select: Index output when drive is not selected");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when input present on index and write protect");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when drive is not selected");

        // Track 0 and write protect
        ind_sens = 1'b1;
        t00_sens = 1'b1;
        wpr_sens = 1'b1;
        #full_clock;
        if(index != 1'b1)
            $display("No select: Index output when input present on t00 and write protect");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when drive is not selected");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when drive is not selected");

        // All sensors
        ind_sens = 1'b0;
        t00_sens = 1'b1;
        wpr_sens = 1'b1;
        #full_clock;
        if(index != 1'b1)
            $display("No select: Index output when drive is not selected");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when drive is not selected");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when drive is not selected");

        ind_sens = 1'b1;
        t00_sens = 1'b0;
        wpr_sens = 1'b0;

        // Step driver
        step = 1'b0;
        #full_clock;
        #full_clock;
        step = 1'b1;
        #full_clock;
        if(step_drv != 4'b0001)
            $display("No select: Stepper motor stepped on bounce");

        #full_clock;
        #full_clock;

        step = 1'b0;
        #step_time;
        step = 1'b1;
        #full_clock;
        if(step_drv != 4'b0001)
            $display("No select: Stepper motor stepped");

        #full_clock;
        #full_clock;

        // Drive enabled - no inputs or outputs should be read
        drive_sel[drive_num] = 1'b0;

        // Motor test - independent of drive select
        motor_on = 1'b0;
        #full_clock;
        if(spin_en != 1'b1)
            $display("Select: Motor not turned on at high speed");
        else if(spin_ss != 1'b1)
            $display("Select: Motor on, not set to high speed");
        
        dens_sel = 1'b0;
        #full_clock;
        if(spin_en != 1'b1)
            $display("Select: Motor not turned on at low speed");
        else if(spin_ss != 1'b0)
            $display("Select: Motor on, not set to low speed");
        
        motor_on = 1'b1;
        dens_sel = 1'b1;

        // Sensor tests
        if(index != 1'b1)
            $display("Select: Index output when no input present");

        if(track_0 != 1'b1)
            $display("Select: Track 0 output when no input present");

        if(wr_protect != 1'b1)
            $display("Select: Write protect output when no input present");

        // Index alone
        ind_sens = 1'b0;
        #full_clock;
        if(index != 1'b0)
            $display("Select: Index not output when drive is selected");

        if(track_0 != 1'b1)
            $display("Select: Track 0 output when input present on index");

        if(wr_protect != 1'b1)
            $display("Select: Write protect output when input present on index");

        // Track 0 alone
        ind_sens = 1'b1;
        t00_sens = 1'b1;
        #full_clock;
        if(index != 1'b1)
            $display("Select: Index output when input present on t00");

        if(track_0 != 1'b0)
            $display("Select: Track 0 not output when drive is selected");

        if(wr_protect != 1'b1)
            $display("Select: Write protect output when input present on t00");

        // Write protect alone
        t00_sens = 1'b0;
        wpr_sens = 1'b1;
        #full_clock;
        if(index != 1'b1)
            $display("Select: Index output when input present on write protect");

        if(track_0 != 1'b1)
            $display("Select: Track 0 output when input present on write protect");

        if(wr_protect != 1'b0)
            $display("Select: Write protect not output when drive is selected");

        // Index and track 0
        ind_sens = 1'b0;
        t00_sens = 1'b1;
        wpr_sens = 1'b0;
        #full_clock;
        if(index != 1'b0)
            $display("Select: Index not output when drive is selected");

        if(track_0 != 1'b0)
            $display("Select: Track 0 not output when drive is selected");

        if(wr_protect != 1'b1)
            $display("Select: Write protect output when input present on index and t00");

        // Index and write protect
        ind_sens = 1'b0;
        t00_sens = 1'b0;
        wpr_sens = 1'b1;
        #full_clock;
        if(index != 1'b0)
            $display("Select: Index not output when drive is selected");

        if(track_0 != 1'b1)
            $display("Select: Track 0 output when input present on index and write protect");

        if(wr_protect != 1'b0)
            $display("Select: Write protect not output when drive is selected");

        // Track 0 and write protect
        ind_sens = 1'b1;
        t00_sens = 1'b1;
        wpr_sens = 1'b1;
        #full_clock;
        if(index != 1'b1)
            $display("Select: Index output when input present on t00 and write protect");

        if(track_0 != 1'b0)
            $display("Select: Track 0 not output when drive is selected");

        if(wr_protect != 1'b0)
            $display("Select: Write not protect output when drive is selected");

        // All sensors
        ind_sens = 1'b0;
        t00_sens = 1'b1;
        wpr_sens = 1'b1;
        #full_clock;
        if(index != 1'b0)
            $display("Select: Index not output when drive is selected");

        if(track_0 != 1'b0)
            $display("Select: Track 0 not output when drive is selected");

        if(wr_protect != 1'b0)
            $display("Select: Write protect not output when drive is selected");

        ind_sens = 1'b1;
        t00_sens = 1'b0;
        wpr_sens = 1'b0;

        // Step driver
        step = 1'b0;
        #full_clock;
        #full_clock;
        step = 1'b1;
        #full_clock;
        if(step_drv != 4'b0001)
            $display("Select: Stepper motor stepped on bounce");

        #full_clock;
        #full_clock;

        step = 1'b0;
        dir_sel = 1'b0;
        #step_time;
        step = 1'b1;
        #full_clock;
        #full_clock;
        #full_clock;
        #full_clock;
        if(step_drv == 4'b0001)
            $display("Select: Stepper motor not stepped forwards");
        else if(step_drv == 4'b1000)
            $display("Select: Stepper motor stepped backwards");
        else if(step_drv == 4'b0100)
            $display("Select: Stepper motor stepped multiple times");
        else begin // Only continue if state is 4'b0010
            #full_clock;
            #full_clock;

            step = 1'b0;
            dir_sel = 1'b1;
            #step_time;
            step = 1'b1;
            #full_clock;
            #full_clock;
            #full_clock;
            #full_clock;
            if(step_drv == 4'b0010)
                $display("Select: Stepper motor not stepped backwards");
            else if(step_drv == 4'b0100)
                $display("Select: Stepper motor stepped forwards");
            else if(step_drv == 4'b1000)
                $display("Select: Stepper motor stepped multiple times");
        end

        $stop;
    end
 endmodule