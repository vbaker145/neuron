%% Firing rate encoding with a minicolumn ensemble
%
% 1 Create common neurons
% 
% 2 Generate connectivity for sparse and disconnected
%
% 3 Stimulate each geometry with 100 random trials (same firing rate,
% randomized stim and background
%
% 4 Metrics: # peaks, peak distance

clear all; close all;

rng(42);

%For plotWaves2D
addpath('../2d')
 

addpath('../sce'); %Neural column code

dt = 0.1;
tmax = 2000;
t = 0:dt:tmax;

%Make column ensemble
%Connected microcolumn ensemble
structure.width = 2;
structure.height = 2;
structure.nWide = 20;
structure.nHigh = 20;
structure.columnSpacing = 2.5+structure.width;
structure.layers = 10;
structure.displacement = 0;
colStruct    = makeFiringRateColumnEnsemble(dt, structure.columnSpacing, structure);


%Background, corrected for dt
stimStrength = 5;
st = zeros(colStruct.N, size(t,2));
st(colStruct.ecn,1:1/dt:end) = stimStrength*rand(sum(colStruct.ecn),tmax+1);
st(~colStruct.ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~colStruct.ecn),tmax+1);
sti = (interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax))';

%Stimulate column ensemble
vinit=-65*ones(colStruct.N,1)+0*rand(colStruct.N,1);    % Initial values of v
uinit=(colStruct.b).*vinit;                 % Initial values of u

%Connected minicolumn ensemble
[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), ...
    colStruct.a, colStruct.b, colStruct.c, colStruct.d, colStruct.S, ...
    colStruct.delays, sti); 
size(firings)
figure(201); plot(firings(:,1) ,firings(:,2)./colStruct.Nlayer, 'k.')
        
