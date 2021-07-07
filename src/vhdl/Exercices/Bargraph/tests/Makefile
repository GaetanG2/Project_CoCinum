SRCDIR = $(PWD)/..
VHDL_SOURCES = $(SRCDIR)/Bargraph.vhd
TOPLEVEL = bargraph
MODULE = run
SIM = ghdl
SIM_ARGS = --wave=Bargraph.ghw
export COCOTB_REDUCED_LOG_FMT = 1

include $(shell cocotb-config --makefiles)/Makefile.inc
include $(shell cocotb-config --makefiles)/Makefile.sim
