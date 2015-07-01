/*
 * Main.h
 *
 * Created on: May 13, 2015
 * Author: Caspar Friedrich
 */

#ifndef MAIN_H_
#define MAIN_H_

// Standard libraries
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

// AVR Libraries
#include <avr/interrupt.h>
#include <util/delay.h>

// Local libraries
#include "ADC.h"
#include "Events.h"
#include "Serial.h"
#include "SPI.h"
#include "lib/MCP4151.h"

// Friendly names
#define enableInterrupts()  sei()
#define disableInterrupts() cli()

#define ADC_InA  PC0
#define ADC_InB  PC1
#define ADC_OutA PC2
#define ADC_OutB PC3

#endif /* MAIN_H_ */
