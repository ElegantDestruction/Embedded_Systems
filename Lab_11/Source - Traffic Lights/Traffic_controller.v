`timescale 1ns / 1ps

module Traffic_controller(
	input wire clk,
	input wire clr,
	output reg [5:0] lights
	);
	
	reg [2:0] state;
	reg [3:0] count;
	
	parameter	S0 = 3'b000,
					S1 = 3'b001,
					S2 = 3'b010,
					S3 = 3'b011,
					S4 = 3'b100,
					S5 = 3'b101,
					SEC5 = 4'b1111,
					SEC1 = 4'b0011;
	
	
	always @(posedge clk or negedge clr)
		begin
			if(clr == 0)
				begin
					state <= S0;
					count <= 0;
				end
			else
				begin
					case(state)
						S0	:	if(count < SEC5)
									begin
										state <= S0;
										count <= count + 1'b1;
									end
								else
									begin
										state <= S1;
										count <= 1'b0;
									end
									
						S1	:	if(count < SEC1)
									begin
										state <=S1;
										count <= count + 1'b1;
									end
								else
									begin
										state <= S2;
										count <= 1'b0;
									end
								
						
						S2	:	if(count < SEC1)
									begin
										state <=S2;
										count <= count + 1'b1;
									end
								else
									begin
										state <= S3;
										count <= 1'b0;
									end
						
						S3	:	if(count < SEC5)
									begin
										state <=S3;
										count <= count + 1'b1;
									end
								else
									begin
										state <= S4;
										count <= 1'b0;
									end
						
						S4	:	if(count < SEC1)
									begin
										state <=S4;
										count <= count + 1'b1;
									end
								else
									begin
										state <= S5;
										count <= 1'b0;
									end
						
						S5	:	if(count < SEC1)
									begin
										state <=S5;
										count <= count + 1'b1;
									end
								else
									begin
										state <= S0;
										count <= 1'b0;
									end
						
					endcase
				end
		end
		
		
	always@(*)
		begin
			case(state)
				S0:	lights = 6'b100001;
				S1:	lights = 6'b100010;
				S2:	lights = 6'b100100;
				S3:	lights = 6'b001100;
				S4:	lights = 6'b010100;
				S5:	lights = 6'b100100;
				default lights = 6'b100001;
			endcase
		end
endmodule
