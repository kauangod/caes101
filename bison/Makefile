all:
	bison -d parser.y -o parser.tab.c --update
	flex lexer.l
	gcc parser.tab.c lex.yy.c -Wall -o compiler
	./compiler