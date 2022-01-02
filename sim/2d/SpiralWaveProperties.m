clear all; close all;
rng(42);

load 2DSpiralFirings.mat

diffTime = [];
diffTheta = [];
diffC = [];
thetas = [];

%Set spatial and temporal windows to examine
[xGrid, yGrid] = meshgrid(180:5:280, 100:5:200); 
xGrid = xGrid(:); yGrid = yGrid(:);
tBounds = [1100 1350];

times = nan(length(xGrid),1);
thetas = nan(length(xGrid),1);
speeds = nan(length(xGrid),1);

for jj=1:length(xGrid)
    testIdxX = xGrid(jj);
    testIdxY = yGrid(jj);
    idx = find(pos.x==testIdxX & pos.y==testIdxY);

    ft = find( ismember(firings(:,2),idx) & firings(:,1)>tBounds(1) & firings(:,1)<tBounds(2) );
    ft = firings(ft,1);

    if ~isempty(ft)
        %Check that the two neurons at X=Y=150 give similar results
        [wt, theta, c] = calcWaveProperties(firings, pos, idx(1), 10, [ft(1)-50 ft(1)+50], 0.5);
        
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

nwin = 8;
twin = (tBounds(2)-tBounds(1))/(nwin+1);
t = min(times):twin:min(times)+twin*nwin;

rasterPlots(firings, pos, t, xGrid, yGrid, times, thetas, speeds);

figure(100); histogram(speeds, 0:0.05:2,'FaceColor','k');
xlabel('Estimated wave speed (units/ms)'); ylabel('Counts'); 
set(gca,'FontSize', 12);


%%
function x = rasterPlots(f, pos, frameTimes, xGrid, yGrid, times, thetas, speeds)
x = pos.x; y = pos.y;


dt = 5; %Milliseconds/tenth second

h = figure(10);
set(h, 'Position', [100 100 800 550]);

nplots = length(frameTimes)-1;
ncols = 4;
if nplots == 1
    ncols = 1;  %One figure if a single plot
end

nrows = ceil(nplots/ncols);
for tt=1:length(frameTimes)-1
   fwin = find(f(:,1)>frameTimes(tt) & f(:,1)<frameTimes(tt)+dt);
   fev = f(fwin,:);
   
   subplot(nrows,ncols,tt); hold on;
   plot(x(fev(:,2)), y(fev(:,2)), 'k.');
   axis([min(xGrid) max(xGrid) min(yGrid) max(yGrid) ])
   
   %Add quivers
   gidx = find(times>frameTimes(tt) & times<frameTimes(tt+1));
   quiver(xGrid(gidx), yGrid(gidx), speeds(gidx).*cos(thetas(gidx)), speeds(gidx).*sin(thetas(gidx)),'r')
   
   text(min(xGrid)+5, max(yGrid)-5, ['T=' num2str(frameTimes(tt)) ], 'FontSize', 10, 'BackgroundColor', 'White')
   set(gca, 'XTick', []);
   set(gca, 'YTick', []);
end

end
