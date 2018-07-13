%Single Izhikevich neuron
clear; close all;

dt = .1;
t = 0;
a = 0.02;
%b = 0.2;
b = 0.2;
c = -65;
d = 6;

v = -65;
u = 0.2*v;

nsteps = 4000;
stim = zeros(1,nsteps);
stimDur = floor(10/dt);
stim(100:end) = 20;
vall = [];
uall = [];
for step=1:nsteps            % simulation of 1000 ms
  if v>30
    v = c;
    u =u+d;
  end
  I = stim(step);
  v=v+dt*0.5*(0.04*v.^2+5*v+140-u+I); % step 0.5 ms
  v=v+dt*0.5*(0.04*v.^2+5*v+140-u+I); % for numerical
  u=u+dt*a.*(b.*v-u);                 % stability
  
  vall = [vall min(v,30)];
  uall = [uall u];
end

figure(10); plot(vall);
hold on; plot(stim,'r')

figure(11); plot(vall, uall,'x-')

vval = -80:0;
uval = b.*vval;
[vg ug] = meshgrid(vval,uval);

vout = zeros(size(vg,1), size(vg,2), 10);
uout = zeros(size(ug,1), size(ug,2), 10);

dt = 1;
for jj=1:10
    vout(:,:,jj) = vg;
    uout(:,:,jj) = ug;
    
    vout(vout>30) = -65;
    uout(vout>30) = uout(vout>30) - d;
    vg=vg+dt*0.5*(0.04*vg.^2+5*vg+140-ug); % step 0.5 ms
    vg=vg+dt*0.5*(0.04*vg.^2+5*vg+140-ug); % for numerical
    ug=ug+dt*a.*(b.*vg-ug);                 % stabilit
end
