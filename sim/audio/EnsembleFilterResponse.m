% Filter response of a column ensemble

clear all; close all;

addpath('../lsm'); %Neural column code

dt = 0.1;
tmax = 200;
t = 0:dt:tmax;
nInputPool = 50;
binDuration = 10;
bins = 0:binDuration:tmax;

%Make column ensemble
colStruct = makeFiringRateColumnEnsemble(dt);

%% Firing rate coded stimulus
% firingRate = 1*ones(1,length(t));
% for jj=1:9
%    sidx = floor(jj*1000/dt);
%    firingRate(sidx:sidx+floor(100/dt)) = 5;
% end

%firingRate = 5*(cos(2*pi*3.*(t./1000))+1); %Cosine, positive
firingRate = 10*(sin(2*pi*1.5*(t./1000))).^2; %Cosine, raised
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
stimStrength = 2;
stB = zeros(colStruct.N, size(t,2));
stB(colStruct.ecn,1:1/dt:end) = stimStrength*rand(sum(colStruct.ecn),tmax+1);
stB(~colStruct.ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~colStruct.ecn),tmax+1);
stB = (interp1(0:tmax, stB(:,1:1/dt:end)', 0:dt:tmax))';

st = st+stB;

figure(22); subplot(3,1,1); plot(t,firingRate); %Firing rate graph
figure(24); subplot(3,1,1); plot(t,firingRate); 
%figure(22); subplot(3,1,1); plot(t, max(stImpulse));
%figure(24); subplot(3,1,1); plot(t, max(stImpulse));

%% Simulate column ensemble
vinit=-65*ones(colStruct.N,1)+0*rand(colStruct.N,1);    % Initial values of v
uinit=(colStruct.b).*vinit;                 % Initial values of u

[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), ...
    colStruct.a, colStruct.b, colStruct.c, colStruct.d, colStruct.S, ...
    colStruct.delays, st);                                
                            

%% Plot results
figure; imagesc(t, 1:nInputPool, stSpikes); colorbar; colormap('gray');
set(gca, 'YDir', 'Normal');
title('Input neurons, # spikes/50 ms')
xlabel('Time (ms)'); ylabel('Input neuron #');
set(gca, 'FontSize', 12);

for jj=0:colStruct.nCols-1
    %Firing plot, color-coded by column
    idx = colStruct.csec(firings(:,2))==jj;
    f = firings(idx,:);
    fc{jj+1} = f;
    figure(20); hold on;
    plot(f(:,1)./1000, floor(f(:,2)/colStruct.Nlayer),'.');
    axis([0 max(t)/1000 0 colStruct.structure.layers] ); 
    text(0.9,80,['COl #=' num2str(jj)],'BackgroundColor', 'White')
    
    %Input layer and output layer average firing rate
    figure(22); subplot(3,1,2); hold on;
    sidx = find( f(:,2)<colStruct.Nlayer );
    hcs(jj+1,:) = histcounts(f(sidx,1),bins);
    plot(bins(1:end-1)+binDuration/2, hcs(jj+1,:));
    subplot(3,1,3); hold on;
    eidx = find( f(:,2)>(colStruct.N-colStruct.Nlayer) );
    hce(jj+1,:) = histcounts(f(eidx,1), bins);
    plot(bins(1:end-1)+binDuration/2, hce(jj+1,:));
    
end

% Plot total histograms
figure(22); 
subplot(3,1,2); hold on;
hcsSum = sum(hcs); hcsStd = std(hcs);
hceSum = sum(hce); hceStd = std(hce);
ymax = max(hceSum);
%errorbar(bins(1:end-1)+binDuration/2, hcsSum, hcsStd);
plot(bins(1:end-1)+binDuration/2, hcsSum, 'k');
ax = axis; ax(4) = ymax; axis(ax);
subplot(3,1,3); hold on;
plot(bins(1:end-1)+binDuration/2, hceSum, 'k');
ax = axis; ax(4) = ymax; axis(ax);

hcsInterp = interp1([0 bins(1:end-1)+binDuration/2 tmax], [0 hcsSum 0], t );
hceInterp = interp1([0 bins(1:end-1)+binDuration/2 tmax], [0 hceSum 0], t );
figure; plot(t, hcsInterp); hold on; plot(t, hceInterp, 'k');