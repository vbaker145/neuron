/*
 * Realtime SPIKE-distance (only known previous spikes) (Kreuz)
 */
#define char16_t uint16_T

#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[],
int nrhs, const mxArray *prhs[])

{
    #define bi_spike_diffs_realtime_t_out plhs[0]
    
    #define num_pairs_in prhs[0]
    #define run_pili2_lengths_ruc_in prhs[1]
    #define num_trains_in prhs[2]
    #define previ_in prhs[3]
    #define prev_indy_in prhs[4]
    #define udists_in prhs[5]
    
    int *num_pairs, *run_pili2_lengths_ruc, *num_trains, *prev_indy, pac = 0, sac, trac1, trac2, M;
    double *bi_spike_diffs_realtime_t, *udists, *udists2, *previ, normy;
    const mxArray *udistsPr, *udists2Pr;
    
    num_pairs = (int *)mxGetPr(num_pairs_in);
    run_pili2_lengths_ruc = (int *)mxGetPr(run_pili2_lengths_ruc_in);
    num_trains = (int *)mxGetPr(num_trains_in);
    previ = (double *)mxGetPr(previ_in);
    prev_indy = (int *)mxGetPr(prev_indy_in);
    
    bi_spike_diffs_realtime_t_out = mxCreateNumericArray(0, 0, mxDOUBLE_CLASS, mxREAL);
    mxSetM(bi_spike_diffs_realtime_t_out, *num_pairs);
    mxSetN(bi_spike_diffs_realtime_t_out, *run_pili2_lengths_ruc);
    mxSetData(bi_spike_diffs_realtime_t_out, mxMalloc(sizeof(double) * *num_pairs * *run_pili2_lengths_ruc));
    bi_spike_diffs_realtime_t = (double *)mxGetPr(bi_spike_diffs_realtime_t_out);
    
    M  = mxGetM(udists_in);
    
    for(trac1 = 0; trac1 < *num_trains-1; ++trac1)
        for(trac2 = trac1 + 1; trac2 < *num_trains;  ++trac2) {
            pac++;
            
            udistsPr = mxGetCell(udists_in, trac2 * M + trac1);
            udists2Pr = mxGetCell(udists_in, trac1 * M + trac2);
            
            udists = (double *)mxGetPr(udistsPr);
            udists2 = (double *)mxGetPr(udists2Pr);
            
            for(sac = 0; sac < *run_pili2_lengths_ruc; ++sac) {
                normy = previ[trac1 + *num_trains * sac] + previ[trac2 + *num_trains * sac];
                if (previ[trac1 + *num_trains * sac ] < previ[trac2 + *num_trains * sac]) {
                    bi_spike_diffs_realtime_t[(pac-1) + *num_pairs * sac] = (previ[trac2 + *num_trains * sac] - previ[trac1 + *num_trains * sac]
                    + udists2[prev_indy[trac2 + *num_trains * sac] - 1])
                    /(2*normy + !normy);
                }
                else {
                    bi_spike_diffs_realtime_t[(pac-1) + *num_pairs * sac] = (previ[trac1 + *num_trains * sac] - previ[trac2 + *num_trains * sac]
                    + udists[prev_indy[trac1 + *num_trains * sac] - 1])
                    /(2*normy + !normy);
                }
            }
        }
    return;
}