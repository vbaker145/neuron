function channels = earModel(fs )
%Filterbank audio processing
%Crappy ear model

f0 = [10, 100, 150, 200, 300, 400, 500, 700, 1100 ];
f1 = [100, 150, 200, 300, 400, 500, 700, 1100, 2000 ];

n_filt = length(f0);
filt_order = 30;
fs2 = fs/2;

for jj=1:n_filt
    channels(:,jj) = fir1( filt_order,[f0(jj)/fs2 f1(jj)/fs2] ); 
end

end

