/*
 * SPI.h - SPI controller library for the UUCA
 *
 * Created on: Mar 27, 2015
 * Author: Caspar Friedrich
 */

#ifndef SPI_H_
#define SPI_H_

#include <stdint.h>
#include <stdbool.h>

#include <avr/io.h>

#include "util/process.h"

#define POTI0 PB0
#define POTI1 PB1

#define SS    PB2
#define MOSI  PB3
#define MISO  PB4
#define SCK   PB5

void SPI_initializeHardware(void);
void SPI_transferData(uint8_t data, uint8_t chipSelect);

#endif /* SPI_H_ */
