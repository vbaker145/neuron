clear all; close all;

width = 2;
height = 2;
layers = 150;
N = width*height*layers;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0.0;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.maxLength = 10;
connectivity.connStrength = 8;

dt = 1.0;
tmax = 700;
t = 0:dt:tmax;

delay.delayType = 1;
delay.delayMult = 2;
delay.delayFrac = 1.0;
delay.dt = dt;

%Impulsive stimulus
stImpulse = zeros(N, size(t,2))*rand();
sidx = 1;
stimDuration = floor(20/dt);
stimDepth = 5;
stImpulse(sidx:stimDepth*(sidx+width*height),20:(20+stimDuration))= 5;

waveSizes = []; waveFractions = []; waveSlopes = [];

%figure(20); subplot(3,3,1);
vall = []; uall = [];
delayMults = (2);
lambdas = ([2.5]);
maxLengths = (100);
slopesMean = zeros(length(delayMults), length(lambdas));
slopesStd = zeros(length(delayMults), length(lambdas), length(maxLengths));
for jj=1:length(delayMults)
    jj
    delay.delayMult = delayMults(jj);
    for kk=1:length(lambdas)
        connectivity.lambda = lambdas(kk);
        for ll = 1:length(maxLengths)
            connectivity.maxLength = maxLengths(ll);
            slopes = [];
            for testIdx = 1:5
                %Make column
                [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);

                %Simulate column
                vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
                uinit=b.*vinit;                 % Initial values of u

                %Column impulse response
                [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stImpulse);
                [wt wp wl] = findWaves(firings, .001, 2*2);
                [sizes waveFrac slope] = analyzeWaves(wt, wp, wl);
                slopes(testIdx) = mean(slope);
                figure; plot(wt, wp, 'k.'); title(num2str(maxLengths(ll)));
            end
            slopesMean(jj,kk,ll) = mean(slopes);
        end
        %slopesStd(jj,kk) = std(slopes);
    end
    
end
