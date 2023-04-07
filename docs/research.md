# Research

## Overview

Various links to websites for learning about everything floppy: disks, drives, controllers, etc.

## Links

[1] https://extrapages.de/archives/20190102-Floppy-notes.html
- Overview of how data is encoded on floppy disks (FM, MFM).

[2] https://www.eit.lth.se/fileadmin/eit/courses/eitn50/Literature/fat12_description.pdf
- Information about the FAT12 filesystem used on some PC floppies.

[3] https://www.mouser.com/datasheet/2/268/37c78-468028.pdf
- Datasheet for a floppy disk controller.

[4] https://www.reddit.com/r/FPGA/comments/r9srq7/floppy_disk_controller_on_fpga/
- Reddit discussion about implementing an FDC on an FPGA.

[5] https://github.com/steve-chamberlin/fpga-disk-controller
- Apple II floppy implementation in Verilog and PCB files.

[6] https://www.hermannseib.com/documents/floppy.pdf
- 'The floppy user guide' - contains useful information about the types, layout, and formatting of disks.

[7] https://github.com/dhansel/ArduinoFDC
- Library for using an Arduino as a floppy disk controller.

[8] https://www.5volts.ch/posts/mfmreader/
- Overview of floppy disk data encoding and format.

[9] https://retrocmp.de/fdd/general/floppy-bus.htm
- Information about the 34-pin bus and the variations for each signal.

[10] https://archive.org/details/Teac_FD-55_Drive_Maintenance_Manual_1983_Teac_Corporation_of_America
- Service manual for the Teac FD-55 drive, a standard 5.25 inch drive.

[11] https://archive.org/details/bitsavers_shugartSA8oryofOperationsApr76_1380425
- Floppy drive theory of operation manual written by Shugart Associates, creators of the 5.25 inch drive.

[12] https://archive.org/details/bitsavers_mitsubishiMF504A347UAStandardSpecifications_1938078, https://archive.org/details/bitsavers_mitsubishiMF504A3TechnicalManual_883627, 
https://archive.org/details/bitsavers_mitsubishiMF504A347UASchematics_382555
- Specifications, service manuals, and schematics for the Mitsubishi MF504 used in this project. **Very useful** in identifying components and understanding the intended behavior of the drive.

[13] http://info-coach.fr/atari/hardware/_fd-hard/AN-917.pdf
- Application note AN917 on reading and writing data for a floppy disk. Essential document for understanding the theory of how data is recorded and read off of a disk.

[14] https://link.springer.com/content/pdf/10.1007/978-0-387-84927-0_3.pdf
- Publication on recovering data off of failing disks which also goes into some detail about the theory behind disk reading and writing.

[15] https://github.com/dhansel/ArduinoFDC
- A software FDC developed for Arduino-compatible boards. Currently the best method available for using the control board, due to its ability to manually control the spindle motor and step the head to an aribtrary track using the disk monitor feature.

[16] https://www.angelfire.com/journal2/paofiles/robotics/paoStepperMotors.htm
- Tutorial on testing and identifying the type of stepper motor used in a floppy drive.

[17] https://www.robot-electronics.co.uk/products/icewerx.html
- Product page for the Devantech iceWerx FPGA the PCB is designed around. Includes a pinout for the two headers.

[18] https://github.com/devantech/iceFUN
- Example projects for the iceWerx, which were adapted for the control circuit and pcb tests. Includes links to installing the icestorm toolchain and iceFun programmer.

[19] https://www.analog.com/media/en/technical-documentation/data-sheets/1420fa.pdf
- Datasheet for the LTC1420, the ADC that was tested for potential use in the read circuit.

[20] http://www.b-kainka.de/Daten/Analog/ne592.pdf
- Application note for the NE592, a much older amplifier, with an example circuit for a disk decoder circuit similar to those implemented on the original drives.

[21] http://brutmanlabs.org/Diskettes/Diskette_handling.html
- Another introduction to the basics and different types of floppy disks. Discusses DD vs HD disks and when to use one type in a certain drive.
