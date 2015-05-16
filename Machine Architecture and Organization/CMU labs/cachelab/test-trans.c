/*
 * test-trans.c - Checks the correctness and performance of all of the
 *     student's matrix wavefront transport functions and records the results for their
 *     official submitted version as well.
 */
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <getopt.h>
#include <sys/types.h>
#include "cachelab.h"
#include <sys/wait.h> // fir WEXITSTATUS
#include <limits.h> // for INT_MAX

/* Maximum array dimension */
#define MAXN 1024

/* The description string for the matrix_wavefront_submit() function that the
   student submits for credit */
#define SUBMIT_DESCRIPTION "Matrix Wavefront submission"

/* External function defined in trans.c */
extern void registerFunctions();

/* External variables defined in cachelab-tools.c */
extern trans_func_t func_list[MAX_TRANS_FUNCS];
extern int func_counter; 

/* Globals set on the command line */
static int M = 0;
static int N = 0;
static int s = 0;
static int E = 0;
static int b = 0;

/* The correctness and performance for the submitted matrix wavefront function */
struct results {
    int funcid;
    int correct;
    int misses;
};
static struct results results = {-1, 0, INT_MAX};

/* 
 * eval_perf - Evaluate the performance of the registered matrix wavefront functions
 */
void eval_perf(unsigned int s, unsigned int E, unsigned int b)
{
    int i,flag;
    unsigned int len, hits, misses, evictions;
    unsigned long long int marker_start, marker_end, addr;
    char buf[1000], cmd[1023];
    char filename[128];

    registerFunctions(); 

    /* Open the complete trace file */
    FILE* full_trace_fp;  
    FILE* part_trace_fp; 

    /* Evaluate the performance of each registered matrix wavefront function */

    for (i=0; i<func_counter; i++) {
        if (strcmp(func_list[i].description, SUBMIT_DESCRIPTION) == 0 )
            results.funcid = i; /* remember which function is the submission */


        printf("\nFunction %d (%d total)\nStep 1: Validating and generating memory traces\n",i,func_counter);
        /* Use valgrind to generate the trace */

       sprintf(cmd, "valgrind --tool=lackey --trace-mem=yes --log-fd=1 -v ./tracegen -M %d -N %d -s %d -E %d -b %d -F %d  > trace.tmp", M, N,s,E,b,i);
        flag=WEXITSTATUS(system(cmd));
        if (0!=flag) {
            printf("Validation error at function %d! Run ./tracegen -M %d -N %d -s %d -E %d -b %d -F %d for details.\nSkipping performance evaluation for this function.\n",flag-1,M,N,s,E,b,i);      
            continue;
        }

        /* Get the start and end marker addresses */
        FILE* marker_fp = fopen(".marker", "r");
        assert(marker_fp);
        fscanf(marker_fp, "%llx %llx", &marker_start, &marker_end);
        fclose(marker_fp);


        func_list[i].correct=1;

        /* Save the correctness of the matrix wavefront submission */
        if (results.funcid == i ) {
            results.correct = 1;
        }

        full_trace_fp = fopen("trace.tmp", "r");
        assert(full_trace_fp);


        /* Filtered trace for each matix wavefront function goes in a separate file */
        sprintf(filename, "trace.f%d", i);
        part_trace_fp = fopen(filename, "w");
        assert(part_trace_fp);
    
        /* Locate trace corresponding to the trans function */
        flag = 0;
        while (fgets(buf, 1000, full_trace_fp) != NULL) {

            /* We are only interested in memory access instructions */
            if (buf[0]==' ' && buf[2]==' ' &&
                (buf[1]=='S' || buf[1]=='M' || buf[1]=='L' )) {
                sscanf(buf+3, "%llx,%u", &addr, &len);
        
                /* If start marker found, set flag */
                if (addr == marker_start)
                    flag = 1;

                /* Valgrind creates many spurious accesses to the
                   stack that have nothing to do with the students
                   code. At the moment, we are ignoring all stack
                   accesses by using the simple filter of recording
                   accesses to only the low 32-bit portion of the
                   address space. At some point it would be nice to
                   try to do more informed filtering so that would
                   eliminate the valgrind stack references while
                   include the student stack references. */
                if (flag && addr < 0xffffffff) {
                    fputs(buf, part_trace_fp);
                }

                /* if end marker found, close trace file */
                if (addr == marker_end) {
                    flag = 0;
                    fclose(part_trace_fp);
                    break;
                }
            }
        }
        fclose(full_trace_fp);

        /* Run the reference simulator */
        printf("Step 2: Evaluating performance (s=%d, E=%d, b=%d)\n", s, E, b);
        char cmd[1023];
        sprintf(cmd, "./csim-ref -s %u -E %u -b %u -t trace.f%d > /dev/null", 
                s, E, b, i);
        system(cmd);
    
        /* Collect results from the reference simulator */
        FILE* in_fp = fopen(".csim_results","r");
        assert(in_fp);
        fscanf(in_fp, "%u %u %u", &hits, &misses, &evictions);
        fclose(in_fp);
        func_list[i].num_hits = hits;
        func_list[i].num_misses = misses;
        func_list[i].num_evictions = evictions;
        printf("func %u (%s): hits:%u, misses:%u, evictions:%u\n",
               i, func_list[i].description, hits, misses, evictions);
    
        /* If it is matrix_wavefront_submit(), record number of misses */
        if (results.funcid == i) {
            results.misses = misses;
        }
    }
  
}


