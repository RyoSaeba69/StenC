%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "y.tab.h"
	#include "code.h"
%}
identificateur [a-zA-Z]+\{[0-9]\,[0-9]\}
prepro ^[ \t\n]*(#[^ ]*[ ]+)
blank [ \t\n]+
commentaire "/*"([^\*]*[\*]*[^/\*])*[^\*]*[\*]*"*/"
/* flottant (\.?[0-9]{1}[0-9\.]*)|(\.?[0-9]{1}[0-9\.]*)e[0-9]*  */
entier [0-9]+
	
%%
"stencil" {return STENCIL;}
"="	{
	return '=';
	}
"{"	{
	return '{';
	}
"}"	{
	return '}';
	}
","	{
	return ',';
	}
{entier}	{
			yylval.entier = atoi(yytext);
			return ENTIER;
			}
{identificateur}	{
					yylval.ident = yytext;
					return IDENTIFICATEUR;
					}
{commentaire} {}
{blank} {}
. {printf("LEX : %s non reconnu", yytext);}

%%

