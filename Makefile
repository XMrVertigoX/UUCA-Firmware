# Directories
SDIR = src

MCU    = atmega328p
TARGET = UUCA-Firmware

# Macros
F_CPU = 16000000
IO_SELECT  = __AVR_ATmega328P__

SOURCES  = $(wildcard $(SDIR)/*.c)
SOURCES += $(wildcard $(SDIR)/drivers/*.c)

OBJECTS = $(patsubst %.c, %.o, $(SOURCES))

INCLUDES = -I$(SDIR)/include

CC      = avr-gcc
CFLAGS  = -c -Os -DF_CPU=$(F_CPU) -D$(IO_SELECT) -mmcu=$(MCU) $(INCLUDES)
LDFLAGS = -mmcu=$(MCU)

# Fuse configuration
LFUSE = 0xFF
HFUSE = 0xD9
EFUSE = 0xFC

PROGRAMMER = usbtiny


# ----- Rules ------------------------------------------------------------------

all: hex eeprom

hex: $(TARGET).hex

eeprom: $(TARGET)_eeprom.hex

$(TARGET).hex: $(TARGET).elf
	avr-objcopy -j .text -j .data -O ihex $(TARGET).elf $(TARGET).hex

$(TARGET)_eeprom.hex: $(TARGET).elf
	avr-objcopy -j .eeprom --change-section-lma .eeprom=0 -O ihex $(TARGET).elf $(TARGET)_eeprom.hex

$(TARGET).elf: $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $(TARGET).elf

%.o: %.c
	$(CC) $(CFLAGS) -o $@ $<

program: program_flash

program_flash:
	avrdude -p$(MCU) -c$(PROGRAMMER) -Uflash:w:$(TARGET).hex:a

program_eeprom:
	avrdude -p$(MCU) -c$(PROGRAMMER) -Ueeprom:w:$(TARGET)_eeprom.hex:a

program_fuse:
	avrdude -p$(MCU) -c$(PROGRAMMER) -Ulfuse:w:$(LFUSE):m -Uhfuse:w:$(HFUSE):m -Uefuse:w:$(EFUSE):m

program_diamax:
	avrdude -p$(MCU) -cstk500 -P /dev/ttyACM0 -U flash:w:$(TARGET).hex:a

size:
	avr-size $(TARGET).elf

clean:
	rm -rf $(OBJECTS)
	rm -rf *_eeprom.hex
	rm -rf *.elf
	rm -rf *.hex
