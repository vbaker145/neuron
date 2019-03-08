function [ sizes waveFraction slopes ] = analyzeWaves( wt, wp, labels )
%Analyze properties of traveling waves
% wt - vector of firing cluster times
% wp - vector of firing cluster z value
% labels - cell array, each element is a set of indices defining one
% traveling wave

nWavePts = sum(cellfun(@length,labels));
waveFraction = nWavePts/length(wp);
sizes = cellfun(@length,labels);
    
%Find slope
slopes = [];
for jj=1:length(labels)
    wl = labels{jj};
    wpAbs = abs(wp(wl)-wp(wl(1)));
    wtRef = wt(wl)-wt(wl(1));
    slopes(jj) = wtRef'\wpAbs';  
    
    wtj = wt(wl); wpj = wp(wl);
    
    pidx = [min(wp(wl)), max(wp(wl))];
end


end

