function [Wout, x, Yt ] = trainDDN( data, initLen, trainLen, Win, W, N, maxDelay, delays)

x = zeros(maxDelay, N); %Node activations, first column is input history
u = data;

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
      x(1,kk) = tanh(W(kk,:)*(x(inds(:,kk)))+Win(kk)*[u(jj)]);
   end
   if jj>initLen
        %out(:,jj-initLen) = [1; u(jj-1);  x(1,:)'];
        out(:,jj-initLen) = [u(jj-1); x(1,:)'];
   end
end

%train the output
%Yt = u(initLen+1:trainLen+initLen); %Training signal
Yt = ones(1,trainLen);

reg = 1e-8;  % regularization coefficient
X = out;
X_T = out';
Wout = Yt*X_T * inv(X*X_T + reg*eye(1+N));

%Wout = Yt*pinv(X);

end

