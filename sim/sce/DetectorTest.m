%Test detector on various networks
clear; close all;

rng(42);  %Random seed for consistent results

width = 2;
height = 2;
layers = 100;
N = width*height*layers;

tmax = 1000;
dt = 0.2;
t = 0:dt:tmax;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0.0;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.connStrength = 10;
connectivity.maxLength = 100;

delay.delayType = 1;
delay.delayMult = 2;
delay.delayFrac = 1.0;
delay.dt = dt;

vall = []; uall = [];

K=[4,8,12];
figure(100);subplot(length(K),3,1);

for kidx = 1:length(K)
    
    %Make column
    connectivity.connStrength = K(kidx);
    [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);

    vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
    uinit=b.*vinit;                 % Initial values of u

    %Background, corrected for dt
    stimStrength = 5;
    st = zeros(N, size(t,2));
    st(ecn,1:1/dt:end) = stimStrength*rand(sum(ecn),tmax+1);
    st(~ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~ecn),tmax+1);
    sti = (interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax))';

    [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, sti);
    size(firings)

    subplot(length(K),3,(kidx-1)*3+1); plot(firings(:,1),firings(:,2)/(width*height),'k.');
    set(gca, 'FontSize', 12)
    title(['K= ' num2str(K(kidx))]);

    %Analyze results
    wl={};
    if ~isempty(firings)
        [wt wp wl] = findWaves(firings, .001, width*height);
        subplot(length(K),3,(kidx-1)*3+2); scatter(wt, wp, 'k.'); set(gca, 'FontSize', 12)
        subplot(length(K),3,(kidx-1)*3+3); hold on; set(gca, 'FontSize', 12);
        %plot(firings(:,1),firings(:,2)/(width*height),'k.');
        jetmap = jet(length(wl));
        for widx = 1:length(wl)
            wld = wl{widx};
            scatter(wt(wld), wp(wld), 20, jetmap(widx,:),'filled');
        end
        if ~isempty(wl)
            [sizes waveFrac slopes] = analyzeWaves(wt, wp, wl);
        end
    end
    
    if kidx<length(K)
       %Remove X ticks
       for jj=1:3
          subplot(length(K),3,(kidx-1)*3+jj);
          set(gca, 'XTickLabels', []);
       end
    end
end

%Scale figure
set(gcf, 'Position', [124 99 951 818] );
%X axis labels
for jj=1:3
  subplot(length(K),3,(length(K)-1)*3+jj);
  xlabel('Time (milliseconds)')
end

%Y labels
for jj=1:length(K)
  subplot(length(K),3,(jj-1)*3+1);
  ylabel('Neuron Z position')
end

set(gca, 'FontSize', 12)