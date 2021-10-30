function mv = plotForest_Frames( f, pos, v, sim_dt, frameTimes )

x = pos.x; y = pos.y;

xf = squeeze(x(:,:,1)); yf = squeeze(y(:,:,1)); 
xf = xf(:); yf = yf(:);

tmax = max(f(:,1));

dt = 2; %Milliseconds/tenth second
v_dt = dt/sim_dt;

h = figure(10);
set(h, 'Position', [100 100 800 550]);
colormap('jet');
nplots = length(frameTimes);
ncols = 4;
nrows = ceil(nplots/ncols);

for tt=1:length(frameTimes)
%    fwin = find(f(:,1)>tt & f(:,1)<tt+dt);
%    fev = f(fwin,:);
%    subplot(1,2,1);
%    plot(x(fev(:,2)), y(fev(:,2)), 'k.');
%    axis([min(pos.x(:)) max(pos.x(:)) min(pos.y(:)) max(pos.y(:))])
   
   %Plot membrane voltage
   ts = floor(frameTimes(tt)/sim_dt)+1;
   vt = v(:,ts:ts+v_dt);
   vt = mean(vt');
   vt = reshape(vt, size(x));
   vt = mean(vt,3);
   
   subplot(nrows,ncols,tt);
   
   scatter(xf, yf, 15, vt(:), 'filled');
   caxis([-70 -40])
   axis([min(pos.x(:)) max(pos.x(:)) min(pos.y(:)) max(pos.y(:))])
   
   text(max(x(:))/10, 0.9*max(y(:)), ['T=' num2str(frameTimes(tt)) ], 'FontSize', 10, 'BackgroundColor', 'White')
   set(gca, 'XTick', []);
   set(gca, 'YTick', []);
end

mv=1;

end

