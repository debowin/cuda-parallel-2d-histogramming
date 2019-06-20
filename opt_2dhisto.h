#ifndef OPT_KERNEL
#define OPT_KERNEL

void opt_2dhisto(uint32_t* d_input, size_t inputSize, unsigned int* d_bins, cudaDeviceProp prop);

/* Include below the function headers of any other functions that you implement */
#endif
