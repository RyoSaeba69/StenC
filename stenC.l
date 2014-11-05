%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "y.tab.h"
	#include "code.h"
%}
identificateur [_a-zA-Z][_a-zA-Z0-9]*
prepro ^[ \t\n]*(#[^ ]*[ ]+)
blank [ \t\n]+
commentaire "/*"([^\*]*[\*]*[^/\*])*[^\*]*[\*]*"*/"
flottant (\.?[0-9]{1}[0-9\.]*)|(\.?[0-9]{1}[0-9\.]*)e[0-9]*
entier [0-9]+
chaineCar \"([^\\\"]|(\\.))*\"
%%
	
{commentaire} {}
{blank} {}

%%

