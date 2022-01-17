###########################################################################
# Author		: Kosinov Alexey (https://github.com/alexeykosinov)
# Description	:
#				: Use cases: hdl simulation with calling C/C++ functions
#				: using Direct Programming Interface (DPI) 
#				: Tool verison	: ModelSim SE-64 10.6d
#				: OS			: Windows 7 64x
#				: MINGW64		: 10.2.0 (GCC)
#				:
###########################################################################

PRJ_NAME 		= test

HDL_SRC 		= test.sv
C_SRC 			= test.c

XILINX_HOME 	= D:/_files/Xilinx/14.7/ISE_DS/ISE
USE_XIL			= 1
MODELSIM_HOME 	= C:/modeltech64_10.6d
VLIB 			= vlib
VLOG 			= vlog
VSIM 			= vsim

CC 				= gcc
OBJ 			= $(C_SRC:%.c=%.obj)

run: vlib vlog vsim

vlib:
	$(VLIB) work

vlog:
	$(VLOG) -sv -dpiheader dpiheader.h $(HDL_SRC)
	$(VLOG) $(XILINX_HOME)/verilog/src/glbl.v

ifeq ($(USE_XIL), 1)
vsim: $(PRJ_NAME).dll
	$(VSIM) -voptargs="+acc" -quiet -t 1ns -sv_lib $(PRJ_NAME) -do $(PRJ_NAME).do \
	-L xilinxcorelib_ver \
	-L unisims_ver \
	-L unimacro_ver \
	-L secureip \
	-lib work work.$(PRJ_NAME)
else
vsim: $(PRJ_NAME).dll
	$(VSIM) -voptargs="+acc" -quiet -t 1ns -sv_lib $(PRJ_NAME) -do $(PRJ_NAME).do -lib work work.$(PRJ_NAME)
endif

%.obj: %.c
	$(CC) -c -fPIC -I $(MODELSIM_HOME)/include $< -o $@

$(PRJ_NAME).dll: $(OBJ)
	$(CC) -shared -Bsymbolic $(OBJ) -o $(PRJ_NAME).dll -L $(MODELSIM_HOME)/win64

clean:
	rm -rf work
	rm -f *.dll
	rm -f *.obj
	rm -f *.wlf
	rm transcript
	rm dpiheader.h



	