
function results=SPIKY_Synfire_f_distances(spikes,d_para)

m_para.all_measures_str={'C';'D'}; % 1:SPIKE-Sync,2:SPIKE-Order
m_para.all_measures_string={'SPIKE_synchro';'SPIKE_order'};

d_para.edge_correction=1;
d_para.profile_mode=3;
f_para=d_para;
if isfield(d_para,'all_train_group_sizes') && length(d_para.all_train_group_sizes)>1
    f_para.num_all_train_groups=length(d_para.all_train_group_sizes);
    cum_group=[0 cumsum(f_para.all_train_group_sizes)];
    f_para.group_vect=zeros(1,f_para.num_trains);
    for gc=1:f_para.num_all_train_groups
        f_para.group_vect(cum_group(gc)+(1:f_para.all_train_group_sizes(gc)))=gc;
    end
    f_para.select_trains=1:f_para.num_trains;
    f_para.select_group_vect=f_para.group_vect(f_para.select_trains);
    f_para.num_select_group_trains=d_para.all_train_group_sizes;
    f_para.num_select_train_groups=length(f_para.num_select_group_trains);
    f_para.select_train_groups=1:f_para.num_select_train_groups;
    f_para.group_matrices=1;
    f_para.dendrograms=1;
else
    d_para.profile_mode=1;
    f_para.num_select_group_trains=1;
    f_para.num_select_train_groups=1;
    f_para.group_matrices=0;
    f_para.dendrograms=0;
end

m_para.spike_sync_pili=1;
m_para.spike_order_pili=2;


uspikes=cell(1,d_para.num_trains);
for trac=1:d_para.num_trains
    uspikes{trac}=spikes{trac}(spikes{trac}>=d_para.tmin & spikes{trac}<=d_para.tmax);
    uspikes{trac}=unique([d_para.tmin uspikes{trac} d_para.tmax]);
end
num_uspikes=cellfun('length',uspikes);

tmin_spikes=find(cellfun(@(v) v(1), spikes(cellfun('length',spikes)>0))==d_para.tmin);
tmax_spikes=find(cellfun(@(v) v(end), spikes(cellfun('length',spikes)>0))==d_para.tmax);
m_res.num_tmin_spikes=length(tmin_spikes);
m_res.num_tmax_spikes=length(tmax_spikes);

dummy=[0 num_uspikes];
all_indy=zeros(1,sum(num_uspikes));
for trac=1:d_para.num_trains
    all_indy(sum(dummy(1:trac))+(1:num_uspikes(trac)))=trac*ones(1,num_uspikes(trac));
end
[all_spikes,indy]=sort([uspikes{:}]);
num_all_spikes=length(all_spikes);

all_trains=all_indy(indy);
all_trains(setdiff(1:d_para.num_trains,tmin_spikes))=0;
all_trains(end-d_para.num_trains+setdiff(1:d_para.num_trains,tmax_spikes))=0;

if m_res.num_tmin_spikes==0 && m_res.num_tmax_spikes==0
    all_indy=d_para.num_trains:num_all_spikes-d_para.num_trains+1;
elseif m_res.num_tmin_spikes==0
    all_indy=[d_para.num_trains:num_all_spikes-d_para.num_trains num_all_spikes-d_para.num_trains+tmax_spikes];
elseif m_res.num_tmax_spikes==0
    all_indy=[tmin_spikes d_para.num_trains+1:num_all_spikes-d_para.num_trains+1];
else
    all_indy=[tmin_spikes d_para.num_trains+1:num_all_spikes-d_para.num_trains num_all_spikes-d_para.num_trains+tmax_spikes];
end

all_spikes=all_spikes(all_indy);
all_trains=all_trains(all_indy);

m_res.all_isi=diff(all_spikes);
m_res.num_all_isi=length(all_spikes)-1;
m_res.isi=m_res.all_isi(m_res.all_isi>0);
m_res.num_isi=length(m_res.isi);
m_res.cum_isi=unique(all_spikes);
clear all_indy indy % all_spikes

