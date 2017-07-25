function [Wout, x, Yt] = trainESN( data, initLen, trainLen, inSize, resSize, Win, W, alpha  )
%Train ESN output weights

% allocated memory for the design (collected states) matrix
X = zeros(1+inSize+resSize,trainLen-initLen);
% set the corresponding target matrix directly
Yt = data(initLen+2:trainLen+1)';

% run the reservoir with the data and collect X
x = zeros(resSize,1);
%for t = 1:length(data)
for t=1:trainLen
	u = data(t);
	x = (1-alpha).*x + alpha.*tanh( Win*[1;u] + W*x );
	if t > initLen
		X(:,t-initLen) = [1;u;x];
	end
end

% train the output
reg = 1e-8;  % regularization coefficient
X_T = X';
Wout = Yt*X_T * inv(X*X_T + reg*eye(1+inSize+resSize));
%Wout = Yt*pinv(X);

end

