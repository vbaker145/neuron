function mv = plotWaves2D( f, pos )

x = pos.x; y = pos.y;

tmax = max(f(:,1));

dt = 2; %Milliseconds/tenth second

hf = figure(10);
set(hf, 'Position', [50 50 800 800]);

vw = VideoWriter('Waves2D');
open(vw);

for tt=0:dt:tmax
   fwin = find(f(:,1)>tt & f(:,1)<tt+dt);
   fev = f(fwin,:);
   plot(x(fev(:,2)), y(fev(:,2)), 'k.');
   axis([min(pos.x(:)) max(pos.x(:)) min(pos.y(:)) max(pos.y(:))])
   %axis equal
   drawnow
   %pause(0.2)
   writeVideo(vw, getframe(gcf));
end

close(vw);

end

