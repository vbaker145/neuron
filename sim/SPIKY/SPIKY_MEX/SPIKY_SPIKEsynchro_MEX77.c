/*
 * NB, MM, TK Jan 2015
 */

#include "mex.h"

/*NEEDS TO BE REWRITTEN*/

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
        
{
#define synchro_out plhs[0]
    
#define num_trains_in prhs[0]
#define num_uspikes_in prhs[1]
#define uspikes_in prhs[2]
    
    int *num_trains, sac, trac1, trac2, *num_uspikes, usac, changeSign, cntr1, cntr2, x, totalCounter, temp, flag[2][2], indx[2];
    double *uspikes1, *uspikes2, tau[2][2], abso, mini;
    double *synchro, *synchroReallocated;
    mxArray *synchroPr, *uspikes1Pr, *uspikes2Pr, *synchroPrReallocated, *synchroPrReallocated1;
    
    num_trains = (int *)mxGetPr(num_trains_in);
    num_uspikes = (int *)mxGetPr(num_uspikes_in);
    
    synchro_out = mxCreateCellMatrix(1, *num_trains * (*num_trains - 1)/2);
    
    for(trac1 = 0; trac1 < *num_trains; ++trac1)
        for(trac2 = trac1+1; trac2 < *num_trains;  ++trac2) {
            
            uspikes1Pr = mxGetCell(uspikes_in, trac1);
            uspikes2Pr = mxGetCell(uspikes_in, trac2);
            
            uspikes1 = (double *)mxGetPr(uspikes1Pr);
            uspikes2 = (double *)mxGetPr(uspikes2Pr);
            
            synchroPr = mxCreateNumericArray(0, 0, mxDOUBLE_CLASS, mxREAL);
            mxSetM(synchroPr, 1);
            if (num_uspikes[trac1] + num_uspikes[trac2] == 0) {
                mxSetN(synchroPr, 1);
                mxSetData(synchroPr, mxMalloc(sizeof(double)));
            }
            else {
                mxSetN(synchroPr, num_uspikes[trac1] + num_uspikes[trac2]);
                mxSetData(synchroPr, mxMalloc(sizeof(double) * (num_uspikes[trac1] + num_uspikes[trac2])));
            }
            synchro = (double *)mxGetPr(synchroPr);
            /*synchro = mxMalloc(sizeof(bool) * (num_uspikes[trac1] + num_uspikes[trac2]));
             * mxSetPr(synchroPr, synchro);*/
            
            if (num_uspikes[trac1] == 0) {
                if (num_uspikes[trac2] == 0)
                    synchro[0] = 1;
                else
                    for(cntr1 = 0; cntr1 < num_uspikes[trac2]; ++cntr1)
                        synchro[cntr1] = 0;
            }
            else {
                if (num_uspikes[trac2] == 0)
                     for(cntr1 = 0; cntr1 < num_uspikes[trac1]; ++cntr1)
                        synchro[cntr1] = 0;
                else   {
                    /*init*/
                    totalCounter = 0;
                    indx[0] = 0; indx[1] = 0;
                    flag[0][0] = 0; flag[0][1] = 0;
                    flag[1][0] = 0; flag[1][1] = 0;
                    
                    while ((indx[0] < num_uspikes[trac1]) || (indx[1] < num_uspikes[trac2])) {
                        
                        if (indx[0] < num_uspikes[trac1]  && indx[1] < num_uspikes[trac2]) {
                            /*find the nearest spike (identify in which train it is - x), be carerull if there is next spike*/
                            if (uspikes1[indx[0]] == uspikes2[indx[1]]) {
                                
                                for(cntr1 = 0; cntr1 < 2; ++cntr1)
                                    if (flag[cntr1][0]) {
                                        tau[cntr1][1] = tau[cntr1][0];
                                        flag[cntr1][1] = 1;
                                    }
                                
                                tau[0][0] = (uspikes1[indx[0]+1] - uspikes1[indx[0]])/2; tau[1][0] = (uspikes2[indx[1]+1] - uspikes2[indx[1]])/2;
                                flag[0][0] = 1; flag[1][0] = 1;
                                synchro[totalCounter] = 1;
                                
                                totalCounter++;
                                synchro[totalCounter] = 1; /* double check it*/
                                totalCounter++;
                                indx[0]++; indx[1]++;
                            }
                            else {
                                
                                /*skip the queue */
                                tau[0][0] = (uspikes1[indx[0]+1] - uspikes1[indx[0]])/2; tau[1][0] = (uspikes2[indx[1]+1] - uspikes2[indx[1]])/2;
                                flag[0][0] = 1; flag[1][0] = 1;
                                
                                x = (uspikes1[indx[0]] < uspikes2[indx[1]]) ? 0 : 1;
                                
                                if (x == 0) {
                                    if (indx[0] < num_uspikes[trac1] - 1)
                                        while(uspikes1[indx[0]+1] <= uspikes2[indx[1]]) {
                                
                                            flag[0][1] = 1; /* be smarter update tau*/
                                            tau[0][1] = tau[0][0];
                                            if (indx[0] == num_uspikes[trac1] - 1) {
                                                flag[0][0] = 0;
                                                break;
                                            }
                                            indx[0]++;
                                            tau[0][0] = (uspikes1[indx[0]+1] - uspikes1[indx[0]])/2;
                                            
                                            synchro[totalCounter] = 0;
                                
                                            totalCounter++;
                                        }
                                }
                                else {
                                    if (indx[1] < num_uspikes[trac2] - 1)
                                        while(uspikes2[indx[1] + 1] <= uspikes1[indx[0]]) {
                                            flag[1][1] = 1;
                                            tau[1][1] = tau[1][0];
                                            if (indx[1] == num_uspikes[trac2] - 1){
                                                flag[1][0] = 0;
                                                break;
                                            }
                                            indx[1]++;
                                            tau[1][0] = (uspikes2[indx[1]+1] - uspikes2[indx[1]])/2;
                                            synchro[totalCounter] = 0;
                                            totalCounter++;
                                        }
                                }
                                
                                /* untill sparse matrices */
                                if (indx[0] < num_uspikes[trac1]-1) {
                                    tau[0][0] = (uspikes1[indx[0]+1] - uspikes1[indx[0]])/2;
                                    flag[0][0] = 1;}
                                else
                                    flag[0][0] = 0;
                                
                                if (indx[1] < num_uspikes[trac2]-1) {
                                    tau[1][0] = (uspikes2[indx[1]+1] - uspikes2[indx[1]])/2;
                                    flag[1][0] = 1; }
                                else
                                    flag[1][0] = 0;
                                
                                if (indx[0] > 0) {
                                    tau[0][1] = (uspikes1[indx[0]] - uspikes1[indx[0]-1])/2;
                                    flag[0][1] = 1;}
                                else
                                    flag[0][1] = 0;
                                
                                if (indx[1] > 0) {
                                    tau[1][1] = (uspikes2[indx[1]] - uspikes2[indx[1]-1])/2;
                                    flag[1][1] = 1; }
                                else
                                    flag[1][1] = 0;
                                
                                abso = uspikes1[indx[0]] - uspikes2[indx[1]];
                                abso = (abso > 0) ? abso : -abso;
                                
                                mini = (flag[0][0] == 1) ? tau[0][0] : tau[0][1];
                                
                                for(cntr1 = 0; cntr1 < 2; cntr1++)
                                    for(cntr2 = 0; cntr2 < 2; cntr2++)
                                        if (flag[cntr1][cntr2])
                                            if (mini > tau[cntr1][cntr2])
                                                mini = tau[cntr1][cntr2];
                                
                                if (abso < mini) {
                                    synchro[totalCounter] = 1;
                                    totalCounter++;
                                    synchro[totalCounter] = 1;
                                    totalCounter++;
                                    indx[0]++; indx[1]++;
                                }
                                else {
                                    synchro[totalCounter] = 0;
                                    totalCounter++;
                                    indx[x]++;
                                }
                            }
                            
                        }
                        else {
                            /* find out which (doesnt) fail*/
                            x = (indx[0] < num_uspikes[trac1] - 1) ? 0 : 1;
                            
                            if (x == 0) {
                                if (indx[0] < num_uspikes[trac1])
                                    while(uspikes1[indx[0] + 1] <= uspikes2[indx[1]]) {
                                        flag[0][1] = 1; /* be smarter update tau*/
                                        tau[0][1] = tau[0][0];
                                        if (indx[0] == num_uspikes[trac1]) {
                                            flag[0][0] = 0;
                                            break;
                                        }
                                        indx[0]++;
                                        tau[0][0] = (uspikes1[indx[0]+1] - uspikes1[indx[0]])/2;
                                        synchro[totalCounter] = 0;
                                        totalCounter++;
                                    }
                            }
                            else {
                                if (indx[1] < num_uspikes[trac2])
                                    while(uspikes2[indx[1] + 1] <= uspikes1[indx[0]]) {
                                        flag[1][1] = 1;
                                        tau[1][1] = tau[1][0];
                                        if (indx[1] == num_uspikes[trac2]){
                                            flag[1][0] = 0;
                                            break;
                                        }
                                        
                                        indx[1]++;
                                        tau[1][0] = (uspikes2[indx[1]+1] - uspikes2[indx[1]])/2;
                                        synchro[totalCounter] = 0;
                                        totalCounter++;
                                    }
                            }
                            
                            /* untill sparse matrices */
                            if (indx[0] < num_uspikes[trac1]-1) {
                                tau[0][0] = (uspikes1[indx[0]+1] - uspikes1[indx[0]])/2;
                                flag[0][0] = 1;}
                            else
                                flag[0][0] = 0;
                            
                            if (indx[1] < num_uspikes[trac2]-1) {
                                tau[1][0] = (uspikes2[indx[1]+1] - uspikes2[indx[1]])/2;
                                flag[1][0] = 1; }
                            else
                                flag[1][0] = 0;
                            
                            if (indx[0] > 0) {
                                tau[0][1] = (uspikes1[indx[0]] - uspikes1[indx[0]-1])/2;
                                flag[0][1] = 1;}
                            else
                                flag[0][1] = 0;
                            
                            if (indx[1] > 0) {
                                tau[1][1] = (uspikes2[indx[1]] - uspikes2[indx[1]-1])/2;
                                flag[1][1] = 1; }
                            else
                                flag[1][1] = 0;
                            
                            abso = uspikes1[indx[0]] - uspikes2[indx[1]];
                            abso = (abso > 0) ? abso : -abso;
                            
                            mini = (flag[0][0] == 1) ? tau[0][0] : tau[0][1];
                            
                            for(cntr1 = 0; cntr1 < 2; cntr1++)
                                for(cntr2 = 0; cntr2 < 2; cntr2++)
                                    if (flag[cntr1][cntr2])
                                        if (mini > tau[cntr1][cntr2])
                                            mini = tau[cntr1][cntr2];
                            
                            if (x)
                                temp = trac2;
                            else
                                temp = trac1;
                            
                            if (abso < mini) {
                                synchro[totalCounter] = 1;
                                totalCounter++;
                                synchro[totalCounter] = 1;
                                totalCounter++;
                                if (indx[0] <= num_uspikes[trac1] - 1)
                                    indx[0]++;
                                if (indx[1] <= num_uspikes[trac2] - 1)
                                    indx[1]++;
                            }
                            else {
                                synchro[totalCounter] = 0;
                                totalCounter++;
                                if (indx[x] < num_uspikes[temp] - 1)
                                    indx[x]++;
                            }
                            
                            if (indx[x] <= num_uspikes[temp] - 1)
                            {
                                if (indx[0] < num_uspikes[trac1]-1) {
                                    tau[0][0] = (uspikes1[indx[0]+1] - uspikes1[indx[0]])/2;
                                    flag[0][0] = 1;}
                                else
                                    flag[0][0] = 0;
                                
                                if (indx[1] < num_uspikes[trac2]-1) {
                                    tau[1][0] = (uspikes2[indx[1]+1] - uspikes2[indx[1]])/2;
                                    flag[1][0] = 1; }
                                else
                                    flag[1][0] = 0;
                                
                                if (indx[0] > 0) {
                                    tau[0][1] = (uspikes1[indx[0]] - uspikes1[indx[0]-1])/2;
                                    flag[0][1] = 1;}
                                else
                                    flag[0][1] = 0;
                                
                                if (indx[1] > 0) {
                                    tau[1][1] = (uspikes2[indx[1]] - uspikes2[indx[1]-1])/2;
                                    flag[1][1] = 1; }
                                else
                                    flag[1][1] = 0;
                                
                                abso = uspikes1[indx[0]] - uspikes2[indx[1]];
                                abso = (abso > 0) ? abso : -abso;
                                
                                mini = (flag[0][0] == 1) ? tau[0][0] : tau[0][1];
                                
                                for(cntr1 = 0; cntr1 < 2; cntr1++)
                                    for(cntr2 = 0; cntr2 < 2; cntr2++)
                                        if (flag[cntr1][cntr2])
                                            if (mini > tau[cntr1][cntr2])
                                                mini = tau[cntr1][cntr2];
                                
                                if (x)
                                    temp = trac2;
                                else
                                    temp = trac1;
                                
                                if (abso < mini) {
                                    synchro[totalCounter] = 1;
                                    totalCounter++;
                                    synchro[totalCounter] = 1;
                                    totalCounter++;
                                    if (indx[0] < num_uspikes[trac1] - 1)
                                        indx[0]++;
                                    if (indx[1] < num_uspikes[trac2] - 1)
                                        indx[1]++;
                                }
                                else {
                                    synchro[totalCounter] = 0;
                                    totalCounter++;
                                    if (indx[x] < num_uspikes[temp] - 1)
                                        indx[x]++;
                                }
                            }
                            
                            while (indx[x] < num_uspikes[temp] - 1) {
                                indx[x]++;
                                synchro[totalCounter] = 0;
                                totalCounter++;
                            }
                            break;
                        }
                    }
                }
            }
                /*reallocate*/
                
                temp = (*num_trains - 1)**num_trains/2 - (*num_trains - 1 - trac1)*(*num_trains - trac1)/2 + trac2 - trac1 - 1;
                
                mxSetCell(synchro_out, temp, synchroPr);
            }
            return;
        }
    
    /*********** shifted by 1 to be consistent */