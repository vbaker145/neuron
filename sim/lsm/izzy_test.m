clear; clc

%Ne=800;                 Ni=200;
%re=rand(Ne,1);          ri=rand(Ni,1);
%a=[0.02*ones(Ne,1);     0.02+0.08*ri];
%b=[0.2*ones(Ne,1);      0.25-0.05*ri];
%c=[-65+15*re.^2;        -65*ones(Ni,1)];
%d=[8-6*re.^2;           2*ones(Ni,1)];
%S=[0.5*rand(Ne+Ni,Ne),  -rand(Ne+Ni,Ni)];


%Dmax = 4;
%delays=floor( rand(Ne+Ni)*Dmax ); %Synaptic delays

[a,b,c,d, S, delays] = makeColumn(10, 10, 10, 0.8);

v=-65*ones(10*10*10,1);    % Initial values of v
u=b.*v;                 % Initial values of u

nsteps = 1000;
nstim = floor(.30*1000);
%stim1 = [5*randn(800,nsteps);2*randn(200,nsteps)]; % thalamic input
st1 = 30*poissonSpikeTrain( 1, 20, .001);
sf = randi(1000,1,nstim);
stim1 = zeros(1000,1);
stim1(sf) = 1;
stim1 = stim1*st1;

[v1, u, firings] = izzy_net(v,u,1.0, nsteps, a, b, c, d, S, delays, stim1);
figure(10); subplot(2,1,1); plot(firings(:,1),firings(:,2),'.');
xlabel('Time (ms)','FontSize', 12); ylabel('Neruon #', 'FontSize',12);
figure(10); subplot(2,1,2); imagesc(stim1);

%stim2 = [5*randn(800,nsteps);2*randn(200,nsteps)]; % thalamic input
st2 = 20*poissonSpikeTrain( 1, 20, .001);
stim2 = zeros(1000,1);
stim2(sf) = 1;
stim2 = stim2*st2;
[v2, u, firings] = izzy_net(v,u,1.0, nsteps, a, b, c, d, S, delays, stim2);
figure(20); plot(firings(:,1),firings(:,2),'.');
xlabel('Time (ms)','FontSize', 12); ylabel('Neruon #', 'FontSize',12);



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


    
    