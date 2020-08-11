clear all; close all;

rng(42); %Seed random for consistent results

width = 2;
height = 2;
layers = 100;
N = width*height*layers;
N_layer = width*height;

%Column parameters
structure.width = width;
structure.height = height;
structure.layers = layers;
structure.displacement = 0.0;

connectivity.percentExc = 1;
connectivity.connType = 1;
connectivity.lambda = 2.5;
connectivity.maxLength = 100;
connectivity.connStrength = 0; %Disconnected neurons, we just want the stimulus response

dt = 0.1;
tmax = 200;
t = 0:dt:tmax;

delay.delayType = 1;
delay.delayMult = 1;
delay.delayFrac = 1.0;
delay.dt = dt;

vall = []; uall = [];

currentStepMag = 1:15;

%Make column
[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
    
fdelExc = [];
for jj=1:length(currentStepMag)
    %Step stimulus to all neurons at t=100 milliseconds
    stImpulse = zeros(N, size(t,2));
    sidx = 100/dt;
    stImpulse(:, sidx:end)= currentStepMag(jj);
    stImpulse = (interp1(0:tmax, stImpulse(:,1:1/dt:end)', 0:dt:tmax))';    

    %Simulate column
    vinit=-65*ones(N,1)+0*rand(N,1);    % Initial values of v
    uinit=b.*vinit;                 % Initial values of u

    %Column impulse response
    [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stImpulse);
    figure(5); subplot(2,1,1);
    plot(firings(:,1)./1000, firings(:,2)/(N_layer),'k.');
    xlim([0.09 0.12]);
    ylabel('Z position', 'FontSize', 12)
    subplot(2,1,2);
    plot(t./1000, mean(stImpulse), 'kx');
    xlim([0.09 0.12]);
    xlabel('Time (seconds)','FontSize',12)
    ylabel('Input (mV)')
    set(gca, 'FontSize',12)

    fireDelays = [];
    for kk=1:N
        fi = find(firings(:,2)==kk);
        fi = firings(fi,1);
        fi = min(fi);
        if ~isempty(fi)
           fireDelays = [fireDelays  fi];
        end
    end
    
    fdelExc(jj) = mean(fireDelays);
end

%Make column
connectivity.percentExc = 0; %All inhibitory neurons
[a,b,c,d, S, delays, ecn] = makeColumnParameters(structure, connectivity, delay);
    
fdelInhb = [];
for jj=1:length(currentStepMag)
    %Step stimulus to all neurons at t=100 milliseconds
    stImpulse = zeros(N, size(t,2));
    sidx = 100/dt;
    stImpulse(:, sidx:end)= currentStepMag(jj);
    stImpulse = (interp1(0:tmax, stImpulse(:,1:1/dt:end)', 0:dt:tmax))';    

    %Simulate column
    vinit=-65*ones(N,1)+0*rand(N,1);    % Initial values of v
    uinit=b.*vinit;                 % Initial values of u

    %Column impulse response
    [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), a, b, c, d, S, delays, stImpulse);
    figure(5); subplot(2,1,1);
    plot(firings(:,1)./1000, firings(:,2)/(N_layer),'k.');
    xlim([0.09 0.12]);
    ylabel('Z position', 'FontSize', 12)
    subplot(2,1,2);
    plot(t./1000, mean(stImpulse), 'kx');
    xlim([0.09 0.12]);
    xlabel('Time (seconds)','FontSize',12)
    ylabel('Input (mV)')
    set(gca, 'FontSize',12)

    fireDelays = [];
    for kk=1:N
        fi = find(firings(:,2)==kk);
        fi = firings(fi,1);
        fi = min(fi);
        if ~isempty(fi)
           fireDelays = [fireDelays  fi];
        end
    end
    
    fdelInhb(jj) = mean(fireDelays);
end

figure; 
plot(currentStepMag, fdelExc-100, 'ko-','MarkerSize', 10);
hold on; plot(currentStepMag, fdelInhb-100, 'kx--','MarkerSize', 10);
xlabel('Input step magnitude (mV)'); ylabel('Average delay before firing (ms)');
legend(['Excitatory neurons'; 'Inhibitory neurons']);
set(gca,'FontSize', 12);
