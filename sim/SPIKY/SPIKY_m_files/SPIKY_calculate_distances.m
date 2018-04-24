% This calculates the selected time-resolved spike train distances once the button 'Calculate' is pressed.
% In case of very long datasets it also initiates the memory management.

disp(' '); disp(' ')

%
% ==================================
%  To do - List:
% ===============
% Stimulus
% reset in STG
% Movie (new Matlab-function)
% Poisson line (--> Significance paper)
% More than 2 measures and only matrices in frame comparison
% FB-STG: Edit Replace - Delete
% Permanently store new subplot positions #######
% different orders of moving average for different measures (due to their different time scales)
% ==================================
%

m_para.all_measures_str={'Stimulus';'Spikes';'PS';'I';'S';'S_r';'S_f';'C';'D';'S_N';'S^A';'S_{NE}';'Si';'Si_r';'Si_f';'Sd';'Sd_N';'Sd_E';'Sd_{NE}';'V';'R'};
m_para.all_measures_string={'Stimulus';'Spikes';'PSTH';'ISI';'SPIKE';'SPIKE_realtime';'SPIKE_forward';'SPIKE_synchro';'SPIKE_order';...
    'SPIKE_N';'SPIKE_E';'SPIKE_NE';'SPIKEi';'SPIKEi_realtime';'SPIKEi_forward';'SPIKE_disc';'SPIKE_disc_N';'SPIKE_disc_E';'SPIKE_disc_NE';'Victor';'vanRossum'};

m_para.num_diff_measures=2;
m_para.num_non_bi_measures=3;

m_para.stimulus=1;
m_para.spikes=2;
m_para.psth=3;
m_para.isi_pico=4;
m_para.spike_pili=5;
m_para.realtime_spike_pili=6;
m_para.forward_spike_pili=7;
m_para.spikesync_disc=8;
m_para.spikeorder_disc=9;
m_para.spike_neb_pili=10;
m_para.spike_eero_pili=11;
m_para.spike_neb_eero_pili=12;
m_para.spike_pico=13;
m_para.realtime_spike_pico=14;
m_para.forward_spike_pico=15;
m_para.spike_disc=16;
m_para.spike_neb_disc=17;
m_para.spike_eero_disc=18;
m_para.spike_neb_eero_disc=19;
m_para.victor=20;
m_para.van_rossum=21;

m_para.disc_measures=[m_para.spikesync_disc m_para.spikeorder_disc m_para.spike_disc m_para.spike_neb_disc m_para.spike_eero_disc m_para.spike_neb_eero_disc];
m_para.pico_measures=[m_para.isi_pico m_para.spike_pico m_para.realtime_spike_pico m_para.forward_spike_pico];
m_para.pili_measures=[m_para.spike_pili m_para.realtime_spike_pili m_para.forward_spike_pili m_para.spike_neb_pili m_para.spike_eero_pili m_para.spike_neb_eero_pili];
m_para.spike_measures=[m_para.spike_pili m_para.spike_neb_pili m_para.spike_eero_pili m_para.spike_neb_eero_pili m_para.spike_disc m_para.spike_neb_disc m_para.spike_eero_disc m_para.spike_neb_eero_disc];   % ##############
m_para.realtime_measures=[m_para.realtime_spike_pico m_para.realtime_spike_pili];
m_para.forward_measures=[m_para.forward_spike_pico m_para.forward_spike_pili];
m_para.bi_measures=[m_para.disc_measures m_para.pico_measures m_para.pili_measures];
m_para.cont_bi_measures=[m_para.pico_measures m_para.pili_measures];                            % continuous bivariate measures
m_para.inv_bi_measures=m_para.spikesync_disc;                                                   % inverse bivariate measures
m_para.asym_bi_measures=m_para.spikeorder_disc;                                                 % asymmetric bivariate measures

f_para.subplot_posi(m_para.stimulus)=str2num(get(handles.subplot_stimulus_posi_edit,'String'));
f_para.subplot_posi(m_para.spikes)=str2num(get(handles.subplot_spikes_posi_edit,'String'));
f_para.subplot_posi(m_para.psth)=str2num(get(handles.subplot_psth_posi_edit,'String'));
f_para.subplot_posi(m_para.isi_pico)=str2num(get(handles.subplot_isi_posi_edit,'String'));
f_para.subplot_posi(m_para.spike_pili)=str2num(get(handles.subplot_spike_posi_edit,'String'));
f_para.subplot_posi(m_para.realtime_spike_pili)=str2num(get(handles.subplot_spike_realtime_posi_edit,'String'));
f_para.subplot_posi(m_para.forward_spike_pili)=str2num(get(handles.subplot_spike_forward_posi_edit,'String'));
f_para.subplot_posi(m_para.spikesync_disc)=str2num(get(handles.subplot_spikesync_posi_edit,'String'));
f_para.subplot_posi(m_para.spikeorder_disc)=str2num(get(handles.subplot_spikeorder_posi_edit,'String'));

if f_para.subplot_posi(m_para.spike_disc)>0
    f_para.subplot_posi(m_para.spike_pili)=f_para.subplot_posi(m_para.spike_disc);
end
m_para.as_vect=SPIKY_f_all_sorted(f_para.subplot_posi);    % position number, not just 0 and 1
if ~all(m_para.as_vect==f_para.subplot_posi)
    f_para.subplot_posi=m_para.as_vect;
    set(handles.subplot_stimulus_posi_edit,'String',num2str(f_para.subplot_posi(m_para.stimulus)))
    set(handles.subplot_spikes_posi_edit,'String',num2str(f_para.subplot_posi(m_para.spikes)))
    set(handles.subplot_psth_posi_edit,'String',num2str(f_para.subplot_posi(m_para.psth)))
    set(handles.subplot_isi_posi_edit,'String',num2str(f_para.subplot_posi(m_para.isi_pico)))
    set(handles.subplot_spike_posi_edit,'String',num2str(f_para.subplot_posi(m_para.spike_pili)))
    set(handles.subplot_spike_realtime_posi_edit,'String',num2str(f_para.subplot_posi(m_para.realtime_spike_pili)))
    set(handles.subplot_spike_forward_posi_edit,'String',num2str(f_para.subplot_posi(m_para.forward_spike_pili)))
    set(handles.subplot_spikesync_posi_edit,'String',num2str(f_para.subplot_posi(m_para.spikesync_disc)))
    set(handles.subplot_spikeorder_posi_edit,'String',num2str(f_para.subplot_posi(m_para.spikeorder_disc)))
