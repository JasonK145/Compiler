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