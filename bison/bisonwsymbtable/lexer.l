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
"if"            { return IF; }
"then"          { return THEN; }
"else"          { return ELSE; }
"return"        { return RETURN; }
"=="            { return EQUALS; }
"!="            { return DIFFERENT; } 
">="            { return GREATER; } 
"<="            { return LESS; } 
"&&"            { return AND; }
"||"            { return OR; }

"0"     { return '0'; }
"+"     { return '+'; }
"-"     { return '-'; }
"*"     { return '*'; }
"/"     { return '/'; }
"="     { return '='; }
"!"     { return '!'; }
"<"     { return '<'; }
">"     { return '>'; }
"("     { return '('; }
")"     { return ')'; }
"{"     { return '{'; } 
"}"     { return '}'; }
 

[_]*[a-zA-Z]+[_]*[a-zA-Z]* { strcpy(yylval.variable, yytext); return VARIABLE; }
[-]?[0-9]+"."[0-9]+  { yylval.value = atof(yytext); return NUM; }
[-]?[0-9]+           { yylval.value = atof(yytext); return NUM; }
\'[a-zA-Z]\'             { yylval.string[0] = yytext[1]; yylval.string[1] = '\0'; return CARACTERE;}
[ \t]            {}  // Ignora espaços e tabulações
"\n"             { return DONE; }
.                { printf("Error: invalid lexeme '%s'.\n", yytext); return 0; }
%%
