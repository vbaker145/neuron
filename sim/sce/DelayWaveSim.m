clear; close all;
width = 2;
height = 2;
layers = 100;
N = width*height*layers;

rng(42); %Set random seed for repeatable results

tmax = 500;
dt = 0.2;
t = 0:dt:tmax;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0;

connectivity.percentExc = 0.8;
connectivity.connType = 2;
connectivity.lambda = 2.5;
connectivity.connStrength = 1.5;
connectivity.maxLength = 100;

delay.delayType = 1; %Constant delay
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);

vall = []; uall = [];

vinit=-65*ones(N,1)+0*rand(N,1);    % Initial values of v
uinit=b.*vinit;                 % Initial values of u

%Background, corrected for dt
stimStrength = 5;
st = zeros(N, size(t,2));
st(ecn,1:1/dt:end) = stimStrength*rand(sum(ecn),tmax+1);
st(~ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~ecn),tmax+1);
sti = (interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax))';

%No delay
connectivity.connType = 5;
delay.delayType = 2;
delay.delayMult = 1.7; %Observed minimum latency from Markram
[a,b,c,d, S, delaysConstant, ecn] = makeColumnParameters(structure, connectivity, delay);
[v, vall, u, uall, firingsNoDelay] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delaysConstant, sti);

%With delay
delay.delayType = 1; %Delay porportional to inter-neuron distance
delay.delayMult = 0.01;
[a,b,c,d, S, delaysDistance, ecn] = makeColumnParameters(structure, connectivity, delay);
[v, vall, u, uall, firingsDelayp01] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delaysDistance, sti);

delay.delayMult = 0.5;
[a,b,c,d, S, delaysDistance, ecn] = makeColumnParameters(structure, connectivity, delay);
[v, vall, u, uall, firingsDelayp05] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delaysDistance, sti);

delay.delayMult = 1;
[a,b,c,d, S, delaysDistance, ecn] = makeColumnParameters(structure, connectivity, delay);
[v, vall, u, uall, firingsDelay1] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delaysDistance, sti);

figure(100); set(gcf, 'Position', [0 0 1000 400]); 
subplot(1,4,1);
plot(firingsNoDelay(:,1)./1000, firingsNoDelay(:,2)/(width*height),'k.');
xlabel('Time (seconds)'); ylabel('Neuron position (Z)');
set(gca, 'XLim',[0 max(t)/1000]);
set(gca,'FontSize',12);
text(0.01, 90, '1.7 ms delay', 'FontSize', 12, 'BackgroundColor', 'White')

subplot(1,4,2);
plot(firingsDelayp01(:,1)./1000, firingsDelayp01(:,2)/(width*height),'k.');
xlabel('Time (seconds)');
set(gca, 'XLim',[0 max(t)/1000]);
set(gca, 'YTick',[])
set(gca,'FontSize',12);
text(0.01, 90, '\kappa=0.1', 'FontSize', 12, 'BackgroundColor', 'White')

subplot(1,4,3);
plot(firingsDelayp05(:,1)./1000, firingsDelayp05(:,2)/(width*height),'k.');
xlabel('Time (seconds)');
set(gca, 'XLim',[0 max(t)/1000]);
set(gca, 'YTick',[])
set(gca,'FontSize',12);
text(0.01, 90, '\kappa=0.5', 'FontSize', 12, 'BackgroundColor', 'White')

subplot(1,4,4);
plot(firingsDelay1(:,1)./1000, firingsDelay1(:,2)/(width*height),'k.');
xlabel('Time (seconds)');
set(gca, 'XLim',[0 max(t)/1000]);
set(gca, 'YTick',[])
set(gca,'FontSize',12);
text(0.01, 90, '\kappa=1.0', 'FontSize', 12, 'BackgroundColor', 'White')

