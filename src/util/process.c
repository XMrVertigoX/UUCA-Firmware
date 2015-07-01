#include "process.h"

/*
 * utilities.c
 *
 * Created on: 25 Jun 2015
 * Author: Caspar Friedrich
 */

void wait(bool wakeupCondition) {
	while (!wakeupCondition)
		;
}
