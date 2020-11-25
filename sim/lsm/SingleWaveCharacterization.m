clear; close all;

rng(42); %Seed random for consistent results

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
connectivity.connStrength = 10;

dt = 0.2;
tmax = 2000;
t = 0:dt:tmax;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

%Impulsive stimulus
stImpulse = zeros(N, size(t,2))*rand();
sidx = 1;
stimDuration = floor(20/dt);
stimDepth = 5;
stImpulse(sidx:stimDepth*(sidx+width*height),20:(20+stimDuration))= 10;
stImpulse = (interp1(0:tmax, stImpulse(:,1:1/dt:end)', 0:dt:tmax))';

waveSizes = []; waveFractions = []; waveSlopes = [];

%figure(20); subplot(3,3,1);
vall = []; uall = [];
min_ccf = 1;
n_ccf = 1;
for jj=1:100
    %[pt, v, firings, hb] = ImpulseResponse(2, 1);
    %Make column
    [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
       
    %Simulate column
    nbins = 20;
    hbins = zeros(1,nbins);
    startTimes = []; startPos = [];
    
    %Background stimulus
    stimStrength = 5;
    st = zeros(N, size(t,2));
    st(ecn,1:1/dt:end) = stimStrength*rand(sum(ecn),tmax+1);
    st(~ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~ecn),tmax+1);
    stBackground = (interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax))';
    
    for kk=1:1
        kk
        vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
        uinit=b.*vinit;                 % Initial values of u

        %Column impulse response
        %Scale connection strengths by 2.4 due to no background stim
        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S.*2.4, delays, stImpulse);
        %figure(50); subplot(1,2,1); plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');
        fscale = firings(:,2)/(width*height);
        [bins, edges] = histcounts(fscale, 0:layers/nbins:layers );
        hbins = hbins + bins;
        
        %Column background response
        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stBackground);
        %figure(50); subplot(1,2,2); plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');
        [wt wp wl] = findWaves(firings, .001, 2*2);
        
        for labels = 1:length(wl)
            idx = wl{labels}(1);
            startTimes = [startTimes, wt(idx)];
            startPos = [startPos, wp(idx)];
        end  
        
        fbins = histcounts(startPos, 0:layers/nbins:layers);
        ccf = corrcoef(fbins(2:end), hbins(2:end));
        ccf_all(n_ccf) = ccf(1,2);
        
        if ccf_all(n_ccf) < -0.5
            %Plot wave initiation and density histograms together
            figure; subplot(1,2,1); barh(edges(1:end-1)+edges(2)/2, fbins./sum(fbins), 'k');
            xlabel('Fraction of initiation events', 'FontSize', 12)
            ylabel('Z position', 'FontSize', 12)
            subplot(1,2,2); barh(edges(1:end-1)+edges(2)/2, hbins./sum(hbins),'k')
            xlabel('Fraction of total firing events', 'FontSize', 12)
        end
    
        if ccf_all(n_ccf) < min_ccf
            amin = a;
            bmin = b;
            cmin = c;
            dmin = d;
            Smin = S;
            delaysmin = delays;
            ecnmin = ecn;
            min_ccf = ccf_all(n_ccf);
        end
        n_ccf = n_ccf+1;
    end
    
end

%Plot minimum correlation results
vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
uinit=b.*vinit;                 % Initial values of u

%Set to mini
a = amin;
b = bmin;
c = cmin;
d = dmin;
S = Smin;
delays = delaysmin;
ecn = ecnmin;
        
%Column impulse response
[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), amin, b, c, d, S.*2.4, delays, stImpulse);
fscale = firings(:,2)/(width*height);
[bins, edges] = histcounts(fscale, 0:layers/nbins:layers );
hbins = hbins + bins;
stepFire = firings;

%Column background response
[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stBackground);
[wt wp wl] = findWaves(firings, .001, 2*2);

for labels = 1:length(wl)
    idx = wl{labels}(1);
    startTimes = [startTimes, wt(idx)];
    startPos = [startPos, wp(idx)];
end 

%Plot wave initiation sites with histogram
figure; subplot(1,2,1); plot(startTimes, startPos, 'ko');
ylabel('Z position', 'FontSize', 12)
xlabel('Time (s)', 'FontSize', 12)
set(gca, 'FontSize',12)
fbins = histcounts(startPos, 0:layers/nbins:layers);
subplot(1,2,2); barh(edges(1:end-1)+edges(2)/2, fbins./sum(fbins), 'k');
xlabel('Fraction of initiation events', 'FontSize', 12)
set(gca, 'FontSize',12)

%plot density histogram
figure; subplot(1,2,1); plot(stepFire(:,1)./1000, stepFire(:,2)./(width*height), 'k.');
ylabel('Z position', 'FontSize', 12)
xlabel('Time (s)', 'FontSize', 12)
set(gca, 'FontSize',12)
subplot(1,2,2); barh(edges(1:end-1)+edges(2)/2, hbins./sum(hbins),'k')
xlabel('Fraction of total firing events', 'FontSize', 12)
set(gca, 'FontSize',12) 

%Plot wave initiation and density histograms together
figure; subplot(1,2,1); barh(edges(1:end-1)+edges(2)/2, fbins./sum(fbins), 'k');
xlabel('Fraction of initiation events', 'FontSize', 12)
ylabel('Z position', 'FontSize', 12)
subplot(1,2,2); barh(edges(1:end-1)+edges(2)/2, hbins./sum(hbins),'k')
xlabel('Fraction of total firing events', 'FontSize', 12)

ccf = corrcoef(fbins(2:end), hbins(2:end));
ccf_all(jj) = ccf(1,2);

figure; plot(ccf_all, 'k.');
xlabel('Trial #', 'FontSize', 12)
ylabel('Correlation coefficient','FontSize', 12)

