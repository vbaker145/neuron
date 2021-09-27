function st = impulseStim2D(pos, stimStrength, t, xlim, ylim, zlim)
%Impulse stimulus

dt = t(2)-t(1);

%Stimuluate lower 2x2 section
xidx = find(pos.x>=xlim(1) & pos.x<=xlim(2));
yidx = find(pos.y>=ylim(1) & pos.y<=ylim(2));
zidx = find(pos.z>=zlim(1) & pos.z<=zlim(2));

idx = intersect( intersect(xidx,yidx),zidx );

st = zeros(size(pos.x(:),1), size(t,2));
st(idx, 1:floor(10/dt)) = stimStrength;

end

