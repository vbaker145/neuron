function [waveTimes wavePositions waveLabels] = findWaves(firings, dt, crossSection)
%Find propagating waves in a column
% firings - firings times by time step/neuron index

waveTimes = [];
wavePositions = [];
waveLabels = {};

winSz = .010;
winStep = .005;
bridge = 5;
minClusPts = 3;

%Get firing matrix in terms of time and layer #
f = firings;
f(:,1) = f(:,1) * dt;
f(:,2) = floor( f(:,2) / crossSection );
%figure(10); plot(f(:,1), f(:,2), 'x');

%Windowed clustering, remove background firing
steps = floor((max(f(:,1))-winSz)/winStep);
idx = 1;
jj=0;
while jj < max(f(:,1))
    fsort = sort(f( find((jj+winSz)>f(:,1) & f(:,1)>jj), 2));
    kk=1;
    while kk<length(fsort)-1
        c = fsort(kk);
        clusPts = fsort(find(fsort-c>0 & fsort-c<bridge));
        if length(clusPts) > minClusPts
           waveTimes(idx) = jj;
           wavePositions(idx) = mean(clusPts);
           numFirings(idx) = length(clusPts);
           idx = idx+1;
           kk = kk+length(clusPts);
        else
            kk = kk+1;
        end
    end
    jj = jj+winStep;
end

%Plane sweep to label waves
pts = [waveTimes' wavePositions'];
idx = zeros(size(waveTimes'));
waveIdx = 1;

for jj = 1:length(waveTimes)
   testPt = pts(jj,:);
   if idx(jj) == 0
      idx(jj) = waveIdx;
      waveIdx = waveIdx + 1;
   end
   pdiff = pts(jj+1:end,:)-testPt;
   cidx = find(pdiff(:,1)<4*winSz & abs(pdiff(:,2)) < 4*bridge);
   idx(jj+cidx) = idx(jj);
end

%figure; scatter(pts(:,1), pts(:,2), 50, idx); colorbar;
if waveIdx == 1
    return
end

maxidx = sortrows(tabulate(idx),2);
maxidx = maxidx(find(maxidx(:,2)>5));

%figure(10); hold on;

for jj=1:length(maxidx)
    cidx = find(idx==maxidx(jj));
    %scatter(pts(cidx,1), pts(cidx,2), 50, idx(cidx),'filled'); colorbar;
    waveLabels{jj} = cidx;
end

end

