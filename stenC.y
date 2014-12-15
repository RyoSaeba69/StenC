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
	int next_label = 0;

%}

%union{
	int integer;
	char* string;
	enum quad_op qop;
	struct symbol* ptr_symbol;
	quad* quad_type;

	struct condition_type{
		quad* code;
		quad_list* truelist;
		quad_list* falselist;
	} cond;	

	struct dvar {
		char* identifier;
		quad* q;
	}dvar_type;

}

%token INTEGER /* [0-9]+*/
%token IDENTIFIER /* */
%token INT /* int */
%token TRUE 
%token FALSE
%token WHILE 
%token DO
%token IF 
%token ELSE 
%token EQUAL 
%token OR
%token AND 
%token NOT 
%token STENCIL
%token END_OF_CODE

%type <integer> INTEGER
%type <string> IDENTIFIER
%type <dvar_type> declaration_var
%type <ptr_symbol> expression;
%type <ptr_symbol> variable;
%type <cond> condition;
%type <quad_type> instruction
%type <quad_type> list_instructions
%type <quad_type> assignment_expression
/*%type <quad_type> assignment_array */


%type <quad_type> wloop
%type <quad_type> wloop_false
%type <quad_type> if_falsetag
%type <quad_type> noelse_tag
%type <quad_type> afterelse_tag


%right '=' /* a = b = c // On fait d abord b = c puis a = b donc right */
%left '+' '-'
%left '*' '/'


%left EQUAL
%left OR 
%left AND
%right NOT 

%%

axiom: '{' list_instructions '}' {printf("Axiom reached\n");symbol_print(symbols_table);quad_print(quads_list);gen_mips(quads_list);}
						;
list_instructions: instruction {$$ = $1;}
				  | instruction list_instructions {$$ = $1;}
				  ;

wloop: {
		$$ = quad_gen(&next_label, Q_GOTO, NULL, NULL, NULL);
		quad_add(&quads_list, $$);
	}
	;

wloop_false: {
		$$ = quad_gen(&next_label, Q_GOTO, NULL, NULL, NULL);
		quad_add(&quads_list, $$);
	}
	;

if_falsetag: {
		$$ = quad_gen(&next_label, Q_NOOP, NULL, NULL, NULL);
		quad_add(&quads_list, $$);
	}
	;

afterelse_tag : {
	$$ = quad_gen(&next_label, Q_NOOP, NULL, NULL, NULL);
	quad_add(&quads_list, $$);
}
;

noelse_tag : {
	$$ = quad_gen(&next_label, Q_GOTO, NULL, NULL, symbol_add(&symbols_table, NULL, false, 0));
	quad_add(&quads_list, $$);
}
;

instruction: declaration_var ';' {$$ = $1.q;}
			| assignment_expression ';' {$$ = $1;}
			| assignment_array {/* not implemented */}
			| IF '(' condition ')' '{' list_instructions '}' if_falsetag
			 {
				quad_list_complete_label($3.truelist, $6->label);
				quad_list_complete_label($3.falselist, $8->label);
			 }
		 	| IF '(' condition ')' '{' list_instructions '}' noelse_tag ELSE '{' list_instructions '}' afterelse_tag
		 	{
				quad_list_complete_label($3.truelist, $6->label);
				quad_list_complete_label($3.falselist, $11->label);
				$8->res->value = $13->label;
		 	}
			| WHILE '(' condition ')' '{' list_instructions wloop '}' wloop_false {
			quad_list_complete_label($3.truelist, $3.code->label);			 
			quad_list_complete_label($3.falselist, $9->label);			 
			symbol* tmp_symbol = symbol_gen(NULL, true, $3.code->label);
			$7->res = tmp_symbol;
		 	}

		;

