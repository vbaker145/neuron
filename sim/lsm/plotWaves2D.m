function pc = plotWaves2D( f, pos, fname )

if nargin < 3
    fname = 'Waves2D';
end
x = pos.x; y = pos.y;

tmax = max(f(:,1));

dt = 2; %Milliseconds/tenth second

hf = figure(10);
set(hf, 'Position', [50 50 800 800]);

vw = VideoWriter(fname);
open(vw);
idx = 1;

for tt=0:dt:tmax
   fwin = find(f(:,1)>tt & f(:,1)<tt+dt);
   fev = f(fwin,:);
   if size(fev,1) > 10
      xv = x(fev(:,2)); yv = y(fev(:,2)); 
      pc(idx,:) = [mean(xv) mean(yv)];
      idx = idx + 1;
   end
   plot(x(fev(:,2)), y(fev(:,2)), 'k.');
   axis([min(pos.x(:)) max(pos.x(:)) min(pos.y(:)) max(pos.y(:))])
   %axis equal
   drawnow
   %pause(0.2)
   writeVideo(vw, getframe(gcf));
end

close(vw);

end

