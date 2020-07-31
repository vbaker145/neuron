clear all; close all;
rng(42);

width = 2;
height = 2;
layers = 100;
N = width*height*layers;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0.0;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.maxLength = 100;
connectivity.connStrength = 24;

dt = 0.2;
tmax = 1200;
t = 0:dt:tmax;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

waveSizes = []; waveFractions = []; waveSlopes = [];

%figure(20); subplot(3,3,1);
vall = []; uall = [];
delayMults = [1.0 0.5 0.2];
widthHeights = [2,2; 2,3; 3,3; 3,4; 4,4];

slopesMean = zeros(length(delayMults), size(widthHeights,1));
slopesStd = zeros(length(delayMults), size(widthHeights,1));

Ntrials = 3;
slopes = zeros(length(delayMults), size(widthHeights,1), Ntrials);
for jj=1:length(delayMults)
    delay_t = delay;
    delay_t.delayMult = delayMults(jj);
    for kk=1:size(widthHeights,1)
            structure_t = structure;
            structure_t.width = widthHeights(kk,1);
            structure_t.height = widthHeights(kk,2);
            N = structure_t.width*structure_t.height*layers;
            N_layer = structure_t.width*structure_t.height;
            
            %Impulsive stimulus
            stImpulse = zeros(N, size(t,2))*rand();
            sidx = 1;
            stimDuration = floor(20/dt);
            stimDepth = 10;
            stImpulse(sidx:stimDepth*(sidx+width*height),20:(20+stimDuration))= 20;
            stImpulse = (interp1(0:tmax, stImpulse(:,1:1/dt:end)', 0:dt:tmax))';

            tslope = NaN(1, Ntrials);
            for testIdx = 1:Ntrials
                %Make column
                [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure_t, connectivity, delay_t);

                %Simulate column
                vinit=-65*ones(N,1)+10*rand(N,1);    % Initial values of v
                uinit=b.*vinit;                 % Initial values of u

                %Column impulse response
                [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stImpulse);
                figure(5); plot(firings(:,1)./1000, firings(:,2)/(N_layer),'k.');
                xlabel('Time (seconds)','FontSize',12)
                ylabel('Z position', 'FontSize', 12)
                set(gca, 'FontSize',12)
                [wt wp wl] = findWaves(firings, dt/1000, structure_t.width*structure_t.height);
                
                %[sizes waveFrac slope] = analyzeWaves(wt, wp, wl);
                %slopes(testIdx) = mean(slope);
                
                %Alternate slope measurement
                endTime = min(wt(wp>layers-3)); %Find first activation of top layer
                if ~isempty(endTime) 
                    tslope(testIdx) = endTime-0.020; %Speed is time from stimulus to first activation
                end
                %figure; plot(wt, wp, 'k.'); title(num2str(kk));
            end 
            slopes(jj,kk,:) = tslope;
    end
end

%slopesMean(jj,kk) = mean(slopes);
%slopesStd(jj,kk) = std(slopes);
