#ifndef PROJECT_H
#define PROJECT_H

#include "node.h"
#include "semantic.h"

typedef struct _operand* pOperand;
typedef struct _interCode* pInterCode;
typedef struct _interCodes* pInterCodes;
typedef struct _interCodeList* pInterCodeList;

typedef struct _operand {
    enum {
        OP_VARIABLE,
        OP_CONSTANT,
        OP_ADDRESS,
        OP_LABEL,
        OP_FUNCTION,
        OP_RELOP,
    } kind;

    union {
        int value;
        char* name;
    } u;

} Operand;

typedef struct _interCode {
    enum {
        IR_LABEL,
        IR_FUNCTION,
        IR_ASSIGN,
        IR_ADD,
        IR_SUB,
        IR_MUL,
        IR_DIV,
        
    } kind;

    union {
        struct {
            pOperand op;
        } oneOp;
        struct {
            pOperand right, left;
        } assign;
        struct {
            pOperand result, op1, op2;
        } binOp;
    } u;
} InterCode;

typedef struct _interCodes {
    pInterCode code;
    pInterCodes *prev, *next;
} InterCodes;

typedef struct _interCodeList {
    pInterCodes head;
    pInterCodes cur;
    int tempVarNum;
    int labelNum;
} InterCodeList;

extern boolean interError;
extern pInterCodeList interCodeList;
pOperand newOperand(int kind, ...);
void deleteOperand(pOperand p);
void setOperand(pOperand p, int kind, void* val);
void printOp(FILE* fp, pOperand op);
pInterCode newInterCode(int kind, ...);
void deleteInterCode(pInterCode p);
void printInterCode(FILE* fp, pInterCodeList interCodeList);
pInterCodes newInterCodes(pInterCode code);
void deleteInterCodes(pInterCodes p);
pInterCodeList newInterCodeList();
void deleteInterCodeList(pInterCodeList p);
void addInterCode(pInterCodeList interCodeList, pInterCodes newCode);

#endif