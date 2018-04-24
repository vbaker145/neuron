/*	Rearanging spike trains in order to boost vR,
 note they (inputs) must not have any common element*/

#include "mex.h"
#include "math.h"
#include "limits.h"

void mexFunction(int nlhs, mxArray *plhs[],
int nrhs, const mxArray *prhs[])

{
    #define spikes_out plhs[0]
    
    #define spikesA_in prhs[0]
    #define spikesB_in prhs[1]
    #define cespA_in prhs[2]
    #define cespB_in prhs[3]
    #define length_in prhs[4]
    
    int num_spikesA, num_spikesB, *length, i, j;
    double *spikesA, *spikesB, *spikes, *cespA, *cespB;
    
    spikesA = (double *)mxGetPr(spikesA_in);
    spikesB = (double *)mxGetPr(spikesB_in);
    cespA = (double *)mxGetPr(cespA_in);
    cespB = (double *)mxGetPr(cespB_in);
    
    length = (int *)mxGetPr(length_in);
    
    num_spikesA = mxGetN(spikesA_in);
    num_spikesB = mxGetN(spikesB_in); 
    
    spikes_out = mxCreateNumericArray(0, 0, mxDOUBLE_CLASS, mxREAL);
    mxSetM(spikes_out, 2);
    mxSetN(spikes_out, *length);
    mxSetData(spikes_out, mxMalloc(sizeof(double) * 2 * *length));
    spikes = (double *)mxGetPr(spikes_out);      
      
    i = 0;
    j = 0;
    
    while (i + j < *length) {
        if ((spikesA[i] < spikesB[j] && i < num_spikesA)||(j == num_spikesB)) {
            spikes[2*(i+j)] = cespA[i];
            if (j > 0)
                spikes[1 + 2*(i+j)] = cespB[j-1];
            else
                spikes[1 + 2*(i+j)] = 0;
            if (i < num_spikesA)
                i++;
        }
        else {
            spikes[1 + 2*(i+j)] = cespB[j];

            if (i > 0)
                spikes[2*(i+j)] = cespA[i-1];
            else
                spikes[2*(i+j)] = 0;
            if (j < num_spikesB)
                j++;
        }

    }
      
    return;
}