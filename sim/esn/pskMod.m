function psk = pskMod(nsamples, upSamp, downSamp )
%Generate PSK data
nsyms = ceil(nsamples/(upSamp/downSamp));
con = [0.5+1i*0.5, -0.5+1i*0.5, -0.5-1i*0.5, 0.5-1i*0.5];
syms = con(randi(4,1,nsyms));

psk = resample(syms, upSamp, downSamp);
psk = psk(1:nsamples);

end

