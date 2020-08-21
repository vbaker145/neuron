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
kappas = 0.2:0.1:2;

nTrials = 100;
stimStrength = 5;
for kk = 1:length(kappas)
    delay.delayMult = kappas(kk);
    waveSizes = []; waveFractions =[]; waveSlopes = []; 
    wavePts = 0; nFirings = 0;
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
        nFirings = nFirings + size(firings,1);
        %plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');

        %Analyze results
        wl={};
        if ~isempty(firings)
            [wt wp wl] = findWaves(firings, dt*.001, width*height);
            if length(wl) > 3
                [sizes waveFrac slopes nWavePts] = analyzeWaves(wt, wp, wl);
                waveSizes = [waveSizes sizes];
                waveFractions = [waveFractions waveFrac];
                waveSlopes = [waveSlopes slopes];
                wavePts = wavePts + nWavePts;
            else
                waveFractions = [waveFractions 0];
            end
        end

    end
    
    if length(waveSizes) > nTrials/10
        waveSize(pidx,:) = [mean(waveSizes) std(waveSizes)];
        waveFraction(pidx,:) = [mean(waveFractions) std(waveFractions) min(waveFractions) max(waveFractions)];
        waveSlope(pidx,:) = [mean(waveSlopes) std(waveSlopes)];
        waveFracTotal(pidx) = wavePts/nFirings;
    else
        waveSize(pidx,:) = [0 0];
        waveFraction(pidx,:) = [0 0 0 0];
        waveSlope(pidx,:) = [0 0];
    end
    
    pidx = pidx+1;
end

xVals = kappas;

%Figure 6 in paper
figure(6);
errorbar(xVals, waveFraction(:,1), waveFraction(:,2),'k.'); 
%errorbar(xVals, waveFraction(:,1), waveFraction(:,3), waveFraction(:,4), 'k.'); 
xlim([xVals(1)-0.2 xVals(end)+0.2]);
xlabel('Delay \kappa')
ylabel('Wave firing fraction')
set(gca,'FontSize',12);


