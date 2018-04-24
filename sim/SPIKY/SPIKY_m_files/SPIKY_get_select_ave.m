% This is an example file that demonstrates how to set the intervals for the selective averaging using a Matlab script.

if ~exist('spikes','var')
    spikes=allspikes; 
end
if ~isempty(d_para.thick_markers)
    dummy=[d_para.tmin d_para.thick_markers d_para.tmax];
    d_para.selective_averages=cell(1+length(dummy)-1);
    for tmc=1:length(dummy)-1
        d_para.selective_averages{tmc+1}=[dummy(tmc) dummy(tmc+1)];
    end
end
d_para.selective_averages{1}=[d_para.tmin d_para.tmax];       % Selective averaging over the whole time interval
