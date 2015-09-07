// Standard libraries
#include <stdint.h>
#include <stdio.h>

// AVR related libraries
#include <avr/eeprom.h>
#include <avr/io.h>

// FreeRTOS libraries
#include <FreeRTOS.h>
#include <task.h>

// Local driver
#include <ADC.h>
#include <UART.h>
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

// set stream pointer
FILE UART0_Stream = FDEV_SETUP_STREAM(UART0_sendByte, UART0_receiveByte, _FDEV_SETUP_RW);

// TODO: Calculation incorrect!
float getVoltage(uint16_t adcValue) {
	return VREF * ((float) adcValue) / ((2 ^ BITS) - 1);
}

void mainTask(void *parameters) {
	uint16_t voltage;

	for (;;) {
		voltage = getVoltage(ADC_readValue(0));
		printf("%dV\r\n", voltage);

		vTaskDelay(1000);
	}
}

void testTask1(void *parameters) {
	for (;;) {
		char buffer[3];

		fread(buffer, 3, 1, stdin);
		fwrite(buffer, 3, 1, stdout);

		// vTaskDelay(1000);
	}
}

void testTask2(void *parameters) {
	for (;;) {
		printf("testTask2\r\n");

		vTaskDelay(1000);
	}
}

int main(void) {
	// TODO: write chipInit() somewhere

	ADC_init();
	// SPI_initializeHardware();
	UART0_init();

	// assign our stream to standart I/O streams
	stdin  = &UART0_Stream;
	stdout = &UART0_Stream;
	stderr = &UART0_Stream;

	xTaskCreate(testTask1, "testTask1", stackSize, NULL, taskPriorityLow, NULL);
	xTaskCreate(testTask2, "testTask2", stackSize, NULL, taskPriorityLow, NULL);
	// xTaskCreate(mainTask, "main", stackSize, NULL, taskPriorityLow, NULL);

	vTaskStartScheduler();
}
