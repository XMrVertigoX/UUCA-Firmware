#ifndef SPI_H_
#define SPI_H_

#include <stdint.h>

void SPI_initializeHardware(void);
void SPI_transferData(uint8_t data, uint8_t chipSelect);

#endif
