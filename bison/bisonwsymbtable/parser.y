%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define TABLE_SIZE 100
#define VAR_SIZE 11

int yylex(void);
int yywrap(void);
void yyerror(const char* str);

double result = 0;

enum Types{
  INT_TYPE,
  FLOAT_TYPE,
  BOOL_TYPE,
  CHAR_TYPE, 
  NO_TYPE
};
typedef struct Symbol{
  char var[VAR_SIZE];
  int type;
  int in_use; /* vazio (0), ocupado (1)*/
  union {
    int value_int;
    float value_float;
    unsigned int value_bool;
    char value_char;
  };
}Symbol;

Symbol* create_table(unsigned int size){
  if (size == 0){
      printf("Tamanho de tabela inválido!");
      return NULL;
  }
  Symbol* temp_table;
  int i = 0;
  temp_table = (Symbol*)malloc(sizeof(Symbol) * size);
  for(i = 0; i < size; i++){
      strcpy(temp_table[i].var, " ");
      temp_table[i].type = NO_TYPE;
      temp_table[i].in_use = 0;
  }
  return temp_table;
}

Symbol* table = create_table(TABLE_SIZE);

unsigned int hash(const char* key) {
    unsigned int hash_value = 0;
    while (*key) {
        hash_value += (unsigned char)(*key);
        key++;
    }
    return hash_value % TABLE_SIZE;
}

void insert(const char* name, const int type) {
    unsigned int index = hash(name);
    unsigned int original_index = index;
    unsigned int var_size = strlen(name);

    if (var_size > VAR_SIZE){
        printf ("Variável maior que o esperado!");
        return;
    }
    while (table[index].in_use) {
        if (strcmp(table[index].var, name) == 0) {
            // Se o símbolo já existir, atualiza o tipo
            table[index].type = type;
            return;
        }
        index = (index + 1) % TABLE_SIZE;
        if (index == original_index) {
            printf("Erro: tabela cheia!\n");
            return;
        }
    }
    strcpy(table[index].var, name);
    table[index].var[10] = '\0';
    table[index].type = type;
    table[index].in_use = 1;
}

Symbol* search(const char* name) {
    unsigned int index = hash(name);
    unsigned int original_index = index;

    while (table[index].in_use) {
        if (strcmp(table[index].var, name) == 0) {
            return &table[index]; 
        }
        index = (index + 1) % TABLE_SIZE;
        if (index == original_index) {
            break; 
        }
    }
    return NULL;
}

void print_table() {
    for (int i = 0; i < TABLE_SIZE; i++) {
        if (table[i].in_use) {
            printf("Nome: %s, Tipo: %d\n", table[i].var, table[i].type);
        }
    }
}

void free_table() {
    for (int i = 0; i < TABLE_SIZE; i++) {
        if (table[i].in_use) {
            free(table[i].var);
            table[i].in_use = 0;
        }
    }
    free(table);
}
%}

/* declare type possibilities of symbols */
%union {
  double value;
  char variable[11];
  char string[1];
}

/* declare tokens (default is typeless) */
%token <value> NUM 
%token INT
%token FLOAT
%token BOOL
%token CHAR
%token DONE
%token <variable> VARIABLE
%token IF
%token THEN
%token ELSE
%token EQUALS
%token DIFFERENT
%token GREATER
%token LESS
%token AND
%token OR
%token <string> CARACTERE
%token WRITE
%token READ

/* declare non-terminals */
%type <value> expr_aritmetica termo fator 
%type <variable> ID
%type <unsigned int> expr_logica

%define parse.error verbose

%% 
programa: declaracoes comandos DONE

declaracoes: declaracao
           | declaracoes declaracao

declaracao: INT ID DONE { insert($2, INT_TYPE); }
          | FLOAT ID DONE { insert($2, FLOAT_TYPE); }
          | BOOL ID DONE { insert($2, BOOL_TYPE); }
          | CHAR ID DONE { insert($2, CHAR_TYPE); }

