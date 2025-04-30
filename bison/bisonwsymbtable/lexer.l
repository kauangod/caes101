%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"
%}

%option noyywrap

%%

"write"         { return WRITE; }
"read"          { return READ; }
"int"           { return INT; }
"float"         { return FLOAT; }
"char"          { return CHAR; }
"bool"          { return BOOL; }
"=="            { return EQUALS; }
"!="            { return DIFFERENT; } 
">="            { return GREATER; } 
"<="            { return LESS; } 
"&&"            { return AND; }
"||"            { return OR; }

"+"     { return '+'; }
"-"     { return '-'; }
"*"     { return '*'; }
"/"     { return '/'; }
"="     { return '='; }
"!"     { return '!';}
"<"     { return '<'; }
">"     { return '>'; }
"("     { return '('; }
")"     { return ')'; }
"{"     { return '{'; } 
"}"     { return '}'; }

[_]*[a-zA-Z]+[_]*[a-zA-Z]* { strcpy(yylval.variable, yytext); return VARIABLE; }
/*[a-zA-Z]+            { strcpy(yylval.string, yytext); return STRING; }*/
[-]?[0-9]+"."[0-9]+  { yylval.value = atof(yytext); return NUM; }
[-]?[0-9]+           { yylval.value = atof(yytext); return NUM; }
[a-zA-Z]             { yylval.string[0] = yytext[0]; return CARACTERE;}
"if"             { return IF; }
"then"           { return THEN; }
"else"           { return ELSE; }

[ \t]            {}  // Ignora espaços e tabulações
"\n"             { return DONE; }
.                { printf("Error: invalid lexeme '%s'.\n", yytext); return 0; }
%%
