#include <ADC.h>

static void setupADCController() {

	/*
	 * ADEN: Enable the ADC
	 * ADPS2...0: Set the prescale factor for conversion to 64 (125kHz)
	 */
	ADCSRA |= (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);
}

static void setupADCMultiplexer() {

	/*
	 * REFS0: Use AVCC as reference.
	 */
	ADMUX |= (1 << REFS0);
}

static void setChannel(uint8_t channel) {

	/*
	 * Set conversion channel
	 */
	ADMUX |= channel;
}

static void resetChannel() {

	/*
	 * set MUX3...0 to zero
	 */
	ADMUX &= 0xF0;
}

static void startConversion() {

	/*
	 * ADSC: Start conversion
	 */
	ADCSRA |= (1 << ADSC);
}

static bool channelValidity(uint8_t channel) {

	/*
	 * 0...7: 10 bit ADC
	 * 8: Temperature sensor
	 * 8+: Invalid address
	 */
	if (channel <= 8) {
		return true;
	} else {
		return false;
	}
}

static bool conversionFinished() {
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
