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
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

%Make 2-D sheet
[a,b,c,d, S, delays, ecn, pos] = makeColumnParameters(structure, connectivity, delay, 0);
%Background, corrected for dt
st = impulseStim2D(pos, 10, t, [0 3], [0 3], [0 1]);

kappaScale = [1.0 0.75 0.5 0.25 0.1];

for jj=1:length(kappaScale)

    vinit=-65*ones(N,1)+0*rand(N,1);    % Initial values of v
    uinit=b.*vinit;                 % Initial values of u

    [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, floor(delays*kappaScale(jj)), st);
    
    kappaFiring{jj} = firings;
    
end

