#include "inter.h"

boolean interError = FALSE;
pInterCodeList interCodeList;

pOperand newOperand(int kind, ...) {
    pOperand p = (pOperand)malloc(sizeof(Operand));
    assert(p != NULL);
    p->kind = kind;
    va_list vaList;
    assert(kind >= 0 && kind < 6);
    va_start(vaList, 1);
    switch (kind) {
        case OP_CONSTANT:
            p->u.value = va_arg(vaList, int);
            break;
        case OP_VARIABLE:
        case OP_ADDRESS:
        case OP_LABEL:
        case OP_FUNCTION:
        case OP_RELOP:
            p->u.name = va_arg(vaList, char*);
            break;
    }
    return p;
}

void setOperand(pOperand p, int kind, void* val) {
    assert(p != NULL);
    assert(kind >= 0 && kind < 6);
    p->kind = kind;
    switch (kind) {
        case OP_CONSTANT:
            p->u.value = (int)val;
            break;
        case OP_VARIABLE:
        case OP_ADDRESS:
        case OP_LABEL:
        case OP_FUNCTION:
        case OP_RELOP:
            if (p->u.name) free(p->u.name);
            p->u.name = (char*)val;
            break;
    }
}

void deleteOperand(pOperand p) {
    if (p == NULL) return;
    assert(p->kind >= 0 && p->kind < 6);
    switch (p->kind) {
        case OP_CONSTANT:
            break;
        case OP_VARIABLE:
        case OP_ADDRESS:
        case OP_LABEL:
        case OP_FUNCTION:
        case OP_RELOP:
            if (p->u.name) {
                free(p->u.name);
                p->u.name = NULL;
            }
            break;
    }
    free(p);
}

void printOp(FILE* fp, pOperand op) {
    assert(op != NULL);
    if (fp == NULL) {
        switch (op->kind) {
            case OP_CONSTANT:
                printf("#%d", op->u.value);
                break;
            case OP_VARIABLE:
            case OP_ADDRESS:
            case OP_LABEL:
            case OP_FUNCTION:
            case OP_RELOP:
                printf("%s", op->u.name);
                break;
        }
    } else {
        switch (op->kind) {
            case OP_CONSTANT:
                fprintf(fp, "#%d", op->u.value);
                break;
            case OP_VARIABLE:
            case OP_ADDRESS:
            case OP_LABEL:
            case OP_FUNCTION:
            case OP_RELOP:
                fprintf(fp, "%s", op->u.name);
                break;
        }
    }
}

pInterCode newInterCode(int kind, ...) {
    pInterCode p = (pInterCode)malloc(sizeof(InterCode));
    assert(p != NULL);
    p->kind = kind;
    va_list vaList;
    assert(kind >= 0 && kind < 19);
    switch (kind) {
        case IR_LABEL:
        case IR_FUNCTION:
        case IR_ASSIGN:
        case IR_ADD:
        case IR_SUB:
        case IR_MUL:
        case IR_DIV:
            va_start(vaList, 3);
            p->u.binOp.result = va_arg(vaList, pOperand);
            p->u.binOp.op1 = va_arg(vaList, pOperand);
            p->u.binOp.op2 = va_arg(vaList, pOperand);
            break;
    }
    return p;
}

void deleteInterCode(pInterCode p) {
    assert(p != NULL);
    assert(p->kind >= 0 && p->kind < 19);
    switch (p->kind) {
        case IR_LABEL:
        case IR_FUNCTION:
        case IR_ASSIGN:
        case IR_ADD:
        case IR_SUB:
        case IR_MUL:
        case IR_DIV:
            deleteOperand(p->u.binOp.result);
            deleteOperand(p->u.binOp.op1);
            deleteOperand(p->u.binOp.op2);
            break;
    }
    free(p);
}

