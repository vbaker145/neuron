clear; close all;

tmax = 1000;
dt = 0.5;
t = 0:dt:tmax;

%Column parameters
structure.width = 2;
structure.height = 2;
structure.nWide = 2;
structure.nHigh = 2;
structure.columnSpacing = 8;
structure.layers = 50;
structure.displacement = 0;
nCols = structure.nWide*structure.nHigh;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 3.5;
connectivity.connStrength = 10;
connectivity.maxLength = 100;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

Nlayer = structure.width*structure.nWide*structure.height*structure.nHigh;
N = Nlayer*structure.layers;
        
pidx=1;
connStrength = 5;
stimStrength = 3;
stimFrq = 4;
%stimPhs = zeros(1,nCols);
stimPhs = [[0 0 0 0]; [0 pi/4 pi/2 3*pi/4]; [0 pi/2 pi 3*pi/2] ];
nFrq = length(stimFrq);
nPhs = size(stimPhs,1);
for kk = 1:nFrq
    waveSizes = []; waveFractions =[]; waveSlopes = [];
    for phsIdx=1:nPhs
        vall = []; uall = [];
        
        [a,b,c,d, S, delays, ecn, csec] = makeColumnEnsemble(structure, connectivity, delay);
        a(ecn) = 0.02;
        
        vinit=-65*ones(N,1)+0*rand(N,1);    % Initial values of v
        uinit=b.*vinit;                 % Initial values of u
        
        %Impulse stimulus, column 0
        st = ensembleStimulus(structure, csec, dt, t, 2, stimStrength, stimFrq(kk), stimPhs(phsIdx,:));

        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st);
        size(firings)
        
        %figure; imagesc(vall); colorbar; title(num2str(delayMult(kk)));
        
        for jj=0:nCols-1
            idx = csec(firings(:,2))==jj;
            f = firings(idx,:);
            fc{jj+1} = f;
            figure(20); 
            subplot(1,nCols,jj+1);
            plot(f(:,1)./1000, floor(f(:,2)/Nlayer),'k.');
            axis([0 max(t)/1000 0 structure.layers] ); set(gca, 'XTickLabel',[]);
            text(0.9,80,['COl #=' num2str(jj)],'BackgroundColor', 'White')
            
            figure(21); 
            figIdx = kk+phsIdx-1;
            subplot(2, nFrq+nPhs, figIdx); hold on;
            scatter(f(:,1)./1000, floor(f(:,2)/Nlayer), 10, jj*ones(1,size(f,1)), 'fo');
            xlabel('Time (seconds)'); 
            if jj==0 
                if kk==1
                    ylabel('Z position'); 
                else
                    set(gca, 'YTickLabel', []);
                end
            end
            if jj==nCols-1
                text(0.25,20,['Freq=' num2str(stimFrq(kk))],'BackgroundColor', 'White', 'Color', 'Red')
                text(0.25,15,['Phases=' num2str(stimPhs(phsIdx,:).*(180/pi))],'BackgroundColor', 'White', 'Color', 'Red')
            end
            subplot(2, nFrq+nPhs, nFrq+nPhs+figIdx ); hold on;
            plot(t./1000, mean(st(find(csec==jj),:)));
        end
        
        %xlabel('Time (seconds)'); ylabel('Neuron Z position');
        
%         [a,b,c2,d2, S2, delays2, ecn] = makeColumnParameters(structure, connectivity, delay);
%         [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, sti);
%         figure; plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');

        %Analyze results
        wl={};
        if ~isempty(firings)
            [wt wp wl] = findWaves(firings, dt*.001, Nlayer);
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
% figure;
% subplot(3,1,1); errorbar(delayMult, waveSize(:,1), waveSize(:,2),'k'); 
% set(gca,'XTick',[]); xlim([delayMult(1)-0.2 delayMult(end)+0.2]);
% ylabel('# firings/wave');
% subplot(3,1,2); errorbar(delayMult, waveFraction(:,1), waveFraction(:,2),'k'); 
% set(gca,'XTick',[]); xlim([delayMult(1)-0.2 delayMult(end)+0.2]);
% ylabel('Wave firing fraction')
% subplot(3,1,3); errorbar(delayMult, waveSlope(:,1), waveSlope(:,2),'k'); 
% xlim([delayMult(1)-0.2 delayMult(end)+0.2]);
% xlabel('Delay constant');
% ylabel('Velocity (mm/s)');
