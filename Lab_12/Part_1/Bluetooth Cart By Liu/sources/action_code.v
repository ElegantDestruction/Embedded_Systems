module  action_code(ASCII_code, action );
input [7:0] ASCII_code;
output [3:0]action;
reg [3:0] action;

always @ (ASCII_code)
begin
case(ASCII_code)
8'b00110001: action =4'b0001; //if ASCII_code =8'b00110001,action =4'b0001
8'b00110010: action =4'b0100; //if ASCII_code =8'b00110010,action =4'b0100
8'b00110011: action =4'b1000; //if ASCII_code =8'b00110100,action =4'b1000  
8'b00110100: action =4'b0010; //if ASCII_code =8'b00110101,action =4'b0010
default: action =4'b0000; 
endcase
end 
endmodule
