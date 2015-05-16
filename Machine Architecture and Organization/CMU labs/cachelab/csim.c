/* Name:Hao Wang
 * X500:wang5167
 * csim.c - A cache simulator that can replay traces from Valgrind
 *     and output statistics such as number of hits, misses, and
 *     evictions.  The replacement policy is LRU.
 *
 * The function printSummary() is given to print output.
 * Please use this function to print the number of hits, misses and evictions.
 * This is crucial for the driver to evaluate your work. 
 */
#include <getopt.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <assert.h>
#include <math.h>
#include <limits.h>
#include <string.h>
#include <errno.h>
#include "cachelab.h"

//#define DEBUG_ON 
#define ADDRESS_LENGTH 64

/* Type: Memory address */
typedef unsigned long long int mem_addr_t;

/* Type: Cache line
   LRU is a counter used to implement LRU replacement policy  */
typedef struct cache_line {
    char valid;
    mem_addr_t tag;
    unsigned long long int lru;
} cache_line_t;

typedef cache_line_t* cache_set_t;
typedef cache_set_t* cache_t;

/* Globals set by command line args */
int verbosity = 0; /* print trace if set */
int s = 0; /* set index bits */
int b = 0; /* block offset bits */
int E = 0; /* associativity */
char* trace_file = NULL;

/* Derived from command line args */
int S; /* number of sets */
int B; /* block size (bytes) */

/* Counters used to record cache statistics */
int miss_count = 0;
int hit_count = 0;
int eviction_count = 0;
unsigned long long int lru_counter = 1;

/* The cache we are simulating */
cache_t cache;  
mem_addr_t set_index_mask;

/* 
 * initCache - Allocate memory, and initialize the cache.
 */
void initCache(){
    cache = (cache_t)malloc(sizeof(cache_set_t)*S);
    for(int setindex =0; setindex<S;setindex++){
        cache[setindex] = (cache_set_t)malloc(sizeof(cache_line_t)*E); 
        for(int lineindex=0;lineindex<E;lineindex++){
            cache[setindex][lineindex].valid ='0';
            cache[setindex][lineindex].lru=0;
            cache[setindex][lineindex].tag=0;
        } 
    }
}
/* 
 * freeCache - free allocated memory
 */
void freeCache(){
    free(cache);
}

int getset(mem_addr_t* addr){
	int setindex = 0;
	long x = (long)addr >> b;
	int  y = (1 << s) - 1;
	setindex = (int) (x & y);
    return setindex;
}

long gettag(mem_addr_t* addr){
	long tagindex = 0;
	long x = (long)addr;
	int  y = s + b;
	tagindex = (long) (x >> y);
    return tagindex;
}

/* The key function in your simulator that 
    accesses data at memory address addr and 
    accordingly makes changes to the structures 
    used for implememting the cache.*/
void accessData(mem_addr_t* addr, char* op){
    if(*op == 'L'||*op == 'M'){
        int index;
    	int full = 1;
  	  	int empty_elem = 0;
    	int last_elem = 0;
   		cache_set_t currentset=cache[getset(addr)];        
    	mem_addr_t last_time = currentset[0].lru;
    	for (index = 0; index < E; index++){
        	if (currentset[index].valid == '1'){	
        		if(gettag(addr) == currentset[index].tag){
        			currentset[index].lru = lru_counter++;
            		break;
        		}
        	}
        	if (currentset[index].valid == '0'){
            	full = 0;
            	empty_elem = index;
        	}
        	if (currentset[index].lru < last_time){
            	last_elem = index;
            	last_time = currentset[index].lru;
        	}
    	}

    	if (index == E){
        	miss_count++;
        	if (full==1){
            	(currentset[last_elem]).tag=gettag(addr);
            	(currentset[last_elem]).lru = lru_counter++;
            	eviction_count++;
        	}
        	else{
            	(currentset[empty_elem]).valid = '1';
            	(currentset[empty_elem]).tag = gettag(addr);
            	(currentset[empty_elem]).lru = lru_counter++;
        	}
    	}
    	else{
        	hit_count++;
    	}
    }
    
    if(*op == 'S'||*op == 'M'){
        int index;
    	cache_set_t currentset=cache[getset(addr)];
    	for (index = 0; index < E; index++){
        	if ((currentset[index]).valid == '1'){	
        		if(gettag(addr) == (currentset[index]).tag){
        			(currentset[index]).lru = lru_counter++;
            		break;
        		}
        	}
    	}
    	if (index == E){
    		*op ='L';
        	accessData(addr,op); 
    	}
    	else{
        	hit_count++;
    	}
    }
}
/*
 * replayTrace - replays the given trace file against the cache 
 *
 * YOU CAN RE-WRITE THIS FUNCTION IF YOU WANT TO.
 */
