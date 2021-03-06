
//module Bluetooth_Enabled_Cart_control

module BT_PWM ( CLOCK_50, reset_n, 	RX, LED, pwm_out_left, pwm_out_right );
parameter divvalue = 325 ;//9600 bps //missing a value here
 
input CLOCK_50;
input  reset_n;
input    RX;
output [7:0] LED;
output pwm_out_left;
output pwm_out_right;

wire [3:0] action;

uart_RX inst0(.clk(CLOCK_50),.rdata(RX),.rst(reset_n) ,.R_out(LED));
defparam  inst0.divvalue = divvalue; //9600

action_code inst1(.ASCII_code(LED), .action(action) );

motor_pwm_v inst2( .reset_n(reset_n),. clk(CLOCK_50),  .SW(action) //missing code here
                   ,.pwm_out_left(pwm_out_left), .pwm_out_right(pwm_out_right)); 

endmodule
