%Small scalle network
clear; close all;

%Izhikevich model parameters
n=1; nExc = 1;
excNeurons = 1; 
a = zeros(n,1); b = zeros(n,1); c = zeros(n,1); d = zeros(n,1);
a(excNeurons) = 0.025; 
b(excNeurons) = 0.26; 
c(excNeurons) = -65;
d(excNeurons) = 5;

S = 30;
delays = 25;

v=-65*ones(n,1);    % Initial values of v
u=b.*v;                 % Initial values of u

dt = 0.2;
nsteps = 1000;
firingRate = 30;

st1 = 30*poissonSpikeTrain( nsteps*dt*1e-3, firingRate, dt*1e-3);

%Gaussian spikes
gs = exp(-(-5:5).^2/4); 
st1g = conv(st1,gs);
stim1 = ones(n,1);
stim1 = stim1*st1g;

stim1 = 10*sin(2*pi*10*dt*1e-3.*(0:nsteps-1));

stim1 = zeros(1,nsteps);
stim1(1:100:end) = 10;
    
[v1, vall, u, uall, firings] = izzy_net(v,u,1.0, nsteps, a, b, c, d, S, delays, stim1);

figure; plot(vall./max(abs(vall))); hold on; plot(uall/max(abs(uall)),'r');
hold on; plot(stim1/10,'g')