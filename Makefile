MCU    = atmega328p
TARGET = main
BINARY = Firmware

SOURCES  = $(wildcard FreeRTOS/Source/*.c)
SOURCES += $(wildcard FreeRTOS/Source/portable/MemMang/heap_3.c)
SOURCES += $(wildcard FreeRTOS/Source/portable/GCC/ATMega328P/*.c)
SOURCES += $(wildcard Drivers/*.c)
SOURCES += $(wildcard src/*.c)
SOURCES += $(wildcard src/drivers/*.c)

OBJECTS = $(patsubst %.c, %.o, $(SOURCES))

INCLUDES  = -I FreeRTOS/Source/include
INCLUDES += -I FreeRTOS/Source/portable/GCC/ATMega328P
INCLUDES += -I Drivers/include
INCLUDES += -I src/include

SYMBOLS  = -D F_CPU=16000000
SYMBOLS += -D __AVR_ATmega328P__

CC      = avr-gcc
CFLAGS  = -c -Os -mmcu=$(MCU) $(SYMBOLS) $(INCLUDES)
LDFLAGS = -mmcu=$(MCU)

# AVR-ISPs
AVRISPmkII = -c avrispmkII
DIAMEX     = -c stk500 -P /dev/ttyACM0
USBTINY    = -c usbtiny

ISP = $(AVRISPmkII)

# ----- Rules ------------------------------------------------------------------

all: $(BINARY).elf $(BINARY).hex $(BINARY)_eeprom.hex

program: program_flash program_eeprom

program_flash: $(BINARY).hex
	avrdude -p $(MCU) $(ISP) -U flash:w:$(BINARY).hex:i

program_eeprom: $(BINARY)_eeprom.hex
	avrdude -p $(MCU) $(ISP) -U eeprom:w:$(BINARY)_eeprom.hex:i

size: $(BINARY).elf
	avr-size $(BINARY).elf

clean:
	rm -rf *.elf *.hex $(OBJECTS)

%.o: %.c
	$(CC) $(CFLAGS) -o $@ $<

$(BINARY).elf: $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $(BINARY).elf

$(BINARY).hex: $(BINARY).elf
	avr-objcopy -j .text -j .data -O ihex $(BINARY).elf $(BINARY).hex

$(BINARY)_eeprom.hex: $(BINARY).elf
	avr-objcopy -j .eeprom --change-section-lma .eeprom=0 -O ihex $(BINARY).elf $(BINARY)_eeprom.hex
