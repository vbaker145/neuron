function mv = plotForest( f, pos, v, sim_dt, fname )


if nargin < 6
    fname = 'Forest2D';
end
x = pos.x; y = pos.y;

xf = squeeze(x(:,:,1)); yf = squeeze(y(:,:,1)); 
xf = xf(:); yf = yf(:);

tmax = max(f(:,1));

dt = 2; %Milliseconds/tenth second
v_dt = dt/sim_dt;

hf = figure(10);
set(hf, 'Position', [50 50 1600 800]);
subplot(1,2,1); xlabel('X'); ylabel('Y');
axis([min(pos.x(:)) max(pos.x(:)) min(pos.y(:)) max(pos.y(:))])
subplot(1,2,2); xlabel('X'); ylabel('Y');
colormap('jet');

vw = VideoWriter(fname);
open(vw);

for tt=0:dt:tmax
   fwin = find(f(:,1)>tt & f(:,1)<tt+dt);
   fev = f(fwin,:);
   subplot(1,2,1);
   plot(x(fev(:,2)), y(fev(:,2)), 'k.');
   axis([min(pos.x(:)) max(pos.x(:)) min(pos.y(:)) max(pos.y(:))])
   
   %Plot membrane voltage
   ts = floor(tt/sim_dt)+1;
   vt = v(:,ts:ts+v_dt);
   vt = mean(vt');
   vt = reshape(vt, size(x));
   vt = mean(vt,3);
   
   subplot(1,2,2);
   
   scatter(xf, yf, 15, vt(:), 'filled'); colorbar;
   caxis([-70 -40])

   title(['T =' num2str(tt)]);
   drawnow
   writeVideo(vw, getframe(gcf));
end

close(vw);

end

