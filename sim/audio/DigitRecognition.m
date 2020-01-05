%Process audio files
clear all; close all;

doplots = 0;

fs = 8e3; %Sample frequency in Hz
dt = 1e3/fs; %Time step in milliseconds
tmax = 1000;

addpath('../lsm'); %Neural column code
data_dir = '../../data/free-spoken-digit-dataset-master/recordings';

fnames = dir(data_dir);
fnames = fnames(3:end);
for jj=1:length(fnames)
    fname = [fnames(jj).folder '/' fnames(jj).name];
    tok = split(fnames(jj).name, ["_","."]);
    digit(jj) = str2double(char(tok(1)));
    spkr{jj} = char(tok(2));
    trial(jj) = str2double(char(tok(3)));
end

%Find all examples of digit 0 from Jackson
idx_jackson_digit0 = find( contains(spkr, "jackson") & digit==0 );

%Make a column ensemble to process the audio data 
colStruct = makeAudioColumnEnsemble();
stimStrength = 4;
chn = earModel(fs);
lpf = ones(1,50)./50;

digits = 0:9;

%Train the perceptron outputs, linear regression
for jj=1:length(digits)
    %kidx = idxTrain{jj};
    disp(['Digit ' num2str(digits(jj))])
    kidx = find(digit==digits(jj));
    for kk = 1:length(kidx)
        %Read audio file
        d = audioread( [fnames(kidx(kk)).folder '/' fnames(kidx(kk)).name] );
        if doplots == 1
           figure(10); plot((0:length(d)-1)./fs, d);
           xlabel('Time (s)'); ylabel('Amplitude')
           title(num2str(digits(jj)));
        end
        
        %Process into 9 frequency regions for stimulus
        if doplots == 1
           figure(20); clf;
           subplot(3,3,1); hold on;
        end
        so = [];
        for fidx = 1:9
            fd = filter(chn(:,fidx),1,d);
            fd = filter(lpf,1,abs(fd));
            fd = fd./max(fd);
            so(:,fidx) = fd;
            if doplots == 1
                subplot(3,3,fidx); plot(fd);
            end
        end
        
        %Stimulate column
        t=0:dt:(dt*(length(d)-1));
        st = audioEnsembleStimulus( colStruct.structure, colStruct.csec, ...
            dt, t, so, stimStrength);
        
        vinit=-65*ones(colStruct.N,1)+0*rand(colStruct.N,1);    % Initial values of v
        uinit=(colStruct.b).*vinit;                 % Initial values of u
        
        [v, vall, u, uall, firings] = izzy_net(vinit,uinit,dt, length(t), ...
            colStruct.a, colStruct.b, colStruct.c, colStruct.d, colStruct.S, ...
            colStruct.delays, st);
        
        
        for fidx=0:colStruct.nCols-1
            if doplots == 1
                idx = colStruct.csec(firings(:,2))==fidx;
                f = firings(idx,:);
                %fc{jj+1} = f;
                figure(30); 
                subplot(1,colStruct.nCols,fidx+1);
                plot(f(:,1)./1000, floor(f(:,2)/colStruct.Nlayer),'k.');
                axis([0 max(t)/1000 0 colStruct.structure.layers] ); set(gca, 'XTickLabel',[]);
                text(0.9,80,['COl #=' num2str(fidx)],'BackgroundColor', 'White')
            end
        end
        
        %Record average firing rate at end of digit per column
        [avgFireRates, smoothedFires, sout] = columnFiringRate( colStruct, firings, so, t, tmax );
        afr{jj,kk} = avgFireRates;
        sfr{jj,kk} = smoothedFires;
        audioStim{jj,kk} = sout';
        
    end
end

%Train perceptron on data
[mdl X Y] = trainAudioClassifier(sfr);

% idx_digit0 = idxTrain{1};
% idx = idx_digit0(end);
% fname = [fnames(idx).folder '/' fnames(idx).name];
% [d, fs] = audioread(fname);
% sound(d, fs);