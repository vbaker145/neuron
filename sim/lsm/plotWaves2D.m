function mv = plotWaves2D( f, pos, v, sim_dt, ecn, fname )

if nargin < 6
    fname = 'Waves2D';
end
x = pos.x; y = pos.y;

tmax = max(f(:,1));

dt = 2; %Milliseconds/tenth second
v_dt = dt/sim_dt;

hf = figure(10);
set(hf, 'Position', [50 50 1600 800]);
subplot(1,2,1); xlabel('X'); ylabel('Y');
subplot(1,2,2); xlabel('X'); ylabel('Y');

% vf = figure(20);
% set(vf, 'Position', [900 50 800 800] );
smoother = 0.5*ones(3);
smoother(5) = 1;
smoother = smoother ./ sum(smoother(:));


vw = VideoWriter(fname);
open(vw);

for tt=0:dt:tmax
   fwin = find(f(:,1)>tt & f(:,1)<tt+dt);
   fev = f(fwin,:);
   figure(10); subplot(1,2,1);
   plot(x(fev(:,2)), y(fev(:,2)), 'k.');
   axis([min(pos.x(:)) max(pos.x(:)) min(pos.y(:)) max(pos.y(:))])
   
   %Plot membrane voltage
   ts = floor(tt/sim_dt)+1;
   vt = v(:,ts:ts+v_dt);
   vt = mean(vt');
   vt = reshape(vt, size(x,1), []);
   vt = conv2(vt, smoother, 'same');
   subplot(1,2,2);
   
   imagesc(x(:,1), y(:,1), vt); colorbar;
   set(gca, 'YDir', 'Normal'); caxis([-70 -40]);
   hold on; plot(x(ecn) );
   title(['T =' num2str(tt)]);
   drawnow
   writeVideo(vw, getframe(gcf));
end

close(vw);

end