void replayTrace(char* trace_fn)
{
    char buf[1000];
    mem_addr_t* addr;
    //unsigned int len=0;
    char op[1000];
    FILE* trace_fp = fopen(trace_fn, "r");

    if(!trace_fp){
        fprintf(stderr, "%s: %s\n", trace_fn, strerror(errno));
        exit(1);
    }

    while( fgets(buf, 1000, trace_fp) != NULL) {

        /* buf[Y] gives the Yth byte in the trace line */

        /* Read address and length from the trace using sscanf 
           E.g. sscanf(buf+3, "%llx,%u", &addr, &len);
         */

        /*  
         *    ACCESS THE CACHE, i.e. CALL accessData
     	 *    Be careful to handle 'M' accesses 
         */
       sscanf(buf, "%s %p", op, &addr);
       accessData(addr,op);
    }

    fclose(trace_fp);   
}

/*
 * printUsage - Print usage info
 */
void printUsage(char* argv[])
{
    printf("Usage: %s [-hv] -s <num> -E <num> -b <num> -t <file>\n", argv[0]);
    printf("Options:\n");
    printf("  -h         Print this help message.\n");
    printf("  -v         Optional verbose flag.\n");
    printf("  -s <num>   Number of set index bits.\n");
    printf("  -E <num>   Number of lines per set.\n");
    printf("  -b <num>   Number of block offset bits.\n");
    printf("  -t <file>  Trace file.\n");
    printf("\nExamples:\n");
    printf("  linux>  %s -s 4 -E 1 -b 4 -t traces/yi.trace\n", argv[0]);
    printf("  linux>  %s -v -s 8 -E 2 -b 4 -t traces/yi.trace\n", argv[0]);
    exit(0);
}

/*
 * main - Main routine 
 */
int main(int argc, char* argv[])
{
    char c;

    while( (c=getopt(argc,argv,"s:E:b:t:vh")) != -1){
        switch(c){
        case 's':
            s = atoi(optarg);
            break;
        case 'E':
            E = atoi(optarg);
            break;
        case 'b':
            b = atoi(optarg);
            break;
        case 't':
            trace_file = optarg;
            break;
        case 'v':
            verbosity = 1;
            break;
        case 'h':
            printUsage(argv);
            exit(0);
        default:
            printUsage(argv);
            exit(1);
        }
    }

    /* Make sure that all required command line args were specified */
    if (s == 0 || E == 0 || b == 0 || trace_file == NULL) {
        printf("%s: Missing required command line argument\n", argv[0]);
        printUsage(argv);
        exit(1);
    }

    /* Compute S, E and B from command line args */
    S=(1<<s);
    B=(1<<b);
    /* Initialize cache */
    initCache();

#ifdef DEBUG_ON
    printf("DEBUG: S:%u E:%u B:%u trace:%s\n", S, E, B, trace_file);
    printf("DEBUG: set_index_mask: %llu\n", set_index_mask);
#endif
 
    /* Read the trace and access the cache */
    replayTrace(trace_file);

    /* Free allocated memory */
    freeCache();

    /* Output the hit and miss statistics for the autograder */
    printSummary(hit_count, miss_count, eviction_count);
    return 0;
}
