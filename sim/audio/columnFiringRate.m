function [ avgFireRate, smoothFire] = columnFiringRate( colStruct, firings,t, tmax )
%Firing rate feature for audio recognition
    avgFireRate = [];
    dt = t(2)-t(1);
    t_ext = 0:dt:tmax-dt;
    nt = floor(length(t_ext)/10);
    smoothFire = zeros(colStruct.nCols,nt);
    for fidx=0:colStruct.nCols-1
        %Find firing events from top of column
        idx = colStruct.csec(firings(:,2))==fidx;
        f = firings(idx,:);
        f = f( find(f(:,2)/colStruct.Nlayer >= colStruct.structure.layers-2),:);
        avgFireRate(fidx+1) = size(f,1);
        
        %Smoothed firing
        [tf,idx] = ismember(t,f(:,1));
        sort(idx);
        idx = find(idx>0);
        s = zeros(1,length(t));
        s(idx) = 1;
        s = decimate(s,10);
        smoothFire(fidx+1, 1:length(s)) = s;
    end
end

