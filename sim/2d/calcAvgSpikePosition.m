function [t, aspr, aniso] = calcAvgSpikePosition( f, t, pos, centerPos )

x = pos.x; y = pos.y;

dt = 5; %Milliseconds per calculation

idx = 1;

aspx = []; aspy = [];

for jj=1:length(t)
   fwin = find(f(:,1)>t(jj) & f(:,1)<t(jj)+dt);
   fev = f(fwin,:);
   
   xc = x(fev(:,2))-centerPos(1);
   yc = y(fev(:,2))-centerPos(2);
   
   aspr(jj,1) = mean(xc);
   aspr(jj,2) = mean(yc);  
end

aniso = sqrt( aspr(:,1).^2 + aspr(:,2).^2 );