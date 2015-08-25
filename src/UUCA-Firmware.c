#include <inttypes.h>

#include "avr/io.h"
#include <util/delay.h>

#include "ADC.h"
#include "Serial.h"
#include "SPI.h"

FUSES = {
    .low      = LFUSE_DEFAULT,
    .high     = HFUSE_DEFAULT,
    .extended = EFUSE_DEFAULT,
};

int VREF = 5;
int BITS = 10;

// TODO: Calculation incorrect!
float getVoltage(uint16_t adcValue) {
	return VREF * ((float) adcValue) / ((2^BITS) - 1);
}

int main(void) {
	// TODO: write boardInit somewhere

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
