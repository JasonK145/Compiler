#ifndef SEMANTIC_H
#define SEMANTIC_H

#include"node.h"
//typedef struct type* Type;
/*typedef struct fieldList* FieldList;

enum struct BaseType {INT,FLOAT};

typedef struct fieldList{
    char* name;
     BaseType type;
    FieldList *next;
}FieldList;
*/


void traverseTree(Node* node);
 

void Declaration();
void VarDec();
void FunDec();
void Func();
void VarList();
void Params();
int Specifier(Node* node);
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