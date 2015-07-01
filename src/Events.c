#include "Events.h"

/*
 * Events.c
 *
 * Created on: Apr 15, 2015
 * Author: Caspar Friedrich
 */

#include <avr/io.h>
#include <avr/interrupt.h>

void Events_initializeHardware(void) {
	// Turn on the Pull-up
	PORTD |= (1 << PORTD2);

	// Turn on interrupt(s)
	EIMSK |= (1 << INT0);
}

ISR (INT0_vect) {
	/* interrupt code here */
}
