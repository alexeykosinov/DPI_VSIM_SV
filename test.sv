`timescale 1ns/100ps

package math_pkg;
	import "DPI-C" dpi_sin = function real sin(real val);
endpackage

module test;

	import math_pkg::*;

	typedef logic [15:0] int16_t;

	logic [15:0] test_value;

	real sine_out;

	parameter sampling_time = 10; 
	const real pi = 3.1416; 
	real time_us; 
	bit clk; 
	real freq = 1; 
	real offset = 2.5; 
	real ampl = 2.5; 
	
	always clk = #(sampling_time) ~clk; 
	always @(clk) begin 
		time_us = $time; 
	end 
	
	assign sine_out = offset + (ampl * sin(2*pi*freq*time_us));

	assign test_value = int16_t'(sine_out);

endmodule
