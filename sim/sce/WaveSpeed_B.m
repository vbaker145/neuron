clear all; close all;

rng(42); %Seed random for consistent results

width = 2;
height = 2;
layers = 50;
N = width*height*layers;
N_layer = width*height;

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

dt = 0.1;
tmax = 1000;
t = 0:dt:tmax;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

waveSizes = []; waveFractions = []; waveSlopes = [];

%figure(20); subplot(3,3,1);
vall = []; uall = [];
bScale = 0.7:0.05:1.3;

slopesMean = zeros(length(bScale),1);
slopesStd = zeros(length(bScale), 1);

Ntrials = 100;
slopes = NaN(Ntrials, length(bScale) );
for jj=1:length(bScale)
    

    %Impulsive stimulus
    stImpulse = zeros(N, size(t,2));
    sidx = 1;
    stimDuration = floor(20/dt);
    stimDepth = 10;
    stImpulse(sidx:stimDepth*(sidx+width*height),20:(20+stimDuration))= 20;
    stImpulse = (interp1(0:tmax, stImpulse(:,1:1/dt:end)', 0:dt:tmax))';

    tslope = NaN(1, Ntrials);
    for testIdx = 1:Ntrials
        %Make column
        [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
        b = b*bScale(jj);

        %Simulate column
        vinit=-65*ones(N,1)+0*rand(N,1);    % Initial values of v
        uinit=b.*vinit;                 % Initial values of u

        %Column impulse response
        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stImpulse);

        %Alternate slope measurement
        fl = firings(:,2)/N_layer;
        topFires = find(fl > structure.layers-3 );
        endTime = min( firings(topFires,1) );

        %endTime = min(wt(wp>layers-3)); %Find first activation of top layer
        if ~isempty(endTime) 
            slopes(testIdx,jj) = endTime-20*dt;
            %tslope(testIdx) = endTime-20*dt; %Speed is time from stimulus to first activation
        end
        %figure; plot(wt, wp, 'k.'); title(num2str(kk));
    end 
end

waveSpan = structure.layers-stimDepth;
speed = 1./nanmean(slopes./waveSpan);
xVals = bScale;

figure(6); subplot(1,2,1);
errorbar(xVals, nanmean(slopes./waveSpan), nanstd(slopes./waveSpan),'ko')
xlim([xVals(1)-0.1 xVals(end)+0.1]);
xlabel('b scale factor')
ylabel('Pace (ms/unit)')
set(gca,'FontSize',12);

subplot(1,2,2);
plot(xVals, speed,'ko', 'MarkerSize',10); 
xlim([xVals(1)-0.1 xVals(end)+0.1]);
xlabel('b scale factor')
ylabel('Speed (units/ms)')
set(gca,'FontSize',12);

save('WaveSpeedB.mat', 'slopes', 'speed', 'waveSpan', 'bScale', 'structure');