declaration_var : type_specifier IDENTIFIER {
					if(find_symbol(symbols_table, $2) != NULL){
						printf("ERROR ==> %s already declared ! \n", $2);
						exit(0);
						//$$ = $2;
					} else {
						symbol* tmp_symbol = symbol_add(&symbols_table, $2, false, 0);
						$$.identifier = $2;
						quad* tmp_quad = quad_gen(NULL, Q_ASSIGNMENT, NULL, NULL, tmp_symbol);
						$$.q = tmp_quad;
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

assignment_expression : declaration_var '=' expression {
							symbol* var_symbol = find_symbol(symbols_table, $1.identifier);
							
							var_symbol->value = $3->value;
							$1.q->arg1 = $3;
							$1.q->label = next_label;
							quad_add(&quads_list, $1.q);
							next_label++;
							$$ = $1.q;

					  }
					  | IDENTIFIER '=' expression {
							symbol* var_symbol = find_symbol(symbols_table, $1);

							if(var_symbol == NULL){
								printf("ERROR ==> %s never declared ! \n", $1);
								exit(0);
							}
							var_symbol->value = $3->value;
							quad* new_quad = quad_gen(&next_label, Q_ASSIGNMENT, $3, NULL, var_symbol);
							$$ = new_quad;
							quad_add(&quads_list, new_quad);
					  }
					  ;
					
variable: IDENTIFIER {
				symbol* id_symbol = find_symbol(symbols_table, $1);

				if(id_symbol == NULL){
					printf("ERROR==> %s never declared !", $1);
				}

				$$ = id_symbol;

		}
		| INTEGER {
			symbol* tmp_sym2 = symbol_add(&symbols_table, NULL, true, $1);
			symbol* tmp_sym = symbol_add(&symbols_table, NULL, true, $1);
			quad* new_quad = quad_gen(&next_label, Q_ASSIGNMENT, tmp_sym2, NULL, tmp_sym);
			quad_add(&quads_list, new_quad);
			$$ = tmp_sym;
		};

expression: expression '+' expression{
				$$ = symbol_add(&symbols_table, NULL, false, make_operation(Q_PLUS, $1->value, $3->value));
				$$->value =  make_operation(Q_PLUS, $1->value, $3->value);
				quad* new_quad = quad_gen(&next_label, Q_PLUS, $1, $3, $$);
				quad_add(&quads_list, new_quad);
			}
			|expression '-' expression{
				$$ = symbol_add(&symbols_table, NULL, false, make_operation(Q_MINUS, $1->value, $3->value));
				$$->value =  make_operation(Q_MINUS, $1->value, $3->value);
				quad* new_quad = quad_gen(&next_label, Q_MINUS, $1, $3, $$);
				quad_add(&quads_list, new_quad);
			}
			| expression '*' expression{
				$$ = symbol_add(&symbols_table, NULL, false, make_operation(Q_MULTIPLY, $1->value, $3->value));
				$$->value =  make_operation(Q_MULTIPLY, $1->value, $3->value);
				quad* new_quad = quad_gen(&next_label, Q_MULTIPLY, $1, $3, $$);
				quad_add(&quads_list, new_quad);
			}
			|expression '/' expression{
				$$ = symbol_add(&symbols_table, NULL, false, make_operation(Q_DIVIDE, $1->value, $3->value));
				$$->value =  make_operation(Q_DIVIDE, $1->value, $3->value);
				quad* new_quad = quad_gen(&next_label, Q_DIVIDE, $1, $3, $$);
				quad_add(&quads_list, new_quad);
			}
			| '(' expression ')' {
				$$ = $2;
			}
			| variable {
				$$ = $1;
			}
			;


	condition: IDENTIFIER EQUAL INTEGER
			   | TRUE
			   {
					$$.code = quad_gen(&next_label, Q_GOTO, NULL, NULL, symbol_add(&symbols_table, NULL, false, -1));
					quad_add(&quads_list, $$.code);

					$$.truelist = quad_list_new($$.code);
					$$.falselist = NULL;
			   }
			   | FALSE
			   {
					$$.code = quad_gen(&next_label, Q_GOTO, NULL, NULL, symbol_add(&symbols_table, NULL, false, -1));
					quad_add(&quads_list, $$.code);

					$$.truelist = NULL;
					$$.falselist = quad_list_new($$.code);
			   }
			   | condition OR condition
			   {
				   	quad_list_complete_label($1.falselist, $3.code->label);
					$$.code = quad_gen(&next_label, Q_GOTO, NULL, NULL, symbol_add(&symbols_table, NULL, false, -1));
					quad_add(&quads_list, $$.code);

					$$.truelist = $1.truelist;
					quad_list_add(&$$.truelist, $3.truelist);
					$$.falselist = $3.falselist;
			   }
			   | condition AND condition
			   {
				   	quad_list_complete_label($1.truelist, $3.code->label);
					$$.code = quad_gen(&next_label, Q_GOTO, NULL, NULL, symbol_add(&symbols_table, NULL, false, -1));
					quad_add(&quads_list, $$.code);

					$$.truelist = $3.truelist;
					$$.falselist = $1.falselist;
					quad_list_add(&$$.falselist, $3.falselist);
			   }
			   | NOT condition
			   {
				   $$.code = $2.code; 
				   $$.truelist = $2.falselist;
				   $$.falselist = $2.truelist;
			   }
			   | '(' condition ')'
			   {
				   $$.code = $2.code;

				   $$.truelist = $2.truelist;
				   $$.falselist = $2.falselist;
			   }
			   ;
%%

int main(){
	printf("Compiler StenC : \n");
	return yyparse();
}
