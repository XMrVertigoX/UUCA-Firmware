#ifndef UART_H_
#define UART_H_

#include <stdio.h>

void UART0_init(void);
int UART0_sendByte(char data, FILE *stream);
int UART0_receiveByte(FILE *stream);

#endif
