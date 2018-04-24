/*
 * For given cell of spike times, finds nearest neighbour in one run (for each pair)
 */

#define char16_t uint16_T

#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[],
int nrhs, const mxArray *prhs[])

{
    #define udists_out plhs[0]
    
    #define num_trains_in prhs[0]
    #define num_uspikes_in prhs[1]
    #define uspikes_in prhs[2]
    
    int *num_trains, sac, trac1, trac2, *num_uspikes, indx, usac, changeSign;
    double *udists, *uspikes1, *uspikes2;
    mxArray *udistsPr, *uspikes1Pr, *uspikes2Pr;
    
    num_trains = (int *)mxGetPr(num_trains_in);
    num_uspikes = (int *)mxGetPr(num_uspikes_in);
    
    udists_out = mxCreateCellMatrix(*num_trains, *num_trains);
    
    for(trac1 = 0; trac1 < *num_trains; ++trac1)
        for(trac2 = 0; trac2 < *num_trains;  ++trac2)
            if (trac1 != trac2) {
                
                uspikes1Pr = mxGetCell(uspikes_in, trac1);
                uspikes2Pr = mxGetCell(uspikes_in, trac2);
                
                uspikes1 = (double *)mxGetPr(uspikes1Pr);
                uspikes2 = (double *)mxGetPr(uspikes2Pr);
                
                udistsPr = mxCreateNumericArray(0, 0, mxDOUBLE_CLASS, mxREAL);
                mxSetM(udistsPr, 1);
                mxSetN(udistsPr, num_uspikes[trac1]);
                mxSetData(udistsPr, mxMalloc(sizeof(double) * num_uspikes[trac1]));
                
                udists = (double *)mxGetPr(udistsPr);
                
                udists[0] = uspikes1[0] - uspikes2[0]; indx = 0;
                if (udists[0] < 0)
                    udists[0] = -udists[0];
                
                for(usac = 1; usac < num_uspikes[trac2]; ++usac) {
                    if (uspikes1[0] - uspikes2[usac] < 0)
                        changeSign = -1;
                    else
                        changeSign = 1;
                    if (udists[0] > changeSign*(uspikes1[0] - uspikes2[usac])) {
                        udists[0] = changeSign*(uspikes1[0] - uspikes2[usac]);
                        indx = usac;
                    }
                    else
                        break;
                }
                
                for(sac = 1; sac < num_uspikes[trac1]; ++sac) {
                    
                    udists[sac] = uspikes1[sac] - uspikes2[indx];
                    if (udists[sac] < 0)
                        udists[sac] = -udists[sac];
                    
                    for(usac = indx+1; usac < num_uspikes[trac2]; ++usac) {
                        if (uspikes1[sac] - uspikes2[usac] < 0)
                            changeSign = -1;
                        else
                            changeSign = 1;
                        if (udists[sac] > changeSign*(uspikes1[sac] - uspikes2[usac])) {
                            udists[sac] = changeSign*(uspikes1[sac] - uspikes2[usac]);
                            indx = usac;
                        }
                        else
                            break;
                    }
                }
                
                mxSetCell(udists_out, trac2 * *num_trains + trac1, udistsPr);
            }
    return;
}