#include "semantic.h"

void traverseTree(Node* node){
    if(node == NULL) return;
    printf("Enter traverseTree!     Type: ");
    printf("%s\n",node->name);
    
    if(!strcmp(node->name,"Declaration")) Declaration(node);

    traverseTree(node->CHILD_NODE[0]);
    traverseTree(node->CHILD_NODE[1]);
    traverseTree(node->CHILD_NODE[2]);
   
}

void Declaration(Node* node){
    assert(node != NULL);
    
    Node* curNode = node;
    printf("%s\n",curNode->CHILD_NODE[0]->name);
    if(!strcmp(curNode->CHILD_NODE[0]->name,"VarDec")){
        //向typeSpec發送請求，typeSpec返回0 or 1 0=INT 1=float
        //向varDec發送請求，varDec返回name
        VarDec(curNode->CHILD_NODE[0]);
       
    }
    else{
        
    }
}

void VarDec(Node* node){
    assert(node != NULL);
    Node* curNode = node;
    printf("%s\n",curNode->CHILD_NODE[0]->name);
    if(!strcmp(curNode->CHILD_NODE[0]->name,"TypeSpec")){
        //檢查符號表有沒有重複
        //放到符號表
        int type = TypeSpec(curNode->CHILD_NODE[0]);
        printf("%d",type);
        char* id = curNode->val;
    }
    else{
        int type = TypeSpec(curNode);
    }

}

void FuncDec(Node* node){
    assert(node!=NULL);
    Node* curNode = node;
    if(curNode->CHILD_NODE[1]!=NULL){
        
    }
    else if(!strcmp(curNode->CHILD_NODE[0],"")){
        
    }
}

int TypeSpec(Node* node){
    printf("Enter TypeSpec\n");
    printf("        HERE is %s\n",node->name);
    printf("        %s\n",node->CHILD_NODE[0]->name);
    printf("        %s",node->CHILD_NODE[0]->val);
    assert(node != NULL);
    Node* curNode = node;
    char* ntype = curNode->CHILD_NODE[0]->val;
    
}