module restate(clk,rst, redata,clkcount,bitcount,
		        clkcountEN, shEN, bitcountEN,
		        rstbitcount, redone);
  input	clk, redata, rst;
  input [2:0] clkcount;
  input [3:0] bitcount;
  output clkcountEN, shEN, bitcountEN, rstbitcount;
  output redone;
  reg	clkcountEN, shEN ;
  reg	bitcountEN,	rstbitcount, redone;
  reg	[2:0]	next_state, state;
  parameter	r_START = 3'b001,  	r_CENTER = 3'b010,
          	r_WAIT  = 3'b011,   r_SAMPLE = 3'b100,
		  	r_STOP  = 3'b101;
  parameter	WORD_LEN = 8;

 // State Machine - Next State Assignment
  always @(posedge clk or negedge rst)
   begin
    if (~rst) state <= r_START;
     else state <= next_state;
   end
  // State Machine - Next State
  always @(state or redata or clkcount or bitcount)
   begin
   // default
    next_state  = state;
    clkcountEN = 1'b0;
    shEN      = 1'b0;
    bitcountEN      = 1'b0;
    rstbitcount   = 1'b0;
    redone= 1'b0;

    case (state)
     // START state Wait for the start bit
     r_START:
      begin
       if (~redata ) next_state = r_CENTER;
       else 
        begin 
         next_state = r_START;
         rstbitcount  = 1'b1; 
        end
     end

	// CENTER state Find the center of the bit-cell 
     r_CENTER: 
      begin
       if(clkcount == 3'h4)
         begin
 		 // it is still 0, then it is a genuine start bit
           if (~redata) next_state = r_WAIT;
		 // otherwise, could have been a false noise
           else next_state = r_START;
         end
       else
         begin
          next_state  = r_CENTER;
		  clkcountEN = 1'b1;  // allow counter to tick          
         end
      end
	// WAIT state Wait a bit-cell time before 
	// sampling the state of the data pin
	 r_WAIT:
	  begin
		if (clkcount == 3'h6) 
		 begin
           if (bitcount == WORD_LEN)
             next_state = r_STOP; 
           else
            begin
             next_state = r_SAMPLE;
            end
         end
        else
            begin
             next_state  = r_WAIT;
             clkcountEN = 1'b1;   
            end
      end
   	 r_SAMPLE:
	  begin
		shEN = 1'b1; 
		bitcountEN = 1'b1; // one more bit received
		next_state = r_WAIT;
	  end	
    // STOP state make sure the stop bit
     r_STOP: 
      begin
		next_state = r_START;
        redone = 1'b1;
      end
     default: begin
       next_state  = 3'bxxx;
       clkcountEN = 1'bx;
	   shEN      = 1'bx;
	   bitcountEN      = 1'bx;
       rstbitcount   = 1'bx;
       redone  = 1'bx;
      end
   endcase
 end
endmodule

