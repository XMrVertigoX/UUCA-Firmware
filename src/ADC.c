#include "ADC.h"

/*
 *  Setup ADC
 *
 * ADEN: Enable the ADC
 * ADPS2...0: Set the prescale factor for conversion to 64 (125kHz)
 */
void setupADCController() {
	ADCSRA |= (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);
}

/*
 * Setup conversion
 *
 * REFS0: Use AVCC as reference.
 */
void setupADCMultiplexer() {
	ADMUX |= (1 << REFS0);
}

/*
 * Set conversion channel
 */
void setChannel(uint8_t channel) {
	ADMUX |= channel;
}

/*
 * Reset ADC mux
 *
 * set MUX3...0 to zero
 */
void resetChannel() {
	ADMUX &= 0xF0;
}

/*
 * Start analog/digital conversion
 *
 * ADSC: Start conversion
 */
void startConversion() {
	ADCSRA |= (1 << ADSC);
}

/*
 * Check if channel number is valid
 *
 * 0...7: 10 bit ADC
 * 8: Temperature sensor
 * 8+: Invalid address
 */
bool channelValidity(uint8_t channel) {
	if (channel <= 8) {
		return true;
	} else {
		return false;
	}
}

/*
 * Check if the conversion has finished
 *
 * Returns true if conversion has finished
 */
bool conversionFinished() {
	return !(ADCSRA & (1 << ADSC));
}

void ADC_initializeHardware(void) {
	setupADCController();
	setupADCMultiplexer();
}

uint16_t ADC_readValue(uint8_t channel) {
	// Return impossible value if channel is invalid
	if (!channelValidity(channel)) {
		return 0xFC00;
	}

	setChannel(channel);
	startConversion();

	while (!conversionFinished())
		;

	resetChannel();

	return ADC;
}
