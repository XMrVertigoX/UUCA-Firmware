CFLAGS =
CPPFLAGS = -O0
CXXFLAGS = -std=c++11
LDFLAGS =

ISP = avrispmkII

MCU = atmega328p
NAME = UUCA-Firmware

INCLUDES += AVRCDrivers/include
INCLUDES += FreeRTOS/include
INCLUDES += FreeRTOS/portable/GCC/ATMega328P
INCLUDES += src/include

SYMBOLS += F_CPU=16000000
SYMBOLS += BAUD=9600
# SYMBOLS += __ASSERT_USE_STDERR
# SYMBOLS += NDEBUG

SOURCES += FreeRTOS/portable/MemMang/heap_3.c
SOURCES += FreeRTOS/portable/GCC/ATMega328P/port.c
SOURCES += FreeRTOS/list.c
# SOURCES += FreeRTOS/queue.c
SOURCES += FreeRTOS/tasks.c
SOURCES += AVRCDrivers/$(MCU)/adc.c
SOURCES += AVRCDrivers/$(MCU)/spi.c
SOURCES += AVRCDrivers/$(MCU)/uart.c
SOURCES += src/main.c

include common.mk
include avr.mk
