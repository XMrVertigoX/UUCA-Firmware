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
		Serial_printIntegerAndReturn(ADC_readValue(0), 10);

		_delay_ms(250);
	}
}
