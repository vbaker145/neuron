clear; close all;

rng(42); %Seed random for consistent results

addpath('../sce/');

width = 100;
height = 100;
layers = 2;
N = width*height*layers;

tmax = 250;
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
connectivity.connStrength = 24;
connectivity.maxLength = 100; 

delay.delayType = 1;
delay.delayMult = 0.2;
delay.delayFrac = 1.0;
delay.dt = dt;

[a,b,c,d, S, delays, ecn, pos] = makeColumnParameters_fast(structure, connectivity, delay, 0);

%Background, corrected for dt
st = impulseStim2D(pos, 10, t, [width/2-1 width/2+1], [height/2-1 height/2+1], [0 1]);

Kvals = (9:0.25:11);
nTrials = 10;
trials = 1;
for jj=1:length(Kvals)
    for kk=1:nTrials
        %Make 2-D sheet
        connectivity.connStrength = Kvals(jj);
        [a,b,c,d, S, delays, ecn, pos] = makeColumnParameters_fast(structure, connectivity, delay, 0);

        vinit=-65*ones(N,1);    % Initial values of v
        uinit=b.*vinit;                 % Initial values of u

        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st);
        [tout, aspr, anis] = calcAvgSpikePosition( firings,  (50:5:100), pos, [width/2 height/2]);
        KFiring{kk,jj} = firings;
        anisScore(kk,jj) = mean(anis);
    end
end

h = figure(10);
set(h, 'Position', [100 100 800 400]);
plot(Kvals, nanmean(anisScore), 'ko-', 'MarkerFaceColor', 'black')
xlabel('K'); ylabel('Mean CoM displacement (units)')
set(gca, 'FontSize', 12)

