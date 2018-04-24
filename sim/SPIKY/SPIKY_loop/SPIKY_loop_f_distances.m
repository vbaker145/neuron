% 'SPIKY_loop' is complementary to the graphical user interface 'SPIKY'.
% Both programs can be used to calculate time-resolved spike train distances (ISI and SPIKE) between two (or more) spike trains.
% However, whereas SPIKY was mainly designed to facilitate the detailed analysis of one dataset,
% 'SPIKY_loop' is meant to be used in order to compare the results for many different datasets (e.g. in some kind of loop).
% The source codes use a minimum number of input and output variables (described below).
% This is the function (called by SPIKY_loop.m) in which the various spike train dissimilarities are calculated
% (using the MEX-files described below).
% Copyright Thomas Kreuz, Nebojsa Bozanic; March 2014
%
% More information on the program and the spike train distances can be found under
% "http://www.fi.isc.cnr.it/users/thomas.kreuz/Source-Code/SPIKY.html" and/or in
%
% Kreuz T, Chicharro D, Houghton C, Andrzejak RG, Mormann F: Monitoring spike train synchrony. J Neurophysiol 109, 1457 (2013)
% Kreuz T: SPIKE-distance. Scholarpedia 7(12):30652 (2012).
% Kreuz T: Measures of spike train synchrony. Scholarpedia, 6(10):11934 (2011).
% Kreuz T, Chicharro D, Greschner M, Andrzejak RG: Time-resolved and time-scale adaptive measures of spike train synchrony. J Neurosci Methods 195, 92 (2011).
% Kreuz T, Chicharro D, Andrzejak RG, Haas JS, Abarbanel HDI: Measuring multiple spike train synchrony. J Neurosci Methods 183, 287 (2009).
% Kreuz T, Haas JS, Morelli A, Abarbanel HDI, Politi A: Measuring spike train synchrony. J Neurosci Methods 165, 151 (2007)
%
% For questions and comments please contact us at "thomaskreuz (at) cnr.it".
%
%
% Input:
% ======
%
% Cell 'spikes' with two or more spike trains (each cell array contains the spike times of one spike train)
%
% Parameter structure 'para' that describe the data (see below)
%
% tmin:            Beginning of recording
% tmax:            End of recording
% dts:             Sampling interval, precision of spike times
%                  [!!! Please take care that this value is not larger than the actual sampling size,
%                   otherwise two spikes can occur at the same time instant and this can lead to problems in the algorithm !!!]
% select_measures: Vector with measure selection (for order see below)
%
%
% Output (Structure 'results'):
% =============================
%
%    results.<Measure>.name:    Name of selected measures (helps to identify the order within all other variables)
%    results.<Measure>.overall: Level of dissimilarity over all spike trains and the whole interval
%                               just one value, obtained by averaging over both spike trains and time
%    results.<Measure>.matrix:  Pairwise distance matrices, obtained by averaging over time
%    results.<Measure>.time:    Time-values of overall dissimilarity profile
%    results.<Measure>.profile: Overall dissimilarity profile obtained by averaging over spike train pairs
%
% Note: For the ISI-distance the function 'SPIKY_f_pico' can be used to obtain the average value as well as
% x- and y-vectors for plotting:
%
% [overall_dissimilarity,plot_x_values,plot_y_values] = SPIKY_f_pico(SPIKY_loop_results.<Measure>.time,SPIKY_loop_results.<Measure>.profile,para.tmin);
%


function results=SPIKY_loop_f_distances(spikes,d_para)

m_para.all_measures_str={'I';'S';'S_r';'S_f';'C';'D';'PSTH'}; % 1:ISI,2:SPIKE,3:realtimeSPIKE,4:forwardSPIKE,5:SPIKE-Sync,6:SPIKE-Order,7:PSTH
m_para.all_measures_string={'ISI';'SPIKE';'SPIKE_realtime';'SPIKE_forward';'SPIKE_synchro';'SPIKE_order';'PSTH'};

f_para=d_para;
f_para.select_measures=double(f_para.select_measures~=0);
f_para.select_measures(f_para.select_measures>0)=cumsum(f_para.select_measures(f_para.select_measures>0));
f_para.edge_correction=1;
f_para.psth_num_bins=100;
f_para.psth_window=3;
f_para.profile_mode=3;
if isfield(d_para,'all_train_group_sizes') && length(d_para.all_train_group_sizes)>1
    %if f_para.profile_mode>1
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
    %end
else
    f_para.profile_mode=1;
    f_para.num_select_group_trains=1;
    f_para.num_select_train_groups=1;
    f_para.group_matrices=0;
    f_para.dendrograms=0;
end

m_para.isi_pico=1;
m_para.spike_pili=2;
m_para.realtime_spike_pili=3;
m_para.forward_spike_pili=4;
m_para.spikesync_disc=5;
m_para.spikeorder_disc=6;
m_para.psth=7;

m_para.num_non_bi_measures=1;

max_memo_init=100000000;      % memory management, should be big enough to hold the basic matrices but small enough to not run out of memory
%max_memo_init=100000;      % memory management, should be big enough to hold the basic matrices but small enough to not run out of memory

m_para.pico_measures=m_para.isi_pico;
m_para.disc_measures=[m_para.spikesync_disc m_para.spikeorder_disc];
m_para.pili_measures=[m_para.spike_pili m_para.realtime_spike_pili m_para.forward_spike_pili];
m_para.realtime_measures=m_para.realtime_spike_pili;
m_para.forward_measures=m_para.forward_spike_pili;
m_para.bi_measures=[m_para.disc_measures m_para.pico_measures m_para.pili_measures];
m_para.cont_bi_measures=[m_para.pico_measures m_para.pili_measures];                            % continuous bivariate measures
m_para.inv_bi_measures=m_para.spikesync_disc;                                                   % inverse bivariate measures
m_para.asym_bi_measures=m_para.spikeorder_disc;                                                 % asymmetric bivariate measures

m_para.num_all_measures=length(f_para.select_measures);
select_measures=intersect(1:m_para.num_all_measures,find(f_para.select_measures));
[~,ms_indy]=sort(f_para.select_measures(select_measures));
m_para.select_measures=select_measures(ms_indy);
m_para.select_bi_measures=m_para.select_measures(ismember(m_para.select_measures,m_para.bi_measures));
m_para.select_cont_bi_measures=m_para.select_measures(ismember(m_para.select_measures,m_para.cont_bi_measures));
m_para.num_sel_measures=length(m_para.select_measures);
m_para.num_sel_bi_measures=length(m_para.select_bi_measures);
m_para.num_sel_cont_bi_measures=length(m_para.select_cont_bi_measures);

m_para.select_pili_measures=intersect(m_para.pili_measures,m_para.select_measures);
m_para.num_pili_measures=length(m_para.select_pili_measures);
m_para.select_pico_measures=intersect(m_para.pico_measures,m_para.select_measures);
m_para.num_pico_measures=length(m_para.select_pico_measures);
m_para.select_disc_measures=intersect(m_para.disc_measures,m_para.select_measures);
m_para.num_disc_measures=length(m_para.select_disc_measures);

m_para.measure_indy=zeros(1,m_para.num_all_measures);
m_para.measure_indy(m_para.pili_measures)=SPIKY_f_all_sorted(f_para.select_measures(m_para.pili_measures));
m_para.measure_indy(m_para.pico_measures)=SPIKY_f_all_sorted(f_para.select_measures(m_para.pico_measures));
m_para.measure_indy(m_para.disc_measures)=SPIKY_f_all_sorted(f_para.select_measures(m_para.disc_measures));



% aaa=f_para.subplot_posi(m_para.num_diff_measures+1:m_para.num_all_measures);
% bbb=aaa+(1:(m_para.num_all_measures-m_para.num_diff_measures))/(m_para.num_all_measures-m_para.num_diff_measures+1);
% bbb(bbb<1)=0;
% m_para.measure_all_indy=[zeros(1,m_para.num_diff_measures) SPIKY_f_all_sorted(bbb)];
%
% ccc=aaa(aaa>0)-min(aaa(aaa>0))+1;
% [dummy,eee]=sort(ccc);
% fff=find(aaa);
% m_res.mat_str=m_para.all_measures_str(m_para.num_diff_measures+fff(eee));

aaa=f_para.select_measures(1:m_para.num_all_measures-m_para.num_non_bi_measures);
bbb=aaa+(1:(m_para.num_all_measures-m_para.num_non_bi_measures))/(m_para.num_all_measures-m_para.num_non_bi_measures+1);
bbb(bbb<1)=0;
m_para.measure_bi_indy=[SPIKY_f_all_sorted(bbb) zeros(1,m_para.num_non_bi_measures)];
%m_res.mat_str=m_para.all_measures_str(m_para.num_diff_measures+m_para.measure_all_indy(m_para.measure_all_indy>0));

% ccc=aaa(aaa>0)-min(aaa(aaa>0))+1;
% [ddd,eee]=sort(ccc);
% fff=find(aaa);
% m_res.bi_mat_str=m_para.all_measures_str(m_para.num_non_bi_measures+fff(eee));


%m_para.measure_bi_indy=zeros(1,m_para.num_all_measures);
%m_para.measure_bi_indy(f_para.select_measures(1:4)>0)=f_para.select_measures(f_para.select_measures(1:4)>0);

m_para.sel_measures_str=m_para.all_measures_str(m_para.select_measures);
m_para.sel_bi_measures_str=m_para.all_measures_str(m_para.select_bi_measures);
m_para.sel_pili_measures_str=m_para.all_measures_str(m_para.select_pili_measures);
m_para.sel_pico_measures_str=m_para.all_measures_str(m_para.select_pico_measures);
m_para.sel_disc_measures_str=m_para.all_measures_str(m_para.select_disc_measures);

m_para.pili_measures_indy=find(ismember(m_para.select_measures,m_para.pili_measures));
m_para.pico_measures_indy=find(ismember(m_para.select_measures,m_para.pico_measures));
m_para.disc_measures_indy=find(ismember(m_para.select_measures,m_para.disc_measures));

m_para.pili_bi_measures_indy=find(ismember(m_para.select_bi_measures,m_para.pili_measures));
m_para.pico_bi_measures_indy=find(ismember(m_para.select_bi_measures,m_para.pico_measures));
m_para.disc_bi_measures_indy=find(ismember(m_para.select_bi_measures,m_para.disc_measures));

if d_para.tmin>=d_para.tmax
    disp('The beginning of the recording can not be later\nthan the end of the recording!');
    return;
end

uspikes=cell(1,d_para.num_trains);
for trac=1:d_para.num_trains
    uspikes{trac}=spikes{trac}(spikes{trac}>=d_para.tmin & spikes{trac}<=d_para.tmax);
    uspikes{trac}=unique([d_para.tmin uspikes{trac} d_para.tmax]);
end
num_uspikes=cellfun('length',uspikes);
max_num_uspikes=max(num_uspikes);

