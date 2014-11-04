%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>
	#include <math.h>
	int yylex();
	int yyerror();
%}


%%
	
axiom: ;

%%

int main(){
	
	printf("Compilateur StenC : \n");
	return yyparse();
}