% We define the ISI as going from right after the last spike to the
% exact time of the next spike. So the previous spike is not part of the ISI
% while the following is. So when you are on a spike this is the
% following spike and the one before is the previous spike.

d_para.num_pairs=d_para.num_trains*(d_para.num_trains-1)/2;

r_para.num_runs=1;
r_para.run_pico_lengths=m_res.num_isi;
r_para.run_pico_starts=1;
r_para.run_pico_ends=m_res.num_isi;

r_para.run_pili_lengths=m_res.num_all_isi+1;
r_para.run_pili_starts=1;
r_para.run_pili_ends=r_para.run_pili_lengths;

empties=find(m_res.all_isi==0);
ivs=cell(1,d_para.num_trains);
ive=cell(1,d_para.num_trains);
for trac=1:d_para.num_trains
    dummy1=[1 max([m_res.num_tmin_spikes 1])+find(all_trains(max([m_res.num_tmin_spikes 1])+1:end-max([m_res.num_tmax_spikes 1]))==trac)];
    dummy2=[dummy1(2:length(dummy1))-1 m_res.num_all_isi-m_res.num_tmax_spikes+1];
    len=dummy2-dummy1+1-histc(empties,dummy1);
    ive{trac}=cumsum(len);
    ivs{trac}=[1 ive{trac}(1:end-1)+1];
end
clear empties % all_trains

ave_bi_vect=zeros(2,d_para.num_pairs);

