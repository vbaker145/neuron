function [a,b,c,d, S, delays, excNeurons, columnLabels, pos] = makeColumnEnsemble(structure, connectivity, delay, plotAx)

doplot = 0;


width = structure.width;
height = structure.height;
nWide = structure.nWide;
nHigh = structure.nHigh;
columnSpacing = structure.columnSpacing;
xPts = repmat(0:width-1, nWide,1)' + repmat(0:columnSpacing:columnSpacing*(nWide-1),width, 1);
xPts = xPts(:);
yPts = repmat(0:height-1, nHigh,1)' + repmat(0:columnSpacing:columnSpacing*(nHigh-1),height, 1);
yPts = yPts(:);
[xp, yp] = meshgrid(xPts, yPts);

nCols = 0;
columnLabels = zeros(size(xp));
for jj=0:nWide-1
    for kk=0:nHigh-1
        xt = (columnSpacing*jj<=xp & xp<columnSpacing*(jj+1));
        yt = (columnSpacing*kk<=yp & yp<columnSpacing*(kk+1));
        xyt = xt & yt;
        columnLabels(xyt) = nCols;
        nCols = nCols + 1;
    end
end

columnLabels = repmat(columnLabels(:), structure.layers, 1); 

layers = structure.layers;
displacement = structure.displacement;

percentExc = connectivity.percentExc;
connType = connectivity.connType;
lambda = connectivity.lambda;
if isfield(connectivity,'C')
    C_const = connectivity.C;
else
   C_const = 0.5; 
end
maxLength = connectivity.maxLength;
connStrength = connectivity.connStrength;

delayType = delay.delayType;
delayMult = delay.delayMult;
delayFrac = delay.delayFrac;
dt = delay.dt;

if doplot
   if nargin < 4
      figure(101); clf;
      plotAx = axes;
   end
end

n = length(xPts)*length(yPts)*layers;

zv = (0:layers-1);
[x,y,z] = meshgrid(xPts,yPts,zv);
pos.x = x; pos.y = y; pos.z = z;

x = x(:); y = y(:); z = z(:);
x = x+displacement*(rand(size(x))-0.5);
y = y+displacement*(rand(size(y))-0.5);
z = z+displacement*(rand(size(z))-0.5);

if doplot == 1
    scatter3(plotAx, x,y,z,30, 'black','filled')
    hold on;
end

if doplot == 1
    map = colormap('jet');
end

connections = zeros(length(x), length(x));
rtype = rand(n,1); 
%rtype(1:(width*nWide*height*nHigh) ) = 0; %Input layer is all excitatory
excNeurons = rtype < percentExc; nExc = sum(excNeurons);
inNeurons = rtype >= percentExc; nIn = sum(inNeurons);

%Izhikevich model parameters
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
a = zeros(n,1); b = zeros(n,1); c = zeros(n,1); d = zeros(n,1);
a(excNeurons) = 0.02; a(inNeurons) = 0.02 + 0.08*rand(nIn,1);
b(excNeurons) = 0.2; b(inNeurons) = 0.25 - 0.05*rand(nIn,1);
c(excNeurons) = -65+15*rand(nExc,1).^2; c(inNeurons) = -65;
d(excNeurons) = 8-6*rand(nExc,1).^2; d(inNeurons) = 2;

%Synaptic delays
delays = zeros(n);
dmax = 3*lambda;

%Synaptic weights
for jj=1:length(x)
    if connType == 4
       rowConnect = rand()<0.5; 
    end
     for kk=1:length(x)
        zmin = min(z(jj), z(kk)); zmax = max(z(jj),z(kk)); 
        %dz = min(abs(zmax-zmin), abs(zmax-(zmin+layers))); %PBC
        dz = z(jj)-z(kk); %Regular boundary conditions
        dis = sqrt((x(jj)-x(kk))^2+(y(jj)-y(kk))^2+dz^2);
        if dis > 0
            %cp = rand() < exp(-(dis/lambda)^2);
            if connType == 1 
                cp = rand() < C_const *exp(-(dis/lambda)^2);
                if dis>maxLength
                   cp = 0; 
                end
                %cp = rand() < exp(-(dis/lambda));
            elseif connType == 2
                cp = dis<maxLength;
            elseif connType == 3
                cp = rand() < funkyPDF(maxLength, 0.5, lambda, dis);
            elseif connType == 4
                cp = 0;
                if rowConnect
                    cp = dis<maxLength;
                end
            else
                cp = rand() < 0.5;
            end
%             if dis>maxLength
%                 cp = 0;
%             end
            if cp
                %Connect neuron
                connections(jj,kk) = connStrength*rand()*(0.5*excNeurons(jj)-inNeurons(jj));
                %connections(jj,kk) = connStrength*(0.5*excNeurons(jj)-inNeurons(jj));
                %connections(jj,kk) = connStrength*(0.5*excNeurons(jj)-inNeurons(jj))+(rand()-0.5)*connStrengthRange;
                %connections(jj,kk) = excNeurons(jj)*6+inNeurons(jj)*(-2);
                
                if doplot == 1
                    didx = dis/dmax;
                    didx = min(didx,1);
                    cm = map(floor(didx*size(map,1)),:);  
                    line(plotAx, [x(jj) x(kk)],[y(jj) y(kk)], [z(jj) z(kk)], 'Color',cm, 'LineWidth', 2*didx);
                    %line(plotAx, [x(jj) x(kk)],[y(jj) y(kk)], [z(jj) z(kk)] );
                end
            end
            
            if delayType == 1
                if rand() < delayFrac
                    delays(jj,kk) = floor(dis*delayMult/dt);
                else
                    delays(jj,kk) = floor(2/dt);
                end
            elseif delayType == 2
                delays(jj,kk) = floor(delayMult/dt);
            else
                delays(jj,kk) = floor(delayMult*rand()/dt)+1;
            end
            
        end
    end
end

if doplot == 1
    title(['Spacing=' num2str(columnSpacing)]);
    axis equal;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    set(gcf, 'pos', [0 0 600 800]);
    set(gca, 'FontSize', 14);
end

S = connections;

end

