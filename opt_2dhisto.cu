#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "util.h"
#include "opt_2dhisto.h"
#include "ref_2dhisto.h"


__global__ void opt_2dhisto_kernel(uint32_t* d_input, size_t inputSize, unsigned int* d_bins);

void opt_2dhisto(uint32_t* d_input, size_t inputSize, unsigned int* d_bins, cudaDeviceProp prop)
{
    /* This function should only contain grid setup 
       code and a call to the GPU histogramming kernel. 
       Any memory allocations and transfers must be done 
       outside this function */
    float maxConcurrentBlocks = prop.maxThreadsPerMultiProcessor*prop.multiProcessorCount/(float)prop.maxThreadsPerBlock;
    cudaMemset(d_bins, 0, HISTO_HEIGHT*HISTO_WIDTH*sizeof(unsigned int));
    opt_2dhisto_kernel<<<min(ceil(inputSize/(float)prop.maxThreadsPerBlock), maxConcurrentBlocks), prop.maxThreadsPerBlock>>>(d_input, inputSize, d_bins);
    cudaDeviceSynchronize();
}

/* Include below the implementation of any other functions you need */

__device__ unsigned int atomicClampedAdd(unsigned int* address, unsigned int value, int limit){
    unsigned int old = *address, assumed;
    do{
      assumed = old;	// READ
      old = atomicCAS(address, assumed, 
            (value + assumed)>limit ? limit : value+assumed);	// MODIFY + WRITE
    } while (assumed != old);
  return old;
}

__global__ void opt_2dhisto_kernel(uint32_t* d_input, size_t inputSize, unsigned int* d_bins){
    __shared__ unsigned int private_bins[HISTO_HEIGHT*HISTO_WIDTH];;
    if(threadIdx.x < HISTO_HEIGHT * HISTO_WIDTH)
        private_bins[threadIdx.x] = 0;
    
    __syncthreads();
    int stride = gridDim.x*blockDim.x;
    int index = threadIdx.x + blockDim.x*blockIdx.x;
    while(index<inputSize){
        atomicAdd(&(private_bins[d_input[index]]), 1);
        index += stride;
    }
    __syncthreads();

    if(threadIdx.x < HISTO_HEIGHT * HISTO_WIDTH)
        atomicClampedAdd(&(d_bins[threadIdx.x]), private_bins[threadIdx.x], UINT8_MAXIMUM);
}