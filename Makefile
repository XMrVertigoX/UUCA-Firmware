BINDIR = _bin
OBJDIR = _obj

MKDIR = mkdir -p
RM = rm -rf

CC = avr-gcc

CFLAGS =
CPPFLAGS = -mmcu=$(MCU) -Os $(addprefix -D, $(SYMBOLS)) $(addprefix -I, $(INCLUDES))
CXXFLAGS = -fno-exceptions -std=c++11
LDFLAGS = -mmcu=$(MCU)

ISP = -cavrispmkII

MCU = atmega328p
TARGET = main
BINARY = UUCA-Firmware

INCLUDES += AVRCDrivers/include
INCLUDES += FreeRTOS/include
INCLUDES += FreeRTOS/portable/GCC/ATMega328P
INCLUDES += src/include

SYMBOLS += F_CPU=16000000
SYMBOLS += BAUD=9600
# SYMBOLS += __ASSERT_USE_STDERR
# SYMBOLS += NDEBUG

C_SOURCES += FreeRTOS/portable/MemMang/heap_3.c
C_SOURCES += FreeRTOS/portable/GCC/ATMega328P/port.c
C_SOURCES += FreeRTOS/list.c
# C_SOURCES += FreeRTOS/queue.c
C_SOURCES += FreeRTOS/tasks.c
C_SOURCES += AVRCDrivers/$(MCU)/adc.c
C_SOURCES += AVRCDrivers/$(MCU)/spi.c
C_SOURCES += AVRCDrivers/$(MCU)/uart.c
C_SOURCES += src/main.c

CXX_SOURCES += 

OBJECTS += $(addprefix $(OBJDIR)/, $(patsubst %.c, %.o, $(C_SOURCES)))
OBJECTS += $(addprefix $(OBJDIR)/, $(patsubst %.cpp, %.o, $(CXX_SOURCES)))

# ----- Rules ------------------------------------------------------------------

all: $(BINDIR)/$(BINARY).elf $(BINDIR)/$(BINARY).hex

clean:
	$(RM) $(OBJDIR)
	$(RM) $(BINDIR)

program: $(BINDIR)/$(BINARY).hex
	@avrdude -p$(MCU) $(ISP) -Uflash:w:$<:i

size: $(BINDIR)/$(BINARY).elf
	@avr-size $<

$(OBJDIR)/%.o: %.c
	@$(MKDIR) $(dir $@)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<

$(OBJDIR)/%.o: %.cpp
	@$(MKDIR) $(dir $@)
	$(CC) -c $(CPPFLAGS) $(CXXFLAGS) -o $@ $<

$(BINDIR)/$(BINARY).elf: $(OBJECTS)
	@$(MKDIR) $(dir $@)
	$(CC) $(CPPFLAGS) $(LDFLAGS) -o $@ $^

$(BINDIR)/$(BINARY).hex: $(BINDIR)/$(BINARY).elf
	@$(MKDIR) $(dir $@)
	avr-objcopy -j .text -j .data -O ihex $< $@
