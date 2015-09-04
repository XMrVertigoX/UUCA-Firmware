MCU    = atmega328p
TARGET = main

SOURCES  = $(wildcard Drivers/*.c)
SOURCES += $(wildcard FreeRTOS/*.c)
SOURCES += $(wildcard FreeRTOS/portable/MemMang/*.c)
SOURCES += $(wildcard FreeRTOS/portable/GCC/ATMega328P/*.c)
SOURCES += $(wildcard src/*.c)
SOURCES += $(wildcard src/drivers/*.c)

OBJECTS = $(patsubst %.c, %.o, $(SOURCES))

INCLUDES  = -I Drivers/include
INCLUDES += -I FreeRTOS/include
INCLUDES += -I FreeRTOS/portable/GCC/ATMega328P
INCLUDES += -I src/include

MACROS  = -D F_CPU=16000000
MACROS += -D __AVR_ATmega328P__

CC      = avr-gcc
CFLAGS  = -c -Os -mmcu=$(MCU) $(MACROS) $(INCLUDES)
LDFLAGS = -mmcu=$(MCU)

BINARY = Firmware.elf

# AVR-ISPs
AVRISPmkII = -c avrispmkII
DIAMEX  = -c stk500 -P /dev/ttyACM0
USBTINY = -c usbtiny

ISP = $(AVRISPmkII)


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
