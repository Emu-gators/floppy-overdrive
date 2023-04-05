# Some notes on the current state of the PCB

During testing, it was found that some aspects of the board do not function exactly as expected and will require later revisions to the design:

- The +/- 2.5V voltage generator (IC3, R20-21, C8-9) does not function and will not provide the correct voltages. When assembling the board, these components should be left unsoldered. The preamplifier circuit, however (IC1-2), does work as intended with the correct voltages, and can be powered directly from TP16-17 using an external power supply.

- When connecting the board to an ArduinoFDC, some pins will require extra pull-up resistors to +5V to prevent floating. This was noted in the motor enable signal, which would not return to +5V when the motor was disabled manually without this extra resistor. In testing, having all control lines appeared to provide good results, except for the Index signal, which would not provide a consistent waveform with this extra resistor. Futher research into the traditional signal termination methods should be researched to resolve this issue.

- The new board will not lie flat in the drive without drilling an extra hole to fit the key pin at the read end of the drive. This has been corrected in the current KiCad project files, but should be noted when using the old revision of the board.

- Pin 39 on the breakout header is meant to be connected to +3.3V, but is not connected to any net. If desired, this can be solved by scratching off the silkscreen on the bottom layer to expose the +3.3V plane and soldering the pin directly. THis is also fixed in the current KiCad project files.