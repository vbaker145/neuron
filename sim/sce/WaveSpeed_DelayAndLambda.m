clear all; close all;

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
delayMults = [0.1 0.05];
lambdas = [2.5:0.5:5];

slopesMean = zeros(length(delayMults),length(lambdas));
slopesStd = zeros(length(delayMults), length(lambdas));

Ntrials = 10;
slopes = NaN(Ntrials, length(delayMults), length(lambdas) );
for jj=1:length(delayMults)
    for kk=1:length(lambdas)
        jj 
        kk
        delay_t = delay;
        delay_t.delayMult = delayMults(jj);
        connectivity_t = connectivity;
        connectivity_t.lambda = lambdas(kk);
        structure_t = structure;
        N = structure_t.width*structure_t.height*layers;
        N_layer = structure_t.width*structure_t.height;

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
            [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure_t, connectivity_t, delay_t);

            %Simulate column
            vinit=-65*ones(N,1)+0*rand(N,1);    % Initial values of v
            uinit=b.*vinit;                 % Initial values of u

            %Column impulse response
            [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stImpulse);
    %         figure(5); plot(firings(:,1)./1000, firings(:,2)/(N_layer),'k.');
    %         xlabel('Time (seconds)','FontSize',12)
    %         ylabel('Z position', 'FontSize', 12)
    %         set(gca, 'FontSize',12)
    %         [wt wp wl] = findWaves(firings, dt/1000, structure_t.width*structure_t.height, 200);

            %[sizes waveFrac slope] = analyzeWaves(wt, wp, wl);
            %slopes(testIdx) = mean(slope);

            %Alternate slope measurement
            fl = firings(:,2)/N_layer;
            topFires = find(fl > structure.layers-3 );
            endTime = min( firings(topFires,1) );

            %endTime = min(wt(wp>layers-3)); %Find first activation of top layer
            if ~isempty(endTime) 
                slopes(testIdx,jj,kk) = endTime-20*dt;
                %tslope(testIdx) = endTime-20*dt; %Speed is time from stimulus to first activation
            end
            %figure; plot(wt, wp, 'k.'); title(num2str(kk));
        end 
    end %end lambda loop
end %end kappa loop

waveSpan = structure.layers-stimDepth;
speed = squeeze(nanmean(waveSpan./slopes));
speedStd = squeeze(nanstd(waveSpan./slopes));

figure(10); surf(delayMults, lambdas, speed');
xlabel('\kappa', 'FontWeight', 'bold'); ylabel('\lambda', 'FontWeight', 'bold'); zlabel('Wave speed (units/ms)')
set(gca, 'FontSize', 12);

h=figure(20); 
set(h, 'Position', [100 100 600 300]);
errorbar(lambdas, speed(1,:), speedStd(1,:), 'ko')
hold on; errorbar(lambdas, speed(2,:), speedStd(2,:), 'kx')
xlabel('\lambda', 'FontWeight', 'bold'); ylabel('Wave speed (units/ms)')
xlim([2 5.5]);
legend('\kappa=0.1','\kappa=0.05', 'Location', 'northwest')
set(gca, 'FontSize', 12);

