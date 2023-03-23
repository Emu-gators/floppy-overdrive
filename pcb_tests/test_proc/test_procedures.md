# Floppy Overdrive - Control Board Test Procedures

## Section 1: Physical Inspection

### Visual Inspection
1. With the control board placed silkscreen side up, inspect the physical condition of the board. Compare the board against the provided schematic diagram to ensure that the shape matches and all silkscreen text is present.
2. Ensure that there are no visibly broken traces on the board. Attempt to follow each trace as closely as possible and repeat this process on both sides of the board.

### Board Fit Test
1. Remove the NAMFN control board from the Mitsubishi MF504A floppy drive. Retain the two screws from the connector side of the board.
2. Insert the control board into the drive, roughly aligning it with where the original board was placed.
3. Inspect the connector side screw holes from above. Ensure that the board’s screw holes align with those on the drive casing.
4. Using the original screws set aside, secure the control board in place and ensure that there is no interference between the screws and PCB while replacing them.

## Section 2: Power Testing

### Ground Continuity

### External Voltage Rails (+5V/+12V)
1. With the FPGA device removed, connect a 4-pin +5V/+12V power supply to the board at Header J1.
2. Connect the negative end of a multimeter to Pin 40 of Header J8 (GND).
3. Turn on the power supply.
4. Touch the positive end of the multimeter to test points TP1 (+5V) and TP2 (+12V). For each, ensure that the multimeter reads a proper voltage as expected on that line.
5. Touch the multimeter to pin 9 of U3 and ensure that the device is receiving 12 volts.
6. Touch the multimeter to pin 19 of U1 and U2 and ensure that each device is receiving 5 volts.
7. Touch the multimeter to pin 1 of J8 (the breakout pin header) and ensure that 5 volts is available on that pin.
8. Insert a wire into pin 35 of J3, device U4 and connect it to the multimeter. Ensure that 5 volts is present on that pin.
9. Disable the power supply.

### Amplifier Supply Voltage Rails (+/-2.5V)
1. With the FPGA device removed, connect a 4-pin +5V/+12V power supply to the board at Header J1.
2. Connect the negative end of a multimeter to Pin 40 of Header J8 (GND).
3. Turn on the power supply.
4. Touch the positive end of the multimeter to test point TP17 (+2.5V) and ensure that there is only POSITIVE 2.5 volts present.
5. Touch the positive end of the multimeter to test point TP16 (-2.5V) and ensure that there is only NEGATIVE 2.5 volts present.
6. When these voltages are confirmed, touch the positive end of the multimeter to pin 3 on IC1-2 to ensure those devices are receiving +2.5V.
7. Touch the positive end of the multimeter to pin 6 on IC1-2 to ensure those devices are also receiving -2.5V.

### FPGA Supply Voltage Rails (+3.3V)
1. With the FPGA device (U4) inserted in its socket, connect a 4-pin +5V/+12V power supply to the board at Header J1.
2. Connect the negative end of a multimeter to Pin 40 of Header J8 (GND) and the positive end to Pin 39 (+3.3V).
3. Turn on the power supply.
4. Ensure that the multimeter is reading +3.3V.
5. Touch the multimeter to pin 2 of U1 and U2 and ensure that each device is receiving +3.3V volts.
6. Touch the multimeter to pin 39 of J8 (the breakout pin header) and ensure that 3.3 volts is available on that pin.

## Section 3: Functionality Testing

## Floppy Bus Continuity
NOTE: When reprogramming the iceWerx FPGA, remove it from the control board to prevent any potential damage to the on-board components during the programming process.
1. Program the FPGA device with the code found in pcb_tests/floppy_bus.
2. Replace the FPGA in its socket on the control board.
3. Connect the negative end of an oscilloscope to Pin 1 of J3 (the 34-pin floppy bus).
4. Power on the control board.
5. For each even-numbered pin on J3 (excluding pin 4), connect the positive end of the oscilloscope. Verify that each pin is toggling at a frequency of 1 kHz and only switches between +5V and 0V.

## External Header Continuity
1. Program the FPGA device with the code found in pcb_tests/external_header.
2. Replace the FPGA in its socket on the control board.
3. Connect the negative end of an oscilloscope to Pin 40 of J8 (ground on the breakout pins).
4. Power on the control board.
5. Starting at pin 2 and going up to pin 38, connect the positive end of the oscilloscope to each pin on the header. Verify that each pin is toggling at a frequency of 1 kHz and only switches between +3.3V and 0V.

## Manual Disk Sensor Output
1. Prepare the MF504A drive and a floppy disk.
2. Connect headers J2, J4, and J6 to their respective connectors on the floppy drive.
3. Program the FPGA device with the code found in pcb_tests/sensors and replace it on the control board.
4. Connect the negative end of a multimeter to Pin 40 of J8 (ground on the breakout pins).
5. Power on the control board. 
6. With no disk inserted in the drive, touch the positive end of the multimeter to test points 4-6 by header J4. All three points should currently be at ground.
7. Touch the positive end of the multimeter to test points 8 and 10. All three should be at +3.3V.
8. Touch the positive end of the multimeter to pins 8 (Index) and 28 (Write Protect) on header J3. Both should be at +5V.
9. Insert a floppy disk in the drive just far enough to cover the write-protect sensor on the front-left side of the drive.
10. Repeat steps 7-9. The write protect signal should now be at +3.3V at TP4, and ground on TP10 and pin 28 at header J3.
11. Insert the disk far enough to cover the index sensor at the center of the drive, near the spindle motor.
12. Repeat steps 7-9. The write protect signal and index signal should match that seen in step 11.
13. Insert the disk completely into the drive, triggering the disk latch.
14. Repeat steps 7-9. The index signal should match that seen in step 13 and TP6 should now be at +3.3V. If there is no write-protect notch in the disk, the write-protect signal should match steps 7-9, otherwise it should match steps 11 and 13.

