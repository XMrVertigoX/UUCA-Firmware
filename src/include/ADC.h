#ifndef ADC_H_
#define ADC_H_

#include <inttypes.h>
#include <stdbool.h>

#include <avr/io.h>

void ADC_initializeHardware(void);

/*
 * Convert analog values. 10 bit precision. Results between 0x0000 and 0x03FF. Returns 0xFC00 in case of an error
 */
uint16_t ADC_readValue(uint8_t channel);

#endif
