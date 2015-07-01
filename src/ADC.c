#include "ADC.h"

/*
 * ADC.c
 *
 * Created on: Apr 15, 2015
 * Author: Caspar Friedrich
 */

void setupADCController() {
	/* Setup ADC.
	 * ADEN: Enable the ADC
	 * ADPS2...0: Set the prescale factor for conversion to 64 (125kHz) */
	ADCSRA |= (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);
}

void setupADCMultiplexer() {
	/* Setup conversion.
	 * REFS0: Use AVCC as reference. */
	ADMUX |= (1 << REFS0);
}

void setChannel(uint8_t channel) {
	ADMUX |= channel;
}

void resetChannel() {
	// Reset ADC mux (set MUX3...0 to zero)
	ADMUX &= 0xF0;
}

void startConversion() {
	// Start the conversion
	ADCSRA |= (1 << ADSC);
}

bool channelValidity(uint8_t channel) {
	if (channel < 8) {
		return true;
	} else {
		return false;
	}
}

bool conversionFinished() {
	return !(ADCSRA & (1 << ADSC));
}

void ADC_initializeHardware(void) {
	setupADCController();
	setupADCMultiplexer();
}

uint16_t ADC_readValue(uint8_t channel) {
	// Check if channel value is valid
	if (!channelValidity(channel)) {
		return 0xFC00;
	}

	setChannel(channel);

	startConversion();

	// Wait for conversion to finish
	wait(conversionFinished());

	resetChannel();

	// Return ADC value register
	return ADC;
}
