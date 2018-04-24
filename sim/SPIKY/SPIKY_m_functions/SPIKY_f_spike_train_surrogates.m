% This function generates various kinds of spike train surrogates (which differ in the
% selection of properties that are maintained). Currently the properties maintained 
% are either (1) the individual spike numbers, or (2) the individual interspike interval
% distribution (in addition) or (3) the pooled spike train or (4) the peri-stimulus time histogram (PSTH).

function surro_spikes=SPIKY_f_spike_train_surrogates(spikes,para)

num_trains=length(spikes);
num_spikes=cellfun('length',spikes);
surro_spikes=cell(1,num_trains);
if para.choice==1 % maintain number of spikes for each spike train constant
   for trac=1:num_trains
       surro_spikes{trac}=sort(para.tmin+rand(1,num_spikes(trac))*(para.tmax-para.tmin));
       surro_spikes{trac}=unique(round(surro_spikes{trac}/para.dts)*para.dts);
   end
elseif para.choice==2 % maintain interspike interval distribution for each spike train constant
   for trac=1:num_trains
       isi=diff([para.tmin spikes{trac} para.tmax]);
       surro_spikes{trac}=cumsum(isi(randperm(length(isi))));
       surro_spikes{trac}=unique(round(surro_spikes{trac}(1:end-1)/para.dts)*para.dts);
   end
elseif para.choice==3 % maintain pooled spike train
   all_spikes=[spikes{:}];
   num_all_spikes=length(all_spikes);
   ori_labels=zeros(1,num_all_spikes);
   sc=0;
   for trac=1:num_trains
       ori_labels(sc+(1:num_spikes(trac)))=trac;
       sc=sc+num_spikes(trac);
   end
   surro_labels=ori_labels(randperm(num_all_spikes));
   for trac=1:num_trains
       surro_spikes{trac}=all_spikes(surro_labels==trac);
   end
elseif para.choice==4 % maintain PSTH
    cdf=sort([spikes{:}]);
    cdf=[cdf; 1/length(cdf)*(1:length(cdf))];
    for trac=1:num_trains
        surro_spikes{trac}=interp1(cdf(2,:),cdf(1,:),sort(rand(1,num_spikes(trac))));   % notice the difference rand -> uniform
    end
end