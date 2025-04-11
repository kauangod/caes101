%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yylex(void);
int yywrap(void);
void yyerror(const char* str);

/* the result variable */
double result = 0;
int symb[26];

%}

/* declare type possibilities of symbols */
%union {
  double value;
  int valueInt;
}

/* declare tokens (default is typeless) */
%token <value> VAL
%token PLUS
%token MINUS
%token DIVIDE
%token TIMES
/* %token LEFT */
/* %token RIGHT */
%token DONE
%token <valueInt> VARIABLE
%token EQUALS

/* declare non-terminals */
%type <value> stmt expr factor

/* give us more detailed errors */
%define parse.error verbose

%%

/* one expression only followed by a new line */
progexec: stmt
    |  stmt progexec

stmt: atrib DONE {}
    | expr DONE {result = $1; return 0;}

/* variable value */
atrib: VARIABLE EQUALS expr { symb[$1] = $3;}

/* an expression uses + or - or neither */
expr: expr factor PLUS {$$ = $1 + $2;}
    | expr factor MINUS {$$ = $1 - $2;}
    | expr factor TIMES {$$ = $1 * $2;}
    | expr factor DIVIDE {$$ = $1 / $2;}
    | factor {$$ = $1;}

/* an expression uses * or / or neither */
/* term: term factor TIMES {$$ = $1 * $2;}
    | term factor DIVIDE {$$ = $1 / $2;}
    | factor {$$ = $1;} */

factor: VAL {$$ = $1;}
      /* | LEFT expr RIGHT {$$ = $2;} */
      | VARIABLE { $$ = symb[$1];}
%%

int yywrap( ) {
  return 1;
}

void yyerror(const char* str) {
  fprintf(stderr, "Compiler error: '%s'.\n", str);
}

int main( ) {
  yyparse( );
  printf("The answer is %lf\n", result);
  return 0;
}


