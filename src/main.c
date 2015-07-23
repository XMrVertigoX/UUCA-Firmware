#include <util/delay.h>

#include "ADC.h"
#include "Serial.h"
#include "SPI.h"
int VREF = 5;
int BITS = 10;

float getVoltage(uint16_t adcValue) {
	return VREF*((float)adcValue)/(2^(BITS));
}

int main(void) {
	ADC_initializeHardware();
	Serial_initializeHardware();
	SPI_initializeHardware();

	for (;;) {
		Serial_print("Voltage: ");
		Serial_printInteger(getVoltage(ADC_readValue(0)), 10);
		Serial_print("V\n");

		_delay_ms(250);
	}
}




