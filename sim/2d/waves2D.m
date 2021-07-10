clear; close all;

rng(42); %Seed random for consistent results

addpath('../sce/');

width = 200;
height = 200;
layers = 2;
N = width*height*layers;

tmax = 2000;
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
connectivity.connStrength = 6;
connectivity.maxLength = 100; 

delay.delayType = 1;
delay.delayMult = 0.4;
delay.delayFrac = 1.0;
delay.dt = dt;


%Make 2-D sheet
[a,b,c,d, S, delays, ecn, pos] = makeColumnParametersPBC(structure, connectivity, delay, 0);

vinit=-65*ones(N,1)+0*rand(N,1);    % Initial values of v
uinit=b.*vinit;                 % Initial values of u

%Background, corrected for dt
stimStrength = 4;
st = zeros(N, size(t,2));
st(ecn,1:1/dt:end) = stimStrength*rand(sum(ecn),tmax+1);
st(~ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~ecn),tmax+1);
st = (interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax))';

[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st);
%plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');

%plotWaves2D( firings, pos, vall, dt, ecn, '2DWaves_1layer.avi' );
plotWaves2D_Frames( firings, pos, vall, dt, 1000:20:1220 );
