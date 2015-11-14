CFLAGS =
CPPFLAGS = -O0
CXXFLAGS = -std=c++11
LDFLAGS =

ISP = avrispmkII

MCU = atmega328p
NAME = firmware

INCLUDES += AVRCDrivers/include
INCLUDES += FreeRTOS/Source/include
INCLUDES += FreeRTOS/Source/portable/GCC/ATMega328P
INCLUDES += src/include

SYMBOLS += F_CPU=16000000
SYMBOLS += BAUD=9600
# SYMBOLS += __ASSERT_USE_STDERR
# SYMBOLS += NDEBUG

SOURCES += FreeRTOS/Source/portable/MemMang/heap_3.c
SOURCES += FreeRTOS/Source/portable/GCC/ATMega328P/port.c
SOURCES += FreeRTOS/Source/list.c
# SOURCES += FreeRTOS/Source/queue.c
SOURCES += FreeRTOS/Source/tasks.c
SOURCES += AVRCDrivers/$(MCU)/adc.c
SOURCES += AVRCDrivers/$(MCU)/spi.c
SOURCES += AVRCDrivers/$(MCU)/uart.c
SOURCES += src/main.c

include common.mk
include avr.mk
