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
structure.nWide = 4;
structure.nHigh = 4;
structure.columnSpacing = 2.5+structure.width;
structure.layers = 5;
structure.displacement = 0;
colStruct    = makeFiringRateColumnEnsemble(dt, structure.columnSpacing, structure);
