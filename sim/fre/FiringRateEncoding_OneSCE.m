%% Firing rate encoding with a minicolumn ensemble
%

clear all; close all;

rng(35);

addpath('../sce'); %Neural column code

dt = 0.1;
tmax = 2000;
t = 0:dt:tmax;
nInputPool = 50;
binDuration = 1;
bins = 0:binDuration:tmax;

%Make column ensemble
%Make column ensemble
%Connected microcolumn ensemble
structure.width = 2;
structure.height = 2;
structure.nWide = 1;
structure.nHigh = 1;
structure.columnSpacing = 2.5;
structure.layers = 40;
structure.displacement = 0;

%Make SCE
colStruct  = makeFiringRateColumnEnsemble(dt, 7, structure);

nTrials = 100;
 
firingRates = 1:2:21;
nFiringRates = length(firingRates);

%connErr = zeros(length(colStructs), nTrials, 6);
%nFirings = zeros(length(colStructs), nTrials);

for fr = 1:nFiringRates
    fr

    for iTrial = 1:nTrials
        %% Simulate column ensembles

        %Random stimulus and background
        firingRate = firingRates(fr)*ones(1,length(t));
        [st, stSpikes] = firingRateEnsembleStimulus( colStruct.structure, ...
                                            colStruct.csec, colStruct.ecn, dt, ...
                                            t, nInputPool, firingRate, 6 );

        vinit=-65*ones(colStruct.N,1)+0*rand(colStruct.N,1);    % Initial values of v
        uinit=(colStruct.b).*vinit;                 % Initial values of u

        %Simulate column ensemble
        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), ...
            colStruct.a, colStruct.b, colStruct.c, colStruct.d, colStruct.S, ...
            colStruct.delays, st);  
        size(firings)

        %Average the meuron activity at the input and output of the SCE
        inputMP = mean(vall(1:colStruct.Nlayer,:));
        outputMP = mean(vall(end-colStruct.Nlayer:end,:));

        %Find peaks in input/output membrane potential
        [ip iw op ow] = findPeaks(inputMP, outputMP, dt, 0.25);
        npks(fr, iTrial) = length(op)-1;
        
        if iTrial == 1
           %Save raster plot
           raster{fr} = firings;
           spikes{fr} = stSpikes;
        end
    end %Trial loop

end %End loop columns


m = mean(npks,2);
v = std(npks,0,2);
h = figure(20); set(h, 'Position', [0 0 900 500]);
errorbar(firingRates,m(:,1), v(:,1), 'ko', 'MarkerFaceColor', 'k');

%Fit activation function to data
actfun = @(b,x)(1./(b(1)-b(2).*log(1-1./(b(2).*x)) ));
bt = nlinfit(firingRates', m, actfun, [1 1]);
hold on; plot(firingRates, actfun(bt,firingRates),'-.k', 'LineWidth', 2);

logfun = @(b,x)(b(1)*log(b(2)*x));
bt = nlinfit(firingRates', m, logfun, [1 1]);
hold on; plot(firingRates, logfun(bt,firingRates),'--k', 'LineWidth', 2);

legend('Measurement', 'Activation function fit', 'Logarithmic fit');
xlim([0 22]); ylim([0 8]);

xlabel('Input firing rate (spikes/second)');
ylabel('Wave arrival rate (waves/second)')
set(gca,'FontSize', 14);



%Raster plots
h = figure(10); set(h, 'Position', [0 0 900 600]);
sidx = [1 3 11];

%Creat subplots
for si=1:length(sidx)
   hs(si) = subplot(2,3,si);
   hs(si+3) = subplot(2,3,si+3);
end

%Size subplots
for si=1:length(sidx)
    set(hs(si), 'Position', [0.1+0.3*(si-1)    0.4    0.25    0.55]);
    set(hs(si+3), 'Position', [0.1+0.3*(si-1)    0.1    0.25    0.25]);
end

%Plot into subplots
xlimits = [1000 2000];
ylimits = [0 colStruct.structure.layers];
for si = 1:length(sidx)
    subTop = hs(si);
    subBottom = hs(si+3);
    
    f = raster{sidx(si)};
    s = spikes{sidx(si)};

    plot(subTop, f(:,1), f(:,2)./colStruct.Nlayer, 'k.');
    set(subTop, 'XTickLabel', []);
    set(subTop, 'XLim', xlimits);
    set(subTop, 'YLim', ylimits);
    set(subTop, 'FontSize', 12);

    imagesc(subBottom, t, 1:nInputPool, s==0); colormap('gray');
    set(subBottom, 'YDir', 'Normal');
    set(subBottom, 'XLim', xlimits); 
    set(subBottom.XLabel, 'String', 'time (ms)');
    set(subBottom, 'FontSize', 12);
    
    if si==1
       set(subTop.YLabel, 'String', 'Z position');
       set(subBottom.YLabel, 'String', 'Neuron #');
    end
    
end
