clear; close all;

rng(42); %Seed random for consistent results

%Calculate 'C' scaling factors
%Array of [Width x Heigh, AvgConnections] pairs
AvgConnections = [4, 6.9; 6, 9.4; 9, 12.8; 12, 15.2; 16, 17.9 ]; %From previous runs with C=0.5
%Quadratic fit to predict average # conenctions for a given cross section
qc = polyfit(AvgConnections(:,1), AvgConnections(:,2), 2);

width = 2;
height = 2;
layers = 50;
N = width*height*layers;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0.0;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;

%Scaling factor for column cross section
nn = width*height;
F = AvgConnections(1,2)/(qc(1)*nn^2+qc(2)*nn+qc(3));
connectivity.C = F*0.5;

connectivity.maxLength = 100;
connectivity.connStrength = 1;

dt = 0.2;
tmax = 2000;
t = 0:dt:tmax;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

nTrials = 20;
tConn = []; tDelay = [];
for jj=1:nTrials
    %Make column
    [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
    [ac(jj) ae(jj) ai(jj) aei(jj) tc] = SCE_connection_statistics(S);
    tConn = [tConn tc];
    
    tDelay = [tDelay; delays(find(delays>0))*dt];
end

mean(ac)
mean(ae)
mean(ai)

%Histogram of # connections
figure(20); 
set(gcf, 'Position', [0 0 1000 500]);
histogram(tConn, 'FaceColor', 'k');
xlabel('# connections'); ylabel('#occurences');
set(gca, 'FontSize', 14)

%Histogram of delays
figure(21);
set(gcf, 'Position', [0 0 1000 500]);
histogram(tDelay, 'FaceColor', 'k', 'BinWidth', 0.25);
xlabel('Delay (ms)'); ylabel('#occurences');
set(gca, 'FontSize', 14)