comandos: comando
        | comandos comando

comando: comando_if
       | atribs
       | comando_read
       | comando_write

comando_read: READ '(' ID ')' { 
                int index = hash($3); 
                switch(table[index].type){
                    case INT_TYPE:
                       scanf("%d", &table[index].value_int);
                    break;
                    case FLOAT_TYPE:
                        scanf("%f", &table[index].value_float);
                    break;
                    case BOOL_TYPE:
                        scanf("%u", &table[index].value_bool);
                    break;
                    case CHAR_TYPE:
                        scanf("%c", &table[index].value_char);
                    break;
                    default:
                      break;
                }      
              }  

comando_write: WRITE '(' ID ')' { 
                  int index = hash($3); 
                  switch(table[index].type){
                      case INT_TYPE:
                          printf("%d", table[index].value_int);
                      break;
                      case FLOAT_TYPE:
                          printf("%f", table[index].value_float);
                      break;
                      case BOOL_TYPE:
                          printf("%u", table[index].value_bool);
                      break;
                      case CHAR_TYPE:
                          printf("%c", table[index].value_char);
                      break;
                      default:
                        break;
                  }
               }
             | WRITE '(' NUM ')' { printf("%.2lf", $3); }
             | WRITE '(' CARACTERE ')' { printf("%c", $3[0]); }

atribs: atrib
      | atribs atrib

comando_if: IF '(' expr_logica ')' THEN '{' atribs '}'
          | IF '(' expr_logica ')' THEN '{' atribs '}' ELSE '{' atribs '}'
          
expr_logica: expr_aritmetica '>' expr_aritmetica
           | expr_aritmetica '<' expr_aritmetica
           | expr_aritmetica GREATER expr_aritmetica
           | expr_aritmetica LESS expr_aritmetica
           | expr_aritmetica EQUALS expr_aritmetica
           | expr_aritmetica DIFFERENT expr_aritmetica
           | expr_logica OR expr_logica 
           | expr_logica AND expr_logica
           | '!' expr_logica
           

atrib: ID '=' expr_aritmetica { int index = hash($1); 
                                if(table[index].type == INT_TYPE) 
                                    { table[index].value_int = (int)$3; } 
                                else if(table[index].type == FLOAT_TYPE) 
                                { table[index].value_float = (float)$3; } 
                                else 
                                { printf("Erro semantico, expressao aritmetica atribuida a variavel nao numerica!"); } 
                              }
     | ID '=' expr_logica { int index = hash($1); 
                            if(table[index].type == BOOL_TYPE) 
                                { table[index].value_bool = $3; } 
                            else 
                                { printf("Erro semantico, expressao booleana atribuida a variavel nao booleana!"); } 
                          }
     | ID '=' CARACTERE { int index = hash($1); 
                          if(table[index].type == CHAR_TYPE) 
                              { table[index].value_char = $3[0]; } 
                          else 
                              { printf("Erro semantico, caractere atribuido a variavel nao char!");} 
                        }
                              

expr_aritmetica: expr_aritmetica '+' termo { $$ = $1 + $3; }
               | expr_aritmetica '-' termo { $$ = $1 - $3; }
               | termo

termo: termo '*' fator { $$ = $1 * $3; }
     | termo '/' fator { $$ = $1 / $3; }
     | fator 

fator: NUM 
     | '(' expr_aritmetica ')' { $$ = $2; } 
     | ID { unsigned int index = hash ($1); 
          if(table[index].type == INT_TYPE || table[index].type == FLOAT_TYPE) 
              { $$ = table[index].value; }
          else 
              { printf("Erro de semantica, tentativa de operacao aritmetica com variavel nao numerica!"); }
          }

ID: VARIABLE

%%

int yywrap() {
  return 1;
}

void yyerror(const char* str) {
  fprintf(stderr, "Compiler error: '%s'.\n", str);
}

int main() {
  yyparse();
  printf("The answer is %lf\n", result);
  return 0;
}


