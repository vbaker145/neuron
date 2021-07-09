function mv = plotWaves2D_Frames( f, pos, v, sim_dt, frameTimes )

x = pos.x; y = pos.y;

tmax = max(f(:,1));

dt = 2; %Milliseconds/tenth second
v_dt = dt/sim_dt;

% vf = figure(20);
% set(vf, 'Position', [900 50 800 800] );
smoother = 0.5*ones(3);
smoother(5) = 1;
smoother = smoother ./ sum(smoother(:));

idx = 1;

h = figure(10);
set(h, 'Position', [100 100 800 500]);
nplots = length(frameTimes);
ncols = 4;
nrows = ceil(nplots/ncols);
for tt=1:length(frameTimes)
   fwin = find(f(:,1)>frameTimes(tt) & f(:,1)<frameTimes(tt)+dt);
   fev = f(fwin,:);
   subplot(nrows,ncols,tt);
   plot(x(fev(:,2)), y(fev(:,2)), 'k.');
   axis([min(pos.x(:)) max(pos.x(:)) min(pos.y(:)) max(pos.y(:))])
   
   text(max(x(:))/10, 0.1*max(y(:)), ['T=' num2str(frameTimes(tt)) ], 'FontSize', 12, 'BackgroundColor', 'White')
   set(gca, 'XTick', []);
   set(gca, 'YTick', []);
   
   %Plot membrane voltage
%    ts = floor(frameTimes(tt)/sim_dt)+1;
%    vt = v(:,ts:ts+v_dt);
%    vt = mean(vt');
%    vt = reshape(vt, size(x));
%    vt = mean(vt,3);
%    
%    vt = conv2(vt, smoother, 'same');
%    subplot(2,nplots,tt+nplots);
%    
%    imagesc(x(:,1), y(:,1), vt); 
%    set(gca, 'YDir', 'Normal'); caxis([-70 -40]);
   %hold on; plot(x(ecn) );
   %title(['T =' num2str(tt)]);
end

mv = 1;

end

