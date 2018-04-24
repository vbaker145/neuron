% This is an example file that demonstrates how to set the triggered averaging using a Matlab script.

if ~exist('spikes','var')
    spikes=allspikes; 
end
tracs=1+[0 1 2 3]*d_para.num_all_trains/4;
tracs=unique(round(tracs));
tracs=tracs(tracs>=1 & tracs<=d_para.num_all_trains);
d_para.triggered_averages=cell(1,length(tracs));
for trac=1:length(tracs)
    d_para.triggered_averages{trac}=round(spikes{tracs(trac)}/d_para.dts)*d_para.dts;       % Triggered averaging over all time instants when a certain neuron fires
end
