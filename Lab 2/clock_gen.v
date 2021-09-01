`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:32:52 05/05/2021 
// Design Name: 
// Module Name:    clock_gen 
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
// task 1
module clock_div_two(clk_in, rst, clk_div_2, clk_div_4,
clk_div_8, clk_div_16);
input clk_in, rst;
output clk_div_2, clk_div_4, clk_div_8, clk_div_16;

reg [3:0] Q;
always @ (posedge clk_in)
begin
	if(rst)
		Q <= 4'b0000;
	else
		Q <= Q + 1'b1;
end

assign clk_div_2 = Q[0];
assign clk_div_4 = Q[1];
assign clk_div_8 = Q[2];
assign clk_div_16 = Q[3];

endmodule

// task 2
module clock_div_thirty_two(clk_in, rst, clk_div_32);
input clk_in, rst;
output reg clk_div_32;

reg [3:0] Q;
always @ (posedge clk_in)
begin
	if(rst)
	begin
		Q <= 4'b0000;
		clk_div_32 <= 0;
	end
	else if(Q == 4'b1111)
	begin
		clk_div_32 <= ~clk_div_32;
		Q <= Q + 1'b1;
	end
	else
		Q <= Q + 1'b1;
end

endmodule

// task 3
module clock_div_twenty_six(clk_in, rst, clk_div_26);
input clk_in, rst;
output reg clk_div_26;

reg [3:0] Q;
always @ (posedge clk_in)
begin
	if(rst)
	begin
		Q <= 4'b0000;
		clk_div_26 <= 0;
	end
	else if(Q == 4'b1100)
	begin
		clk_div_26 <= ~clk_div_26;
		Q <= Q + 1'b1;
	end
	else
		Q <= Q + 1'b1;
end

endmodule

// task 4, 5, 6
module clock_div_three(clk_in, rst, clk_div_3, clk_pos,
clk_neg);
input clk_in, rst;
output clk_div_3;
output reg clk_pos, clk_neg;

reg [1:0] count_pos;
always @ (posedge clk_in)
begin
	if(rst)
		count_pos <= 2'b00;
	else
		count_pos <= count_pos + 1'b1;
end

always @ (posedge clk_in)
begin
	if(count_pos == 0)
		clk_pos <= 1;
	else
		clk_pos <= 0;
end

reg [1:0] count_neg;
always @ (negedge clk_in)
begin
	if(rst)
		count_neg <= 2'b00;
	else
		count_neg <= count_neg + 1'b1;
end

always @ (negedge clk_in)
begin
	if(count_neg == 0)
		clk_neg <= 1;
	else
		clk_neg <= 0;
end

//this will be the logical or of the pos and neg
assign clk_div_3 = clk_pos || clk_neg;

endmodule

// task 7
module clock_div_five(clk_in, rst, clk_div_5);
input clk_in, rst;
output clk_div_5;

reg [4:0] count_pos;
always @ (posedge clk_in)
begin
	if(rst)
		count_pos <= 5'b00110;
	else
		count_pos <= {count_pos[3:0],count_pos[4]};
end

reg [4:0] count_neg;
always @ (negedge clk_in)
begin
	if(rst)
		count_neg <= 5'b00110;
	else
		count_neg <= {count_neg[3:0],count_neg[4]};
end

//this will be the logical or of the pos and neg
assign clk_div_5 = count_pos[4] || count_neg[4];

endmodule

// task 8
module clock_pulse(clk_in, rst, clk_div);
input clk_in, rst;
output reg clk_div;

reg [99:0] count;
always @ (posedge clk_in)
begin
	if (rst)
	begin
		count <= {1'b1,{99{1'b0}}};
	end
	else
		count <= {count[98:0],count[99]};
end

always @ (posedge clk_in)
begin
	if (rst)
		clk_div <= 0;
	if(count[99])
		clk_div <= ~clk_div;
end

endmodule

// task 9
module clock_strobe(clk_in, rst, toggle_counter);
input clk_in, rst;
output reg [7:0] toggle_counter;

reg [3:0] Q;
always @ (posedge clk_in)
begin
	if (rst)
	begin
		Q <= 4'b0001;
	end
	else
	begin
		Q <= {Q[2:0],Q[3]};
	end
end

always @ (posedge clk_in)
begin
	if (rst)
		toggle_counter <= 0;
	else if (Q[3] == 1)
		toggle_counter <= toggle_counter - 4'b0101; 
	else
		toggle_counter <= toggle_counter + 4'b0011; 
end

endmodule

module clock_gen(
    input clk_in,
    input rst,
    output clk_div_2,
    output clk_div_4,
    output clk_div_8,
    output clk_div_16,
    output clk_div_32,
    output clk_div_26,
    output clk_div_3,
    output clk_pos,
    output clk_neg,
    output clk_div_5,
    output clk_div,
    output [7:0] toggle_counter
    );
	 
clock_div_two task1(
	.clk_in (clk_in),
	.rst (rst),
	.clk_div_2(clk_div_2),
	.clk_div_4(clk_div_4),
	.clk_div_8(clk_div_8),
	.clk_div_16(clk_div_16)
);

clock_div_thirty_two task2 (
	.clk_in(clk_in),
	.rst(rst),
	.clk_div_32(clk_div_32)
);

clock_div_twenty_six task3(
	.clk_in (clk_in),
	.rst (rst),
	.clk_div_26 (clk_div_26)
);

clock_div_three task456(
	.clk_in(clk_in),
	.rst(rst),
	.clk_div_3(clk_div_3),
	.clk_pos(clk_pos),
	.clk_neg(clk_neg)
);

clock_div_five task7(
	.clk_in (clk_in),
	.rst (rst),
	.clk_div_5 (clk_div_5)
);

clock_pulse task8(
	.clk_in(clk_in),
	.rst(rst),
	.clk_div(clk_div)
);

clock_strobe task9(
	.clk_in (clk_in),
	.rst (rst),
	.toggle_counter (toggle_counter)
);


endmodule
