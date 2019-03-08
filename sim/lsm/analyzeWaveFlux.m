function [ dummy ] = analyzeWaveFlux( wt, wp, labels, firings )
%Analyze properties of traveling waves
% wt - vector of firing cluster times
% wp - vector of firing cluster z value
% labels - cell array, each element is a set of indices defining one
% traveling wave
% firings - Raw firing events

nWavePts = sum(cellfun(@length,labels));
waveFraction = nWavePts/length(wp);
sizes = cellfun(@length,labels);


%Find slope
vidfile = VideoWriter('wave_flux.avi');
vidfile.FrameRate = 10;
open(vidfile);
fg = figure(10); clf;
fg.Position = [100 100 2048 600];
subplot(1,2,1); plot(firings(:,1),firings(:,2),'k.'); hold on;
l1 = line([0,0],[0, max(firings(:,2))],'Color','r' );
fidx = 1;
frames = [];
for tt = 0:0.005:max(firings(:,1))
       subplot(1,2,1); 
       delete(l1);
       l1 = line([tt, tt],[0, max(firings(:,2))],'Color','r' );
       fwin = firings(firings(:,1)>tt & firings(:,1)<(tt+0.02),:);
       subplot(1,2,2);
       hob = histogram(fwin(:,2),0:5:200); title(tt);
       frames(:, fidx) = hob.Values; fidx = fidx+1;
       ax = axis; ax(4) = 30; axis(ax);
       drawnow
       writeVideo(vidfile, getframe(gcf));
end
close(vidfile);
    
figure; imagesc((1:size(frames,2)).*0.005,0:5:200 ,frames); 
set(gca, 'YDir', 'Normal'); colorbar
xlabel('Time (ms)'); ylabel('Z position')
title('Firing density')

slopes = [];
for jj=1:length(labels)
    wl = labels{jj}; 
    
    wtj = wt(wl); wpj = wp(wl);
    tidx = [min(wtj), max(wtj)];
    pidx = [min(wpj), max(wpj)];
    
    idx =  (firings(:,1)>tidx(1)) & (firings(:,1)<tidx(2)) & (firings(:,2)>pidx(1)) & (firings(:,2)<pidx(2));
    f = firings(idx,:);
    
    %figure; plot(wtj, wpj, 'ko');
    %hold on; plot(f(:,1), f(:,2), 'k.');
end


end

