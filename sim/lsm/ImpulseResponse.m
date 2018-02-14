function pt = ImpulseResponse(csec)

%Frequency sweep

width = csec;
height = csec;
layers = 20;
N = width*height*layers;

dt = 1;
t = 0:dt:300;

vall = [];
fires = [];

%rng(42);
vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v

st1 = zeros(N, size(t,2));

%Impulse response
sidx = width*height*layers/2;
sidx = 1;
stimDuration = floor(10/dt);
st1(sidx:sidx+width*height,100:(100+stimDuration))= 10;

%background current, subthreshold
%st1(1:width*height, :) = 3*rand(width*height, size(t,2));

%Column with random connections
% [a,b,c,d, S, delays, ecn] = makeColumn(width, height, layers, 0.8, 0);
% uinit=b.*vinit;                 % Initial values of u
% [v1, vall, u, uall, firings] = izzy_net(vinit,uinit,1.0, length(t), a, b, c, d, S, delays, st1);
% figure(10); imagesc(vall); caxis([-80 50]); colorbar

%Column with distance-based connections
vall = []; uall = [];
[a,b,c,d, S, delays, ecn] = makeColumn(width, height, layers, 0.8, 1, dt);
uinit=b.*vinit;                 % Initial values of u
[v1, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st1);
figure(20); imagesc(vall); caxis([-80 50]); colorbar

%st1(sidx:sidx+width*height,50:53)= 30;
%
%[v1, vall, u, uall, firings] = izzy_net(v,u,1.0, length(t), a, b, c, d, S, delays, st1);

%out = vall(end-width*height:end,:);
%midx = find(mean(out)>30);
%midx = midx(1);
%pt = midx-50

end

