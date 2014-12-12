#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol.h"

symbol* symbol_gen(char* identifier, bool isconstant, int value){

	static int next_tmp = 0;

	symbol* new_symbol = malloc(sizeof(symbol));

	if(identifier == NULL){
		// 100 is the maximum length of a temp
		char tmp_name[100] = "temp_";
		char str_number[95];
		sprintf(str_number, "%d", next_tmp);
		strcat(tmp_name, str_number);
		new_symbol->identifier = strdup(tmp_name);
		next_tmp++;
	} else {
		new_symbol->identifier = strdup(identifier);
	}
	new_symbol->isconstant = isconstant;
	new_symbol->value = value;
	new_symbol->next = NULL;

	return new_symbol;
}

symbol* symbol_add(symbol** symbol_list, char* identifier, bool isconstant, int value){

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

/*symbol* symbol_add_or_edit(symbol** symbols_list, char* identifier, bool isconstant, int value){

	symbol* edit_symbol;
	
	HASH_FIND_STRING(symbols_list, identifier, edit_symbol);	

	if(edit_symbol == NULL){
		edit_symbol = symbol_gen(identifier, isconstant, value);
		HASH_ADD_STR(symbols_list, identifier, edit_symbol);
	} else {
		edit_symbol->isconstant = isconstant;
		edit_symbol->value = value;
	}

	return edit_symbol;
}*/

symbol* find_symbol(symbol* symbols_list, char* identifier) {
	symbol* found_symbol = NULL;

	symbol* list = symbols_list;
	while(list != NULL && found_symbol == NULL){
			if(strcmp(list->identifier, identifier) == 0) {
				found_symbol = list;
			}
			list = list->next;
		}
	return found_symbol;
}

void symbol_print(symbol* symbol_list){
	printf("=== Symbol list ==== \n");
	while(symbol_list != NULL){
		printf("Symbol list : identifier: %s || value : %d \n", symbol_list->identifier, symbol_list->value);
		symbol_list = symbol_list->next;
	}
	printf("=== End Symbol list ===\n");
}