run_ivs=cell(1,d_para.num_trains);
run_ive=cell(1,d_para.num_trains);
for ruc=1 %:r_para.num_runs   % ruc=r_para.num_runs:-1:1
    firsts=zeros(1,d_para.num_trains);
    lasts=zeros(1,d_para.num_trains);
    for trac=1:d_para.num_trains
        firsts(trac)=find(uspikes{trac}(1:num_uspikes(trac))<=m_res.cum_isi(r_para.run_pico_starts(ruc)),1,'last');
        lasts(trac)=find(uspikes{trac}(1:num_uspikes(trac))<m_res.cum_isi(r_para.run_pico_ends(ruc)+1),1,'last');
        if lasts(trac)==num_uspikes(trac)
            %[uspikes{trac}(num_uspikes(trac)) m_res.cum_isi(r_para.run_pico_ends(ruc)+1) m_res.cum_isi(r_para.run_pico_ends(ruc)+1)-uspikes{trac}(num_uspikes(trac))]
            lasts(trac)=num_uspikes(trac)-1;
        end
        run_ivs{trac}=ivs{trac}(firsts(trac):lasts(trac))-r_para.run_pico_starts(ruc)+1;
        run_ive{trac}=ive{trac}(firsts(trac):lasts(trac))-r_para.run_pico_starts(ruc)+1;
        run_ivs{trac}(run_ivs{trac}<1)=1;
        run_ive{trac}(run_ive{trac}>r_para.run_pico_lengths(ruc))=r_para.run_pico_lengths(ruc);
    end
    run_num_ints=lasts-firsts+1;
    
    run_uspikes=cell(1,d_para.num_trains);
    for trac=1:d_para.num_trains
        run_uspikes{trac}=uspikes{trac}(int32(firsts(trac)):int32(lasts(trac)+1));
    end
    run_num_uspikes=run_num_ints+1;
    if exist(['SPIKY_udists_MEX777.',mexext],'file')
        run_udists=SPIKY_udists_MEX(int32(d_para.num_trains),int32(run_num_uspikes),run_uspikes);
    else
        run_udists=cell(d_para.num_trains);
        for trac1=1:d_para.num_trains
            for trac2=setdiff(1:d_para.num_trains,trac1)
                run_udists{trac1,trac2}=zeros(1,run_num_uspikes(trac1));
                for spc=1:run_num_uspikes(trac1)
                    run_udists{trac1,trac2}(spc)=min(abs(run_uspikes{trac1}(spc)-run_uspikes{trac2}));
                end
            end
        end
    end
    for trac=1:d_para.num_trains
        for trac2=1:d_para.num_trains
            if (trac~=trac2)
                run_udists{trac,trac2}(1)=min(abs(uspikes{trac}(firsts(trac))-uspikes{trac2}));
                run_udists{trac,trac2}(end)=min(abs(uspikes{trac}(lasts(trac)+1)-uspikes{trac2}));
            end
        end
    end
    
    m_res.pili_measures_mat=zeros(2,d_para.num_pairs,r_para.run_pili_lengths(ruc));
    
    if ruc==1
        num_spikes=cellfun('length',spikes);
        all_cum_events=zeros(d_para.num_trains,m_res.num_all_isi+1);
        for trac=1:d_para.num_trains
            all_cum_events(trac,:)=cumsum(all_trains(1:m_res.num_all_isi+1)==trac);
        end
        m_res.all_pos_spikes=diff([zeros(d_para.num_trains,1) all_cum_events],[],2);    % position of events (position of following ISI)
        clear all_cum_events
        num_pair_all_spikes=zeros(1,d_para.num_pairs);
        spike_synchro=cell(1,d_para.num_pairs);
        spike_delay=cell(1,d_para.num_pairs);
    end
    norm_spike_synchro=zeros(d_para.num_pairs,r_para.run_pili_lengths(ruc));
    norm_spike_delay=zeros(d_para.num_pairs,r_para.run_pili_lengths(ruc));
    
    pac=0;
    es_isis=cell(1,2);
    for trac1=1:d_para.num_trains-1
        if ruc==1
            es_isis{1}=[inf diff(spikes{trac1}) inf];
        end
        for trac2=trac1+1:d_para.num_trains
            pac=pac+1;
            tracs=[trac1 trac2];
            if ruc==1
                pair_all_spikes=sort([spikes{[trac1 trac2]}]);    %  all_spikes(ismember(all_trains,[0 trac1 trac2]))
                num_pair_all_spikes(pac)=length(pair_all_spikes);
                if exist(['SPIKY_SPIKEsynchro_MEX2.',mexext],'file')  % #################################### check spikes on edges
                    if pac==1
                        spike_synchro=SPIKY_SPIKEsynchro_MEX(int32(d_para.num_trains),int32(d_para.num_spikes),spikes);
                    end
                else
                    spike_synchro{pac}=zeros(1,num_pair_all_spikes(pac));
                    spike_delay{pac}=zeros(1,num_pair_all_spikes(pac));
                    es_isis{2}=[inf diff(spikes{trac2}) inf];
                    doubles=intersect(spikes{trac1},spikes{trac2});
                    for dc=1:length(doubles)
                        spike_synchro{pac}(pair_all_spikes==doubles(dc))=1;
                    end
                    [dummy,train_min_spikes]=min(num_uspikes(tracs));
                    train1=tracs(train_min_spikes);
                    train2=tracs(3-train_min_spikes);
                    first_candy=1;
                    for sc=1:num_spikes(train1)
                        if ~ismember(spikes{train1}(sc),spikes{train2})
                            pair_spike1=spikes{train1}(sc);
                            tau1=min(es_isis{train_min_spikes}(sc:sc+1))/2;
                            [dummy,indy]=min(abs(spikes{train2}(first_candy:end)-pair_spike1));
                            first_candy=first_candy-1+indy;
                            pair_spike2=spikes{train2}(first_candy);
                            tau2=min(es_isis{3-train_min_spikes}(first_candy:first_candy+1))/2;
                            min_tau=min([tau1 tau2]);
                            if isinf(min_tau)
                                min_tau=(d_para.tmax-d_para.tmin)/2;
                            end
                            %[pair_spike1 tau1 pair_spike2 tau2 min_tau]
                            if abs(pair_spike2-pair_spike1)<min_tau && abs(pair_spike2-pair_spike1)<d_para.max_tau                           % < , not <= !!!!!!
                                spike_synchro{pac}(logical(pair_spike1==pair_all_spikes))=1;
                                spike_synchro{pac}(logical(pair_spike2==pair_all_spikes))=1;
                                if pair_spike1<pair_spike2 && train1<train2 % first spike train spikes first
                                    spike_delay{pac}(logical(pair_spike1==pair_all_spikes))=1; % 1 l    positive: 1,2; 1:leading spike
                                    spike_delay{pac}(logical(pair_spike2==pair_all_spikes))=2; % 2 f    positive: 1,2; 2:following spike
                                elseif pair_spike2<pair_spike1 && train2<train1 % first spike train spikes first
                                    spike_delay{pac}(logical(pair_spike2==pair_all_spikes))=1; % 1 l    positive: 1,2; 1:leading spike
                                    spike_delay{pac}(logical(pair_spike1==pair_all_spikes))=2; % 2 f    positive: 1,2; 2:following spike
                                elseif pair_spike1>pair_spike2 && train1<train2 % second spike train spikes first
                                    spike_delay{pac}(logical(pair_spike2==pair_all_spikes))=-1;  % -1 l  negative:2,1; 1:leading spike
                                    spike_delay{pac}(logical(pair_spike1==pair_all_spikes))=-2; % -2 f   negative:2,1; 2:following spike
                                elseif pair_spike2>pair_spike1 && train2<train1 % second spike train spikes first
                                    spike_delay{pac}(logical(pair_spike1==pair_all_spikes))=-1;  % -1 l  negative:2,1; 1:leading spike
                                    spike_delay{pac}(logical(pair_spike2==pair_all_spikes))=-2; % -2 f   negative:2,1; 2:following spike
                                end
                            end
                        end
                    end
                end
            end
            run_all_pos_spikes=m_res.all_pos_spikes([trac1 trac2],r_para.run_pili_starts(ruc):r_para.run_pili_ends(ruc));
            norm_spike_synchro(pac,any(run_all_pos_spikes))=spike_synchro{pac};
            norm_spike_delay(pac,any(run_all_pos_spikes))=spike_delay{pac};
        end
    end
    if ruc==1 && min(cellfun(@(v) v(1), spikes(cellfun('length',spikes)>0)))>d_para.tmin
        norm_spike_synchro(:,1)=norm_spike_synchro(:,2);            % edges, alternative: don't assign and plot them
        norm_spike_delay(:,1)=norm_spike_delay(:,2);                % edges, alternative: don't assign and plot them
    end
    if ruc==r_para.num_runs && max(cellfun(@(v) v(end), spikes(cellfun('length',spikes)>0)))<d_para.tmax
        norm_spike_synchro(:,end)=norm_spike_synchro(:,end-1);
        norm_spike_delay(:,end)=norm_spike_delay(:,end-1);
    end
    m_res.pili_measures_mat(1,1:d_para.num_pairs,1:r_para.run_pili_lengths(ruc))=norm_spike_synchro;
    m_res.pili_measures_mat(2,1:d_para.num_pairs,1:r_para.run_pili_lengths(ruc))=norm_spike_delay;
    spike_sync_profile=shiftdim(permute(sum(m_res.pili_measures_mat(1,:,:),2),[2 1 3]),1);   % sum over pairs
    spike_delay_profile_d=shiftdim(permute(sum(abs(m_res.pili_measures_mat(2,:,:))...  % second (D): spike-based (does this spike lead?)
        -3*(abs(m_res.pili_measures_mat(2,:,:))==2),2),[2 1 3]),1);
    
    spike_delay_profile_e=shiftdim(permute(sum(sign(m_res.pili_measures_mat(2,:,:)),2),[2 1 3]),1);  % first (A): spike-train-based (does the first spike train lead?)
    
    if m_res.num_tmin_spikes>0 && m_res.num_tmax_spikes>0                                                % pairwise values
        ave_bi_vect=sum(sign(m_res.pili_measures_mat(:,:,:)),3);
    elseif m_res.num_tmin_spikes>0
        ave_bi_vect=sum(sign(m_res.pili_measures_mat(:,:,1:end-1)),3);
    elseif m_res.num_tmax_spikes>0
        ave_bi_vect=sum(sign(m_res.pili_measures_mat(:,:,2:end)),3);
    else
        ave_bi_vect=sum(sign(m_res.pili_measures_mat(:,:,2:end-1)),3);
    end
    
