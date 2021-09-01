`timescale 1ms / 1us

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:45:43 06/06/2021
// Design Name:   parking_meter
// Module Name:   /home/ise/Xillinx_host/Lab4/testbench_205416130.v
// Project Name:  Lab4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: parking_meter
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
	reg add1;
	reg add2;
	reg add3;
	reg add4;
	reg rst1;
	reg rst2;
	reg clk;
	reg rst;

	// Outputs
	wire [6:0] led_seg;
	wire a1;
	wire a2;
	wire a3;
	wire a4;
	wire [3:0] val1;
	wire [3:0] val2;
	wire [3:0] val3;
	wire [3:0] val4;
	
	integer i;

	// Instantiate the Unit Under Test (UUT)
	parking_meter uut (
		.add1(add1), 
		.add2(add2), 
		.add3(add3), 
		.add4(add4), 
		.rst1(rst1), 
		.rst2(rst2), 
		.clk(clk), 
		.rst(rst), 
		.led_seg(led_seg), 
		.a1(a1), 
		.a2(a2), 
		.a3(a3), 
		.a4(a4), 
		.val1(val1), 
		.val2(val2), 
		.val3(val3), 
		.val4(val4)
	);

	initial begin
		// Initialize Inputs
		add1 = 0;
		add2 = 0;
		add3 = 0;
		add4 = 0;
		rst1 = 0;
		rst2 = 0;
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		//RST test
		#5; //clk posedge
		rst = 1;
		#5;
		rst = 0;
		#20;
		
		//ADD60 test and 0.5 Hz test
		#5; //clk posedge
		add1 = 1;
		#10;
		add1 = 0;
		#2020;
		rst = 1;
		#5;
		rst = 0;
		
		//ADD120 test
		#5; //clk posedge
		add2 = 1;
		#10;
		add2 = 0;
		#10;
		rst = 1;
		#5;
		rst = 0;
		
		//ADD180 test
		#5; //clk posedge
		add3 = 1;
		#10;
		add3 = 0;
		#10;
		rst = 1;
		#5;
		rst = 0;
		
		//ADD300 test and 1 Hz test and display test
		#5; //clk posedge
		add4 = 1;
		#10;
		add4 = 0;
		#2020;
		rst = 1;
		#5;
		rst = 0;
		
		//9999 seconds maximum test
		#5; //clk posedge
		for(i = 0; i < 34; i = i + 1)
		begin
			add4 = 1;
			#10;
			add4 = 0;
			#10;
		end
		#5;
		
		//rst2 test
		#5; //clk posedge
		rst2 = 1;
		#10;
		rst2 = 0;
		#2015;
		
		//rst1 test
		#5; //clk posedge
		rst1 = 1;
		#10;
		rst1 = 0;
		#1015;
		
		//adding time during odd decrement (<180 seconds)
		#5; //clk posedge
		add1 = 1;
		#10;
		add1 = 0;
		#1015;
		
		//0000 timer test
		#5; //clk posedge
		rst = 1;
		#10;
		rst = 0;
		#1015;
		
		$finish;

	end
	
	always begin
		#5;
		clk = ~clk;
	end
      
endmodule

