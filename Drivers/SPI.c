#include <SPI.h>

void setupSPIBus() {
	// Set MOSI, SCK and SS as outputs
	DDRB |= (1 << MOSI) | (1 << SCK) | (1 << SS);

	// Enable master SPI at clock rate Fck/16
	SPCR = (1 << SPE) | (1 << MSTR) | (1 << SPR0);
}

void setupChipSelect() {
	// Set chip select lines as outputs
	DDRB |= (1 << POTI0) | (1 << POTI1);

	// Set both CS lines high (idle)
	PORTB |= (1 << POTI0) | (1 << POTI1);
}

void enableChipSelect(uint8_t chipSelect) {
	// Set chipSelect pin low
	PORTB &= ~((1 << chipSelect));
}

void disableChipSelect(uint8_t chipSelect) {
	// Set chipSelect pin high
	PORTB |= (1 << chipSelect);
}

void writeData(uint8_t data) {
	SPDR = data;
}

bool transmissionComplete() {
	return SPSR & (1 << SPIF);
}

void SPI_initializeHardware(void) {
	setupSPIBus();
	setupChipSelect();
}

void SPI_transferData(uint8_t data, uint8_t chipSelect) {
	enableChipSelect(chipSelect);
	writeData(data);

	while (!transmissionComplete())
		;

	disableChipSelect(chipSelect);
}
