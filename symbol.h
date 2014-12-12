#ifndef SYMBOL_H
#define SYMBOL_H

#include <stdbool.h>

typedef struct symbol {
	char* identifier;
	bool isconstant;
	int value;
	struct symbol* next;
} symbol;

symbol* symbol_gen(char* identifier, bool isconstant, int value);
//symbol* symbol_add_or_edit(symbol** symbols_list, char* identifier, bool isconstant, int value);
symbol* find_symbol(symbol* symbols_list, char* identifier);
symbol* symbol_add(symbol** symbol_list, char* identifier, bool isconstant, int value);
//symbol* symbol_lookup(char* identifier, symbol* symbol_list);
void symbol_print(symbol* symbol_list);

#endif
