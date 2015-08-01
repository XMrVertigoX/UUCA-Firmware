#include <util/delay.h>

#include "ADC.h"
#include "Serial.h"
#include "SPI.h"

int main(void) {
	ADC_initializeHardware();
	Serial_initializeHardware();
	SPI_initializeHardware();

	for (;;) {
		Serial_print("ADC: ");
		Serial_printInteger(ADC_readValue(8), 10);
		Serial_print("\n");

		_delay_ms(250);
	}
}
