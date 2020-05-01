function [st, stSpikeTrain] = firingRateEnsembleStimulus( structure, colID, excN, dt, t, nInputPool, firingRate )

% structure: defines structure of microcolumn ensemble
% colID - column labels for all neurons
% dt - time step
% t - simulation times
% nInputPool - number of neurons in the input pool
% firingRate - instantaneous average firing rates of input pool

N = structure.width*structure.nWide*structure.height*structure.nHigh*structure.layers;
N_per_layer = structure.width*structure.nWide*structure.height*structure.nHigh;
N_cols = structure.nWide*structure.nHigh;
N_per_column = N_per_layer/N_cols;

%Synaptic response model
ExpSize = 4;  %Length of synaptic response in milliseconds
synRespLambda = floor(ExpSize/dt);
synResp = exp(-((0:synRespLambda-1)./synRespLambda).^2);

st = zeros(N, length(t));

%Connect input pool to 1st layer of column ensemble
inputConnectivity = rand(nInputPool, N_per_layer );
inputConnectivity = inputConnectivity<0.5;
inputConnectivity(~excN(1:N_per_layer)) = 0;
%inputConnectivity = rand(1,N_per_layer).*inputConnectivity;
inputConnectivity = 5/2*inputConnectivity;

%Caculate firing events for input pool based on firing rate
dtStep = 10/dt; 
stSpikes = zeros(nInputPool, length(t));
stSpikeTrain = []; pidx = 1;
for tidx = 1:dtStep:length(t)
    for jj=1:nInputPool
        pst =  poissonSpikeTrain( dtStep*dt/1000, firingRate(tidx), dt/1000);
        stSpikes(jj, tidx:tidx+dtStep-1) = conv(pst,synResp,'same');
        stSpikeTrain(jj, pidx) = sum(pst);
    end
    pidx = pidx+1;
end

stSpikes = stSpikes(:,1:length(t) ); %Trim any extra time

for jj=1:N_per_layer
    st(jj,:) = sum( stSpikes.*repmat(inputConnectivity(:,jj),1 ,length(t) ) );
end


%Map input firings to column stimulus
% st = zeros(N, length(t));
% for jj=1:N_cols
%     idx = find(colID(1:N_per_layer*4)==(jj-1));
%     sv = bsa(stimVals(:,jj));
%     st(idx, :) = stimStrength.*repmat(sv', length(idx),1);
%     %st(idx, :) = stimStrength.*repmat(stimVals(:,jj)', length(idx),1);
%     %st(idx, :)= repmat(stimStrength*sin(2*pi*stimFrq.*(t/1000)+phs),length(idx),1);
% end

    

