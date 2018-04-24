% This is an example file that demonstrates how to set the time instants using a Matlab script.

if ~exist('spikes','var')
    spikes=allspikes; 
end
trac=1;
d_para.instants=round(spikes{trac}/d_para.dts)*d_para.dts;       % Time instants when a certain neuron fires

