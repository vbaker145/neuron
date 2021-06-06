%% Firing rate encoding with a population of SCEs
%
% 1 Create SCE neurons 
% 
% 2 Generate connectivity for the three population types
%
% 3 Generate a common stimulus
% 
% 4 Measure wave rate and efficiency with 0% and 10% neuron damage
%

clear all; close all;

rng(42);

addpath('../lsm'); %Neural column code

dt = 0.1;
tmax = 2000;
t = 0:dt:tmax;
nInputPool = 50;
binDuration = 1;
bins = 0:binDuration:tmax;

%Neuron damage %
nd = [0.05 0.1];

%Input firing rates
firingRates = 21;
nFiringRates = length(firingRates);

%Make column ensemble
%Connected microcolumn ensemble
structure.width = 2;
structure.height = 2;
structure.nWide = 3;
structure.nHigh = 3;
structure.columnSpacing = 3.5;
structure.layers = 10;
structure.displacement = 0;

nTrials = 10;

morphologies = {'One big SCE', 'Independent SCE', 'Coupled SCE'};
nMorph = length(morphologies);

%Base population, one big SCE
colStructOneBigSCE = makeFiringRateColumnEnsemble(dt, 2, structure);

%4 independent SCE
colStructIndependent = makeFiringRateColumnEnsemble(dt, 20, structure);

%4 coupled SCE
colStructCoupled = makeFiringRateColumnEnsemble(dt, 3.5, structure);

colStructs = {}; neuronsRemoved = [];

for cidx = 1:length(nd)
    for tidx = 1:nTrials
        s = rng();
        
        cs = colStructOneBigSCE;
        [cs.S, neuronsRemoved{cidx,tidx}] = damage_network(colStructOneBigSCE.S, nd(cidx) );
        colStructs{(cidx-1)*nMorph+1,tidx} =  cs;
        
        rng(s);
        cs = colStructIndependent;
        [cs.S, neuronsRemoved{cidx,tidx}] = damage_network(colStructIndependent.S, nd(cidx) );
        colStructs{(cidx-1)*nMorph+2,tidx} = cs;
        
        rng(s);
        cs = colStructCoupled;
        [cs.S, neuronsRemoved{cidx,tidx}] = damage_network(colStructCoupled.S, nd(cidx) );
        colStructs{(cidx-1)*nMorph+3, tidx} = cs;
        
    end
end



for fr = 1:nFiringRates
    fr

    %Random stimulus and background
    firingRate = firingRates(fr)*ones(1,length(t));
    [st, stSpikes] = firingRateEnsembleStimulus( colStructOneBigSCE.structure, ...
                                        colStructOneBigSCE.csec, colStructOneBigSCE.ecn, dt, ...
                                        t, nInputPool, firingRate, 6 );
                                    
    %Baseline wave rates for each morphology
    [npOneBigSCE, nfrOneBigSCE] = test_sce(colStructOneBigSCE, dt, t, st, tmax );
    [npIndependent, nfrIndependent] = test_sce(colStructIndependent, dt, t, st, tmax );
    [npCoupled, nfrCoupled] = test_sce(colStructCoupled, dt, t, st, tmax );
                                                
    %% Simulate column ensembles
    for ndi = 1:length(nd)   
        for scePopIdx = 1:nMorph
            colIdx = (ndi-1)*nMorph+scePopIdx;
            for trial = 1:nTrials
                colStructT = colStructs{colIdx,trial};
                [colIdx trial]
                [np, nfr] = test_sce(colStructT, dt, t, st, tmax );
                npks(fr, colIdx, trial) = np;
                nfires(fr,colIdx,trial) = nfr;
            end %End trial loop
        end %End loop over population morphologies
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
   popWaveRate = squeeze(npks)';
   popNFires = squeeze(nfires)';
   
   %Plot output waves rates for each morphology and damage %
   figure(40); subplot(length(nd), nMorph,1); hold on;
   for jj=1:length(nd)
       for kk=1:nMorph
           didx = (jj-1)*3+kk;
           subplot(length(nd), nMorph, didx);
           histogram(popWaveRate(:,didx), 0:0.5:8);
           title([morphologies{kk} ', damage ' num2str(nd(jj)*100) '%' ]);
           xlabel('Wave rate'); ylabel('# trials');
       end
   end
   
   %Plot firing rates for each morphology and damage %
   figure(50); subplot(length(nd),1,1); 
   for jj=1:length(nd)
       subplot(length(nd),1,jj); 
       cidx = (jj-1)*nMorph+1;
       mf = mean(popNFires(:, cidx:cidx+nMorph-1));
       bar(categorical(morphologies),mf);
       ylabel('Total # spikes');
       title(['Damage ' num2str(nd(jj)*100) '%']);
   end
   
end


%%
% Encapsulate SCE execution
function [npks, nfires] = test_sce(colStructT, dt, t, st, tmax )
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
    
    npks = (length(op)-1)./(tmax/1000);
    nfires = size(firings,1);
end


