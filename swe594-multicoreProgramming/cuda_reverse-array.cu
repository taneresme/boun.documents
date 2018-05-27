#include <iostream>
 
#define N 10

// __global__ qualifier indicates that 
// this function is a kernel function of CUDA.
__global__
void reverse(int *da){
	int tid = blockIdx.x; // which block handling the data 
	if (tid < N){
		int cross = N - 1 - tid;
		int temp = da[tid];
		da[tid] = da[cross];
		da[cross] = temp;
	}
}

int main(int argc, char *argv[])
{	
	std::cout << "Press any button to continue...";
	std::cin.get();
	
	// Define the arrays to be stored on host.
	int A[N], Arev[N];
	// Define the array (pointer) to be stored on device (GPU)
	int *da;
	
	// Fill the array with some values.
	for(int i=0; i<N; i++){
		A[i] = i;//rand() % 100;
		Arev[i] = -1;
	}
	
	// Allocate memory on device for N-item
	cudaMalloc((void**)&da, N*sizeof(int));
	// Copy the values on host (A) to device (da)
	// "da" is the memory location to copy A
	cudaMemcpy(da, A, N*sizeof(int), cudaMemcpyHostToDevice);
	
	// Call kernel with N/2 block (grid).
	reverse<<<N / 2, 1>>>(da);
	
	// Wait for all thread to finish
	cudaThreadSynchronize();
	
	// Copy "da" from device to host (Arev)
	cudaMemcpy(Arev, da, N*sizeof(int), cudaMemcpyDeviceToHost);
	
	// Print them
	for(int i=0; i<N; i++){
		printf("%d \n", Arev[i]);
	}
	
	// Free the allocated memory on device
	cudaFree(da);
	
	return 0;
}
