clear; close all;

rng(42); %Seed random for consistent results

%% Set up base column
width = 2;
height = 2;
layers = 100;
N = width*height*layers;

tmax = 2000;
dt = 0.2;
t = 0:dt:tmax;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0;

connectivity.percentExc = 1;
connectivity.connType = 1;
connectivity.lambda = 3;
connectivity.connStrength = 10;
connectivity.maxLength = 100;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;
delay.delayFrac = 1;

stimStrength = 5;

[a,b,c,d, S, delays, ecn, pos] = makeColumnParameters(structure, connectivity, delay);

%Background, corrected for dt
st = zeros(N, size(t,2));
st(ecn,1:1/dt:end) = stimStrength*rand(sum(ecn),tmax+1);
st(~ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~ecn),tmax+1);
        
%Stimulus
% sidx = 1;
% stimStart = floor(1100/dt);
% stimDuration = floor(20/dt);
% stimDepth = 5;
% st(sidx:stimDepth*(sidx+width*height),stimStart:(stimStart+stimDuration))= 8;

sti = (interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax))';

vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
uinit=b.*vinit;                 % Initial values of u

[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, sti);

figure(30); subplot(1,2,1); 
plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');
xlabel('Time (seconds)'); ylabel('Z position');
set(gca, 'FontSize', 12);

%% Same test, single LTS inhibitory neuron

connectivity.percentExc = 50*structure.width*structure.height; %Single LTS inhibitory neuron
%connectivity.connStrength = 12;

[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);

%Background, corrected for dt
% st = zeros(N, size(t,2));
% st(ecn,1:1/dt:end) = stimStrength*rand(sum(ecn),tmax+1);
% st(~ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~ecn),tmax+1);
% sti = (interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax))';
% 

vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
uinit=b.*vinit;                 % Initial values of u

[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, sti);

figure(30); subplot(1,2,2); 
plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');
xlabel('Time (seconds)'); ylabel('Z position');
set(gca, 'FontSize', 12);


% 
% stImpulse = zeros(N, size(t,2))*rand();
% sidx = 1;
% stimDuration = floor(20/dt);
% stimDepth = 5;
% stImpulse(sidx:stimDepth*(sidx+width*height),20:(20+stimDuration))= 10;
% stImpulse = (interp1(0:tmax, stImpulse(:,1:1/dt:end)', 0:dt:tmax))';
% 
% [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stImpulse);
% figure(30); subplot(1,3,2); 
% plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');
% xlabel('Time (seconds)'); 
% set(gca, 'FontSize', 12);
% 
% nbins = 50;
% fscale = firings(:,2)/(width*height);
% [bins, edges] = histcounts(fscale, 0:layers/nbins:layers );
% subplot(1,3,3); barh(edges(1:end-1)+edges(2)/2, bins./sum(bins),'k')
% xlabel('Fraction of total firing events', 'FontSize', 12)

