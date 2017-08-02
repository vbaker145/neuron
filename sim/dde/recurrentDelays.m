%Simulate recurrent network with delays
clear all; close all;
N = 5;
maxDelay = 3;

delays = randi(maxDelay, N); 
%delays = ones(N,N)+3;

alpha = 0.75;

initLen = 500;
trainLen = 2000;
testLen = 2000;

x = zeros(maxDelay, N); %Node activations, first column is input history
win = 0.1.*(rand(N,1)-0.5);
w = 0.1.*(rand(N,N)-0.5);
%u = sin(1.1.*(1:(initLen+trainLen+testLen)));
u = mso(1,initLen+trainLen+testLen,8);

for kk=1:N
   colInd = 1:N;
   rowInd = delays(colInd,kk)';
   inds(:,kk) = sub2ind([maxDelay N], rowInd, colInd);
end

out = zeros(1+N,trainLen);
for jj=1:(initLen+trainLen)
   %Copy down activation array
   x(2:end, :) = x(1:end-1,:);
   for kk=1:N
      %Calculate node activation
      x(1,kk) = tanh(w(kk,:)*(x(inds(:,kk)))+win(kk)*[u(jj)]);
   end
   if jj>initLen
        %out(:,jj-initLen) = [1; u(jj-1);  x(1,:)'];
        out(:,jj-initLen) = [u(jj-1); x(1,:)'];
   end
end

%train the output
%Yt = u(initLen+1:trainLen+initLen); %Training signal
Yt = 20.*ones(1,trainLen);
reg = 1e-8;  % regularization coefficient
X = out;
X_T = out';
%Wout = Yt*X_T * inv(X*X_T + reg*eye(2+N));
%Wout = rand(1,N+2)-0.5;
Wout = Yt*pinv(X);
%Wout = rand(1,N+2)-0.5;

ut = mso(1,initLen+trainLen+testLen,8);
%ut = sin(0.01*(1:initLen+trainLen+testLen));
%ut = u;

inData =u(initLen+trainLen+1); 
for jj=1:testLen
   %inData =u(initLen+trainLen+jj); %Predictive mode
   inData = ut(jj);
   %Copy down activation array
   x(2:end, :) = x(1:end-1,:);
   for kk=1:N
      %Calculate node activation
      %x(1,kk) = tanh(w(kk,:)*(x(inds(:,kk)))+win(kk)*u(jj+initLen+trainLen));
      x(1,kk) = tanh(w(kk,:)*(x(inds(:,kk)))+win(kk)*[inData]);
      %x(1,kk) = tanh(w(kk,:)*(x(inds(:,kk)))+win(kk,:)*[1]);
   end
   %Xout(jj) = Wout*[win(kk,:)'.*[1; inData]; x(1,:)'];
   Xout(jj) = Wout*[inData; x(1,:)'];
   %inData = Xout(jj); %Generative mode
   %inData = rand();
end
figure(10); imagesc(out); colorbar

figure(20); subplot(2,1,1);
%gt = u(trainLen+initLen+1:end);
gt = ut(1:testLen);
plot(Xout); hold on; plot(gt,'r');
subplot(2,1,2);
err = Xout-gt;
plot(err);

figure(30); plot(20*log10(abs(fftshift(fft(gt)))));
hold on; plot(20*log10(abs(fftshift(fft(Xout)))),'g');
