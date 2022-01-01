clear all; close all;
rng(42);

load 2DSpreadingFirings.mat

diffTime = [];
diffTheta = [];
diffC = [];
thetas = [];
plotWaves2D_Rasters(firings, pos, 0:1999, 1100:25:1100+25*3);


xGrid = meshgrid(150:10:250); 
yGrid = xGrid';
xGrid = xGrid(:); yGrid = yGrid(:);

times = nan(length(xGrid),1);
thetas = nan(length(xGrid),1);
speeds = nan(length(xGrid),1);

for jj=1:length(xGrid)
    testIdxX = xGrid(jj);
    testIdxY = yGrid(jj);
    idx = find(pos.x==testIdxX & pos.y==testIdxY);

    ft = find( ismember(firings(:,2),idx) & firings(:,1)>1100 & firings(:,1)<1200 );
    ft = firings(ft,1);

    if length(ft) > 1
        %Check that the two neurons at X=Y=150 give similar results
        [wt, theta, c] = calcWaveProperties(firings, pos, idx(1), 10, ft(1)-50, 0.5);
        
        if ~isempty(wt)   
            times(jj) = wt;
            thetas(jj) = theta;
            speeds(jj) = c;
        end
    end
end

figure(50); quiver(xGrid, yGrid, speeds.*cos(thetas), speeds.*sin(thetas),'k')
axis equal
xlabel('X'); ylabel('Y');
set(gca,'FontSize', 12);

nwin = 4;
twin = (max(times)-min(times))/(nwin+1);
t = min(times):twin:min(times)+twin*(nwin+1);

figure(75);
subplot(1, nwin,1);

for jj=1:nwin
    subplot(1, nwin,jj); 
    gidx = find(times>t(jj) & times<t(jj+1));
    quiver(xGrid(gidx), yGrid(gidx), speeds(gidx).*cos(thetas(gidx)), speeds(gidx).*sin(thetas(gidx)),'k')
    axis([min(xGrid) max(xGrid) min(yGrid) max(yGrid)]); 
    axis square
end


