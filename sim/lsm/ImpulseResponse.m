%Frequency sweep
clear; close all;

width = 3;
height = 3;
layers = 12;
N = width*height*layers;
[a,b,c,d, S, delays, ecn] = makeColumn(width, height, layers, 0.8);

dt = 0.1;
t = 0:dt:100;

vall = [];
fires = [];

v=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
u=b.*v;                 % Initial values of u

st1 = zeros(N, size(t,2));
%sidx = width*height*layers/2;
sidx = 1;
st1(sidx:sidx+width*height,100:110)= 30;

[v1, vall, u, uall, firings] = izzy_net(v,u,1.0, length(t), a, b, c, d, S, delays, st1);
