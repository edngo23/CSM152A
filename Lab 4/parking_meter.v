`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:40:58 06/06/2021 
// Design Name: 
// Module Name:    parking_meter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module parking_meter(
    input add1,
    input add2,
    input add3,
    input add4,
    input rst1,
    input rst2,
    input clk,
    input rst,
    
	 output reg [6:0] led_seg,
    output reg a1,
    output reg a2,
    output reg a3,
    output reg a4,
    output [3:0] val1,
    output [3:0] val2,
    output [3:0] val3,
    output [3:0] val4
    );
	
	//state parameters
	parameter ZERO = 4'b0000;
	parameter INITIAL = 4'b0001;
	parameter ADD60 = 4'b0010;
	parameter ADD120 = 4'b0011;
	parameter ADD180 = 4'b0100;
	parameter ADD300 = 4'b0101;
	parameter SLOW_FLASH = 4'b0110;
	parameter RST16 = 4'b0111;
	parameter RST150 = 4'b1000;
	parameter CHECK = 4'b1001;
	
	//keeping track of time and states
	reg [3:0] current_state;
	reg [3:0] next_state;
	reg [13:0] remaining_time;
	
	//varying period counters
	reg [6:0] count_100;
	reg [5:0] count_50;
	reg flash_clk;
	
	//led segment variables
	reg [6:0] led_seg4;
	reg [6:0] led_seg3;
	reg [6:0] led_seg2;
	reg [6:0] led_seg1;
	reg [3:0] led_counter;
	
	//count_100 clk statements
	always @ (posedge clk)
	begin
		if(rst || current_state == RST16 || current_state == RST150)
			count_100 <= 7'b1;
		else if(current_state == INITIAL)
			count_100 <= 7'b0;
		else if(count_100 == 100)
			count_100 <= 7'b1;
		else
			count_100 <= count_100 + 1'b1;	
	end
	
	//count_50 clk statements
	always @ (posedge clk)
	begin
		if(rst || current_state == ZERO)
			count_50 <= 1'b1;
		else if(count_50 == 50)
			count_50 <= 1'b1;
		else
			count_50 <= count_50 + 1'b1;
	end
	
	always @ (posedge clk)
	begin
		if(rst)
			flash_clk <= 1'b1;
		else if(count_50 == 50)
			flash_clk <= ~flash_clk;
		else
			flash_clk <= flash_clk;
	end
	
	//current_state assignment
	always @ (posedge clk)
	begin
		if(rst)
			current_state <= INITIAL;
		else if(rst1)
			current_state <= RST16;
		else if(rst2)
			current_state <= RST150;
		else
			current_state <= next_state;
	end
	
	//next_state assignment
	always @*
	begin
		case(current_state)
			ZERO:
			begin
				if(add1)
					next_state = ADD60;
				else if(add2)
					next_state = ADD120;
				else if(add3)
					next_state = ADD180;
				else if(add4)
					next_state = ADD300;
				else
					next_state = INITIAL;
			end
			INITIAL:
			begin
				if(add1)
					next_state = ADD60;
				else if(add2)
					next_state = ADD120;
				else if(add3)
					next_state = ADD180;
				else if(add4)
					next_state = ADD300;
				else
					next_state = INITIAL;
			end
			ADD60,ADD120,ADD180,ADD300:
			begin
				next_state = CHECK;
			end
			SLOW_FLASH:
			begin
				if(add1)
					next_state = ADD60;
				else if(add2)
					next_state = ADD120;
				else if(add3)
					next_state = ADD180;
				else if(add4)
					next_state = ADD300;
				else if(remaining_time == 0)
					next_state = ZERO;
				else
					next_state = SLOW_FLASH;
			end
			RST16, RST150:
			begin
				if(add1)
					next_state = ADD60;
				else if(add2)
					next_state = ADD120;
				else if(add3)
					next_state = ADD180;
				else if(add4)
					next_state = ADD300;
				else
					next_state = CHECK;
			end
			CHECK:
			begin
				if(add1)
					next_state = ADD60;
				else if(add2)
					next_state = ADD120;
				else if(add3)
					next_state = ADD180;
				else if(add4)
					next_state = ADD300;
				else if(remaining_time < 180)
					next_state = SLOW_FLASH;
				else
					next_state = CHECK;
			end
			default:
				next_state = current_state;
		endcase
	end
	
	//remaining_time updating
	always @ (posedge clk)
	begin
		case(current_state)
			ZERO,INITIAL:
				remaining_time <= 14'b0;
			ADD60:
			begin
				if(count_100 == 100)
					remaining_time <= ((remaining_time + 59) > 9999) ? 9999:(remaining_time + 59);
				else
					remaining_time <= ((remaining_time + 60) > 9999) ? 9999:(remaining_time + 60);
			end
			ADD120:
			begin
				if(count_100 == 100)
					remaining_time <= ((remaining_time + 119) > 9999) ? 9999:(remaining_time + 119);
				else
					remaining_time <= ((remaining_time + 120) > 9999) ? 9999:(remaining_time + 120);
			end
			ADD180:
			begin
				if(count_100 == 100)
					remaining_time <= ((remaining_time + 179) > 9999) ? 9999:(remaining_time + 179);
				else
					remaining_time <= ((remaining_time + 180) > 9999) ? 9999:(remaining_time + 180);
			end
			ADD300:
			begin
				if(count_100 == 100)
					remaining_time <= ((remaining_time + 299) > 9999) ? 9999:(remaining_time + 299);
				else
					remaining_time <= ((remaining_time + 300) > 9999) ? 9999:(remaining_time + 300);
			end
			RST16:
			begin
				if(count_100 == 100)
					remaining_time <= 15;
				else
					remaining_time <= 16;
			end
			RST150:
			begin
				if(count_100 == 100)
					remaining_time <= 149;
				else
					remaining_time <= 150;
			end
			CHECK,SLOW_FLASH:
			begin
				if(count_100 == 100)
					remaining_time <= remaining_time - 1;
				else
					remaining_time <= remaining_time;
			end
		endcase
	end
	
	assign val4 = remaining_time % 10;
	assign val3 = (remaining_time/10) % 10;
	assign val2 = (remaining_time/100) % 10;
	assign val1 = (remaining_time/1000) % 10;
	
	//led segments combination logic
	always @*
	begin
		if(val4 == 0)
			led_seg4 = 7'b0000001;
		else if(val4 == 1)
			led_seg4 = 7'b1001111;
		else if(val4 == 2)
			led_seg4 = 7'b0010010;
		else if(val4 == 3)
			led_seg4 = 7'b0000110;
		else if(val4 == 4)
			led_seg4 = 7'b1001100;
		else if(val4 == 5)
			led_seg4 = 7'b0100100;
		else if(val4 == 6)
			led_seg4 = 7'b0100000;
		else if(val4 == 7)
			led_seg4 = 7'b0001111;
		else if(val4 == 8)
			led_seg4 = 7'b0000000;
		else if(val4 == 9)
			led_seg4 = 7'b0000100;
		else
			led_seg4 = 7'b0000001;
	end
	
	always @*
	begin
		if(val3 == 0)
			led_seg3 = 7'b0000001;
		else if(val3 == 1)
			led_seg3 = 7'b1001111;
		else if(val3 == 2)
			led_seg3 = 7'b0010010;
		else if(val3 == 3)
			led_seg3 = 7'b0000110;
		else if(val3 == 4)
			led_seg3 = 7'b1001100;
		else if(val3 == 5)
			led_seg3 = 7'b0100100;
		else if(val3 == 6)
			led_seg3 = 7'b0100000;
		else if(val3 == 7)
			led_seg3 = 7'b0001111;
		else if(val3 == 8)
			led_seg3 = 7'b0000000;
		else if(val3 == 9)
			led_seg3 = 7'b0000100;
		else
			led_seg3 = 7'b0000001;
	end
	
	always @*
	begin
		if(val2 == 0)
			led_seg2 = 7'b0000001;
		else if(val2 == 1)
			led_seg2 = 7'b1001111;
		else if(val2 == 2)
			led_seg2 = 7'b0010010;
		else if(val2 == 3)
			led_seg2 = 7'b0000110;
		else if(val2 == 4)
			led_seg2 = 7'b1001100;
		else if(val2 == 5)
			led_seg2 = 7'b0100100;
		else if(val2 == 6)
			led_seg2 = 7'b0100000;
		else if(val2 == 7)
			led_seg2 = 7'b0001111;
		else if(val2 == 8)
			led_seg2 = 7'b0000000;
		else if(val2 == 9)
			led_seg2 = 7'b0000100;
		else
			led_seg2 = 7'b0000001;
	end
	
	always @*
	begin
		if(val1 == 0)
			led_seg1 = 7'b0000001;
		else if(val1 == 1)
			led_seg1 = 7'b1001111;
		else if(val1 == 2)
			led_seg1 = 7'b0010010;
		else if(val1 == 3)
			led_seg1 = 7'b0000110;
		else if(val1 == 4)
			led_seg1 = 7'b1001100;
		else if(val1 == 5)
			led_seg1 = 7'b0100100;
		else if(val1 == 6)
			led_seg1 = 7'b0100000;
		else if(val1 == 7)
			led_seg1 = 7'b0001111;
		else if(val1 == 8)
			led_seg1 = 7'b0000000;
		else if(val1 == 9)
			led_seg1 = 7'b0000100;
		else
			led_seg1 = 7'b0000001;
	end
	
	always @ (posedge clk)
	begin
		if(rst)
			led_counter <= 4'b0001;
		else
			led_counter <= {led_counter[2:0], led_counter[3]};
	end
	
	always @ (posedge clk)
	begin
		if(remaining_time == 0)
		begin
			if(flash_clk == 1)
			begin
				if(led_counter[3])
				begin
					a1 <= 1;
					a2 <= 1;
					a3 <= 1;
					a4 <= 0;
					led_seg <= led_seg4;
				end
				else if(led_counter[2])
				begin
					a1 <= 1;
					a2 <= 1;
					a3 <= 0;
					a4 <= 1;
					led_seg <= led_seg3;
				end
				else if(led_counter[1])
				begin
					a1 <= 1;
					a2 <= 0;
					a3 <= 1;
					a4 <= 1;
					led_seg <= led_seg2;
				end
				else if(led_counter[0])
				begin
					a1 <= 0;
					a2 <= 1;
					a3 <= 1;
					a4 <= 1;
					led_seg <= led_seg1;
				end
			end
			else
			begin
				a1 <= 1;
				a2 <= 1;
				a3 <= 1;
				a4 <= 1;
			end
		end
		
		else if(remaining_time >= 180)
		begin
			if(led_counter[3])
			begin
				a1 <= 1;
				a2 <= 1;
				a3 <= 1;
				a4 <= 0;
				led_seg <= led_seg4;
			end
			else if(led_counter[2])
			begin
				a1 <= 1;
				a2 <= 1;
				a3 <= 0;
				a4 <= 1;
				led_seg <= led_seg3;
			end
			else if(led_counter[1])
			begin
				a1 <= 1;
				a2 <= 0;
				a3 <= 1;
				a4 <= 1;
				led_seg <= led_seg2;
			end
			else if(led_counter[0])
			begin
				a1 <= 0;
				a2 <= 1;
				a3 <= 1;
				a4 <= 1;
				led_seg <= led_seg1;
			end
		end
		
		else
		begin
			if((remaining_time % 2) == 0)
			begin
				if(led_counter[3])
				begin
					a1 <= 1;
					a2 <= 1;
					a3 <= 1;
					a4 <= 0;
					led_seg <= led_seg4;
				end
				else if(led_counter[2])
				begin
					a1 <= 1;
					a2 <= 1;
					a3 <= 0;
					a4 <= 1;
					led_seg <= led_seg3;
				end
				else if(led_counter[1])
				begin
					a1 <= 1;
					a2 <= 0;
					a3 <= 1;
					a4 <= 1;
					led_seg <= led_seg2;
				end
				else if(led_counter[0])
				begin
					a1 <= 0;
					a2 <= 1;
					a3 <= 1;
					a4 <= 1;
					led_seg <= led_seg1;
				end
			end
			else
			begin
				a1 <= 1;
				a2 <= 1;
				a3 <= 1;
				a4 <= 1;
			end
		end
	end

endmodule
