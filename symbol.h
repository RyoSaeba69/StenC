#ifndef SYMBOL_H
#define SYMBOL_H

#include <stdbool.h>

typedef struct symbol {
	char* identifier;
	bool isconstant;
	int value;
	struct symbol *next;
} symbol;

symbol* symbol_gen(char* identifier, bool isconstant, int value);
symbol* symbol_add(char* identifier, bool isconstant, int value, symbol** symbol_list);
symbol* symbol_lookup(char* identifier, symbol* symbol_list);
void symbol_print(symbol* symbol_list);

#endif
