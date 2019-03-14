clear all; close all;

width = 2;
height = 2;
layers = 150;
N = width*height*layers;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0.3;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.connStrength = 8;

dt = 1.0;
tmax = 700;
t = 0:dt:tmax;

delay.delayType = 1;
delay.delayMult = 3;
delay.delayFrac = 1.0;
delay.dt = dt;

%Impulsive stimulus
stImpulse = zeros(N, size(t,2));
sidx = 1;
stimDuration = floor(20/dt);
stimDepth = 5;
stImpulse(sidx:stimDepth*(sidx+width*height),20:(20+stimDuration))= 5;

%Background stimulus
st = zeros(N, size(t,2));
st(:,1:1/dt:end) = 3*rand(N,tmax+1);
%stBackground = interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax);
stBackground = st;

waveSizes = []; waveFractions = []; waveSlopes = [];

%figure(20); subplot(3,3,1);
vall = []; uall = [];
for jj=1:10
    %[pt, v, firings, hb] = ImpulseResponse(2, 1);
    %Make column
    [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
       
    %Simulate column
    nbins = 20;
    hbins = zeros(1,nbins);
    startTimes = []; startPos = [];
    for kk=1:100
        kk
        vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
        uinit=b.*vinit;                 % Initial values of u

        %Column impulse response
        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stImpulse);
        fscale = firings(:,2)/(width*height);
        [bins, edges] = histcounts(fscale, 0:layers/nbins:layers );
        hbins = hbins + bins;
        
        %Column background response
        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stBackground);
        [wt wp wl] = findWaves(firings, .001, 2*2);
        
        for labels = 1:length(wl)
            idx = wl{labels}(1);
            startTimes = [startTimes, wt(idx)];
            startPos = [startPos, wp(idx)];
        end  
    end
    %figure; subplot(1,2,1); plot(startTimes, startPos, 'ko');
    fbins = histcounts(startPos, 0:layers/nbins:layers);
    figure; subplot(1,2,1); barh(edges(1:end-1)+edges(2)/2, fbins./sum(fbins), 'k');
    subplot(1,2,2); barh(edges(1:end-1)+edges(2)/2, hbins./sum(hbins),'k')
    ccf = corrcoef(fbins(2:end), hbins(2:end));
    ccf_all(jj) = ccf(1,2);
    title(['Correlation coefficient ', num2str(ccf(1,2))]);
    %figure(20); subplot(3,3,jj); barh(2.5:5:97.5, hbins./sum(hbins),'k')
    
    %Analyze waves
%     [wt wp wl] = findWaves(firings, .001, 2*2);
%     [sizes waveFrac slopes] = analyzeWaves(wt, wp, wl);
%     waveSizes = [waveSizes sizes];
%     waveFractions = [waveFractions waveFrac];
%     waveSlopes = [waveSlopes slopes];
end
