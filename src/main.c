/* Standard libraries */
#include <stdint.h>

/* AVR related libraries */
#include <avr/eeprom.h>
#include <avr/io.h>
#include <util/delay.h>

/* FreeRTOS libraries */
#include <FreeRTOS.h>
#include <task.h>

/* Local driver */
#include <ADC.h>
#include <debug.h>
#include <SPI.h>

#define stackSize (configMINIMAL_STACK_SIZE)

#define taskPriorityLow  (tskIDLE_PRIORITY + 1)
#define taskPriorityMid  (tskIDLE_PRIORITY + 2)
#define taskPriorityHigh (tskIDLE_PRIORITY + 3)

/* Arduino fuse settings */
FUSES = { .low = LFUSE_DEFAULT, .high = HFUSE_DEFAULT, .extended = EFUSE_DEFAULT, };

/* Default charger settings for eeprom */
uint8_t foo EEMEM = 0;

int VREF = 5;
int BITS = 10;

/* TODO: Calculation incorrect! */
float getVoltage(uint16_t adcValue) {
	return VREF * ((float) adcValue) / ((2 ^ BITS) - 1);
}

void mainTask(void *pvParameters) {
	for (;;) {
		/*Serial_print("Voltage: ");
		 Serial_printInteger(getVoltage(ADC_readValue(0)), 10);
		 Serial_print("V\n");*/

		assert(false);

		vTaskDelay(1000);
	}

	vTaskDelete(NULL);
}

int main(void) {
	/* TODO: write boardInit somewhere */

	ADC_initializeHardware();
	Serial_initializeHardware();
	SPI_initializeHardware();

	xTaskCreate(mainTask, "main", stackSize, NULL, taskPriorityHigh, NULL);

	vTaskStartScheduler();

	return 1;
}
