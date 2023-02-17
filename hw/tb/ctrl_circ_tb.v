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

    // Define the module for the controller interface
    ctrl_circ U_CTRL(.clk, .rst, .dens_sel(dens_sel), .index(index), .drive_sel(drive_sel), .motor_on(motor_on),
                     .dir_sel(dir_sel), .step(step), .track_0(track_0), .wr_protect(wr_protect),
                     .spin_en(spin_en), .spin_ss(spin_ss), .step_drv(step_drv), .ind_sens(ind_sens),
                     .t00_sens(t00_sens), .wpr_sens(wpr_sens), .dsk_sens(dsk_sens));

    localparam half_clock = 50;
    localparam full_clock = 100; // 10 MHz
    localparam step_time = 500000; // 0.55 ms;
    localparam drive_num = 1;

    // Clock pulse generator - the clock will rise and fall every 50ns to give a total period of 100 ns (10 MHz)
    always
    begin
        clk = 1'b1;
        #half_clock;
        clk = 1'b0;
        #half_clock;
    end

    // Tests - Various inputs to the controller circuit will be tested in this block sequentially,
    // and each output will be asserted against the expected output
    always @(posedge clk)
    begin
        // Reset inputs to their default states
        rst = 1'b1;
        drive_sel = 4'b1111; // Drive disabled
        dens_sel = 1'b1;
        motor_on = 1'b1;
        dir_sel = 1'b1;
        step = 1'b1;
        ind_sens = 1'b1; // This sensor is HIGH on FALSE
        t00_sens = 1'b0; // This sensor is LOW on FALSE
        wpr_sens = 1'b0; // This sensor is LOW on FALSE
        dsk_sens = 1'b0; // This sensor is LOW on FALSE
        #full_clock
        #full_clock

        // TEST BLOCK
        // The currently selected drive is not the controller - no inputs or outputs should be read
        rst = 1'b0;

        // Motor test - independent of drive select, the motor should be able to be enabled or disabled
        motor_on = 1'b0; // Enable signal (active-low)
        #full_clock; // Wait for a full clock cycle
        if(spin_en != 1'b1) // Incorrect: Motor is currently off
            $display("No select: Motor not turned on at high speed");
        else if(spin_ss != 1'b1) // Incorrect: Motor is currently at a low speed
            $display("No select: Motor on, not set to high speed");
        
        // Density select - Motor should spin at the slower speed (speed select is low)
        dens_sel = 1'b0;
        #full_clock;
        if(spin_en != 1'b1)
            $display("No select: Motor not turned on at low speed");
        else if(spin_ss != 1'b0)
            $display("No select: Motor on, not set to low speed");
        
        // Disable motor
        motor_on = 1'b1;
        dens_sel = 1'b1;

        // Sensor tests - Each test first enables their corresponding sensors and then asserts against the outputs to make sure that they are on (or off) as expected
        // No outputs should be seen since the drive is not selected
        if(index != 1'b1)
            $display("No select: Index output when no input present");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when no input present");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when no input present");

        // Asserting the index signal alone
        ind_sens = 1'b0; // On
        #full_clock;
        if(index != 1'b1)
            $display("No select: Index output when drive is not selected");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when input present on index");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when input present on index");

        // Asserting the track 0 signal alone
        ind_sens = 1'b1; // Off
        t00_sens = 1'b1; // On
        #full_clock;
        // Checking the outputs - display an error when does not match expected
        if(index != 1'b1)
            $display("No select: Index output when input present on t00");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when drive is not selected");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when input present on t00");

        // Write protect alone
        t00_sens = 1'b0; // Off
        wpr_sens = 1'b1; // On
        #full_clock;
        if(index != 1'b1)
            $display("No select: Index output when input present on write protect");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when input present on write protect");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when drive is not selected");

        // Index and track 0
        ind_sens = 1'b0; // On
        t00_sens = 1'b1; // On
        wpr_sens = 1'b0; // Off
        #full_clock;
        if(index != 1'b1)
            $display("No select: Index output when drive is not selected");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when drive is not selected");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when input present on index and t00");

        // Index and write protect
        ind_sens = 1'b0; // On
        t00_sens = 1'b0; // Off
        wpr_sens = 1'b1; // On
        #full_clock;
        if(index != 1'b1)
            $display("No select: Index output when drive is not selected");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when input present on index and write protect");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when drive is not selected");

        // Track 0 and write protect
        ind_sens = 1'b1; // Off
        t00_sens = 1'b1; // On
        wpr_sens = 1'b1; // On
        #full_clock;
        if(index != 1'b1)
            $display("No select: Index output when input present on t00 and write protect");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when drive is not selected");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when drive is not selected");

        // All sensors
        ind_sens = 1'b0; // On
        t00_sens = 1'b1; // On
        wpr_sens = 1'b1; // On
        #full_clock;
        if(index != 1'b1)
            $display("No select: Index output when drive is not selected");

        if(track_0 != 1'b1)
            $display("No select: Track 0 output when drive is not selected");

        if(wr_protect != 1'b1)
            $display("No select: Write protect output when drive is not selected");

        // Clearing all sensor signals to off
        ind_sens = 1'b1;
        t00_sens = 1'b0;
        wpr_sens = 1'b0;

        // Testing the stepper driver: the currenttly energized coil (step_drv) should not change at any point
        // Simulating a bounce
        step = 1'b0; // Enable step line
        #full_clock; // Wait two clock cycles (200 ns)
        #full_clock;
        step = 1'b1; // Disable step line - waveform should resemble a 200 ns active-low pulse, less than that needed to step the motor
        #full_clock;
        if(step_drv != 4'b0001)
            $display("No select: Stepper motor stepped on bounce");

        // Wait for another 200ns - step pulses will not be sent by the controller less than 3ms apart
        #full_clock;
        #full_clock;

        // Simulating a real step pulse
        step = 1'b0;
        #step_time; // Wait for 0.5ms
        step = 1'b1;
        #full_clock;
        if(step_drv != 4'b0001) // Head should still not move since drive is not selected
            $display("No select: Stepper motor stepped");

        #full_clock;
        #full_clock;

        // TEST BLOCK
        // Drive enabled - drive should resond to inputs
        drive_sel[drive_num] = 1'b0; // Assert correct drive number

        // Motor test - independent of drive select, should turn on and off as requested
        // High speed motor enable
        motor_on = 1'b0;
        #full_clock;
        if(spin_en != 1'b1)
            $display("Select: Motor not turned on at high speed");
        else if(spin_ss != 1'b1)
            $display("Select: Motor on, not set to high speed");
        
        // Low speed motor enable
        dens_sel = 1'b0;
        #full_clock;
        if(spin_en != 1'b1)
            $display("Select: Motor not turned on at low speed");
        else if(spin_ss != 1'b0)
            $display("Select: Motor on, not set to low speed");
        

        // Disable motor inputs and ensure the motor is actually diabled
        motor_on = 1'b1;
        dens_sel = 1'b1;

        if(spin_en != 1'b0)
            $display("Select: Motor still turned on");

        // Sensor tests - outputs should now correspond o the current state of the sensors since the drive is selected
        // No sesnors are currently on, so no output lines should be output
        if(index != 1'b1)
            $display("Select: Index output when no input present");

        if(track_0 != 1'b1)
            $display("Select: Track 0 output when no input present");

        if(wr_protect != 1'b1)
            $display("Select: Write protect output when no input present");

        // Index sensor alone - only index output whould be on
        ind_sens = 1'b0;
        #full_clock;
        if(index != 1'b0)
            $display("Select: Index not output when drive is selected");

        if(track_0 != 1'b1)
            $display("Select: Track 0 output when input present on index");

        if(wr_protect != 1'b1)
            $display("Select: Write protect output when input present on index");

        // Track 0 sensor alone - only track 0 output should be on
        ind_sens = 1'b1;
        t00_sens = 1'b1;
        #full_clock;
        if(index != 1'b1)
            $display("Select: Index output when input present on t00");

        if(track_0 != 1'b0)
            $display("Select: Track 0 not output when drive is selected");

        if(wr_protect != 1'b1)
            $display("Select: Write protect output when input present on t00");

        // Write protect alone - ditto
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

        // Step driver - coil should change in proper order to move head, i.e. 0001>0010>0100>1000>0001>...
        // Only one coil should be on at all times

        // Simulating a bounce - too short to be a real pulse
        step = 1'b0;
        #full_clock;
        #full_clock;
        step = 1'b1;
        #full_clock;
        if(step_drv != 4'b0001) // Coils should remain unchanged (0001 is the default state)
            $display("Select: Stepper motor stepped on bounce");

        #full_clock;
        #full_clock;

        // Simulating a forwards step - the dirsction input is asserted and the step line in pulsed low for an appropriate period of time.
        // New coil state should be 0010
        step = 1'b0;
        dir_sel = 1'b0;
        #step_time;
        step = 1'b1;
        #full_clock;
        #full_clock;
        #full_clock;
        #full_clock;
        if(step_drv == 4'b0001) // Has not moved
            $display("Select: Stepper motor not stepped forwards");
        else if(step_drv == 4'b1000) // Has moved backwards
            $display("Select: Stepper motor stepped backwards");
        else if(step_drv == 4'b0100) // Has stepped at least twice
            $display("Select: Stepper motor stepped multiple times");
        else begin // Only continue testing if the current state is 4'b0010
            #full_clock;
            #full_clock;

            // Simulating a backwards step
            step = 1'b0;
            dir_sel = 1'b1;
            #step_time;
            step = 1'b1;
            #full_clock;
            #full_clock;
            #full_clock;
            #full_clock;
            if(step_drv == 4'b0010) // Has not moved
                $display("Select: Stepper motor not stepped backwards");
            else if(step_drv == 4'b0100) // Has moved forwards
                $display("Select: Stepper motor stepped forwards");
            else if(step_drv == 4'b1000) // Has moved backwards
                $display("Select: Stepper motor stepped multiple times");
        end

        // End of testbench
        $stop;
    end
 endmodule