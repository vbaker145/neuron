function [st] = poissonSpikeTrain( duration, rate, dt)

nbins = floor(duration/dt);
rdt = rate*dt;
pspike = rand(1,nbins);
st = 1.0*(pspike<rdt);

end

