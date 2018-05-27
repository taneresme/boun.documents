#include <thrust/host_vector.h>
#include <thrust/iterator/permutation_iterator.h>

#define N 10

// Counts the digits in an array that has items ranged 
// between 0 and 9.
int main() {
	// Initialize the arrays
	int A[N];
	int cs[10] = {0,0,0,0,0,0,0,0,0,0};
	for(int j = 0; j < N; j++){
		A[j] = rand() % 10;
	}
	
	// Initialize thrust host vectors.
	thrust::host_vector<int> ha(A, A + N);
	thrust::host_vector<int> hcs(cs, cs + 10);
	
	// The below function performs the operation 
	// hcs[ ha[ i ] ] = hcs[ ha[ i ] ] + 1 parallel.
	thrust::transform(thrust::make_permutation_iterator(hcs.begin(), ha.begin()), // start of hcs[ ha[ i ] ] for input
					  thrust::make_permutation_iterator(hcs.end(), ha.end()), // end of hcs[ ha[ i ] ] for input
					  thrust::make_constant_iterator(1), // returns always 1 for every request
					  thrust::make_permutation_iterator(hcs.begin(), ha.begin()), // hcs[ ha[ i ] ] for output
					  thrust::plus<int>() // the operation applied.
					  ); 
	
	// Print them
	thrust::copy(hcs.begin(), hcs.end(), std::ostream_iterator<int>(std::cout, "\n"));
}
