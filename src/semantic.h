#ifndef SEMANTIC_H
#define SEMANTIC_H

#define HASH_TABLE_SIZE 0x3fff
#include"node.h"
typedef struct type* Type;
typedef struct fieldList* FieldList;

typedef struct fieldList{
    char* name;
    Type type;
    FieldList *next;
}FieldList;


#endif