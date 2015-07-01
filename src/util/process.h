/*
 * utilities.h
 *
 * Created on: 25 Jun 2015
 * Author: Caspar Friedrich
 */

#ifndef UTIL_PROCESS_H_
#define UTIL_PROCESS_H_

#include <stdbool.h>

/*
 * Invoke an empty loop until condition is true
 */
void wait(bool wakeupCondition);

#endif /* UTIL_PROCESS_H_ */
