function [a,b,c,d, S, delays] = makeColumn(width, height, layers, percentExc)



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

n = width*height*layers;

xv = 0:width-1;
yv = 0:width-1;
zv = 0:layers-1;
[x,y,z] = meshgrid(xv,yv,zv);

x = x(:); y = y(:); z = z(:);

figure(100); subplot(1,2,1); scatter3(x,y,z,50, 'black','filled')
hold on;

lambda = 4;
dmax = 5;
map = colormap('jet');
connections = zeros(length(x), length(x));
rtype = rand(n,1);
excNeurons = rtype < percentExc; nExc = sum(excNeurons);
inNeurons = rtype >= percentExc; nIn = sum(inNeurons);

%Izhikevich model parameters
a = zeros(n,1); b = zeros(n,1); c = zeros(n,1); d = zeros(n,1);
a(excNeurons) = 0.02; a(inNeurons) = 0.02 + 0.08*rand(nIn,1);
b(excNeurons) = 0.2; b(inNeurons) = 0.25 - 0.05*rand(nIn,1);
c(excNeurons) = -20+3*rand(nExc,1).^2; c(inNeurons) = -20;
d(excNeurons) = 8-6*rand(nExc,1).^2; d(inNeurons) = 2;

%Synaptic delays
Dmax = 20;
%delays=floor( rand(n)*(Dmax-5) ); %Synaptic delays
delays = 2*ones(n);

%Synaptic weights
for jj=1:length(x)
     for kk=1:length(x)
        dis = sqrt((x(jj)-x(kk)).^2+(y(jj)-y(kk))^2+(z(jj)-z(kk))^2);
        if dis > 0
            if rand() < exp(-(dis/lambda)^2)
                %Connect neuron
                connections(jj,kk) = 1.0-2.0*inNeurons(jj);
                delays(jj,kk) = floor(dis);
                didx = dis/dmax;
                didx = min(didx,1);
                cm = map(floor(didx*size(map,1)),:);  
                line([x(jj) x(kk)],[y(jj) y(kk)], [z(jj) z(kk)], 'Color',cm, 'LineWidth', 2*didx);
            end
        end
    end
end
title(['Connections, lambda=' num2str(lambda)]);
axis equal;
set(gcf, 'pos', [0 0 600 800]);
subplot(1,2,2); hold on; imagesc(connections);
S = connections;

end

