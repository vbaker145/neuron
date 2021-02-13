clear; close all;

rng(42); %Seed random for consistent results

width = 2;
height = 2;
layers = 15;
N = width*height*layers;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0.0;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.maxLength = 100;
connectivity.connStrength = 16;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = 0.2;

[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);