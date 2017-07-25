%Simulate recurrent network with delays
clear all; close all;
N = 50;
maxDelay = 33;

delays = randi(maxDelay, N); 

alpha = 0.75;

initLen = 500;
trainLen = 2000;
testLen = 2000;

x = zeros(maxDelay, N); %Node activations, first column is input history
win = 0.1.*(rand(1,N)-0.5);
w = rand(N,N)-0.5;
%u = sin(1.1.*(1:(initLen+trainLen+testLen)));
u = mso(1,initLen+trainLen+testLen,3);

for kk=1:N
   colInd = 1:N;
   rowInd = delays(colInd,kk)';
   inds(:,kk) = sub2ind([maxDelay N], rowInd, colInd);
end

out = zeros(2+N,trainLen);
for jj=1:(initLen+trainLen)
   %Copy down activation array
   x(2:end, :) = x(1:end-1,:);
   for kk=1:N
      %Calculate node activation
      x(1,kk) = tanh(w(kk,:)*(x(inds(:,kk)))+win(kk)*u(jj));
   end
   if jj>initLen
        out(:,jj-initLen) = [1; u(jj-1);  x(1,:)'];
   end
end

%train the output
Yt = u(initLen+1:trainLen+initLen); %Training signal
reg = 1e-8;  % regularization coefficient
X = out;
X_T = out';
Wout = Yt*X_T * inv(X*X_T + reg*eye(2+N));
for jj=1:testLen
    inData =u(initLen+trainLen+jj); 
   %Copy down activation array
   x(2:end, :) = x(1:end-1,:);
   for kk=1:N
      %Calculate node activation
      %x(1,kk) = tanh(w(kk,:)*(x(inds(:,kk)))+win(kk)*u(jj+initLen+trainLen));
      x(1,kk) = tanh(w(kk,:)*(x(inds(:,kk)))+win(kk)*inData);
   end
   Xout(jj) = Wout*[1; inData; x(1,:)'];
   
end
figure; imagesc(out); colorbar

figure; subplot(2,1,1);
gt = u(trainLen+initLen+1:end);
plot(Xout); hold on; plot(gt,'r');
subplot(2,1,2);
err = Xout-gt;
plot(err);