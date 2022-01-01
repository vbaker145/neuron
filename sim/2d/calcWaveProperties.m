function [wt, theta, c] = calcWaveProperties(f, pos, cut, r, tut, waveSpeed)

%Calculate wave angles and speeds 
% f - matrix of firing indices and times
% pos - position of neurons
% cut - cell under test (index of neuron)
% r - radius within cut to consider
% tut - time under test, min/max times to consider

%Find distance from cell under test
x = pos.x(:); y = pos.y(:);
xut = x(cut); yut = y(cut);
dis = sqrt((y-yut).^2 + (x-xut).^2);

%Find spikes that fall within distance and time limits
rwin = find(dis<=r);
ridx =  ismember(f(:,2), rwin);
tidx = (f(:,1)>tut & f(:,1)<tut+100);
cidx = ridx & tidx;

fa = f(cidx, :);

cutSpikes = fa( fa(:,2)==cut,: );

if isempty( cutSpikes )
    disp('No spikes from CUT');
    wt = []; theta = []; c = [];
    return;
end

wt = cutSpikes(1,1);
nidx = unique(fa(:,2));

for jj=1:length(nidx)
   spikes = fa( fa(:,2)==nidx(jj), :); 
   dt(jj) = spikes(1,1) - cutSpikes(1,1);
   spikeVec(jj,:) = [x(spikes(1,2))-xut, y(spikes(1,2))-yut];
end

%Plot spike timing delta
figure(15); 
scatter(spikeVec(:,1), spikeVec(:,2), 30, dt, 'filled');
xlabel('X offset'); ylabel('Y offset');
colorbar;
axis equal; 
set(gca, 'FontSize', 12);

%Find best fit angle 
mAngle = angle(spikeVec(:,1) + 1i*spikeVec(:,2));
mr = sqrt(spikeVec(:,1).^2 + spikeVec(:,2).^2 );

testAngle = (0:364).*pi/180;
for jj=1:length(testAngle)
    errAngle(jj) = sum( abs(dt' - (1/waveSpeed)*(mr.*cos(mAngle-testAngle(jj)))) )/length(nidx);
end

[mv midx] = min(errAngle);
theta = testAngle(midx);

figure(25);
plot(errAngle, 'k');
xlabel('Angle (degrees)'); ylabel('Fit error'); set(gca, 'FontSize', 12);

%Now find best speed fit at that angle
testSpeed = 0.1:0.05:5;
for jj=1:length(testSpeed)
    errSpeed(jj) = sum( abs(dt' - (1/testSpeed(jj))*(mr.*cos(mAngle-theta))) )/length(nidx);
end
[mv midx] = min(errSpeed);
c = testSpeed(midx);
end

