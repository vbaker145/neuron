function stImpulse = impulseEnsembleStimulus( structure, colID, dt, t, stimStrength )

% structure: defines structure of microcolumn ensemble
% colID - column labels for all neurons
% dt - time step
% t - simulation times
% nInputPool - number of neurons in the input pool
% firingRate - instantaneous average firing rates of input pool

N = structure.width*structure.nWide*structure.height*structure.nHigh*structure.layers;
N_per_layer = structure.width*structure.nWide*structure.height*structure.nHigh;
N_cols = structure.nWide*structure.nHigh;

stImpulse = zeros(N, size(t,2));
stimDuration = floor(20/dt);
stimDepth = 2;
sneurons = find(colID(1:stimDepth*N_per_layer) == 0);
stImpulse(sneurons,20:(20+stimDuration))= stimStrength;
stImpulse = (interp1(0:max(t), stImpulse(:,1:1/dt:end)', 0:dt:max(t)))';

end