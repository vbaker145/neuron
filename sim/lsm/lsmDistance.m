function [ stimDis, respDis] = lsmDistance( stim1, resp1, stim2, resp2 )

stimDis = sqrt(sum((stim1-stim2).^2))/sqrt(sum(stim1.^2));
respDis = sqrt(sum((resp1-resp2).^2))/sqrt(sum(resp1.^2));

end

