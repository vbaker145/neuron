% This function extracts the best estimate of the sampling interval from 
% the spike dataset itself in case none is provided by the user.

function dt = SPIKY_f_get_dt_gcd(spikes)
if isempty(spikes)
    dt = 1;
    return
end
dt = spikes(1);                     % adapted Euclidean algorithm (gcd) improved for non integers
i = 2;
while i <= length(spikes(:))
    if (spikes(i) ~= 0) 
        dt = aea(dt, spikes(i));
    end
    i = i + 1;
end
end

function gcd = aea(a, b)
if (a < b)
    [a, b] = exchange(a, b);
end
while (b > 1.0e-10)
    residue = floor(a/b);           % problematic floor
    a = a - double(residue)*b;
    [a, b] = exchange(a, b);
end
gcd = a;
end

function [a1, b1] = exchange(a, b)          % use third party, otherwise precision problems
a1 = b;
b1 = a;
end