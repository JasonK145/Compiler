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
blank [ ]*
IF if
ELSE else
WHILE while
RELOP >|<|>=|<=|==|!=
RETURN return
TYPE int|float
LP "("
RP ")"
LC "{"
RC "}"
INT [0-9]+
WORD [_0-9a-zA-Z]+
FLOAT {INT}"."{INT}
%%

{IF} { yylval.node = CreateTokenNode(yylineno, "IF", TOKEN_OTHERS, yytext); return IF; }
{ELSE} { yylval.node = CreateTokenNode(yylineno, "ELSE", TOKEN_OTHERS, yytext); return ELSE; }
{WHILE} { yylval.node = CreateTokenNode(yylineno, "WHILE", TOKEN_OTHERS, yytext); return WHILE; }
{RELOP} { yylval.node = CreateTokenNode(yylineno, "RELOP", TOKEN_OTHERS, yytext); return RELOP; }
{RETURN} { yylval.node = CreateTokenNode(yylineno, "RETURN", TOKEN_OTHERS, yytext); return RETURN;  } 
{TYPE} { printf("type detected!\n"); yylval.node = CreateTokenNode(yylineno, "TYPE", TOKEN_OTHERS, yytext); return TYPE; }

{INT} { printf("INT detected\n"); yylval.node = CreateTokenNode(yylineno,"INT", TOKEN_INT, yytext ); return INT;}
{FLOAT} { printf("FLOAT detectd\n"); yylval.node = CreateTokenNode(yylineno, "FLOAT", TOKEN_FLOAT, yytext); return FLOAT;}
\n { printf("enter detected\n"); yycolumn = 1;}
\t { }

{LP} { printf("LP det!\n"); yylval.node = CreateTokenNode(yylineno, "LP", TOKEN_OTHERS, yytext); return LP; }
{RP} { yylval.node = CreateTokenNode(yylineno, "RP", TOKEN_OTHERS, yytext); return RP; }
{LC} { yylval.node = CreateTokenNode(yylineno, "LC", TOKEN_OTHERS, yytext); return LC; }
{RC} { yylval.node = CreateTokenNode(yylineno, "RC", TOKEN_OTHERS, yytext); return RC; }


{WORD} {printf("Word detected!\n"); yylval.node = CreateTokenNode(yylineno, "WORD", TOKEN_OTHERS, yytext); return WORD; }
"+" { yylval.node = CreateTokenNode(yylineno,"PLUS", TOKEN_OTHERS, yytext); return PLUS; }
"-" { yylval.node = CreateTokenNode(yylineno, "MINUS",TOKEN_OTHERS, yytext); return MINUS; }
"*" { yylval.node = CreateTokenNode(yylineno, "MUL",TOKEN_OTHERS, yytext); return MUL; }
"/" { yylval.node = CreateTokenNode(yylineno, "DIV",TOKEN_OTHERS, yytext); return DIV; }
"=" { yylval.node = CreateTokenNode(yylineno, "EQUAL",TOKEN_OTHERS, yytext); return EQUAL; }

"&&" { yylval.node = CreateTokenNode(yylineno, "AND", TOKEN_OTHERS, yytext); return AND; }
"||" { yylval.node = CreateTokenNode(yylineno, "OR", TOKEN_OTHERS, yytext); return OR; }
"!"  { yylval.node = CreateTokenNode(yylineno, "NOT", TOKEN_OTHERS, yytext); return NOT; }
"."  { yylval.node = CreateTokenNode(yylineno, "DOT", TOKEN_OTHERS, yytext); return DOT; }

";" { yylval.node = CreateTokenNode(yylineno, "SEMI", TOKEN_OTHERS, yytext); return SEMI; }
"," { yylval.node = CreateTokenNode(yylineno, "COMMA", TOKEN_OTHERS, yytext); return COMMA; }
{blank} {}
.   { printf("Error type A at Line %d: Mysterious character \'%s\'.\n", yylineno, yytext); }


%%
int yywrap(void){
    return 1;    
}
