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

%type <entier> ENTIER
%type <ident> IDENTIFICATEUR
	
%%
	
axiom: stencil '\n';

stencil: STENCIL IDENTIFICATEUR '=' tableau;

tableau: '{' entier_liste '}';

entier_liste: ENTIER 
			  |
			  ENTIER ',' entier_liste 
			  ;

%%

int main(){
	
	printf("Compilateur StenC : \n");
	return yyparse();
}