
//This module is a UART receiver, which makes up of 
//standard modules provided from the Quantus II library 
//for shift registers, counters, flip-flops

//This UART receiver receives button signals "forward"
//"backward", "turn left", and "turn right" commands 
//from the application run on the smartphone/tablet.  

module urev(clk,rst,uartdata,uartredone,uartredata);
input	clk,rst,uartdata;
output	uartredone;
output	[7:0] uartredata;
wire	[3:0] bitcount;
wire	shEN,bitcountEN,clkcountEN,redone,rstbitcount;
wire	[2:0] clkcount;
wire	[1:0] redata;

palshiftreg	inst(.clrn(rst),.clk(clk),.Ldn(1'b0),.Sh(shEN),
                 .Di(redata[0]),.Q(uartredata));
					  
defparam	inst.width = 8;

restate	inst1(.clk(clk),.redata(redata[0]),.rst(rst),
              .bitcount(bitcount),.clkcount(clkcount),
              .clkcountEN(clkcountEN),.shEN(shEN),
              .bitcountEN(bitcountEN),.rstbitcount(rstbitcount),
              .redone(redone));

lpm_counter	inst2(.sclr(rstbitcount),.clock(clk),
                  .cnt_en(bitcountEN),.aclr(~rst),.q(bitcount));
defparam inst2.lpm_width = 4,inst2.lpm_type = "LPM_COUNTER",
		 inst2.lpm_direction = "UP";

lpm_shiftreg inst3 (.clock(clk),.shiftin(uartdata),.aset(~rst),
	             .q(redata));
					 
defparam inst3.lpm_type = "LPM_SHIFTREG",inst3.lpm_width = 2,
		 inst3.lpm_direction = "RIGHT";

lpm_counter	inst4 (.sclr(~clkcountEN),.clock(clk),.aclr(~rst),
                   .q(clkcount));
						 
defparam inst4.lpm_width = 3,inst4.lpm_type = "LPM_COUNTER",
		 inst4.lpm_direction = "UP";

dff inst5(.D(redone), .CLK(clk), .CLRN(rst), .Q(uartredone) );

endmodule
