clear; close all
width = 3;
height = 3;
layers = 20;
N = width*height*layers;

dt = 1;
t = 0:dt:300;

vall = [];
fires = [];

%rng(42);
vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v

%Impulse response input
st1 = zeros(N, size(t,2));
sidx = width*height*layers/2;
sidx = 1;
stimDuration = floor(10/dt);
st1(sidx:sidx+width*height,100:(100+stimDuration))= 5;

%Random input
st1 = 2*abs(rand(N, size(t,2)));

%Column with random connections
[a,b,c,d, Srand, delaysRand, ecn] = makeColumn(width, height, layers, 0.8, 0, dt);


%Column with distance-based connections
vall = []; uall = [];
[a,b,c,d, Sdis, delaysDis, ecn] = makeColumn(width, height, layers, 0.8, 1, dt);

%Thalamic input, per Izhekevich
st1 = zeros(N, size(t,2));
st1(ecn,:) = 5*rand(sum(ecn), size(t,2)); %Excitatory neurons
inn = ~ecn;
st1(inn,:) = 2*rand(sum(inn), size(t,2)); %Inhibitory neurons
%st1 (N/2:end,:) = 0;

uinit=b.*vinit;                 % Initial values of u
[v1, vall, u, uall, firingsRand] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, Srand, delaysRand, st1);
[v1, vall, u, uall, firingsDis] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, Sdis, delaysDis, st1);

figure(5); plot(firingsRand(:,1),firingsRand(:,2),'.');
xlabel('Time (ms)','FontSize', 12); ylabel('Neruon #', 'FontSize',12);
figure(6); plot(firingsDis(:,1),firingsDis(:,2),'.');
xlabel('Time (ms)','FontSize', 12); ylabel('Neruon #', 'FontSize',12);