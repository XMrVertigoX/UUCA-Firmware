MCU    = atmega328p
TARGET = main
BINARY = Firmware

SOURCES += FreeRTOS/portable/MemMang/heap_3.c
SOURCES += FreeRTOS/portable/GCC/ATMega328P/port.c
SOURCES += FreeRTOS/list.c
# SOURCES += FreeRTOS/queue.c
SOURCES += FreeRTOS/tasks.c
SOURCES += Drivers/$(MCU)/adc.c
SOURCES += Drivers/$(MCU)/spi.c
SOURCES += Drivers/$(MCU)/uart.c
SOURCES += src/main.c

INCLUDES += FreeRTOS/include
INCLUDES += FreeRTOS/portable/GCC/ATMega328P
INCLUDES += Drivers/include
INCLUDES += src/include

SYMBOLS += F_CPU=16000000
SYMBOLS += BAUD=9600
# SYMBOLS += __ASSERT_USE_STDERR
# SYMBOLS += NDEBUG
# SYMBOLS += __AVR_ATmega328P__

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

program: program_flash

program_flash: $(BINARY).hex
	avrdude -p $(MCU) $(ISP) -U flash:w:$<:i

program_eeprom: $(BINARY)_eeprom.hex
	avrdude -p $(MCU) $(ISP) -U eeprom:w:$<:i

size: $(BINARY).elf
	avr-size $<

clean:
	$(RM) *.elf *.hex $(OBJECTS)

%.o: %.c
	$(MKDIR) $(OBJDIR)
	$(CC) $(CFLAGS) -o $@ $<

$(BINARY).elf: $(OBJECTS)
	$(MKDIR) $(BINDIR)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

$(BINARY).hex: $(BINARY).elf
	$(MKDIR) $(BINDIR)
	avr-objcopy -j .text -j .data -O ihex $< $@

$(BINARY)_eeprom.hex: $(BINARY).elf
	$(MKDIR) $(BINDIR)
	avr-objcopy -j .eeprom --change-section-lma .eeprom=0 -O ihex $< $@