void printInterCode(FILE* fp, pInterCodeList interCodeList) {
    for (pInterCodes cur = interCodeList->head; cur != NULL; cur = cur->next) {
        assert(cur->code->kind >= 0 && cur->code->kind < 19);
        if (fp == NULL) {
            switch (cur->code->kind) {
                case IR_LABEL:
                    printf("LABEL ");
                    printOp(fp, cur->code->u.oneOp.op);
                    printf(" :");
                    break;
                case IR_FUNCTION:
                    printf("FUNCTION ");
                    printOp(fp, cur->code->u.oneOp.op);
                    printf(" :");
                    break;
                case IR_ASSIGN:
                    printOp(fp, cur->code->u.assign.left);
                    printf(" := ");
                    printOp(fp, cur->code->u.assign.right);
                    break;
                case IR_ADD:
                    printOp(fp, cur->code->u.binOp.result);
                    printf(" := ");
                    printOp(fp, cur->code->u.binOp.op1);
                    printf(" + ");
                    printOp(fp, cur->code->u.binOp.op2);
                    break;
                case IR_SUB:
                    printOp(fp, cur->code->u.binOp.result);
                    printf(" := ");
                    printOp(fp, cur->code->u.binOp.op1);
                    printf(" - ");
                    printOp(fp, cur->code->u.binOp.op2);
                    break;
                case IR_MUL:
                    printOp(fp, cur->code->u.binOp.result);
                    printf(" := ");
                    printOp(fp, cur->code->u.binOp.op1);
                    printf(" * ");
                    printOp(fp, cur->code->u.binOp.op2);
                    break;
                case IR_DIV:
                    printOp(fp, cur->code->u.binOp.result);
                    printf(" := ");
                    printOp(fp, cur->code->u.binOp.op1);
                    printf(" / ");
                    printOp(fp, cur->code->u.binOp.op2);
                    break;
            }
            printf("\n");
        } else {
            switch (cur->code->kind) {
                case IR_LABEL:
                    fprintf(fp, "LABEL ");
                    printOp(fp, cur->code->u.oneOp.op);
                    fprintf(fp, " :");
                    break;
                case IR_FUNCTION:
                    fprintf(fp, "FUNCTION ");
                    printOp(fp, cur->code->u.oneOp.op);
                    fprintf(fp, " :");
                    break;
                case IR_ASSIGN:
                    printOp(fp, cur->code->u.assign.left);
                    fprintf(fp, " := ");
                    printOp(fp, cur->code->u.assign.right);
                    break;
                case IR_ADD:
                    printOp(fp, cur->code->u.binOp.result);
                    fprintf(fp, " := ");
                    printOp(fp, cur->code->u.binOp.op1);
                    fprintf(fp, " + ");
                    printOp(fp, cur->code->u.binOp.op2);
                    break;
                case IR_SUB:
                    printOp(fp, cur->code->u.binOp.result);
                    fprintf(fp, " := ");
                    printOp(fp, cur->code->u.binOp.op1);
                    fprintf(fp, " - ");
                    printOp(fp, cur->code->u.binOp.op2);
                    break;
                case IR_MUL:
                    printOp(fp, cur->code->u.binOp.result);
                    fprintf(fp, " := ");
                    printOp(fp, cur->code->u.binOp.op1);
                    fprintf(fp, " * ");
                    printOp(fp, cur->code->u.binOp.op2);
                    break;
                case IR_DIV:
                    printOp(fp, cur->code->u.binOp.result);
                    fprintf(fp, " := ");
                    printOp(fp, cur->code->u.binOp.op1);
                    fprintf(fp, " / ");
                    printOp(fp, cur->code->u.binOp.op2);
                    break;
            }
            fprintf(fp, "\n");
        }
    }
}

// InterCodes func
pInterCodes newInterCodes(pInterCode code) {
    pInterCodes p = (pInterCodes)malloc(sizeof(InterCodes));
    assert(p != NULL);
    p->code = code;
    p->prev = NULL;
    p->next = NULL;
}

void deleteInterCodes(pInterCodes p) {
    assert(p != NULL);
    deleteInterCode(p->code);
    free(p);
}
pInterCodeList newInterCodeList() {
    pInterCodeList p = (pInterCodeList)malloc(sizeof(InterCodeList));
    p->head = NULL;
    p->cur = NULL;
    p->tempVarNum = 1;
    p->labelNum = 1;
}

void deleteInterCodeList(pInterCodeList p) {
    assert(p != NULL);
    pInterCodes q = p->head;
    while (q) {
        pInterCodes temp = q;
        q = q->next;
        deleteInterCodes(temp);
    }
    free(p);
}

void addInterCode(pInterCodeList interCodeList, pInterCodes newCode) {
    if (interCodeList->head == NULL) {
        interCodeList->head = newCode;
        interCodeList->cur = newCode;
    } else {
        interCodeList->cur->next = newCode;
        newCode->prev = interCodeList->cur;
        interCodeList->cur = newCode;
    }
}
