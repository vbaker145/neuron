%% Firing rate encoding with a minicolumn ensemble
%
% 1 Create common neurons
% 
% 2 Generate connectivity for sparse and disconnected
%
% 3 Stimulate each geometry with different firing rates 
%

clear all; close all;

rng(41);

addpath('../lsm'); %Neural column code

dt = 0.1;
tmax = 2000;
t = 0:dt:tmax;
nInputPool = 50;
binDuration = 1;
bins = 0:binDuration:tmax;

%Neuron damage %
nd = [0 0.05 0.1];

%Input firing rates
firingRates = 21;
nFiringRates = length(firingRates);

%Make column ensemble
%Connected microcolumn ensemble
structure.width = 2;
structure.height = 2;
structure.nWide = 2;
structure.nHigh = 2;
structure.columnSpacing = 3.5;
structure.layers = 10;
structure.displacement = 0;

nTrials = 20;

colSep = 2; 
colStructBase = makeFiringRateColumnEnsemble(dt, colSep, structure);
colStructs = {}; neuronsRemoved = [];

for cidx = 1:length(nd)
    for tidx = 1:nTrials
        cs = colStructBase;
        [cs.S neuronsRemoved{cidx,tidx}] = damage_network(colStructBase.S, nd(cidx),0 );
        colStructs{cidx,tidx} =  cs;
    end
end



for fr = 1:nFiringRates
    fr

    %Random stimulus and background
    firingRate = firingRates(fr)*ones(1,length(t));
    [st, stSpikes] = firingRateEnsembleStimulus( colStructBase.structure, ...
                                        colStructBase.csec, colStructBase.ecn, dt, ...
                                        t, nInputPool, firingRate, 6 );
                                                
    %% Simulate column ensembles
    for ndi = 1:length(nd)       
            for trial = 1:nTrials
                %Damage network
                colStructT = colStructs{ndi,trial};
                
                vinit=-65*ones(colStructT.N,1)+0*rand(colStructT.N,1);    % Initial values of v
                uinit=(colStructT.b).*vinit;                 % Initial values of u

                %Simulate column ensemble
                [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), ...
                    colStructT.a, colStructT.b, colStructT.c, colStructT.d, colStructT.S, ...
                    colStructT.delays, st);  
                size(firings)

                %Record # of peaks
                inputMP = mean(vall(1:colStructT.Nlayer,:));
                outputMP = mean(vall(end-colStructT.Nlayer:end,:));

                %Find peaks in input/output membrane potential
                [ip iw op ow] = findPeaks(inputMP, outputMP, dt, 0.25);
                npks(fr, ndi, trial) = (length(op)-1)./(tmax/1000);
            end %End trial loop
    end   %End loop over connection strength
end %End loop over firing rates
    
m = mean(npks,3);
v = std(npks,0,3);
figure(20); errorbar(firingRates,m(:,1), v(:,1));
for jj=2:size(m,2)
    hold on; errorbar(firingRates,m(:,jj), v(:,jj));
end
xlabel('Input firing rate (spikes/second)');
ylabel('Output wave rate (waves/second)');
legend(split(num2str(nd)));
set(gca,'FontSize', 14);

%Plot of all trials for single firing rate
if length(firingRates) == 1
   %Plot output wave rates for all trials 
   figure(30); plot(squeeze(npks)', 'x-');
   xlabel('trial #'); ylabel('Output wave rate (waves/second)');
   set(gca, 'FontSize', 14);
   legend(split(num2str(nd)));
   set(gca,'FontSize', 14);
   
   %Show which neurons were removed for which trial
   figure(31); hold on;
   for jj=1:nTrials
      nr = neuronsRemoved(2,jj);
      if ~isempty(nr{1})
        plot( jj*ones(1,length(nr)), nr{:}, 'ko');
      end
   end
end
