%DDN test
clear all; close all;
N = 10;
maxDelay = 17;

delays = randi(maxDelay, N); 
%delays = ones(N);

for kk=1:N
   colInd = 1:N;
   rowInd = delays(colInd,kk)';
   inds(:,kk) = sub2ind([maxDelay N], rowInd, colInd);
end

initLen = 500;
trainLen = 2000;
testLen = 2000;

x = zeros(maxDelay, N); %Node activations, first column is input history
win = 0.1.*(rand(N,1)-0.5);
w = 0.1.*(rand(N,N)-0.5);
%u = sin(1.1.*(1:(initLen+trainLen+testLen)));
u = mso(1,initLen+trainLen+testLen,8);
u = u./max(abs(u));
[Wout, x, x8] = trainDDN( u, initLen, trainLen, win, w, N, maxDelay, delays  );
u = mso(1,initLen+trainLen+testLen,2);
u = u./max(abs(u));
[Wout, x, x2] = trainDDN( u, initLen, trainLen, win, w, N, maxDelay, delays  );
u = rand(1,initLen+trainLen+testLen)-0.5;
u = u./max(abs(u));
[Wout, x, xr] = trainDDN( u, initLen, trainLen, win, w, N, maxDelay, delays  );

ut = mso(1,testLen,8);
Xout = evalDDN( ut, maxDelay, delays, N, w, win, Wout );
%ut = mso(1,testLen,4);
ut = rand(1,testLen)-0.5;
XoutB = evalDDN( ut, maxDelay, delays, N, w, win, Wout );

figure(20); subplot(2,1,1);
%gt = u(trainLen+initLen+1:end);
gt = ut(1:testLen);
plot(Xout); hold on; plot(gt,'r');
subplot(2,1,2);
err = Xout-gt;
plot(err);

figure(30); plot(20*log10(abs(fftshift(fft(gt)))));
hold on; plot(20*log10(abs(fftshift(fft(Xout)))),'g');