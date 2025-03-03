/* 
Compile it as a shared object/dynamic library to call it from julia e.g.
    Linux/gnu:
            gcc -fPIC -shared -fopenmp -o matrixlib.so mul.c
    Mac/homebrew:
            clang -Xclang -fopenmp -L/opt/homebrew/opt/libomp/lib -I/opt/homebrew/opt/libomp/include -lomp  -fPIC -dynamiclib -o matrixlib.dylib mul.c
*/

#include <stdio.h>
#include <omp.h>

void mymul(double* A, double* B, double* C, int m, int n, int p) {
    //Simple C rutine for matrix multiplication.

    //(!) Can you modify the default thread scheduling?
    //(!) What about environment variables?
    //(!) Is the memory access pattern optimal? What is A pointing to when called by Julia?
    //(!) This schoolbook implementation is O(n^3), there is a better one?
    //(!) What about SIMD?
    #pragma omp parallel for
    for (int i = 0; i < m; i++) {

        for (int j = 0; j < p; j++) {   
            double sum = 0.0;

            for (int k = 0; k < n; k++) {
                sum += A[i * n + k] * B[k * p + j];
            }
            C[i * p + j] = sum;
        }
    }
}


void say_y(int y)
{
    // The simplest openmp Example
    #pragma omp parallel
    printf("Hello from C: got y = %d.\n", y);
}
