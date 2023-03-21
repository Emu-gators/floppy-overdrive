# Project setup
PROJ      = floppy_bus
DEVICE    = 8k

# Files
FILES = pll.v floppy_bus.v

.PHONY: floppy_bus clean burn

floppy_bus:
	# synthesize using Yosys
	yosys -p "synth_ice40 -top top -json $(PROJ).json" $(FILES)
	# Place and route using nextpnr
	nextpnr-ice40 -r --hx8k --json $(PROJ).json --package cb132 --asc $(PROJ).asc --opt-timing --pcf iceFUN.pcf

	# Convert to bitstream using IcePack
	icepack $(PROJ).asc $(PROJ).bin

burn:
	iceFUNprog $(PROJ).bin

clean:
	rm *.asc *.bin *blif *.json
