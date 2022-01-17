set XILINX $env(XILINX)
vlib work

vlog -sv -dpiheader dpiheader.h test.sv
gcc -c -fpic -I C:/modeltech64_10.6d/include test.c -o test.obj
gcc -shared -Bsymbolic -o test.dll test.obj -L C:/modeltech64_10.6d/win64
vsim -novopt -quiet -t 1ns -sv_lib test -lib work work.test