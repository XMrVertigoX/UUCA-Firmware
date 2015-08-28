MCU    = atmega328p
TARGET = main

BINARY = Firmware.elf

# Macros
F_CPU = 16000000
IO_SELECT  = __AVR_ATmega328P__

SOURCES  = $(wildcard src/*.c)
SOURCES += $(wildcard src/drivers/*.c)
SOURCES += $(wildcard FreeRTOS/*.c)
SOURCES += $(wildcard FreeRTOS/portable/MemMang/*.c)
SOURCES += $(wildcard FreeRTOS/portable/GCC/ATMega328P/*.c)

OBJECTS = $(patsubst %.c, %.o, $(SOURCES))

INCLUDES  = -I src/include
INCLUDES += -I FreeRTOS/include
INCLUDES += -I FreeRTOS/portable/GCC/ATMega328P

CC      = avr-gcc
CFLAGS  = -c -Os -DF_CPU=$(F_CPU) -D$(IO_SELECT) -mmcu=$(MCU) $(INCLUDES)
LDFLAGS = -mmcu=$(MCU)

# AVR-ISPs
USBTINY = -c usbtiny
DIAMEX  = -c stk500 -P /dev/ttyACM0

ISP = $(USBTINY)


# ----- Rules ------------------------------------------------------------------

all: $(BINARY)

$(BINARY): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $(BINARY)

%.o: %.c
	$(CC) $(CFLAGS) -o $@ $<

program: program_flash program_eeprom program_fuses

program_flash: $(BINARY)
	avrdude -p$(MCU) $(ISP) -Uflash:w:$(BINARY)

program_eeprom: $(BINARY)
	avrdude -p$(MCU) $(ISP) -Ueeprom:w:$(BINARY)

program_fuses: $(BINARY)
	avrdude -p$(MCU) $(ISP) -Ulfuse:w:$(BINARY) -Uhfuse:w:$(BINARY) -Uefuse:w:$(BINARY)

size: $(BINARY)
	avr-size $(BINARY)

clean:
	rm -rf $(BINARY) $(OBJECTS)
	
