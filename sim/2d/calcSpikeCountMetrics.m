function [isi, cv, Nij, cc_d] = calcSpikeCountMetrics(f, sim_t, pos)

xp = pos.x(:); yp = pos.y(:); zp = pos.z(:);
N = length(xp);

twin = 50;
t = 0:max(sim_t);
Nij = zeros(length(t), N);

for jj=1:N
   spikes = find(f(:,2)==jj);
   spikeTimes = sort( f(spikes,1) );
   isi{jj} = diff(spikeTimes);
   cv(jj) = sqrt(var(isi{jj}))/mean(isi{jj});
   for kk=1:length(spikeTimes)
      st = spikeTimes(kk);
      min_t = floor(max(st-twin, 0));
      Nij( (min_t:min_t+twin)+1 , jj) = Nij( (min_t:min_t+twin)+1 , jj) + 1;
   end
end

Nij_mean = mean(Nij);
Nij_var = var(Nij);
CC = zeros(1000);
d = zeros(1000);
for jj=1:1000
    for kk=jj+1:1000
       norm = sqrt(Nij_var(jj)*Nij_var(kk) );
       if norm > 0
           CCtmp =  xcorr(Nij(:,jj)-Nij_mean(jj), Nij(:,kk)-Nij_mean(kk))/norm;
           CC(jj,kk) = max(CCtmp);
           d(jj,kk) = sqrt((xp(jj)-xp(kk))^2+(yp(jj)-yp(kk))^2+(zp(jj)-zp(kk))^2 );
       end
    end
end

cc_d = zeros(100,1);
for bins=1:100
    gidx = find(d>=bins-1 & d<bins);
    cct = CC(gidx);
    cc_d(bins) = mean(cct(cct>0)); 
end

h = figure(20);
set(h, 'Position', [0 100 400 250]);
histogram(cv, 'Normalization', 'probability','FaceColor', 'k')
xlabel('Coefficient of variation')
ylabel('Probability mass')
set(gca, 'FontSize', 12);

h = figure(30);
set(h, 'Position', [600 100 400 250]);
plot(f(:,1), f(:,2), 'k.');
ylim([100 130]);
xlabel('Time (ms)'); ylabel('Neuron #');
set(gca, 'FontSize', 12);

h = figure(40);
set(h, 'Position', [800 100 400 250]);
plot(cc_d, 'k', 'LineWidth', 1);
xlabel('Neuron separation (units)'); ylabel('Mean correlation')

end

