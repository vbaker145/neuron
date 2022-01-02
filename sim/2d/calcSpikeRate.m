function [spikeCounts] = calcSpikeRate(f, pos, gridSz, tWin)

xsz = max(pos.x(:));
ysz = max(pos.y(:));

nXbins = ceil(xsz/gridSz);
nYbins = ceil(ysz/gridSz);

tMax = max(f(:,1));
nTbins = ceil(tMax/tWin);

spikeCounts = zeros(nXbins, nYbins, nTbins);

figure(20); 
for tidx = 1:nTbins
   tnow = (tidx-1)*tWin;
   fidx = f(:,1)>=tnow & f(:,1)<(tnow+tWin);
   posIdx = f(find(fidx),2);
   xv = floor( pos.x(posIdx)/gridSz )+1;
   yv = floor( pos.y(posIdx)/gridSz )+1;
   for kk=1:length(xv)
       spikeCounts(xv(kk),yv(kk),tidx) = spikeCounts(xv(kk),yv(kk),tidx)+1;
   end
   if length(xv) > 0
     cspikeCounts(:,:,tidx) = spikeCounts(:,:,tidx)/length(xv);
   end
   
%    if ~isempty(posIdx)
%         plot(pos.x(posIdx), pos.y(posIdx), 'k.');
%         xlim([0 xsz]); ylim([0 ysz]);
%         title(num2str(tidx));
%    end
end

figure(50); imagesc((1:nXbins)*gridSz,(1:nYbins)*gridSz, spikeCounts(:,:,end)'); colormap('gray'); colorbar; set(gca, 'YDir', 'Normal');
xlabel('X'); ylabel('Y'); set(gca,'FontSize',12)
axis equal
end

