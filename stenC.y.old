%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>
	#include <math.h>
	int yylex();
	int yyerror();
%}

%union{
	int entier;
	char* ident;
}

%token STENCIL /* stencil*/
%token ENTIER /* [0-9]+*/
%token IDENTIFICATEUR /* */
%token IDENTIFICATEUR_STENCIL /* */
%token INT /* int */
%token MOINSMOINS
%token PLUSPLUS

%type <entier> ENTIER
%type <ident> IDENTIFICATEUR
%type <ident> IDENTIFICATEUR_STENCIL


%%

axiom: declaration_var {printf("Declaration de variable reconnu ");}
						;

declaration_var : stencil ';'
				  | entier_var ';'
				;

stencil: STENCIL IDENTIFICATEUR_STENCIL '=' tableau
			;

entier_var: entier_int
			;

entier_int:  INT IDENTIFICATEUR
			| INT IDENTIFICATEUR '=' ENTIER
			;

tableau: '{' entier_liste '}'
			;

entier_liste: ENTIER
			  |
			  ENTIER ',' entier_liste
			  ;

%%

int main(){

	printf("Compilateur StenC : \n");
	return yyparse();
}
