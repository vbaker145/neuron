function [Y, mse] = esn( data, trainLen, testLen, resSize, alpha )

% A minimalistic Echo State Networks demo with Mackey-Glass (delay 17) data 
% in "plain" Matlab.
% by Mantas Lukosevicius 2012
% http://minds.jacobs-university.de/mantas

% load the data
%trainLen = 2000;
%testLen = 2000;
%trainLen = 4000;
%testLen = 4000;
initLen = 100;

%data = load('MackeyGlass_t17.txt');
%t = 0:pi/13:(10000-1)*pi/13;
%data = sin(.13.*t)'+0.2.*sin(0.45.*t)';
%data = mso(1,10000,5)';
%data = data./max(abs(data));

% plot some of it
% figure(10);
% plot(data(1:1000));
% title('A sample of data');

% generate the ESN reservoir
inSize = 1; outSize = 1;
%a = 0.3; % leaking rate
%a = 0.35; % leaking rate
a = alpha;

%rand( 'seed', 42 );
Win = (rand(resSize,1+inSize)-0.5) .* 1;
W = rand(resSize,resSize)-0.5;
%W = normrnd(0,1,resSize,resSize);
% Option 1 - direct scaling (quick&dirty, reservoir-specific):
% W = W .* 0.13;
% Option 2 - normalizing and setting spectral radius (correct, slower):
%disp 'Computing spectral radius...';
opt.disp = 0;
rhoW = abs(eigs(W,1,'LM',opt));
%disp 'done.'
W = W .* ( 1.25 /rhoW);

%Train the ESN
[Wout, x, Yt] = trainESN( data, initLen, trainLen, inSize, resSize, Win, W, alpha  );

% run the trained ESN in a generative mode. no need to initialize here, 
% because x is initialized with training data and we continue from there.
Y = zeros(outSize,testLen);
u = data(trainLen+1);
for t = 1:testLen 
	x = (1-a).*x + a.*tanh( Win*[1;u] + W*x );
	y = Wout*[1;u;x];
	Y(:,t) = y;
	% generative mode:
	%u = y;
	% this would be a predictive mode:
	u = data(trainLen+t+1);
    %u = sin(0.3*(trainLen+t+1));
end

errorLen = 500;
mse = sum((data(trainLen+2:trainLen+errorLen+1)'-Y(1,1:errorLen)).^2)./errorLen;
%disp( ['MSE = ', num2str( mse )] );

% plot some signals
figure(1);
plot( data(trainLen+2:trainLen+testLen+1), 'color', [0,0.75,0] );
hold on;
plot( Y', 'b' );
hold off;
axis tight;
title('Target and generated signals y(n) starting at n=0');
legend('Target signal', 'Free-running predicted signal');

figure(2)
pdata = data(trainLen+2:trainLen+testLen+1); 
win = hamming(length(pdata));
plot( 20*log10(abs(fft(win.*pdata))), 'color', [0,0.75,0] );
hold on;
plot( 20*log10(abs(fft(win.*Y'))), 'b' );
hold off;
axis tight;
title('Spectrum of target and generated signals y(n) starting at n=0');
legend('Target signal', 'Free-running predicted signal');

end

