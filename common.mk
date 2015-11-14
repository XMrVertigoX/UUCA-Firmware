BINDIR = _bin
OBJDIR = _obj

override CC = $(TOOLCHAIN_PREFIX)gcc
override OBJCOPY = $(TOOLCHAIN_PREFIX)objcopy
override SIZE = $(TOOLCHAIN_PREFIX)size

override MKDIR = mkdir -p
override RM = rm -rf

override CPPFLAGS += -mmcu=$(MCU) $(addprefix -D, $(SYMBOLS)) $(addprefix -I, $(INCLUDES))
override CXXFLAGS += -fno-exceptions

OBJECTS = $(addprefix $(OBJDIR)/, $(addsuffix .o, $(basename $(SOURCES))))

# ----- Rules ------------------------------------------------------------------

.PHONY: all clean size

.PRECIOUS: $(OBJECTS)

all: $(BINDIR)/$(NAME).elf

clean:
	$(RM) $(BINDIR)
	$(RM) $(OBJDIR)

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
