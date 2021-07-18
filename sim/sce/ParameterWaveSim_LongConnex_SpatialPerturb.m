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

structureDisplaced = structure;
structureDisplaced.displacement = 0.5;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.C = 0.5;
connectivity.connStrength = 10;
connectivity.maxLength = 100; 
%connectivity.maxLength = 2*connectivity.lambda; %Test pruning long connections

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;
        
%Parameter values to explore
connStrength = [4:12];
lambdas = 1:0.5:4;

simParams = {connStrength,lambdas};
simParamNames = {'K', '\lambda'};

nTrials = 50;

h= figure(100); 
set(h, 'Position', [100 100 850 550]);
subplot(2,3,1);
paramWaveFractions = {};
connectivityBase = connectivity;
delayBase = delay;

for simType = 1:length(simParams)
    simVals = simParams{simType};
    pidx=1;
    waveSize = []; waveFraction =[]; waveSlope = [];
    waveFractionDisplaced = []; waveFractionNoLong = [];
    connectivity = connectivityBase;
    delay = delayBase;
    for kk = 1:length(simVals)
        switch simType
            case 1 
                connectivity.connStrength = simVals(kk);
            case 2 
                connectivity.lambda = simVals(kk);
        end
        
        connectivityNoLong = connectivity;
        connectivityNoLong.maxLength = 5;
           
        waveFractions =[];  waveSizes = [];
        waveFractionsDisplaced =[];  waveSizesDisplaced = [];
        waveFractionsNoLong =[];  waveSizesNoLong = [];

        for jj=1:nTrials
            [wf, ws] = trialFunc(structure, connectivity, delay, t);
            waveFractions = [waveFractions wf];
            waveSizes = [waveSizes ws];
            
            [wf, ws] = trialFunc(structureDisplaced, connectivity, delay, t);
            waveFractionsDisplaced = [waveFractionsDisplaced wf];
            waveSizesDisplaced = [waveSizes ws];
            
            [wf, ws] = trialFunc(structure, connectivityNoLong, delay, t);
            waveFractionsNoLong = [waveFractionsNoLong wf];
            waveSizesNoLong = [waveSizesNoLong ws];
        end

        if length(waveSizes) > nTrials/10
            waveFraction(pidx,:) = [mean(waveFractions) std(waveFractions) min(waveFractions) max(waveFractions)];
            waveFractionDisplaced(pidx,:) = [mean(waveFractionsDisplaced) std(waveFractionsDisplaced) min(waveFractionsDisplaced) max(waveFractionsDisplaced)];
            waveFractionNoLong(pidx,:) = [mean(waveFractionsNoLong) std(waveFractionsNoLong) min(waveFractionsNoLong) max(waveFractionsNoLong)];
        else
            waveFraction(pidx,:) = [0 0 0 0];
            waveFractionDisplaced(pidx,:) = [0 0 0 0];
            waveFractionNoLong(pidx,:) = [0 0 0 0];
        end

        pidx = pidx+1;
    end
    xVals = simVals;
    xSpan = max(xVals)-min(xVals);
    paramWaveFractions{simType} = waveFraction;
    figure(100); subplot(2,3,(simType-1)*3+1);
    errorbar(xVals, waveFraction(:,1), waveFraction(:,2),'k.'); 
    xlim([min(xVals)-0.02*xSpan max(xVals)+0.02*xSpan]);
    ylim([0 1]);
    line(xlim, [0.886 0.886], 'Color', 'red', 'LineStyle','--')
    xlabel(simParamNames{simType} );
    ylabel('Wave firing fraction')
    set(gca,'FontSize',12);
    
    subplot(2,3,(simType-1)*3+2); 
    errorbar(xVals, waveFractionDisplaced(:,1), waveFractionDisplaced(:,2),'k.'); 
    xlim([min(xVals)-0.02*xSpan max(xVals)+0.02*xSpan]);
    ylim([0 1]);
    xlabel(simParamNames{simType} );
    line(xlim, [0.886 0.886], 'Color', 'red', 'LineStyle','--')
    set(gca,'FontSize',12);
    
    subplot(2,3,(simType-1)*3+3); 
    errorbar(xVals, waveFractionNoLong(:,1), waveFractionNoLong(:,2),'k.'); 
    xlim([min(xVals)-0.02*xSpan max(xVals)+0.02*xSpan]);
    ylim([0 1]);
    xlabel(simParamNames{simType} );
    line(xlim, [0.886 0.886], 'Color', 'red', 'LineStyle','--')
    set(gca,'FontSize',12);
    
end %End loop over sim type

save('ParamWaveSim.mat', 'simParams', 'paramWaveFractions');


function [waveFraction, waveSizes] = trialFunc(structure, connectivity, delay, t)
    waveSizes = []; waveFraction = [];
    dt = t(2)-t(1);
    tmax = max(t);
    N = structure.width*structure.height*structure.layers;

    [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);

    vinit=-65*ones(N,1)+0*rand(N,1);    % Initial values of v
    uinit=b.*vinit;                 % Initial values of u

    %Background, corrected for dt
    stimStrength = 5;
    st = zeros(N, size(t,2));
    st(ecn,1:1/dt:end) = stimStrength*rand(sum(ecn),tmax+1);
    st(~ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~ecn),tmax+1);
    st = (interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax))';

    [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st);
    nFirings = size(firings,1);
    %plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');

    %Analyze results
    wl={};
    if ~isempty(firings)
        [wt wp wl] = findWaves(firings, dt*.001, structure.width*structure.height);
        if length(wl) > 3
            [sizes waveFrac slopes nWavePts] = analyzeWaves(wt, wp, wl);
            waveSizes = sizes;
            waveFraction = waveFrac;
        else
            waveFraction = 0;
        end
    end

end


