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

tDelay = colStruct.delays(find(colStruct.delays>0))*dt;

[ac ae ai aei tc] = SCE_connection_statistics(colStruct.S);

%Histogram of # connections
figure(20); 
set(gcf, 'Position', [0 0 1000 500]);
histogram(tc, 'FaceColor', 'k', 'Normalization', 'probability');
xlabel('# connections'); ylabel('#occurences');
set(gca, 'FontSize', 14)

%Histogram of delays
figure(21);
set(gcf, 'Position', [0 0 1000 500]);
histogram(tDelay, 'FaceColor', 'k', 'BinWidth', 0.25, 'Normalization', 'probability');
xlabel('Delay (ms)'); ylabel('#occurences');
set(gca, 'FontSize', 14)

