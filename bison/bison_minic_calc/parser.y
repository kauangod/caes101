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
%token DONE
%token <valueInt> VARIABLE
%token IF
%token ELSE
%token EQUALS
%token DIFFERENT
%token GREATER_OR_EQUAL
%token LOWER_OR_EQUAL
%token AND
%token OR

/* declare non-terminals */
%type <value> stmt expr factor term boolean logical_expression command_if

/* give us more detailed errors */
%define parse.error verbose
%left OR
%left AND
%left "!"
%%
/* one expression only followed by a new line */
progexec: stmt
    | stmt progexec

stmt: atrib DONE {}
    | expr DONE {result = $1; return 0;}
    | command_if DONE {result = $1; return 0;}

/* variable value */
atrib: VARIABLE '=' expr {symb[$1] = $3;}

/* an expression uses + or - or neither */
expr: expr '+' term {$$ = $1 + $3;}
    | expr '-' term {$$ = $1 - $3;}
    | term {$$ = $1;}

/* an expression uses * or / or neither */
term: term '*' factor {$$ = $1 * $3;}
    | term '/' factor {$$ = $1 / $3;}
    | factor {$$ = $1;}

factor: VAL {$$ = $1;}
      | '(' expr ')' {$$ = $2;}
      | VARIABLE {$$ = symb[$1];}

command_if: IF '(' boolean ')' '{' expr '}' ELSE '{' expr '}' {$$ = ($3 ? $6 : $10);}
          | IF '(' boolean ')' '{' expr '}' {$$ = ($3 ? $6 : 0);}


boolean: '!' '(' logical_expression ')' {$$ = !$3;}
       | '(' logical_expression ')' {$$ = $2;}
       | logical_expression

logical_expression: factor EQUALS factor {$$ = ($1 == $3);}
                  | factor DIFFERENT factor {$$ = ($1 != $3);}
                  | factor GREATER_OR_EQUAL factor {$$ = ($1 >= $3);}
                  | factor LOWER_OR_EQUAL factor {$$ = ($1 <= $3);}
                  | factor '>' factor {$$ = ($1 > $3);}
                  | factor '<' factor {$$ = ($1 < $3);}
                  | logical_expression OR logical_expression {$$ = ($1 || $3);}
                  | logical_expression AND logical_expression {$$ = ($1 && $3);}
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


