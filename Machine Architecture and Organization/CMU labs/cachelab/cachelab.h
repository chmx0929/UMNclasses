/* 
 * cachelab.h - Prototypes for Cache Lab helper functions
 */

#ifndef CACHELAB_TOOLS_H
#define CACHELAB_TOOLS_H

#define MAX_TRANS_FUNCS 100

typedef struct trans_func{
  void (*func_ptr)(int M,int N,int[M][N], int s, int E, int b);
  char* description;
  char correct;
  unsigned int num_hits;
  unsigned int num_misses;
  unsigned int num_evictions;
} trans_func_t;

/* 
 * printSummary - This function provides a standard way for your cache
 * simulator * to display its final hit and miss statistics
 */ 
void printSummary(int hits,  /* number of  hits */
				  int misses, /* number of misses */
				  int evictions); /* number of evictions */

/* Fill the matrix with data */
void initMatrix(int M, int N, int A[M][N]);

/* The baseline trans function that produces correct results. */
void correctTrans(int M, int N, int A[M][N], int s, int E, int b);

/* Add the given function to the function list */
void registerTransFunction(
    void (*trans)(int M,int N,int[M][N], int s, int E, int b), char* desc);

#endif /* CACHELAB_TOOLS_H */
