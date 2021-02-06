%% Firing rate encoding with a minicolumn ensemble
%
% 1 Create common neurons
% 
% 2 Generate connectivity for sparse and disconnected
%
% 3 Stimulate each geometry with 100 random trials (same firing rate,
% randomized stim and background
%
% 4 Metrics: # peaks, peak distance

clear all; close all;

%rng(42);

%Comment 

addpath('../lsm'); %Neural column code

dt = 0.1;
tmax = 1000;
t = 0:dt:tmax;
nInputPool = 50;
binDuration = 1;
bins = 0:binDuration:tmax;

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

%colSep = 6:10;
colSep = 2.5;
colStructs = [];
for cidx = 1:length(colSep)
    cst = makeFiringRateColumnEnsemble(dt, colSep(cidx), structure);
    cs = colStructBase;
    cs.S = cst.S;
    cs.delay = cst.delay;
    cs.structure.columnSpacing = colSep(cidx);
    colStructs = [colStructs cs];
end

%Separated minicolumn ensemble
%Same neurons as connected ensemble, different connectivity
% colStructSep = makeFiringRateColumnEnsemble(dt, 20);
% colStructS   = colStructC;
% colStructS.S = colStructSep.S;
% colStructS.delay = colStructSep.delay;
% colStructS.structure.columnSpacing = 20;
% 
% colStructs = [colStructS colStructC];

nTrials = 50;
connErr = zeros(length(colStructs), nTrials, 6);
nFirings = zeros(length(colStructs), nTrials);

for iTrial = 1:nTrials
    iTrial
    colStruct = colStructs(1);
 
    firingRate = 5*ones(1,length(t));
    %firingRate(floor(450/dt):floor(550/dt)) = 20;
    %firingRate(floor(500/dt):end) = 50;
    firingRatePeaks = 500;
    [st, stSpikes] = firingRateEnsembleStimulus( colStruct.structure, ...
                                        colStruct.csec, colStruct.ecn, dt, ...
                                        t, nInputPool, firingRate, 6 );

    % Background, corrected for dt
    stimStrength = 0;
    stB = zeros(colStruct.N, size(t,2));
    stB(colStruct.ecn,1:1/dt:end) = stimStrength*rand(sum(colStruct.ecn),tmax+1);
    stB(~colStruct.ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~colStruct.ecn),tmax+1);
    stB = (interp1(0:tmax, stB(:,1:1/dt:end)', 0:dt:tmax))';

    st = st+stB;

    %figure(22); subplot(3,1,1); plot(t,firingRate); %Firing rate graph
    %figure(22); subplot(3,1,1); plot(t, max(stImpulse));

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
        figure(201); plot(firings(:,1) ,firings(:,2)./colStruct.Nlayer, 'k.')
        
         [ nErrI, pErrI, nErrO, pErrO ] = firingRateErrorAnalysis( vall, colStruct, firingRatePeaks, dt, 0.25 );
         connErr(connIdx, iTrial, :) = [nErrI pErrI nErrO pErrO ];
         nFirings(connIdx, iTrial) = size(firings,1);
        
        %Plot results
        inputMP = mean(vall(1:colStruct.Nlayer,:));
        outputMP = mean(vall(end-colStruct.Nlayer:end,:));
        yMin = min([inputMP outputMP]);
        yMax = max([inputMP outputMP]);
        h = figure(200); %h.Position = [2159 -42 712 943];
        h=subplot(3,1,1); plot(t, mean(st(1:colStruct.Nlayer,:)),'k')
        h.Position = [0.1300 0.7093 0.7750 0.2157];
        set(gca, 'XTick', [])
        ylabel('Mean stimulus (mV)');
        set(gca, 'FontSize', 12);
        subplot(3,1,2); plot(t, inputMP, 'k');
        ax = axis; ax(3) = yMin; ax(4) = yMax; axis(ax);
        xlabel('Time (ms)'); ylabel('Mean base layer potential (mV)'); 
        set(gca, 'FontSize',12);
        subplot(3,1,3); plot(t, outputMP, 'k');
        ax = axis; ax(3) = yMin; ax(4) = yMax; axis(ax);
        xlabel('Time (ms)'); ylabel('Mean output layer potential (mV)'); 
        set(gca, 'FontSize',12); 
        

    end %End loop over columns
end %End loop over trials

for jj=1:length(colStructs)
    d = squeeze(connErr(jj,:,:));
    rmsErr(jj,:) = sqrt(mean(d.^2));
    meanErr(jj,:) = mean(d);
    stdErr(jj,:) = std(d);
    colSep(jj) = colStructs(jj).structure.columnSpacing;
end

%Plot output results
h = figure(300); plot(colSep, rmsErr(:,4),'kx-')
ax = axis; ax(1) = ax(1)-0.5; ax(2) = ax(2)+0.5; axis(ax);
xlabel('Minicolumn separation'); ylabel('Peak # error \kappa');
set(gca, 'FontSize', 12);
h2 = figure(301); errorbar(colSep, meanErr(:,5), stdErr(:,5), 'kx-')
ax = axis; ax(1) = ax(1)-0.5; ax(2) = ax(2)+0.5; axis(ax);
xlabel('Minicolumn separation'); ylabel('Peak position error \pi');
set(gca, 'FontSize', 12);


%Plot output compared to inpuit
h = figure(400); plot(colSep, rmsErr(:,4),'kx-')
hold on; plot(colSep, rmsErr(:,1), 'kx--')
ax = axis; ax(1) = ax(1)-0.5; ax(2) = ax(2)+0.5; axis(ax);
xlabel('Minicolumn separation'); ylabel('Peak # error \kappa');
set(gca, 'FontSize', 12);
h2 = figure(401); errorbar(colSep, meanErr(:,5), stdErr(:,5), 'kx-')
hold on; errorbar(colSep, meanErr(:,2), stdErr(:,2), 'kx--')
ax = axis; ax(1) = ax(1)-0.5; ax(2) = ax(2)+0.5; axis(ax);
xlabel('Minicolumn separation'); ylabel('Peak position error \pi');
set(gca, 'FontSize', 12);

%% plotting
% h = figure(200); h.Position = [2159 -42 712 943];
% h=subplot(3,1,1); plot(t, firingRate,'k');
% h.Position = [0.1300 0.7093 0.7750 0.2157];
% set(gca, 'XTick', [])
% ylabel('Firing rate (Hz)');
% set(gca, 'FontSize', 12);
% h = subplot(3,1,2); plot(t,inputMP,'k');
% ax = axis; ax(3) = yMin; ax(4) = yMax; axis(ax);
% ylabel('Mean potential (mV)');
% set(gca, 'FontSize', 12);
% set(gca, 'XTick', []);
% subplot(3,1,3); plot(t, outputMP, 'k');
% ax = axis; ax(3) = yMin; ax(4) = yMax; axis(ax);
% xlabel('Time (ms)'); ylabel('Mean potential (mV)'); 
% set(gca, 'FontSize',12); 

%% Plot results
%figure; imagesc(t, 1:nInputPool, stSpikes); colorbar; colormap('gray');
% figure(100); subplot(3,1,1); plot(t, firingRate,'k');
% set(gca, 'XTick', [])
% ylabel('Firing rate (Hz)');
% set(gca, 'FontSize', 12);
% subplot(3,1,2); imagesc(t, 1:nInputPool, stSpikes==0); colormap('gray');
% set(gca, 'YDir', 'Normal');
% ylabel('Input neuron #');
% set(gca, 'FontSize', 12);
% set(gca, 'XTick', []);
% subplot(3,1,3); imagesc(t, 1:colStruct.Nlayer, st(1:colStruct.Nlayer,:)); colorbar;
% xlabel('Time (ms)'); ylabel('Base layer neuron #'); 
% set(gca, 'FontSize',12); set(gca, 'YDir', 'Normal');
% 
% for jj=0:colStruct.nCols-1
%     %Firing plot, color-coded by column
%     idx = colStruct.csec(firings(:,2))==jj;
%     f = firings(idx,:);
%     fc{jj+1} = f;
%     figure(20); hold on;
%     plot(f(:,1)./1000, floor(f(:,2)/colStruct.Nlayer),'.');
%     axis([0 max(t)/1000 0 colStruct.structure.layers] ); 
%     text(0.9,80,['COl #=' num2str(jj)],'BackgroundColor', 'White')
%     
%     %Input layer and output layer average firing rate
%     figure(22); subplot(3,1,2); hold on;
%     sidx = find( f(:,2)<colStruct.Nlayer );
%     hcs(jj+1,:) = histcounts(f(sidx,1),bins);
%     plot(bins(1:end-1)+binDuration/2, hcs(jj+1,:));
%     subplot(3,1,3); hold on;
%     eidx = find( f(:,2)>(colStruct.N-colStruct.Nlayer) );
%     hce(jj+1,:) = histcounts(f(eidx,1), bins);
%     plot(bins(1:end-1)+binDuration/2, hce(jj+1,:));
%     
% end

% Plot total histograms
% figure(22); 
% subplot(3,1,2); hold on;
% hcsSum = sum(hcs); hcsStd = std(hcs);
% hceSum = sum(hce); hceStd = std(hce);
% ymax = max(hceSum);
% %errorbar(bins(1:end-1)+binDuration/2, hcsSum, hcsStd);
% plot(bins(1:end-1)+binDuration/2, hcsSum, 'k');
% ax = axis; ax(4) = ymax; axis(ax);
% subplot(3,1,3); hold on;
% plot(bins(1:end-1)+binDuration/2, hceSum, 'k');
% ax = axis; ax(4) = ymax; axis(ax);

