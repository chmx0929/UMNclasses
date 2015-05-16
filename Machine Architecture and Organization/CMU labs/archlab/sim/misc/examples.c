typedef struct elem {
    int data;
    struct elem *left;
    struct elem *right;
} node;

node* search(node *tree, int val) {
   if(!tree) {
      return NULL;
   }
   if(val == tree->data) {
      return tree;
   } else if(val < tree->data) {
      return search(tree->left, val);
   } else if(val > tree->data){
      return search(tree->right, val);
   }
}

void matrix_xor(int size, int A[size][size], int B[size][size], int C[size][size])  {
   int i, j, k, sum;

   for(i=0;i<size;i++){ 
      for(j=0;j<size;j++){  
         sum=0;
         for(k=0;k<size;k++)
            sum=sum+(A[i][k]^B[k][j]);
         C[i][j]=sum;
      }
  }
}