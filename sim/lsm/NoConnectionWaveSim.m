clear; close all;
width = 2;
height = 2;
layers = 50;
N = width*height*layers;

tmax = 1000;
dt = 0.5;
t = 0:dt:tmax;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.connStrength = 8;
connectivity.maxLength = 100;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;
delay.delayFrac = 1;

stimStrength = 5;

[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);

vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
uinit=b.*vinit;                 % Initial values of u

%Background, corrected for dt
st = zeros(N, size(t,2));
st(ecn,1:1/dt:end) = stimStrength*rand(sum(ecn),tmax+1);
st(~ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~ecn),tmax+1);
sti = (interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax))';
blankInterval = floor( size(sti,2)/8 );
blanking = ones(size(sti));
blanking(:, 2*blankInterval:3*blankInterval) = 0;
%sti = sti.*blanking;
        
[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, sti);
size(firings)

fg = figure(20); set(fg, 'Position', [100 300 2000 600]);
subplot(1,3,1);
plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');
xlabel('Time (seconds)'); ylabel('Z position');
set(gca, 'FontSize', 12);

for jj=1:N
   fe = find(firings(:,2)==jj);
   nfires(jj) = length(fe); 
   if length(fe) > 2
        isiMax(jj) = min(diff(fe));
   else
        isiMax(jj) = max(t);
   end
end

%Simulate same column with no connections
S = zeros(size(S)); 

st = zeros(N, size(t,2));
st(ecn,1:1/dt:end) = stimStrength*rand(sum(ecn),tmax+1);
st(~ecn,1:1/dt:end) = stimStrength*(2/5)*rand(sum(~ecn),tmax+1);
sti = (interp1(0:tmax, st(:,1:1/dt:end)', 0:dt:tmax))';

[v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, sti);
size(firings)

figure(20); subplot(1,3,2);
plot(firings(:,1)./1000, firings(:,2)/(width*height),'k.');
xlabel('Time (seconds)'); ylabel('Z position');
set(gca, 'FontSize', 12);

figure(20); subplot(1,3,3);
nbins = 15;
fscale = firings(:,2)/(width*height);
[bins, edges] = histcounts(fscale, 0:layers/nbins:layers );
barh(edges(1:end-1)+edges(2)/2, bins./sum(bins), 'k');
xlabel('Fraction of total firing events'); ylabel('Z position');
set(gca, 'FontSize', 12);
