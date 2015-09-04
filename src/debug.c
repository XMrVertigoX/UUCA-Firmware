#include <debug.h>

void __assert(const char *__func, const char *__file, int __lineno,
		const char *__sexp) {

	Serial_printAndReturn(__func);
	Serial_printAndReturn(__file);
	Serial_printIntegerAndReturn(__lineno, DEC);
	Serial_printAndReturn(__sexp);
	// abort program execution.
	//abort();
}
