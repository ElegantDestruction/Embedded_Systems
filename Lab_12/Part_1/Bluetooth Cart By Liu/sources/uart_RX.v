
//This module is the UART receiver
module uart_RX(clk,rdata,rst ,R_out,rdready);

//parameter divvalue = 325; //for the baudrate of 9600 bit per second

parameter divvalue = 27; 
input	clk;
input	rdata;
input	rst;

output[7:0] R_out;
wire	baud8clk;

wire	[7:0] RDR;
output	rdready;


baudrate	b2v_inst(.clk(clk),.baud8clk(baud8clk));
defparam	b2v_inst.divvalue = divvalue;


urev	b2v_inst2(.clk(baud8clk),.rst(rst),.uartdata(rdata),.uartredone(rdready),.uartredata(RDR));

LOAD_R	b2v_inst3(.ready_data(rdready),.clk(baud8clk),.RDR(RDR),.R_out(R_out));

endmodule