end

m_para.num_all_measures=length(f_para.subplot_posi);
select_measures=intersect(m_para.num_diff_measures+1:m_para.num_all_measures,find(f_para.subplot_posi));
[dummy,ms_indy]=sort(f_para.subplot_posi(select_measures));
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
m_para.measure_indy(m_para.disc_measures)=SPIKY_f_all_sorted(f_para.subplot_posi(m_para.disc_measures));
m_para.measure_indy(m_para.pico_measures)=SPIKY_f_all_sorted(f_para.subplot_posi(m_para.pico_measures));
m_para.measure_indy(m_para.pili_measures)=SPIKY_f_all_sorted(f_para.subplot_posi(m_para.pili_measures));

aaa=f_para.subplot_posi(m_para.num_diff_measures+1:m_para.num_all_measures);
bbb=aaa+(1:(m_para.num_all_measures-m_para.num_diff_measures))/(m_para.num_all_measures-m_para.num_diff_measures+1);
bbb(bbb<1)=0;
m_para.measure_all_indy=[zeros(1,m_para.num_diff_measures) SPIKY_f_all_sorted(bbb)];

ccc=aaa(aaa>0)-min(aaa(aaa>0))+1;
[dummy,eee]=sort(ccc);
fff=find(aaa);
m_res.mat_str=m_para.all_measures_str(m_para.num_diff_measures+fff(eee));

aaa=f_para.subplot_posi(m_para.num_non_bi_measures+1:m_para.num_all_measures);
bbb=aaa+(1:(m_para.num_all_measures-m_para.num_non_bi_measures))/(m_para.num_all_measures-m_para.num_non_bi_measures+1);
bbb(bbb<1)=0;
m_para.measure_bi_indy=[zeros(1,m_para.num_non_bi_measures) SPIKY_f_all_sorted(bbb)];
%m_res.mat_str=m_para.all_measures_str(m_para.num_diff_measures+m_para.measure_all_indy(m_para.measure_all_indy>0));

ccc=aaa(aaa>0)-min(aaa(aaa>0))+1;
[ddd,eee]=sort(ccc);
fff=find(aaa);
m_res.bi_mat_str=m_para.all_measures_str(m_para.num_non_bi_measures+fff(eee));

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

if str2double(get(handles.dpara_tmin_edit,'String'))>=str2double(get(handles.dpara_tmax_edit,'String'))
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('The beginning of the recording can not be later\nthan the end of the recording!'),'Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    set(handles.dpara_tmin_edit,'String',num2str(d_para.tmin))
    set(handles.dpara_tmax_edit,'String',num2str(d_para.tmax))
    ret=1;
    return;
end

uspikes=cell(1,d_para.num_trains);
for trac=1:d_para.num_trains
    uspikes{trac}=spikes{trac}(spikes{trac}>=d_para.tmin-100*eps & spikes{trac}<=d_para.tmax+100*eps);
    uspikes{trac}=unique([d_para.tmin uspikes{trac} d_para.tmax]);
end
num_uspikes=cellfun('length',uspikes);
max_num_uspikes=max(num_uspikes);

% #########################################################################
% ######################################################################### Victor, van Rossum (currently not included!)
% #########################################################################

if f_para.subplot_posi(m_para.victor)
    q=[0 5 10];
    m_res.vic=zeros(length(q),d_para.num_trains,d_para.num_trains);
    for trac1=1:d_para.num_trains-1
        for trac2=trac1+1:d_para.num_trains
            m_res.vic(:,trac1,trac2)=SPIKY_Victor_MEX(spikes{trac1},spikes{trac2},q);
            m_res.vic(1:length(q),trac2,trac1)=m_res.vic(1:length(q),trac1,trac2);
        end
    end
end
if f_para.subplot_posi(m_para.van_rossum)   % still problematic !!!!!!!
    tau=1;
    m_res.vr=zeros(length(tau),d_para.num_trains,d_para.num_trains);
    for tauc=1:length(tau)
        for trac1=1:d_para.num_trains-1
            for trac2=trac1+1:d_para.num_trains
                m_res.vr(tauc,trac1,trac2)=SPIKY_vanRossum(spikes{trac1}/d_para.tmax*2,spikes{trac2}/d_para.tmax*2,tau*2);
            end
        end
        m_res.vr(tauc,:,:)=shiftdim(m_res.vr(tauc,:,:),1)+shiftdim(m_res.vr(tauc,:,:),1)';
    end
end

% #########################################################################
% #########################################################################
% #########################################################################


