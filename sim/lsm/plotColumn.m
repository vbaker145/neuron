function mv = plotColumn(pos, sim_dt, v, fname)

if nargin < 4
    fname = 'ColumnMembranePotential';
end

x = pos.x(:); y=pos.y(:); z=pos.z(:);

vw = VideoWriter(fname);
open(vw);

hf = figure(10);
set(hf, 'Position', [76 1 500 973]);

plot_dt = 2;
v_dt= plot_dt/sim_dt;
tmax = size(v,2)*sim_dt;
nt = floor(tmax/plot_dt);

map = colormap('jet');
mv(nt) = struct('cdata',[],'colormap',[]);
for jj=0:nt-1
    tt = jj*plot_dt;
    
    %Plot membrane voltage
    ts = floor(tt/sim_dt)+1;
    vt = v(:,ts:ts+v_dt);
    vt = mean(vt');
    
    c = vt+65;
    c(c>100) = 100; c(c<0) = 0;
    c=map(floor(c./100*(size(map,1)-1))+1,:);

    scatter3(x,y,z,50, c,'filled');
    axis equal;
    title(['T =' num2str(tt)]);
    campos([33.7163  -57.6982  129.1888]);
    drawnow
    mv(jj+1) = getframe(gcf);
    writeVideo(vw, mv(jj+1));
end

close(vw);

end
