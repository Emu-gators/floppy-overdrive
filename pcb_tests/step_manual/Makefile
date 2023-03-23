# Project setup
PROJ      = step_manual
DEVICE    = 8k

# Files
FILES = step_driver_deb.v step_manual.v

.PHONY: step_manual clean burn

step_manual:
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
