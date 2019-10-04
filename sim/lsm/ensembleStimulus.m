function st = ensembleStimulus( structure, colID, dt, t, stimType, stimStrength, stimFrq, stimPhs )

% structure: defines structure of microcolumn ensemble
% layers - number of layers in microcolumn
% colID - column labels for all neurons
% dt - time step
% t - simulation times
% stim - stimulus type

N = structure.width*structure.nWide*structure.height*structure.nHigh*structure.layers;
N_per_layer = structure.width*structure.nWide*structure.height*structure.nHigh;
N_cols = structure.nWide*structure.nHigh;
N_per_column = N_per_layer/N_cols;

st = zeros(N_per_layer, length(t));

if stimType == 1
    %Impulse stimulus on one column 
    st = zeros(N, length(t));
    sidx = 1;
    stimDuration = floor(20/dt);
    stimDepth = 5;
    idx = find(colID(1:N_per_layer)==0);
    st(idx, sidx:sidx+stimDuration)= stimStrength;
elseif stimType == 2
    %Sine stimulus all columns
    st = zeros(N, length(t));
    for jj=1:N_cols
        idx = find(colID(1:N_per_layer*4)==(jj-1));
        phs = stimPhs(jj);
        st(idx, :)= repmat(stimStrength*sin(2*pi*stimFrq.*(t/1000)+phs),length(idx),1);
    end
end


end

