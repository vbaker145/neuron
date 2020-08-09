clear; close all;

rng(42); %Seed random for consistent results

width = 2;
height = 2;
layers = 100;
N = width*height*layers;

tmax = 1000;
dt = 0.2;
t = 0:dt:tmax;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.connStrength = 10;
connectivity.maxLength = 100;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;
        
pidx=1;
nTrials = 100;
percentExc = 0.3:0.025:1;
stimStrength = 5;
figure(20); subplot(length(percentExc),1,1); hold on;
for kk = 1:length(percentExc)
    connectivity.percentExc = percentExc(kk);
    waveSizes = []; waveFractions =[]; waveSlopes = [];
    for jj=1:nTrials
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
%         figure(20); subplot(length(percentExc),1,kk)
%         plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');
%         axis([0 1 0 100] ); set(gca, 'XTickLabel',[]); set(gca, 'YTickLabel',[]);
%         text(0.8,80,['% exc =' num2str(percentExc(kk))],'BackgroundColor', 'White', 'FontSize', 12, 'Color', 'Red')
%         if kk == length(percentExc)
%             set(gca, 'XTickMode', 'auto', 'XTickLabelMode', 'auto');
%             xlabel('Time (seconds)');
%         end
        
        %xlabel('Time (seconds)'); ylabel('Neuron Z position');
        
%         [a,b,c2,d2, S2, delays2, ecn] = makeColumnParameters(structure, connectivity, delay);
%         [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, sti);
        %figure; plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');

        %Analyze results
        wl={};
        if ~isempty(firings)
            [wt wp wl] = findWaves(firings, dt*.001, width*height);
            if length(wl) > 3
                [sizes waveFrac slopes] = analyzeWaves(wt, wp, wl);
                waveSizes = [waveSizes sizes];
                waveFractions = [waveFractions waveFrac];
                waveSlopes = [waveSlopes slopes];
            else
                waveFractions = [waveFractions 0];
            end
        end

        %if ~isempty(wl)
        %    nWavePts = sum(cellfun(@length,wl));
        %    frac(midx) = nWavePts/length(wp);
        %    medWaveSize(midx) = median(cellfun(@length,wl));
        %    midx=midx+1;
        %end
    end
    if length(waveSizes) > nTrials/10
        waveSize(pidx,:) = [mean(waveSizes) std(waveSizes)];
        waveFraction(pidx,:) = [mean(waveFractions) std(waveFractions) min(waveFractions) max(waveFractions)];
        waveSlope(pidx,:) = [mean(waveSlopes) std(waveSlopes)];
    else
        waveSize(pidx,:) = [0 0];
        waveFraction(pidx,:) = [0 0 0 0];
        waveSlope(pidx,:) = [0 0];
    end
    pidx = pidx+1;
end

xVals = percentExc;

figure(6);
errorbar(xVals, waveFraction(:,1), waveFraction(:,2),'k.'); 
%errorbar(xVals, waveFraction(:,1), waveFraction(:,3), waveFraction(:,4), 'k.'); 
xlim([xVals(1)-0.05 xVals(end)+0.05]);
set(gca,'FontSize',12);
xlabel('Excitatory fraction')
ylabel('Wave firing fraction')

% figure;
% subplot(3,1,1); errorbar(pexc, waveSize(:,1), waveSize(:,2),'k'); set(gca,'XTick',[])
% subplot(3,1,2); errorbar(pexc, waveFraction(:,1), waveFraction(:,2),'k'); set(gca,'XTick',[])
% subplot(3,1,3); errorbar(pexc, waveSlope(:,1), waveSlope(:,2),'k'); 


% figure;
% subplot(3,1,1); errorbar(lambda, waveSize(:,1), waveSize(:,2),'k'); set(gca,'XTick',[])
% subplot(3,1,2); errorbar(lambda, waveFraction(:,1), waveFraction(:,2),'k'); set(gca,'XTick',[])
% subplot(3,1,3); errorbar(lambda, waveSlope(:,1), waveSlope(:,2),'k'); 

% 
figure;
subplot(3,1,1); errorbar(delayMult, waveSize(:,1), waveSize(:,2),'k'); 
set(gca,'XTick',[]); xlim([delayMult(1)-0.2 delayMult(end)+0.2]);
ylabel('# firings/wave');
subplot(3,1,2); errorbar(delayMult, waveFraction(:,1), waveFraction(:,2),'k'); 
set(gca,'XTick',[]); xlim([delayMult(1)-0.2 delayMult(end)+0.2]);
ylabel('Wave firing fraction')
subplot(3,1,3); errorbar(delayMult, waveSlope(:,1), waveSlope(:,2),'k'); 
xlim([delayMult(1)-0.2 delayMult(end)+0.2]);
xlabel('Delay constant');
ylabel('Velocity (mm/s)');
