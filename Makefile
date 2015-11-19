TOOLCHAIN_PREFIX = avr-

CC = $(TOOLCHAIN_PREFIX)gcc
OBJCOPY = $(TOOLCHAIN_PREFIX)objcopy
SIZE = $(TOOLCHAIN_PREFIX)size
MKDIR = mkdir -p
RM = rm -rf

BINDIR = _bin
OBJDIR = _obj

ISP = avrispmkII

MCU = atmega328p
NAME = firmware

INCLUDES += AVRCDrivers/include
INCLUDES += FreeRTOS/Source/include
INCLUDES += FreeRTOS/Source/portable/GCC/ATMega328P
INCLUDES += src/include

SOURCES += FreeRTOS/Source/portable/MemMang/heap_3.c
SOURCES += FreeRTOS/Source/portable/GCC/ATMega328P/port.c
SOURCES += FreeRTOS/Source/list.c
# SOURCES += FreeRTOS/Source/queue.c
SOURCES += FreeRTOS/Source/tasks.c
SOURCES += AVRCDrivers/$(MCU)/adc.c
SOURCES += AVRCDrivers/$(MCU)/spi.c
SOURCES += AVRCDrivers/$(MCU)/uart.c
SOURCES += src/main.c

SYMBOLS += F_CPU=16000000
SYMBOLS += BAUD=9600
# SYMBOLS += __ASSERT_USE_STDERR
# SYMBOLS += NDEBUG

CFLAGS =
CPPFLAGS = -mmcu=$(MCU) $(addprefix -D, $(SYMBOLS)) $(addprefix -I, $(INCLUDES)) -O3
CXXFLAGS = -fno-exceptions
LDFLAGS =

OBJECTS = $(addprefix $(OBJDIR)/, $(addsuffix .o, $(basename $(SOURCES))))

# ----- Rules ------------------------------------------------------------------

.PHONY: all clean program size

.PRECIOUS: $(OBJECTS)

all: $(BINDIR)/$(NAME).elf

clean:
	$(RM) $(BINDIR)
	$(RM) $(OBJDIR)

program: $(BINDIR)/$(NAME).hex
	avrdude -p $(MCU) -c $(ISP) -U flash:w:$<:i

size: $(BINDIR)/$(NAME).elf
	$(SIZE) $<

$(OBJDIR)/%.o: %.c
	$(MKDIR) $(dir $@)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<

$(OBJDIR)/%.o: %.cpp
	$(MKDIR) $(dir $@)
	$(CC) -c $(CPPFLAGS) $(CXXFLAGS) -o $@ $<

$(BINDIR)/%.elf: $(OBJECTS)
	$(MKDIR) $(dir $@)
	$(CC) $(CPPFLAGS) $(LDFLAGS) -o $@ $^

$(BINDIR)/%.hex: $(BINDIR)/%.elf
	$(MKDIR) $(dir $@)
	$(OBJCOPY) -j .text -j .data -O ihex $< $@
