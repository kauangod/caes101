# === Variáveis de nomes de arquivos ===
FLEX   = lexer.l
BISON  = parser.y
EXEC   = compiler

BISON_C = parser.tab.c
BISON_H = parser.tab.h
FLEX_C  = lex.yy.c

CC = gcc
CFLAGS = -Wall

# === Regra principal ===
all: $(EXEC)

# === Regras de geração dos arquivos ===
$(BISON_C) $(BISON_H): $(BISON)
	bison -d $(BISON) -o $(BISON_C)

$(FLEX_C): $(FLEX) $(BISON_H)
	flex $(FLEX)

$(EXEC): $(BISON_C) $(FLEX_C)
	$(CC) $(CFLAGS) $(BISON_C) $(FLEX_C) -o $(EXEC) -lfl

# === Limpeza dos arquivos gerados ===
clean:
	rm -f $(BISON_C) $(BISON_H) $(FLEX_C) $(EXEC)