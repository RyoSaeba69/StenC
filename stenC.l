%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "y.tab.h"
%}

identifier [a-zA-Z]+[0-9a-zA-Z_]*
integer [0-9]+

%%

"int" { return INT;}
"=" {return '=';}
";" {return ';';}


{integer} {
	yylval.integer = atoi(yytext);
	return INTEGER;
}

{identifier} {
	yylval.string = strdup(yytext);
	return IDENTIFIER;
}



\n {return yytext[0];}
[\t ] {}

. {printf("[Lex] Non recognized character %c \n", yytext[0]);}
