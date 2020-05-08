function avg = cavg_cfar( d, ntest, nguard, nwin )
%Cell-averaged 1-D CFAR smoothing

t = zeros(1,length(d)+2*(nguard+nwin));
sidx = nguard+nwin+1;
eidx = length(t)-nguard-nwin;

t(sidx:eidx) = d;

cwin = [ones(1,nwin) zeros(1,2*nguard+1) ones(1,nwin)];
noise = conv(t, cwin, 'same');
noise = noise+eps;

twin = ones(1,ntest);
sig = conv(t,twin,'same');

avg = sig(sidx:eidx)./noise(sidx:eidx);

%avg = avg./max(avg);

end

