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
colStruct = makeFiringRateColumnEnsemble(dt);

%% Firing rate coded stimulus
% firingRate = 1*ones(1,length(t));
% for jj=1:9
%    sidx = floor(jj*1000/dt);
%    firingRate(sidx:sidx+floor(100/dt)) = 5;
% end

firingRateHz = 3;
%firingRate = 5*(cos(2*pi*3.*(t./1000))+1); %Cosine, positive
firingRate = 10*(sin(2*pi*(firingRateHz/2)*(t./1000))).^2; %Cosine, raised
firingRateInvMs = (1/firingRateHz)*1000;
firingRatePeaks = (0.5*firingRateInvMs:firingRateInvMs:tmax);
[st, stSpikes] = firingRateEnsembleStimulus( colStruct.structure, colStruct.csec, colStruct.ecn, dt, t, nInputPool, firingRate );

%% Impulse stimulus
%Impulsive stimulus
stImpulse = zeros(colStruct.N, size(t,2));
sidx = 1;
stimDuration = floor(20/dt);
stimDepth = 1;
cwidth = colStruct.structure.width*colStruct.structure.nWide;
cheight = colStruct.structure.height*colStruct.structure.nHigh;
for jj=1:floor(tmax/1000)
    impIdx = ((jj-1)*1000 + 1)/dt;
    stImpulse(1:stimDepth*(cwidth*cheight),impIdx:(impIdx+stimDuration))= 10;
end

%% Background, corrected for dt
stimStrength = 3;
stB = zeros(colStruct.N, size(t,2));
stB(colStruct.ecn,1:1/dt:end) = stimStrength*rand(sum(colStruct.ecn),tmax+1);
stB(~colStruct.ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~colStruct.ecn),tmax+1);
stB = (interp1(0:tmax, stB(:,1:1/dt:end)', 0:dt:tmax))';

st = st+stB;

figure(22); subplot(3,1,1); plot(t,firingRate); %Firing rate graph
%figure(22); subplot(3,1,1); plot(t, max(stImpulse));

%% Simulate column ensemble
vinit=-65*ones(colStruct.N,1)+0*rand(colStruct.N,1);    % Initial values of v
uinit=(colStruct.b).*vinit;                 % Initial values of u

[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), ...
    colStruct.a, colStruct.b, colStruct.c, colStruct.d, colStruct.S, ...
    colStruct.delays, st);                                


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


%% Measurements
% hcsInterp = interp1([0 bins(1:end-1)+binDuration/2 tmax], [0 hcsSum 0], t );
% hceInterp = interp1([0 bins(1:end-1)+binDuration/2 tmax], [0 hceSum 0], t );
% figure; plot(t, hcsInterp); hold on; plot(t, hceInterp, 'k');

inputMP = mean(vall(1:colStruct.Nlayer,:));
outputMP = mean(vall(end-colStruct.Nlayer:end,:));
yMax= max([max(inputMP) max(outputMP)]);
yMin= min([min(inputMP) min(outputMP)]);

h = figure(200); h.Position = [2159 -42 712 943];
h=subplot(3,1,1); plot(t, firingRate,'k');
h.Position = [0.1300 0.7093 0.7750 0.2157];
set(gca, 'XTick', [])
ylabel('Firing rate (Hz)');
set(gca, 'FontSize', 12);
h = subplot(3,1,2); plot(t,inputMP,'k');
ax = axis; ax(3) = yMin; ax(4) = yMax; axis(ax);
ylabel('Mean potential (mV)');
set(gca, 'FontSize', 12);
set(gca, 'XTick', []);
subplot(3,1,3); plot(t, outputMP, 'k');
ax = axis; ax(3) = yMin; ax(4) = yMax; axis(ax);
xlabel('Time (ms)'); ylabel('Mean potential (mV)'); 
set(gca, 'FontSize',12); 

%% Test output neuron firing

%Find peaks in input/output membrane potential
[ip iw op ow] = findPeaks(inputMP, outputMP, dt, 0.25);

%Calculate number error
nErrI = length(ip)-length(firingRatePeaks);
nErrO = length(op)-length(firingRatePeaks);

%Calculate mean-squared position error
dp = abs(repmat(ip, length(firingRatePeaks), 1) - repmat(firingRatePeaks', 1, length(ip)));
pErrI = mean(sqrt(min(dp).^2));
dp = abs(repmat(op, length(firingRatePeaks), 1) - repmat(firingRatePeaks', 1, length(op)));
pErrO = mean(sqrt(min(dp).^2));

