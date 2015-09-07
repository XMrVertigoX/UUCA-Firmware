#ifndef SERIAL_H_
#define SERIAL_H_

#include <stdint.h>
#include <stdio.h>

#include <avr/io.h>

#include <Config.h>

void USART0Init(void);
int  USART0SendByte(uint8_t data, FILE *stream);
int  USART0ReceiveByte(FILE *stream);

#endif
