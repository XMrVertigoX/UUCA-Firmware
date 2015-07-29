TARGET = UUCA-Firmware
MCU = atmega328p
SOURCES = src/UUCA-Firmware.c src/ADC.c src/SPI.c src/Serial.c

PROGRAMMER = usbtiny
#PORT = -P /dev/ttyACM0
#BAUD = -B 115200

F_CPU = 16000000

#Ab hier nichts verändern
OBJECTS = $(SOURCES:.c=.o)
CFLAGS = -c -Os -D F_CPU=$(F_CPU)
LDFLAGS =

all: hex eeprom

hex: $(TARGET).hex

eeprom: $(TARGET)_eeprom.hex

$(TARGET).hex: $(TARGET).elf
	avr-objcopy -O ihex -j .data -j .text $(TARGET).elf $(TARGET).hex

$(TARGET)_eeprom.hex: $(TARGET).elf
	avr-objcopy -O ihex -j .eeprom --change-section-lma .eeprom=1 $(TARGET).elf $(TARGET)_eeprom.hex

$(TARGET).elf: $(OBJECTS)
	avr-gcc $(LDFLAGS) $(OBJECTS) -o $(TARGET).elf

.c.o:
	avr-gcc $(CFLAGS) -mmcu=$(MCU) $< -o $@

size:
	avr-size --mcu=$(MCU) -C $(TARGET).elf

program:
	avrdude -p $(MCU) $(PORT) $(BAUD) -c $(PROGRAMMER) -U flash:w:$(TARGET).hex:a

clean_tmp:
	rm -rf *.o
	rm -rf *.elf

clean:
	rm -rf *.o
	rm -rf *.elf
	rm -rf *.hex