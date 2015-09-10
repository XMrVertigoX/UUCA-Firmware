MCU    = atmega328p
TARGET = main
BINARY = Firmware

SOURCES += FreeRTOS/portable/MemMang/heap_3.c
SOURCES += FreeRTOS/portable/GCC/ATMega328P/port.c
SOURCES += FreeRTOS/list.c
# SOURCES += FreeRTOS/queue.c
SOURCES += FreeRTOS/tasks.c
SOURCES += Drivers/ADC_$(MCU).c
# SOURCES += Drivers/SPI_$(MCU).c
SOURCES += Drivers/USART_$(MCU).c
SOURCES += src/main.c

INCLUDES += FreeRTOS/include
INCLUDES += FreeRTOS/portable/GCC/ATMega328P
INCLUDES += Drivers/include
INCLUDES += src/include

SYMBOLS += F_CPU=16000000
SYMBOLS += BAUD=9600
# SYMBOLS += __ASSERT_USE_STDERR
# SYMBOLS += __AVR_ATmega328P__
# SYMBOLS += NDEBUG

OBJECTS = $(patsubst %.c, %.o, $(SOURCES))

CC      = avr-gcc
CFLAGS  = -c -Os -mmcu=$(MCU) $(addprefix -D ,$(SYMBOLS)) $(addprefix -I ,$(INCLUDES))
LDFLAGS = -mmcu=$(MCU)

# AVR-ISPs
AVRISPmkII = -c avrispmkII
DIAMEX     = -c stk500 -P /dev/ttyACM0
USBTINY    = -c usbtiny

ISP = $(AVRISPmkII)

# ----- Rules ------------------------------------------------------------------

all: $(BINARY).elf

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
