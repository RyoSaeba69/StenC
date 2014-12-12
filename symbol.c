#include "symbol.h"
#include "stdio.h"
#include "stdlib.h"

symbol* symbol_gen(char* identifier, bool isconstant, int value){

	symbol* new_symbol = malloc(sizeof(symbol));

	new_symbol->identifier = identifier;
	new_symbol->isconstant = isconstant;
	new_symbol->value = value;
	new_symbol->next = NULL;

	return new_symbol;
}

symbol* symbol_add(char* identifier, bool isconstant, int value, symbol** symbol_list){
	symbol* new_symbol = symbol_gen(identifier, isconstant, value);

	if(*symbol_list == NULL){
		*symbol_list = new_symbol;
	} else {
		symbol* list = *symbol_list;

		while(list->next != NULL){
			list = list->next;
		}
		list->next = new_symbol;
	}

	return new_symbol;
}


void symbol_print(symbol* symbol_list){
	printf("=== Symbol list ==== \n");
	while(symbol_list != NULL){
		printf("Symbol list : identifier: %s || value : %d \n", symbol_list->identifier, symbol_list->value);
		symbol_list = symbol_list->next;
	}
	printf("=== End Symbol list ===\n");
}
