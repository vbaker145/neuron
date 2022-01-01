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

thetas = zeros(length(xGrid),1);
speeds = zeros(length(xGrid),1);

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
            thetas(jj) = theta;
            speeds(jj) = c;
        end
    end
end

figure(50); quiver(xGrid, yGrid, speeds(:).*cos(thetas(:)), speeds(:).*sin(thetas(:)),'k')
axis equal
xlabel('X'); ylabel('Y');
set(gca,'FontSize', 12);





