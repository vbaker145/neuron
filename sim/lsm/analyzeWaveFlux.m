function [ dummy ] = analyzeWaveFlux( wt, wp, labels, firings )
%Analyze properties of traveling waves
% wt - vector of firing cluster times
% wp - vector of firing cluster z value
% labels - cell array, each element is a set of indices defining one
% traveling wave
% Raw firing events

nWavePts = sum(cellfun(@length,labels));
waveFraction = nWavePts/length(wp);
sizes = cellfun(@length,labels);
    
%Find slope

figure;
for tt = 0:0.01:max(firings(:,1))
       fwin = firings(firings(:,1)>tt & firings(:,1)<(tt+0.02),:);
       histogram(fwin(:,2),0:10:200); title(tt)
end
    
slopes = [];
for jj=1:length(labels)
    wl = labels{jj}; 
    
    wtj = wt(wl); wpj = wp(wl);
    tidx = [min(wtj), max(wtj)];
    pidx = [min(wpj), max(wpj)];
    
    idx =  (firings(:,1)>tidx(1)) & (firings(:,1)<tidx(2)) & (firings(:,2)>pidx(1)) & (firings(:,2)<pidx(2));
    f = firings(idx,:);
    
    %figure; plot(wtj, wpj, 'ko');
    %hold on; plot(f(:,1), f(:,2), 'k.');
    
    
end


end

