function [a,b,c,d, S, delays, excNeurons] = makeColumn(width, height, layers, percentExc, connType, dt)

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

if nargin < 5
    connType = 0;
end

doplot = 0;

n = width*height*layers;

displacement = 0.8;
xv = (0:width-1); 
yv = (0:height-1);
zv = (0:layers-1);
[x,y,z] = meshgrid(xv,yv,zv);

x = x(:); y = y(:); z = z(:);
x = x+displacement*(rand(size(x))-0.5);
y = y+displacement*(rand(size(y))-0.5);
z = z+displacement*(rand(size(z))-0.5);

if doplot == 1
    figure(100); subplot(1,2,1); scatter3(x,y,z,50, 'black','filled')
    hold on;
end

if doplot == 1
    map = colormap('jet');
end

lambda = 2.5;
connections = zeros(length(x), length(x));
rtype = rand(n,1);
excNeurons = rtype < percentExc; nExc = sum(excNeurons);
inNeurons = rtype >= percentExc; nIn = sum(inNeurons);

%Izhikevich model parameters
a = zeros(n,1); b = zeros(n,1); c = zeros(n,1); d = zeros(n,1);
a(excNeurons) = 0.02; a(inNeurons) = 0.02 + 0.08*rand(nIn,1);
b(excNeurons) = 0.2; b(inNeurons) = 0.25 - 0.05*rand(nIn,1);
c(excNeurons) = -65+10*rand(nExc,1).^2; c(inNeurons) = -65;
d(excNeurons) = 8-6*rand(nExc,1).^2; d(inNeurons) = 2;

%Synaptic delays
delays = zeros(n);
delayMult = 2;
dmax = layers;
connStrength = 5;

%Synaptic weights
for jj=1:length(x)
     for kk=1:length(x)
        zmin = min(z(jj), z(kk)); zmax = max(z(jj),z(kk)); 
        dz = min(abs(zmax-zmin), abs(zmax-(zmin+layers))); %PBC
        %dz = z(jj)-z(kk); 
        dis = sqrt((x(jj)-x(kk))^2+(y(jj)-y(kk))^2+dz^2);
        if dis > 0
            if connType == 1
                cp = rand() < exp(-(dis/lambda)^2);
            else
                cp = rand() < (1-percentExc);
            end
            cp = rand() < exp(-(dis/lambda)^2);
            if cp
                %Connect neuron
                connections(jj,kk) = connStrength*(0.75*excNeurons(jj)-inNeurons(jj));
                %connections(jj,kk) = excNeurons(jj)*6+inNeurons(jj)*(-2);
                if connType == 1
                    delays(jj,kk) = floor(dis*delayMult);
                else
                    delays(jj,kk) = floor(delayMult*rand())+1;
                    %delays(jj,kk) = 1;
                end
                if doplot == 1
                    didx = dis/dmax;
                    didx = min(didx,1);
                    cm = map(floor(didx*size(map,1)),:);  
                    line([x(jj) x(kk)],[y(jj) y(kk)], [z(jj) z(kk)], 'Color',cm, 'LineWidth', 2*didx);
                end
            end
        end
    end
end

if doplot == 1
    title(['Connections, lambda=' num2str(lambda)]);
    axis equal;
    set(gcf, 'pos', [0 0 600 800]);
    subplot(1,2,2); hold on; imagesc(connections);
end

S = connections;

end

