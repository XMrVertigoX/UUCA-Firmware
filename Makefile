BDIR = bin
SDIR = src

MCU = atmega328p
F_CPU = 16000000

TARGET = Firmware
SOURCES = $(wildcard $(SDIR)/*.c)
OBJECTS = $(patsubst %.c, %.o, $(SOURCES))

CC = avr-gcc
CFLAGS = -c -Os -DF_CPU=$(F_CPU)

PROGRAMMER = usbtiny

all: hex eeprom

hex: $(TARGET).hex

eeprom: $(TARGET)_eeprom.hex

$(TARGET).hex: $(TARGET).elf
	avr-objcopy -j .text -j .data -O ihex $(BDIR)/$(TARGET).elf $(BDIR)/$(TARGET).hex

$(TARGET)_eeprom.hex: $(TARGET).elf
	avr-objcopy -j .eeprom --change-section-lma .eeprom=0 -O ihex $(BDIR)/$(TARGET).elf $(BDIR)/$(TARGET)_eeprom.hex

$(TARGET).elf: $(OBJECTS)
	$(CC) $(OBJECTS) -o $(BDIR)/$(TARGET).elf

%.o: %.c
	$(CC) $(CFLAGS) -mmcu=$(MCU) -o $@ $<

size:
	avr-size --mcu=$(MCU) -C $(BDIR)/$(TARGET).elf

program:
	avrdude -p $(MCU) -c $(PROGRAMMER) -U flash:w:$(BDIR)/$(TARGET).hex:a

program_diamax:
	avrdude -p $(MCU) -c stk200 -P /dev/ttyACM0 -U flash:w:$(BDIR)/$(TARGET).hex:a

clean:
	rm -f $(SDIR)/*.o
	rm -f $(BDIR)/*.elf
	rm -f $(BDIR)/*.hex
