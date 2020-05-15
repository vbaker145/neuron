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

addpath('../lsm'); %Neural column code

dt = 0.05;
tmax = 3000;
t = 0:dt:tmax;
nInputPool = 50;
binDuration = 1;
bins = 0:binDuration:tmax;

%Make column ensemble
%Connected microcolumn ensemble

colStructBase    = makeFiringRateColumnEnsemble(dt, 4);

colSep = 4:4:20;
colStructs = [];
for cidx = 1:length(colSep)
    cst = makeFiringRateColumnEnsemble(dt, colSep(cidx));
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

nTrials = 3;
connErr = zeros(length(colStructs), nTrials, 4);

for iTrial = 1:nTrials
    colStruct = colStructs(1);

    %Random stimulus and background
    firingRateHz = 3;
    %firingRate = 5*(cos(2*pi*3.*(t./1000))+1); %Cosine, positive
    firingRate = 10*(sin(2*pi*(firingRateHz/2)*(t./1000))).^2; %Cosine, raised
    firingRateInvMs = (1/firingRateHz)*1000;
    firingRatePeaks = (0.5*firingRateInvMs:firingRateInvMs:tmax);
    [st, stSpikes] = firingRateEnsembleStimulus( colStruct.structure, colStruct.csec, colStruct.ecn, dt, t, nInputPool, firingRate );

    % Background, corrected for dt
    stimStrength = 3;
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
        [ nErrI, pErrI, nErrO, pErrO ] = firingRateErrorAnalysis( vall, colStruct, firingRatePeaks, dt, 0.25 );
        connErr(connIdx, iTrial, :) = [nErrI pErrI nErrO pErrO ];
    end %End loop over columns
end %End loop over trials

for jj=1:length(colStructs)
    d = squeeze(connErr(jj,:,:));
    rmsErr(jj,:) = sqrt(mean(d.^2));
    colSep(jj) = colStructs(jj).structure.columnSpacing;
end

figure(20); plot(colSep, rmsErr(:,3)./9,'kx-');
hold on; plot(colSep, rmsErr(:,4)./333,'bx-');
xlabel('Minicolumn separation');
ylabel('% error');
legend('# peaks error', 'Peak position error');
set(gca,'FontSize',12);

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

