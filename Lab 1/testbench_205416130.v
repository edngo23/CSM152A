`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:53:29 04/18/2021
// Design Name:   FPCVT
// Module Name:   /home/ise/Xillinx_host/Lab1/testbench_205416130.v
// Project Name:  Lab1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPCVT
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_205416130;

	// Inputs
	reg [12:0] D;

	// Outputs
	wire S;
	wire [2:0] E;
	wire [4:0] F;

	// Instantiate the Unit Under Test (UUT)
	FPCVT uut (
		.D(D), 
		.S(S), 
		.E(E), 
		.F(F)
	);

	initial begin
		// Initialize Inputs
		D = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		D = 13'b1111111111111; //all 1s
		#10;
		D = 13'b0111111111111; //biggest positive
		#10;
		D = 13'b1000000000000; //biggest negative (overflow)
		#10;
		D = 13'b0000111101011; //significand round up
		#10;
		D = 13'b0000111100011; //normal positive
		#10;
		D = 13'b1000111101011; //negative significand round up
		#10;
		D = 13'b1000111100011; //normal negative
		#10;
		D = 13'b0000111111011; //significand overflow to exp
		#10;
		D = 13'b1001011100011; //normal negative
		#10;
		D = 13'b0000000001011; //small positive
		#10;
		$finish;
	end
      
endmodule

