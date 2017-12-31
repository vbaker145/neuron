function [a,b,c,d, S, delays] = makeColumn(width, height, layers, percentExc)

n = width*height*layers;

ne = floor(n*percentExc);
ni = n-ne;

re=rand(ne,1);          ri=rand(ni,1);
a=[0.02*ones(ne,1);     0.02+0.08*ri];
b=[0.2*ones(ne,1);      0.25-0.05*ri];
c=[-50+15*re.^2;        -50*ones(ni,1)];
d=[8-6*re.^2;           2*ones(ni,1)];
S=[0.5*rand(ne+ni,ne),  -rand(ne+ni,ni)];


Dmax = 12;
delays=floor( rand(ne+ni)*Dmax ); %Synaptic delays


xv = 0:width-1;
yv = 0:width-1;
zv = 0:layers-1;
[x,y,z] = meshgrid(xv,yv,zv);

x = x(:); y = y(:); z = z(:);

figure; subplot(1,2,1); scatter3(x,y,z,50, 'black','filled')
hold on;

% lambda = 2;
% dmax = 5;
% map = colormap('jet');
% connections = zeros(length(x), length(x));
% for jj=1:length(x)
%     for kk=1:length(x)
%         dis = sqrt((x(jj)-x(kk)).^2+(y(jj)-y(kk))^2+(z(jj)-z(kk))^2);
%         if dis > 0
%             if rand() < exp(-(dis/lambda)^2)
%                 connections(jj,kk) = 1;
%                 didx = dis/dmax;
%                 didx = min(didx,1);
%                 cm = map(floor(didx*size(map,1)),:);  
%                 line([x(jj) x(kk)],[y(jj) y(kk)], [z(jj) z(kk)], 'Color',cm, 'LineWidth', 2*didx);
%             end
%         end
%     end
% end
% title(['Connections, lambda=' num2str(lambda)]);
% axis equal;
% set(gcf, 'pos', [0 0 600 800]);
% subplot(1,2,2); hold on; imagesc(connections);

end

