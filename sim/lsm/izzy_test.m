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
layers = 15;
stimLayers = 15;
[a,b,c,d, S, delays] = makeColumn(width, height, layers, 0.8,1,1);

N = width*height*layers;
dt = 1;
nsteps = 1000;
nstim = floor(.30*(stimLayers*width*height));
stimSyn = randn(nstim,1)+1;
firingRate = 40;


% v=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
% u=b.*v;                 % Initial values of u
% stim1 = [5*randn(800,nsteps);2*randn(200,nsteps)]; % thalamic input
% st1 = 30*poissonSpikeTrain( nsteps*dt*1e-3, firingRate, dt*1e-3);
% 
% %Gaussian spikes
% gs = exp(-(-5:5).^2/4); 
% st1g = conv(st1,gs);
% 
% sf = randi(2,N, length(st1g));
% sf = sf-1;
% %stim1 = zeros(N,1);
% %stim1(sf) = 1;
% %stim1 = stim1*st1g;
% stim1 = sf;
% 
% [v1, vall, u, firings] = izzy_net(v,u,1.0, nsteps, a, b, c, d, S, delays, stim1);
% firings(:,1) = firings(:,1)*dt;
% figure(10); clf; plot(firings(:,1),firings(:,2),'.');
% xlabel('Time (ms)','FontSize', 12); ylabel('Neruon #', 'FontSize',12);
% tsp = find(st1>0)*dt;
% xv = [tsp; tsp]; yv = [zeros(1,length(tsp)); N*ones(1,length(tsp))];
% hold on; line(xv, yv, 'Color', 'r');
% 
% figure(11); clf; imagesc(vall); colorbar; caxis([-100 30])
% hold on; line(xv, yv, 'Color', 'r'); set(gca, 'YDir', 'Normal');

stims = []; response = []; eds = [];

ntests = 30;
st1 = 30*poissonSpikeTrain( nsteps*dt*1e-3, firingRate, dt*1e-3);
st2 = 30*poissonSpikeTrain( nsteps*dt*1e-3, firingRate, dt*1e-3);

%Gaussian spikes
gs = exp(-(-5:5).^2/4); 
st1g = conv(st1,gs);
st2g = conv(st2,gs);

sf = randi(stimLayers*width*height,1,nstim); %Inject onto random neurons in column

stim1inject = zeros(N,1);
stim1inject(sf) = stimSyn;

stim2inject = zeros(N,1);
stim2inject(sf) = stimSyn;
    
for jj=1:ntests
    disp(jj)
    
    %Make random stimulus spiuke trains
    st1 = 30*poissonSpikeTrain( nsteps*dt*1e-3, firingRate, dt*1e-3);
    st2 = 30*poissonSpikeTrain( nsteps*dt*1e-3, firingRate, dt*1e-3);
    %Gaussian spikes
    st1g = conv(st1,gs);
    st2g = conv(st2,gs);
    %Inject onto random neurons with Gaussian-distributed weightss
    stim1 = stim1inject*st1g;
    stim2 = stim2inject*st2g;
    
    v=-65*ones(N,1)+20*rand(N,1);    % Initial values of v
    u=b.*v;                 % Initial values of u
    [v1, vall1, u, firings] = izzy_net(v,u,1.0, nsteps, a, b, c, d, S, delays, stim1);
    
    v=-65*ones(N,1)+20*rand(N,1);    % Initial values of v
    u=b.*v;                 % Initial values of u
    [v2, vall2, u, firings] = izzy_net(v,u,1.0, nsteps, a, b, c, d, S, delays, stim2);
    
    [sd rd] = lsmDistance(st1g, vall1, st2g, vall2);
    stims = [stims sd];
    response = [response rd'];
    ed = sum( (max(vall1,50)-max(vall2,50)).^2 ); 
    eds = [eds; ed];
    %stims = [stims; st1g]; 
    %response = [response vall(:,1)];
    
end

figure; plot(stims, mean(response),'o');
xlabel('Stimulus distance', 'FontSize', 12); ylabel('Response distance', 'FontSize', 12);
% sdis = zeros(ntests, ntests);
% rdis = zeros(ntests, ntests);
% for jj=1:ntests
%     for kk=1:ntests
%         [sdis(jj,kk) rdis(jj,kk)] = lsmDistance(stims(jj,:), response(:,jj), stims(kk,:), response(:,kk));
%     end
% end
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


    
    