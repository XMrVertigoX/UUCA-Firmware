// Standard libraries
#include <stdint.h>
#include <stdio.h>

// AVR related libraries
#include <avr/eeprom.h>
#include <avr/io.h>

// FreeRTOS libraries
#include <FreeRTOS.h>
#include <task.h>

// Driver libraries
#include <adc.h>
#include <spi.h>
#include <usart.h>

#define taskPriority (tskIDLE_PRIORITY + 1)

// ADC reference values
#define VREF (5)
#define BITS (10)

// Factory fuse settings
// FUSES = {
//     .low      = 0x62,
//     .high     = 0xD9,
//     .extended = 0xFF,
// };

// Default charger settings for eeprom
// uint8_t foo EEMEM = 0;

// set stream pointer
FILE USART0_Stream = FDEV_SETUP_STREAM(USART0_sendByte, USART0_receiveByte,
                                       _FDEV_SETUP_RW);

// TODO: Calculation incorrect or incompatible!
// float getVoltage(long adcValue) {
//     long adc = VREF * (adcValue / 1024);
//     return (float) (adc * VREF);
// }

static uint32_t msToTicks(uint32_t ms) {
    return (ms/(1000/configTICK_RATE_HZ));
}

void mainTask(void *parameters) {
    long voltage;

    for (;;) {
        voltage = ADC_readValue(0);
        printf("%ld\r\n", voltage);

        vTaskDelay(msToTicks(1000));
    }
}

void testTask(void *parameters) {
    for (;;) {
        uint8_t buffer[3];

        fread(buffer, 1, sizeof(buffer), stdin);
        fwrite(buffer, 1, sizeof(buffer), stdout);
    }
}

int main(void) {
    ADC_init();
    SPI_init();
    USART0_init();

    // assign our stream to standard I/O streams
    stdin  = &USART0_Stream;
    stdout = &USART0_Stream;
    stderr = &USART0_Stream;

    xTaskCreate(testTask, "testTask", configMINIMAL_STACK_SIZE, NULL,
				taskPriority, NULL);
    xTaskCreate(mainTask, "main", configMINIMAL_STACK_SIZE, NULL,
				taskPriority, NULL);

    vTaskStartScheduler();
}
