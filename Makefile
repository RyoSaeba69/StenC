LEX = lex
YACC = yacc -d
CC = gcc

stenC: stenC.c y.tab.c lex.yy.c
	$(CC) -o stenC y.tab.c lex.yy.c -ly -ll
y.tab.c: stenC.y
	$(YACC) stenC.y
lex.yy.c: stenC.l
	$(LEX) stenC.l