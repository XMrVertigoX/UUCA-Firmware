# Directories
BDIR = bin
SDIR = src

# MCU parameter
MCU   = atmega328p
F_CPU = 16000000

# Default Arduino fuse configuration
EFUSE = 0x05
HFUSE = 0xDE
LFUSE = 0xFF

TARGET  = Firmware
SOURCES = $(wildcard $(SDIR)/*.c)
OBJECTS = $(patsubst %.c, %.o, $(SOURCES))

CC      = avr-gcc
CFLAGS  = -c -Os -DF_CPU=$(F_CPU) -I$(SDIR)/include
LDFLAGS = 

PROGRAMMER = usbtiny

# ----- Rules ------------------------------------------------------------------

all: hex eeprom

hex: $(TARGET).hex

eeprom: $(TARGET)_eeprom.hex

$(TARGET).hex: $(TARGET).elf
	avr-objcopy -j .text -j .data -O ihex $(BDIR)/$(TARGET).elf $(BDIR)/$(TARGET).hex

$(TARGET)_eeprom.hex: $(TARGET).elf
	avr-objcopy -j .eeprom --change-section-lma .eeprom=0 -O ihex $(BDIR)/$(TARGET).elf $(BDIR)/$(TARGET)_eeprom.hex

$(TARGET).elf: $(OBJECTS)
	$(CC) $(LDFLAGS) -mmcu=$(MCU) $(OBJECTS) -o $(BDIR)/$(TARGET).elf

%.o: %.c
	$(CC) $(CFLAGS) -mmcu=$(MCU) -o $@ $<

size:
	avr-size --mcu=$(MCU) -C $(BDIR)/$(TARGET).elf

program:
	avrdude -p $(MCU) -c $(PROGRAMMER) -U flash:w:$(BDIR)/$(TARGET).hex:a

program_fuse:
	avrdude -p $(MCU) -c $(PROGRAMMER) -U efuse:w:$(EFUSE):m -U hfuse:w:$(HFUSE):m -U lfuse:w:$(LFUSE):m

program_diamax:
	avrdude -p $(MCU) -c stk500 -P /dev/ttyACM0 -U flash:w:$(BDIR)/$(TARGET).hex:a

clean:
	rm -rf $(SDIR)/*.o
	rm -rf $(BDIR)/*.elf
	rm -rf $(BDIR)/*.hex
