%ESN generation of MSO signals
close all;
maxSines = 5;
nruns = 20;

resSize = 500;

fails = zeros(1,maxSines);
nrmse = zeros(1,maxSines);
for nsines = 1:maxSines
    nsines
    fails(nsines) = 0;
    nrmse(nsines) = 0;
    ngood = 0;
    for jj=1:nruns
        din = mso(1,10000,nsines)';
        din = din./max(abs(din));
        a = (rand(resSize,1)-0.5)*0.75+0.5;
        %a = 0.5;
        [Y, mse] = esn(din,2000,2000,resSize,a);
        if sum(isnan(Y)+isinf(Y)) > 0 
            fails(nsines) = fails(nsines)+1;
        else
            ngood = ngood + 1;
            nrmse(nsines) = nrmse(nsines)+mse;
        end
    end
    nrmse(nsines) = nrmse(nsines)/ngood;
end