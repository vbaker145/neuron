#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
        
{
#define synchro_out plhs[0]
    
#define spikes_in prhs[0]
    
    int num_trains, *num_sac, trac1, trac2, num_spikes1, num_spikes2, usac, changeSign, cntr1, cntr2, x, totalCounter, temp, flag[2][2], indx[2];
    double *spikes1, *spikes2, tau[2][2], abso, mini;
    double *synchro;
    mxArray *synchroPr, *spikes1Pr, *spikes2Pr;
    
    // mexPrintf("\n\tStarted\n\n"); //
    
    num_trains = mxGetN(spikes_in);
    
    // mexPrintf("number of trains = %i\n", num_trains); //
    
    // output has a size of the number of pairs
    synchro_out = mxCreateCellMatrix(1, num_trains * (num_trains - 1)/2);
    
    // while spikes
    
    // update tau
    
    // compare tau (write synchro)
    
    for(trac1 = 0; trac1 < num_trains - 1; ++trac1) {
        
        spikes1Pr = mxGetCell(spikes_in, trac1);
        num_spikes1 = mxGetN(spikes1Pr);
        // mexPrintf("number of spike spikes in the train #%i is %i\n", trac1+1, num_spikes1); //
        
        spikes1 = (double *)mxGetPr(spikes1Pr);
        
        // mexPrintf("\tTheir values are \n"); //
        for(unsigned dummy = 0; dummy < num_spikes1; ++dummy) //
            // mexPrintf("spike %i = %f \n", dummy+1, spikes1[dummy]); //
        
        for(trac2 = trac1+1; trac2 < num_trains;  ++trac2) {
            
            synchroPr = mxCreateNumericArray(0, 0, mxDOUBLE_CLASS, mxREAL);
            mxSetM(synchroPr, 1);
            
            spikes2Pr = mxGetCell(spikes_in, trac2);
            num_spikes2 = mxGetN(spikes2Pr);
            // mexPrintf("number of spike spikes in the train #%i is %i\n", trac2+1, num_spikes2); //
            
            spikes2 = (double *)mxGetPr(spikes2Pr);
            // mexPrintf("\tTheir values are \n"); //
            for(unsigned dummy = 0; dummy < num_spikes2; ++dummy) //
                // mexPrintf("spike %i = %f \n", dummy+1, spikes2[dummy]); //
            
            // mexPrintf("\n\tReading input data has been successful \n\n"); //
            
            // if there are no spikes the value is... 1
            if (num_spikes1 + num_spikes2 == 0) {
                mxSetN(synchroPr, 1);
                mxSetData(synchroPr, mxMalloc(sizeof(double)));
            }
            else {
                mxSetN(synchroPr, num_spikes1 + num_spikes2);
                mxSetData(synchroPr, mxMalloc(sizeof(double) * (num_spikes1 + num_spikes2)));
            }
            synchro = (double *)mxGetPr(synchroPr);
            /*synchro = mxMalloc(sizeof(bool) * (num_spikes1 + num_spikes2));
             * mxSetPr(synchroPr, synchro);*/
            
            if (num_spikes1 == 0) {
                // mexPrintf("Empty first train in a pair \n");
                if (num_spikes2 == 0)
                    synchro[0] = 1;
                else
                    for(cntr1 = 0; cntr1 < num_spikes2; ++cntr1)
                        synchro[cntr1] = 0;
            }
            else {
                if (num_spikes2 == 0) {
                    // mexPrintf("Empty second train in a pair \n");
                    for(cntr1 = 0; cntr1 < num_spikes1; ++cntr1)
                        synchro[cntr1] = 0;
                }
                else   {
                    // mexPrintf("Both spike trains are non-empty \n");
                    /*init*/
                    totalCounter = 0;
                    indx[0] = 0; indx[1] = 0;
                    flag[0][0] = 0; flag[0][1] = 0;
                    flag[1][0] = 0; flag[1][1] = 0;
                    
                    while ((indx[0] < num_spikes1) || (indx[1] < num_spikes2)) {
                        
                        // mexPrintf("Entering the while loop, the counter is %i \n", totalCounter);
                        
                        if (indx[0] < num_spikes1  && indx[1] < num_spikes2) {
                            
                            // mexPrintf("Both indices are non-last. %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2);
                            
                            /*find the nearest spike (identify in which train it is - x), be carerull if there is next spike*/
                            if (spikes1[indx[0]] == spikes2[indx[1]]) {
                                // mexPrintf("Spikes at the same time are always synchronous \n");
                                
                                for(cntr1 = 0; cntr1 < 2; ++cntr1)
                                    if (flag[cntr1][0]) {
                                        tau[cntr1][1] = tau[cntr1][0];
                                        flag[cntr1][1] = 1;
                                    }
                                
                                tau[0][0] = (spikes1[indx[0]+1] - spikes1[indx[0]])/2; tau[1][0] = (spikes2[indx[1]+1] - spikes2[indx[1]])/2;
                                flag[0][0] = 1; flag[1][0] = 1;
                                synchro[totalCounter] = 1;
                                totalCounter++;
                                synchro[totalCounter] = 1; /* double check it*/
                                totalCounter++;
                                indx[0]++; indx[1]++;
                                
                                // mexPrintf("Synchro %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2);
                            
                                
                            }
                            else {
                                
                                // mexPrintf("Spikes are processed in chunks depending how many succeding spikes are in each train \n");
                                
                                // calculate the distance til neighbour spikes (half) for both trains
                                tau[0][0] = (spikes1[indx[0]+1] - spikes1[indx[0]])/2; tau[1][0] = (spikes2[indx[1]+1] - spikes2[indx[1]])/2;
                                
                                // mark that you have calculated it
                                flag[0][0] = 1; flag[1][0] = 1;
                                
                                // determine which one is first (smaller value)
                                x = (spikes1[indx[0]] < spikes2[indx[1]]) ? 0 : 1;
                                
                                // can be written in a more elegant manner
                                if (x == 0) { // if first
                                    if (indx[0] < num_spikes1 - 1) //if not the last (there is no right neighbor if its the last
                                        while(spikes1[indx[0]+1] <= spikes2[indx[1]]) { //skipping all til the change
                                            
                                            flag[0][1] = 1; /* be smarter update tau*/
                                            tau[0][1] = tau[0][0]; // since moving right becomes left, and right has to be recalculated
                                            if (indx[0] == num_spikes1 - 1) { // if last
                                                flag[0][0] = 0; // there is no right
                                                break;
                                            }
                                            indx[0]++;
                                            // mexPrintf("Chunk0 %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2);
                            
                                            tau[0][0] = (spikes1[indx[0]+1] - spikes1[indx[0]])/2;
                                            
                                            synchro[totalCounter] = 0; // all in the middle are 0
                                            totalCounter++;
                                        }
                                }
                                else { // if second... the same
                                    if (indx[1] < num_spikes2 - 1)
                                        while(spikes2[indx[1] + 1] <= spikes1[indx[0]]) {
                                            flag[1][1] = 1;
                                            tau[1][1] = tau[1][0];
                                            if (indx[1] == num_spikes2 - 1){
                                                flag[1][0] = 0;
                                                break;
                                            }
                                            indx[1]++;
                                            // mexPrintf("Chunk1 %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2);
                            
                                            tau[1][0] = (spikes2[indx[1]+1] - spikes2[indx[1]])/2;
                                            synchro[totalCounter] = 0;
                                            totalCounter++;
                                        }
                                }
                                
                                // updating taus
                                /* untill sparse matrices */
                                if (indx[0] < num_spikes1 - 1) {
                                    tau[0][0] = (spikes1[indx[0]+1] - spikes1[indx[0]])/2;
                                    flag[0][0] = 1;}
                                else
                                    flag[0][0] = 0;
                                
                                if (indx[1] < num_spikes2-1) {
                                    tau[1][0] = (spikes2[indx[1]+1] - spikes2[indx[1]])/2;
                                    flag[1][0] = 1; }
                                else
                                    flag[1][0] = 0;
                                
                                if (indx[0] > 0) {
                                    tau[0][1] = (spikes1[indx[0]] - spikes1[indx[0]-1])/2;
                                    flag[0][1] = 1;}
                                else
                                    flag[0][1] = 0;
                                
                                if (indx[1] > 0) {
                                    tau[1][1] = (spikes2[indx[1]] - spikes2[indx[1]-1])/2;
                                    flag[1][1] = 1; }
                                else
                                    flag[1][1] = 0;
                                
                                // finally the comparison
                                abso = spikes1[indx[0]] - spikes2[indx[1]];
                                abso = (abso > 0) ? abso : -abso;
                                
                                mini = (flag[0][0] == 1) ? tau[0][0] : tau[0][1];
                                
                                for(cntr1 = 0; cntr1 < 2; cntr1++)
                                    for(cntr2 = 0; cntr2 < 2; cntr2++)
                                        if (flag[cntr1][cntr2])
                                            if (mini > tau[cntr1][cntr2])
                                                mini = tau[cntr1][cntr2];
                                
                                // mexPrintf("mini = %f\n", mini);
                                // mexPrintf("abso = %f\n", abso);
                                
                                if (abso < mini) {
                                    // mexPrintf("Matched \n");
                                    synchro[totalCounter] = 1;
                                    totalCounter++;
                                    synchro[totalCounter] = 1;
                                    totalCounter++;
                                    indx[0]++; indx[1]++;
                                    // mexPrintf("Matched %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2);
                            
                                }
                                else {
                                    // mexPrintf("Mismatched \n");
                                    synchro[totalCounter] = 0;
                                    totalCounter++;
                                    indx[x]++;
                                    // mexPrintf("Mismatched. %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2);
                            
                                }
                            }
                            
                        }
                        else {
                            
                            // mexPrintf("One train has reached its last spike %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2);
                            
                            /* find out which (doesnt) fail*/
                            x = (indx[0] < num_spikes1 - 1) ? 0 : 1;
                            
                            if (x == 0) {
                                // mexPrintf("0 \n");
                                if (indx[0] < num_spikes1)
                                    while(spikes1[indx[0] + 1] <= spikes2[indx[1]]) {
                                        flag[0][1] = 1; /* be smarter update tau*/
                                        tau[0][1] = tau[0][0];
                                        if (indx[0] == num_spikes1) {
                                            flag[0][0] = 0;
                                            break;
                                        }
                                        indx[0]++;
                                        // mexPrintf("while... %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2);
                            
                                        tau[0][0] = (spikes1[indx[0]+1] - spikes1[indx[0]])/2;
                                        synchro[totalCounter] = 0;
                                        totalCounter++;
                                    }
                            }
                            else {
                                // mexPrintf("1 \n");
                                if (indx[1] < num_spikes2)
                                    while(spikes2[indx[1] + 1] <= spikes1[indx[0]]) {
                                        flag[1][1] = 1;
                                        tau[1][1] = tau[1][0];
                                        if (indx[1] == num_spikes2){
                                            flag[1][0] = 0;
                                            break;
                                        }
                                        
                                        indx[1]++;
                                        // mexPrintf("while... %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2);
                            
                                        tau[1][0] = (spikes2[indx[1]+1] - spikes2[indx[1]])/2;
                                        synchro[totalCounter] = 0;
                                        totalCounter++;
                                    }
                            }
                            
                            /* untill sparse matrices */
                            if (indx[0] < num_spikes1-1) {
                                tau[0][0] = (spikes1[indx[0]+1] - spikes1[indx[0]])/2;
                                flag[0][0] = 1;}
                            else
                                flag[0][0] = 0;
                            
                            if (indx[1] < num_spikes2-1) {
                                tau[1][0] = (spikes2[indx[1]+1] - spikes2[indx[1]])/2;
                                flag[1][0] = 1; }
                            else
                                flag[1][0] = 0;
                            
                            if (indx[0] > 0) {
                                tau[0][1] = (spikes1[indx[0]] - spikes1[indx[0]-1])/2;
                                flag[0][1] = 1;}
                            else
                                flag[0][1] = 0;
                            
                            if (indx[1] > 0) {
                                tau[1][1] = (spikes2[indx[1]] - spikes2[indx[1]-1])/2;
                                flag[1][1] = 1; }
                            else
                                flag[1][1] = 0;
                            
                            abso = spikes1[indx[0]] - spikes2[indx[1]];
                            abso = (abso > 0) ? abso : -abso;
                            
                            mini = (flag[0][0] == 1) ? tau[0][0] : tau[0][1];
                            
                            for(cntr1 = 0; cntr1 < 2; cntr1++)
                                for(cntr2 = 0; cntr2 < 2; cntr2++)
                                    if (flag[cntr1][cntr2])
                                        if (mini > tau[cntr1][cntr2])
                                            mini = tau[cntr1][cntr2];
                            
                            if (x)
                                temp = num_spikes2;
                            else
                                temp = num_spikes1;
                            
                            // mexPrintf("mini = %f\n", mini);
                            // mexPrintf("abso = %f\n", abso);
                                
                            if (abso < mini) {
                                synchro[totalCounter] = 1;
                                totalCounter++;
                                synchro[totalCounter] = 1;
                                totalCounter++;
                                if (indx[0] < num_spikes1 - 1) {
                                    indx[0]++;
                                    // mexPrintf("Finish it1 %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2);
                            
                            
                                }
                                if (indx[1] < num_spikes2 - 1) {
                                    indx[1]++;
                                    // mexPrintf("Finish it2 %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2);
                            
                            
                                }
                            }
                            else {
                                synchro[totalCounter] = 0;
                                totalCounter++;
                                if (indx[x] < temp - 1)
                                    indx[x]++;
                            }
                            
                            if (indx[x] <= temp - 1)
                            {
                                if (indx[0] < num_spikes1-1) {
                                    tau[0][0] = (spikes1[indx[0]+1] - spikes1[indx[0]])/2;
                                    flag[0][0] = 1;}
                                else
                                    flag[0][0] = 0;
                                
                                if (indx[1] < num_spikes2-1) {
                                    tau[1][0] = (spikes2[indx[1]+1] - spikes2[indx[1]])/2;
                                    flag[1][0] = 1; }
                                else
                                    flag[1][0] = 0;
                                
                                if (indx[0] > 0) {
                                    tau[0][1] = (spikes1[indx[0]] - spikes1[indx[0]-1])/2;
                                    flag[0][1] = 1;}
                                else
                                    flag[0][1] = 0;
                                
                                if (indx[1] > 0) {
                                    tau[1][1] = (spikes2[indx[1]] - spikes2[indx[1]-1])/2;
                                    flag[1][1] = 1; }
                                else
                                    flag[1][1] = 0;
                                
                                abso = spikes1[indx[0]] - spikes2[indx[1]];
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
                                    if (indx[0] < num_spikes1)
                                        indx[0]++;
                                    if (indx[1] < num_spikes2)
                                        indx[1]++;
                                    
                                    // mexPrintf("xxx1 %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2);
                            
                                }
                                else {
                                    synchro[totalCounter] = 0;
                                    totalCounter++;
                                    if (indx[x] < temp)
                                        indx[x]++;
                                    
//                                     // mexPrintf("xxx2 %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2);
                            
                                }
                            }
                            
//                             while (indx[x] < temp) {
//                                 indx[x]++;
//                                 
//                                 // mexPrintf("xxx3 %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2); //
//                             
//                                 synchro[totalCounter] = 0;
//                                 totalCounter++;
//                             }
//                             
//                             if ((indx[0] == num_spikes1) && (indx[1] == 1))
//                                 break;
                        }
                    }
                    // mexPrintf("Exiting the loop, status %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2); //
                }
                // mexPrintf("Exiting the loop, status II %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2); //
            }
            
            // mexPrintf("End %i/%i %i/%i \n", indx[0], num_spikes1, indx[1], num_spikes2); //
//             for(unsigned dummy = 0; dummy < num_spikes1 + num_spikes2; ++dummy) //
                // mexPrintf("!!! synchro %i = %f \n", dummy+1, synchro[dummy]); //
            
            temp = (num_trains - 1)*num_trains/2 - (num_trains - 1 - trac1)*(num_trains - trac1)/2 + trac2 - trac1 - 1; 
            // mexPrintf("Position of a cell is %i\n", temp+1); //
            mxSetCell(synchro_out, temp, synchroPr);
        }
    }
    // mexPrintf("\n\tThe end \n"); //
    
    return;
}