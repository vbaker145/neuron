function [ spikes ] = bsa( x )
%Ben spiking algorithm representation of a signal
thresh = 0.9550;

x = x./max(x);
x = x(:);

if size(x,1) > size(x,2)
    
end

%Original BSA filter
fc = [8 16 26 35 44 52 59 64 65 64 61 57 52 45 37 29 21 13 7 4]; 
fc = fc./sum(fc);
fc = fc(:);

nfilt = length(fc);
n = length(x);

spikes = zeros(size(x));
for jj=1:n-nfilt
    e1 = sum( abs( x(jj:jj+nfilt-1) - fc ) );
    e2 = sum( abs( x(jj:jj+nfilt-1) ) );
    
    if e1 <= e2-thresh
        x(jj:jj+nfilt-1) =  x(jj:jj+nfilt-1)-fc;
       spikes(jj) = 1;
    end
    
end


end

