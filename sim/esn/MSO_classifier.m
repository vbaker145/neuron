%ESN classifier for MSO
clear all; close all;

%Create common resevoir
nSines = 4;
initLen = 100;
trainLen = 2000; testLen = 2000;
inSize = 1; outSize = 1;
resSize = 500;
alpha = (rand(resSize,1)-0.5)*0.75+0.5;

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
W = W .* ( 1.25 /rhoW);

%Train on MSOs
for jj=1:nSines
   din= mso(1,initLen+trainLen+testLen,jj)';
   din = din./max(abs(din)); 
   [Wout_n(:,jj) x_n(:,jj)] = trainESN( din, initLen, trainLen, inSize, resSize, Win, W, alpha  );
end

tdat = mso(1,initLen+trainLen+testLen,3)';

for jj=1:nSines
    Y = zeros(outSize,testLen);
    u = tdat(trainLen+1);
    Wout = Wout_n(:,jj)';
    x = x_n(:,jj);
    for t = 1:testLen 
        x = (1-alpha).*x + alpha.*tanh( Win*[1;u] + W*x );
        y = Wout*[1;u;x];
        Y(:,t) = y;
        % generative mode:
        %u = y;
        % this would be a predictive mode:
        u = tdat(trainLen+t+1);
    end
    errorLen = 500;
    mse(jj) = sum((tdat(trainLen+2:trainLen+errorLen+1)'-Y(1,1:errorLen)).^2)./errorLen;
    
    figure(jj); subplot(2,1,1)
    plot( tdat(trainLen+2:trainLen+testLen+1), 'color', [0,0.75,0] );
    hold on;
    plot( Y', 'b' );
    hold off;
    axis tight;
    title('Target and generated signals y(n) starting at n=0');
    legend('Target signal', 'Free-running predicted signal');
    
    figure(jj); subplot(2,1,2)
    pdata = tdat(trainLen+2:trainLen+testLen+1); 
    win = hamming(length(pdata));
    plot( 20*log10(abs(fft(win.*pdata))), 'color', [0,0.75,0] );
    hold on;
    plot( 20*log10(abs(fft(win.*Y'))), 'b' );
    hold off;
    axis tight;
    title('Spectrum of target and generated signals y(n) starting at n=0');
    legend('Target signal', 'Free-running predicted signal');
end
