%Test detector on various networks
clear; close all;
width = 2;
height = 2;
layers = 200;
N = width*height*layers;

tmax = 1000;
dt = 1.0;
t = 0:dt:tmax;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0.0;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.connStrength = 5;

delay.delayType = 1;
delay.delayMult = 2;
delay.delayFrac = 1.0;
delay.dt = dt;

vall = []; uall = [];
        
[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);

vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
uinit=b.*vinit;                 % Initial values of u

%Background, corrected for dt
st = zeros(N, size(t,2));
st(:,1:1/dt:end) = 3*rand(N,tmax+1);
sti = interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax);

[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st);
size(firings)

figure(10); plot(firings(:,1)*dt,firings(:,2)/(width*height),'k.');


%Analyze results
wl={};
if ~isempty(firings)
    [wt wp wl] = findWaves(firings, .001, width*height);
    figure(11); scatter(wt, wp, 'k.')
    if ~isempty(wl)
        [sizes waveFrac slopes] = analyzeWaves(wt, wp, wl);
    end
end