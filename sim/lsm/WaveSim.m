clear; close all;
width = 2;
height = 2;
layers = 200;
N = width*height*layers;

tmax = 1000;
dt = 1.0;
t = 0:dt:tmax;

%background current, subthreshold
%st = 3*rand(N, size(t,2));

%Background, corrected for dt
st = zeros(N, size(t,2));
st(:,1:1/dt:end) = 3*rand(N,tmax+1);
sti = interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax);

vall = []; uall = [];
[a,b,c,d, S, delays, ecn] = makeColumn(width, height, layers, 0.8, 1, dt);

vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
uinit=b.*vinit;                 % Initial values of u

%Background, corrected for dt
st = zeros(N, size(t,2));
st(:,1:1/dt:end) = 3*rand(N,tmax+1);
sti = interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax);

[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st);
size(firings)

%figure; imagesc(vall); colorbar

%Analyze results
wl={};
if ~isempty(firings)
    [wt wp wl] = findWaves(firings, .001, width*height);
end
        

pidx=1;
pexc = 0.5:0.1:0.9;
for percExc = 0.5:0.1:0.9
    waveSizes = []; waveFractions =[]; waveSlopes = [];
    for jj=1:10
        vall = []; uall = [];
        
        [a,b,c,d, S, delays, ecn] = makeColumn(width, height, layers, percExc, 1, dt);

        vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
        uinit=b.*vinit;                 % Initial values of u
        
        %Background, corrected for dt
        st = zeros(N, size(t,2));
        st(:,1:1/dt:end) = 3*rand(N,tmax+1);
        sti = interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax);

        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st);
        size(firings)
        
        %figure; imagesc(vall); colorbar

        %Analyze results
        wl={};
        if ~isempty(firings)
            [wt wp wl] = findWaves(firings, .001, width*height);
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

figure;
subplot(3,1,1); errorbar(pexc, waveSize(:,1), waveSize(:,2),'k'); set(gca,'XTick',[])
subplot(3,1,2); errorbar(pexc, waveFraction(:,1), waveFraction(:,2),'k'); set(gca,'XTick',[])
subplot(3,1,3); errorbar(pexc, waveSlope(:,1), waveSlope(:,2),'k'); 