if any(f_para.subplot_posi(m_para.num_non_bi_measures+1:m_para.num_all_measures))                                                        % ISI-SPIKE-SPIKEsync
    non_empties=find(cellfun('length',spikes)>0);
    tmin_spikes=non_empties(abs(cellfun(@(v) v(1), spikes(cellfun('length',spikes)>0))-d_para.tmin)<1e-20);
    tmax_spikes=non_empties(abs(cellfun(@(v) v(end), spikes(cellfun('length',spikes)>0))-d_para.tmax)<1e-20);
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
    
    m_para.memo_num_measures=2*m_para.num_pili_measures+m_para.num_pico_measures+m_para.num_disc_measures;
    memo_fact=m_para.memo_num_measures*d_para.num_pairs;
    memo=memo_fact*m_res.num_isi;
    
    if f_para.run_test==0 || ~ismember(get(handles.Data_listbox,'Value'),[1 2 3 10 13])
        max_memo=d_para.max_memo_init;
    elseif ismember(get(handles.Data_listbox,'Value'),f_para.offset+[1 4 10 13])
        max_memo=16;
    elseif ismember(get(handles.Data_listbox,'Value'),f_para.offset+[2 3])
        max_memo=400;
    end
    
    r_para.num_runs=1;
    if memo>max_memo
        num_init_runs=ceil(memo/max_memo);
        if f_para.run_test==0 || ~ismember(get(handles.Data_listbox,'Value'),f_para.offset+[1 2 3 4 10 13])
            max_pico_len=ceil(m_res.num_isi/num_init_runs);
        else
            max_pico_len=max_memo;
        end
        while rem(m_res.num_isi,max_pico_len)==1
            max_pico_len=max_pico_len-1;
        end
        
        if m_para.memo_num_measures>0
            r_para.num_runs=ceil(m_res.num_isi/max_pico_len);
            if r_para.num_runs==0
                set(0,'DefaultUIControlFontSize',16);
                mbh=msgbox(sprintf('Dataset might be too large.\nPlease increase the value of the variable\n ''d_para.max_memo_init'' in ''SPIKY_f_user_interface'' !!!'),'Warning','warn','modal');
                htxt = findobj(mbh,'Type','text');
                set(htxt,'FontSize',12,'FontWeight','bold')
                mb_pos=get(mbh,'Position');
                set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                uiwait(mbh);
                ret=1;
                return
            end
        end
        
        r_para.run_pico_ends=cumsum(fix([max_pico_len*ones(1,r_para.num_runs-1) m_res.num_isi-max_pico_len*(r_para.num_runs-1)]));    % ISI
        r_para.run_pico_starts=[1 r_para.run_pico_ends(1:end-1)+1];
        r_para.run_pico_lengths=r_para.run_pico_ends-r_para.run_pico_starts+1;
        if m_para.num_disc_measures>0    % SPIKE-Sync
            r_para.run_disc_ends=zeros(1,r_para.num_runs);
            for ruc=1:r_para.num_runs
                r_para.run_disc_ends(ruc)=find(all_spikes==m_res.cum_isi(r_para.run_pico_ends(ruc)+1),1,'first');
            end
            r_para.run_disc_starts=[1 r_para.run_disc_ends(1:end-1)+1];
            r_para.run_disc_lengths=r_para.run_disc_ends-r_para.run_disc_starts+1;
        end
        if m_para.num_pili_measures>0   % SPIKE
            r_para.run_pili_ends=2*r_para.run_pico_ends;
            r_para.run_pili_starts=[1 r_para.run_pili_ends(1:end-1)+1];
            r_para.run_pili_lengths=r_para.run_pili_ends-r_para.run_pili_starts+1;
        end
    end
    %r_para
    
    if r_para.num_runs==1
        r_para.run_pico_lengths=m_res.num_isi;
        r_para.run_pico_starts=1;
        r_para.run_pico_ends=m_res.num_isi;
        if m_para.num_disc_measures>0
            r_para.run_disc_lengths=m_res.num_all_isi+1;   % = num_all_spikes
            r_para.run_disc_starts=1;
            r_para.run_disc_ends=r_para.run_disc_lengths;
        end
        if m_para.num_pili_measures>0
            r_para.run_pili_lengths=2*m_res.num_isi;
            r_para.run_pili_starts=1;
            r_para.run_pili_ends=2*m_res.num_isi;
        end
    end
    
    
