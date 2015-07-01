/*
 * ADC.h
 *
 * Created on: Apr 15, 2015
 * Author: Caspar Friedrich
 * 
 * Module to control the ADC functionality.
 */

#ifndef ADC_H_
#define ADC_H_

#include <stdint.h>
#include <stdbool.h>

#include <avr/io.h>

#include "util/process.h"

void ADC_initializeHardware(void);

/* 
 * Convert analog values. 10 bit precision. Results between 0x0000 and 0x03FF. Returns 0xFC00 in case of an error
 */
uint16_t ADC_readValue(uint8_t channel);

#endif /* ADC_H_ */
