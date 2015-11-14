TOOLCHAIN_PREFIX = avr-

# ----- Rules ------------------------------------------------------------------

.PHONY: program

$(BINDIR)/%.hex: $(BINDIR)/%.elf
	$(MKDIR) $(dir $@)
	$(OBJCOPY) -j .text -j .data -O ihex $< $@

program: $(BINDIR)/$(NAME).hex
	avrdude -p $(MCU) -c $(ISP) -U flash:w:$<:i
