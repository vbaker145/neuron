%% Firing rate encoding with a minicolumn ensemble
%
% 1 Create common neurons
% 
% 2 Generate connectivity for sparse and disconnected
%
% 3 Stimulate each geometry with different firing rates 
%

clear all; close all;

%rng(42);

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
structure.nWide = 2;
structure.nHigh = 2;
structure.columnSpacing = 2.5;
structure.layers = 10;
structure.displacement = 0;
colStructBase    = makeFiringRateColumnEnsemble(dt, 7, structure);


colSep = [structure.width (structure.width-1)+colStructBase.connectivity.lambda];
%colSep = structure.width;
colStructs = [];
for cidx = 1:length(colSep)
    cst = makeFiringRateColumnEnsemble(dt, colSep(cidx), structure);
    cs = colStructBase;
    cs.S = cst.S;
    cs.delay = cst.delay;
    cs.structure.columnSpacing = colSep(cidx);
    colStructs = [colStructs cs];
end
firingRates = [1 2 10 20];
nFiringRates = length(firingRates);

%connErr = zeros(length(colStructs), nTrials, 6);
%nFirings = zeros(length(colStructs), nTrials);

for fr = 1:nFiringRates
    fr
    
    %Random stimulus and background
    firingRate = firingRates(fr)*ones(1,length(t));
    [st, stSpikes] = firingRateEnsembleStimulus( colStructBase.structure, ...
                                        colStructBase.csec, colStructBase.ecn, dt, ...
                                        t, nInputPool, firingRate, 6 );

    %% Simulate column ensembles
    for connIdx =1:length(colStructs)
        colStruct = colStructs(connIdx);

        vinit=-65*ones(colStruct.N,1)+0*rand(colStruct.N,1);    % Initial values of v
        uinit=(colStruct.b).*vinit;                 % Initial values of u

        %Connected minicolumn ensemble
        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), ...
            colStruct.a, colStruct.b, colStruct.c, colStruct.d, colStruct.S, ...
            colStruct.delays, st);  
        size(firings)

        figure(10); subplot(length(colStructs), nFiringRates,(connIdx-1)*nFiringRates+fr);
        plot(firings(:,1) ,firings(:,2)./colStruct.Nlayer, 'k.')
        title(num2str(firingRates(fr)));
        set(gca,'FontSize', 12);
    end %End loop columns
end %End loop over trials

