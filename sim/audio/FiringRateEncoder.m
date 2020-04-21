% Firing rate encoder
% Demosntrate that a column ensemble can encode the firing rate of an input
% pool into traveling waves

clear all; close all;

addpath('../lsm'); %Neural column code

dt = 0.05;
t = 0:dt:3000-dt;
nInputPool = 50;

%Make column ensemble
colStruct = makeFiringRateColumnEnsemble(dt);

% firingRate = 1*ones(1,length(t));
% for jj=1:9
%    sidx = floor(jj*1000/dt);
%    firingRate(sidx:sidx+floor(100/dt)) = 5;
% end

firingRate = 10*(sin(2*pi*8.*(t./1000))+1);
%firingRate = [15*ones(1,length(t)/2) 30*ones(1,length(t)/2)];
%firingRate = t./20;
[st, stSpikes] = firingRateEnsembleStimulus( colStruct.structure, colStruct.csec, colStruct.ecn, dt, t, nInputPool, firingRate );


vinit=-65*ones(colStruct.N,1)+0*rand(colStruct.N,1);    % Initial values of v
uinit=(colStruct.b).*vinit;                 % Initial values of u

[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), ...
    colStruct.a, colStruct.b, colStruct.c, colStruct.d, colStruct.S, ...
    colStruct.delays, st);                                
                            

figure; imagesc(t, 1:nInputPool, stSpikes); colorbar; colormap('gray');
set(gca, 'YDir', 'Normal');
title('Input neurons, # spikes/50 ms')
xlabel('Time (ms)'); ylabel('Input neuron #');
set(gca, 'FontSize', 12);

figure; 
title('Input/Output neuron layer, mean membrane potential')
subplot(2,1,1); plot(t, mean(vall(1:16,:))); 
subplot(2,1,2); plot(t, mean(vall(end-16:end,:))); 
xlabel('Time (ms)'); ylabel('Membrane potential (mV)');
set(gca, 'FontSize', 12);

figure; plot(firings(:,1), firings(:,2),'k.')
xlabel('Time (ms'); ylabel('Neuron #')
set(gca, 'FontSize',12)