% ##################################### cSPIKE ###############################
%    InitializecSPIKE;
%    STS = SpikeTrainSet(spikes,d_para.tmin,d_para.tmax);
%    
%     if f_para.subplot_posi(m_para.isi_pico)                        % ISI
%         for samc=1:r_para.run_pico_lengths(ruc)
%             ddd=STS.ISIdistanceMatrix(m_res.cum_isi(r_para.run_pico_starts-1+samc));
%             ddd=ddd(logical(tril(ones(d_para.num_trains),-1)));
%             m_res.pili_measures_mat(m_para.measure_indy(m_para.isi_pico),1:d_para.num_pairs,samc)=ddd';
%         end
%     end
%    
%    if f_para.subplot_posi(m_para.spike_pili)                                                   % SPIKE-pili
%         for samc=1:2:r_para.run_pili_lengths
%             ddd=STS.SPIKEdistanceMatrix(m_res.pili_supi(r_para.run_pili_starts-1+samc));
%             ddd=ddd(logical(tril(ones(d_para.num_trains),-1)));
%             m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_pili),1:d_para.num_pairs,samc)=ddd';
%         end
%         for samc=2:2:r_para.run_pili_lengths
%             ddd=STS.SPIKEdistanceMatrix(m_res.pili_supi(r_para.run_pili_starts-1+samc)-1e-13);
%             ddd=ddd(logical(tril(ones(d_para.num_trains),-1)));
%             m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_pili),1:d_para.num_pairs,samc)=ddd;
%         end
%    end
% ##################################### cSPIKE ###############################
    
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
                    if  spikes{trac}(end)<uspikes{trac}(end)
                        fl_isis{trac}(3:4)=diff(uspikes{trac}(end-2:end));
                    end
                end
            end
        end
        if any(f_para.subplot_posi([m_para.spike_pico m_para.realtime_spike_pico m_para.spike_pili m_para.realtime_spike_pili]))
            prev_edge_cor_indy=cell(1,d_para.num_trains);
        end
        if any(f_para.subplot_posi([m_para.spike_pico m_para.forward_spike_pico m_para.spike_pili m_para.forward_spike_pili]))
            foll_edge_cor_indy=cell(1,d_para.num_trains);
        end
    end
    
    uspikes2=cell(1,d_para.num_trains);
    for trac=1:d_para.num_trains
        uspikes2{trac}=spikes{trac}(spikes{trac}>=d_para.tmin-100*eps & spikes{trac}<=d_para.tmax+100*eps);
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
    r_para.ruc_initial=1;
    r_para.ruc_final=r_para.num_runs;
    for ruc=r_para.ruc_initial:r_para.ruc_final
        if r_para.num_runs>1 && getappdata(pwbh,'canceling')
            delete(pwbh)
            ret=1;
            return
        end
        
        % ###########################################################################################################################################
        % ################################################################# Pico-pili-Quantities #####################################################
        % ###########################################################################################################################################
        
        if any(f_para.subplot_posi(m_para.bi_measures))
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
        if exist(['SPIKY_udists_MEX.',mexext],'file')
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
                    run_udists{trac,trac2}(1)=min(abs(run_uspikes{trac}(1)-uspikes2{trac2}));
                    run_udists{trac,trac2}(end)=min(abs(run_uspikes{trac}(end)-uspikes2{trac2}));
                end
            end
        end
        
        if any(f_para.subplot_posi([m_para.spikesync_disc m_para.isi_pico m_para.spike_pili m_para.spike_disc]))
            isis=cell(1,d_para.num_trains);
            ints=zeros(d_para.num_trains,r_para.run_pico_lengths(ruc));
            for trac=1:d_para.num_trains
                isis{trac}=diff(run_uspikes{trac});
                for ic=1:run_num_ints(trac)
                    ints(trac,run_ivs{trac}(ic):run_ive{trac}(ic))=isis{trac}(ic);
                end
            end
        end
        
        if any(f_para.subplot_posi([m_para.spike_pico m_para.realtime_spike_pico m_para.spike_pili m_para.realtime_spike_pili m_para.spike_disc])) % SPIKE-Pre-Pico
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
            
            if any(f_para.subplot_posi([m_para.spike_pili m_para.realtime_spike_pili]))                     % SPIKE-Pre-pili
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
        
        if any(f_para.subplot_posi([m_para.spike_pico m_para.forward_spike_pico m_para.spike_pili m_para.forward_spike_pili]))  % SPIKE-Forward-Pico
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
            
            if any(f_para.subplot_posi([m_para.spike_pili m_para.forward_spike_pili]))                       % SPIKE-forward-pili
                foll_spikes_indy_pili=zeros(d_para.num_trains,r_para.run_pili_lengths(ruc),'uint32'); % two values at start/end of each interval of pooled spike train: index of following uspike in that spike train
                foll_spikes_pili=zeros(d_para.num_trains,r_para.run_pili_lengths(ruc)); % two values at start/end of each interval of pooled spike train: distance to following uspike in that spike train
                for trac=1:d_para.num_trains
                    foll_spikes_indy_pili(trac,:)=reshape(repmat(foll_spikes_indy(trac,1:r_para.run_pico_lengths(ruc)),2,1),1,r_para.run_pili_lengths(ruc));
                    foll_spikes_pili(trac,:)=reshape([foll_spikes(trac,1:r_para.run_pico_lengths(ruc)); foll_spikes(trac,1:r_para.run_pico_lengths(ruc))],...
                        1,r_para.run_pili_lengths(ruc))-m_res.pili_supi(r_para.run_pili_starts(ruc):r_para.run_pili_ends(ruc));
                end
            end
        end
        
        % #####################################################################################################################################
        % ############################################################ [ pili-Measures ] #####################################################
        % #####################################################################################################################################
        
        if m_para.num_pili_measures>0
            odds=1:2:r_para.run_pili_lengths(ruc);
            evens=odds+1;
            m_res.pili_measures_mat=zeros(m_para.num_pili_measures,d_para.num_pairs,r_para.run_pili_lengths(ruc));
            
            if f_para.subplot_posi(m_para.realtime_spike_pili)                                           % REALTIME-pili
                if exist(['SPIKY_realtimeSPIKE_MEX2.',mexext],'file')
                    m_res.pili_measures_mat(m_para.measure_indy(m_para.realtime_spike_pili),1:d_para.num_pairs,1:r_para.run_pili_lengths(ruc)) = ...
                        SPIKY_realtimeSPIKE_MEX2(int32(d_para.num_pairs),int32(r_para.run_pili_lengths(ruc)),int32(d_para.num_trains),...
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
            
            if f_para.subplot_posi(m_para.forward_spike_pili)                                             % FORWARD-pili
                
                if exist(['SPIKY_forwardSPIKE_MEX2.',mexext],'file')
                    m_res.pili_measures_mat(m_para.measure_indy(m_para.forward_spike_pili),1:d_para.num_pairs,1:r_para.run_pili_lengths(ruc)) = ...
                        SPIKY_forwardSPIKE_MEX2(int32(d_para.num_pairs),int32(r_para.run_pili_lengths(ruc)),int32(d_para.num_trains),...
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
            
            if any(f_para.subplot_posi(m_para.spike_measures))                                                   % any SPIKE-measure
                
                if f_para.edge_correction                                  % Edge-correction for SPIKE-distance
                    for trac=1:d_para.num_trains
                        if num_uspikes(trac)>2       % protection against empty spike trains
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
                isi_indy_pili=reshape(repmat(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc),2,1),1,2*r_para.run_pico_lengths(ruc))-...
                    r_para.run_pico_starts(ruc)+1;
                
                if any(f_para.subplot_posi([m_para.spike_eero_pili m_para.spike_neb_eero_pili]))      % Eero-correction
                    ints2=ints;
                    if f_para.isi_thr>=0
                        if f_para.isi_thr==0
                            f_para.isi_thr = sqrt(mean([isis{:}].^2))*2;  % if threshold==0 then set automatically ######################################
                        end
                        ints2(ints<f_para.isi_thr)=f_para.isi_thr;
                    end
                end
                
                if f_para.subplot_posi(m_para.spike_pili)                                                   % SPIKE-pili
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
                                    ((ints(trac1,isi_indy_pili)+ints(trac2,isi_indy_pili)).*...
                                    (ints(trac1,isi_indy_pili)+ints(trac2,isi_indy_pili))/2);
                            end
                        end
                    end
                    ave_bi_vect(logical(m_para.select_bi_measures==m_para.spike_pili),:)=...
                        ave_bi_vect(logical(m_para.select_bi_measures==m_para.spike_pili),:)+...
                        sum((m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_pili),:,odds)+...
                        m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_pili),:,evens))/2.*...
                        repmat(shiftdim(m_res.isi(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc)),-1),[1,d_para.num_pairs]),3);
                end
                
                if f_para.subplot_posi(m_para.spike_neb_pili)                                                   % SPIKE-Neb-pili
                    if exist(['SPIKY_SPIKE_Neb_MEX.',mexext],'file')
                        m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_neb_pili),1:d_para.num_pairs,1:r_para.run_pili_lengths(ruc)) = ...
                            SPIKY_SPIKE_Neb_MEX(int32(d_para.num_pairs),int32(r_para.run_pili_lengths(ruc)),int32(d_para.num_trains),...
                            foll_spikes_pili,prev_spikes_pili,int32(isi_indy_pili-1),int32(prev_spikes_indy_pili),int32(foll_spikes_indy_pili),...
                            ints,run_udists);
                    else
                        disp('Neb not available!')
                    end
                    ave_bi_vect(logical(m_para.select_bi_measures==m_para.spike_neb_pili),:)=...
                        ave_bi_vect(logical(m_para.select_bi_measures==m_para.spike_neb_pili),:)+...
                        sum((m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_neb_pili),:,odds)+...
                        m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_neb_pili),:,evens))/2.*...
                        repmat(shiftdim(m_res.isi(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc)),-1),[1,d_para.num_pairs]),3);
                end
                
                if f_para.subplot_posi(m_para.spike_eero_pili)                                                   % SPIKE-Eero-pili
                    if exist(['SPIKY_SPIKE_Eero_MEX.',mexext],'file')
                        m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_eero_pili),1:d_para.num_pairs,1:r_para.run_pili_lengths(ruc)) = ...
                            SPIKY_SPIKE_Eero_MEX(int32(d_para.num_pairs),int32(r_para.run_pili_lengths(ruc)),int32(d_para.num_trains),...
                            foll_spikes_pili,prev_spikes_pili,int32(isi_indy_pili-1),int32(prev_spikes_indy_pili),int32(foll_spikes_indy_pili),...
                            ints,ints2,run_udists);
                    else
                        disp('Eero not available!')
                    end
                    ave_bi_vect(logical(m_para.select_bi_measures==m_para.spike_eero_pili),:)=...
                        ave_bi_vect(logical(m_para.select_bi_measures==m_para.spike_eero_pili),:)+...
                        sum((m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_eero_pili),:,odds)+...
                        m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_eero_pili),:,evens))/2.*...
                        repmat(shiftdim(m_res.isi(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc)),-1),[1,d_para.num_pairs]),3);
                end
                
                if f_para.subplot_posi(m_para.spike_neb_eero_pili)                                                   % SPIKE-Neb-Eero-pili
                    if exist(['SPIKY_SPIKE_Neb_Eero_MEX.',mexext],'file')
                        m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_neb_eero_pili),1:d_para.num_pairs,1:r_para.run_pili_lengths(ruc)) = ...
                            SPIKY_SPIKE_Neb_Eero_MEX(int32(d_para.num_pairs),int32(r_para.run_pili_lengths(ruc)),int32(d_para.num_trains),...
                            foll_spikes_pili,prev_spikes_pili,int32(isi_indy_pili-1),int32(prev_spikes_indy_pili),int32(foll_spikes_indy_pili),...
                            ints,ints2,run_udists);
                    else
                        disp('Neb-Eero not available!')
                    end
                    ave_bi_vect(logical(m_para.select_bi_measures==m_para.spike_neb_eero_pili),:)=...
                        ave_bi_vect(logical(m_para.select_bi_measures==m_para.spike_neb_eero_pili),:)+...
                        sum((m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_neb_eero_pili),:,odds)+...
                        m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_neb_eero_pili),:,evens))/2.*...
                        repmat(shiftdim(m_res.isi(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc)),-1),[1,d_para.num_pairs]),3);
                end
            end
        end
        clear isis
        
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
            
            if f_para.subplot_posi(m_para.spikesync_disc) || f_para.subplot_posi(m_para.spikeorder_disc)
                if ruc==r_para.ruc_initial
                    if f_para.subplot_posi(m_para.spikesync_disc)
                        spike_synchro=cell(1,d_para.num_pairs);
                    end
                    if f_para.subplot_posi(m_para.spikeorder_disc)
                        spike_order=cell(1,d_para.num_pairs);
                    end
                end
                if sum(num_spikes)>0
                    if f_para.subplot_posi(m_para.spikesync_disc)
                        norm_spike_synchro=zeros(d_para.num_pairs,r_para.run_disc_lengths(ruc));
                    end
                    if f_para.subplot_posi(m_para.spikeorder_disc)
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
                                            spike_synchro=SPIKY_SPIKEsynchro_MEX(int32(d_para.num_trains),int32(d_para.num_spikes),spikes);
                                        end
                                    else
                                        if f_para.subplot_posi(m_para.spikesync_disc)
                                            spike_synchro{pac}=zeros(1,num_pair_all_spikes(pac));
                                        end
                                        if f_para.subplot_posi(m_para.spikeorder_disc)
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
                                                    if f_para.subplot_posi(m_para.spikesync_disc)
                                                        spike_synchro{pac}(logical(pair_spike1==pair_all_spikes))=1;
                                                        spike_synchro{pac}(logical(pair_spike2==pair_all_spikes))=1;
                                                    end
                                                    if f_para.subplot_posi(m_para.spikeorder_disc)
                                                        if pair_spike1<pair_spike2
                                                            spike_order{pac}(logical(pair_spike1==pair_all_spikes))=1; % 1 l    positive: 1,2; 1:leading spike
                                                            spike_order{pac}(logical(pair_spike2==pair_all_spikes))=1; % 2 f    positive: 1,2; 2:following spike
                                                        elseif pair_spike1>pair_spike2
                                                            spike_order{pac}(logical(pair_spike2==pair_all_spikes))=-1;  % -1 l  negative:2,1; 1:leading spike
                                                            spike_order{pac}(logical(pair_spike1==pair_all_spikes))=-1; % -2 f   negative:2,1; 2:following spike
                                                        end
