%Plot neural microcolumn
clear;

xv = -1:1;
yv = -1:1;
zv = 1:15;
[x,y,z] = meshgrid(xv,yv,zv);

x = x(:); y = y(:); z = z(:);



figure; subplot(1,2,1); scatter3(x,y,z,50, 'black','filled')
hold on;

lambda = 8;
dmax = 5;
map = colormap('jet');
connections = zeros(length(x), length(x));
for jj=1:length(x)
    for kk=1:length(x)
        d = sqrt((x(jj)-x(kk)).^2+(y(jj)-y(kk))^2+(z(jj)-z(kk))^2);
        if rand() < exp(-(d/lambda)^2)
            connections(jj,kk) = 1;
            if d>0
                didx = d/dmax;
                didx = min(didx,1);
                c = map(floor(didx*size(map,1)),:);  
                line([x(jj) x(kk)],[y(jj) y(kk)], [z(jj) z(kk)], 'Color',c, 'LineWidth', 2*didx);
            end
        end
    end
end
title(['Connections, lambda=' num2str(lambda)]);
axis equal;
set(gcf, 'pos', [0 0 600 800]);
subplot(1,2,2); hold on; imagesc(connections);


