`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:27:43 05/23/2021
// Design Name:   vending_machine
// Module Name:   /home/ise/Xillinx_host/Lab3/testbench_205416130.v
// Project Name:  Lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vending_machine
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
	reg CARD_IN;
	reg VALID_TRAN;
	reg [2:0] ITEM_CODE;
	reg KEY_PRESS;
	reg RELOAD;
	reg CLK;
	reg RESET;

	// Outputs
	wire VEND;
	wire INVALID_SEL;
	wire FAILED_TRAN;
	wire [2:0] COST;

	// Instantiate the Unit Under Test (UUT)
	vending_machine uut (
		.CARD_IN(CARD_IN), 
		.VALID_TRAN(VALID_TRAN), 
		.ITEM_CODE(ITEM_CODE), 
		.KEY_PRESS(KEY_PRESS), 
		.RELOAD(RELOAD), 
		.CLK(CLK), 
		.RESET(RESET), 
		.VEND(VEND), 
		.INVALID_SEL(INVALID_SEL), 
		.FAILED_TRAN(FAILED_TRAN), 
		.COST(COST)
	);

	initial begin
		// Initialize Inputs
		CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		RELOAD = 0;
		CLK = 0;
		RESET = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		CLK = 1;
		#10
		//RESET test
		RESET = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		RESET = 0;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		//RELOAD test
		RELOAD = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		RELOAD = 0;
		//NORMAL TEST 1 (COST = 2)
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		VALID_TRAN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		VALID_TRAN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		//NORMAL TEST 2 (COST = 5)
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 2;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 3;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		VALID_TRAN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		VALID_TRAN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		//CARD_IN test where never set to 0 means a new transaction
		//TRANSACTION 1
		#10
		CLK = 0;
		CARD_IN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 4;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		VALID_TRAN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		VALID_TRAN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		//TRANSACTION 2
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 2;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		VALID_TRAN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		VALID_TRAN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		//FAILED input, no key input after putting in card for 5 cycles
		#10
		CLK = 0;
		CARD_IN = 1;
		#10
		CLK = 1; // 1 cycle
		#10
		CLK = 0;
		#10
		CLK = 1; // 2 cycle
		#10
		CLK = 0;
		#10
		CLK = 1; // 3 cycle
		#10
		CLK = 0;
		#10
		CLK = 1; // 4 cycle
		#10
		CLK = 0;
		#10
		CLK = 1; // 5 cycle
		#10
		CLK = 0;
		#10
		CLK = 1; // 6 cycle
		#10
		CLK = 0;
		CARD_IN = 0;
		#10
		CLK = 1; // 7 cycle
		#10
		CLK = 0;
		#10
		CLK = 1; // 8 cycle
		#10
		CLK = 0;
		#10
		CLK = 1; // 9 cycle
		#10
		CLK = 0;
		#10
		CLK = 1; // 10 cycle
		//FAILED input, only 1 key pressed
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1; //1 cycle
		#10
		CLK = 0;
		#10
		CLK = 1; //2 cycle
		#10
		CLK = 0;
		#10
		CLK = 1; //3 cycle
		#10
		CLK = 0;
		#10
		CLK = 1; //4 cycle
		#10
		CLK = 0;
		#10
		CLK = 1; //5 cycle
		#10
		CLK = 0;
		#10
		CLK = 1; //6 cycle
		#10
		CLK = 0;
		CARD_IN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		//FAILED input, invalid item code
		#10
		CLK = 0;
		CARD_IN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 5;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		//FAILED transaction
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		CARD_IN = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		//Empty machine attempt to vend
		RESET = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		RESET = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		CARD_IN = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 1;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		CARD_IN = 0;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 1;
		ITEM_CODE = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		KEY_PRESS = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		#10
		CLK = 0;
		#10
		CLK = 1;
		$finish;
		
	end
      
endmodule

