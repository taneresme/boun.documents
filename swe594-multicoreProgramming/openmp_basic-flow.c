#include <stdio.h>
#include <omp.h>

int a = 3 ;
int b = 5 ;

#pragma omp threadprivate(a, b)

main ()
{
	int i ;
	int c = 1 ;
	int d = 2 ;
	int tid ;
	omp_set_num_threads(20) ;
	omp_set_dynamic(1);
#pragma omp parallel private(c) private(tid,d) copyin(b)
{
	tid = omp_get_thread_num();
	a = tid + b ;
	b = tid + b ;
	c = tid + b ;
	d = tid + b ;
	printf("Thread %d: a,b,c,d= %d %d %d %d\n",tid,a,b,c,d);
}
	printf("a,b,c,d= %d %d %d %d\n",a,b,c,d);
#pragma omp parallel for firstprivate(c) private(i) reduction(*:d)
	for(i=0 ; i < 5 ; i++) {
		printf("tid=%d, a,b,c,d= %d %d %d %d\n",omp_get_thread_num(), a,b,c,d);
		a = a + c + i ;
	}
	printf("a,b,c,d= %d %d %d %d\n",a,b,c,d);
}
