clear all; close all;
rng(42);

load 2DSpreadingFirings.mat

diffTime = [];
diffTheta = [];
diffC = [];
thetas = [];
plotWaves2D_Rasters(firings, pos, 0:1999, 1100:25:1100+25*3);
for jj=1:10
    %testIdxX = floor(rand*200)+50;
    %testIdxY = floor(rand*200)+50;
    testIdxX = 150+jj;
    testIdxY = 150+jj;
    idx = find(pos.x==testIdxX & pos.y==testIdxY);

    ft = find( ismember(firings(:,2),idx) & firings(:,1)>1100 & firings(:,1)<1200 );
    ft = firings(ft,1);

    if length(ft) > 1
        %Check that the two neurons at X=Y=150 give similar results
        [wt1, theta1, c1] = calcWaveProperties(firings, pos, idx(1), 10, ft(1)-50, 0.5);
        [wt2, theta2, c2] = calcWaveProperties(firings, pos, idx(2), 10, ft(1)-50, 0.5);
        
        if ~isempty(wt1) & ~isempty(wt2)
            diffTime = [diffTime, wt2-wt1];
            diffTheta = [diffTheta, (theta2-theta1)*180/pi];
            diffC = [diffC, c2-c1];
            thetas = [thetas,theta1];
        end
    end
end

thetaErr = [mean(abs(diffTheta)), std(abs(diffTheta))]
CErr = [mean(abs(diffC)), std(abs(diffC))]
thetaDelta = [mean(abs(thetas*180/pi)), std(abs(thetas*180/pi))]

figure(100); plot(abs(diffTime), abs(diffTheta), 'x');
figure(200); plot(abs(diffTime), abs(diffC), 'x');



