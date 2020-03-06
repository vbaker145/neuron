% Firing rate encoder
% Demosntrate that a column ensemble can encode the firing rate of an input
% pool into traveling waves

clear all; close all;
dt = 0.05;
t = 0:dt:10000-dt;
nInputPool = 10;

%Make column ensemble
colStruct = makeFiringRateColumnEnsemble(dt);

%firingRate = 25*ones(1,length(t));
firingRate = [15*ones(1,length(t)/2) 30*ones(1,length(t)/2)];
%firingRate = t./20;
[st, stSpikes] = firingRateEnsembleStimulus( colStruct.structure, colStruct.csec, dt, t, nInputPool, firingRate );


vinit=-65*ones(colStruct.N,1)+0*rand(colStruct.N,1);    % Initial values of v
uinit=(colStruct.b).*vinit;                 % Initial values of u

[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), ...
    colStruct.a, colStruct.b, colStruct.c, colStruct.d, colStruct.S, ...
    colStruct.delays, st);                                
                            

figure; imagesc(t, 1:nInputPool, stSpikes); colorbar; colormap('gray');
set(gca, 'YDir', 'Normal');
title('Input neurons, # spikes/50 ms')

figure; plot(t, mean(vall(end-16:end,:))); 
%colorbar; colormap('jet'); caxis([-70 -30]);

title('Output neuron layer, mean membrane potential')
