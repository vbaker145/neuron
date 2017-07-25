%Simulate recurrent network with delays
clear all; 
N = 100;
maxDelay = 33;

delays = randi(maxDelay, N); 

alpha = 0.75;

simSteps = 2000;
simT = 1:simSteps;

x = zeros(maxDelay, N); %Node activations, first column is input history
win = rand(1,N)-0.5;
w = rand(N,N)-0.5;
u = sin(0.77.*simT);

for kk=1:N
   colInd = 1:N;
   rowInd = delays(colInd,kk)';
   inds(:,kk) = sub2ind([maxDelay N], rowInd, colInd);
end

out = zeros(1,N);
for jj=1:simSteps
   %Copy down activation array
   x(2:end, :) = x(1:end-1,:);
   for kk=1:N
      %Calculate node activation
      x(1,kk) = tanh(w(kk,:)*(x(inds(:,kk)))+win(kk)*u(jj));
   end
   out = [out; x(1,:)];
end

% train the output
trainLen = 
reg = 1e-8;  % regularization coefficient
X_T = X';
Wout = Yt*X_T * inv(X*X_T + reg*eye(1+inSize+resSize));

figure; imagesc(out); colorbar