// Standard libraries
#include <stdint.h>
#include <stdio.h>

// AVR related libraries
#include <avr/eeprom.h>
#include <avr/io.h>

// FreeRTOS libraries
#include <FreeRTOS.h>
#include <task.h>

// Global configuration
#include <Config.h>

// Local driver
#include <ADC.h>
#include <Serial.h>
#include <SPI.h>

#define stackSize (configMINIMAL_STACK_SIZE)

#define taskPriorityLow  (tskIDLE_PRIORITY + 1)
#define taskPriorityMid  (tskIDLE_PRIORITY + 2)
#define taskPriorityHigh (tskIDLE_PRIORITY + 3)

// Factory fuse settings
FUSES = {
	.low      = 0x62,
	.high     = 0xD9,
	.extended = 0xFF,
};

// Default charger settings for eeprom
uint8_t foo EEMEM = 0;

// ADC reference values
int VREF = 5;
int BITS = 10;

// TODO: Calculation incorrect!
float getVoltage(uint16_t adcValue) {
	return VREF * ((float) adcValue) / ((2 ^ BITS) - 1);
}

void mainTask(void *pvParameters) {
	uint16_t voltage;

	for (;;) {
		voltage = getVoltage(ADC_readValue(0));
		printf("%dV\n", voltage);

		vTaskDelay(1000);
	}
}

// set stream pointer
FILE usart0_str = FDEV_SETUP_STREAM(USART0SendByte, USART0ReceiveByte, _FDEV_SETUP_RW);

int main(void) {
	// TODO: write chipInit() somewhere

	ADC_initializeHardware();
	SPI_initializeHardware();

	// Initialize USART0
	USART0Init();

	// assign our stream to standart I/O streams
	stdin  = &usart0_str;
	stdout = &usart0_str;
	stderr = &usart0_str;

	xTaskCreate(mainTask, "main", stackSize, NULL, taskPriorityLow, NULL);

	vTaskStartScheduler();

	return 1;
}
