#ifndef SERIAL_H_
#define SERIAL_H_

#include <stdint.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include <string.h>

#include <avr/io.h>

#define USART_BAUDRATE 9600
#define BAUD_PRESCALE (((F_CPU/(USART_BAUDRATE*16UL))) - 1)

#define BIN (2)
#define DEC (10)
#define HEX (16)

void Serial_initializeHardware(void);

void Serial_print(const char *str);
void Serial_printAndReturn(const char *str);
void Serial_printInteger(int val, uint8_t base);
void Serial_printIntegerAndReturn(int val, uint8_t base);

#endif
