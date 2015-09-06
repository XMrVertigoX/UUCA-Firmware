#include <Serial.h>

#define UBRR_VALUE (((F_CPU / (USART_BAUDRATE * 16UL))) - 1)

void USART0Init(void) {
	// Set baud rate
	UBRR0H = (uint8_t) (UBRR_VALUE >> 8);
	UBRR0L = (uint8_t) (UBRR_VALUE);

	// Set frame format to 8 data bits, no parity, 1 stop bit
	UCSR0C |= (1 << UCSZ01) | (1 << UCSZ00);

	// enable transmission and reception
	UCSR0B |= (1 << RXEN0) | (1 << TXEN0);
}

int USART0SendByte(char data, FILE *stream) {
	// Send additionally carriage return
	if (data == '\n') {
    	USART0SendByte('\r', 0);
	}

	// wait while previous byte is completed
	while(!(UCSR0A & (1 << UDRE0)));

	// Transmit data
	UDR0 = data;

	return 0;
}

int USART0ReceiveByte(FILE *stream) {
	uint8_t data;

	// Wait for byte to be received
	while(!(UCSR0A & (1 << RXC0)));

	data = UDR0;

	// Return received data
	return data;
}
