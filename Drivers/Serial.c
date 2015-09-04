#include <Serial.h>

void Serial_initializeHardware(void) {
	UCSR0B |= (1 << RXEN0) | (1 << TXEN0);
	UCSR0C |= (1 << UCSZ00) | (1 << UCSZ01);
	UBRR0H = (BAUD_PRESCALE >> 8);
	UBRR0L = BAUD_PRESCALE;
}

static void writeByte(uint8_t dataByte) {
	UDR0 = dataByte;

	while (!(UCSR0A & (1 << UDRE0)))
		;
}

void Serial_print(const char *str) {
	int i;

	for (i = 0; i < strlen(str); i++) {

		// Print a space if char is not an ASCII character
		if (isascii(str[i])) {
			writeByte(str[i]);
		} else {
			writeByte(0x20);
		}
	}
}

void Serial_printAndReturn(const char *str) {
	Serial_print(str);
	Serial_print("\r\n");
}

void Serial_printInteger(int val, uint8_t base) {
	uint8_t digits;

	// Calculate amount of digits
	if (val == 0) {
		digits = 1;
	} else {
		digits = (uint8_t) log10(abs(val)) + 1;
	}

	// Create an empty char buffer matching the digits and add two for the terminating zero and the sign
	char str[digits + 2];

	itoa(val, str, base);

	Serial_print(str);
}

void Serial_printIntegerAndReturn(int val, uint8_t base) {
	Serial_printInteger(val, base);
	Serial_print("\r\n");
}
