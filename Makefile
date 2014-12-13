LEX = lex
YACC = yacc -d -v
CC = gcc
#SRC = quad.c quad.h symbol.h

stenC: stenC.c y.tab.c lex.yy.c
	$(CC) y.tab.c lex.yy.c quad.h quad.c symbol.h symbol.c quad_op.h quad_op.c -ly -ll -Wall -g
y.tab.c: stenC.y
	$(YACC) stenC.y
lex.yy.c: stenC.l
	$(LEX) stenC.l
