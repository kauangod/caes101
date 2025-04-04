%{
#include <stdio.h>
%}

%%
a{1}[0-9][0-9][0-9][0-9][0-9][0-9][0-9]   { printf("RA UTFPR: %s \n", yytext); } /* Exercício 7 */
["][a-zA-Z\ ]*["]   { printf("Strings programa em C: %s \n", yytext); } /* Exercício 12 */
(2[0-5][0-5]|1[0-9][0-9]|[1-9][0-9]?|0)\.(2[0-5][0-5]|1[0-9][0-9]|[1-9][0-9]?|0)\.(2[0-5][0-5]|1[0-9][0-9]|[1-9][0-9]?|0)\.(2[0-5][0-5]|1[0-9][0-9]|[1-9][0-9]?|0)   { printf("Endereços de IP válidos: %s \n", yytext); } /* Exercício 4 */
.   { printf("Caractere desconhecido: %s \n", yytext); }
%%

int main(int argc, char **argv) {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
