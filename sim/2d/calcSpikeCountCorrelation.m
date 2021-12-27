function scc = calcSpikeCountCorrelation(spikeCounts, corrLength)

N = size(spikeCounts, 3);

refMax = N-corrLength;

scc = zeros(corrLength, 1);

for jj=1:refMax
   scc = scc + calcSpikeCountDistance(spikeCounts, jj, jj:jj+corrLength-1 ); 
end

end

