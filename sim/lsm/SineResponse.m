%Sine wave input response
clear all; close all;

frq = 10:5:50;

width = 3;
height = 3;
layers = 20;
N = width*height*layers;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0.3;

connectivity.percentExc = 0.8;
connectivity.connType = 1;
connectivity.lambda = 2;
connectivity.connStrength = 7;

dt = 1.0;
tmax = 2000;
t = 0:dt:tmax;

delay.delayType = 1;
delay.delayMult = 5;
delay.delayFrac = 1;
delay.dt = dt;

waveSizes = []; waveFractions = []; waveSlopes = [];

%figure(20); subplot(3,3,1);
vall = []; uall = [];
Nruns = 5;
vout = zeros(length(frq), Nruns, length(t) );
for jj=1:Nruns
    %[pt, v, firings, hb] = ImpulseResponse(2, 1);
    %Make column
    [a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);

    %Simulate column
    nbins = 20;
    hbins = zeros(1,nbins);
    startTimes = []; startPos = [];
    for kk=1:length(frq)
        frq(kk)
        %Sine stimulus
        stSine = 0.5*rand(N,tmax+1); %Random background stimulus
        stimDepth = 1;
        stSine(1:stimDepth*width*height, :) = repmat( 10*sin(2*pi*frq(kk).*(t/1000)), stimDepth*width*height, 1);
    
        vinit=-65*ones(N,1)+5*rand(N,1);    % Initial values of v
        uinit=b.*vinit;                 % Initial values of u

        %Column impulse response
        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stSine);
        vo = vall(end-width*height+1:end, :);
        vout(kk, jj, :) = mean(vo);
    end
end

