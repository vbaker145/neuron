%% Generation of Poisson spike train with refractoriness
 clear; clf;   
 fr_mean=15/1000;      % mean firing rate
%% generating poisson spike train
 lambda=1/fr_mean;              % inverse firing rate
 ns=1000;                       % number of spikes to be generated
 isi1=-lambda.*log(rand(ns,1)); % generation of expo. distr. ISIs
%% Delete spikes that are within refractory period
 is=0;
 for i=1:ns;
     if rand>exp(-isi1(i)^2/32);
         is=is+1;
         isi(is)=isi1(i);
     end
 end
%% Ploting histogram and caclulating cv
 hist(isi,50);          % Plot histogram of 50 bins
 cv=std(isi)/mean(isi)  % coefficient of variation
