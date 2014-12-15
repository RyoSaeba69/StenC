%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "quad_op.h"
	#include "quad.h"
	#include "y.tab.h"
%}

identifier [a-zA-Z]+[0-9a-zA-Z_]*
integer [0-9]+

%%

"true" {return TRUE;}
"false" {return FALSE;}

"stencil" {return STENCIL;}
"while" {return WHILE;}
"do" {return DO;}
"if" {return IF;}
"else" {return ELSE;}
"==" {return EQUAL;}
"!" {return NOT;}
"&&" {return AND;}
"||" {return OR;}

"END_OF_CODE" {return END_OF_CODE;}
"int" { return INT;}
"=" {return '=';}
";" {return ';';}
"[" {return '[';}
"]" {return ']';}
"{" {return '{';}
"}" {return '}';}
"(" {return '(';}
")" {return ')';}
"," {return ',';}
"+" {return '+';};
"-" {return '-';};
"/" {return '/';};
"*" {return '*';};

{integer} {
	yylval.integer = atoi(yytext);
	return INTEGER;
}

{identifier} {
	yylval.string = strdup(yytext);
	return IDENTIFIER;
}



\n {/*return yytext[0];*/}
[\t ] {}

. {printf("[Lex] Non recognized character %c \n", yytext[0]);}