if m_para.num_sel_bi_measures>0     % num_sel_measures>0
    
    non_empties=find(cellfun('length',spikes)>0);
    %tmin_spikes=find(cellfun(@(v) v(1), spikes(cellfun('length',spikes)>0))==d_para.tmin);
    %tmax_spikes=find(cellfun(@(v) v(end), spikes(cellfun('length',spikes)>0))==d_para.tmax);
    
    tmin_spikes=non_empties(abs(cellfun(@(v) v(1), spikes(cellfun('length',spikes)>0))-d_para.tmin)<1e-20);
    tmax_spikes=non_empties(abs(cellfun(@(v) v(end), spikes(cellfun('length',spikes)>0))-d_para.tmax)<1e-20);
    %if tmax_spikes2~=tmax_spikes
    %    disp(['!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Diff:',num2str(d_para.bc)])
    %end
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
    
    if m_para.num_pili_measures>0
        dummy=[spikes{:}];
        dummy=double(unique(dummy(dummy>d_para.tmin & dummy<d_para.tmax)));
        m_res.pili_supi=sort([d_para.tmin dummy dummy d_para.tmax]);
        m_res.pili_len=length(m_res.pili_supi);
        if m_res.pili_len~=2*m_res.num_isi
            disp(' '); disp(' ')
            error(['m_res.pili_len 2*m_res.num_isi =',num2str([m_res.pili_len 2*m_res.num_isi])])
        end
        m_res.pili_supi_indy=round((m_res.pili_supi-d_para.tmin)/d_para.dts);
        clear dummy
    end
    
    % ###########################################################################################################################################
    % ############################################################## Memory management ##########################################################
    % ###########################################################################################################################################
    
    d_para.num_pairs=d_para.num_trains*(d_para.num_trains-1)/2;
    m_para.memo_num_measures=2*m_para.num_pili_measures+m_para.num_pico_measures++m_para.num_disc_measures;
    memo_fact=m_para.memo_num_measures*d_para.num_pairs;
    memo=memo_fact*m_res.num_isi;
    
    max_memo=max_memo_init;
    
    
    %max_memo=16;    % ###############
    %max_memo=30;    % ###############
    
    
    r_para.num_runs=1;
    if memo>max_memo
        num_init_runs=ceil(memo/max_memo);
        max_pico_len=ceil(m_res.num_isi/num_init_runs);
        %max_pico_len=150
        
        if m_para.memo_num_measures>0
            r_para.num_runs=ceil(m_res.num_isi/max_pico_len);
            if r_para.num_runs==0
                set(0,'DefaultUIControlFontSize',16);
                mbh=msgbox(sprintf('Dataset might be too large.\nPlease increase the value of the variable ''max_memo'' !!!'),'Warning','warn','modal');
                htxt = findobj(mbh,'Type','text');
                set(htxt,'FontSize',12,'FontWeight','bold')
                mb_pos=get(mbh,'Position');
                set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                uiwait(mbh);
                ret=1;
                return
            end
        end
        
        r_para.run_pico_ends=cumsum(fix([max_pico_len*ones(1,r_para.num_runs-1) m_res.num_isi-max_pico_len*(r_para.num_runs-1)]));
        r_para.run_pico_starts=[1 r_para.run_pico_ends(1:end-1)+1];
        r_para.run_pico_lengths=r_para.run_pico_ends-r_para.run_pico_starts+1;
        
        if m_para.num_disc_measures>0
            r_para.run_disc_ends=zeros(1,r_para.num_runs);
            for ruc=1:r_para.num_runs
                r_para.run_disc_ends(ruc)=find(all_spikes==m_res.cum_isi(r_para.run_pico_ends(ruc)+1),1,'last');   % first
            end
            r_para.run_disc_starts=[1 r_para.run_disc_ends(1:end-1)+1];
            r_para.run_disc_lengths=r_para.run_disc_ends-r_para.run_disc_starts+1;
        end
        
        if m_para.num_pili_measures>0
            r_para.run_pili_ends=2*r_para.run_pico_ends;
            r_para.run_pili_starts=[1 r_para.run_pili_ends(1:end-1)+1];
            r_para.run_pili_lengths=r_para.run_pili_ends-r_para.run_pili_starts+1;
        end
    end
    
    if r_para.num_runs==1
        r_para.run_pico_lengths=m_res.num_isi;
        r_para.run_pico_starts=1;
        r_para.run_pico_ends=m_res.num_isi;
        if m_para.num_disc_measures>0
            r_para.run_disc_lengths=m_res.num_all_isi+1;
            r_para.run_disc_starts=1;
            r_para.run_disc_ends=r_para.run_disc_lengths;
        end
        if m_para.num_pili_measures>0
            r_para.run_pili_lengths=2*m_res.num_isi;
            r_para.run_pili_starts=1;
            r_para.run_pili_ends=2*m_res.num_isi;
        end
    end
    
    empties=find(m_res.all_isi==0);
    ivs=cell(1,d_para.num_trains);
    ive=cell(1,d_para.num_trains);
    for trac=1:d_para.num_trains
        dummy1=[1 max([m_res.num_tmin_spikes 1])+find(all_trains(max([m_res.num_tmin_spikes 1])+1:end-max([m_res.num_tmax_spikes 1]))==trac)];
        dummy2=[dummy1(2:length(dummy1))-1 m_res.num_all_isi-m_res.num_tmax_spikes+1];
        len=dummy2-dummy1+1-histc(empties,dummy1);
        ive{trac}=cumsum(len);
        ivs{trac}=[1 ive{trac}(1:end-1)+1];
        if isempty(ive{trac})
            ive{trac}=ivs{trac};
        end
    end
    clear empties % all_trains
    
    %     empties=find(m_res.all_isi==0);
    %     ivs=cell(1,d_para.num_trains);
    %     ive=cell(1,d_para.num_trains);
    %     for trac=1:d_para.num_trains
    %         dummy1=[1 max([m_res.num_tmin_spikes 1])+find(all_trains(max([m_res.num_tmin_spikes 1])+1:end-max([m_res.num_tmax_spikes 1]))==trac)];
    %         dummy2=[dummy1(2:length(dummy1))-1 m_res.num_all_isi-m_res.num_tmax_spikes+1];
    %         len=dummy2-dummy1+1-histc(empties,dummy1);
    %         ive{trac}=cumsum(len);
    %         ivs{trac}=[1 ive{trac}(1:end-1)+1];
    %     end
    %     clear empties % all_trains
    
    
    ave_bi_vect=zeros(m_para.num_sel_bi_measures,d_para.num_pairs);
    if r_para.num_runs>1
        disp(' ');
        disp('Large data set. Please be patient.')
        disp(' ');
        disp(['Number of calculation loop runs: ',num2str(r_para.num_runs)])
        pwbh = waitbar(0,'Large data set. Please be patient.','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
        setappdata(pwbh,'canceling',0)
    end
    
    if f_para.edge_correction
        if r_para.num_runs>1    % Edge-correction for many runs
            fl_isis=repmat({zeros(1,4)},1,d_para.num_trains);
            for trac=1:d_para.num_trains
                if num_uspikes(trac)>2
                    if spikes{trac}(1)>uspikes{trac}(1)
                        fl_isis{trac}(1:2)=diff(uspikes{trac}(1:3));
                    end
                    if spikes{trac}(end)<uspikes{trac}(end)
                        fl_isis{trac}(3:4)=diff(uspikes{trac}(end-2:end));
                    end
                end
            end
        end
        if any(f_para.select_measures([m_para.spike_pili m_para.realtime_spike_pili]))
            prev_edge_cor_indy=cell(1,d_para.num_trains);
        end
        if any(f_para.select_measures([m_para.spike_pili m_para.forward_spike_pili]))
            foll_edge_cor_indy=cell(1,d_para.num_trains);
        end
    end
    
    uspikes2=cell(1,d_para.num_trains);
    for trac=1:d_para.num_trains
        uspikes2{trac}=spikes{trac}(spikes{trac}>=d_para.tmin & spikes{trac}<=d_para.tmax);
        if length(uspikes2{trac})>1
            if uspikes2{trac}(1)>d_para.tmin
                if uspikes2{trac}(1)-d_para.tmin<uspikes2{trac}(2)-uspikes2{trac}(1)
                    uspikes2{trac}=unique([2*uspikes2{trac}(1)-uspikes2{trac}(2) uspikes2{trac}]);
                else
                    uspikes2{trac}=unique([d_para.tmin uspikes2{trac}]);
                end
            end
            if uspikes2{trac}(end)<d_para.tmax
                if d_para.tmax-uspikes2{trac}(end)<uspikes2{trac}(end)-uspikes2{trac}(end-1)
                    uspikes2{trac}=unique([uspikes2{trac} 2*uspikes2{trac}(end)-uspikes2{trac}(end-1)]);
                else
                    uspikes2{trac}=unique([uspikes2{trac} d_para.tmax]);
                end
            end
        else
            uspikes2{trac}=unique([d_para.tmin uspikes2{trac} d_para.tmax]);
        end
    end
    
    run_ivs=cell(1,d_para.num_trains);
    run_ive=cell(1,d_para.num_trains);
    r_para.ruc_initial=r_para.num_runs;
    r_para.ruc_final=1;
    for ruc=r_para.num_runs:-1:r_para.ruc_final
        if r_para.num_runs>1 && getappdata(pwbh,'canceling')
            delete(pwbh)
            ret=1;
            return
        end
        
        % ###########################################################################################################################################
        % ################################################################# Pico-pili-Quantities #####################################################
        % ###########################################################################################################################################
        
        if any(f_para.select_measures(m_para.bi_measures))
            run_firsts=zeros(1,d_para.num_trains);                             % first interval (and previous spike)
            run_lasts=zeros(1,d_para.num_trains);                              % last interval (and previous spike, following spike is +1)
            for trac=1:d_para.num_trains
                run_firsts(trac)=find(uspikes{trac}<=m_res.cum_isi(r_para.run_pico_starts(ruc)),1,'last');
                run_lasts(trac)=find(uspikes{trac}<m_res.cum_isi(r_para.run_pico_ends(ruc)+1),1,'last');
                run_ivs{trac}=ivs{trac}(run_firsts(trac):run_lasts(trac))-r_para.run_pico_starts(ruc)+1;
                run_ive{trac}=ive{trac}(run_firsts(trac):run_lasts(trac))-r_para.run_pico_starts(ruc)+1;
                run_ivs{trac}(run_ivs{trac}<1)=1;
                run_ive{trac}(run_ive{trac}>r_para.run_pico_lengths(ruc))=r_para.run_pico_lengths(ruc);
            end
            run_num_ints=run_lasts-run_firsts+1;
        end
        
        run_uspikes=cell(1,d_para.num_trains);
        for trac=1:d_para.num_trains
            run_uspikes{trac}=uspikes2{trac}(int32(run_firsts(trac)):int32(run_lasts(trac)+1));
        end
        run_num_uspikes=run_num_ints+1;
        if exist(['SPIKY_udists_MEX2.',mexext],'file')
            run_udists=SPIKY_udists_MEX2(int32(d_para.num_trains),int32(run_num_uspikes),run_uspikes);
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
                    run_udists{trac,trac2}(1)=min(abs(run_uspikes{trac}(1)-uspikes2{trac2}));
                    run_udists{trac,trac2}(end)=min(abs(run_uspikes{trac}(end)-uspikes2{trac2}));
                end
            end
        end
        
        if any(f_para.select_measures([m_para.spikesync_disc m_para.isi_pico m_para.spike_pili]))
            isis=cell(1,d_para.num_trains);
            ints=zeros(d_para.num_trains,r_para.run_pico_lengths(ruc));
            for trac=1:d_para.num_trains
                isis{trac}=diff(run_uspikes{trac});
                for ic=1:run_num_ints(trac)
                    ints(trac,run_ivs{trac}(ic):run_ive{trac}(ic))=isis{trac}(ic);
                end
            end
        end
        
        if any(f_para.select_measures([m_para.spike_pili m_para.realtime_spike_pili]))  % SPIKE-Pre-Pico
            previs_indy=zeros(d_para.num_trains,max(run_num_ints),'uint32');
            previs=zeros(d_para.num_trains,max(run_num_ints));
            prev_spikes_indy=zeros(d_para.num_trains,r_para.run_pico_lengths(ruc),'uint32');
            prev_spikes=zeros(d_para.num_trains,r_para.run_pico_lengths(ruc));
            for trac=1:d_para.num_trains
                previs_indy(trac,1:run_num_ints(trac))=run_firsts(trac):run_lasts(trac);
                previs(trac,1:run_num_ints(trac))=run_uspikes{trac}(previs_indy(trac,1:run_num_ints(trac))-run_firsts(trac)+1);
                for ic=1:run_num_ints(trac)
                    prev_spikes_indy(trac,run_ivs{trac}(ic):run_ive{trac}(ic))=previs_indy(trac,ic);
                    prev_spikes(trac,run_ivs{trac}(ic):run_ive{trac}(ic))=previs(trac,ic);
                end
                if f_para.edge_correction && num_uspikes(trac)>2 && run_firsts(trac)==1 && spikes{trac}(1)>uspikes{trac}(1)  % edge-correction
                    prev_edge_cor_indy{trac}=find(prev_spikes_indy(trac,:)==1);
                end
                prev_spikes_indy(trac,:)=prev_spikes_indy(trac,:)-uint32(run_firsts(trac)-1);
            end
            clear previs_indy previs
            
            if any(f_para.select_measures([m_para.spike_pili m_para.realtime_spike_pili]))                     % SPIKE-Pre-pili
                prev_spikes_indy_pili=zeros(d_para.num_trains,r_para.run_pili_lengths(ruc),'uint32'); % two values at start/end of each interval of pooled spike train: index of previous uspike in that spike train
                prev_spikes_pili=zeros(d_para.num_trains,r_para.run_pili_lengths(ruc)); % two values at start/end of each interval of pooled spike train: distance to previous uspike in that spike train
                for trac=1:d_para.num_trains
                    prev_spikes_indy_pili(trac,:)=reshape(repmat(prev_spikes_indy(trac,1:r_para.run_pico_lengths(ruc)),2,1),1,r_para.run_pili_lengths(ruc));
                    prev_spikes_pili(trac,:)=m_res.pili_supi(r_para.run_pili_starts(ruc):r_para.run_pili_ends(ruc))-...
                        reshape([prev_spikes(trac,1:r_para.run_pico_lengths(ruc)); prev_spikes(trac,1:r_para.run_pico_lengths(ruc))],...
                        1,r_para.run_pili_lengths(ruc));
                end
            end
        end
        
        if any(f_para.select_measures([m_para.spike_pili m_para.forward_spike_pili]))  % SPIKE-forward-Pico
            follis_indy=zeros(d_para.num_trains,max(run_num_ints),'uint32');
            follis=zeros(d_para.num_trains,max(run_num_ints));
            foll_spikes_indy=zeros(d_para.num_trains,r_para.run_pico_lengths(ruc),'uint32');
            foll_spikes=zeros(d_para.num_trains,r_para.run_pico_lengths(ruc));
            for trac=1:d_para.num_trains
                follis_indy(trac,1:run_num_ints(trac))=(run_firsts(trac):run_lasts(trac))+1;
                follis(trac,1:run_num_ints(trac))=run_uspikes{trac}(follis_indy(trac,1:run_num_ints(trac))-run_firsts(trac)+1);
                for ic=1:run_num_ints(trac)
                    foll_spikes_indy(trac,run_ivs{trac}(ic):run_ive{trac}(ic))=follis_indy(trac,ic);
                    foll_spikes(trac,run_ivs{trac}(ic):run_ive{trac}(ic))=follis(trac,ic);
                end
                if f_para.edge_correction && num_uspikes(trac)>2 && run_lasts(trac)==num_uspikes(trac)-1 && spikes{trac}(end)<uspikes{trac}(end)
                    foll_edge_cor_indy{trac}=find(foll_spikes_indy(trac,:)==num_uspikes(trac));
                end
                foll_spikes_indy(trac,:)=foll_spikes_indy(trac,:)-uint32(run_firsts(trac)-1);
            end
            clear follis_indy follis
            
            if any(f_para.select_measures([m_para.spike_pili m_para.forward_spike_pili]))                       % SPIKE-forward-pili
                foll_spikes_indy_pili=zeros(d_para.num_trains,r_para.run_pili_lengths(ruc),'uint32'); % two values at start/end of each interval of pooled spike train: index of following uspike in that spike train
                foll_spikes_pili=zeros(d_para.num_trains,r_para.run_pili_lengths(ruc)); % two values at start/end of each interval of pooled spike train: distance to following uspike in that spike train
                for trac=1:d_para.num_trains
                    foll_spikes_indy_pili(trac,:)=reshape(repmat(foll_spikes_indy(trac,1:r_para.run_pico_lengths(ruc)),2,1),1,r_para.run_pili_lengths(ruc));
                    foll_spikes_pili(trac,:)=reshape([foll_spikes(trac,1:r_para.run_pico_lengths(ruc)); foll_spikes(trac,1:r_para.run_pico_lengths(ruc))],...
                        1,r_para.run_pili_lengths(ruc))-m_res.pili_supi(r_para.run_pili_starts(ruc):r_para.run_pili_ends(ruc));
                end
            end
        end
        clear isis
        
        % #####################################################################################################################################
        % ############################################################## [ pili-Measures ] ###################################################
        % #####################################################################################################################################
        
        if m_para.num_pili_measures>0
            odds=1:2:r_para.run_pili_lengths(ruc);
            evens=odds+1;
            m_res.pili_measures_mat=zeros(m_para.num_pili_measures,d_para.num_pairs,r_para.run_pili_lengths(ruc));
            
            if f_para.select_measures(m_para.realtime_spike_pili)                                           % REALTIME-pili
                if exist(['SPIKY_realtimeSPIKE_MEX.',mexext],'file')
                    m_res.pili_measures_mat(m_para.measure_indy(m_para.realtime_spike_pili),1:d_para.num_pairs,1:r_para.run_pili_lengths(ruc)) = ...
                        SPIKY_realtimeSPIKE_MEX(int32(d_para.num_pairs),int32(r_para.run_pili_lengths(ruc)),int32(d_para.num_trains),...
                        prev_spikes_pili,int32(prev_spikes_indy_pili),run_udists);
                else
                    pac=0;
                    for trac1=1:d_para.num_trains-1
                        for trac2=trac1+1:d_para.num_trains
                            pac=pac+1;
                            normy=(prev_spikes_pili(trac1,:)+prev_spikes_pili(trac2,:));
                            dummy=(prev_spikes_pili(trac1,:)<prev_spikes_pili(trac2,:)-0.00000001);
                            dummy1=trac1*(1-dummy)+trac2*dummy;   % index of spike train with earlier spike
                            dummy2=trac2*(1-dummy)+trac1*dummy;   % index of spike train with later spike
                            for sc=1:r_para.run_pili_lengths(ruc)
                                m_res.pili_measures_mat(m_para.measure_indy(m_para.realtime_spike_pili),pac,sc)= ...
                                    (abs(prev_spikes_pili(trac1,sc)-prev_spikes_pili(trac2,sc))+...   % later spike
                                    run_udists{dummy1(sc),dummy2(sc)}(prev_spikes_indy_pili(dummy1(sc),sc)))...      % earlier spike
                                    /(2*normy(sc)+(normy(sc)==0));
                            end
                        end
                    end
                    clear dummy dummy1 dummy2
                end
                aves=(log(1./m_res.pili_measures_mat(m_para.measure_indy(m_para.realtime_spike_pili),:,evens))-...
                    log(1./m_res.pili_measures_mat(m_para.measure_indy(m_para.realtime_spike_pili),:,odds)))./...
                    (1./m_res.pili_measures_mat(m_para.measure_indy(m_para.realtime_spike_pili),:,evens)-...
                    1./m_res.pili_measures_mat(m_para.measure_indy(m_para.realtime_spike_pili),:,odds));
                aves(isnan(aves))=0;
                ave_bi_vect(logical(m_para.select_bi_measures==m_para.realtime_spike_pili),:)=...
                    ave_bi_vect(logical(m_para.select_bi_measures==m_para.realtime_spike_pili),:)+...
                    sum(aves.*repmat(shiftdim(m_res.isi(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc)),-1),...
                    [1,d_para.num_pairs]),3);
            end
            
            if f_para.select_measures(m_para.forward_spike_pili)                                             % forward-pili
                if exist(['SPIKY_forwardSPIKE_MEX.',mexext],'file')
                    m_res.pili_measures_mat(m_para.measure_indy(m_para.forward_spike_pili),1:d_para.num_pairs,1:r_para.run_pili_lengths(ruc)) = ...
                        SPIKY_forwardSPIKE_MEX(int32(d_para.num_pairs),int32(r_para.run_pili_lengths(ruc)),int32(d_para.num_trains),...
                        foll_spikes_pili,int32(foll_spikes_indy_pili),run_udists);
                else
                    pac=0;
                    for trac1=1:d_para.num_trains-1
                        for trac2=trac1+1:d_para.num_trains
                            pac=pac+1;
                            normy=(foll_spikes_pili(trac1,:)+foll_spikes_pili(trac2,:));
                            dummy=(foll_spikes_pili(trac1,:)<foll_spikes_pili(trac2,:)-0.00000001);
                            dummy1=trac1*(1-dummy)+trac2*dummy;   % index of spike train with earlier spike
                            dummy2=trac2*(1-dummy)+trac1*dummy;   % index of spike train with later spike
                            for sc=1:r_para.run_pili_lengths(ruc)
                                m_res.pili_measures_mat(m_para.measure_indy(m_para.forward_spike_pili),pac,sc)= ...
                                    (abs(foll_spikes_pili(trac1,sc)-foll_spikes_pili(trac2,sc))+...   % later spike
                                    run_udists{dummy1(sc),dummy2(sc)}(foll_spikes_indy_pili(dummy1(sc),sc)))...      % earlier spike
                                    /(2*normy(sc)+(normy(sc)==0));
                            end
                        end
                    end
                    clear dummy dummy1 dummy2
                end
                aves=(log(1./m_res.pili_measures_mat(m_para.measure_indy(m_para.forward_spike_pili),:,evens))-...
                    log(1./m_res.pili_measures_mat(m_para.measure_indy(m_para.forward_spike_pili),:,odds)))./...
                    (1./m_res.pili_measures_mat(m_para.measure_indy(m_para.forward_spike_pili),:,evens)-...
                    1./m_res.pili_measures_mat(m_para.measure_indy(m_para.forward_spike_pili),:,odds));
                aves(isnan(aves))=0;
                ave_bi_vect(logical(m_para.select_bi_measures==m_para.forward_spike_pili),:)=...
                    ave_bi_vect(logical(m_para.select_bi_measures==m_para.forward_spike_pili),:)+...
                    sum(aves.*repmat(shiftdim(m_res.isi(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc)),-1),...
                    [1,d_para.num_pairs]),3);
            end
            
            if f_para.select_measures(m_para.spike_pili)                                                   % SPIKE-pili
                if f_para.edge_correction
                    for trac=1:d_para.num_trains
                        if num_uspikes(trac)>2    % protection against empty spike trains
                            if run_firsts(trac)==1 && spikes{trac}(1)>uspikes{trac}(1)
                                %prev_spikes_indy(prev_edge_cor_indy{trac})=prev_spikes_indy(prev_edge_cor_indy{trac})+1;
                                prev_spikes_indy_pili(trac,[prev_edge_cor_indy{trac}*2-1 prev_edge_cor_indy{trac}*2])=...
                                    prev_spikes_indy_pili(trac,[prev_edge_cor_indy{trac}*2-1 prev_edge_cor_indy{trac}*2])+1;
                            end
                            if run_lasts(trac)==num_uspikes(trac)-1 && spikes{trac}(end)<uspikes{trac}(end)
                                %foll_spikes_indy(foll_edge_cor_indy{trac})=foll_spikes_indy(foll_edge_cor_indy{trac})-1;
                                foll_spikes_indy_pili(trac,[foll_edge_cor_indy{trac}*2-1 foll_edge_cor_indy{trac}*2])=...
                                    foll_spikes_indy_pili(trac,[foll_edge_cor_indy{trac}*2-1 foll_edge_cor_indy{trac}*2])-1;
                            end
                        end
                    end
                end
                clear isis
                isi_indy_pili=reshape(repmat(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc),2,1),1,2*r_para.run_pico_lengths(ruc))-...
                    r_para.run_pico_starts(ruc)+1;
                
                if exist(['SPIKY_SPIKE_MEX.',mexext],'file')
                    m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_pili),1:d_para.num_pairs,1:r_para.run_pili_lengths(ruc)) = ...
                        SPIKY_SPIKE_MEX(int32(d_para.num_pairs),int32(r_para.run_pili_lengths(ruc)),int32(d_para.num_trains),...
                        foll_spikes_pili,prev_spikes_pili,int32(isi_indy_pili-1),int32(prev_spikes_indy_pili),int32(foll_spikes_indy_pili),...
                        ints,run_udists);
                else
                    pac=0;
                    for trac1=1:d_para.num_trains-1
                        for trac2=trac1+1:d_para.num_trains
                            pac=pac+1;
                            m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_pili),pac,1:r_para.run_pili_lengths(ruc)) = ...
                                ((run_udists{trac1,trac2}(prev_spikes_indy_pili(trac1,:)).*foll_spikes_pili(trac1,:)+...
                                run_udists{trac1,trac2}(foll_spikes_indy_pili(trac1,:)).*prev_spikes_pili(trac1,:))./...
                                ints(trac1,isi_indy_pili).*ints(trac2,isi_indy_pili)+...
                                (run_udists{trac2,trac1}(prev_spikes_indy_pili(trac2,:)).*foll_spikes_pili(trac2,:)+...
                                run_udists{trac2,trac1}(foll_spikes_indy_pili(trac2,:)).*prev_spikes_pili(trac2,:))./...
                                ints(trac2,isi_indy_pili).*ints(trac1,isi_indy_pili))./...
                                ((ints(trac1,isi_indy_pili)+ints(trac2,isi_indy_pili)).^2/2);
                        end
                    end
                end
                ave_bi_vect(logical(m_para.select_bi_measures==m_para.spike_pili),:)=...
                    ave_bi_vect(logical(m_para.select_bi_measures==m_para.spike_pili),:)+...
                    sum((m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_pili),:,odds)+...
                    m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_pili),:,evens))/2.*...
                    repmat(shiftdim(m_res.isi(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc)),-1),[1,d_para.num_pairs]),3);
            end
        end
        
        % #####################################################################################################################################
        % ################################################### Disc-Measures (SPIKE-Synchro) ###################################################
        % #####################################################################################################################################
        
        if m_para.num_disc_measures>0                                                                                                   % disc
            m_res.disc_measures_mat=zeros(m_para.num_disc_measures,d_para.num_pairs,r_para.run_disc_lengths(ruc));
            
            if ruc==r_para.ruc_initial
                num_spikes=cellfun('length',spikes);
                all_cum_events=zeros(d_para.num_trains,m_res.num_all_isi+1);
                for trac=1:d_para.num_trains
                    all_cum_events(trac,:)=cumsum(all_trains(1:m_res.num_all_isi+1)==trac);
                end
                %m_res.all_pos_spikes=[zeros(d_para.num_trains,1) diff(all_cum_events,[],2) zeros(d_para.num_trains,1)];    % position of events (position of following ISI)
                m_res.all_pos_spikes=diff([zeros(d_para.num_trains,1) all_cum_events],[],2);    % position of events (position of following ISI)
                clear all_cum_events
                num_pair_all_spikes=zeros(1,d_para.num_pairs);
            end
            
            if f_para.select_measures(m_para.spikesync_disc)|| f_para.select_measures(m_para.spikeorder_disc)
                if ruc==r_para.ruc_initial
                    if f_para.select_measures(m_para.spikesync_disc)
                        spike_synchro=cell(1,d_para.num_pairs);
                    end
                    if f_para.select_measures(m_para.spikeorder_disc)
                        spike_order=cell(1,d_para.num_pairs);
                    end
                end
                if sum(num_spikes)>0
                    if f_para.select_measures(m_para.spikesync_disc)
                        norm_spike_synchro=zeros(d_para.num_pairs,r_para.run_disc_lengths(ruc));
                    end
                    if f_para.select_measures(m_para.spikeorder_disc)
                        norm_spike_order=zeros(d_para.num_pairs,r_para.run_disc_lengths(ruc));
                    end
                    pac=0;
                    es_isis=cell(1,2);
                    for trac1=1:d_para.num_trains-1
                        if ruc==r_para.ruc_initial
                            es_isis{1}=[inf diff(spikes{trac1}) inf];
                        end
                        for trac2=trac1+1:d_para.num_trains
                            pac=pac+1;
                            tracs=[trac1 trac2];
                            if ruc==r_para.ruc_initial
                                pair_all_spikes=sort([spikes{[trac1 trac2]}]);    %  all_spikes(ismember(all_trains,[0 trac1 trac2]))
                                num_pair_all_spikes(pac)=length(pair_all_spikes);
                                if num_pair_all_spikes(pac)>0
                                    if exist(['SPIKY_SPIKEsynchro_MEX22.',mexext],'file')  % #################################### check spikes on edges and single spikes
                                        if pac==1
                                            spike_synchro=SPIKY_SPIKEsynchro_MEX2(int32(d_para.num_trains),int32(d_para.num_spikes),spikes);
                                        end
                                    else
                                        if f_para.select_measures(m_para.spikesync_disc)
                                            spike_synchro{pac}=zeros(1,num_pair_all_spikes(pac));
                                        end
                                        if f_para.select_measures(m_para.spikeorder_disc)
                                            spike_order{pac}=zeros(1,num_pair_all_spikes(pac));
                                        end
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
                                                if abs(pair_spike2-pair_spike1)<min_tau                             % < , not <= !!!!!!
                                                    if f_para.select_measures(m_para.spikesync_disc)
                                                        spike_synchro{pac}(logical(pair_spike1==pair_all_spikes))=1;
                                                        spike_synchro{pac}(logical(pair_spike2==pair_all_spikes))=1;
                                                    end
                                                    if f_para.select_measures(m_para.spikeorder_disc)
                                                        if pair_spike1<pair_spike2
                                                            spike_order{pac}(logical(pair_spike1==pair_all_spikes))=1; % 1 l    positive: 1,2; 1:leading spike
                                                            spike_order{pac}(logical(pair_spike2==pair_all_spikes))=1; % 2 f    positive: 1,2; 2:following spike
                                                        elseif pair_spike1>pair_spike2
                                                            spike_order{pac}(logical(pair_spike2==pair_all_spikes))=-1;  % -1 l  negative:2,1; 1:leading spike
                                                            spike_order{pac}(logical(pair_spike1==pair_all_spikes))=-1; % -2 f   negative:2,1; 2:following spike
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if num_pair_all_spikes(pac)>0
                                run_all_pos_spikes=m_res.all_pos_spikes([trac1 trac2],r_para.run_disc_starts(ruc):r_para.run_disc_ends(ruc));
                                if f_para.select_measures(m_para.spikesync_disc)
                                    run_start=length(find(any(m_res.all_pos_spikes([trac1 trac2],1:r_para.run_disc_starts(ruc)-1))));
                                    norm_spike_synchro(pac,any(run_all_pos_spikes))=spike_synchro{pac}(run_start+(1:length(find(any(run_all_pos_spikes)))));
                                end
                                if f_para.select_measures(m_para.spikeorder_disc)
                                    norm_spike_order(pac,any(run_all_pos_spikes))=spike_order{pac};
                                end
                            end
                        end
                        if ruc==1 && min(cellfun(@(v) v(1), spikes(cellfun('length',spikes)>0)))>d_para.tmin
                            if f_para.select_measures(m_para.spikesync_disc)
                                norm_spike_synchro(:,1)=norm_spike_synchro(:,2);            % edges, alternative: don't assign and plot them
                            end
                            if f_para.select_measures(m_para.spikeorder_disc)
                                norm_spike_order(:,1)=norm_spike_order(:,2);                % edges, alternative: don't assign and plot them
                            end
                        end
                        if ruc==r_para.num_runs && max(cellfun(@(v) v(end), spikes(cellfun('length',spikes)>0)))<d_para.tmax
                            if f_para.select_measures(m_para.spikesync_disc)
                                norm_spike_synchro(:,end)=norm_spike_synchro(:,end-1);
                            end
                            if f_para.select_measures(m_para.spikeorder_disc)
                                norm_spike_order(:,end)=norm_spike_order(:,end-1);
                            end
                        end
                        
                        if f_para.select_measures(m_para.spikesync_disc)
                            m_res.disc_measures_mat(m_para.measure_indy(m_para.spikesync_disc),1:d_para.num_pairs,1:r_para.run_disc_lengths(ruc))=norm_spike_synchro;
                        end
                        if f_para.select_measures(m_para.spikeorder_disc)
                            m_res.disc_measures_mat(m_para.measure_indy(m_para.spikeorder_disc),1:d_para.num_pairs,1:r_para.run_disc_lengths(ruc))=norm_spike_order;
                        end
                    end
                else
                    if f_para.select_measures(m_para.spikesync_disc)
                        m_res.disc_measures_mat(m_para.measure_indy(m_para.spikesync_disc),1:d_para.num_pairs,1:r_para.run_disc_lengths(ruc))=[1 1];
                    end
                    if f_para.select_measures(m_para.spikeorder_disc)
                        m_res.disc_measures_mat(m_para.measure_indy(m_para.spikeorder_disc),1:d_para.num_pairs,1:r_para.run_disc_lengths(ruc))=[0 0];
                    end
                end
            end
            
            
            if r_para.num_runs==1
                if m_res.num_tmin_spikes>0 && m_res.num_tmax_spikes>0     % pairwise values
                    ave_bi_vect(m_para.disc_bi_measures_indy,:)=ave_bi_vect(m_para.disc_bi_measures_indy,:)+...
                        sum(m_res.disc_measures_mat(m_para.measure_indy(m_para.select_disc_measures),:,:),3);
                elseif m_res.num_tmin_spikes>0
                    ave_bi_vect(m_para.disc_bi_measures_indy,:)=ave_bi_vect(m_para.disc_bi_measures_indy,:)+...
                        sum(m_res.disc_measures_mat(m_para.measure_indy(m_para.select_disc_measures),:,1:end-1),3);
                elseif m_res.num_tmax_spikes>0
                    ave_bi_vect(m_para.disc_bi_measures_indy,:)=ave_bi_vect(m_para.disc_bi_measures_indy,:)+...
                        sum(m_res.disc_measures_mat(m_para.measure_indy(m_para.select_disc_measures),:,2:end),3);
                else
                    ave_bi_vect(m_para.disc_bi_measures_indy,:)=ave_bi_vect(m_para.disc_bi_measures_indy,:)+...
                        sum(m_res.disc_measures_mat(m_para.measure_indy(m_para.select_disc_measures),:,2:end-1),3);
                end
                disc_profiles=shiftdim(permute(sum(m_res.disc_measures_mat(m_para.measure_indy(m_para.select_disc_measures),:,:),2),[2 1 3]),1);   % sum over pairs
            else
                if ruc==1
                    if m_res.num_tmin_spikes>0
                        ave_bi_vect(m_para.disc_bi_measures_indy,:)=ave_bi_vect(m_para.disc_bi_measures_indy,:)+...
                            sum(m_res.disc_measures_mat(m_para.measure_indy(m_para.select_disc_measures),:,:),3);
                    else
                        ave_bi_vect(m_para.disc_bi_measures_indy,:)=ave_bi_vect(m_para.disc_bi_measures_indy,:)+...
                            sum(m_res.disc_measures_mat(m_para.measure_indy(m_para.select_disc_measures),:,2:end),3);
                    end
                elseif ruc==r_para.num_runs
                    if m_res.num_tmax_spikes>0
                        ave_bi_vect(m_para.disc_bi_measures_indy,:)=ave_bi_vect(m_para.disc_bi_measures_indy,:)+...
                            sum(m_res.disc_measures_mat(m_para.measure_indy(m_para.select_disc_measures),:,:),3);
                    else
                        ave_bi_vect(m_para.disc_bi_measures_indy,:)=ave_bi_vect(m_para.disc_bi_measures_indy,:)+...
                            sum(m_res.disc_measures_mat(m_para.measure_indy(m_para.select_disc_measures),:,1:end-1),3);
                    end
                else
                    ave_bi_vect(m_para.disc_bi_measures_indy,:)=ave_bi_vect(m_para.disc_bi_measures_indy,:)+...
                        sum(m_res.disc_measures_mat(m_para.measure_indy(m_para.select_disc_measures),:,:),3);
                end
            end
        end
        
        % #####################################################################################################################################
        % ########################################################### [ Pico-Measures ] #######################################################
        % #####################################################################################################################################
        
        if m_para.num_pico_measures>0                                                                                                   % Pico
            if f_para.select_measures(m_para.isi_pico)                        % ISI (calculated first, then edge-correction of ints for SPIKE)
                if exist(['SPIKY_ISI_MEX.',mexext],'file')
                    m_res.pico_measures_mat(m_para.measure_indy(m_para.isi_pico),1:d_para.num_pairs,1:r_para.run_pico_lengths(ruc)) = ...
                        abs(SPIKY_ISI_MEX(int32(d_para.num_pairs),int32(r_para.run_pico_lengths(ruc)),int32(d_para.num_trains),ints));
                else
                    pac=0;
                    for trac1=1:d_para.num_trains-1
                        for trac2=trac1+1:d_para.num_trains
                            pac=pac+1;
                            dummy1=find(ints(trac1,:)<ints(trac2,:));
                            m_res.pico_measures_mat(m_para.measure_indy(m_para.isi_pico),pac,dummy1)=abs(ints(trac1,dummy1)./ints(trac2,dummy1)-1);
                            dummy2=find(ints(trac1,:)>=ints(trac2,:) & ints(trac1,:)~=0);
                            m_res.pico_measures_mat(m_para.measure_indy(m_para.isi_pico),pac,dummy2)=abs(ints(trac2,dummy2)./ints(trac1,dummy2)-1);
                        end
                    end
                end
            end
            ave_bi_vect(m_para.pico_bi_measures_indy,:)=ave_bi_vect(m_para.pico_bi_measures_indy,:)+sum(m_res.pico_measures_mat.*...
                repmat(shiftdim(m_res.isi(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc)),-1),[m_para.num_pico_measures,...
                d_para.num_pairs]),3);
        end
        
        if r_para.num_runs>1
            disp(['Calculation-Loop-Info: ',num2str(r_para.num_runs+1-ruc),'  (',num2str(r_para.num_runs),')'])
            if m_para.num_disc_measures>0
                eval(['sl_disc_' num2str(ruc) '= m_res.disc_measures_mat;']);
                if ruc==r_para.ruc_initial
                    disc_profiles=zeros(m_para.num_disc_measures,m_res.num_all_isi+1);
                end
                disc_profiles(:,r_para.run_disc_starts(ruc):r_para.run_disc_ends(ruc))=...
                    shiftdim(permute(sum(m_res.disc_measures_mat(m_para.measure_indy(m_para.spikesync_disc),:,:),2),[2 1 3]),1);
            end
            if m_para.num_pico_measures>0
                eval(['sl_pico_' num2str(ruc) '= m_res.pico_measures_mat;']);
                if ruc==r_para.ruc_initial
                    pico_profiles=zeros(m_para.num_pico_measures,m_res.num_isi);
                end
                pico_profiles(:,r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc))=shiftdim(permute(mean(m_res.pico_measures_mat,2),[2 1 3]),1);
            end
            if m_para.num_pili_measures>0
                eval(['sl_pili_' num2str(ruc) '= m_res.pili_measures_mat;']);
                if ruc==r_para.ruc_initial
                    pili_profiles=zeros(m_para.num_pili_measures,m_res.pili_len);
                end
                pili_profiles(:,r_para.run_pili_starts(ruc):r_para.run_pili_ends(ruc))=shiftdim(permute(mean(m_res.pili_measures_mat,2),[2 1 3]),1);
            end
            save(['SPIKY_AZBYCX' num2str(ruc)],'-v6',['sl_*' num2str(ruc)])
            %waitbar((r_para.num_runs+1-ruc)/r_para.num_runs,pwbh,['Calculation-Loop-Info: ',...
            %    num2str(r_para.num_runs+1-ruc),'  (',num2str(r_para.num_runs),')'])
            if ruc==1
                delete(pwbh)
            end
        end
    end
    r_para.ruc=ruc;
    clear uspikes all_spikes all_trains
    
    
    if m_para.num_pico_measures>0
        ave_bi_vect(m_para.pico_bi_measures_indy,:)=ave_bi_vect(m_para.pico_bi_measures_indy,:)/sum(m_res.isi);
    end
    if m_para.num_pili_measures>0
        ave_bi_vect(m_para.pili_bi_measures_indy,:)=ave_bi_vect(m_para.pili_bi_measures_indy,:)/sum(m_res.isi);
    end
    all_distances=mean(ave_bi_vect,2)';
    
    if m_para.num_disc_measures>0
        if f_para.select_measures(m_para.spikesync_disc)
            if sum(num_pair_all_spikes)>0
                all_distances(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikesync_disc)))=sum(ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikesync_disc)),:))/sum(num_pair_all_spikes);   % not simple average !!!
            else
                all_distances(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikesync_disc)))=1;
            end
            ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikesync_disc)),:)=(ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikesync_disc)),:)+(num_pair_all_spikes==0))./(num_pair_all_spikes+(num_pair_all_spikes==0));
        end
        if f_para.select_measures(m_para.spikeorder_disc)
            if sum(num_pair_all_spikes)>0
                all_distances(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikeorder_disc)))=sum(ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikeorder_disc)),:))/sum(num_pair_all_spikes);   % not simple average !!!
            else
                all_distances(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikeorder_disc)))=0;
            end
            ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikeorder_disc)),:)=(ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikeorder_disc)),:)+(num_pair_all_spikes==0))./(num_pair_all_spikes+(num_pair_all_spikes==0));
        end
    end
    
    mat_indy=nchoosek(1:d_para.num_trains,2);
    results.spikes=spikes;
    for mac=1:m_para.num_sel_bi_measures
        eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
            '.name=''',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),''';'])
        eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.overall=all_distances(mac);'])
        if m_para.select_bi_measures(mac)==m_para.spikesync_disc
            eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.matrix=ones(d_para.num_trains,d_para.num_trains);'])
        else
            eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.matrix=zeros(d_para.num_trains,d_para.num_trains);'])
        end
        eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
            '.matrix(sub2ind([d_para.num_trains d_para.num_trains],mat_indy(:,1),mat_indy(:,2)))=ave_bi_vect(mac,:);'])
        if m_para.select_bi_measures(mac)~=m_para.spikeorder_disc
            eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
                '.matrix(sub2ind([d_para.num_trains d_para.num_trains],mat_indy(:,2),mat_indy(:,1)))=ave_bi_vect(mac,:);'])
        else
            eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
                '.matrix(sub2ind([d_para.num_trains d_para.num_trains],mat_indy(:,2),mat_indy(:,1)))=-ave_bi_vect(mac,:);'])
        end
        if isfield(d_para,'all_train_group_sizes') && length(d_para.all_train_group_sizes)>1
            eval(['imat=results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.matrix;']);
            gmat=zeros(f_para.num_select_train_groups,f_para.num_select_train_groups);
            for sgc=1:f_para.num_select_train_groups
                for sgc2=sgc:f_para.num_select_train_groups
                    if sgc~=sgc2
                        gmat(sgc,sgc2)=mean(mean(imat(f_para.select_group_vect==f_para.select_train_groups(sgc),...
                            f_para.select_group_vect==f_para.select_train_groups(sgc2))));
                        gmat(sgc2,sgc)=gmat(sgc,sgc2);
                    else
                        if f_para.num_select_group_trains(sgc)>1
                            gmat(sgc,sgc2)=(sum(sum(imat(f_para.select_group_vect==f_para.select_train_groups(sgc),f_para.select_group_vect==f_para.select_train_groups(sgc))))-...
                                f_para.num_select_group_trains(sgc)*imat(1,1))/((f_para.num_select_group_trains(sgc)*(f_para.num_select_group_trains(sgc)-1)));
                        end
                    end
                end
            end
            eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.group_matrix=gmat;'])
        end
        if ismember(m_para.select_bi_measures(mac),m_para.disc_measures)
            if m_res.num_tmin_spikes>0 && m_res.num_tmax_spikes>0
                eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.time=d_para.tmin+[0 cumsum(m_res.all_isi)];'])
                eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.profile=disc_profiles(m_para.measure_indy(m_para.select_bi_measures(mac)),:)/(d_para.num_trains-1);'])
            elseif m_res.num_tmin_spikes>0
                eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.time=d_para.tmin+[0 cumsum(m_res.all_isi(1:end-1))];'])
                eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.profile=disc_profiles(m_para.measure_indy(m_para.select_bi_measures(mac)),1:end-1)/(d_para.num_trains-1);'])
            elseif m_res.num_tmax_spikes>0
                eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.time=d_para.tmin+[cumsum(m_res.all_isi)];'])
                eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.profile=disc_profiles(m_para.measure_indy(m_para.select_bi_measures(mac)),2:end)/(d_para.num_trains-1);'])
            else
                eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.time=d_para.tmin+[cumsum(m_res.all_isi(1:end-1))];'])
                eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.profile=disc_profiles(m_para.measure_indy(m_para.select_bi_measures(mac)),2:end-1)/(d_para.num_trains-1);'])
            end
        elseif ismember(m_para.select_bi_measures(mac),m_para.pico_measures)
            eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.time=m_res.isi;'])
            if r_para.num_runs==1
                eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
                    '.profile=shiftdim(permute(mean(m_res.pico_measures_mat(m_para.measure_indy(m_para.select_bi_measures(mac)),:,:),2),[2 1 3]),1);'])
            else
                eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
                    '.profile=pico_profiles(m_para.measure_indy(m_para.select_bi_measures(mac)),:);'])
            end
        elseif ismember(m_para.select_bi_measures(mac),m_para.pili_measures)
            eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),'.time=m_res.pili_supi;'])
            if r_para.num_runs==1
                eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
                    '.profile=shiftdim(permute(mean(m_res.pili_measures_mat(m_para.measure_indy(m_para.select_bi_measures(mac)),:,:),2),[2 1 3]),1);'])
            else
                eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
                    '.profile=pili_profiles(m_para.measure_indy(m_para.select_bi_measures(mac)),:);'])
            end
        end
    end
    
    if isfield(d_para,'instants') && ~isempty(d_para.instants)
        d_para.instants=unique(d_para.instants);
        d_para.num_instants=length(d_para.instants);
    else
        d_para.instants=[];
        d_para.num_instants=0;
    end
    
    if isfield(d_para,'selective_averages') && ~isempty(d_para.selective_averages)
        d_para.num_selective_averages=length(d_para.selective_averages);
        d_para.num_sel_ave=zeros(1,d_para.num_selective_averages);
        for sac=1:d_para.num_selective_averages
            d_para.num_sel_ave(sac)=length(d_para.selective_averages{sac})/2;
        end
    else
        d_para.num_selective_averages=0;
    end
    
    if isfield(d_para,'triggered_averages') && ~isempty(d_para.triggered_averages)
        d_para.num_triggered_averages=length(d_para.triggered_averages);
    else
        d_para.num_triggered_averages=0;
    end
    f_para.select_trains=1:d_para.num_trains;
    f_para.num_trains=d_para.num_trains;
    
    triu_indy=triu(ones(d_para.num_trains),1);
    [ti_col,ti_row]=find(triu_indy');
    f_para.num_select_pairs=f_para.num_trains*(f_para.num_trains-1)/2;
    f_para.select_pairs=zeros(1,f_para.num_select_pairs);
    pc=0;
    for trac1=1:f_para.num_trains-1
        for trac2=trac1+1:f_para.num_trains
            pc=pc+1;
            f_para.select_pairs(pc)=find(ti_row==min(f_para.select_trains([trac1 trac2])) & ti_col==max(f_para.select_trains([trac1 trac2])));
        end
    end
    f_para.num_select_pairs=length(f_para.select_pairs);
    d_para.mat_indy=nchoosek(1:d_para.num_trains,2);
    f_para.mat_indy=nchoosek(1:f_para.num_trains,2);
else
    m_para.memo_num_measures=0;
end


if m_para.memo_num_measures>0                                               % ##### disc & pico & pili #####
    if m_para.num_disc_measures>0
        event_num=1;
        sel_spikes=find([1 any(m_res.all_pos_spikes(f_para.select_trains,2:end-1)) 1]);
        all_cum_isi2=d_para.tmin+cumsum([0 m_res.all_isi]);
        sel_all_cum_isi2=all_cum_isi2(sel_spikes);
        first_winspike_ind2=find(sel_all_cum_isi2>=f_para.tmin,1,'first');
        last_winspike_ind2=find(sel_all_cum_isi2<=f_para.tmax,1,'last');
        win_cum_isi2=sel_all_cum_isi2(first_winspike_ind2:last_winspike_ind2);
        if first_winspike_ind2>1 && f_para.tmin<sel_all_cum_isi2(first_winspike_ind2)
            win_cum_isi2=[f_para.tmin win_cum_isi2];
            first_winspike_ind2=first_winspike_ind2-1;
        end
        if last_winspike_ind2<length(sel_all_cum_isi2) && f_para.tmax>sel_all_cum_isi2(last_winspike_ind2)
            win_cum_isi2=[win_cum_isi2 f_para.tmax];
            last_winspike_ind2=last_winspike_ind2+1;   % pico: num_isi instead of num_win_spikes
        end
        win_sel_spikes=sel_spikes(first_winspike_ind2:last_winspike_ind2);
        isi2=diff(win_cum_isi2);
        num_win_spikes=length(isi2)+1;
    end
    cum_isi2=d_para.tmin+cumsum([0 m_res.isi]);
    first_winspike_ind=find(cum_isi2>=f_para.tmin,1,'first');
    last_winspike_ind=find(cum_isi2<=f_para.tmax,1,'last');
    cum_isi=cum_isi2(first_winspike_ind:last_winspike_ind);
    if first_winspike_ind>1 && f_para.tmin<cum_isi2(first_winspike_ind)
        cum_isi=[f_para.tmin cum_isi];
        first_winspike_ind=first_winspike_ind-1;
    end
    if last_winspike_ind<length(cum_isi2) && f_para.tmax>cum_isi2(last_winspike_ind)
        cum_isi=[cum_isi f_para.tmax];
    else
        last_winspike_ind=last_winspike_ind-1;   % pico: num_isi instead of num_win_spikes
    end
    isi=diff(cum_isi);
    num_isi=length(isi);
    if m_para.num_pili_measures>0
        first_pili_supi_ind=find(m_res.pili_supi(1:2:end)>=f_para.tmin,1,'first')*2-1;
        last_pili_supi_ind=find(m_res.pili_supi(2:2:end)<=f_para.tmax,1,'last')*2;
        pili_supi=m_res.pili_supi(first_pili_supi_ind:last_pili_supi_ind);
        edges=0;
        if first_pili_supi_ind>1 && f_para.tmin<pili_supi(1)
            edges=edges+1;
            pili_supi=[f_para.tmin pili_supi(1) pili_supi];
        end
        if last_pili_supi_ind<length(m_res.pili_supi) && f_para.tmax>pili_supi(end)
            edges=edges+2;
            pili_supi=[pili_supi pili_supi(end) f_para.tmax];
        end
    end
end


num_profiles=mod(f_para.profile_mode,2)+sum(f_para.num_select_group_trains>1)*(f_para.profile_mode>1);
if m_para.num_sel_measures>0
    
    % #####################################################################################################################################
    % ######################################################### Pico- & pili-Profiles #####################################################
    % #####################################################################################################################################
    
    spike_diffs_realtime_l_ave=zeros(1,num_profiles);
    spike_diffs_forward_l_ave=zeros(1,num_profiles);
    
    if m_para.memo_num_measures>0                                               % ##### pico & pili #####
        
        if r_para.num_runs>1 || num_profiles>0
            if m_para.num_disc_measures>0
                num_spike_profiles=mod(f_para.profile_mode,2)+2*sum(f_para.num_select_group_trains>1)*(f_para.profile_mode>1);
                if f_para.select_measures(m_para.spikesync_disc)
                    spike_sync=zeros(num_spike_profiles,num_win_spikes);
                end
                if f_para.select_measures(m_para.spikeorder_disc)
                    spike_order=zeros(num_spike_profiles,num_win_spikes,'double');
                end
            end
            if m_para.num_pico_measures>0
                if f_para.select_measures(m_para.isi_pico)
                    isi_ratio=zeros(num_profiles,num_isi);
                end
            end
            if m_para.num_pili_measures>0
                if f_para.select_measures(m_para.spike_pili)
                    spike_diffs_l=zeros(num_profiles,2*num_isi);
                end
                if f_para.select_measures(m_para.realtime_spike_pili)
                    spike_diffs_realtime_l=zeros(num_profiles,2*num_isi);
                end
                if f_para.select_measures(m_para.forward_spike_pili)
                    spike_diffs_forward_l=zeros(num_profiles,2*num_isi);
                end
            end
        end
        
        if r_para.num_runs==1
            if mod(f_para.profile_mode,2)==1                     % All
                if m_para.num_disc_measures>0
                    if f_para.select_measures(m_para.spikesync_disc)
                        if sum(num_spikes)==0
                            if f_para.select_measures(m_para.spikesync_disc)
                                spike_sync=[1 1];
                            end
                            if f_para.select_measures(m_para.spikeorder_disc)
                                spike_order=[0 0];
                            end
                        elseif first_winspike_ind2==last_winspike_ind2-1
                            if f_para.select_measures(m_para.spikesync_disc)
                                spike_sync=[0 0];
                            end
                            if f_para.select_measures(m_para.spikeorder_disc)
                                spike_order=[0 0];
                            end
                        else
                            if f_para.select_measures(m_para.spikesync_disc)
                                spike_sync(1,1:num_win_spikes)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(m_para.spikesync_disc),...
                                    f_para.select_pairs,win_sel_spikes),1),1))/(f_para.num_trains-1);
                            end
                            if f_para.select_measures(m_para.spikeorder_disc)
                                spike_order(1,1:num_win_spikes)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(m_para.spikeorder_disc),...
                                    f_para.select_pairs,win_sel_spikes),1),1))/(f_para.num_trains-1);
                            end
                            edge_spikes=ismember([f_para.tmin f_para.tmax],[spikes{f_para.select_trains}]);
                            if ~ismember(win_cum_isi2(1),sel_all_cum_isi2(2:end-1)) && ~edge_spikes(1)
                                if f_para.select_measures(m_para.spikesync_disc)
                                    spike_sync(1,1)=spike_sync(1,2);
                                end
                                if f_para.select_measures(m_para.spikeorder_disc)
                                    spike_order(1,1)=spike_order(1,2);
                                end
                            elseif win_cum_isi2(1)~=sel_all_cum_isi2(1) || edge_spikes(1)
                                event_num=event_num+1;                          % spike at beginning
                            end
                            if ~ismember(win_cum_isi2(end),sel_all_cum_isi2(2:end-1)) && ~edge_spikes(2)
                                if f_para.select_measures(m_para.spikesync_disc)
                                    spike_sync(1,end)=spike_sync(1,end-1);
                                end
                                if f_para.select_measures(m_para.spikeorder_disc)
                                    spike_order(1,end)=spike_order(1,end-1);
                                end
                            elseif win_cum_isi2(end)~=sel_all_cum_isi2(end) || edge_spikes(2)
                                event_num=event_num+2;                          % spike at end
                            end
                        end
                    end
                end
                if m_para.num_pico_measures>0
                    if f_para.select_measures(m_para.isi_pico)
                        isi_ratio(1,1:num_isi)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(m_para.isi_pico),...
                            f_para.select_pairs,first_winspike_ind:last_winspike_ind),1),1);
                    end
                end
                if m_para.num_pili_measures>0
                    if f_para.select_measures([m_para.spike_pili])
                        spike_diffs_l(1,1:2*num_isi)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_pili),...
                            f_para.select_pairs,2*first_winspike_ind-1:2*last_winspike_ind),1),1);
                    end
                    if f_para.select_measures([m_para.realtime_spike_pili])
                        profi=shiftdim(m_res.pili_measures_mat(m_para.measure_indy(m_para.realtime_spike_pili),...
                            f_para.select_pairs,2*first_winspike_ind-1:2*last_winspike_ind),1);
                        spike_diffs_realtime_l(1,1:2*num_isi)=mean(profi,1);
                        odds=1:2:2*num_isi;
                        evens=odds+1;
                        aves=(log(1./profi(:,evens))-log(1./profi(:,odds)))./(1./profi(:,evens)-1./profi(:,odds));
                        aves(isnan(aves))=0;
                        spike_diffs_realtime_l_ave(1)=mean(sum(aves.*repmat(isi,f_para.num_select_pairs,1),2)/sum(isi));
                        clear profi
                    end
                    if f_para.select_measures([m_para.forward_spike_pili])
                        profi=shiftdim(m_res.pili_measures_mat(m_para.measure_indy(m_para.forward_spike_pili),...
                            f_para.select_pairs,2*first_winspike_ind-1:2*last_winspike_ind),1);
                        spike_diffs_forward_l(1,1:2*num_isi)=mean(profi,1);
                        odds=1:2:2*num_isi;
                        evens=odds+1;
                        aves=(log(1./profi(:,evens))-log(1./profi(:,odds)))./(1./profi(:,evens)-1./profi(:,odds));
                        aves(isnan(aves))=0;
                        spike_diffs_forward_l_ave(1)=mean(sum(aves.*repmat(isi,f_para.num_select_pairs,1),2)/sum(isi));
                        clear profi
                    end
                end
            end
            
            if f_para.profile_mode>1                            % Groups
                
                gsgz=mod(f_para.profile_mode,2);
                for sgc=1:f_para.num_select_train_groups
                    if f_para.num_select_group_trains(sgc)>1
                        gsgz=gsgz+1;
                        select_group=f_para.select_train_groups(sgc);
                        gm_indy=find(f_para.group_vect(d_para.mat_indy(:,1))==select_group & f_para.group_vect(d_para.mat_indy(:,2))==select_group & ...
                            ismember(d_para.mat_indy(:,1),f_para.select_trains)' & ismember(d_para.mat_indy(:,2),f_para.select_trains)');
                        if m_para.num_disc_measures>0
                            if f_para.select_measures(m_para.spikesync_disc)
                                if first_winspike_ind2==last_winspike_ind2
                                    if f_para.select_measures(m_para.spikesync_disc)
                                        spike_sync=[0 0];
                                    end
                                    if f_para.select_measures(m_para.spikeorder_disc)
                                        spike_order=[0 0];
                                    end
                                else
                                    gr_sel_spikes=find([1 any(m_res.all_pos_spikes(f_para.select_trains(f_para.select_group_vect==select_group),2:end-1)) 1]);
                                    dummindy=find(ismember(win_sel_spikes,gr_sel_spikes));
                                    %spike_sync(gsgz,dummindy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...    % ########
                                    %    m_para.spikesync_disc),gm_indy,gr_sel_spikes),1),1))/(f_para.num_select_group_trains(sgc)-1);
                                    if f_para.select_measures(m_para.spikesync_disc)
                                        spike_sync(gsgz,dummindy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...    % ########
                                            m_para.spikesync_disc),gm_indy,win_sel_spikes(dummindy)),1),1))/(f_para.num_select_group_trains(sgc)-1);
                                        spike_sync(sum(f_para.num_select_group_trains>1)+gsgz,dummindy)=1;
                                    end
                                    if f_para.select_measures(m_para.spikeorder_disc)
                                        spike_order(gsgz,dummindy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...    % ########
                                            m_para.spikeorder_disc),gm_indy,win_sel_spikes(dummindy)),1),1))/(f_para.num_select_group_trains(sgc)-1);
                                        spike_order(sum(f_para.num_select_group_trains>1)+gsgz,dummindy)=1;
                                    end
                                    edge_spikes=ismember([f_para.tmin f_para.tmax],[spikes{f_para.select_trains(f_para.select_group_vect==select_group)}]);
                                    if ~ismember(win_cum_isi2(dummindy(1)),sel_all_cum_isi2(2:end-1)) && ~edge_spikes(1)
                                        if f_para.select_measures(m_para.spikesync_disc)
                                            spike_sync(gsgz,dummindy(1))=spike_sync(gsgz,dummindy(2));
                                        end
                                        if f_para.select_measures(m_para.spikeorder_disc)
                                            spike_order(gsgz,dummindy(1))=spike_order(gsgz,dummindy(2));
                                        end
                                    elseif (win_cum_isi2(dummindy(1))~=sel_all_cum_isi2(1) || edge_spikes(2)) && f_para.profile_mode==2 && gsgz==mod(f_para.profile_mode,2)+1
                                        event_num=event_num+1;
                                    end
                                    if ~ismember(win_cum_isi2(dummindy(end)),sel_all_cum_isi2(2:end-1)) && ~edge_spikes(2)
                                        if f_para.select_measures(m_para.spikesync_disc)
                                            spike_sync(gsgz,dummindy(end))=spike_sync(gsgz,dummindy(end-1));
                                        end
                                        if f_para.select_measures(m_para.spikeorder_disc)
                                            spike_order(gsgz,dummindy(end))=spike_order(gsgz,dummindy(end-1));
                                        end
                                    elseif (win_cum_isi2(dummindy(end))~=sel_all_cum_isi2(end) || edge_spikes(2)) && f_para.profile_mode==2 && gsgz==mod(f_para.profile_mode,2)+1
                                        event_num=event_num+2;
                                    end
                                end
                            end
                        end
                        if m_para.num_pico_measures>0
                            if f_para.select_measures(m_para.isi_pico)
                                isi_ratio(gsgz,1:num_isi)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                                    m_para.isi_pico),gm_indy,first_winspike_ind:last_winspike_ind),1),1);
                            end
                        end
                        if m_para.num_pili_measures>0
                            if f_para.select_measures([m_para.spike_pili])
                                spike_diffs_l(gsgz,1:2*num_isi)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                                    m_para.spike_pili),gm_indy,2*first_winspike_ind-1:2*last_winspike_ind),1),1);
                            end
                            if f_para.select_measures([m_para.realtime_spike_pili])
                                profi=shiftdim(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                                    m_para.realtime_spike_pili),gm_indy,2*first_winspike_ind-1:2*last_winspike_ind),1));
                                spike_diffs_realtime_l(gsgz,1:2*num_isi)=mean(profi,1);
                                odds=1:2:2*num_isi;
                                evens=odds+1;
                                aves=(log(1./profi(:,evens))-log(1./profi(:,odds)))./(1./profi(:,evens)-1./profi(:,odds));
                                aves(isnan(aves))=0;
                                spike_diffs_realtime_l_ave(gsgz)=mean(sum(aves.*repmat(isi,length(gm_indy),1),2)/sum(isi));
                                clear profi
                            end
                            if f_para.select_measures([m_para.forward_spike_pili])
                                profi=shiftdim(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                                    m_para.forward_spike_pili),gm_indy,2*first_winspike_ind-1:2*last_winspike_ind),1));
                                spike_diffs_forward_l(gsgz,1:2*num_isi)=mean(profi,1);
                                odds=1:2:2*num_isi;
                                evens=odds+1;
                                aves=(log(1./profi(:,evens))-log(1./profi(:,odds)))./(1./profi(:,evens)-1./profi(:,odds));
                                aves(isnan(aves))=0;
                                spike_diffs_forward_l_ave(gsgz)=mean(sum(aves.*repmat(isi,length(gm_indy),1),2)/sum(isi));
                                clear profi
                            end
                        end
                    end
                end
            end
            
            if m_para.num_pili_measures>0
                if mod(edges,2)>0   % initial value in the middle of interspike interval
                    if f_para.select_measures([m_para.spike_pili])
                        spike_diffs_l(:,1)=spike_diffs_l(:,1)+(spike_diffs_l(:,2)-spike_diffs_l(:,1)).*...
                            repmat((f_para.tmin-m_res.pili_supi(first_pili_supi_ind-2))./...
                            (m_res.pili_supi(first_pili_supi_ind)-m_res.pili_supi(first_pili_supi_ind-2)),num_profiles,1);
                    end
                    if f_para.select_measures([m_para.realtime_spike_pili])   % linear approximation
                        spike_diffs_realtime_l(:,1)=spike_diffs_realtime_l(:,1)+(spike_diffs_realtime_l(:,2)-spike_diffs_realtime_l(:,1)).*...
                            repmat((f_para.tmin-m_res.pili_supi(first_pili_supi_ind-2))./...
                            (m_res.pili_supi(first_pili_supi_ind)-m_res.pili_supi(first_pili_supi_ind-2)),num_profiles,1);
                        
                    end
                    if f_para.select_measures([m_para.forward_spike_pili])   % linear approximation
                        spike_diffs_forward_l(:,1)=spike_diffs_forward_l(:,1)+(spike_diffs_forward_l(:,2)-spike_diffs_forward_l(:,1)).*...
                            repmat((f_para.tmin-m_res.pili_supi(first_pili_supi_ind-1))./...
                            (m_res.pili_supi(first_pili_supi_ind)-m_res.pili_supi(first_pili_supi_ind-1)),num_profiles,1);
                    end
                end
                if mod(edges,4)>1   % final value in the middle of interspike interval
                    if f_para.select_measures([m_para.spike_pili])
                        spike_diffs_l(:,2*num_isi)=spike_diffs_l(:,2*num_isi-1)+(spike_diffs_l(:,2*num_isi)-spike_diffs_l(:,2*num_isi-1)).*...
                            repmat((f_para.tmax-m_res.pili_supi(last_pili_supi_ind))./...
                            (m_res.pili_supi(last_pili_supi_ind+2)-m_res.pili_supi(last_pili_supi_ind)),num_profiles,1);
                    end
                    if f_para.select_measures([m_para.realtime_spike_pili])   % linear approximation
                        spike_diffs_realtime_l(:,2*num_isi)=spike_diffs_realtime_l(:,2*num_isi-1)+...
                            (spike_diffs_realtime_l(:,2*num_isi)-spike_diffs_realtime_l(:,2*num_isi-1)).*...
                            repmat((f_para.tmax-m_res.pili_supi(last_pili_supi_ind))./...
                            (m_res.pili_supi(last_pili_supi_ind+2)-m_res.pili_supi(last_pili_supi_ind)),num_profiles,1);
                    end
                    if f_para.select_measures([m_para.forward_spike_pili])   % linear approximation
                        spike_diffs_forward_l(:,2*num_isi)=spike_diffs_forward_l(:,2*num_isi-1)+...
                            (spike_diffs_forward_l(:,2*num_isi)-spike_diffs_forward_l(:,2*num_isi-1)).*...
                            repmat((f_para.tmax-m_res.pili_supi(last_pili_supi_ind))./...
                            (m_res.pili_supi(last_pili_supi_ind+2)-m_res.pili_supi(last_pili_supi_ind)),num_profiles,1);
                    end
                end
            end
        else
            if m_para.num_pico_measures+m_para.num_disc_measures>0
                min_ruc=find(m_res.cum_isi(r_para.run_pico_ends+1)>=f_para.tmin,1,'first');
                max_ruc=find(m_res.cum_isi(r_para.run_pico_ends+1)<=f_para.tmax,1,'last');
            else
                min_ruc=find(m_res.pili_supi(r_para.run_pili_ends)>=f_para.tmin,1,'first');
                max_ruc=find(m_res.pili_supi(r_para.run_pili_ends)<=f_para.tmax,1,'last');
            end
            
            num_runs=max_ruc-min_ruc+1;
            if num_runs>1
                disp(' ')
                disp(['Number of profile loop runs: ',num2str(num_runs)])
                pwbh = waitbar(0,'Large data set. Please be patient.','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
                setappdata(pwbh,'canceling',0)
            end
            for ruc=min_ruc:max_ruc
                
                if r_para.num_runs>1 && getappdata(pwbh,'canceling')
                    delete(pwbh)
                    return
                end
                if num_runs>1
                    if min_ruc~=1 || max_ruc~=r_para.num_runs
                        disp(['Profile-Loop-Info = ',num2str(ruc),'  (',num2str(r_para.num_runs),') --- ',...
                            num2str(ruc-min_ruc+1  ),'  (',num2str(max_ruc-min_ruc+1),')'])
                    else
                        disp(['Profile-Loop-Info = ',num2str(ruc),'  (',num2str(r_para.num_runs),')'])
                    end
                end
                if ruc~=r_para.ruc
                    if m_para.num_disc_measures>0
                        load(['SPIKY_AZBYCX' num2str(ruc)],['sl_disc_',num2str(ruc)]);
                        eval(['m_res.disc_measures_mat = sl_disc_',num2str(ruc),';']);
                        eval(['clear sl_disc_',num2str(ruc),';']);
                    end
                    if m_para.num_pico_measures>0
                        load(['SPIKY_AZBYCX' num2str(ruc)],['sl_pico_',num2str(ruc)]);
                        eval(['m_res.pico_measures_mat = sl_pico_',num2str(ruc),';']);
                        eval(['clear sl_pico_',num2str(ruc),';']);
                    end
                    if m_para.num_pili_measures>0
                        load(['SPIKY_AZBYCX' num2str(ruc)],['sl_pili_',num2str(ruc)]);
                        eval(['m_res.pili_measures_mat = sl_pili_',num2str(ruc),';']);
                        eval(['clear sl_pili_',num2str(ruc),';']);
                    end
                    r_para.ruc=ruc;
                    waitbar((ruc-min_ruc+1)/num_runs,pwbh,['Profile-Loop-Info: ',num2str(ruc-min_ruc+1),'  (',num2str(num_runs),')'])
                    if ruc==max_ruc
                        delete(pwbh)
                    end
                end
                
                if m_para.num_disc_measures>0
                    disc_load_run_indy=intersect(r_para.run_disc_starts(ruc):r_para.run_disc_ends(ruc),win_sel_spikes)-r_para.run_disc_starts(ruc)+1;
                    disc_prof_run_indy=(1:length(disc_load_run_indy))+find(win_sel_spikes>=r_para.run_disc_starts(ruc),1,'first')-1;
                end
                if m_para.num_pico_measures>0
                    pico_load_run_indy=(max([r_para.run_pico_starts(ruc) first_winspike_ind]):min(...
                        [r_para.run_pico_ends(ruc) last_winspike_ind]))-r_para.run_pico_starts(ruc)+1;
                    pico_prof_run_indy=pico_load_run_indy+r_para.run_pico_starts(ruc)-first_winspike_ind;
                end
                if m_para.num_pili_measures>0
                    pili_load_run_indy=(max([r_para.run_pili_starts(ruc) first_pili_supi_ind]):min(...
                        [r_para.run_pili_ends(ruc) last_pili_supi_ind]))-r_para.run_pili_starts(ruc)+1;
                    pili_prof_run_indy=pili_load_run_indy+r_para.run_pili_starts(ruc)-first_pili_supi_ind;
                end
                
                if mod(f_para.profile_mode,2)==1                     % All
                    if m_para.num_disc_measures>0
                        if f_para.select_measures(m_para.spikesync_disc)
                            if first_winspike_ind2==last_winspike_ind2-1
                                if f_para.select_measures(m_para.spikesync_disc)
                                    spike_sync=[0 0];
                                end
                                if f_para.select_measures(m_para.spikeorder_disc)
                                    spike_order=[0 0];
                                end
                            else
                                if f_para.select_measures(m_para.spikesync_disc)
                                    spike_sync(1,disc_prof_run_indy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...
                                        m_para.spikesync_disc),f_para.select_pairs,disc_load_run_indy),1),1))/(f_para.num_trains-1);
                                end
                                if f_para.select_measures(m_para.spikeorder_disc)
                                    spike_order(1,disc_prof_run_indy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...
                                        m_para.spikeorder_disc),f_para.select_pairs,disc_load_run_indy),1),1))/(f_para.num_trains-1);
                                end
                                edge_spikes=ismember([f_para.tmin f_para.tmax],[spikes{f_para.select_trains}]);
                                if ~ismember(win_cum_isi2(1),sel_all_cum_isi2) && ~edge_spikes(1)
                                    if f_para.select_measures(m_para.spikesync_disc)
                                        spike_sync(1,1)=spike_sync(1,2);
                                    end
                                    if f_para.select_measures(m_para.spikeorder_disc)
                                        spike_order(1,1)=spike_order(1,2);
                                    end
                                elseif win_cum_isi2(1)~=sel_all_cum_isi2(1) || (edge_spikes(1) && ruc==1)
                                    event_num=event_num+1;
                                end
                                if ~ismember(win_cum_isi2(end),sel_all_cum_isi2) && ~edge_spikes(2)
                                    if f_para.select_measures(m_para.spikesync_disc)
                                        spike_sync(1,end)=spike_sync(1,end-1);
                                    end
                                    if f_para.select_measures(m_para.spikeorder_disc)
                                        spike_order(1,end)=spike_order(1,end-1);
                                    end
                                elseif win_cum_isi2(end)~=sel_all_cum_isi2(end) || (edge_spikes(2) && ruc==1)
                                    event_num=event_num+2;
                                end
                            end
                        end
                    end
                    if m_para.num_pico_measures>0
                        if f_para.select_measures(m_para.isi_pico)
                            isi_ratio(1,pico_prof_run_indy)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                                m_para.isi_pico),f_para.select_pairs,pico_load_run_indy),1),1);
                        end
                    end
                    if m_para.num_pili_measures>0
                        if f_para.select_measures([m_para.spike_pili])
                            spike_diffs_l(1,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                                m_para.spike_pili),f_para.select_pairs,pili_load_run_indy),1),1);
                        end
                        if f_para.select_measures(m_para.realtime_spike_pili)
                            spike_diffs_realtime_l(1,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(m_para.realtime_spike_pili),...
                                f_para.select_pairs,pili_load_run_indy),1),1);
                            % spike_diffs_realtime_l_ave $$$$$$
                        end
                        if f_para.select_measures(m_para.forward_spike_pili)
                            spike_diffs_forward_l(1,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(m_para.forward_spike_pili),...
                                f_para.select_pairs,pili_load_run_indy),1),1);
                            % spike_diffs_forward_l_ave $$$$$$
                        end
                    end
                end
                
                if f_para.profile_mode>1                            % Groups
                    gsgz=mod(f_para.profile_mode,2);
                    for sgc=1:f_para.num_select_train_groups
                        if f_para.num_select_group_trains(sgc)>1
                            gsgz=gsgz+1;
                            select_group=f_para.select_train_groups(sgc);
                            gm_indy=find(f_para.group_vect(d_para.mat_indy(:,1))==select_group & f_para.group_vect(d_para.mat_indy(:,2))==select_group & ...
                                ismember(d_para.mat_indy(:,1),f_para.select_trains)' & ismember(d_para.mat_indy(:,2),f_para.select_trains)');
                            if m_para.num_disc_measures>0
                                gr_sel_spikes=find([1 any(m_res.all_pos_spikes(f_para.select_trains(f_para.select_group_vect==select_group),2:end-1)) 1]);
                                prof_dummindy=intersect(disc_prof_run_indy,find(ismember(win_sel_spikes,gr_sel_spikes)));
                                load_dummindy=win_sel_spikes(prof_dummindy)-r_para.run_disc_starts(ruc)+1;
                                if f_para.select_measures(m_para.spikesync_disc)
                                    spike_sync(gsgz,prof_dummindy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...
                                        m_para.spikesync_disc),gm_indy,load_dummindy),1),1))/(f_para.num_select_group_trains(sgc)-1);
                                    spike_sync(sum(f_para.num_select_group_trains>1)+gsgz,prof_dummindy)=1;
                                end
                                if f_para.select_measures(m_para.spikeorder_disc)
                                    spike_order(gsgz,prof_dummindy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...
                                        m_para.spikeorder_disc),gm_indy,load_dummindy),1),1))/(f_para.num_select_group_trains(sgc)-1);
                                    spike_order(sum(f_para.num_select_group_trains>1)+gsgz,prof_dummindy)=1;
                                end
                                edge_spikes=ismember([f_para.tmin f_para.tmax],[spikes{f_para.select_trains(f_para.select_group_vect==select_group)}]);
                                if ruc==1 && ~ismember(win_cum_isi2(prof_dummindy(1)),sel_all_cum_isi2(2:end-1)) && ~edge_spikes(1)
                                    if f_para.select_measures(m_para.spikesync_disc)
                                        spike_sync(gsgz,prof_dummindy(1))=spike_sync(gsgz,prof_dummindy(2));
                                    end
                                    if f_para.select_measures(m_para.spikeorder_disc)
                                        spike_order(gsgz,prof_dummindy(1))=spike_order(gsgz,prof_dummindy(2));
                                    end
                                elseif (win_cum_isi2(prof_dummindy(1))~=sel_all_cum_isi2(1) || (edge_spikes(1) && ruc==1)) && f_para.profile_mode==2 && gsgz==mod(f_para.profile_mode,2)+1
                                    event_num=event_num+1;
                                end
                                if ruc==r_para.num_runs && ~ismember(win_cum_isi2(prof_dummindy(end)),sel_all_cum_isi2(2:end-1)) && ~edge_spikes(2)
                                    if f_para.select_measures(m_para.spikesync_disc)
                                        spike_sync(gsgz,prof_dummindy(end))=spike_sync(gsgz,prof_dummindy(end-1));
                                    end
                                    if f_para.select_measures(m_para.spikeorder_disc)
                                        spike_order(gsgz,prof_dummindy(end))=spike_order(gsgz,prof_dummindy(end-1));
                                    end
                                elseif (win_cum_isi2(prof_dummindy(end))~=sel_all_cum_isi2(end) || (edge_spikes(2) && ruc==1)) && f_para.profile_mode==2 && gsgz==mod(f_para.profile_mode,2)+1
                                    event_num=event_num+2;
                                end
                            end
                            if m_para.num_pico_measures>0
                                if f_para.select_measures(m_para.isi_pico)
                                    isi_ratio(gsgz,pico_prof_run_indy)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                                        m_para.isi_pico),gm_indy,pico_load_run_indy),1),1);
                                end
                            end
                            
                            if m_para.num_pili_measures>0
                                if f_para.select_measures([m_para.spike_pili])
                                    spike_diffs_l(gsgz,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(...
                                        m_para.measure_indy(m_para.spike_pili),gm_indy,pili_load_run_indy),1),1);
                                end
                                if f_para.select_measures(m_para.realtime_spike_pili)
                                    spike_diffs_realtime_l(gsgz,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                                        m_para.realtime_spike_pili),gm_indy,pili_load_run_indy),1),1);
                                end
                                if f_para.select_measures(m_para.forward_spike_pili)
                                    spike_diffs_forward_l(gsgz,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                                        m_para.forward_spike_pili),gm_indy,pili_load_run_indy),1),1);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    % ##################################################################################################################################
    % ################################################################## PSTH ##########################################################
    % ##################################################################################################################################
    
    if f_para.select_measures(m_para.psth) && num_profiles>0
        bin_width=(f_para.tmax-f_para.tmin)/f_para.psth_num_bins;
        bins=f_para.tmin:bin_width:f_para.tmax;
        
        m_res.psth=zeros(num_profiles,f_para.psth_num_bins+1);
        if mod(f_para.profile_mode,2)==1
            for trac=1:f_para.num_trains
                if ~isempty(spikes{trac})
                    m_res.psth(1,1:f_para.psth_num_bins+1)=m_res.psth(1,1:f_para.psth_num_bins+1)+histc(spikes{trac},bins);
                end
            end
        end
        if f_para.profile_mode>1
            gsgz=mod(f_para.profile_mode,2);
            for sgc=1:f_para.num_select_train_groups
                if f_para.num_select_group_trains(sgc)>1
                    gsgz=gsgz+1;
                    select_group=f_para.select_train_groups(sgc);
                    for trac=find(f_para.select_group_vect==select_group)
                        m_res.psth(gsgz,1:f_para.psth_num_bins+1)=m_res.psth(gsgz,1:f_para.psth_num_bins+1)+histc(spikes{trac},bins);
                    end
                end
            end
        end
        m_res.psth=[m_res.psth(:,1:f_para.psth_num_bins-1) m_res.psth(:,f_para.psth_num_bins)+m_res.psth(:,f_para.psth_num_bins+1)]/bin_width;
        psth_norm=max(max(m_res.psth));
        m_res.psth=m_res.psth/(psth_norm+(psth_norm==0)); % ####
        if f_para.psth_window>0
            for proc=1:num_profiles
                m_res.psth(proc,:)=SPIKY_f_compute_gauss_smooth(m_res.psth(proc,:),f_para.psth_window)';
            end
        end
        results.PSTH.name='PSTH';
        results.PSTH.time=bins(1:f_para.psth_num_bins)+(bins(2)-bins(1))/2;
        results.PSTH.profile=m_res.psth;
    end
end

if m_para.num_sel_bi_measures>0
    if f_para.group_matrices && f_para.num_select_train_groups>1 && f_para.num_select_train_groups<f_para.num_trains
        grou_indy=triu(ones(f_para.num_trains),1);
        [ti_col2,ti_row2]=find(grou_indy');
    end
    SPIKY_loop_matrices
end