void eval_perf_new(unsigned int s, unsigned int E, unsigned int b)
{
    int i,flag;
    unsigned int len, hits, misses, evictions;
    unsigned long long int marker_start, marker_end, addr;
    char buf[1000], cmd[1023];
    char filename[128];
   
    func_counter = 0;  //so that next time the func_counter starts from 0 only
    registerFunctions(); 

    /* Open the complete trace file */
    FILE* full_trace_fp;  
    FILE* part_trace_fp; 

    /* Evaluate the performance of each registered matrix wavefront function */

    for (i=0; i<func_counter; i++) {
        if (strcmp(func_list[i].description, SUBMIT_DESCRIPTION) == 0 )
            results.funcid = i; /* remember which function is the submission */


        printf("\nFunction %d (%d total)\nStep 1: Validating and generating memory traces\n",i,func_counter);
        /* Use valgrind to generate the trace */

       sprintf(cmd, "valgrind --tool=lackey --trace-mem=yes --log-fd=1 -v ./tracegen -M %d -N %d -s %d -E %d -b %d -F %d > trace.tmp", M, N,s,E,b,i);
        flag=WEXITSTATUS(system(cmd));
        if (0!=flag) {
            printf("Validation error at function %d! Run ./tracegen -M %d -N %d -s %d -E %d -b %d -F %d for details.\nSkipping performance evaluation for this function.\n",flag-1,M,N,s,E,b,i);      
            continue;
        }

        /* Get the start and end marker addresses */
        FILE* marker_fp = fopen(".marker", "r");
        assert(marker_fp);
        fscanf(marker_fp, "%llx %llx", &marker_start, &marker_end);
        fclose(marker_fp);


        func_list[i].correct=1;

        /* Save the correctness of the matrix wavefront submission */
        if (results.funcid == i ) {
            results.correct = 1;
        }

        full_trace_fp = fopen("trace.tmp", "r");
        assert(full_trace_fp);


        /* Filtered trace for each matix wavefront function goes in a separate file */
        sprintf(filename, "trace.f%d", i);
        part_trace_fp = fopen(filename, "w");
        assert(part_trace_fp);
    
        /* Locate trace corresponding to the trans function */
        flag = 0;
        while (fgets(buf, 1000, full_trace_fp) != NULL) {

            /* We are only interested in memory access instructions */
            if (buf[0]==' ' && buf[2]==' ' &&
                (buf[1]=='S' || buf[1]=='M' || buf[1]=='L' )) {
                sscanf(buf+3, "%llx,%u", &addr, &len);
        
                /* If start marker found, set flag */
                if (addr == marker_start)
                    flag = 1;

                /* Valgrind creates many spurious accesses to the
                   stack that have nothing to do with the students
                   code. At the moment, we are ignoring all stack
                   accesses by using the simple filter of recording
                   accesses to only the low 32-bit portion of the
                   address space. At some point it would be nice to
                   try to do more informed filtering so that would
                   eliminate the valgrind stack references while
                   include the student stack references. */
                if (flag && addr < 0xffffffff) {
                    fputs(buf, part_trace_fp);
                }

                /* if end marker found, close trace file */
                if (addr == marker_end) {
                    flag = 0;
                    fclose(part_trace_fp);
                    break;
                }
            }
        }
        fclose(full_trace_fp);

        /* Run the reference simulator */
        printf("Step 2: Evaluating performance (s=%d, E=%d, b=%d)\n", s, E, b);
        char cmd[1023];
        sprintf(cmd, "./csim-ref -s %u -E %u -b %u -t trace.f%d > /dev/null", 
                s, E, b, i);
        system(cmd);
    
        /* Collect results from the reference simulator */
        FILE* in_fp = fopen(".csim_results","r");
        assert(in_fp);
        fscanf(in_fp, "%u %u %u", &hits, &misses, &evictions);
        fclose(in_fp);
        func_list[i].num_hits = hits;
        func_list[i].num_misses = misses;
        func_list[i].num_evictions = evictions;
        printf("func %u (%s): hits:%u, misses:%u, evictions:%u\n",
               i, func_list[i].description, hits, misses, evictions);
    
        /* If it is matrix_wavefront_submit(), record number of misses */
        if (results.funcid == i) {
            results.misses = misses;
        }
    }
  
}

