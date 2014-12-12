%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>
	#include <math.h>
	#include "quad.h"
	#include "symbol.h"

	int yylex();
	int yyerror();

	symbol* symbols_table = NULL;
	quad* quads_list = NULL;

%}

%union{
	int integer;
	char* string;
}

%token INTEGER /* [0-9]+*/
%token IDENTIFIER /* */
%token INT /* int */

%type <integer> INTEGER
%type <string> IDENTIFIER
%type <string> declaration_var

%%

axiom: list_instructions '\n' {printf("Axiom reached :D\n");symbol_print(symbols_table);quad_print(quads_list);gen_mips(quads_list);}
						;
list_instructions: instruction ';'
				  | instruction ';' list_instructions {printf("INSTRUCTION LIST ");}
				  ;

instruction: declaration_var {printf("AN INSTRUCTION \n");}
			| assignment_expression {printf("ASSIGN INSTRUCTION \n");}
			;

declaration_var : type_specifier IDENTIFIER {
					printf("A DECLARATION \n");
					if(find_symbol(symbols_table, $2) != NULL){
						printf("ERROR ==> %s already declared ! \n", $2);
						exit(0);
						//$$ = $2;
					} else {
						symbol_add(&symbols_table, $2, false, 0);
						$$ = $2;
					}
				}
				;

type_specifier: INT
				;

assignment_expression : declaration_var '=' INTEGER {

							symbol* var_symbol = find_symbol(symbols_table, $1);
							var_symbol->value = $3;
							symbol* integer_symbol = symbol_add(&symbols_table, NULL, true, $3);
							quad* new_quad = quad_gen(ASSIGNMENT, var_symbol, NULL, integer_symbol);
							quad_add(&quads_list, new_quad);

						}
					  |	IDENTIFIER '=' INTEGER {
							symbol* var_symbol = find_symbol(symbols_table, $1);

						if(var_symbol == NULL){
							printf("ERROR ==> %s never declared ! \n", $1);
							exit(0);
						}


							var_symbol->value = $3;
							symbol* integer_symbol = symbol_add(&symbols_table, NULL, true, $3);
							quad* new_quad = quad_gen(ASSIGNMENT, var_symbol, NULL, integer_symbol);
							quad_add(&quads_list, new_quad);
					  }
					  ;
					

%%

int main(){
	printf("Compiler StenC : \n");
	return yyparse();
}
