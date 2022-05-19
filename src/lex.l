%{
    #include "node.h"
    #include <stdio.h>
    #include "yacc.tab.h"
    //int yyline = 1;


    extern unsigned lexError;
    int lines = 0;
    int yycolumn = 1;
    
    #define YY_USER_ACTION \
        yylloc.first_line = yylloc.last_line = yylineno; \
        yylloc.first_column = yycolumn; \
        yylloc.last_column = yycolumn + yyleng - 1; \
        yycolumn += yyleng;

%}

%option yylineno

digit [0-9]
number [0-9]+
letter [a-zA-Z]
word [0-9a-zA-Z]+
blank [ ]*
%%

{number} { printf("number detected\n"); yylval.node = CreateTokenNode(yylineno,"INT", TOKEN_INT, yytext ); return NUMBER;}
\n { printf("enter detected\n"); yycolumn = 1;}
{word} { printf("word detected\n"); yylval.node = CreateTokenNode(yylineno, "WORD", TOKEN_OTHERS, yytext); return WORD; }
"+" { printf("+ detected\n"); yylval.node = CreateTokenNode(yylineno,"PLUS", TOKEN_OTHERS, yytext); return PLUS; }
"-" { printf("- detected\n"); yylval.node = CreateTokenNode(yylineno, "MINUS",TOKEN_OTHERS, yytext); return MINUS;}
"*" { printf("* detected\n"); yylval.node = CreateTokenNode(yylineno, "MUL",TOKEN_OTHERS, yytext); return MUL;}
"/" { printf("/ detected\n"); yylval.node = CreateTokenNode(yylineno, "DIV",TOKEN_OTHERS, yytext); return DIV;}
"=" { printf("= detected\n"); yylval.node = CreateTokenNode(yylineno, "EQUAL",TOKEN_OTHERS, yytext); return EQUAL;}

. { }


%%
int yywrap(void){
    return 0;    
}
