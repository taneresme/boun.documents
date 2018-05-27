#include <stdio.h>
#include <iostream>
#include <math.h>
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

#define N 10

// Counts the digits in an array that has items ranged 
// between 0 and 9.
int main() {
	// Initialize the array that holds the digit counts
	int cs[10] = {0,0,0,0,0,0,0,0,0,0};
	int A[N];
	// Initialize the array with random digits
	for(int j = 0; j<N; j++){
		A[j] = rand() % 10;
	}
	
	// Start openmp parallel block
#pragma omp parallel for 
	for(int i=0 ; i < N ; i++) {
		// This section is critical because, 
		// more than one thread can try to access here.
		#pragma omp critical
		cs[A[i]]++;
	}

	// Print them
	for(int j = 0; j<N; j++){
		printf("%d: %d\n", j, cs[j]);
	}
	
	return 0;	
}
