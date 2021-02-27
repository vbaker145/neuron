%% Firing rate encoding with a minicolumn ensemble
%
% 1 Create common neurons
% 
% 2 Generate connectivity for sparse and disconnected
%
% 3 Stimulate each geometry with different firing rates 
%

clear all; close all;

rng(42);

%Comment 

addpath('../lsm'); %Neural column code

dt = 0.1;
tmax = 2000;
t = 0:dt:tmax;
nInputPool = 50;
binDuration = 1;
bins = 0:binDuration:tmax;

%Make column ensemble
%Make column ensemble
%Connected microcolumn ensemble
structure.width = 2;
structure.height = 2;
structure.nWide = 1;
structure.nHigh = 1;
structure.columnSpacing = 2.5;
structure.layers = 10;
structure.displacement = 0;

nTrials = 100;

colSep = 3.125;
colStruct = makeFiringRateColumnEnsemble(dt, colSep, structure);

%Connection strength (relative)
cs = 0.5:0.1:1.5;

firingRates = 1:4:21;
nFiringRates = length(firingRates);

for fr = 1:nFiringRates
    fr

    %% Simulate column ensembles
    for csi = 1:length(cs)

            colStructT = colStruct;
            colStructT.S = colStructT.S * cs(csi);
            
            for trial = 1:nTrials
                %Random stimulus and background
                firingRate = firingRates(fr)*ones(1,length(t));
                [st, stSpikes] = firingRateEnsembleStimulus( colStructT.structure, ...
                                                    colStructT.csec, colStructT.ecn, dt, ...
                                                    t, nInputPool, firingRate, 6 );

                vinit=-65*ones(colStruct.N,1)+0*rand(colStruct.N,1);    % Initial values of v
                uinit=(colStruct.b).*vinit;                 % Initial values of u

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
                npks(fr, csi, trial) = (length(op)-1)./(tmax/1000);
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
legend(split(num2str(cs)));
set(gca,'FontSize', 14);
