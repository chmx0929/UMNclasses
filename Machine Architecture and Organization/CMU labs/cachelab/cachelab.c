/*
 * cachelab.c - Cache Lab helper functions
 */
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "cachelab.h"
#include <time.h>

trans_func_t func_list[MAX_TRANS_FUNCS];
int func_counter = 0; 

/* 
 * printSummary - Summarize the cache simulation statistics. Student cache simulators
 *                must call this function in order to be properly autograded. 
 */
void printSummary(int hits, int misses, int evictions)
{
    printf("hits:%d misses:%d evictions:%d\n", hits, misses, evictions);
    FILE* output_fp = fopen(".csim_results", "w");
    assert(output_fp);
    fprintf(output_fp, "%d %d %d\n", hits, misses, evictions);
    fclose(output_fp);
}

/* 
 * initMatrix - Initialize the given matrix 
 */
void initMatrix(int M, int N, int A[M][N])
{
    int i, j;
    srand(time(NULL));
    for (i = 0; i < M; i++){
        for (j = 0; j < N; j++){
            A[i][j]=rand()%1000;
        }
    }
}

void randMatrix(int M, int N, int A[N][M]) {
    int i, j;
    srand(time(NULL));
    for (i = 0; i < N; i++){
        for (j = 0; j < M; j++){
            A[i][j]=rand();
        }
    }
}

/* 
 * correctTrans - baseline matrix wavefront function used to evaluate correctness 
 */
void correctTrans(int M, int N, int A[M][N], int s, int E, int b)
{
    int i, j;
    for (i = 1; i < N; i++){
        for (j = 1; j < M; j++){
            A[i][j] = A[i-1][j-1] + A[i-1][j] + A[i][j-1];
        }
    }
}



/* 
 * registerTransFunction - Add the given trans function into your list
 *     of functions to be tested
 */
void registerTransFunction(void (*trans)(int M, int N, int[M][N], int s, int E, int b), 
                           char* desc)
{
    func_list[func_counter].func_ptr = trans;
    func_list[func_counter].description = desc;
    func_list[func_counter].correct = 0;
    func_list[func_counter].num_hits = 0;
    func_list[func_counter].num_misses = 0;
    func_list[func_counter].num_evictions =0;
    func_counter++;
}
