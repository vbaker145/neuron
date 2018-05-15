%Determine propagation time by column width
clear; close all

ntrials = 100;
widthIdx = 1;

for jj=2:4
    idx = 0;
    while idx < ntrials
        idx
        pt = ImpulseResponse(jj);
        if pt > 0
            idx = idx + 1;
            ptime(idx, widthIdx) = pt;
        end
    end
    widthIdx = widthIdx + 1;
    widthIdx
end