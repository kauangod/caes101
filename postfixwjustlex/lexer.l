%{
#include <stdio.h>
typedef struct
{
    int top, size;
    float *elem;
} Stack;

Stack* create_stack(int size){
    Stack* s;
    s = (Stack *)malloc(sizeof(Stack));
    s->top = -1;
    s->size = size;
    s->elem = (float*)malloc(sizeof(float) * s->size);
    return s;
}
void delete_stack (Stack* s){
    int i = 0;
    s->top = -1;
    free(s->elem);
    s->elem = NULL;
    free(s);
    s = NULL;
}
int full (Stack* s){
    if (s->top == (s->size - 1))
        return 1;
    return 0;
}
int empty(Stack* s){
    if (s->top == -1)
        return 1;
    return 0;
}
void push(Stack* s, float elem){
    if (!full(s)) { s->elem[++s->top] = elem; }
    else { printf ("Stack is full!");}
}
float pop(Stack* s){
    if (!empty(s)){
        float t;
        t = s->elem[s->top--];
        return t;
    }
    printf ("Stack is empty!");
    return -1;
}
void print_stack (Stack* s){
    int i = 0;
    printf ("[");
    while (i < s->top){
        printf ("%f, ", s->elem[i]);
        i++;
    }
    printf ("%f", s->elem[i]);
    printf("]");
    printf("\n");
}
Stack* s;
int size = 30;
%}

%option noyywrap

NUM ([0-9]+(\.[0-9])?)
SUM ([\+])
SUB ([\-])
MULT([\*])
DIV ([\/])

%%
{NUM} {push(s, atof(yytext));}
{SUM} {
    float x = 0, y = 0, r = 0;
    print_stack(s);
    x = pop(s);
    y = pop(s);
    r = x + y;
    push(s,r);
}
{SUB} {
    float x = 0, y = 0, r = 0;
    print_stack(s);
    x = pop(s);
    y = pop(s);
    r = y - x;
    push(s,r);
}
{MULT} {
    float x = 0, y = 0, r = 0;
    print_stack(s);
    x = pop(s);
    y = pop(s);
    r = x * y;
    push(s,r);
}
{DIV} {
    float x = 0, y = 0, r = 0;
    print_stack(s);
    x = pop(s);
    y = pop(s);
    r = y / x;
    push(s,r);
}
\n { printf ("%f", s->elem[s->top]); }
. { }
%%

int main(int argc, char **argv) {
    s = create_stack(size);
    yylex();
    delete_stack(s);
    return 0;
}


