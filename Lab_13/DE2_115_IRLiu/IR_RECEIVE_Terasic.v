
module IR_RECEIVE(
					iCLK,         //clk 50MHz
					iRST_n,       //reset					
					iIRDA,        //IR code input
					oDATA_READY,  //data ready
					oDATA         //decode data output
					);


//=======================================================
//  PARAMETER declarations
//=======================================================
parameter IDLE              = 2'b00;  //state Idle: always at a high voltage level
parameter GUIDANCE          = 2'b01;  //state guidance; 9ms at a low voltage and 4.5 ms at a high voltage
parameter DATAREAD          = 2'b10;  //state; read IR data 
												 
												  
parameter IDLE_HIGH_DUR     = 262143; // data_count    262143*0.02us = 5.24ms, threshold for DATAREAD-----> IDLE
parameter GUIDE_LOW_DUR     = 230000; // idle_count    230000*0.02us = 4.60ms, threshold for IDLE--------->GUIDANCE
parameter GUIDE_HIGH_DUR    = 210000; // state_count   210000*0.02us = 4.20ms, 4.5-4.2 = 0.3ms < BIT_AVAILABLE_DUR = 
												  // 0.4ms,threshold for GUIDANCE------->DATAREAD
parameter DATA_HIGH_DUR     = 41500;  // data_count    41500 *0.02us = 0.83ms, sample time from the posedge of iIRDA
parameter BIT_AVAILABLE_DUR = 20000;  // data_count    20000 *0.02us = 0.4ms,  the sample bit 
												  // pointer,can inhibit the interference from iIRDA signal


//=======================================================
//  PORT declarations
//=======================================================
input         iCLK;        //input clk,50MHz
input         iRST_n;      //rst
input         iIRDA;       //Irda RX output decoded data
output        oDATA_READY; //data ready
output [31:0] oDATA;       //output data,32bit 


//=======================================================
//  Signal Declarations
//=======================================================
reg    [31:0] oDATA;                 //data output reg
reg    [17:0] idle_count;            //idle counter; run in the data_read state
reg           idle_count_flag;       //idle_count conter flag
reg    [17:0] state_count;           //state_count; run in guidance state
reg           state_count_flag;      //state_count conter flag
reg    [17:0] data_count;            //data_count; run in data_read state
reg           data_count_flag;       //data_count conter flag
reg     [5:0] bitcount;              //sample bit pointer
reg     [1:0] state;                 //state reg
reg    [31:0] data;                  //data reg
reg    [31:0] data_buf;              //data buf
reg           data_ready;            //data ready flag


//=======================================================
//  Structural coding
//=======================================================	
assign oDATA_READY = data_ready;

//idle counter runs at IDLE state only
always @(posedge iCLK or negedge iRST_n)
	if (!iRST_n)
		idle_count <= 0;
	else if (idle_count_flag)
		idle_count <= idle_count + 1'b1;
	else
		idle_count <= 0;
		
		
		
//idle counter job complete when iIRDA is low in the IDLE state
always @(posedge iCLK or negedge iRST_n)
	if (!iRST_n)
		idle_count_flag <= 1'b0;
	else if ((state == IDLE) && !iIRDA)
		idle_count_flag <= 1'b1;
	else
		idle_count_flag <= 1'b0;
		
		
		
//state counter runs in th GUIDANCE state only
always @(posedge iCLK or negedge iRST_n)
	if (!iRST_n)
		state_count <= 0;
	else if (state_count_flag)
		state_count <= state_count + 1'b1;
	else 
		state_count <= 0;

//state counter job complete when iIRDA is high in the GUIDANCE state
always @(posedge iCLK or negedge iRST_n)
	if (!iRST_n)
		state_count_flag <= 1'b0;
	else if ((state == GUIDANCE) && iIRDA)
		state_count_flag <= 1'b1;
	else 
		state_count_flag <= 1'b0;

//data read counter runs on iCLK clock
always @(posedge iCLK or negedge iRST_n)
	if(!iRST_n)
		data_count <= 1'b0;
	else if (data_count_flag)
		data_count <= data_count + 1'b1;
	else 
		data_count <= 1'b0;
		
//data counter job complete
always @(posedge iCLK or negedge iRST_n)
	if (!iRST_n)
		data_count_flag <= 0;
	else if ((state == DATAREAD) && iIRDA)
		data_count_flag <= 1'b1;
	else 
		data_count_flag <= 1'b0;
		
		
//data reg pointer counter
always @(posedge iCLK or negedge iRST_n)
	if (!iRST_n)
		bitcount <= 6'b0;
	else if (state == DATAREAD)
	begin
		if (data_count == 20000)
			bitcount <= bitcount + 1'b1;
	end
	else
		bitcount <= 6'b0;
		
		
//state change between IDLE, GUIDE, DATA_READ according to irda edge or counter value
always @(posedge iCLK or negedge iRST_n)
	if (!iRST_n)
		state <= IDLE;
	else
		case (state)
			IDLE	:	if (idle_count > GUIDE_LOW_DUR)	//state change from IDLE to Guidance when detect the negedge and the low voltage last for > 4.6ms
			
						state <= GUIDANCE;
			GUIDANCE	:	if (state_count > GUIDE_HIGH_DUR)
			
						state <= DATAREAD;
			DATAREAD	:	if ((data_count >= IDLE_HIGH_DUR) || (bitcount >= 33))
						state <= IDLE;
			default	:	state <= IDLE;	//default
		endcase
		
//data decoding
always @(posedge iCLK or negedge iRST_n)
	if (!iRST_n)
		data <= 0;
	else if (state == DATAREAD)
	begin
		if (data_count >= DATA_HIGH_DUR)
			data[bitcount - 1'b1] <= 1'b1;
	end
	else
		data <= 0;
		
		
//set the data_ready flag
always @(posedge iCLK or negedge iRST_n)
	if (!iRST_n)
		data_ready <= 1'b0;
	else if (bitcount == 32)
		begin
			if (data[31:24] == ~data[23:16])
			begin
				data_buf <= data;
				data_ready <= 1'b1;
			end
			else
				data_ready <= 1'b0;
		end
	else 
		data_ready <= 1'b0;
		

//read data
always @(posedge iCLK or negedge iRST_n)
	if (!iRST_n)
		oDATA <= 32'b0000;
	else if (data_ready)
		oDATA <= data_buf;



					
endmodule
