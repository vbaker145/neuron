function s = mso_single( fs, nsamples, order )
nsamples = nsamples*fs;
t = 0:nsamples-1;
t = t./fs;

f = [0.2 0.311 0.42 0.51 0.63 0.74 0.85 -.97];
dynRange = [1 0.9.^(1:7)];
%f(5) = 0.1; %Idetify "bad" freq
%f = f(randperm(length(f))); %Shuffle frequencies

if order > length(f)
    order = length(f);
end

s = dynRange(order).*sin(f(order).*t); 

end

