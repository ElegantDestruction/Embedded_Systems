/* A Simple GPIO application*/

#include<iostream>
#include<unistd.h>  // for the usleep() function
#include"GPIO.h"
using namespace exploringRPi;
using namespace std;

int main(){
   	GPIO outGPIO(17), inGPIO(27);    // pin 11 and pin 13

	outGPIO.setDirection(OUTPUT);			// configure GPIO to output 

	
	for (int i=0; i<10; i++){        			// flash the LED 10 times
		outGPIO.setValue(HIGH);				// turn the LED on
		usleep(500000);					// sleep for 0.5 seconds
		outGPIO.setValue(LOW);				// turn the LED off
		usleep(500000);					// sleep for 0.5 seconds
	}

   	inGPIO.setDirection(INPUT);      // configure GPIO to output
   
	cout << "The input state is: " << inGPIO.getValue() << endl;	//print input state to screen
									//using cout
   
 

   outGPIO.streamOpen();            
   for (int i=0; i<1000000; i++){   // write 1 million cycles
      outGPIO.streamWrite(HIGH);    // high
      outGPIO.streamWrite(LOW);     // immediately low, repeat
   }
   outGPIO.streamClose();           // close the stream
   return 0;
}
