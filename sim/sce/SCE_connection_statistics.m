function [ avgNConn avgNExc avgNInhib avgEI tConn] = SCE_connection_statistics( S )
%Calculate connection statistics

nConn = (S~=0)';
nExc = (S>0)';
nInhib = (S<0)';

tConn = sum(nConn);
avgNConn = mean(sum(nConn));
avgNExc = mean(sum(nExc));
avgNInhib = mean(sum(nInhib));
avgEI = mean(sum(S));

end

