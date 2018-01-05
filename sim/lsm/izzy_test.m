clear; clc; close all;

%Ne=800;                 Ni=200;
%re=rand(Ne,1);          ri=rand(Ni,1);
%a=[0.02*ones(Ne,1);     0.02+0.08*ri];
%b=[0.2*ones(Ne,1);      0.25-0.05*ri];
%c=[-65+15*re.^2;        -65*ones(Ni,1)];
%d=[8-6*re.^2;           2*ones(Ni,1)];
%S=[0.5*rand(Ne+Ni,Ne),  -rand(Ne+Ni,Ni)];


%Dmax = 4;
%delays=floor( rand(Ne+Ni)*Dmax ); %Synaptic delays
width = 3;
height = 3;
layers = 10;
[a,b,c,d, S, delays] = makeColumn(width, height, layers, 0.8);

N = width*height*layers;
v=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
u=b.*v;                 % Initial values of u

dt = 1.0;

nsteps = 500;
nstim = floor(.30*N);
firingRate = 30;
%stim1 = [5*randn(800,nsteps);2*randn(200,nsteps)]; % thalamic input
st1 = 30*poissonSpikeTrain( nsteps*dt*1e-3, firingRate, dt*1e-3);

%Gaussian spikes
gs = exp(-(-5:5).^2/4); 
st1g = conv(st1,gs);

sf = randi(N,1,nstim);
stim1 = zeros(N,1);
stim1(sf) = 1;
stim1 = stim1*st1g;

[v1, vall, u, firings] = izzy_net(v,u,1.0, nsteps, a, b, c, d, S, delays, stim1);
firings(:,1) = firings(:,1)*dt;
figure(10); plot(firings(:,1),firings(:,2),'.');
xlabel('Time (ms)','FontSize', 12); ylabel('Neruon #', 'FontSize',12);
tsp = find(st1>0)*dt;
xv = [tsp; tsp]; yv = [zeros(1,length(tsp)); N*ones(1,length(tsp))];
hold on; line(xv, yv, 'Color', 'r');

figure(11); imagesc(vall); colorbar; caxis([-100 30])
hold on; line(xv, yv, 'Color', 'r');

stims = []; response = [];

ntests = 10;
for jj=1:ntests
    st1 = 30*poissonSpikeTrain( nsteps*dt*1e-3, firingRate, dt*1e-3);

    %Gaussian spikes
    gs = exp(-(-5:5).^2/4); 
    st1g = conv(st1,gs);

    sf = randi(N,1,nstim);
    stim1 = zeros(N,1);
    stim1(sf) = 1;
    stim1 = stim1*st1g;
    
    v=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
    u=b.*v;                 % Initial values of u
    
    [v1, vall, u, firings] = izzy_net(v,u,1.0, nsteps, a, b, c, d, S, delays, stim1);
    
    stims = [stims; st1g];
    response = [response vall(:,1)];
    
end

sdis = zeros(ntests, ntests);
rdis = zeros(ntests, ntests);
for jj=1:ntests
    for kk=1:ntests
        [sdis(jj,kk) rdis(jj,kk)] = lsmDistance(stims(jj,:), response(:,jj), stims(kk,:), response(:,kk));
    end
end
%stim2 = [5*randn(800,nsteps);2*randn(200,nsteps)]; % thalamic input
% st2 = 20*poissonSpikeTrain( nsteps*dt*1e-3, firingRate, dt*1e-3);
% stim2 = zeros(1000,1);
% stim2(sf) = 1;
% stim2 = stim2*st2;
% [v2, u, firings] = izzy_net(v,u,1.0, nsteps, a, b, c, d, S, delays, stim2);
% figure(20); plot(firings(:,1),firings(:,2),'.');
% xlabel('Time (ms)','FontSize', 12); ylabel('Neruon #', 'FontSize',12);
% 


%Multiple runs
% v=-65*ones(size(S,1),1);    % Initial values of v
% u=b.*v;                 % Initial values of u
% firings = [];
% for jj=1:10
%     nsteps = 100;
%     stim = [5*randn(800,nsteps);2*randn(200,nsteps)]; % thalamic input
%     [v, u, f] = izzy_net(v,u,1.0, nsteps, a, b, c, d, S, delays, stim);
%     f(:,1) = f(:,1)+(jj-1)*nsteps;
%     firings = [firings; f];
% end
% figure(20); plot(firings(:,1),firings(:,2),'.');
% xlabel('Time (ms)','FontSize', 12); ylabel('Neruon #', 'FontSize',12);


    
    