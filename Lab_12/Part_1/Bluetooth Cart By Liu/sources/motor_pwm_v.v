//module motor_switch_two_v ( reset_n, clk, SW, pwm_out_left, pwm_out_right ); 

module motor_pwm_v ( reset_n, clk, SW, pwm_out_left, pwm_out_right ); 
parameter period_width = 2000;   
input reset_n;
input clk;
input [3:0] SW;
output pwm_out_left;
output pwm_out_right;
wire clk_100KHz;
reg [9:0] N_left; 
reg [9:0] N_right;
reg [31:0]  period ;

divider_v inst1 (.reset_n(reset_n), .clk(clk), .clk_out(clk_100KHz));
defparam inst1.divisor = 500;
defparam inst1.divisor2 = 250;


always @ (SW)
begin
  // x and z values are NOT treated as don't-care's
case(SW)
4'b0001: begin  N_left=170; N_right = 130; end
4'b0010: begin  N_left=130; N_right = 170; end
4'b0100: begin  N_left=170; N_right = 170; end
4'b1000: begin  N_left=130; N_right = 130; end
default: begin  N_left=150; N_right = 150; end
endcase
end

always @ (posedge clk_100KHz or negedge reset_n)
begin
   if (reset_n == 0) 
	     period <= 1;
	 else if ( period == period_width)  	
        period <= 1;
    else
        period <= period + 1;
end
   assign pwm_out_left   = (period > N_left)  ? 0: 1;
   assign pwm_out_right  = (period > N_right) ? 0: 1;
	
endmodule
