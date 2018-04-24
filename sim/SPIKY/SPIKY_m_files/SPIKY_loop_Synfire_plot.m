function SPIKY_Synfire_plot(spikes,para)

make_surro=1;
num_surros=19;
show_z_scores=1;
event_seps=0;

plotting=127;  % +1:spikes,+2:dissimilarity profile,+4:dissimilarity matrix,+8:sorted spike trains,+16:sorted dissimilarity profile,+32:sorted dissimilarity matrix+64:surro_histo

color_spikes=3;              % +1:first raster plot,+2:second raster plot
patching=1;                  % 0-no,1-yes
fs=12; cols='bkr';
multi_figure=0;
alphabet='abcdefgh';

mark_upper_matrix_half=1;    % Mark upper half matrix
plot_profiles=5;             % +1:synchro_profile_C,+2:order_profile_d,+4:order_profile_e,+8:order_profile_e for events (green points ###)

plots=[mod(plotting,2)>0 mod(plotting,4)>1 mod(plotting,16)>3 mod(plotting,32)>15 mod(plotting,64)>31];
plot_order=[1 2 3 5 4];
plot_pos=SPIKY_f_all_sorted(plot_order(plots));
num_plots=sum(plots);
profs=[mod(plot_profiles,2)>0 mod(plot_profiles,4)>1 mod(plot_profiles,8)>3];
prof_order=[2 3 1]; prof_letter='CDFE'; prof_color='krk';
prof_pos=SPIKY_f_all_sorted(prof_order(profs));
num_profs=sum(plots);

sync_thr=0;
sync_thr2=sync_thr;
para.sync_thr=sync_thr;
para.max_tau=inf;
m_para.all_measures_string={'SPIKE_synchro';'SPIKE_order'};  % order of select_measures
para.select_measures      =[1 1 0 0 0 0 0];  % Select measures (0-calculate,1-do not calculate)
measure_var=m_para.all_measures_string{2};
measure_name=regexprep(measure_var,'_','-');
para.dataset_str=para.comment_string;
para.range=para.tmax-para.tmin;

para.num_trains=length(spikes);
num_spikes=cellfun('length',spikes);
tmin_spikes=find(cellfun(@(v) v(1), spikes(cellfun('length',spikes)>0))==para.tmin);
tmax_spikes=find(cellfun(@(v) v(end), spikes(cellfun('length',spikes)>0))==para.tmax);
m_res.num_tmin_spikes=length(tmin_spikes);
m_res.num_tmax_spikes=length(tmax_spikes);
dummy=[0 num_spikes];
all_indy=zeros(1,sum(num_spikes));
for trc=1:para.num_trains
    all_indy(sum(dummy(1:trc))+(1:num_spikes(trc)))=trc*ones(1,num_spikes(trc));
end
[all_spikes,sp_indy]=sort([spikes{:}]);
num_all_spikes=length(all_spikes);
all_trains=all_indy(sp_indy);

SPIKY_loop_results = SPIKY_Synfire_f_distances(spikes,para);                % ###################

if sync_thr>0
    or_spikes=spikes;
    yes_spikes=cell(1,para.num_trains);
    all_yes=(SPIKY_loop_results.SPIKE_synchro.profile>sync_thr);
    for trc=1:para.num_trains
        trc_yes=all_yes(logical(all_trains==trc));
        yes_spikes{trc}=spikes{trc}(trc_yes);
    end
    spikes=yes_spikes;
    num_spikes=cellfun('length',spikes);
    
    tmin_spikes=find(cellfun(@(v) v(1), spikes(cellfun('length',spikes)>0))==d_para.tmin);
    tmax_spikes=find(cellfun(@(v) v(end), spikes(cellfun('length',spikes)>0))==d_para.tmax);
    m_res.num_tmin_spikes=length(tmin_spikes);
    m_res.num_tmax_spikes=length(tmax_spikes);
    dummy=[0 num_spikes];
    all_indy=zeros(1,sum(num_spikes));
    for trc=1:para.num_trains
        all_indy(sum(dummy(1:trc))+(1:num_spikes(trc)))=trc*ones(1,num_spikes(trc));
    end
    [all_spikes,indy]=sort([spikes{:}]);
    num_all_spikes=length(all_spikes);
    all_trains=all_indy(indy);
    
    sync_thr2=sync_thr;
    sync_thr=0;
    
    SPIKY_loop_results = SPIKY_Synfire_f_distances(spikes,para);           % ###################
end

% results.SPIKE_order.spike_train_order_all_pairs
% results.SPIKE_order.spike_order_all_pairs
% results.SPIKE_order.matrix_cum
% results.SPIKE_order.overall
% results.spikes

results=SPIKY_loop_results;
ori_spikes=spikes;
ori_results=results;
SPIKY_loop_results.ori_spikes=ori_spikes;
matr=ori_results.SPIKE_order.matrix_cum;

if exist(['SPIKE_order_sim_ann_MEX.',mexext],'file')
    [st_indy_simann,A,total_iter]=SPIKE_order_sim_ann_MEX(matr);           % ###################
else
    [st_indy_simann,A,total_iter]=SPIKY_f_simann_sort(matr);
end


st_order=sum(ori_results.SPIKE_order.matrix_cum,2);
st_indy=st_indy_simann';

run=1;   % [unsorted sorted];
spikes=ori_spikes;
results=ori_results;


if num_plots>0
    SPIKY_loop_Synfire_subplot                                                  % ###################
end

run=2;   % [unsorted sorted]; % before or after sorting, each plot typically consists of two runs

sorted_spikes=spikes(st_indy);
spikes=sorted_spikes;
sorted_SPIKY_loop_results = SPIKY_Synfire_f_distances(spikes,para);        % ###################
sorted_SPIKY_loop_results.SPIKE_order.opt_perm=st_indy;
results=sorted_SPIKY_loop_results;
sorted_num_spikes=cellfun('length',sorted_SPIKY_loop_results.spikes);

sorted_st_order=st_order(st_indy);
matr=results.SPIKE_order.matrix_cum;

if num_plots>0
    SPIKY_loop_Synfire_subplot                                                  % ###################
    if sync_thr>0
        sorted_SPIKY_loop_results.SPIKE_synchro.filt_profile=c_prof;
        sorted_SPIKY_loop_results.SPIKE_order.filt_profile_a=e_prof;
    end
end

SPIKY_Synfire_results.unsorted=SPIKY_loop_results;
SPIKY_Synfire_results.sorted=sorted_SPIKY_loop_results;
SPIKY_Synfire_results.unsorted=rmfield(SPIKY_Synfire_results.unsorted,'ori_spikes');
results=orderfields(SPIKY_Synfire_results);
assignin('base','SPIKY_Synfire_results',results);


