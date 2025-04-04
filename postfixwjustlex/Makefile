FILE = lexer.l
OUTPUT_FILE = lexer

all:
	flex -o $(OUTPUT_FILE).yy.c $(FILE)
	gcc -o $(OUTPUT_FILE) $(OUTPUT_FILE).yy.c 
	./$(OUTPUT_FILE)
