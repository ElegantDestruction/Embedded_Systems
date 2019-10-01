#include <iostream>
#include "SPIDevice.h"

using namespace exploringRPi;

void addDelay(int delay) {
	for(int i = 0; i < 500000 * delay; i++) {
		for(int x = 0; x < delay; x++)
		{
			__asm("NOP");
		}
	}
}

int main() {
	std::cout << "Starting ADC" << std::endl;
	SPIDevice * busDev = new SPIDevice(0, 0);
	busDev->setSpeed(5000000);
	busDev->setMode(SPIDevice::MODE0);
	unsigned char send[3], receive[3];
	send[0] = 0b00000110;
	send[1] = 0b00000000;
	while(true) 
	{
		busDev->transfer(send, receive, 3);
		int value = ((receive[1] & 0b00000011) << 8) | receive[2];
		std::cout << "LDR value: " << value << " out of 4095." << std::endl;
		addDelay(10);
	}
}
