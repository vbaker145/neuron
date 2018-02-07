function pt = ImpulseResponse(csec)

%Frequency sweep

width = csec;
height = csec;
layers = 20;
N = width*height*layers;
[a,b,c,d, S, delays, ecn] = makeColumn(width, height, layers, 0.8);

dt = 1.0;
t = 0:dt:200;

vall = [];
fires = [];

v=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
u=b.*v;                 % Initial values of u

st1 = zeros(N, size(t,2));
%sidx = width*height*layers/2;
sidx = 1;
st1(sidx:sidx+width*height,50:53)= 30;

[v1, vall, u, uall, firings] = izzy_net(v,u,1.0, length(t), a, b, c, d, S, delays, st1);

out = vall(end-width*height:end,:);
midx = find(mean(out)>30);
midx = midx(1);
pt = midx-50

end