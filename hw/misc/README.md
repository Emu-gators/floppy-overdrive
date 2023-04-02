# Miscellaneous Files

This folder contains any leftover Verilog files that were created at the start of development, but have not yet been implemented into the project as a whole.

rw_circ.v contains the skeleton code for the read/write circuit, similar to ctrl_circ.v for the control circuit.\
overdrive_top.v contains the skeleton code for the top-level entity of the entire Floppy Overdrive, and is meant to instantiate both the control and read/write circuits and connect them to the necesarry sensors and buses.