#ifndef UTIL_H__
#define UTIL_H__

#define __USE_BSD 1
#define INPUT_WIDTH  7000
#define INPUT_HEIGHT 7000


#include <stdio.h>
#include <time.h>
#include <sys/time.h>


void** alloc_2d(size_t y_size, size_t x_size, size_t element_size);

#define TIME_IT(ROUTINE_NAME__, LOOPS__, ACTION__)\
{\
    printf("    Timing '%s' started\n", ROUTINE_NAME__);\
    struct timeval tv;\
    struct timezone tz;\
    const clock_t startTime = clock();\
    gettimeofday(&tv, &tz); long GTODStartTime =  tv.tv_sec * 1000000 + tv.tv_usec;\
    for (int loops = 0; loops < (LOOPS__); ++loops)\
    {\
        ACTION__;\
    }\
    gettimeofday(&tv, &tz); long GTODEndTime =  tv.tv_sec * 1000000 + tv.tv_usec;\
    const clock_t endTime = clock();\
    const clock_t elapsedTime = endTime - startTime;\
    const double timeInMilliseconds = (elapsedTime*1000/(double)CLOCKS_PER_SEC);\
    printf("        GetTimeOfDay Time (for %d iterations) = %g ms\n", LOOPS__, (double)(GTODEndTime - GTODStartTime)/1000.0 );\
    printf("        Clock Time        (for %d iterations) = %g ms\n", LOOPS__, timeInMilliseconds );\
    printf("    Timing '%s' ended\n", ROUTINE_NAME__);\
}

#endif
