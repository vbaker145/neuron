% Filter response of a column ensemble

clear all; close all;

addpath('../lsm'); %Neural column code

dt = 0.05;
tmax = 3000;
t = 0:dt:tmax;
nInputPool = 50;
binDuration = 50;
binSize = binDuration/dt;

%Make column ensemble
colStruct = makeFiringRateColumnEnsemble(dt);

% firingRate = 1*ones(1,length(t));
% for jj=1:9
%    sidx = floor(jj*1000/dt);
%    firingRate(sidx:sidx+floor(100/dt)) = 5;
% end

firingRate = 2*(sin(2*pi*3.*(t./1000))+1);
%firingRate = [15*ones(1,length(t)/2) 30*ones(1,length(t)/2)];
%firingRate = t./20;
figure(22); subplot(3,1,1); plot(t,firingRate);
[st, stSpikes] = firingRateEnsembleStimulus( colStruct.structure, colStruct.csec, colStruct.ecn, dt, t, nInputPool, firingRate );

%Background, corrected for dt
stimStrength = 3;
stB = zeros(colStruct.N, size(t,2));
stB(colStruct.ecn,1:1/dt:end) = stimStrength*rand(sum(colStruct.ecn),tmax+1);
stB(~colStruct.ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~colStruct.ecn),tmax+1);
stB = (interp1(0:tmax, stB(:,1:1/dt:end)', 0:dt:tmax))';

st = st+stB;

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

for jj=0:colStruct.nCols-1
    idx = colStruct.csec(firings(:,2))==jj;
    f = firings(idx,:);
    fc{jj+1} = f;
    figure(20); hold on;
    %subplot(1,colStruct.nCols,jj+1);
    plot(f(:,1)./1000, floor(f(:,2)/colStruct.Nlayer),'.');
    axis([0 max(t)/1000 0 colStruct.structure.layers] ); 
    text(0.9,80,['COl #=' num2str(jj)],'BackgroundColor', 'White')
    
    %figure(22); subplot(3,1,2); hold on;
    %endIdx = find(colStruct.csec==jj); endIdx = endIdx(endIdx>(colStruct.N-2*colStruct.Nlayer));
    %plot(sum(vall(endIdx,:)));
    
    figure(22); subplot(3,1,2); hold on;
    sidx = find( f(:,2)<colStruct.Nlayer );
    %plot(f(sidx,1)./1000, 1, 'k.')
    hist(f(sidx,1)./1000, binSize);
    subplot(3,1,3); hold on;
    eidx = find( f(:,2)>(colStruct.N-colStruct.Nlayer) );
    %plot(f(eidx,1)./1000, 1 , 'k.')
    hist(f(eidx,1)./1000, binSize);
    
end
% 
% figure(22); subplot(3,1,3); 
% plot(sum(vall(1:16,:)))
