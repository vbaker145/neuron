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
connectivity.connStrength = 8;
connectivity.maxLength = 100;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

        
pidx=1;
delayMult = 2;
connStrength = 5;
delay.delayFrac = 1;
stimStrength = 5;
timeSteps = [0.01, 0.1, 0.5, 1];
figure(20); subplot(1,3,1); 
for kk = 1:length(timeSteps)
    %delay.delayMult = delayMult(kk);
    waveSizes = []; waveFractions =[]; waveSlopes = [];
    dt = timeSteps(kk);
    delay.dt = dt;
    t = 0:dt:tmax;
    for jj=1:1
        vall = []; uall = [];
        
        [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);

        vinit=-65*ones(N,1)+0*rand(N,1);    % Initial values of v
        uinit=b.*vinit;                 % Initial values of u
        
        %Background, corrected for dt
%         st = zeros(N, size(t,2));
%         st(ecn,1:1/dt:end) = stimStrength*rand(sum(ecn),tmax+1);
%         st(~ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~ecn),tmax+1);
%         sti = (interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax))';
        %Impulsive stimulus
        stImpulse = zeros(N, size(t,2));
        sidx = 1;
        stimDuration = floor(20/dt);
        stimDepth = 5;
        stImpulse(sidx:stimDepth*(sidx+width*height),20:(20+stimDuration))= 5;

        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stImpulse);
        size(firings)
        
        %figure; imagesc(vall); colorbar; title(num2str(delayMult(kk)));
        figure(20); subplot(1,length(timeSteps),kk)
        plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');
        axis([0 0.5 0 100] ); 
        set(gca, 'XTick', 0:0.1:0.5)
        %set(gca, 'XTickLabel',[]);
        %text(0.9,80,['TS=' num2str(timeSteps(kk))],'BackgroundColor', 'White')
        title(['\delta t=' num2str(timeSteps(kk)) ' ms'])
        xlabel('Time (s)');
        if kk==1
           ylabel('Z position') 
        end
        
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
    waveSlope(pidx,:) = [mean(waveSlopes) std(waveSlopes)];
    pidx = pidx+1;
end

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
