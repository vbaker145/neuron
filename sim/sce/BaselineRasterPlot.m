%Test detector on various networks
clear; close all;

rng(42);  %Random seed for consistent results

width = 2;
height = 2;
layers = 100;
N = width*height*layers;
N_layer = width*height;

tmax = 1000;
dt = 0.2;
t = 0:dt:tmax;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0.0;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.C = 0.5;
connectivity.connStrength = 10;
connectivity.maxLength = 100;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);

vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
uinit=b.*vinit;                 % Initial values of u

%Background, corrected for dt
stimStrength = 5;
st = zeros(N, size(t,2));
st(ecn,1:1/dt:end) = stimStrength*rand(sum(ecn),tmax+1);
st(~ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~ecn),tmax+1);
sti = (interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax))';

[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, sti);

    
h = figure(10);
set(h, 'Position', [680   388   800   400]); 
plot(firings(:,1), firings(:,2)/(N_layer),'k.');
ylim([0 layers]);
xlim([0 max(t)]);
xlabel('Time (ms)','FontSize',12)
ylabel('Z position', 'FontSize', 12)
set(gca, 'FontSize', 12)

