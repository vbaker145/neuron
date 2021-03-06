function [ Sdam dam_neuron ] = damage_network( S, p_neuron, p_conn )
%Damage network by removing connectivity
% S - original connectivity matrix
% p_neuron - percent (0.0-1.0) of neurons to REMOVE
% p_conn - percent (0.0-1.0) of connections to REMOVE

Sdam = S;

nRemove = ceil(size(S,1)*p_neuron);
rnd_neuron = rand(1, nRemove);
dam_neuron = round(rnd_neuron*(size(S,1)-1)+1);
Sdam(dam_neuron,:) = 0;
Sdam(:,dam_neuron) = 0;


end

