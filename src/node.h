#ifndef NODE_H
#define NODE_H
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

typedef enum typeNode{
    TOKEN_INT = 1,
    TOKEN_FLOAT,
    TOKEN_ID,
    TOKEN_TYPE,
    TOKEN_OTHERS,
    TOKEN_NONE
}TypeNode;


typedef enum Sort {BASIC, ARRAY, STRUCTURE, FUNCTION }Sort;
typedef enum TypeBasic {TYPE_INT, TYPE_FLOAT}BasicType;

typedef struct node{
    int no_line;
    char* name;
    char* val;
    TypeNode type;
    struct node* CHILD_NODE[3];

}Node;

static Node* CreateNode(int no_line, char* name, TypeNode type, int now, ...){
    Node* curNode = (Node*)malloc(sizeof(Node));
    int len  = strlen(name);
    curNode->name = (char*)malloc(sizeof(char)*(len+1));
    assert(curNode!=NULL);
    assert(curNode->name!=NULL);
    //int nameLen = name.length();
    curNode->name = name;
    curNode->no_line = no_line;
    curNode->type = type;
    

    va_list vaList;
    va_start(vaList, now); 

    for(int i = 0; i<3; i++){
        curNode->CHILD_NODE[i]= NULL;   
    }
    for (int i = 0; i < now; i++){
        curNode->CHILD_NODE[i] = va_arg(vaList,struct node*);
    }
    va_end(vaList);
    return curNode;
    
}

static Node* CreateTokenNode(int no_line, char* name, TypeNode type, char* val){
    Node* curNode = (Node*)malloc(sizeof(Node));
    int lenOfName = strlen(name);
    int lenOfVal = strlen(val);
    curNode->name = (char*)malloc(sizeof(char) * (lenOfName + 1));
    curNode->val = (char*)malloc(sizeof(char) * (lenOfVal + 1));
    assert(curNode!=NULL);
    assert(curNode->name!=NULL);
    assert(curNode->val!=NULL);

    curNode->name = name;
    curNode->no_line = no_line;
    curNode->type = type;
    curNode->val = val;

    for (int i=0; i<3; i++){
        curNode->CHILD_NODE[i] = NULL; 
    }
    return curNode;
}

static void tree (Node* node, int height){
    if (node == NULL) {
        return;
    }
 
    for (int i = 0; i < height; i++) {
        printf("  ");
    }
     printf("%s", node->name);
    if (node->type == TOKEN_NONE) {
        printf(" (%d)", node->no_line);
    } else if (node->type == TOKEN_TYPE || node->type == TOKEN_ID ||
               node->type == TOKEN_INT) {
        printf(": %s", node->val);
    } else if (node->type == TOKEN_FLOAT) {
        printf(": %lf", atof(node->val));
    }
    printf("\n");
    height++;
    tree(node->CHILD_NODE[0], height);
    tree(node->CHILD_NODE[1], height);
    tree(node->CHILD_NODE[2], height);
}












#endif