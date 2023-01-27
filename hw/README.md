# Hardware

## Overview

This folder contains the files relevant to the hardware-based aspects of the Floppy Overdrive project, including HDL code and design schematics.

## FPGA Build Instructions

For testing purposes, the control circuit is currently wrapped within the top-level file circ_test_top.v. This file instantiates an instance of the control circuit module of the project, and connects its inputs and outputs directly to the I/O pins of the FPGA being used. To implement this test circuit on real hardware, the FPGA must be wired according to the schematic in TestControlCirc.png. 

The code so far was been written, compiled, and tested in Quartus on a MAX10 FPGA, but it is written mostly independent of any hardware, so it should be able to be built in any toolchain for any sufficiently large FPGA device as long as all the Verilog files are included.

## Schematics

TestControlCirc.png contains the schamtic used for testing just the control circuit of the project.

The read circuit is currently being implemented and tested in individual stages. The current schematic for the preamplifier circuit can be seen in PreampTest.drawio.png, and currently has been tested to provide 100x gain on a 250kHz input signal.