%                                                         if pair_spike1<pair_spike2
%                                                             spike_order{pac}(logical(pair_spike1==pair_all_spikes))=1; % 1 l    positive: 1,2; 1:leading spike
%                                                             spike_order{pac}(logical(pair_spike2==pair_all_spikes))=-1; % 2 f    positive: 1,2; 2:following spike
%                                                         elseif pair_spike1>pair_spike2
%                                                             spike_order{pac}(logical(pair_spike2==pair_all_spikes))=1;  % -1 l  negative:2,1; 1:leading spike
%                                                             spike_order{pac}(logical(pair_spike1==pair_all_spikes))=-1; % -2 f   negative:2,1; 2:following spike
%                                                         end
                                                    end
%                                                     if pair_spike1<pair_spike2 && train1<train2 % first spike train spikes first
%                                                         spike_order{pac}(logical(pair_spike1==pair_all_spikes))=1; % 1 l    positive: 1,2; 1:leading spike
%                                                         spike_order{pac}(logical(pair_spike2==pair_all_spikes))=2; % 2 f    positive: 1,2; 2:following spike
%                                                     elseif pair_spike2<pair_spike1 && train2<train1 % first spike train spikes first
%                                                         spike_order{pac}(logical(pair_spike2==pair_all_spikes))=1; % 1 l    positive: 1,2; 1:leading spike
%                                                         spike_order{pac}(logical(pair_spike1==pair_all_spikes))=2; % 2 f    positive: 1,2; 2:following spike
%                                                     elseif pair_spike1>pair_spike2 && train1<train2 % second spike train spikes first
%                                                         spike_order{pac}(logical(pair_spike2==pair_all_spikes))=-1;  % -1 l  negative:2,1; 1:leading spike
%                                                         spike_order{pac}(logical(pair_spike1==pair_all_spikes))=-2; % -2 f   negative:2,1; 2:following spike
%                                                     elseif pair_spike2>pair_spike1 && train2<train1 % second spike train spikes first
%                                                         spike_order{pac}(logical(pair_spike1==pair_all_spikes))=-1;  % -1 l  negative:2,1; 1:leading spike
%                                                         spike_order{pac}(logical(pair_spike2==pair_all_spikes))=-2; % -2 f   negative:2,1; 2:following spike
%                                                     end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if num_pair_all_spikes(pac)>0
                                run_all_pos_spikes=m_res.all_pos_spikes([trac1 trac2],r_para.run_disc_starts(ruc):r_para.run_disc_ends(ruc));
                                if f_para.subplot_posi(m_para.spikesync_disc)
                                    run_start=length(find(any(m_res.all_pos_spikes([trac1 trac2],1:r_para.run_disc_starts(ruc)-1))));
                                    norm_spike_synchro(pac,any(run_all_pos_spikes))=spike_synchro{pac}(run_start+(1:length(find(any(run_all_pos_spikes))))); % #################

                                end
                                if f_para.subplot_posi(m_para.spikeorder_disc)
                                    norm_spike_order(pac,any(run_all_pos_spikes))=spike_order{pac};
                                end
                            end
                        end
                    end
                    if ruc==1 && min(cellfun(@(v) v(1), spikes(cellfun('length',spikes)>0)))>d_para.tmin
                        if f_para.subplot_posi(m_para.spikesync_disc)
                            norm_spike_synchro(:,1)=norm_spike_synchro(:,2);            % edges, alternative: don't assign and plot them
                        end
                        if f_para.subplot_posi(m_para.spikeorder_disc)
                            norm_spike_order(:,1)=norm_spike_order(:,2);                % edges, alternative: don't assign and plot them
                        end
                    end
                    if ruc==r_para.num_runs && max(cellfun(@(v) v(end), spikes(cellfun('length',spikes)>0)))<d_para.tmax
                        if f_para.subplot_posi(m_para.spikesync_disc)
                            norm_spike_synchro(:,end)=norm_spike_synchro(:,end-1);
                        end
                        if f_para.subplot_posi(m_para.spikeorder_disc)
                            norm_spike_order(:,end)=norm_spike_order(:,end-1);
                        end
                    end
                    if f_para.subplot_posi(m_para.spikesync_disc)
                        m_res.disc_measures_mat(m_para.measure_indy(m_para.spikesync_disc),1:d_para.num_pairs,1:r_para.run_disc_lengths(ruc))=norm_spike_synchro;
                    end
                    if f_para.subplot_posi(m_para.spikeorder_disc)
                        m_res.disc_measures_mat(m_para.measure_indy(m_para.spikeorder_disc),1:d_para.num_pairs,1:r_para.run_disc_lengths(ruc))=norm_spike_order;
                    end
                else
                    if f_para.subplot_posi(m_para.spikesync_disc)
                        m_res.disc_measures_mat(m_para.measure_indy(m_para.spikesync_disc),1:d_para.num_pairs,1:r_para.run_disc_lengths(ruc))=[1 1];
                    end
                    if f_para.subplot_posi(m_para.spikeorder_disc)
                        m_res.disc_measures_mat(m_para.measure_indy(m_para.spikeorder_disc),1:d_para.num_pairs,1:r_para.run_disc_lengths(ruc))=[0 0];
                    end
                end
            end
            
            % #####################################################################################################################################
            
            spike_disc_vect=[m_para.spike_disc m_para.spike_neb_disc m_para.spike_eero_disc m_para.spike_neb_eero_disc];    % just testing, inferior performance
            if any(f_para.subplot_posi(spike_disc_vect))
                % spike_pili_vect=[m_para.spike_pili m_para.spike_neb_pili m_para.spike_eero_pili m_para.spike_neb_eero_pili];
                sel_spike=find(f_para.subplot_posi(spike_disc_vect));
                num_spike_disc=length(sel_spike);
                if ruc==1
                    spike_disco=cell(num_spike_disc,d_para.num_pairs);
                end
                if sum(num_spikes)>0        % ############
                    norm_spike_disco=zeros(num_spike_disc,d_para.num_pairs,r_para.run_disc_lengths(ruc));
                    pac=0;
                    for trac1=1:d_para.num_trains-1
                        for trac2=trac1+1:d_para.num_trains
                            pac=pac+1;
                            tracs=[trac1 trac2];
                            if ruc==r_para.ruc_initial
                                pair_all_spikes=sort([spikes{[trac1 trac2]}]);    %  all_spikes(ismember(all_trains,[0 trac1 trac2]))
                                num_pair_all_spikes(pac)=length(pair_all_spikes);
                                if num_pair_all_spikes(pac)>0
                                    if exist(['SPIKY_SPIKEdisco_MEX22.',mexext],'file')  % #################################### check spikes on edges and single spikes
                                        if pac==1
                                            spike_disco=SPIKY_SPIKEdisco_MEX2(int32(d_para.num_trains),int32(d_para.num_spikes),spikes);
                                        end
                                    else
                                        dummy=m_res.all_pos_spikes;
                                        if m_res.num_all_isi>m_res.num_isi
                                            zero_intervals=find(m_res.all_isi==0);
                                            for zic=length(zero_intervals):-1:1
                                                zi=zero_intervals(zic);
                                                dummy=[dummy(:,1:zi-1) sum(dummy(:,[zi zi+1]),2) dummy(:,zi+2:end)];
                                            end
                                        end
                                        [r,c]=find(dummy(tracs,:));
                                        spike_disco=cell(num_spike_disc,d_para.num_pairs);
                                        for sdc=1:num_spike_disc
                                            indy=sel_spike(sdc);
                                            %disc_indy=spike_disc_vect(indy);
                                            pili_indy=spike_pili_vect(indy);
                                            fy=squeeze(m_res.pili_measures_mat(m_para.measure_indy(pili_indy),pac,1:r_para.run_pili_lengths(ruc)))';
                                            dfy=[fy(1) mean(fy([2:2:m_res.pili_len-2; 3:2:m_res.pili_len])) fy(end)];
                                            spike_disco{sdc,pac}=dfy(c');
                                        end
                                    end
                                end
                            end
                            if num_pair_all_spikes(pac)>0
                                run_all_pos_spikes=m_res.all_pos_spikes([trac1 trac2],r_para.run_disc_starts(ruc):r_para.run_disc_ends(ruc));
                                if r_para.num_runs==1
                                    for sdc=1:num_spike_disc
                                        norm_spike_disco(sdc,pac,any(run_all_pos_spikes))=spike_disco{sdc,pac};
                                    end
                                else
                                    if ruc==1
                                        for sdc=1:num_spike_disc
                                            norm_spike_disco(sdc,pac,any(run_all_pos_spikes))=spike_disco{sdc,pac}(1:sum(any(run_all_pos_spikes)));
                                        end
                                    else
                                        start=sum(any(m_res.all_pos_spikes([trac1 trac2],1:r_para.run_disc_starts(ruc)-1)));
                                        for sdc=1:num_spike_disc
                                            norm_spike_disco(sdc,pac,any(run_all_pos_spikes))=spike_disco{sdc,pac}(start+(1:sum(any(run_all_pos_spikes))));
                                        end
                                    end
                                end
                            end
                        end
                        
                        if ruc==1 && m_res.num_tmin_spikes==0
                            norm_spike_disco(:,:,1)=norm_spike_disco(:,:,2);            % edges, alternative: don't assign and plot them
                        end
                        if ruc==r_para.num_runs && m_res.num_tmax_spikes==0
                            norm_spike_disco(:,:,end)=norm_spike_disco(:,:,end-1);
                        end
                        m_res.disc_measures_mat(m_para.measure_indy(spike_disc_vect(sel_spike)),1:d_para.num_pairs,1:r_para.run_disc_lengths(ruc))=norm_spike_disco;
                    end
                else
                    m_res.disc_measures_mat(m_para.measure_indy(spike_disc_vect(sel_spike)),1:d_para.num_pairs,1:r_para.run_disc_lengths(ruc))=[1 1];
                end
                if str2num(get(handles.subplot_spike_posi_edit,'String'))==0
                    f_para.subplot_posi(m_para.spike_pili)=0;
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
        
        if m_para.num_pico_measures>0                                                                                   % Pico I: ISI
            m_res.pico_measures_mat=zeros(m_para.num_pico_measures,d_para.num_pairs,r_para.run_pico_lengths(ruc));
            if f_para.subplot_posi(m_para.isi_pico)                        % ISI (calculated first, then edge-correction of ints for SPIKE)
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
            
            if f_para.subplot_posi(m_para.spike_pico)                                         % SPIKE-Pico
                if r_para.ruc==r_para.num_runs
                    m_res.isi_pos=cumsum([d_para.tmin m_res.isi(1:end-1)])+m_res.isi/2;
                end
                m_res.pico_measures_mat(m_para.measure_indy(m_para.spike_pico),1:d_para.num_pairs,1:r_para.run_pico_lengths(ruc)) = ...
                    SPIKY_SPIKEpico_MEX2(int32(d_para.num_pairs),int32(r_para.run_pico_lengths(ruc)),int32(d_para.num_trains),...
                    foll_spikes,m_res.isi_pos(:,r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc)),int32(prev_spikes_indy),...
                    ints,int32(foll_spikes_indy),prev_spikes,run_udists);
            end
            
            if f_para.subplot_posi(m_para.realtime_spike_pico)                                  % REALTIME-PICO
                m_res.pico_measures_mat(m_para.measure_indy(m_para.realtime_spike_pico),1:d_para.num_pairs,1:r_para.run_pico_lengths(ruc)) = ...
                    SPIKY_realtimeSPIKEpico_MEX2(int32(d_para.num_pairs),int32(r_para.run_pico_lengths(ruc)),int32(d_para.num_trains),...
                    prev_spikes,m_res.cum_isi(:,[r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc) r_para.run_pico_ends(ruc)+1]),...
                    m_res.isi(:,r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc)),int32(prev_spikes_indy),run_udists);
            end
            
            if f_para.subplot_posi(m_para.forward_spike_pico)                                    % FORWARD-PICO
                m_res.pico_measures_mat(m_para.measure_indy(m_para.forward_spike_pico),1:d_para.num_pairs,1:r_para.run_pico_lengths(ruc)) = ...
                    SPIKY_forwardSPIKEpico_MEX2(int32(d_para.num_pairs),int32(r_para.run_pico_lengths(ruc)),int32(d_para.num_trains),...
                    foll_spikes,m_res.cum_isi(:,[r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc) r_para.run_pico_ends(ruc)+1]),...
                    m_res.isi(:,r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc)),int32(foll_spikes_indy),run_udists);
            end
            
            ave_bi_vect(m_para.pico_bi_measures_indy,:)=ave_bi_vect(m_para.pico_bi_measures_indy,:)+sum(m_res.pico_measures_mat.*...
                repmat(shiftdim(m_res.isi(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc)),-1),[m_para.num_pico_measures,...
                d_para.num_pairs]),3);
        end
        
        if r_para.num_runs>1
            disp(['Calculation-Loop-Info: ',num2str(ruc),'  (',num2str(r_para.num_runs),')'])
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
            waitbar(ruc/r_para.num_runs,pwbh,['Calculation-Loop-Info: ',num2str(ruc),'  (',num2str(r_para.num_runs),')'])
            if ruc==r_para.num_runs
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
    all_distances=mean(ave_bi_vect,2)';   % multivariate distance value
    
    if m_para.num_disc_measures>0
        if f_para.subplot_posi(m_para.spikesync_disc)
            if sum(num_pair_all_spikes)>0
                all_distances(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikesync_disc)))=sum(ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikesync_disc)),:))/sum(num_pair_all_spikes);   % not simple average !!!
            else
                all_distances(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikesync_disc)))=1;
            end
            ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikesync_disc)),:)=(ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikesync_disc)),:)+(num_pair_all_spikes==0))./(num_pair_all_spikes+(num_pair_all_spikes==0));
        end
        if f_para.subplot_posi(m_para.spikeorder_disc)
            if sum(num_pair_all_spikes)>0
                all_distances(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikeorder_disc)))=sum(ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikeorder_disc)),:))/sum(num_pair_all_spikes);   % not simple average !!!
            else
                all_distances(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikeorder_disc)))=0;
            end
            ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikeorder_disc)),:)=(ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikeorder_disc)),:)+(num_pair_all_spikes==0))./(num_pair_all_spikes+(num_pair_all_spikes==0));
        end
        if any(f_para.subplot_posi(spike_disc_vect))
            for sdc=1:num_spike_disc
                %ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikesync_disc)),:)=(ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(m_para.spikesync_disc)),:)+(num_pair_all_spikes==0))./(num_pair_all_spikes+(num_pair_all_spikes==0));
                disc_indy=spike_disc_vect(sel_spike(sdc));
                ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(disc_indy)),:)=(ave_bi_vect(m_para.disc_bi_measures_indy(m_para.measure_indy(disc_indy)),:)+(num_pair_all_spikes==0))./(num_pair_all_spikes+(num_pair_all_spikes==0));
            end
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
            gmat=zeros(d_para.num_select_train_groups,d_para.num_select_train_groups);
            for sgc=1:d_para.num_select_train_groups
                for sgc2=sgc:d_para.num_select_train_groups
                    if sgc~=sgc2
                        gmat(sgc,sgc2)=mean(mean(imat(d_para.select_group_vect==d_para.select_train_groups(sgc),...
                            d_para.select_group_vect==d_para.select_train_groups(sgc2))));
                        gmat(sgc2,sgc)=gmat(sgc,sgc2);
                    else
                        if d_para.num_select_group_trains(sgc)>1
                            gmat(sgc,sgc2)=(sum(sum(imat(d_para.select_group_vect==d_para.select_train_groups(sgc),d_para.select_group_vect==d_para.select_train_groups(sgc))))-...
                                d_para.num_select_group_trains(sgc)*imat(1,1))/((d_para.num_select_group_trains(sgc)*(d_para.num_select_group_trains(sgc)-1)));
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
    d_para.num_frames=d_para.num_instants+d_para.num_selective_averages+d_para.num_triggered_averages;
    f_para.select_trains=1:d_para.num_trains;
    f_para.group_vect=d_para.group_vect;
else
    results=[];
    r_para=[];
    m_para.memo_num_measures=0;
end
f_para.max_total_spikes=d_para.max_total_spikes;

