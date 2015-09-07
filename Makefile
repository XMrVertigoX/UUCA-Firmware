MCU    = atmega328p
TARGET = main
BINARY = Firmware

SOURCES = \
	$(wildcard FreeRTOS/Source/*.c) \
	$(wildcard FreeRTOS/Source/portable/MemMang/heap_3.c) \
	$(wildcard FreeRTOS/Source/portable/GCC/ATMega328P/*.c) \
	$(wildcard Drivers/*.c) \
	$(wildcard src/*.c) \
	$(wildcard src/drivers/*.c) \

OBJECTS = $(patsubst %.c, %.o, $(SOURCES))

INCLUDES = \
	-I FreeRTOS/Source/include \
	-I FreeRTOS/Source/portable/GCC/ATMega328P \
	-I Drivers/include \
	-I src/include \

SYMBOLS = \
	-D __ASSERT_USE_STDERR \
	# -D __AVR_ATmega328P__ \

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

size: $(BINARY).elf
	avr-size $(BINARY).elf

program: program_flash

program_flash: $(BINARY).hex
	avrdude -p $(MCU) $(ISP) -U flash:w:$(BINARY).hex:i

program_eeprom: $(BINARY)_eeprom.hex
	avrdude -p $(MCU) $(ISP) -U eeprom:w:$(BINARY)_eeprom.hex:i

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
