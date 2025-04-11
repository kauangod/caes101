%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

%}

%option noyywrap

%%

"+"             {return PLUS;}
"-"             {return MINUS;}
"/"             {return DIVIDE;}
"*"             {return TIMES;}
[a-z]           {yylval.valueInt=(int)(yytext[0])- 97; return VARIABLE; }
"="             {return EQUALS;}
[0-9]+          {yylval.value = atof(yytext); return VAL;}
[0-9]+"."[0-9]+ {yylval.value = atof(yytext); return VAL;}
[ \t]           {}
"\n"            {return DONE;}
.               {printf("Error: invalid lexeme '%s'.\n", yytext); return 0;}

%%



