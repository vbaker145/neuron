function [ nErrI, pErrI, nErrO, pErrO ] = firingRateErrorAnalysis( vall, colStruct, firingRatePeaks, dt, thresh )

inputMP = mean(vall(1:colStruct.Nlayer,:));
outputMP = mean(vall(end-colStruct.Nlayer:end,:));

%Find peaks in input/output membrane potential
[ip iw op ow] = findPeaks(inputMP, outputMP, dt, thresh);

%Calculate number error
nErrI = length(ip)-length(firingRatePeaks);
nErrO = length(op)-length(firingRatePeaks);

%Calculate mean-squared position error
dp = abs(repmat(ip, length(firingRatePeaks), 1) - repmat(firingRatePeaks', 1, length(ip)));
pErrI = mean(sqrt(min(dp).^2));
dp = abs(repmat(op, length(firingRatePeaks), 1) - repmat(firingRatePeaks', 1, length(op)));
pErrO = mean(sqrt(min(dp).^2));

    
end

