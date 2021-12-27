function scd = calcSpikeCountDistance(spikeCounts, refIdx, scdRange)

thresh = 3;
sct = spikeCounts>thresh;

Npx = size(spikeCounts,1)*size(spikeCounts,2);

nSCD = length(scdRange);
scd = zeros(nSCD, 1);
scRef = squeeze( spikeCounts(:,:,refIdx) );
scRef = scRef - mean(scRef(:));
scRef = scRef./sqrt(sum(abs(scRef(:))));


for ii = 1:nSCD
    scComp = squeeze( spikeCounts(:,:,scdRange(ii)) );
    scComp = scComp-mean(scComp(:));
    scComp = scComp./sqrt(sum(abs(scComp(:))));
    %scd(ii) = sum( (scRef(:)-scComp(:)).^2 ) / Npx;
    scd(ii) = sum((scRef(:).*scComp(:)))/2;
end

end

