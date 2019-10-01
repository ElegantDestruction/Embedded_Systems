#include "BusDevice.h"

namespace exploringRPi
{
	BusDevice::BusDevice(unsigned int bus, unsigned int device)
	{
		this->bus = bus;
		this->device = device;
		this->file = -1;
	}
	BusDevice::~BusDevice() {}
}
