/*
 * Uses simulated annealing to find the sorting that yields the highest synfire indicator
 */

#define char16_t uint16_T

#include "mex.h"
#include <time.h>
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[],
int nrhs, const mxArray *prhs[])

{
    #define p_out plhs[0]
    #define A_out plhs[1]
    #define total_iter_out plhs[2]
            
    #define D_in prhs[0]

    int M, N, pc, rc, cc, iterations, succ_iter, indy, dummy;
    double T, T_end, alpha;
    double *D, *p, *A, *total_iter, delta_A;
    
    D = (double *)mxGetPr(D_in);
    M = mxGetM(D_in);
    N = mxGetN(D_in);

    p_out = mxCreateNumericArray(0, 0, mxDOUBLE_CLASS, mxREAL);
    mxSetM(p_out, 1);
    mxSetN(p_out, N);    
    mxSetData(p_out, mxMalloc(sizeof(double) * 1 * N));
    p = (double *)mxGetPr(p_out);
    
    A_out = mxCreateDoubleScalar(0);
    A = (double *)mxGetPr(A_out);
    
    total_iter_out = mxCreateDoubleScalar(0);
    total_iter = (double *)mxGetPr(total_iter_out);
    
    srand((unsigned)time(NULL));

    T=0;
    for (rc=0; rc<N; rc++) {
       for (cc=0; cc<M; cc++) {
           if (D[cc*N+rc]>T) {
               T=D[cc*N+rc];
           }
           if (cc>rc) {
               *A+=D[cc*N+rc];
           }
       }
    }
    T*=2;               // starting temperature
    T_end=T/10000;      // final temperature
    alpha=0.9;          // cooling factor
    
    for (pc=0; pc<N; pc++) {        // initial permutation
        p[pc]=pc+1;
    }
    while (T>T_end) {
        iterations=0;
        succ_iter=0;
        while (iterations<100*N && succ_iter<10*N) {  // exchange two rows and cols
            indy=arc4random_uniform(N-1)+1;    // get random integer
            //mexPrintf("##### indy = %i ######\n",indy);
            delta_A = -2*D[(int)((p[indy]-1)*N+p[indy-1]-1)];
            if ((delta_A>0) || exp(delta_A/T)>(rand()/(RAND_MAX+1.))) {     // swap indices
                dummy=p[indy-1];
                p[indy-1]=p[indy];
                p[indy]=dummy;
                *A+=delta_A;
                succ_iter++;
            }
            iterations++;
        }
        *total_iter+=iterations;
        T*=alpha;   // cool down
        if (succ_iter==0) {
            break;
        }
    }
    return;
}