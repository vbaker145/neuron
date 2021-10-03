function mv = plotWaves2D_Rasters( f, pos, sim_dt, frameTimes )

x = pos.x; y = pos.y;

tmax = max(f(:,1));

dt = 2; %Milliseconds/tenth second

idx = 1;

h = figure(10);
set(h, 'Position', [100 100 800 550]);

nplots = length(frameTimes);
ncols = 4;
if nplots == 1
    ncols = 1;  %One figure if a single plot
end

nrows = ceil(nplots/ncols);
for tt=1:length(frameTimes)
   fwin = find(f(:,1)>frameTimes(tt) & f(:,1)<frameTimes(tt)+dt);
   fev = f(fwin,:);
   
   subplot(nrows,ncols,tt);
   plot(x(fev(:,2)), y(fev(:,2)), 'k.');
   axis([min(pos.x(:)) max(pos.x(:)) min(pos.y(:)) max(pos.y(:))])
   
   text(max(x(:))/10, 0.85*max(y(:)), ['T=' num2str(frameTimes(tt)) ], 'FontSize', 10, 'BackgroundColor', 'White')
   set(gca, 'XTick', []);
   set(gca, 'YTick', []);
end

mv = 1;

end

