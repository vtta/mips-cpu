#------------------------------------------------------------------------------
# Simple makefile to simulate Verilog HDL designs under OSX.
# Modify the variables below to suit your own files.
#------------------------------------------------------------------------------
TESTBENCH = MIPS_R2000_tb
# SRCS      := $(shell find ./ -type f -name \*.v )
SRCS     = MIPS_R2000.v instruction_def.v ALU.v Control.v Extender.v
SRCS    += GPR.v DataMemory.v InstructionMemory.v PCU.v
SRCS    += signal_def.v
SRCS    += clk_div.v seg7x16.v # ctrl_encode_def.v
SRCS    += IFIDReg.v IDEXReg.v EXMEMReg.v MEMWBReg.v
SRCS    += ForwardingUnit.v HazardUnit.v ConditionCheck.v
#------------------------------------------------------------------------------
all: simulate

lint:
	verilator -g 2012 -Wall --lint-only $(SRCS) $(TESTBENCH).v

simulate:
	iverilog -g 2012 -Wall -o $(TESTBENCH).vvp $(SRCS) $(TESTBENCH).v
	vvp $(TESTBENCH).vvp | tee $(TESTBENCH)_log.txt | less

gtkwave: simulate
	gtkwave $(TESTBENCH).vcd

scansion: simulate
	open /Applications/Scansion.app $(TESTBENCH).vcd

clean:
	rm -rf $(TESTBENCH).vvp $(TESTBENCH).vcd $(TESTBENCH)_log.txt