end
r_para.ruc=ruc;
clear uspikes

all_distances=mean(ave_bi_vect,2)';
if sum(num_pair_all_spikes)>0
    all_distances=sum(ave_bi_vect,2)/sum(num_pair_all_spikes);   % not simple average !!!
else
    all_distances=[1 1];
end
ave_bi_vect_cum=ave_bi_vect/2;     % why /2 ?????? --> absolute values
ave_bi_vect=ave_bi_vect./repmat(num_pair_all_spikes,2,1);
mat_indy=nchoosek(1:d_para.num_trains,2);

results.spikes=spikes;
for mac=1:2
    eval(['results.',char(m_para.all_measures_string(mac)),...
        '.name=''',char(m_para.all_measures_string(mac)),''';'])
    eval(['results.',char(m_para.all_measures_string(mac)),'.overall=all_distances(mac);'])
    if mac==m_para.spike_sync_pili
        eval(['results.',char(m_para.all_measures_string(mac)),'.matrix=ones(d_para.num_trains,d_para.num_trains);'])
    else
        eval(['results.',char(m_para.all_measures_string(mac)),'.matrix=zeros(d_para.num_trains,d_para.num_trains);'])
    end
    eval(['results.',char(m_para.all_measures_string(mac)),...
        '.matrix(sub2ind([d_para.num_trains d_para.num_trains],mat_indy(:,1),mat_indy(:,2)))=ave_bi_vect(mac,:);'])
    if mac==m_para.spike_order_pili
        eval(['results.',char(m_para.all_measures_string(mac)),'.matrix_cum=zeros(d_para.num_trains,d_para.num_trains);'])
        eval(['results.',char(m_para.all_measures_string(mac)),...
            '.matrix_cum(sub2ind([d_para.num_trains d_para.num_trains],mat_indy(:,1),mat_indy(:,2)))=ave_bi_vect_cum(mac,:);'])
        eval(['results.',char(m_para.all_measures_string(mac)),...
            '.matrix_cum(sub2ind([d_para.num_trains d_para.num_trains],mat_indy(:,2),mat_indy(:,1)))=-ave_bi_vect_cum(mac,:);'])   % makes it asymmetric
        eval(['results.',char(m_para.all_measures_string(mac)),...
            '.matrix(sub2ind([d_para.num_trains d_para.num_trains],mat_indy(:,2),mat_indy(:,1)))=-ave_bi_vect(mac,:);'])   % makes it asymmetric
        eval(['results.',char(m_para.all_measures_string(mac)),'.cum=sum(ave_bi_vect_cum(m_para.spike_sync_pili,:));'])
        eval(['results.',char(m_para.all_measures_string(mac)),'.norm=sum(num_pair_all_spikes)/2;'])
        
        eval(['results.',char(m_para.all_measures_string(mac)),'.spike_number_maximum=2*sum(sort(num_spikes).*(d_para.num_trains-1:-1:0))/(sum(num_spikes)*(d_para.num_trains-1));'])
        eval(['results.',char(m_para.all_measures_string(mac)),'.pairwise_maximum=sum(sum(abs(results.SPIKE_order.matrix_cum)))/(sum(num_spikes)*(d_para.num_trains-1));'])
        eval(['results.',char(m_para.all_measures_string(mac)),'.spike_synchro_all_pairs=norm_spike_synchro(:,2:end-1);'])
        eval(['results.',char(m_para.all_measures_string(mac)),'.spike_order_all_pairs=abs(norm_spike_delay(:,2:end-1))-3*(abs(norm_spike_delay(:,2:end-1))==2);'])
        eval(['results.',char(m_para.all_measures_string(mac)),'.spike_train_order_all_pairs=sign(norm_spike_delay(:,2:end-1));'])
    else
        eval(['results.',char(m_para.all_measures_string(mac)),...
            '.matrix(sub2ind([d_para.num_trains d_para.num_trains],mat_indy(:,2),mat_indy(:,1)))=ave_bi_vect(mac,:);'])
    end
    if m_res.num_tmin_spikes>0 && m_res.num_tmax_spikes>0
        eval(['results.',char(m_para.all_measures_string(mac)),'.time=d_para.tmin+[0 cumsum(m_res.all_isi)];'])
        if mac==m_para.spike_sync_pili
            eval(['results.',char(m_para.all_measures_string(mac)),'.profile=spike_sync_profile/(d_para.num_trains-1);'])
        else
            eval(['results.',char(m_para.all_measures_string(mac)),'.spike_train_order_profile=spike_delay_profile_e/(d_para.num_trains-1);'])
            eval(['results.',char(m_para.all_measures_string(mac)),'.spike_order_profile=spike_delay_profile_d/(d_para.num_trains-1);'])
        end
    elseif m_res.num_tmin_spikes>0
        eval(['results.',char(m_para.all_measures_string(mac)),'.time=d_para.tmin+[0 cumsum(m_res.all_isi(1:end-1))];'])
        if mac==m_para.spike_sync_pili
            eval(['results.',char(m_para.all_measures_string(mac)),'.profile=spike_sync_profile(1:end-1)/(d_para.num_trains-1);'])
        else
            eval(['results.',char(m_para.all_measures_string(mac)),'.spike_train_order_profile=spike_delay_profile_e(1:end-1)/(d_para.num_trains-1);'])
            eval(['results.',char(m_para.all_measures_string(mac)),'.spike_order_profile=spike_delay_profile_d(1:end-1)/(d_para.num_trains-1);'])
        end
    elseif m_res.num_tmax_spikes>0
        eval(['results.',char(m_para.all_measures_string(mac)),'.time=d_para.tmin+[cumsum(m_res.all_isi)];'])
        if mac==m_para.spike_sync_pili
            eval(['results.',char(m_para.all_measures_string(mac)),'.profile=spike_sync_profile(2:end)/(d_para.num_trains-1);'])
        else
            eval(['results.',char(m_para.all_measures_string(mac)),'.spike_train_order_profile=spike_delay_profile_e(2:end)/(d_para.num_trains-1);'])
            eval(['results.',char(m_para.all_measures_string(mac)),'.spike_order_profile=spike_delay_profile_d(2:end)/(d_para.num_trains-1);'])
        end
    else
        eval(['results.',char(m_para.all_measures_string(mac)),'.time=d_para.tmin+[cumsum(m_res.all_isi(1:end-1))];'])
        if mac==m_para.spike_sync_pili
            eval(['results.',char(m_para.all_measures_string(mac)),'.profile=spike_sync_profile(2:end-1)/(d_para.num_trains-1);'])
        else
            eval(['results.',char(m_para.all_measures_string(mac)),'.spike_train_order_profile=spike_delay_profile_e(2:end-1)/(d_para.num_trains-1);'])
            eval(['results.',char(m_para.all_measures_string(mac)),'.spike_order_profile=spike_delay_profile_d(2:end-1)/(d_para.num_trains-1);'])
        end
    end
    
end



