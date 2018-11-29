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
[a,b,c,d, S, delays, ecn] = makeColumn(width, height, layers, 0.5, 1, dt);

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
for percExc = 0.1:0.1:0.9
    midx=1;
    frac=[];
    medWaveSize=[];
    for jj=1:3
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
        end

        if ~isempty(wl)
            nWavePts = sum(cellfun(@length,wl));
            frac(midx) = nWavePts/length(wp);
            medWaveSize(midx) = median(cellfun(@length,wl));
            midx=midx+1;
        end
    end
    waveSize(pidx,:) = [mean(medWaveSize) std(medWaveSize)];
    waveFraction(pidx,:) = [mean(frac) std(frac)];
    pidx = pidx+1;
end
