clear; close all;

rng(42); %Seed random for consistent results

width = 2;
height = 2;
layers = 100;
N = width*height*layers;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0.0;

connectivity.percentExc = 1;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.C = 0;
connectivity.maxLength = 100;
connectivity.connStrength = 1;

dt = 0.1;
tmax = 1000;
t = 0:dt:tmax;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

%Histogram of excitatory and inhibitory ISI at 5 mV input
st = 5*ones(N, size(t,2));
[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
vinit=-65*ones(N,1);    % Initial values of v
uinit=b.*vinit;         % Initial values of u
[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st);
[isiExc, isiExcStd] = findISI(firings, N);
connectivity.percentExc = 0;
[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
vinit=-65*ones(N,1);    % Initial values of v
uinit=b.*vinit;         % Initial values of u
[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st);
[isiInhib, isiInhibStd] = findISI(firings, N);

h = figure(20); 
set(h, 'Position', [100 100 800 350]);
histogram(isiExc, 'BinWidth', 1, 'Normalization', 'probability', 'FaceColor', 'r');
hold on; histogram(isiInhib, 'BinWidth', 1, 'Normalization', 'probability', 'FaceColor', 'b');
ylabel('Probability mass')
xlabel('ISI (milliseconds)')
legend('Excitatory', 'Inhibitory', 'Location', 'northwest');
set(gca, 'FontSize', 12);

%Average ISI for excitatory neurons
connectivity.percentExc = 1;
[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
stimStrength = 1:10;
for stimIdx = 1:length(stimStrength) 
    %Constant stimulus
    st = stimStrength(stimIdx)*ones(N, size(t,2));

    vinit=-65*ones(N,1);    % Initial values of v
    uinit=b.*vinit;         % Initial values of u
    
    [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st);
    [isi isiStd] = findISI(firings,N);
    allISIExc(stimIdx) = nanmean(isi);
end

%Average ISI for inhibitory neurons
connectivity.percentExc = 0;
[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
for stimIdx = 1:length(stimStrength) 
    %Constant stimulus
    st = stimStrength(stimIdx)*ones(N, size(t,2));

    vinit=-65*ones(N,1);    % Initial values of v
    uinit=b.*vinit;         % Initial values of u
    
    [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, st);
    [isi isiStd] = findISI(firings,N);
    allISIInhib(stimIdx) = nanmean(isi);
end

h = figure(10);
set(h, 'Position', [100 100 800 350]);
plot(stimStrength, 1000*(1./allISIExc), 'kx-', 'LineWidth', 1)
hold on;  plot(stimStrength, 1000*(1./allISIInhib), 'ko--', 'LineWidth', 1)
xlabel('Stimulus strength (mV)'); ylabel('Average spiking frequency (Hz)');
legend('Excitatory', 'Inhibitory', 'Location', 'northwest');
set(gca,'FontSize', 12);


%%
function [isi, isiStd] = findISI(f, N) 
isi = zeros(1,N);
isiStd = zeros(1,N);
isiTot = [];
for jj=1:N
    spikeTimes = f( f(:,2)==jj, : );
    isis = diff(spikeTimes(3:end,1));
    isiTot = [isiTot; isis];
    isi(jj) = mean(isis);
    isiStd(jj) = std(isis);
end

end
