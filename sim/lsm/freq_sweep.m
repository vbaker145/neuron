%Frequency sweep
clear; close all;

width = 4;
height = 4;
layers = 12;
N = width*height*layers;
[a,b,c,d, S, delays, ecn] = makeColumn(width, height, layers, 0.8);

dt = 0.25;
t = 0:dt:500;

vall = [];
fires = [];

%Inject into 30% random neurons
nstim = floor(.30*N);
%sf = randi(N,1,nstim);
sf = 1:16;
jj = 1;
rate = zeros(3,5);
f = [20 100 150];
for jj=1:1
    for kk=1:1
        v=-20*ones(N,1)+5*rand(N,1);    % Initial values of v
        u=b.*v;                 % Initial values of u

        st1 = 20*sin(2*pi*f(jj).*(t/1000))+1+rand(size(t));

        stim1 = zeros(N,1);
        %stim1(sf) = 1;
        stim1(sf) = normrnd(1, 1, [1 length(sf)]);
        stim1 = stim1*st1; 

        [v1, vall, u, uall, firings] = izzy_net(v,u, dt, length(t), a, b, c, d, S, delays, stim1);
        fires{5*(jj-1)+kk} = firings;
        rate(jj,kk) = sum(firings(:,2)>(N-width*height));
    end
    jj = jj+1;
end