clear all; close all;

rng(42); %Seed random for consistent results

width = 2;
height = 2;
layers = 50;
N = width*height*layers;
N_layer = width*height;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0.0;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.C = 0.5;
connectivity.maxLength = 100;
connectivity.connStrength = 24;

dt = 0.1;
tmax = 1000;
t = 0:dt:tmax;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

%% Test
    
%Make "regular" 2x2 column
[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
cs2x2 = {};
cs2x2.a = a;
cs2x2.b = b;
cs2x2.c = c;
cs2x2.d = d;
cs2x2.S = S;
cs2x2.delays = delays;

%Make 'regular' 1x1 column
structure.width = 1;
structure.height = 1;
[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
cs1x1 = {};
cs1x1.a = a;
cs1x1.b = b;
cs1x1.c = c;
cs1x1.d = d;
cs1x1.S = S;
cs1x1.delays = delays;

%Make 'enhanced' 1x1 column
connectivity.lambda = 4;
connectivity.connStrength = 30;
[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
cs1x1e = {};
cs1x1e.a = a;
cs1x1e.b = b;
cs1x1e.c = c;
cs1x1e.d = d;
cs1x1e.S = S;
cs1x1e.delays = delays;

%Make 'no variation' 1x1 column
connectivity.percentExc = 1.0;
connectivity.C = 1.0;
[a,b,c,d, S, delays, ecn] = makeColumnParameters_ConstNeurons(structure, connectivity, delay);
cs1x1c = {};
cs1x1c.a = a;
cs1x1c.b = b;
cs1x1c.c = c;
cs1x1c.d = d;
cs1x1c.S = S;
cs1x1c.delays = delays;

%Impulsive stimulus
stImpulse2x2 = zeros(length(cs2x2.a), size(t,2))*rand();
sidx = 1;
stimDuration = floor(20/dt);
stimDepth = 10;
stImpulse2x2(sidx:sidx+stimDepth*2*2,20:(20+stimDuration))= 20;
stImpulse2x2 = (interp1(0:tmax, stImpulse2x2(:,1:1/dt:end)', 0:dt:tmax))';

stImpulse1x1 = zeros(length(cs1x1.a), size(t,2))*rand();
sidx = 1;
stimDuration = floor(20/dt);
stimDepth = 10;
stImpulse1x1(sidx:sidx+stimDepth,20:(20+stimDuration))= 20;
stImpulse1x1 = (interp1(0:tmax, stImpulse1x1(:,1:1/dt:end)', 0:dt:tmax))';


%Column impulse response
vinit=-65*ones(2*2*layers,1)+0*rand(2*2*layers,1);    % Initial values of v
uinit=cs2x2.b.*vinit;                 % Initial values of u
[v, vall, u, uall, firings2x2] = izzy_net(vinit,uinit,dt, length(t), ...
                                            cs2x2.a, cs2x2.b, cs2x2.c, cs2x2.d, ...
                                            cs2x2.S, cs2x2.delays, stImpulse2x2);    

vinit=-65*ones(layers,1)+0*rand(layers,1);    % Initial values of v
uinit=cs1x1.b.*vinit;                 % Initial values of u
[v, vall, u, uall, firings1x1] = izzy_net(vinit,uinit,dt, length(t), ...
                                            cs1x1.a, cs1x1.b, cs1x1.c, cs1x1.d, ...
                                            cs1x1.S, cs1x1.delays, stImpulse1x1); 
uinit=cs1x1e.b.*vinit;                 % Initial values of u                                        
[v, vall, u, uall, firings1x1e] = izzy_net(vinit,uinit,dt, length(t), ...
                                            cs1x1e.a, cs1x1e.b, cs1x1e.c, cs1x1e.d, ...
                                            cs1x1e.S, cs1x1e.delays, stImpulse1x1); 
uinit=cs1x1c.b.*vinit;                 % Initial values of u 
[v, vall, u, uall, firings1x1c] = izzy_net(vinit,uinit,dt, length(t), ...
    cs1x1c.a, cs1x1c.b, cs1x1c.c, cs1x1c.d, ...
    cs1x1c.S, cs1x1c.delays, stImpulse1x1); 
                                        
                                        
h = figure(10);
set(h, 'Position', [680   388   800   400]); 
subplot(1,4,1); plot(firings2x2(:,1), firings2x2(:,2)/(N_layer),'k.');
text(10, 0.9*layers, 'A', 'FontSize', 20)
ylim([0 layers]);
xlim([0 200]);
xlabel('Time (ms)','FontSize',12)
ylabel('Z position', 'FontSize', 12)
subplot(1,4,2); plot(firings1x1(:,1), firings1x1(:,2),'k.');
text(10, 0.9*layers, 'B', 'FontSize', 20)
ylim([0 layers]);
xlim([0 200]);
xlabel('Time (ms)','FontSize',12)
subplot(1,4,3); plot(firings1x1e(:,1), firings1x1e(:,2),'k.');
text(10, 0.9*layers, 'C', 'FontSize', 20)
ylim([0 layers]);
xlim([0 200]);
xlabel('Time (ms)','FontSize',12)
subplot(1,4,4); plot(firings1x1c(:,1), firings1x1c(:,2),'k.');
text(10, 0.9*layers, 'D', 'FontSize', 20)
ylim([0 layers]);
xlim([0 200]);
xlabel('Time (ms)','FontSize',12)
set(gca, 'FontSize',12)

%% Explore


Ntrials = 100;
numWaves2x2 = 0;
numWaves1x1 = 0;
numWaves1x1e = 0;
numWaves1x1c = 0;

for testIdx = 1:Ntrials
    %Generate impulsive stimuli
    stImpulse2x2 = zeros(length(cs2x2.a), size(t,2))*rand();
    sidx = 1;
    stimDuration = floor(20/dt);
    stimDepth = 10;
    stImpulse2x2(sidx:sidx+stimDepth*2*2,20:(20+stimDuration))= 20;
    stImpulse2x2 = (interp1(0:tmax, stImpulse2x2(:,1:1/dt:end)', 0:dt:tmax))';

    stImpulse1x1 = zeros(length(cs1x1.a), size(t,2))*rand();
    sidx = 1;
    stimDuration = floor(20/dt);
    stimDepth = 10;
    stImpulse1x1(sidx:sidx+stimDepth,20:(20+stimDuration))= 20;
    stImpulse1x1 = (interp1(0:tmax, stImpulse1x1(:,1:1/dt:end)', 0:dt:tmax))';
    
    %"regular" 2x2 column
    structure.width = 2;
    structure.height = 2;
    connectivity.lambda = 2.5;
    connectivity.connStrength = 24;
    connectivity.percentExc = 0.8;
    connectivity.C = 0.5;
    [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
    vinit=-65*ones(2*2*layers,1)+0*rand(2*2*layers,1);    % Initial values of v
    uinit=b.*vinit;                 % Initial values of u
    [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), ...
                                                a, b, c, d, S, delays, stImpulse2x2); 
    if max(firings(:,2)) >= layers*structure.width*structure.height
        numWaves2x2 = numWaves2x2 + 1;
    end
    
    %'regular' 1x1 column
    structure.width = 1;
    structure.height = 1;
    connectivity.lambda = 2.5;
    connectivity.connStrength = 24;
    connectivity.percentExc = 0.8;
    connectivity.C = 0.5;
    [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
    vinit=-65*ones(layers,1)+0*rand(layers,1);    % Initial values of v
    uinit=b.*vinit;                 % Initial values of u
    [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), ...
                                                a, b, c, d, S, delays, stImpulse1x1); 
    if max(firings(:,2)) >= layers*structure.width*structure.height
        numWaves1x1 = numWaves1x1 + 1;
    end
    
    %'enhanced' 1x1 column
    structure.width = 1;
    structure.height = 1;
    connectivity.lambda = 4;
    connectivity.connStrength = 30;
    connectivity.percentExc = 0.8;
    connectivity.C = 0.5;
    [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
    vinit=-65*ones(layers,1)+0*rand(layers,1);    % Initial values of v
    uinit=b.*vinit;                 % Initial values of u
    [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), ...
                                                a, b, c, d, S, delays, stImpulse1x1); 
    if max(firings(:,2)) >= layers*structure.width*structure.height
        numWaves1x1e = numWaves1x1e + 1;
    end
    
    %'constant' 1x1 column
    structure.width = 1;
    structure.height = 1;
    connectivity.lambda = 4;
    connectivity.connStrength = 30;
    connectivity.percentExc = 1;
    connectivity.C = 1;
    [a,b,c,d, S, delays, ecn] = makeColumnParameters_ConstNeurons(structure, connectivity, delay);
    vinit=-65*ones(layers,1)+0*rand(layers,1);    % Initial values of v
    uinit=b.*vinit;                 % Initial values of u
    [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), ...
                                                a, b, c, d, S, delays, stImpulse1x1); 
    if max(firings(:,2)) >= layers*structure.width*structure.height
        numWaves1x1c = numWaves1x1c + 1;
    end

end 

%Wave results
numWaves2x2 
numWaves1x1 
numWaves1x1e 
numWaves1x1c 

