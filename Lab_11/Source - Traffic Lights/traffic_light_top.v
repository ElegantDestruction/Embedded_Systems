`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:41:31 10/02/2013 
// Design Name: 
// Module Name:    traffic_light_top 
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
module traffic_light_top(
    input wire clk,
    input wire btn1,
    input wire btn2,
    output wire [5:0] led
    );

wire clk3;
wire clr;

//btn1 is pressed to simulate the presence of pedestrians
//btn2 is pressed to clear the system

assign X = btn1;
assign clr = btn2;

clkdiv U1 (.clk(clk), .clr(clr), .clk3(clk3));

Traffic_controller U2 (.clk(clk3), .clr(clr), .lights(led));

endmodule
