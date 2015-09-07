#include <UART.h>

#include <stdint.h>

#include <avr/io.h>
#include <util/setbaud.h>

// #define UBRR_VALUE ((F_CPU / (UART_BAUDRATE * 16UL)) - 1)

void UART0_init(void) {
	// Set baud rate
	UBRR0H = UBRRH_VALUE;
	UBRR0L = UBRRL_VALUE;

	// Set frame format to 8 data bits, no parity, 1 stop bit
	UCSR0C |= (1 << UCSZ01) | (1 << UCSZ00);

	// enable transmission and reception
	UCSR0B |= (1 << RXEN0) | (1 << TXEN0);
}

int UART0_sendByte(char data, FILE *stream) {
	// Send additional carriage return
	// if (data == '\n') {
    // 	UART0_sendByte('\r', 0);
	// }

	// wait while previous byte is completed
	while(!(UCSR0A & (1 << UDRE0)));

	// Transmit data
	UDR0 = data;

	return 0;
}

int UART0_receiveByte(FILE *stream) {
	uint8_t data;

	// Wait for byte to be received
	while(!(UCSR0A & (1 << RXC0)));

	data = UDR0;

	// Return received data
	return data;
}
