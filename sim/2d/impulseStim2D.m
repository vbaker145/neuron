function st = impulseStim2D(pos, stimStrength, t)
%Impulse stimulus

dt = t(2)-t(1);

%Stimuluate lower 2x2 section
idx = find(pos.x<3 & pos.y<3);

st = zeros(size(pos.x(:),1), size(t,2));
st(idx, 1:floor(10/dt)) = stimStrength;

end

