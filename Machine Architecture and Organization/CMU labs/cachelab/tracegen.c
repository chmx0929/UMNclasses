/* 
 * tracegen.c - Running the binary tracegen with valgrind produces
 * a memory trace of all of the registered matrix wavefront functions. 
 * 
 * The beginning and end of each registered matrix wavefront function's trace
 * is indicated by reading from "marker" addresses. These two marker
 * addresses are recorded in file for later use.
 */

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <unistd.h>
#include <getopt.h>
#include "cachelab.h"
#include <string.h>

/* External variables declared in cachelab.c */
extern trans_func_t func_list[MAX_TRANS_FUNCS];
extern int func_counter; 

/* External function from trans.c */
extern void registerFunctions();

/* Markers used to bound trace regions of interest */
volatile char MARKER_START, MARKER_END;

static int A[1024][1024];
static int C[1024][1024];
static int M;
static int N;
static int s;
static int E;
static int b;

int check(int fn, int M, int N, int C[M][N], int A[M][N])
{
	for(int i=0;i<M;i++) {
		for(int j=0;j<N;j++) {
			if(C[i][j]!= A[i][j]) {
				printf("Validation failed on function %d! Expected %d but got %d at A[%d][%d]\n",fn,C[i][j],A[i][j],i,j);
				return 0;
			}
		}
	}
	return 1;
}

int validate(int fn,int M, int N, int A[M][N], int s, int E, int b) {
    correctTrans(M,N,C,s,E,b);

    return check(fn, M,N,C,A);
}

int main(int argc, char* argv[]){
    int i;

    char c;
    int selectedFunc=-1;
    while( (c=getopt(argc,argv,"M:N:s:E:b:F:")) != -1){
        switch(c){
        case 'M':
            M = atoi(optarg);
            break;
        case 'N':
            N = atoi(optarg);
            break;
        case 's':
            s = atoi(optarg);
            break;
        case 'E':
            E = atoi(optarg);
            break;
        case 'b':
            b = atoi(optarg);
            break;
        case 'F':
            selectedFunc = atoi(optarg);
            break;
        case '?':
        default:
            printf("./tracegen failed to parse its options.\n");
            exit(1);
        }
    }
  

    /*  Register matrix wavefront functions */
    registerFunctions();

    /* Fill A with data */
    initMatrix(M,N, A);
    
    /* making a copy of the initialized matrix, which can be used later for generating expected values */ 
    memcpy(C, A, (sizeof(int) * M * N));

    /* Record marker addresses */
    FILE* marker_fp = fopen(".marker","w");
    assert(marker_fp);
    fprintf(marker_fp, "%llx %llx", 
            (unsigned long long int) &MARKER_START,
            (unsigned long long int) &MARKER_END );
    fclose(marker_fp);

    if (-1==selectedFunc) {
        /* Invoke registered matrix wavefront functions */
        for (i=0; i < func_counter; i++) {
            MARKER_START = 33;
            (*func_list[i].func_ptr)(M, N, A, s, E, b);
            MARKER_END = 34;
            if (!validate(i,M,N,A, s, E, b))
                return i+1;
        }
    } else {
        MARKER_START = 33;
        (*func_list[selectedFunc].func_ptr)(M, N, A, s, E, b);
        MARKER_END = 34;
        if (!validate(selectedFunc,M,N,A, s, E, b))
            return selectedFunc+1;

    }
    return 0;
}


