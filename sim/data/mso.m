function s = mso( fs, nsamples, order )
%Produces multiple superimposed oscillator test data
nsamples = nsamples*fs;
t = 0:nsamples-1;
t = t./fs;

f = [0.2 0.311 0.42 0.51 0.63 0.74 0.85 -.97];
dynRange = [1 0.1.^(1:7)];
%f(5) = 0.1; %Idetify "bad" freq
%f = f(randperm(length(f))); %Shuffle frequencies

if order > length(f)
    order = length(f);
end

s = zeros(1, nsamples);
for jj=1:order
   s = s+dynRange(jj).*sin(f(jj).*t); 
end

%figure; plot(abs(xcorr(s)))

end

