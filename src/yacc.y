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
%token <node> NUMBER
%token <node> ENTER
%token <node> OTHERS WORD
%token <node> PLUS MINUS MUL DIV EQUAL

/* declarated not-terminal */
%type <node> program exp term factor Num


%%
    // program : exp ENTER {printf("%d\n",$1);}

    // exp:exp PLUS term { $$ = $1 + $3;}
    //     | exp MINUS term {$$ = $1 - $3;}
    //     | term      {$$ = $1};
    
    // term:term MUL factor {$$ = $1 * $3;}
    //     | term DIV factor {$$ = $1 / $3;}
    //     | factor {$$ = $1;};

    // // factor: '^' Num {$$ = -$2}
    // //     | Num '^' Num {$$ = pow($1,$3);}
    // //     | Num {$$ = $1;};

    // factor:  Num {$$ = $1}

    // Num : NUMBER { $$ = CreateNode(@$.first_line, "Num", TOKEN_INT,1,$1); }


    program : exp ENTER { $$ = CreateNode(@$.first_line, "program", TOKEN_NONE, 2, $1,$2); root = $$; }

    exp:exp PLUS term { $$ = CreateNode(@$.first_line, "exp", TOKEN_NONE, 3, $1,$2,$3); }
        | exp MINUS term {$$ = CreateNode(@$.first_line, "exp", TOKEN_NONE,  3, $1,$2,$3);}
        | term      {$$ = CreateNode(@$.first_line, "exp", TOKEN_NONE, 1, $1);};
    
    term:term MUL factor {$$ = CreateNode(@$.first_line, "term", TOKEN_NONE,  3, $1,$2,$3);}
        | term DIV factor {$$ = CreateNode(@$.first_line, "term", TOKEN_NONE, 3, $1,$2,$3);}
        | factor { $$ = CreateNode(@$.first_line, "term", TOKEN_NONE, 1, $1); };

    // factor: '^' Num {$$ = -$2}
    //     | Num '^' Num {$$ = pow($1,$3);}
    //     | Num {$$ = $1;};

    factor:  Num { $$ = CreateNode(@$.first_line, "factor", TOKEN_NONE, 1, $1); }

    Num : NUMBER { $$ = CreateNode(@$.first_line, "Num", TOKEN_NONE, 1, $1); }

    
    // program : declaration-list

    // declaration-list : declaration-list declaration
    //     | declaration

    // declaration : var-declaration 
    //     | fun-declaration
    
    // var-declaration : type-specifier ID;
    //     | type specifier ID [ NUM ];

    // type-specifier : int
    //     | void
    
    // fun-declaration : type-specifier ID ( params ) 
    //     | compound-stmt
    
    // params : params-list
    //     | void

    // param-list : param-list , param
    //     | param

    
%%



// int main(){
//     return yyparse();
// }


extern int yylineno;
extern void yyrestart(FILE*);

int main(int argc, char** argv) {
    if (argc < 2) {
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
    return 0;
}