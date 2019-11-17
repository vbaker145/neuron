%Process audio files
clear all; close all;

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
    %[d, fs] = audioread(fname);
end

%Find all examples of digit 0 from Jackson
idx_jackson_digit0 = find( contains(spkr, "jackson") & digit==0 );


digits = [0,5,9];

for jj=1:length(digits)
   idx = find(digit==digits(jj)); 
   n_train = floor(length(idx)/2);
   n_test = n_train;
   idxTrain{jj} = idx ( floor(rand(1,n_train)*length(idx))+1 );
   idxTest{jj} = idx( floor(rand(1,n_test)*length(idx))+1 ); 
end

dig0_idx = idxTrain{1};

% idx = idx_digit0(end);
% fname = [fnames(idx).folder '/' fnames(idx).name]
% [d, fs] = audioread(fname);
% sound(d, fs);