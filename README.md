# cuda-parallel-2d-histogramming

## Overview

This is an implementation of a 2D histogramming operation on the GPU. Histograms are a commonly used analysis tool in image processing
and data-mining applications. They show the frequency of occurrence of data elements over discrete intervals, also known as bins.
A simple example for the use of histograms is determining the distribution of a set of grades.

Example:

Grades: 0, 1, 1, 4, 0, 2, 5, 5, 5

The above grades ranging from 0 to 5 result in the following 6-bin histogram:

Histogram: 2, 2, 1, 0, 1, 3

## Details

| Filename          | Description                                                          |
| ----------------- |----------------------------------------------------------------------|
| Makefile          | The makefile to compile your code                                    |
| util.h            | Header file with some utility macros and function prototypes         |
| util.c            | Source file with some utility functions                              |
| ref_2dhisto.h     | Header file for the reference kernel                                 |
| ref_2dhisto.cpp   | Source file for the scalar reference implementation of the kernel    |
| test_harness.cpp  | Source file with main() method that has sample calls to the kernels  |
| opt_2dhisto.h     | Header file for the parallel kernel                                  |
| opt_2dhisto.cu    | Source file for the parallel implementation of the kernel            |

* *ref_2dhisto(...)* constructs a histogram from the bin IDs passed in input.
* *input* is a 2D array of input data. These will all be valid bin IDs, so no
range checking is required.
* *height* and *width* are the height and width of the input.
* *bins* is the histogram. *HISTO_HEIGHT* and *HISTO_WIDTH* are the
dimensions of the histogram (and are 1 and 1024 respectively, resulting in a 1K-bin histogram).

## Assumptions/Constraints

* The input data consists of index values into the bins.
* The input bins are NOT uniformly distributed. This non-uniformity is a
large portion of what makes this problem interesting for GPUs.
* For each bin in the histogram, once the bin count reaches 255, no further incrementing occurs.
This is sometimes called a "saturating counter". THERE'S NO "ROLL-OVER".

## Execution

* Run "make" to build the executable of this file.
* For debugging, run "make dbg=1" to build a debuggable version of the executable binary.
* Run the binary using "./~name-of-the-artifact~"

There are several modes of operation for the application -

* *No arguments*: The application will use a default seed value for the random
number generator when creating the input image.
* *One argument*: The application will use the seed value provided as a command-line argument.

When run, the application will report the timing information for the sequential code followed by
the timing information of the parallel implementation. It will also compare the two outputs and
print "Test PASSED" if they are identical, or "Test FAILED" otherwise.
