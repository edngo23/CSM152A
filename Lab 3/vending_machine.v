`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:57:07 05/23/2021 
// Design Name: 
// Module Name:    vending_machine 
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
module vending_machine(
    input CARD_IN,
    input VALID_TRAN,
    input [2:0] ITEM_CODE,
    input KEY_PRESS,
    input RELOAD,
    input CLK,
    input RESET,
    output reg VEND,
    output reg INVALID_SEL,
    output reg FAILED_TRAN,
    output reg [2:0] COST
    );

	parameter stRst = 4'b0000; //1
	parameter stIdle = 4'b0001; //2
	parameter stReload = 4'b0010; //3
	parameter stCardInsertWait = 4'b0100; //4
	parameter stWait = 4'b0101; //5
	parameter stValidCheck = 4'b0110; //6
	parameter stInvalidIn = 4'b0111; //7
	parameter stValidIn = 4'b1000; //8
	parameter stTranWait = 4'b1001; //9
	parameter stFailedTran = 4'b1010; //10
	parameter stVend = 4'b1011; //11
	
	reg [3:0] current_state;
	reg [3:0] next_state;
	
	reg [3:0] snack10_count;
	reg [3:0] snack11_count;
	reg [3:0] snack12_count;
	reg [3:0] snack13_count;
	reg [3:0] snack14_count;
	reg [3:0] snack20_count;
	reg [3:0] snack21_count;
	reg [3:0] snack22_count;
	reg [3:0] snack23_count;
	reg [3:0] snack24_count;
	
	reg [2:0] timer_count;
	reg clk_on;
	reg timeIncrement;
	
	reg [2:0] first_code;
	reg [2:0] second_code;
	reg code1_inputted;
	
	//current state assignment
	always @ (posedge CLK)
	begin
		if(RESET)
			current_state <= stRst;
		else
			current_state <= next_state;
	end
	
	//clock counter enable for proper input
	always @ (posedge CLK)
	begin
		if((current_state == stValidIn || 
		   current_state == stCardInsertWait || 
			current_state == stVend) && clk_on == 0)
			clk_on <= 1;
		else
			clk_on <= 0;
	end
	
	//5 clock cycle clock
	always @ (posedge CLK)
	begin
		if(clk_on)
			timer_count <= 3'b000;
		else if(timeIncrement)
			timer_count <= timer_count + 3'b1;
	end
	
	//snack counter status
	always @ (posedge CLK)
	begin
		if(current_state == stRst)
		begin
			snack10_count <= 0;
			snack11_count <= 0;
			snack12_count <= 0;
			snack13_count <= 0;
			snack14_count <= 0;
			snack20_count <= 0;
			snack21_count <= 0;
			snack22_count <= 0;
			snack23_count <= 0;
			snack24_count <= 0;
		end
		else if(current_state == stReload)
		begin
			snack10_count <= 10;
			snack11_count <= 10;
			snack12_count <= 10;
			snack13_count <= 10;
			snack14_count <= 10;
			snack20_count <= 10;
			snack21_count <= 10;
			snack22_count <= 10;
			snack23_count <= 10;
			snack24_count <= 10;
		end
		else if(current_state == stVend)
		begin
			if(first_code == 1 && second_code == 0)
				snack10_count <= snack10_count - 1;
			else if(first_code == 1 && second_code == 1)
				snack11_count <= snack11_count - 1;
			else if(first_code == 1 && second_code == 2)
				snack12_count <= snack12_count - 1;
			else if(first_code == 1 && second_code == 3)
				snack13_count <= snack13_count - 1;
			else if(first_code == 1 && second_code == 4)
				snack14_count <= snack14_count - 1;
			else if(first_code == 2 && second_code == 0)
				snack20_count <= snack20_count - 1;
			else if(first_code == 2 && second_code == 1)
				snack21_count <= snack21_count - 1;
			else if(first_code == 2 && second_code == 2)
				snack22_count <= snack22_count - 1;
			else if(first_code == 2 && second_code == 3)
				snack23_count <= snack23_count - 1;
			else if(first_code == 2 && second_code == 4)
				snack24_count <= snack24_count - 1;
		end
	end
	
	//state validation and assignment
	always @*
	begin
		case(current_state)
			stRst:
			begin
				next_state = stIdle;
				timeIncrement = 0;
			end
			
			stIdle:
			begin
				code1_inputted = 0;
				timeIncrement = 0;
				if(RELOAD)
					next_state = stReload;
				else if(CARD_IN)
					next_state = stCardInsertWait;
				else
					next_state = stIdle;
			end
			
			stReload:
			begin
				next_state = stIdle;
				timeIncrement = 0;
			end
			
			stCardInsertWait:
			begin
				if(KEY_PRESS && !code1_inputted)
				begin
					first_code = ITEM_CODE;
					code1_inputted = 1;
					timeIncrement = 1;
					next_state = stCardInsertWait;
				end
				else if(KEY_PRESS && code1_inputted)
				begin
					second_code = ITEM_CODE;
					next_state = stValidCheck;
					timeIncrement = 0;
				end
				else
				begin
					next_state = stWait;
					timeIncrement = 1;
				end
			end
			
			stWait:
			begin
				if(timer_count == 3) //3
				begin
					next_state = stInvalidIn;
					timeIncrement = 0;
				end
				else if(KEY_PRESS && !code1_inputted)
				begin
					first_code = ITEM_CODE;
					code1_inputted = 1;
					timeIncrement = 1;
					next_state = stCardInsertWait;
				end
				else if(KEY_PRESS && code1_inputted)
				begin
					second_code = ITEM_CODE;
					next_state = stValidCheck;
					timeIncrement = 0;
				end
				else
				begin
					next_state = stWait;
					timeIncrement = 1;
				end
			end
			
			stValidCheck:
			begin
				timeIncrement = 0;
				if((first_code == 1 && second_code == 0 && snack10_count > 0) || 
					(first_code == 1 && second_code == 1 && snack11_count > 0) ||
					(first_code == 1 && second_code == 2 && snack12_count > 0) ||
					(first_code == 1 && second_code == 3 && snack13_count > 0) ||
					(first_code == 1 && second_code == 4 && snack14_count > 0) ||
					(first_code == 2 && second_code == 0 && snack20_count > 0) ||
					(first_code == 2 && second_code == 1 && snack21_count > 0) ||
					(first_code == 2 && second_code == 2 && snack22_count > 0) ||
					(first_code == 2 && second_code == 3 && snack23_count > 0) ||
					(first_code == 2 && second_code == 4 && snack24_count > 0))
					next_state = stValidIn;
				else
					next_state = stInvalidIn;
			end
			
			stInvalidIn:
			begin
				next_state = stIdle;
				timeIncrement = 0;
			end
			
			stValidIn:
			begin
				if(VALID_TRAN)
				begin
					next_state = stVend;
					timeIncrement = 0;
				end
				else
				begin
					next_state = stTranWait;
					timeIncrement = 1;
				end
			end
			
			stTranWait:
			begin
				if(timer_count == 2) //2
				begin
					next_state = stFailedTran;
					timeIncrement = 0;
				end
				else if(VALID_TRAN)
				begin
					next_state = stVend;
					timeIncrement = 0;
				end
				else
				begin
					next_state = stTranWait;
					timeIncrement = 1;
				end
			end
			
			stFailedTran:
			begin
				next_state = stIdle;
				timeIncrement = 0;
			end
			
			stVend:
			begin
				next_state = stIdle;
				timeIncrement = 0;
			end
			
			default: //idle is default state
			begin
				next_state = stIdle;
				timeIncrement = 0;
			end
		endcase
	end
	
	always @*
	begin
		case(current_state)
			stIdle,
			stCardInsertWait,
			stWait,
			stValidCheck,
			stRst,
			stReload:
			begin
				VEND = 0;
				INVALID_SEL = 0;
				FAILED_TRAN = 0;
				COST = 3'b000;
			end
			
			stInvalidIn:
			begin
				VEND = 0;
				INVALID_SEL = 1;
				FAILED_TRAN = 0;
				COST = 3'b000;
			end
			
			stValidIn:
			begin
				if(first_code == 1)
					COST = 2;
				else if(first_code == 2)
					COST = 5;
			end
			
			stFailedTran:
				FAILED_TRAN = 1;
				
			stVend:
				VEND = 1;
		endcase
	end

endmodule
