%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>
	#include <math.h>
	#include "quad.h"
	#include "symbol.h"
	#include "quad_op.h"

	int yylex();
	int yyerror();

	symbol* symbols_table = NULL;
	quad* quads_list = NULL;

%}

%union{
	int integer;
	char* string;
	enum quad_op qop;
	struct symbol* ptr_symbol;
}

%token INTEGER /* [0-9]+*/
%token IDENTIFIER /* */
%token INT /* int */

%type <integer> INTEGER
%type <string> IDENTIFIER
%type <string> declaration_var
%type <qop> operators
%type <ptr_symbol> expression;

%%

axiom: list_instructions '\n' {printf("Axiom reached :D\n");symbol_print(symbols_table);quad_print(quads_list);gen_mips(quads_list);}
						;
list_instructions: instruction ';'
				  | instruction ';' list_instructions {printf("INSTRUCTION LIST ");}
				  ;

instruction: declaration_var {printf("AN INSTRUCTION \n");}
			| assignment_expression {printf("ASSIGN INSTRUCTION \n");}
			| assignment_array {printf("array list \n");}
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

square_bracket: '[' INTEGER ']'
				;

multi_square_bracket: square_bracket multi_square_bracket
					 | square_bracket square_bracket
					 ;

number_list: INTEGER 
			| INTEGER ',' number_list
			;

brackets_list:	'{' '}'
			  |  '{' number_list '}'
			  |  '{' brackets_list ',' brackets_list '}'
			  /*| brackets_list ',' brackets_list*/
			  ;

assignment_array : declaration_var multi_square_bracket '=' brackets_list
					| declaration_var multi_square_bracket
					| IDENTIFIER '=' brackets_list
					;

assignment_expression : declaration_var '=' INTEGER {

							symbol* var_symbol = find_symbol(symbols_table, $1);
							var_symbol->value = $3;
							symbol* integer_symbol = symbol_add(&symbols_table, NULL, true, $3);
							quad* new_quad = quad_gen(Q_ASSIGNMENT, var_symbol, NULL, integer_symbol);
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
							quad* new_quad = quad_gen(Q_ASSIGNMENT, var_symbol, NULL, integer_symbol);
							quad_add(&quads_list, new_quad);
					  }
					  | declaration_var '=' expression
					  | IDENTIFIER '=' expression
					  ;
					
operators: '+' {$$ = Q_PLUS;}| '-' {$$ = Q_MINUS;}| '*' {$$ = Q_MULTIPLY;}| '/' {$$ = Q_DIVIDE;}
		;

expression: IDENTIFIER operators IDENTIFIER{

				symbol* id_symbol1 = find_symbol(symbols_table, $1);
				
				if(id_symbol1 == NULL){
					printf("ERROR==> %s never declared !", $1);
				}

				symbol* id_symbol2 = find_symbol(symbols_table, $3);
				
				if(id_symbol2 == NULL){
					printf("ERROR==> %s never declared !", $3);
				}

				quad* new_quad = quad_gen($2, id_symbol1, id_symbol2, id_symbol2);
				quad_add(&quads_list, new_quad);

			}
			| IDENTIFIER operators INTEGER{
				symbol* id_symbol = find_symbol(symbols_table, $1);
				
				if(id_symbol == NULL){
					printf("ERROR==> %s never declared !", $1);
				}
				
				symbol* integer_symbol = symbol_add(&symbols_table, NULL, true, $3);
				quad* new_quad = quad_gen($2, id_symbol, integer_symbol, integer_symbol);
				quad_add(&quads_list, new_quad);

			}
			| INTEGER operators INTEGER{
				
				symbol* integer_symbol1 = symbol_add(&symbols_table, NULL, true, $1);
				symbol* integer_symbol2 = symbol_add(&symbols_table, NULL, true, $3);
				quad* new_quad = quad_gen($2, integer_symbol1, integer_symbol2, integer_symbol2);
				quad_add(&quads_list, new_quad);
			}
			| INTEGER operators IDENTIFIER{
				symbol* id_symbol = find_symbol(symbols_table, $3);
				
				if(id_symbol == NULL){
					printf("ERROR==> %s never declared !", $3);
				}
				
				symbol* integer_symbol = symbol_add(&symbols_table, NULL, true, $1);
				quad* new_quad = quad_gen($2, integer_symbol, id_symbol, id_symbol);
				quad_add(&quads_list, new_quad);
			}
			;
%%

int main(){
	printf("Compiler StenC : \n");
	return yyparse();
}
