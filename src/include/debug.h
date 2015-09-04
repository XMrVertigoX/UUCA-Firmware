#ifndef DEBUG_H_
#define DEBUG_H_

#include <assert.h>

#include <Serial.h>

void __assert(const char *__func, const char *__file, int __lineno,
		const char *__sexp);

#endif
