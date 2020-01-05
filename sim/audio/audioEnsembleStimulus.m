function st = audioEnsembleStimulus( structure, colID, dt, t, stimVals, stimStrength )

% structure: defines structure of microcolumn ensemble
% colID - column labels for all neurons
% dt - time step
% t - simulation times
% stimvals - stimulus matrix, one input column for each ensemble column

N = structure.width*structure.nWide*structure.height*structure.nHigh*structure.layers;
N_per_layer = structure.width*structure.nWide*structure.height*structure.nHigh;
N_cols = structure.nWide*structure.nHigh;
N_per_column = N_per_layer/N_cols;

st = zeros(N_per_layer, length(t));

%Sine stimulus all columns
st = zeros(N, length(t));
for jj=1:N_cols
    idx = find(colID(1:N_per_layer*4)==(jj-1));
    sv = bsa(stimVals(:,jj));
    st(idx, :) = stimStrength.*repmat(sv', length(idx),1);
    %st(idx, :) = stimStrength.*repmat(stimVals(:,jj)', length(idx),1);
    %st(idx, :)= repmat(stimStrength*sin(2*pi*stimFrq.*(t/1000)+phs),length(idx),1);
end

    

