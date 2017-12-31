function [a,b,c,d, S, delays] = makeColumn(width, height, layers, percentExc)

n = width*height*layers;

ne = floor(n*percentExc);
ni = n-ne;

re=rand(ne,1);          ri=rand(ni,1);
a=[0.02*ones(ne,1);     0.02+0.08*ri];
b=[0.2*ones(ne,1);      0.25-0.05*ri];
c=[-55+15*re.^2;        -55*ones(ni,1)];
d=[8-6*re.^2;           2*ones(ni,1)];
S=[0.5*rand(ne+ni,ne),  -rand(ne+ni,ni)];


Dmax = 12;
delays=floor( rand(ne+ni)*Dmax ); %Synaptic delays

end

