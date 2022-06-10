#ifndef SEMANTIC_H
#define SEMANTIC_H

#include"node.h"
//typedef struct type* Type;
typedef struct fieldList* pFieldList;

//enum struct BaseType {INT,FLOAT};

typedef struct fieldList{
    char* name;
    int type;
    pFieldList next;
}FieldList;




void traverseTree(Node* node);
 

void Declaration(Node* node);
void VarDec();
void FunDec();
void Func();
void VarList();
void Params();
int TypeSpec(Node* node);
void CompStmt();
void LSStatement();
void LocDec();
void StmtList();
void Stmt();
void ExpStmt();
void SelectStmt();
void LPExpStmt();
void RpSide();
void ElseStmt();
void ItStmt();
void ReStmt();
void Exp();
void SimpleExp();
void AppExp();
void Term();
void Factor();
void Num();




#endif