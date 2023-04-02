# Project setup
PROJ      = ctrl_board
DEVICE    = 8k

# Files
FILES = pll.v step_driver_deb.v ctrl_circ.v ctrl_test_top.v

.PHONY: ctrl_board clean burn

ctrl_board:
	# synthesize using Yosys
	yosys -p "synth_ice40 -top ctrl_test_top -json $(PROJ).json" $(addprefix rtl/,$(FILES))
	# Place and route using nextpnr
	nextpnr-ice40 -r --hx8k --json $(PROJ).json --package cb132 --asc $(PROJ).asc --opt-timing --pcf iceFUN.pcf

	# Convert to bitstream using IcePack
	icepack $(PROJ).asc $(PROJ).bin

burn:
	iceFUNprog $(PROJ).bin

clean:
	rm *.asc *.bin *.json
