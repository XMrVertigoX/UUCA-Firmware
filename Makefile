# Directories
SDIR = src

# Fuse configuration
EFUSE = 0x05
HFUSE = 0xDE
LFUSE = 0xFF

# MCU parameters
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

PROGRAMMER = usbtiny


# ----- Rules ------------------------------------------------------------------

all: hex

hex: $(TARGET).hex

eeprom: $(TARGET).eep

$(TARGET).hex: $(TARGET).elf
	avr-objcopy -j .text -j .data -O ihex $(TARGET).elf $(TARGET).hex

$(TARGET).eep: $(TARGET).elf
	avr-objcopy -j .eeprom --change-section-lma .eeprom=0 -O ihex $(TARGET).elf $(TARGET).eep

$(TARGET).elf: $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $(TARGET).elf

%.o: %.c
	$(CC) $(CFLAGS) -o $@ $<

size:
	avr-size --mcu=$(MCU) -C$(TARGET).elf

program: program_flash

program_flash:
	avrdude -p$(MCU) -c$(PROGRAMMER) -Uflash:w:$(TARGET).hex:a

program_eeprom:
	avrdude -p$(MCU) -c$(PROGRAMMER) -Ueeprom:w:$(TARGET).eep:a

program_fuse:
	avrdude -p$(MCU) -c$(PROGRAMMER) -Uefuse:w:$(EFUSE):m -Uhfuse:w:$(HFUSE):m -Ulfuse:w:$(LFUSE):m

program_diamax:
	avrdude -p$(MCU) -cstk500 -P /dev/ttyACM0 -U flash:w:$(TARGET).hex:a

clean:
	rm -rf $(OBJECTS)
	rm -rf *.eep
	rm -rf *.elf
	rm -rf *.hex
