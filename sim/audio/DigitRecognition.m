%Process audio files
clear all; close all;

fs = 8e3; %Sample frequency in Hz
dt = 0.5; %Tiem step in milliseconds

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
chn = earModel(fs);
lpf = ones(1,50)./50;

%Pull training/test data for specified digits
digits = [0,5,9];
for jj=1:length(digits)
   idx = find(digit==digits(jj)); 
   n_train = floor(length(idx)/2);
   n_test = n_train;
   idxTrain{jj} = idx ( floor(rand(1,n_train)*length(idx))+1 );
   idxTest{jj} = idx( floor(rand(1,n_test)*length(idx))+1 ); 
end

%Train the perceptron outputs, linear regression
for jj=1:length(digits)
    kidx = idxTrain{jj};
    for kk = 1:length(kidx)
        %Read audio file
        d = audioread( [fnames(kidx(kk)).folder '/' fnames(kidx(kk)).name] );
        
        %Process into 9 frequency regions for stimulus
        for fidx = 1:9
            fd = filter(chn(:,fidx),1,d);
            fd = filter(lpf,1,abs(fd));
            fd = fd./max(fd);
            so(:,fidx) = fd;
        end
        
        %Stimulate column
        a = 1;
        
        %Record average firing rate at end of digit per column
    end
end
%Train perceptron on data

%Evaluate the test data
for jj=1:length(digits)
    for kk = 1:length(idxTest{jj})
        %Read audio file
        
        %Process into 9 frequency regions for stimulus
        
        %Stimulate column
        
        %Record average firing rate at end of digit per column
        
        %Recognize with perceptron
    end
end
%Evaluate recognition accuracy


idx_digit0 = idxTrain{1};
idx = idx_digit0(end);
fname = [fnames(idx).folder '/' fnames(idx).name];
[d, fs] = audioread(fname);
sound(d, fs);