clear all; close all;

rng(42); %Seed random for consistent results

width = 10;
height = 10;
layers = 2;
N = width*height*layers;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0.0;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.C = 0.5;
connectivity.maxLength = 100;
connectivity.connStrength = 1;

dt = 0.2;
tmax = 2000;
t = 0:dt:tmax;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

%Make column
[a,b,c,d, S, delays, ecn] = makeColumnParametersPBC(structure, connectivity, delay, 1);

figure(102); 
plot(sum(S), 'k+', 'MarkerSize', 12);
xlabel('Postynaptic neuron #'); ylabel('Total synaptic balance');
set(gca,'FontSize',12);
set(gcf, 'Position', [0 0 1000 300]);

