function mv = plotColumn(width, height, layers, vall)

n = width*height*layers;

%xv = 0:width-1;
%yv = 0:width-1;
xv = [0 1 4 5];
yv = [0 1 4 5];
zv = 0:layers-1;
[x,y,z] = meshgrid(xv,yv,zv);

x = x(:); y = y(:); z = z(:);

vw = VideoWriter('column');
open(vw);

map = colormap('jet');
nt = size(vall,2);
mv(nt) = struct('cdata',[],'colormap',[]);
for jj=1:nt
    c = vall(:,jj); c = c+65;
    c(c>100) = 100; c(c<0) = 0;
    c=map(floor(c./100*(size(map,1)-1))+1,:);

    scatter3(x,y,z,50, c,'filled');
    axis equal;
    drawnow
    mv(jj) = getframe(gcf);
    writeVideo(vw, mv(jj));
end

close(vw);

end
