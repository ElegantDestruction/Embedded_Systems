`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:43:49 10/02/2013 
// Design Name: 
// Module Name:    clkdiv 
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
module clkdiv(
	input wire clk,
	input wire clr,
	output wire clk3
	);
	
reg [25:0] q;

always @(posedge clk or negedge clr)
	begin
		if(clr==0)
			q<=0;
		else
			q <= q+1'b1;
	end
assign clk3 = q[22];
endmodule

