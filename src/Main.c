#include "Main.h"

/*
 * Main.c
 *
 * Created on: May 13, 2015
 * Author: Caspar Friedrich
 */

struct {
	bool readMode; // Read mode interrupt flag
} flags;

void initializeHardware(void) {
	Serial_initializeHardware();
	SPI_initializeHardware();
	ADC_initializeHardware();
}

void loadLastSystemState(void) {
	// TODO: Read values from EEPROM
}

int main(void) {
	initializeHardware();

	loadLastSystemState();

	enableInterrupts();

	//int8_t i = 0;
	//bool rising = true;

	// Infinite loop
	for (;;) {
		// Read new voltages if flag is present
		if (flags.readMode) {
			// TODO: Read current voltage and save in runtime and EEPROM

			// Turn off read mode when done
			flags.readMode = false;
		}

		// TODO: Regulator stuff

		Serial_printIntegerAndReturn(ADC_readValue(8), 16);

		/*if (rising) {
		 SPI_transfer(MCP4151_8_INCREASE, POTI0);
		 SPI_transfer(MCP4151_8_INCREASE, POTI1);
		 i++;
		 } else {
		 SPI_transfer(MCP4151_8_DECREASE, POTI0);
		 SPI_transfer(MCP4151_8_DECREASE, POTI1);
		 i--;
		 }

		 if (i == 255) {
		 rising = false;
		 } else if (i == 0) {
		 rising = true;
		 }*/

		_delay_ms(250);
	}

	//Disable interrupts in case of system failure
	disableInterrupts();

	// Second loop to prevent system failures
	for (;;)
		;
}
