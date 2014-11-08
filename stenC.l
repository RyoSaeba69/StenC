%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "y.tab.h"
	#include "code.h"
%}
identificateur_stencil [a-zA-Z]+\{[0-9]\,[0-9]\}
identificateur [a-zA-Z]+
prepro ^[ \t\n]*(#[^ ]*[ ]+)
blank [ \t\n]+
commentaire "/*"([^\*]*[\*]*[^/\*])*[^\*]*[\*]*"*/"
entier [0-9]+
%%

"stencil"{blank}		{return STENCIL;}
"int"{blank}	{return INT;}

"="	{return '=';}
"{"	{return '{';}
"}"	{return '}';}
"[" {return '[';}
"]" {return ']';}
","	{return ',';}
";" {return ';';}
"*"	{return '*';}
"+"	{return '+';}
"-"	{return '-';}
"/"	{return '/';}
"++"	{return PLUSPLUS;}
"--"	{return MOINSMOINS;}


{entier}	{
			yylval.entier = atoi(yytext);
			return ENTIER;
			}
{identificateur}	{
					yylval.ident = yytext;
					return IDENTIFICATEUR;
					}

{identificateur_stencil}	{
					yylval.ident = yytext;
					return IDENTIFICATEUR_STENCIL;
					}

{commentaire} {}
{blank} {}
. {printf("LEX : %s non reconnu", yytext);}

%%
