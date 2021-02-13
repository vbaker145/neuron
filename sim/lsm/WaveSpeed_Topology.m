clear all; close all;

rng(42); %Seed random for consistent results

width = 2;
height = 2;
layers = 50;
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

Ntrials = 5;
widthHeights = [2,2; 2,3; 3,3; 3,4; 4,4];
slopes = NaN(Ntrials, size(widthHeights,1) );

for jj=1:size(widthHeights,1)
    delay_t = delay;
    
    structure_t = structure;
    structure_t.width = widthHeights(jj,1);
    structure_t.height = widthHeights(jj,2);
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
        vinit=-65*ones(N,1)+0*rand(N,1);    % Initial values of v
        uinit=b.*vinit;                 % Initial values of u

        %Column impulse response
        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stImpulse);
        figure(5); plot(firings(:,1)./1000, firings(:,2)/(N_layer),'k.');
        xlabel('Time (seconds)','FontSize',12)
        ylabel('Z position', 'FontSize', 12)
        set(gca, 'FontSize',12)
%         [wt wp wl] = findWaves(firings, dt/1000, structure_t.width*structure_t.height, 200);

        %[sizes waveFrac slope] = analyzeWaves(wt, wp, wl);
        %slopes(testIdx) = mean(slope);

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

speed = structure.layers./nanmean(slopes);

figure(6);
xVals = 1:size(widthHeights,1);
plot(xVals, speed,'ko', 'MarkerSize', 10); 
xlim([xVals(1)-0.1 xVals(end)+0.1]);
xlabel('Column width x height')
xticks(xVals);
xticklabels({'2x2','2x3','3x3','3x4','4x4'})
ylabel('Speed (units/ms)')
set(gca,'FontSize',12);