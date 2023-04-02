# Control Circuit

This folder contains the files needed for the control circuit portion of the Floppy Overdrive. This includes the Verilog code used to implement the control circuit (/rtl), a testbench used to verify this circuit (/tb), and the Make files needed to build the circuit for the control board PCB. 


## Build Instructions

To build the circuit for the PCB, the icestorm toolchain from http://www.clifford.at/icestorm/ and the iceFUN programmer from https://github.com/devantech/iceFUNprog are required.
These tools are currently only supported on Linux.

With a terminal open in this folder, enter the following commands to build the circuit and program it to the iceWerx FPGA:\
`make ctrl_board`\
`make burn`