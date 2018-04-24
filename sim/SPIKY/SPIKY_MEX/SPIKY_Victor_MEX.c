/*  d=spkd(tli,tlj,cost) calculates the "spike time" distance
    (Victor & Purpura 1996) for a DOUBLE cost

    tli: vector of spike times for first spike train
    tlj: vector of spike times for second spike train
    cost: cost per unit time to move a spike

    Copyright (c) 1999 by Daniel Reich and Jonathan Victor.
    Translated to Matlab by Daniel Reich from FORTRAN code by Jonathan Victor.
    Modified by Thomas Kreuz 
    Translated (and memory optimized) into mex by Nebojsa Bozanic
*/

#include "mex.h"
#include "limits.h"

void mexFunction(int nlhs, mxArray *plhs[],
int nrhs, const mxArray *prhs[])

{
    #define vdv_out plhs[0] 
    
    #define tli_in prhs[0]
    #define tlj_in prhs[1]
    #define cost_array_in prhs[2]
   
    int nspi, nspj, i, j, minNsp, unique, num_cost_array, cntr;
    double *tli, *tlj, *cost_array, *vdv, *scr, diff;
    mxArray *scrPr;
    
    tli = (double *)mxGetPr(tli_in);
    tlj = (double *)mxGetPr(tlj_in);
    cost_array = (double *)mxGetPr(cost_array_in);  
    
    num_cost_array = mxGetNumberOfElements(cost_array_in);

    vdv_out = mxCreateNumericArray(0, 0, mxDOUBLE_CLASS, mxREAL);
    mxSetM(vdv_out, 1);
    mxSetN(vdv_out, num_cost_array);
    mxSetData(vdv_out, mxMalloc(sizeof(double)*num_cost_array));
    vdv = (double *)mxGetPr(vdv_out);
        
    nspi = mxGetNumberOfElements(tli_in);
    nspj = mxGetNumberOfElements(tlj_in);
    
    /*####*/
    if (nspi < nspj)
        minNsp = nspi;
    else
        minNsp = nspj;
    
    scrPr = mxCreateNumericArray(0, 0, mxDOUBLE_CLASS, mxREAL);
    mxSetM(scrPr, 2);
    mxSetN(scrPr, minNsp + 1);
    mxSetData(scrPr, mxMalloc(sizeof(double) * 2 * (minNsp + 1)));
    scr = (double *)mxGetPr(scrPr);
       
    for(cntr = 0; cntr < num_cost_array; ++cntr) {
        if (cost_array[cntr] == 0) {
            vdv[cntr] = abs(nspi - nspj);
        }
        else if (cost_array[cntr] >= FLT_MAX ) {
            /* this works only if trains are sorted */
            i = 0;
            j = 0;
            unique = 0;
            while (i < nspi && j < nspj) {
                if (tli[i] == tlj[j] && i < nspi && j < nspj) {
                    i++;
                    j++;
                    unique++;
                }
                else if ((tli[i] < tlj[j]) && (i < nspi) || (j == nspj))
                    i++;
                else
                    j++;
            }       

            vdv[cntr] = nspi + nspj - 2*unique; /*maybe it was smarter to actually count nonuniqes in a loop*/
        } 
        else {
            if (nspi && nspj) {
                scr[0] = 0; 
                for (j=1; j <= minNsp; ++j)
                    scr[2*j] = j;

                for (i=1; i <= nspi + nspj - minNsp; ++i) { /* nspi + nspj - minNsp represents max(nspi, nspj) */
                    scr[1] = i;
                    for (j=1; j <= minNsp; ++j) {
                        scr[1 + 2*j] = scr[2*j] + 1;
                        if (scr[1 + 2*j] > scr[1 + 2*(j-1)] + 1)
                            scr[1 + 2*j] = scr[1 + 2*(j-1)] + 1;

                        /* ## in order to avoid changing tli and tlj among themselves it is easy to just manipulate with indecies## */
                        if ( nspj == minNsp)
                            diff = tli[i-1] - tlj[j-1];
                        else 
                            diff = tli[j-1] - tlj[i-1];

                        if (diff < 0)
                            diff = -diff;
                        if (scr[1 + 2*j] > scr[2*(j-1)] + cost_array[cntr] * diff)
                            scr[1 + 2*j] = scr[2*(j-1)] + cost_array[cntr] * diff;


                    }

                    for (j=0; j <= minNsp; ++j)
                        scr[2*j] = scr[1 + 2*j];

                }

            vdv[cntr] = scr[1 + 2*minNsp];
            }
        }
    }
    return;
}