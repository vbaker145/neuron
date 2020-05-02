clear; close all;
width = 2;
height = 2;
layers = 100;
N = width*height*layers;

tmax = 1000;
dt = 1;
t = 0:dt:tmax;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.connStrength = 6;
connectivity.maxLength = 100;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

% vall = []; uall = [];
% delay.delayType = 1; %Distance-dependent delay
% [a,b,c,d, S, delaysDis, ecn] = makeColumnParameters(structure, connectivity, delay);
% delay.delayType = 2; %Fixed delay
% [a,b,c,d, S, delaysFixed, ecn] = makeColumnParameters(structure, connectivity, delay);
% 
% vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
% uinit=b.*vinit;                 % Initial values of u
% 
% %Background, corrected for dt
% st = zeros(N, size(t,2));
% st(:,1:1/dt:end) = 3*rand(N,tmax+1);
% sti = interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax);
% 
% [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delaysDis, st);
% firingsDis = firings;
% figure; subplot(1,2,1); plot(firings(:,1)*.001,firings(:,2)/4,'k.');
% xlim([-0.1 1.1]);
% xlabel('Time (seconds)'); ylabel('Z position')
% [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delaysFixed, st);
% firingsFixed = firings;
% subplot(1,2,2); plot(firings(:,1)*.001,firings(:,2)/4,'k.');
% set(gca, 'YTick',[]); xlim([-0.1 1.1]);
% xlabel('Time (seconds)')

        
pidx=1;
delayMult = 1;
%connStrength = [2:0.5:6];
connStrength = [2.9:0.05:3.2];
delay.delayFrac = 1;
stimStrength = 5;
figure(20); subplot(1, length(connStrength),1); hold on;
for kk = 1:length(connStrength)
    %delay.delayMult = delayMult(kk);
    connectivity.connStrength = connStrength(kk);
    waveSizes = []; waveFractions =[]; waveSlopes = [];
    for jj=1:50
        vall = []; uall = [];
        
        [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);

        vinit=-65*ones(N,1)+0*rand(N,1);    % Initial values of v
        uinit=b.*vinit;                 % Initial values of u
        
        %Background, corrected for dt
        st = zeros(N, size(t,2));
        st(ecn,1:1/dt:end) = stimStrength*rand(sum(ecn),tmax+1);
        st(~ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~ecn),tmax+1);
        sti = (interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax))';

        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, sti);
        size(firings)
        
        %figure; imagesc(vall); colorbar; title(num2str(delayMult(kk)));
%         figure(20); subplot(1, length(connStrength),kk); 
%         plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');
%         axis([0 1 0 100] ); set(gca, 'XTickLabel',[]); set(gca, 'YTickLabel',[]);
%         text(0.6,80,['K=' num2str(connStrength(kk))],'BackgroundColor', 'White', 'FontSize', 12, 'Color', 'Red')
%         set(gca, 'XTickMode', 'auto', 'XTickLabelMode', 'auto');
%         xlabel('Time (seconds)');
%         if kk == 1
%             set(gca, 'YTickMode', 'auto', 'YTickLabelMode', 'auto');
%             ylabel('Z position');
%         end
        
        %xlabel('Time (seconds)'); ylabel('Neuron Z position');
        
%         [a,b,c2,d2, S2, delays2, ecn] = makeColumnParameters(structure, connectivity, delay);
%         [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, sti);
%         figure; plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');

        %Analyze results
        wl={};
        if ~isempty(firings)
            [wt wp wl] = findWaves(firings, dt*.001, width*height);
            if ~isempty(wl)
                [sizes waveFrac slopes] = analyzeWaves(wt, wp, wl);
                waveSizes = [waveSizes sizes];
                waveFractions = [waveFractions waveFrac];
                waveSlopes = [waveSlopes slopes];
            end
        end

        %if ~isempty(wl)
        %    nWavePts = sum(cellfun(@length,wl));
        %    frac(midx) = nWavePts/length(wp);
        %    medWaveSize(midx) = median(cellfun(@length,wl));
        %    midx=midx+1;
        %end
    end
    waveSize(pidx,:) = [mean(waveSizes) std(waveSizes)];
    waveFraction(pidx,:) = [mean(waveFractions) std(waveFractions)];
    if length(waveFractions) < 5
       waveFraction(pidx,:) = [0 0]; 
    end
    waveSlope(pidx,:) = [mean(waveSlopes) std(waveSlopes)];
    pidx = pidx+1;
end

xVals = connStrength;
figure;
errorbar(xVals, waveFraction(:,1), waveFraction(:,2),'k'); 
xlim([xVals(1)-0.2 xVals(end)+0.2]);
xlabel('Connection strength K')
ylabel('Wave firing fraction')

figure;
subplot(3,1,1); errorbar(xVals, waveSize(:,1), waveSize(:,2),'k'); 
set(gca,'XTick',[]); xlim([xVals(1)-0.2 xVals(end)+0.2]);
ylabel('# firings/wave');
subplot(3,1,2); errorbar(xVals, waveFraction(:,1), waveFraction(:,2),'k'); 
set(gca,'XTick',[]); xlim([xVals(1)-0.2 xVals(end)+0.2]);
ylabel('Wave firing fraction')
subplot(3,1,3); errorbar(xVals, waveSlope(:,1), waveSlope(:,2),'k'); 
xlim([xVals(1)-0.2 xVals(end)+0.2]);
xlabel('Delay constant');
ylabel('Velocity (mm/s)');
