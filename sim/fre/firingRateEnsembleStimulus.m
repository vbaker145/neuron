function [st, stSpikeTrain] = firingRateEnsembleStimulus( structure, colID, excN, dt, t, nInputPool, firingRate, connStrength )
doPlot = 0;

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
ExpSize = 2;  %Length of synaptic response in milliseconds
synRespLambda = floor(ExpSize/dt);
synResp = exp(-((0:synRespLambda-1)./synRespLambda).^2);

st = zeros(N, length(t));

%Connect input pool to 1st layer of column ensemble
inputConnectivity = rand(nInputPool, N_per_layer );
inputConnectivity = inputConnectivity<0.5;
inputConnectivity(~excN(1:N_per_layer)) = 2/5*inputConnectivity(~excN(1:N_per_layer));
%inputConnectivity = 5/2*rand(1,N_per_layer).*inputConnectivity;
inputConnectivity = connStrength*rand(1,N_per_layer).*inputConnectivity;
%inputConnectivity = 5/2*inputConnectivity;

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

if doPlot == 1
    figure(100); subplot(3,1,1); plot(t, firingRate,'k');
    set(gca, 'XTick', [])
    ylabel('Firing rate (Hz)');
    set(gca, 'FontSize', 12);
    subplot(3,1,2); imagesc(t, 1:nInputPool, stSpikes==0); colormap('gray');
    set(gca, 'YDir', 'Normal');
    ylabel('Input neuron #');
    set(gca, 'FontSize', 12);
    set(gca, 'XTick', []);
    %subplot(3,1,3); imagesc(t, 1:N_per_layer, st(1:N_per_layer,:)); colorbar;
    subplot(3,1,3); plot(t, mean(st(1:N_per_layer,:)),'k')
    xlabel('Time (ms)'); ylabel('Base layer neuron #'); 
    set(gca, 'FontSize',12); set(gca, 'YDir', 'Normal');   
end

    

