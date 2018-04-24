/*
 * ISI-distance (Kreuz), calculated from ISI input (ints)
 */
#define char16_t uint16_T

#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[],
int nrhs, const mxArray *prhs[])

{
    #define bi_isi_ratio_out plhs[0]
    
    #define num_pairs_in prhs[0]
    #define run_pico_lengths_ruc_in prhs[1]
    #define num_trains_in prhs[2]
    #define ints_in prhs[3]
    
    int *num_pairs, *run_pico_lengths_ruc, *num_trains,  pac = 0, sac, trac1, trac2;
    double *bi_isi_ratio, *ints;
    
    num_pairs = (int *)mxGetPr(num_pairs_in);
    run_pico_lengths_ruc = (int *)mxGetPr(run_pico_lengths_ruc_in);
    num_trains = (int *)mxGetPr(num_trains_in);
    ints = (double *)mxGetPr(ints_in);
    
    bi_isi_ratio_out = mxCreateNumericArray(0, 0, mxDOUBLE_CLASS, mxREAL);
    mxSetM(bi_isi_ratio_out, *num_pairs);
    mxSetN(bi_isi_ratio_out, *run_pico_lengths_ruc);
    mxSetData( bi_isi_ratio_out, mxMalloc(sizeof(double) * *num_pairs * *run_pico_lengths_ruc));
    bi_isi_ratio = (double *)mxGetPr(bi_isi_ratio_out);
    
    for(trac1 = 0; trac1 < *num_trains-1; ++trac1)
        for(trac2 = trac1 + 1; trac2 < *num_trains;  ++trac2) {
            pac++;
            
            for(sac = 0; sac < *run_pico_lengths_ruc; ++sac) {
                if (ints[trac1 + *num_trains * sac] < ints[trac2 + *num_trains * sac])
                    bi_isi_ratio[(pac-1) + *num_pairs * sac] = ints[trac1 + *num_trains * sac]/ints[trac2 + *num_trains * sac] - 1;
                else
                    /* to avoid division by 0 */
                    if (ints[trac1 + *num_trains * sac] == 0)
                        bi_isi_ratio[(pac-1) + *num_pairs * sac] = 0;
                    else
                        bi_isi_ratio[(pac-1) + *num_pairs * sac] = 1 - ints[trac2 + *num_trains * sac]/ints[trac1 + *num_trains * sac];
            }
            
        }
    return;
}