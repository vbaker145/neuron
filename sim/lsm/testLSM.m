clear; clf

%Create Poisson spike trains
duration = 0.5;
rate = 20;
dt = 0.001;
t = 0:dt:duration-dt;
st1 = poissonSpikeTrain(duration, rate, dt);
st2 = poissonSpikeTrain(duration, rate, dt);
figure(10); plot(t,st1)
hold on; plot(t,st2,'r')

theta = 0.75;
tau = 0.01;
vres = 0.2;
v = vres;
RIext = 0.3;
vt = zeros(1,length(t));
for jj=1:length(t)
    s = v>theta;
    v = s*vres+(1-s)*(v-dt/tau*(v-vres-st1(jj)));
    vt(jj) = v;
end
figure(20); plot(vt)
hold on; plot(st1, 'r')
