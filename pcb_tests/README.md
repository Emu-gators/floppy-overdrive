# PCB Test Procedures and Code

## Test Procedures

A series of test procedures for the PCB are currently provided in the test_proc folder.
It is recommended that these procedures are followed once the PCB is assembed to ensure that the board is working correctly before it is used.
Some of these tests require loading test programs onto the FPGA device. These are provided in the additional folders here and can be programmed to the iceWerx FPGA.

## Code Build Instructions

To build the pcb test projects, the icestorm toolchain from http://www.clifford.at/icestorm/
and the iceFUN programmer from https://github.com/devantech/iceFUNprog are required.
These tools are currently only supported on Linux.

With a terminal open in the test's respective folder, enter the following commands:\
`make [TEST NAME]`\
`make burn`


