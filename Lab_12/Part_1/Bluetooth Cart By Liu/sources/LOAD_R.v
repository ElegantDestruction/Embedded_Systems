
//This module checks if data is ready for the UART receiver 
//from the bluetooth module. 
//If data is ready, read and move data to R_out  

 
module LOAD_R(clk,RDR, R_out,ready_data);
input	ready_data,clk;
input	[7:0]RDR;
output reg	[7:0]R_out;

always @(posedge clk)
begin
	if(ready_data)
	begin
	  
	  R_out<=RDR; 
	  
	
	end
end


endmodule