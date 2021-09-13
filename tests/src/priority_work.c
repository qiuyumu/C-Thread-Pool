#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdint.h>
#include "../../thpool.h"

/*
 * This program takes 1 arguments: number of jobs to add,
 *                                 
 *                                 
 * 
 * Each job is to simply print its priority.
 * 
 * */

void task_with_priority(void* priority){
	printf("%ld ", (uintptr_t)priority);
}

int main(int argc, char *argv[]){

    char *p;
    if (argc != 2){
		puts("This testfile needs excactly one arguments");
		exit(1);
	}


	int num_jobs = strtol(argv[1], &p, 10);

	threadpool thpool;
    /* Test if  thread pick tasks based on priority */
	
	thpool = thpool_init(1);
    thpool_pause(thpool);
    for(int i = 1; i <= num_jobs; ++i){
        thpool_add_work_priority(thpool, (void*)task_with_priority, (void*)(uintptr_t)i, i);
    };
    // Ensure that all threads are in the thread_hold()
    sleep(1);
    thpool_resume(thpool);
    thpool_wait(thpool);
    
	thpool_destroy(thpool);

	return 0;
}
