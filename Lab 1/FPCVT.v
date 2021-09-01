`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:35:03 04/17/2021 
// Design Name: 
// Module Name:    FPCVT 
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
module signMagConversion(
	input [12:0] twosComplement,
	output reg signBit,
	output reg [12:0] signMagnitude
);

	always @twosComplement 
	begin
		signBit = twosComplement[12];
		if(twosComplement == 13'b1000000000000)
			signMagnitude = 13'b0111111111111;
		else if(twosComplement[12] == 1)
			signMagnitude = ~(twosComplement) + 1'b1;
		else
			signMagnitude = twosComplement;
	end
endmodule

module bitExtraction(
	input [12:0] signMagnitude,
	output reg [2:0] exp,
	output reg [4:0] significand,
	output reg sixthBit
);

	always @* 
	begin
		if(signMagnitude[11] == 1) 
		begin
			exp = 7;
			significand = signMagnitude[11:7];
			sixthBit = signMagnitude[6];
		end
		else if(signMagnitude[10] == 1) 
		begin
			exp = 6;
			significand = signMagnitude[10:6];
			sixthBit = signMagnitude[5];
		end
		else if(signMagnitude[9] == 1) 
		begin
			exp = 5;
			significand = signMagnitude[9:5];
			sixthBit = signMagnitude[4];
		end
		else if(signMagnitude[8] == 1) 
		begin
			exp = 4;
			significand = signMagnitude[8:4];
			sixthBit = signMagnitude[3];
		end
		else if(signMagnitude[7] == 1) 
		begin
			exp = 3;
			significand = signMagnitude[7:3];
			sixthBit = signMagnitude[2];
		end
		else if(signMagnitude[6] == 1) 
		begin
			exp = 2;
			significand = signMagnitude[6:2];
			sixthBit = signMagnitude[1];
		end
		else if(signMagnitude[5] == 1) 
		begin
			exp = 1;
			significand = signMagnitude[5:1];
			sixthBit = signMagnitude[0];
		end
		else
		begin
			exp = 0;
			significand = signMagnitude[4:0];
			sixthBit = 0;
		end
	end

endmodule

module rounding(
	input [2:0] exp,
	input [4:0] significand,
	input sixthBit,
	output reg [2:0] newExp,
	output reg [4:0] newSignificand
);
	
	always @* 
	begin
		if(sixthBit == 1) 
		begin //rounding up process
			if(significand == 5'b11111) 
			begin
				if(exp == 3'b111) 
				begin //the biggest E/F combo
					newExp = exp;
					newSignificand = significand;
				end
				else 
				begin //carry over to exponent
					newExp = exp + 1'b1;
					newSignificand = (significand >> 1) + 1'b1;
				end
			end
			else 
			begin //normal rounding up
				newExp = exp;
				newSignificand = significand + 1'b1;
			end
		end
		else 
		begin //no rounding up
			newExp = exp;
			newSignificand = significand;
		end
	end
endmodule

module FPCVT(
    input [12:0] D,
    output S,
    output [2:0] E,
    output [4:0] F
    );

wire [12:0] tempSignMag;
wire tempSign;

wire [2:0] tempExponent;
wire [4:0] tempSignificand;
wire tempSixthBit;

wire [2:0] finalE;
wire [4:0] finalSig;

assign S = tempSign;

assign E = finalE;
assign F = finalSig;

signMagConversion smg(
	.twosComplement(D),
	.signBit(tempSign),
	.signMagnitude(tempSignMag)
);

bitExtraction b_ext(
	.signMagnitude(tempSignMag),
	.exp(tempExponent),
	.significand(tempSignificand),
	.sixthBit(tempSixthBit)
);

rounding rnd(
	.exp(tempExponent),
	.significand(tempSignificand),
	.sixthBit(tempSixthBit),
	.newExp(finalE),
	.newSignificand(finalSig)
);

endmodule
