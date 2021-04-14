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
connectivity.C = 0.5;
connectivity.connStrength = 10;
connectivity.maxLength = 100;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;
        
%Parameter values to explore
connStrength = [4:0.25:12];
lambdas = 1:0.25:4;
percentExc = 0.3:0.025:1;
kappas = 0:0.1:2;

simParams = {connStrength,lambdas,percentExc,kappas};
simParamNames = {'K', '\lambda', 'P_{exc}', '\kappa'};

nTrials = 100;
stimStrength = 5;

figure(100); subplot(2,2,1);
paramWaveFractions = {};
connectivityBase = connectivity;
delayBase = delay;

for simType = 1:4
    simVals = simParams{simType};
    pidx=1;
    waveSize = []; waveFraction =[]; waveSlope = [];
    connectivity = connectivityBase;
    delay = delayBase;
    for kk = 1:length(simVals)
        switch simType
            case 1 
                connectivity.connStrength = simVals(kk);
            case 2 
                connectivity.lambda = simVals(kk);
            case 3
                connectivity.percentExc = simVals(kk);
            case 4
                delay.delayMult = simVals(kk);
        end
           
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
    xVals = simVals;
    xSpan = max(xVals)-min(xVals);
    paramWaveFractions{simType} = waveFraction;
    figure(100); subplot(2,2,simType);
    errorbar(xVals, waveFraction(:,1), waveFraction(:,2),'k.'); 
    xlim([min(xVals)-0.02*xSpan max(xVals)+0.02*xSpan]);
    line(xlim, [0.886 0.886], 'Color', 'red', 'LineStyle','--')
    xlabel(simParamNames{simType} );
    ylabel('Wave firing fraction')
    set(gca,'FontSize',12);
    
end %End loop over sim type

save('ParamWaveSim.mat', 'simParams', 'paramWaveFractions');




