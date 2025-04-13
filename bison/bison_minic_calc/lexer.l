%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"
%}

%option noyywrap

%%
"=="            { return EQUALS; }
"!="            { return DIFFERENT; }
">="            { return GREATER_OR_EQUAL; }
"<="            { return LOWER_OR_EQUAL; }
"&&"            { return AND; }
"||"            { return OR; }

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

[a-z]            { yylval.valueInt = (int)(yytext[0]) - 97; return VARIABLE; }
[0-9]+"."[0-9]+  { yylval.value = atof(yytext); return VAL; }
[0-9]+           { yylval.value = atof(yytext); return VAL; }

"if"             { return IF; }
"else"           { return ELSE; }

[ \t]            {}  // Ignora espaços e tabulações
"\n"             { return DONE; }
.                { printf("Error: invalid lexeme '%s'.\n", yytext); return 0; }
%%