/*
 * usage - Print usage info
 */
void usage(char *argv[]){
    printf("Usage: %s [-h] -M <rows> -N <cols> -s <number of sets> -E <associativity> -b <block size>\n", argv[0]);
    printf("Options:\n");
    printf("  -h          Print this help message.\n");
    printf("  -M <rows>   Number of matrix rows (should be %d)\n",256);
    printf("  -N <cols>   Number of  matrix columns (should be %d)\n", 256);
    printf("  -s <cols>   2 ^ s - Number of cache sets (for 512B cache %d and for 4KB cache %d)\n", 5, 8);
    printf("  -E <cols>   Set associativity of cache  (fixed at %d)\n", 2);
    printf("  -b <cols>   Number of bytes in a cache block (fixed at %d)\n", 3);
    printf("Example for 512Bytes cache size: %s -M 256 -N 256 -s 5 -E 2 -b 3 \n", argv[0]);       
    printf("Example for 4KB cache size: %s -M 256 -N 256 -s 8 -E 2 -b 3 \n", argv[0]);       
}

/*
 * sigsegv_handler - SIGSEGV handler
 */
void sigsegv_handler(int signum){
    printf("Error: Segmentation Fault.\n");
    printf("TEST_TRANS_RESULTS=0:0\n");
    fflush(stdout);
    exit(1);
}

/*
 * sigalrm_handler - SIGALRM handler
 */
void sigalrm_handler(int signum){
    printf("Error: Program timed out.\n");
    printf("TEST_TRANS_RESULTS=0:0\n");
    fflush(stdout);
    exit(1);
}


/* 
 * main - Main routine
 */
int main(int argc, char* argv[])
{
    char c;

    while ((c = getopt(argc,argv,"M:N:s:E:b:h")) != -1) {
        switch(c) {
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
        case 'h':
            usage(argv);
            exit(0);
        default:
            usage(argv);
            exit(1);
        }
    }
  
    if (M == 0 || N == 0) {
        printf("Error: Missing required argument\n");
        usage(argv);
        exit(1);
    }

    if (M > MAXN || N > MAXN) {
        printf("Error: M or N exceeds %d\n", MAXN);
        usage(argv);
        exit(1);
    }

    /* Install SIGSEGV and SIGALRM handlers */
    if (signal(SIGSEGV, sigsegv_handler) == SIG_ERR) {
        fprintf(stderr, "Unable to install SIGALRM handler\n");
        exit(1);
    }

    if (signal(SIGALRM, sigalrm_handler) == SIG_ERR) {
        fprintf(stderr, "Unable to install SIGALRM handler\n");
        exit(1);
    }

    /* Time out and give up after a while */
    alarm(960); // originally 120

    /* Check the performance of the student's matrix wavefront function */
  if((s == 5) && (E == 2) && (b==3))
   {
    eval_perf(5, 2, 3);
  
    /* Emit the results for this particular test */
    if (results.funcid == -1) {
        printf("\nError: We could not find your matrix_wavefront_submit() function\n");
        printf("Error: Please ensure that description field is exactly \"%s\"\n", 
               SUBMIT_DESCRIPTION);
        printf("\nTEST_TRANS_RESULTS=0:0\n");
    }
    else {
        printf("\nSummary for official submission (func %d): correctness=%d misses=%d for cache features ( s=%d E=%d b=%d ) \n",
               results.funcid, results.correct, results.misses, 5, 2, 3);
        printf("\nTEST_TRANS_RESULTS=%d:%d \n", results.correct, results.misses);
    }
  }

//for different cache size, check student's submission for the submitted matrix wavefront function
  else if((s == 8) && (E == 2) && (b==3))
   {
    eval_perf_new(8, 2, 3);
  
    /* Emit the results for this particular test */
    if (results.funcid == -1) {
        printf("\nError: We could not find your matrix_wavefront_submit() function\n");
        printf("Error: Please ensure that description field is exactly \"%s\"\n", 
               SUBMIT_DESCRIPTION);
        printf("\nTEST_TRANS_RESULTS=0:0\n");
    }
    else {
        printf("\nSummary for official submission (func %d): correctness=%d misses=%d for cache features ( s=%d E=%d b=%d ) \n",
               results.funcid, results.correct, results.misses, 8, 2, 3);
        printf("\nTEST_TRANS_RESULTS=%d:%d \n", results.correct, results.misses);
    }

  }

  else 
	{
        printf("\n ERROR!!!! See your command line options for correct matrix and cache sizes \n");
        printf("\n Correct options are- for 512B cache: ./test-trans -M 256 -N 256 -s 5 -E 2 -b 3 \n");
        printf("\n or for 4KB cache: ./test-trans -M 256 -N 256 -s 8 -E 2 -b 3 \n");
	}



    return 0;
}
