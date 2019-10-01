#ifndef BUSDEVICE_H_
#define BUSDEVICE_H_

namespace exploringRPi
{
	class BusDevice
	{
		protected:
			unsigned int bus;
			unsigned int device;
			int file;
		public:
			BusDevice(unsigned int bus, unsigned int device);
			virtual int open() = 0;
			virtual unsigned char readRegister(unsigned int registerAddress) = 0;
			virtual unsigned char * readRegisters(unsigned int number, unsigned int fromAddress = 0) = 0;
			virtual int write(unsigned char value) = 0;
			virtual int writeRegister(unsigned int registerAddress, unsigned char value) = 0;
			virtual void debugDumpRegisters(unsigned int number = 0xff) = 0;
			virtual void close() = 0;
			virtual ~BusDevice();
	};
}
#endif
