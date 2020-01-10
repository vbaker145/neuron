function [mdl X Y md fa] = trainAudioClassifier( sfr )

sf1 = sfr{1,1};
[nClass nData] = size(sfr); 
npts = length(sf1(:));
X = zeros(nClass*nData,npts);

didx = 1;
for jj=1:nClass
    for kk=1:nData
       s = sfr{jj,kk};
       if length(s(:)) == npts
           X(didx,:) = s(:); 
           Y(didx) = jj;
           didx = didx+1;
       else
           jj
           kk
           size(s)
       end
    end
end

X = X(1:didx-1,:);

for jj=1:nClass
    Y_d = Y==jj;
    mdl{jj} = fitclinear(X,Y_d); 
    
    pv = predict(mdl{jj}, X);
    nClassPts = sum(Y_d);
    fa(jj) = length( find(pv' == 1 & Y_d == 0) )/(length(Y) -nClassPts)
    md(jj) = length( find(pv' == 0 & Y_d == 1) )/nClassPts
    %figure; plot(Y_d,'x'); 
    %hold on; plot(pv,'ro');
end

figure; plot(0:9, 1-md, 'k.-'); hold on; plot(0:9, fa, 'r.-')
xlabel('Spoken digit'); ylabel('% of all trials');
legend('Correct classification %', 'False alarm %' );
end

