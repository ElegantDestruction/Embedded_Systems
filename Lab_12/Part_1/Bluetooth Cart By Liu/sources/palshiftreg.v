module palshiftreg(clrn,clk,Ldn,Sh,Di,D,Q);
parameter width = 4;
input clrn,clk,Ldn,Sh;
input Di;
input [width-1:0] D;
output [width-1:0] Q;
reg  [width-1:0] Q;
always @(posedge clk or negedge clrn)
begin
  if (~clrn) Q <= 0;
  else 
	if (Ldn) 
	  Q <= D;
	else if (Sh) 
	   begin
		Q[width-2:0] <= Q[width-1:1];
		Q[width-1]   <= Di;
	   end 
end
endmodule





