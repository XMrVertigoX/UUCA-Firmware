#ifndef SERIAL_H_
#define SERIAL_H_

#include <stdint.h>
#include <stdio.h>

#include <avr/io.h>

// #define USART_BAUDRATE (9600)

void USART0Init(void);
int USART0SendByte(char data, FILE *stream);
int USART0ReceiveByte(FILE *stream);

#endif
