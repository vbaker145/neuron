function [a,b,c,d, S, delays, excNeurons, pos] = makeColumnParameters(structure, connectivity, delay)

width = structure.width;
height = structure.height;
layers = structure.layers;
displacement = structure.displacement;

percentExc = connectivity.percentExc;
connType = connectivity.connType;
lambda = connectivity.lambda;
norm2 = sqrt(1/lambda^2)/sqrt(pi); %PDF normalization constant
maxLength = connectivity.maxLength;
connStrength = connectivity.connStrength;
%connStrengthRange = connectivity.connStrengthRange;

delayType = delay.delayType;
delayMult = delay.delayMult;
delayFrac = delay.delayFrac;
dt = delay.dt;


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

doplot = 1;

n = width*height*layers;

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

if doplot == 1
    figure(100); h1 = subplot(1,2,1);
    scatter3(x,y,z,50, 'black','filled')
    hold on;
    subplot(1,2,2);
    hold on;
end

%connections = zeros(length(x), length(x));
connections = spalloc(length(x), length(x), 1000);

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

%Synaptic delays
%delays = zeros(n);
delays = spalloc(n,n,1000);

%dmax = layers;
dmax = 2*lambda;
if doplot == 1
    map = colormap(jet(dmax));
end

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
                %cp = rand() < 0.5*exp(-(dis/lambda)^2);
                cp = rand() < exp(-(dis/lambda)^2);
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
                    subplot(1,2,1);
                    dis = min(dis,dmax);
                    cm = map(floor(dis),:);
                    line([x(jj) x(kk)],[y(jj) y(kk)], [z(jj) z(kk)], 'Color',cm, 'LineWidth', dis/2);
                    
                    subplot(1,2,2);
                    if excNeurons(jj) == 1 && excNeurons(kk) == 1
                        plot(jj,kk,'g.', 'MarkerSize', 15);
                    elseif excNeurons(jj) == 0
                        plot(jj,kk,'r.', 'MarkerSize', 15);
                    else 
                        plot(jj,kk,'k.', 'MarkerSize', 15);
                    end
                    
                end
                
                %Set delay
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
                end %End set delay
                
            end %End if cp is true
        end %End if dis>0 (not same neuron)
        
     end %End for kk
end %end for jj

if doplot == 1
    subplot(1,2,1);
    axis equal;
    cl = colorbar;
    tls = {''};
    for jj=1:dmax
       tls{end+1} = jj;
       tls{end+1} = '';
    end
    cl.TickLabels = tls;
    
    subplot(1,2,2);
    xlabel('Presynaptic neuron #');
    ylabel('Postsynaptic neuron #');
    set(gca, 'FontSize', 12);
    set(gcf, 'pos', [0 0 600 800]);
end

S = connections;

end

