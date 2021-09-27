function [a,b,c,d, S, delays, excNeurons, pos] = makeColumnParameters_fast(structure, connectivity, delay, doplot)


width = structure.width;
height = structure.height;
layers = structure.layers;
n = width*height*layers; %Total # of neurons
displacement = structure.displacement;

percentExc = connectivity.percentExc;
connType = connectivity.connType; %Not supported in fast version
lambda = connectivity.lambda;
if isfield(connectivity,'C')
    C_const = connectivity.C;
else
   C_const = 0.5; 
end

maxLength = connectivity.maxLength; %Not supported in fast version
connStrength = connectivity.connStrength;

delayType = delay.delayType; %Not supported in fast version
delayMult = delay.delayMult;
delayFrac = delay.delayFrac; %Not supported in fast version
dt = delay.dt;

dmax = 3*lambda; %Only consider neurons less than dmax apart for connection

% ne = floor(n*percentExc);
% ni = n-ne;
% 
% re=rand(ne,1);          ri=rand(ni,1);
% a=[0.02*ones(ne,1);     0.02+0.08*ri];
% b=[0.2*ones(ne,1);      0.25-0.05*ri];
% c=[-65+15*re.^2;        -65*ones(ni,1)];
% d=[8-6*re.^2;           2*ones(ni,1)];
% S=[0.5*rand(ne+ni,ne),  -rand(ne+ni,ni)];
% 
% Dmax = 10;
% delays=floor( rand(ne+ni)*(Dmax-5) ); %Synaptic delays

xv = (0:width-1); 
yv = (0:height-1);
zv = (0:layers-1);
[x,y,z] = meshgrid(xv,yv,zv);
pos.x = x; 
pos.y = y;
pos.z = z;

x = x(:); y = y(:); z = z(:);
x = x+displacement*(rand(size(x))-0.5);
y = y+displacement*(rand(size(y))-0.5);
z = z+displacement*(rand(size(z))-0.5);

if percentExc <= 1.0
    rtype = rand(n,1);
    excNeurons = rtype < percentExc; nExc = sum(excNeurons);
    inNeurons = rtype >= percentExc; nIn = sum(inNeurons);
else
    excNeurons = ones(1,n); excNeurons(percentExc) = 0; nExc = sum(excNeurons);
    inNeurons = zeros(1,n); inNeurons(percentExc) = 1; nIn = sum(inNeurons); 
    excNeurons = logical(excNeurons); inNeurons = logical(inNeurons);
end

%Izhikevich model parameters
a = zeros(n,1); b = zeros(n,1); c = zeros(n,1); d = zeros(n,1);
a(excNeurons) = 0.02; a(inNeurons) = 0.02 + 0.08*rand(nIn,1);
b(excNeurons) = 0.2; b(inNeurons) = 0.25 - 0.05*rand(nIn,1);
%b(excNeurons) = 0.2; b(inNeurons) = 0.25 - 0.05*randi([0,1],nIn,1);
%b(excNeurons) = 0.2; b(inNeurons) = 0.25;

if percentExc > 1.0
    b(inNeurons) = 0.25; %Single LTS inhibitory neuron
end
c(excNeurons) = -65+10*rand(nExc,1).^2; c(inNeurons) = -65;
d(excNeurons) = 8-6*rand(nExc,1).^2; d(inNeurons) = 2;
eiConn = 0.5*excNeurons-inNeurons;

xsz = width; 
ysz = height; 
zsz = layers; 

%Load (or generate) table of inter-neuron distances
fname = strcat( 'DistanceTableABC_',  num2str(width), 'x',num2str(height),'.mat')
%if isfile(fname)
if ~isempty(dir(fname))
    checkIdx = load(fname);
    checkIdx = checkIdx.checkIdx;
else
    checkIdx = [];
    for jj=1:length(x)
        dx = abs(x(jj)-x); dy = abs(y(jj)-y); dz = abs(z(jj)-z); 
        dis = sqrt(dx.^2+dy.^2+dz.^2);
        idx = (dis<dmax) & (dis>0);
        idx = find(idx == 1);  

        checkIdx = [checkIdx; [repmat(jj,length(idx),1), idx, dis(idx)]];
    end
    save(fname, 'checkIdx');
end

%Find neural connections
nidx = size(checkIdx,1);
dis = checkIdx(:,3);
cp = rand(nidx,1) < C_const*exp(-(dis./lambda).^2);
checkPass = checkIdx(find(cp==1),:);

%Create connection matrix. Creating with "sparse" much faster than filling
%a previously allocated sparse array
cs = connStrength*rand(size(checkPass(:,1),1),1).*eiConn(checkPass(:,1));
connections = sparse(checkPass(:,1), checkPass(:,2) , cs, n,n);
%connections(rcIdx) = connStrength*eiConn(checkPass(:,1));

%Create delay matrix. Creating with "sparse" much faster than filling
%a previously allocated sparse array
dis = checkPass(:,3);
ds = floor(dis.*delayMult/dt);
delays = sparse(checkPass(:,1), checkPass(:,2), ds, n,n);

%Assign connections to output variable
S = connections;

end

