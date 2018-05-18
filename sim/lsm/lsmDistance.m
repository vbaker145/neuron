function [ stimDis, respDis] = lsmDistance( stim1, resp1, stim2, resp2 )

%De-mean data
%stim1 = stim1 - mean(stim1); stim2 = stim2 - mean(stim2);
%resp1 = resp1 - mean(resp1); resp2 = resp2 - mean(resp2);

stimDis = mean(sqrt((stim1-stim2).^2));
respDis = sqrt(sum((resp1-resp2).^2))./size(resp1,1);

end

