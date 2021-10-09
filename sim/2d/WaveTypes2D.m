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

Kvals = (9.2:0.2:11);
nTrials = 50;

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
        nFirings(kk,jj) = size(firings,1);
        anisScore(kk,jj) = mean(anis);
    end
end

%Remove firing counts from failed experiemtns
nFiringsClean = nFirings;
nFiringsClean(nFiringsClean<20000) = NaN;

h = figure(30);
set(h, 'Position', [100 100 800 400]);
yyaxis left
errorbar(Kvals, nanmean(anisScore), nanstd(anisScore), 'ko-', 'MarkerFaceColor', 'black')
ylim([0 20])
xlabel('K'); ylabel('Mean CoM displacement (units)')
yyaxis right
plot(Kvals, nanmean(nFiringsClean), 'k^--', 'MarkerFaceColor', 'black')
ylabel('Average # of spikes')
xlim([9 11.2])
legend('CoM displacement', 'Average # of spikes')
set(gca, 'FontSize', 12)

%Generate sample results for explanaion
rng(42);
connectivity.connStrength = 9.6;
[a,b,c,d, S, delays, ecn, pos] = makeColumnParameters_fast(structure, connectivity, delay, 0);
vinit=-65*ones(N,1);    % Initial values of v
uinit=b.*vinit;                 % Initial values of u
[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st);
plotWaves2D_Rasters( firings, pos, dt, 100 );
ax1 = gca;
f20 = figure(20);
set(f20, 'Position', [100 100 600 600]);
copyobj(ax1, f20 )
[tout, aspr, anis] = calcAvgSpikePosition( firings, 100, pos, [width/2 height/2]);
text(10, 10, ['CoM offset:', num2str(anis)], 'FontSize', 12)
xticks auto; yticks auto;
axis equal
axis([0 width 0 height])
title('K=9.6', 'FontSize', 14);
set(gca, 'FontSize', 12);

connectivity.connStrength = 10.6;
[a,b,c,d, S, delays, ecn, pos] = makeColumnParameters_fast(structure, connectivity, delay, 0);
vinit=-65*ones(N,1);    % Initial values of v
uinit=b.*vinit;                 % Initial values of u
[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st);
plotWaves2D_Rasters( firings, pos, dt, 75 );
h = gcf;
set(h,'Position', [100 100 600 600]);
[tout, aspr, anis] = calcAvgSpikePosition( firings, 75, pos, [width/2 height/2]);
text(10, 10, ['CoM offset:', num2str(anis)], 'FontSize', 12, 'BackgroundColor','White')
xticks auto; yticks auto;
axis equal
axis([0 width 0 height])
title('K=10.6', 'FontSize', 14);
set(gca, 'FontSize', 12);