## Manual Track 0 Sensor Output
1. Prepare the MF504A drive and a floppy disk.
2. Connect headers J2, J4, and J6 to their respective connectors on the floppy drive.
3. Program the FPGA device with the code found in pcb_tests/sensors and replace it on the control board.
4. Before powering on the control board, gently push the magnetic heads towards the read end of the drive until it reached the end of the rails.
5. Connect the negative end of a multimeter to Pin 40 of J8 (ground on the breakout pins).
6. Power on the control board. 
7. Touch the positive end of the multimeter to test point ??. The test point should currently be at +3.3V.
8. Touch the positive end of the multimeter to test point ??. The test point should currently be at ground.
9. Touch the positive end of the multimeter to pin ?? on header J3. It shold currently be at ground.
10. Power off the control board and gently push the head towards the front side of the drive until it moves about 1 cm.
11. Repeat steps 6-9. TP?? should be at ground, and TP?? and pin ?? should be at +3.3V and +5V, respectively.

## Manual Spindle Motor Input
1. Program the FPGA device with the code found in pcb_tests/spindle_manual and replace it on the control board.
2. Disconnect the spindle motor header (J2) from the control board.
3. Connect the negative end of the oscilloscope to pin 4 on that header (GND) and the positive end to pin 3 (motor control).
4. Connect a power supply to pin 16 (motor enable) of the input floppy bus (J3) and activate it at a level of +5V.
5. Power on the control board. With the power supply at +5V, the oscilloscope should show the motor control pin at ground.
6. Set the power supply to 0V. The oscilloscope should immediately show the pin at a value of +3.3V.
7. Power off the control board and power supply. Disconnect the oscilloscope and attach the corresponding spindle motor connector.
8. Repeat steps 5-6. When the power supply is at +5V, the spindle motor located in the center of the drive should not be spinning. At 0V, the spindle motor should be spinning.

## Manual Stepper Motor Input
1. Program the FPGA device with the code found in pcb_tests/step_manual and replace it on the control board.
2. Disconnect the stepper motor header from the control board and make sure jumper J1 is in place to activate the step LEDs.
3. Connect a function generator to pin 20 (step) of the input floppy bus (J3). Set it to a square wave with a period of 11 ms and a 91% duty cycle, where the square wave is mostly at +5V and pulses to 0V.
4. Connect a power supply to pin 18 (step direction) of the floppy bus. Set it to +5V.
5. Power on the control board. Only one of the step LEDs should be enabled.
6. Trigger the function generator to send one pulse. The activated LED should shift ?(right/left)?.
7. Set the power supply to 0V and repeat the pulse. The original LED should be activated again.
8. Set the power supply back to +5V and send 5 pulses to the control board. The LEDs should be observed to “step” (?left?) and wrap around the 4 LEDs.
9. Set the power supply to 0V and send 5 pulses again. The same behavior should be observed in the opposite order as in step 8.
10. Set the power supply to +5V and send pulses continuously for 5 seconds. The LEDs should continue to alternate in the usual direction and wrap around without stopping during this period.
11. Repeat step 10 with the power supply at 0V. The same behavior should be seen in the opposite direction.
12. Power off all devices and attach the stepper motor header.
13. Repeat steps 6-9, observing the motion of the drive’s magnetic head. A ??-ward shift in the LEDs should correspond to the drive head moving towards the center of the drive and vice-versa. Do not repeat steps 10-11 as the drive head may step too far in either direction, potentially causing damage to the hardware.

## Controller Connection
1. Program the FPGA drive with the latest code release and replace it on the board.
2. Acquire an Arduino-compatible device and program it with the ArduinoFDC software controller from `https://github.com/dhansel/ArduinoFDC`.
3. Wire the Arduino to the control board, following the pinout provided for that device.
4. Connect all drive sensors and motors to the control board.
5. Power on the drive and the ArduinoFDC.
6. Using a serial monitor connected to the ArduinoFDC, set the drive mode to 5.25 High Density using the command `disktype 2`.
7. Insert a disk into the floppy drive.
8. Use the command `monitor` to enter monitor mode on the ArduinoFDC. The drive’s motor should be enabled immediately after sending this command.
9. Enter the command `m 0` to disable the spindle motor. The drive should react accordingly.
10. Step the drive to track 0 using  the command `r 0, 1`. The magnetic head should return to its home position, farthest away from the center of the drive, and the ArduinoFDC should specifically throw a low-level disk error. This indicates that no data is being read from the drive, which is expected as this functionality is not currently present.
11. Step the drive to an arbitrary track using the command `r [Track #], 1`. The drive should return to track 0 then step outwards to the requested track. The same low-level error should be seen.
12. Repeat step 11 with several different tracks up to the maximum of 79. On each command, the drive should be observed to step inwards, then outwards until it reached the requested track.

## Amplifier Output Testing
1. Program the FPGA device with the latest code release and replace it on the board.
2. Connect an oscilloscope to header J10.
3. Connect all drive sensors and motors to the control board.
4. Prepare a formatted blank high-density floppy disk.
5. Power on the control board.
6. Using the ArduinoFDC in monitor mode, step the drive to track 1, where no data should be present.
7. The oscilloscope should display a roughly sinusoidal signal of a frequency of ~250 kHz and an amplitude of 200 mV. The oscilloscope will likely not display a clean signal due to the nature of the formatting on the disk and the current lack of any filtering hardware.
8. This process also consists of the basic usage of the drive for any further development on the read circuit.

TODO 360/300 rpm. Ground continutity
