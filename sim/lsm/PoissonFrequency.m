%test frequency content of Poisson spike train
dt = 0.0001;
fs = 1/dt;
frf = 20;
duration = 100;

st = poissonSpikeTrain(duration, frf , dt);

gs = exp(-(-5:5).^2/4)
stg = conv(st,gs);
stg = stg-mean(stg);

figure; plot((-0.5:1/(length(stg)-1):0.5).*fs, fftshift(log(abs(fft(stg)))))
xlabel('Frequency (Hz)','FontSize', 12);
ylabel('Log intensity','FontSize', 12);
