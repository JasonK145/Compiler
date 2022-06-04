%{
#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include "node.h"
#define YYERROR_VERBOSE 1
Node* root;

void yyerror(char* s){
    printf("error occured!\n");
}
int yylex();

%}

/* declared types */
%union{
    Node* node;
}

/* declared tokens */
%token <node> INT FLOAT
%token <node> RELOP
%token <node> OTHERS WORD
%token <node> LP RP COMMA
%token <node> PLUS MINUS MUL DIV EQUAL
%token <node> IF ELSE WHILE RETURN

/* declarated not-terminal */
%type <node> Program Exp Declaration Term Num


%%
    /*
    program : exp ENTER { $$ = CreateNode(@$.first_line, "program", TOKEN_NONE, 2, $1,$2); root = $$; }

    exp:exp PLUS term { $$ = CreateNode(@$.first_line, "exp", TOKEN_NONE, 3, $1,$2,$3); }
        | exp MINUS term {$$ = CreateNode(@$.first_line, "exp", TOKEN_NONE,  3, $1,$2,$3);}
        | term      {$$ = CreateNode(@$.first_line, "exp", TOKEN_NONE, 1, $1);};
    
    term:term MUL factor {$$ = CreateNode(@$.first_line, "term", TOKEN_NONE,  3, $1,$2,$3);}
        | term DIV factor {$$ = CreateNode(@$.first_line, "term", TOKEN_NONE, 3, $1,$2,$3);}
        | factor { $$ = CreateNode(@$.first_line, "term", TOKEN_NONE, 1, $1); };


    factor:  Num { $$ = CreateNode(@$.first_line, "factor", TOKEN_NONE, 1, $1); }

    Num : NUMBER { $$ = CreateNode(@$.first_line, "Num", TOKEN_NONE, 1, $1); }
    */
    
    Program :        Declaration                { $$ = CreateNode(@$.first_line, "Program", TOKEN_NONE, 1, $1); root = $$; };
    
    Declaration :    Declaration Exp            { $$ = CreateNode(@$.first_line, "Declaration", TOKEN_NONE, 2, $1, $2); }
    |                Exp                        { $$ = CreateNode(@$.first_line, "Declaration", TOKEN_NONE, 1, $1); };

    Exp :   Exp PLUS Term                       { $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 3, $1,$2,$3); }
    |       Exp MINUS Term                      { $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 3, $1,$2,$3); }
    |       Term                                { $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 1, $1); }
    |       WORD                                { $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 1, $1); };

    Term :  Term MUL Num                        { $$ = CreateNode(@$.first_line, "Term", TOKEN_NONE,  3, $1,$2,$3); }
    |       Term DIV Num                        { $$ = CreateNode(@$.first_line, "Term", TOKEN_NONE,  3, $1,$2,$3); }
    |       Num                                 { $$ = CreateNode(@$.first_line, "Term", TOKEN_NONE, 1, $1); };

    Num :       INT                             { printf("Num\n"); $$ = CreateNode(@$.first_line, "Num", TOKEN_NONE, 1, $1); }
    |           FLOAT                           { $$ = CreateNode(@$.first_line, "Num", TOKEN_NONE, 1, $1); }
    |           LP Exp RP                       { $$ = CreateNode(@$.first_line, "Num", TOKEN_NONE, 3, $1, $3); };

  /*  
    Declaration :   Declaration Exp { $$ = CreateNode(@$.first_line, "Declaration", TOKEN_NONE, 2, $1, $2); }
    |               Exp     { $$ = CreateNode(@$.first_line, "Declaration", TOKEN_NONE, 1, $1); };

    Exp :   Exp PLUS Term       { $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 3, $1,$2,$3); }
    |       Exp MINUS Term      { $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 3, $1,$2,$3); }
    |       Term                { printf("Exp!\n"); $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 1, $1); }
    |       WORD                { printf("!!!"); $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 1, $1); };

  /*  Args :      Exp COMMA Args  { $$ = CreateNode(@$.first_line, "Args", TOKEN_NONE, 3, $1, $3); }
    |           Exp             { $$ = CreateNode(@$.first_line, "Args", TOKEN_NONE, 1, $1); };     
    
    Term :  Term MUL Factor     { $$ = CreateNode(@$.first_line, "Term", TOKEN_NONE,  3, $1,$2,$3); }
    |       Term DIV Factor     { $$ = CreateNode(@$.first_line, "Term", TOKEN_NONE,  3, $1,$2,$3); }
    |       Factor                { printf("Term\n"); $$ = CreateNode(@$.first_line, "Term", TOKEN_NONE, 1, $1); printf("Term done!\n");};

    Factor : Num { $$ = CreateNode(@$.first_line, "Factor", TOKEN_NONE, 1, $1); };

    Num :       INT             { printf("Num\n"); $$ = CreateNode(@$.first_line, "Num", TOKEN_NONE, 1, $1); }
    |           FLOAT           { $$ = CreateNode(@$.first_line, "Num", TOKEN_NONE, 1, $1); }
    |           LP Exp RP       { $$ = CreateNode(@$.first_line, "Num", TOKEN_NONE, 3, $1, $3); }; */


%%



extern int yylineno;
extern void yyrestart(FILE*);

int main(int argc, char** argv) {
    if (argc <= 1) {
        yyparse();
        return 1;
    }

    FILE* f = fopen(argv[1], "r");
    if (!f) {
        perror(argv[1]);
        return 1;
    }
    yyrestart(f);
    yyparse();
    printf("before tree\n");
    tree(root, 0);
    printf("after tree!!\n");
    return 0;
}