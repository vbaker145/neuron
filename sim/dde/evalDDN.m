function [ Xout ] = evalDDN( evalData, maxDelay, delays, N, W, Win, Wout )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

ut = evalData;

x = zeros(maxDelay, N); %Node activations, first column is input history

for kk=1:N
   colInd = 1:N;
   rowInd = delays(colInd,kk)';
   inds(:,kk) = sub2ind([maxDelay N], rowInd, colInd);
end

for jj=1:length(evalData)
   %inData =u(initLen+trainLen+jj); %Predictive mode
   inData = ut(jj);
   %Copy down activation array
   x(2:end, :) = x(1:end-1,:);
   for kk=1:N
      %Calculate node activation
      %x(1,kk) = tanh(w(kk,:)*(x(inds(:,kk)))+win(kk)*u(jj+initLen+trainLen));
      x(1,kk) = tanh(W(kk,:)*(x(inds(:,kk)))+Win(kk)*[inData]);
      %x(1,kk) = tanh(w(kk,:)*(x(inds(:,kk)))+win(kk,:)*[1]);
   end
   %Xout(jj) = Wout*[win(kk,:)'.*[1; inData]; x(1,:)'];
   Xout(jj) = Wout*[inData; x(1,:)'];
   %inData = Xout(jj); %Generative mode
   %inData = rand();
end

end

