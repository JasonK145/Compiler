%{
#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include "node.h"
#include "semantic.h"
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
%token <node> INT FLOAT WORD TYPE
%token <node> RELOP
%token <node> OTHERS
%token <node> LP RP LC RC COMMA
%token <node> PLUS MINUS MUL DIV EQUAL AND OR NOT DOT
%token <node> IF ELSE WHILE RETURN SEMI

/* declarated not-terminal */
%type <node> Program DeclarationList Declaration VarDec FunDec
%type <node> Func VarList Params TypeSpec CompStmt LSStatement
%type <node> LocDec StmtList Stmt ExpStmt SelectStmt LPExpStmt RpSide
%type <node> ElseStmt ItStmt ReStmt Exp SimpleExp AddExp Term Factor Num


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
    
    Program :           DeclarationList                     { $$ = CreateNode(@$.first_line, "Program", TOKEN_NONE, 1, $1); root = $$; };
    
    DeclarationList :   DeclarationList Declaration          { $$ = CreateNode(@$.first_line, "DeclarationList", TOKEN_NONE, 2, $1, $2); }
    |                   Declaration                         { $$ = CreateNode(@$.first_line, "DeclarationList", TOKEN_NONE, 1, $1); };

    Declaration :       VarDec                              { $$ = CreateNode(@$.first_line, "Declaration", TOKEN_NONE, 1, $1); }
    |                   FunDec                              { $$ = CreateNode(@$.first_line, "Declaration", TOKEN_NONE, 1, $1); };

    VarDec :            TypeSpec WORD                       { $$ = CreateNode(@$.first_line, "VarDec", TOKEN_NONE, 2, $1, $2); }
    |                   TypeSpec WORD SEMI                  { $$ = CreateNode(@$.first_line, "VarDec", TOKEN_NONE, 3, $1, $2, $3); };

    FunDec:             TypeSpec WORD Func                  { $$ = CreateNode(@$.first_line, "FunDec", TOKEN_NONE, 3, $1, $2, $3); }
    |                   CompStmt                            { $$ = CreateNode(@$.first_line, "FunDec", TOKEN_NONE, 1, $1); };

    Func:               LP VarList RP                       {  $$ = CreateNode(@$.first_line, "Func", TOKEN_NONE, 3, $1, $2, $3); }
    |                   LP RP                               {  $$ = CreateNode(@$.first_line, "Func", TOKEN_NONE, 2, $1, $2); };
    
    VarList:            Params COMMA VarList                { $$ = CreateNode(@$.first_line, "VarList", TOKEN_NONE, 3, $1, $2, $3); }
    |                   Params                              { $$ = CreateNode(@$.first_line, "VarList", TOKEN_NONE, 1, $1); };

    Params:             TypeSpec VarDec                     { $$ = CreateNode(@$.first_line, "Params", TOKEN_NONE, 2, $1, $2); };

    TypeSpec:           TYPE                                { $$ = CreateNode(@$.first_line, "TypeSpec", TOKEN_NONE, 1, $1);};

    CompStmt:           LC LSStatement RC                  { $$ = CreateNode(@$.first_line, "CompStmt", TOKEN_NONE, 2, $1, $2); };

    LSStatement:       LocDec StmtList                     { $$ = CreateNode(@$.first_line, "LSStatement", TOKEN_NONE, 2, $1, $2); };

    LocDec:             LocDec VarDec                       { $$ = CreateNode(@$.first_line, "LocDec", TOKEN_NONE, 2, $1, $2); }
    |                                                       { $$ = NULL };

    StmtList:           StmtList Stmt                       { $$ = CreateNode(@$.first_line, "StmtList", TOKEN_NONE, 2, $1, $2); }
    |                                                       { $$ = NULL };

    Stmt:               ExpStmt                             { $$ = CreateNode(@$.first_line, "Stmt", TOKEN_NONE, 1, $1); }
    |                   CompStmt                            { $$ = CreateNode(@$.first_line, "Stmt", TOKEN_NONE, 1, $1); }
    |                   SelectStmt                          { $$ = CreateNode(@$.first_line, "Stmt", TOKEN_NONE, 1, $1); }
    |                   ItStmt                              { $$ = CreateNode(@$.first_line, "Stmt", TOKEN_NONE, 1, $1); }
    |                   ReStmt                              { $$ = CreateNode(@$.first_line, "Stmt", TOKEN_NONE, 1, $1); };

    ExpStmt:            Exp SEMI                            { $$ = CreateNode(@$.first_line, "ExpStmt", TOKEN_NONE, 2, $1, $2); };
    
    SelectStmt:         IF LPExpStmt                        { $$ = CreateNode(@$.first_line, "SelectStmt", TOKEN_NONE, 2, $1, $2); };
    
    LPExpStmt:          LP Exp RpSide                       { $$ = CreateNode(@$.first_line, "LPExpStmt", TOKEN_NONE, 3, $1, $2, $3); };

    RpSide:             RP Stmt ElseStmt                    { $$ = CreateNode(@$.first_line, "RpSide", TOKEN_NONE, 3, $1, $2, $3); }
    |                   RP Stmt                             { $$ = CreateNode(@$.first_line, "RpSide", TOKEN_NONE, 2, $1, $2); };

    ElseStmt:           ELSE Stmt                           { $$ = CreateNode(@$.first_line, "ElseStmt", TOKEN_NONE, 2, $1, $2); };

    ItStmt:             WHILE LPExpStmt                     { $$ = CreateNode(@$.first_line, "WhileStmt", TOKEN_NONE, 2, $1, $2); };

    ReStmt:             RETURN Exp SEMI                     { $$ = CreateNode(@$.first_line, "ReStmt", TOKEN_NONE, 3, $1, $2, $3); }
    |                   RETURN SEMI                         { $$ = CreateNode(@$.first_line, "ReStmt", TOKEN_NONE, 2, $1, $2); };

    Exp:                WORD EQUAL Exp                      { $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 3, $1, $2, $3); }
    |                   SimpleExp                          { $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 1, $1); };

    SimpleExp:         AddExp RELOP AddExp                 { $$ = CreateNode(@$.first_line, "SimpleExp", TOKEN_NONE, 3, $1, $2, $3); }
    |                   AddExp                              { $$ = CreateNode(@$.first_line, "SimpleExp", TOKEN_NONE, 1, $1); };

    AddExp:             AddExp PLUS Term                    { $$ = CreateNode(@$.first_line, "AddExp", TOKEN_NONE, 3, $1, $2, $3); }
    |                   AddExp MINUS Term                   { $$ = CreateNode(@$.first_line, "AddExp", TOKEN_NONE, 3, $1, $2, $3); }
    |                   Term                                { $$ = CreateNode(@$.first_line, "AddExp", TOKEN_NONE, 1, $1); };

    Term:               Term MUL Factor                     { $$ = CreateNode(@$.first_line, "Term", TOKEN_NONE, 3, $1, $2, $3); }
    |                   Term DIV Factor                     { $$ = CreateNode(@$.first_line, "Term", TOKEN_NONE, 3, $1, $2, $3); }
    |                   Factor                              { $$ = CreateNode(@$.first_line, "Term", TOKEN_NONE, 1, $1); };

    Factor:             LP Exp RP                           { $$ = CreateNode(@$.first_line, "Factor", TOKEN_NONE, 3, $1, $2, $3); }
    |                   Num                                 { $$ = CreateNode(@$.first_line, "Factor", TOKEN_NONE, 1, $1); }
    |                   WORD                                { $$ = CreateNode(@$.first_line, "Factor", TOKEN_NONE, 1, $1); };

    Num:                INT                                 { $$ = CreateNode(@$.first_line, "Num", TOKEN_NONE, 1, $1); }
    |                   FLOAT                               { $$ = CreateNode(@$.first_line, "Num", TOKEN_NONE, 1, $1); };

   // Args:               Exp COMMA Args                      { $$ = CreateNode(@$.first_line, "Args", TOKEN_NONE, 3, $1, $2, $3); }
    //|                   Exp                                 { $$ = CreateNode(@$.first_line, "Args", TOKEN_NONE, 1, $1); };
    /*
    Declaration :    Declaration Args           { $$ = CreateNode(@$.first_line, "Declaration", TOKEN_NONE, 2, $1, $2); }
    |                Args                       { $$ = CreateNode(@$.first_line, "Declaration", TOKEN_NONE, 1, $1); };

    Args :           Exp COMMA Args             { $$ = CreateNode(@$.first_line, "Args", TOKEN_NONE, 3, $1, $3); }
    |                Exp                        { $$ = CreateNode(@$.first_line, "Args", TOKEN_NONE, 1, $1); };
    
    FunDec:          WORD 
   
   
    Exp :           Exp PLUS Term               { $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 3, $1,$2,$3); }
    |               Exp MINUS Term              { $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 3, $1,$2,$3); }
    |               Exp EQUAL Term              { $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 3, $1,$2,$3); }
    |               Term                        { $$ = CreateNode(@$.first_line, "Exp", TOKEN_NONE, 1, $1); }
    

    Term :          Term MUL Num                { $$ = CreateNode(@$.first_line, "Term", TOKEN_NONE,  3, $1,$2,$3); }
    |               Term DIV Num                { $$ = CreateNode(@$.first_line, "Term", TOKEN_NONE,  3, $1,$2,$3); }
    |               Num                         { $$ = CreateNode(@$.first_line, "Term", TOKEN_NONE, 1, $1); };

    Num :           INT                         { $$ = CreateNode(@$.first_line, "Num", TOKEN_NONE, 1, $1); }
    |               FLOAT                       { $$ = CreateNode(@$.first_line, "Num", TOKEN_NONE, 1, $1); }
    |               LP Exp RP                   { $$ = CreateNode(@$.first_line, "Num", TOKEN_NONE, 3, $1, $3); };
    |               WORD                        { $$ = CreateNode(@$.first_line, "ID", TOKEN_NONE, 1, $1); };
    */
   

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
    traverseTree(root);
    return 0;
}