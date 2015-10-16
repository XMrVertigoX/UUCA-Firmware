BINDIR = _bin
OBJDIR = _obj

MCU    = atmega328p
TARGET = main
BINARY = UUCA-Firmware

INCLUDES += FreeRTOS/include
INCLUDES += FreeRTOS/portable/GCC/ATMega328P
INCLUDES += Drivers/include
INCLUDES += src/include

SYMBOLS += F_CPU=16000000
SYMBOLS += F_SCL=400000
SYMBOLS += BAUD=9600
SYMBOLS += __ASSERT_USE_STDERR
# SYMBOLS += NDEBUG

SOURCES += FreeRTOS/portable/MemMang/heap_3.c
SOURCES += FreeRTOS/portable/GCC/ATMega328P/port.c
SOURCES += FreeRTOS/list.c
# SOURCES += FreeRTOS/queue.c
SOURCES += FreeRTOS/tasks.c
SOURCES += Drivers/$(MCU)/adc.c
SOURCES += Drivers/$(MCU)/spi.c
SOURCES += Drivers/$(MCU)/uart.c
SOURCES += src/main.c

OBJECTS = $(addprefix $(OBJDIR)/, $(patsubst %.c, %.o, $(SOURCES)))

CC      = avr-gcc
CFLAGS  = -c -Os -mmcu=$(MCU) $(addprefix -D ,$(SYMBOLS)) $(addprefix -I ,$(INCLUDES))
LDFLAGS = -mmcu=$(MCU)

MKDIR = mkdir -p
RM    = rm -rf

ISP = -cavrispmkII

# ----- Rules ------------------------------------------------------------------

all: $(BINDIR)/$(BINARY).elf $(BINDIR)/$(BINARY).hex

program: $(BINDIR)/$(BINARY).hex
	avrdude -p$(MCU) $(ISP) -Uflash:w:$<:i

size: $(BINDIR)/$(BINARY).elf
	avr-size $<

clean:
	$(RM) $(OBJDIR)
	$(RM) $(BINDIR)

$(BINDIR)/$(BINARY).elf: $(OBJECTS)
	@$(MKDIR) $(dir $@)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

$(OBJDIR)/%.o: %.c
	@$(MKDIR) $(dir $@)
	$(CC) $(CFLAGS) -o $@ $<

$(BINDIR)/$(BINARY).hex: $(BINDIR)/$(BINARY).elf
	@$(MKDIR) $(BINDIR)
	avr-objcopy -j .text -j .data -O ihex $< $@
