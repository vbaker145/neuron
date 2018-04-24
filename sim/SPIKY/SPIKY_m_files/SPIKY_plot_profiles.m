% This plots the time profiles of the selected measures (given that 'Dissimilarity profiles' is checked in 'Selection: Plots' 
% and after the 'Plot' button has been pressed).

if m_para.memo_num_measures>0                                               % ##### disc & pico & pili #####
    if m_para.num_disc_measures>0
        spike_num=1;
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
    first_winspike_ind=find(m_res.cum_isi>=f_para.tmin,1,'first');
    last_winspike_ind=find(m_res.cum_isi<=f_para.tmax,1,'last');
    win_cum_isi=m_res.cum_isi(first_winspike_ind:last_winspike_ind);
    if first_winspike_ind>1 && f_para.tmin<m_res.cum_isi(first_winspike_ind)
        win_cum_isi=[f_para.tmin win_cum_isi];
        first_winspike_ind=first_winspike_ind-1;
    end
    if last_winspike_ind<m_res.num_isi+1 && f_para.tmax>m_res.cum_isi(last_winspike_ind)
        win_cum_isi=[win_cum_isi f_para.tmax];
    else
        last_winspike_ind=last_winspike_ind-1;   % pico: num_isi instead of num_win_spikes
    end
    isi=diff(win_cum_isi);
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
    if mod(f_para.profile_mode,2)==1                     % All
        s_para.dcols(1,1:3)=[0 0 0];
    end
    if f_para.profile_mode>1                            % Groups
        gsgz=mod(f_para.profile_mode,2);
        s_para.dcols=zeros(f_para.num_select_train_groups,3);
        for sgc=1:f_para.num_select_train_groups
            if f_para.num_select_group_trains(sgc)>1
                gsgz=gsgz+1;
                if f_para.num_select_train_groups==1
                    s_para.dcols(gsgz,1:3)=[0 0 0];
                else
                    s_para.dcols(gsgz,1:3)=d_para.dcols(d_para.select_train_groups(f_para.select_train_groups(sgc)),1:3);
                end
            end
        end
    end
end


% #####################################################################################################################################
% ######################################################### Pico- & pili-Profiles #####################################################
% #####################################################################################################################################

spike_diffs_realtime_l_ave=zeros(1,num_profiles);
spike_diffs_forward_l_ave=zeros(1,num_profiles);

if m_para.memo_num_measures>0                                               % ##### disc & pico & pili #####
    
    if r_para.num_runs>1 || num_profiles>0
        if m_para.num_disc_measures>0
            num_spike_profiles=mod(f_para.profile_mode,2)+2*sum(f_para.num_select_group_trains>1)*(f_para.profile_mode>1);  % *2 for group indices
            if f_para.subplot_posi(m_para.spikesync_disc)
                spike_sync=zeros(num_spike_profiles,num_win_spikes,'double');
            end
            if f_para.subplot_posi(m_para.spikeorder_disc)
                spike_order=zeros(num_spike_profiles,num_win_spikes,'double');
            end
            if f_para.subplot_posi(m_para.spike_disc)
                spike_diffs_disc=zeros(num_spike_profiles,num_win_spikes,'double');
            end
            if f_para.subplot_posi(m_para.spike_neb_disc)
                spike_diffs_neb_disc=zeros(num_spike_profiles,num_win_spikes,'double');
            end
            if f_para.subplot_posi(m_para.spike_eero_disc)
                spike_diffs_eero_disc=zeros(num_spike_profiles,num_win_spikes,'double');
            end
            if f_para.subplot_posi(m_para.spike_neb_eero_disc)
                spike_diffs_neb_eero_disc=zeros(num_spike_profiles,num_win_spikes,'double');
            end
        end
        if m_para.num_pico_measures>0
            if f_para.subplot_posi(m_para.isi_pico)
                isi_ratio=zeros(num_profiles,num_isi);
            end
            if f_para.subplot_posi(m_para.spike_pico)
                spike_diffs=zeros(num_profiles,num_isi);
            end
            if f_para.subplot_posi(m_para.realtime_spike_pico)
                spike_diffs_realtime=zeros(num_profiles,num_isi);
            end
            if f_para.subplot_posi(m_para.forward_spike_pico)
                spike_diffs_forward=zeros(num_profiles,num_isi);
            end
        end
        if m_para.num_pili_measures>0
            if f_para.subplot_posi(m_para.spike_pili)
                spike_diffs_l=zeros(num_profiles,2*num_isi);
            end
            if f_para.subplot_posi(m_para.spike_neb_pili)
                spike_diffs_neb_l=zeros(num_profiles,2*num_isi);
            end
            if f_para.subplot_posi(m_para.spike_eero_pili)
                spike_diffs_eero_l=zeros(num_profiles,2*num_isi);
            end
            if f_para.subplot_posi(m_para.spike_neb_eero_pili)
                spike_diffs_neb_eero_l=zeros(num_profiles,2*num_isi);
            end
            if f_para.subplot_posi(m_para.realtime_spike_pili)
                spike_diffs_realtime_l=zeros(num_profiles,2*num_isi);
            end
            if f_para.subplot_posi(m_para.forward_spike_pili)
                spike_diffs_forward_l=zeros(num_profiles,2*num_isi);
            end
        end
    end

    if r_para.num_runs==1
        if mod(f_para.profile_mode,2)==1                     % All
            if m_para.num_disc_measures>0
                if sum(num_spikes)==0
                    if f_para.subplot_posi(m_para.spikesync_disc)
                        spike_sync=[1 1];
                    end
                    if f_para.subplot_posi(m_para.spikeorder_disc)
                        spike_order=[0 0];
                    end
                    if f_para.subplot_posi(m_para.spike_disc)
                        spike_diffs_disc=[1 1];
                    end
                    if f_para.subplot_posi(m_para.spike_disc)
                        spike_diffs_disc=[1 1];
                    end
                    if f_para.subplot_posi(m_para.spike_disc)
                        spike_diffs_disc=[1 1];
                    end
                    if f_para.subplot_posi(m_para.spike_disc)
                        spike_diffs_disc=[1 1];
                    end
                elseif first_winspike_ind2==last_winspike_ind2-1
                    if f_para.subplot_posi(m_para.spikesync_disc)
                        spike_sync=[0 0];
                    end
                    if f_para.subplot_posi(m_para.spikeorder_disc)
                        spike_order=[0 0];
                    end
                    if f_para.subplot_posi(m_para.spike_disc)
                        spike_diffs_disc=[0 0];
                    end
                    if f_para.subplot_posi(m_para.spike_neb_disc)
                        spike_diffs_neb_disc=[0 0];
                    end
                    if f_para.subplot_posi(m_para.spike_eero_disc)
                        spike_diffs_eero_disc=[0 0];
                    end
                    if f_para.subplot_posi(m_para.spike_neb_eero_disc)
                        spike_diffs_neb_eero_disc=[0 0];
                    end
                else
                    if f_para.subplot_posi(m_para.spikesync_disc)
                        spike_sync(1,1:num_win_spikes)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(m_para.spikesync_disc),...
                            f_para.select_pairs,win_sel_spikes),1),1))/(f_para.num_trains-1);
                    end
                    if f_para.subplot_posi(m_para.spikeorder_disc)
                        spike_order(1,1:num_win_spikes)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(m_para.spikeorder_disc),...
                            f_para.select_pairs,win_sel_spikes),1),1))/(f_para.num_trains-1);
                    end
                    if f_para.subplot_posi(m_para.spike_disc)
                        spike_diffs_disc(1,1:num_win_spikes)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(m_para.spike_disc),...
                            f_para.select_pairs,win_sel_spikes),1),1))/(f_para.num_trains-1);
                    end
                    if f_para.subplot_posi(m_para.spike_neb_disc)
                        spike_diffs_neb_disc(1,1:num_win_spikes)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(m_para.spike_neb_disc),...
                            f_para.select_pairs,win_sel_spikes),1),1))/(f_para.num_trains-1);
                    end
                    if f_para.subplot_posi(m_para.spike_eero_disc)
                        spike_diffs_eero_disc(1,1:num_win_spikes)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(m_para.spike_eero_disc),...
                            f_para.select_pairs,win_sel_spikes),1),1))/(f_para.num_trains-1);
                    end
                    if f_para.subplot_posi(m_para.spike_neb_eero_disc)
                        spike_diffs_neb_eero_disc(1,1:num_win_spikes)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(m_para.spike_neb_eero_disc),...
                            f_para.select_pairs,win_sel_spikes),1),1))/(f_para.num_trains-1);
                    end
                    edge_spikes=ismember([f_para.tmin f_para.tmax],[spikes{f_para.select_trains}]);
                    if ~ismember(win_cum_isi2(1),sel_all_cum_isi2(2:end-1)) && ~edge_spikes(1)
                        if f_para.subplot_posi(m_para.spikesync_disc)
                            spike_sync(1,1)=spike_sync(1,2);
                        end
                        if f_para.subplot_posi(m_para.spikeorder_disc)
                            spike_order(1,1)=spike_order(1,2);
                        end
                        if f_para.subplot_posi(m_para.spike_disc)
                            spike_diffs_disc(1,1)=spike_diffs_disc(1,2);
                        end
                        if f_para.subplot_posi(m_para.spike_neb_disc)
                            spike_diffs_neb_disc(1,1)=spike_diffs_neb_disc(1,2);
                        end
                        if f_para.subplot_posi(m_para.spike_eero_disc)
                            spike_diffs_eero_disc(1,1)=spike_diffs_eero_disc(1,2);
                        end
                        if f_para.subplot_posi(m_para.spike_neb_eero_disc)
                            spike_diffs_neb_eero_disc(1,1)=spike_diffs_neb_eero_disc(1,2);
                        end
                    elseif win_cum_isi2(1)~=sel_all_cum_isi2(1) || edge_spikes(1)
                        spike_num=spike_num+1;                          % spike at beginning
                    end
                    if ~ismember(win_cum_isi2(end),sel_all_cum_isi2(2:end-1)) && ~edge_spikes(2)
                        if f_para.subplot_posi(m_para.spikesync_disc)
                            spike_sync(1,end)=spike_sync(1,end-1);
                        end
                        if f_para.subplot_posi(m_para.spikeorder_disc)
                            spike_order(1,end)=spike_order(1,end-1);
                        end
                        if f_para.subplot_posi(m_para.spike_disc)
                            spike_diffs_disc(1,end)=spike_diffs_disc(1,end-1);
                        end
                        if f_para.subplot_posi(m_para.spike_neb_disc)
                            spike_diffs_neb_disc(1,end)=spike_diffs_neb_disc(1,end-1);
                        end
                        if f_para.subplot_posi(m_para.spike_eero_disc)
                            spike_diffs_eero_disc(1,end)=spike_diffs_eero_disc(1,end-1);
                        end
                        if f_para.subplot_posi(m_para.spike_neb_eero_disc)
                            spike_diffs_neb_eero_disc(1,end)=spike_diffs_neb_eero_disc(1,end-1);
                        end
                    elseif win_cum_isi2(end)~=sel_all_cum_isi2(end) || edge_spikes(2)
                        spike_num=spike_num+2;                          % spike at end
                    end
                end
                %eval('results.SPIKE_Synchro.name=''SPIKE_Synchro'';')
                %eval('results.SPIKE_Synchro.time=win_cum_isi2;')
                %eval('results.SPIKE_Synchro.profile=spike_sync;')
                %results=orderfields(results);
                %assignin('base','SPIKY_results',results);
            end
            if m_para.num_pico_measures>0
                if f_para.subplot_posi(m_para.isi_pico)
                    isi_ratio(1,1:num_isi)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(m_para.isi_pico),...
                        f_para.select_pairs,first_winspike_ind:last_winspike_ind),1),1);
                end
                if f_para.subplot_posi([m_para.spike_pico])
                    spike_diffs(1,1:num_isi)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                        m_para.spike_pico),f_para.select_pairs,first_winspike_ind:last_winspike_ind),1),1);
                end
                if f_para.subplot_posi([m_para.realtime_spike_pico])
                    spike_diffs_realtime(1,1:num_isi)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                        m_para.realtime_spike_pico),f_para.select_pairs,first_winspike_ind:last_winspike_ind),1),1);
                end
                if f_para.subplot_posi([m_para.forward_spike_pico])
                    spike_diffs_forward(1,1:num_isi)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                        m_para.forward_spike_pico),f_para.select_pairs,first_winspike_ind:last_winspike_ind),1),1);
                end
            end
            if m_para.num_pili_measures>0
                if f_para.subplot_posi([m_para.spike_pili])
                    spike_diffs_l(1,1:2*num_isi)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_pili),...
                        f_para.select_pairs,2*first_winspike_ind-1:2*last_winspike_ind),1),1);
                end
                if f_para.subplot_posi([m_para.spike_neb_pili])
                    spike_diffs_neb_l(1,1:2*num_isi)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_neb_pili),...
                        f_para.select_pairs,2*first_winspike_ind-1:2*last_winspike_ind),1),1);
                end
                if f_para.subplot_posi([m_para.spike_eero_pili])
                    spike_diffs_eero_l(1,1:2*num_isi)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_eero_pili),...
                        f_para.select_pairs,2*first_winspike_ind-1:2*last_winspike_ind),1),1);
                end
                if f_para.subplot_posi([m_para.spike_neb_eero_pili])
                    spike_diffs_neb_eero_l(1,1:2*num_isi)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(m_para.spike_neb_eero_pili),...
                        f_para.select_pairs,2*first_winspike_ind-1:2*last_winspike_ind),1),1);
                end
                if f_para.subplot_posi([m_para.realtime_spike_pili])
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
                if f_para.subplot_posi([m_para.forward_spike_pili])
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
                        if first_winspike_ind2==last_winspike_ind2
                            if f_para.subplot_posi(m_para.spikesync_disc)
                                spike_sync=[0 0];
                            end
                            if f_para.subplot_posi(m_para.spikeorder_disc)
                                spike_order=[0 0];
                            end
                            if f_para.subplot_posi(m_para.spike_disc)
                                spike_diffs_disc=[0 0];
                            end
                        else
                            gr_sel_spikes=find([1 any(m_res.all_pos_spikes(f_para.select_trains(f_para.select_group_vect==select_group),2:end-1)) 1]);
                            dummindy=find(ismember(win_sel_spikes,gr_sel_spikes));
                            %spike_sync(gsgz,dummindy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...    % ########
                            %    m_para.spikesync_disc),gm_indy,gr_sel_spikes),1),1))/(f_para.num_select_group_trains(sgc)-1);
                            if f_para.subplot_posi(m_para.spikesync_disc)
                                spike_sync(gsgz,dummindy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...    % ########
                                    m_para.spikesync_disc),gm_indy,win_sel_spikes(dummindy)),1),1))/(f_para.num_select_group_trains(sgc)-1);
                                spike_sync(sum(f_para.num_select_group_trains>1)+gsgz,dummindy)=1;
                            end
                            if f_para.subplot_posi(m_para.spikeorder_disc)
                                spike_order(gsgz,dummindy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...    % ########
                                    m_para.spikeorder_disc),gm_indy,win_sel_spikes(dummindy)),1),1))/(f_para.num_select_group_trains(sgc)-1);
                                spike_order(sum(f_para.num_select_group_trains>1)+gsgz,dummindy)=1;
                            end
                            if f_para.subplot_posi(m_para.spike_disc)
                                spike_diffs_disc(gsgz,dummindy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...    % ########
                                    m_para.spike_disc),gm_indy,win_sel_spikes(dummindy)),1),1))/(f_para.num_select_group_trains(sgc)-1);
                                spike_diffs_disc(sum(f_para.num_select_group_trains>1)+gsgz,dummindy)=1;
                            end
                            edge_spikes=ismember([f_para.tmin f_para.tmax],[spikes{f_para.select_trains(f_para.select_group_vect==select_group)}]);
                            if ~ismember(win_cum_isi2(dummindy(1)),sel_all_cum_isi2(2:end-1)) && ~edge_spikes(1)
                                if f_para.subplot_posi(m_para.spikesync_disc)
                                    spike_sync(gsgz,dummindy(1))=spike_sync(gsgz,dummindy(2));
                                end
                                if f_para.subplot_posi(m_para.spikeorder_disc)
                                    spike_order(gsgz,dummindy(1))=spike_order(gsgz,dummindy(2));
                                end
                                if f_para.subplot_posi(m_para.spike_disc)
                                    spike_diffs_disc(gsgz,dummindy(1))=spike_diffs_disc(gsgz,dummindy(2));
                                end
                            elseif (win_cum_isi2(dummindy(1))~=sel_all_cum_isi2(1) || edge_spikes(2)) && f_para.profile_mode==2 && gsgz==mod(f_para.profile_mode,2)+1
                                spike_num=spike_num+1;
                            end
                            if ~ismember(win_cum_isi2(dummindy(end)),sel_all_cum_isi2(2:end-1)) && ~edge_spikes(2)
                                if f_para.subplot_posi(m_para.spikesync_disc)
                                    spike_sync(gsgz,dummindy(end))=spike_sync(gsgz,dummindy(end-1));
                                end
                                if f_para.subplot_posi(m_para.spikeorder_disc)
                                    spike_order(gsgz,dummindy(end))=spike_order(gsgz,dummindy(end-1));
                                end
                                if f_para.subplot_posi(m_para.spike_disc)
                                    spike_diffs_disc(gsgz,dummindy(end))=spike_diffs_disc(gsgz,dummindy(end-1));
                                end
                            elseif (win_cum_isi2(dummindy(end))~=sel_all_cum_isi2(end) || edge_spikes(2)) && f_para.profile_mode==2 && gsgz==mod(f_para.profile_mode,2)+1
                                spike_num=spike_num+2;
                            end
                        end
                    end
                    if m_para.num_pico_measures>0
                        if f_para.subplot_posi(m_para.isi_pico)
                            isi_ratio(gsgz,1:num_isi)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                                m_para.isi_pico),gm_indy,first_winspike_ind:last_winspike_ind),1),1);
                        end
                        if f_para.subplot_posi([m_para.spike_pico])
                            spike_diffs(gsgz,1:num_isi)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                                m_para.spike_pico),gm_indy,first_winspike_ind:last_winspike_ind),1),1);
                        end
                        if f_para.subplot_posi([m_para.realtime_spike_pico])
                            spike_diffs_realtime(gsgz,1:num_isi)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                                m_para.realtime_spike_pico),gm_indy,first_winspike_ind:last_winspike_ind),1),1);
                        end
                        if f_para.subplot_posi([m_para.forward_spike_pico])
                            spike_diffs_forward(gsgz,1:num_isi)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                                m_para.forward_spike_pico),gm_indy,first_winspike_ind:last_winspike_ind),1),1);
                        end
                    end                    
                    if m_para.num_pili_measures>0
                        if f_para.subplot_posi([m_para.spike_pili])
                            spike_diffs_l(gsgz,1:2*num_isi)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                                m_para.spike_pili),gm_indy,2*first_winspike_ind-1:2*last_winspike_ind),1),1);
                        end
                        if f_para.subplot_posi([m_para.spike_neb_pili])
                            spike_diffs_neb_l(gsgz,1:2*num_isi)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                                m_para.spike_neb_pili),gm_indy,2*first_winspike_ind-1:2*last_winspike_ind),1),1);
                        end
                        if f_para.subplot_posi([m_para.spike_eero_pili])
                            spike_diffs_eero_l(gsgz,1:2*num_isi)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                                m_para.spike_eero_pili),gm_indy,2*first_winspike_ind-1:2*last_winspike_ind),1),1);
                        end
                        if f_para.subplot_posi([m_para.spike_neb_eero_pili])
                            spike_diffs_neb_eero_l(gsgz,1:2*num_isi)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                                m_para.spike_neb_eero_pili),gm_indy,2*first_winspike_ind-1:2*last_winspike_ind),1),1);
                        end
                        if f_para.subplot_posi([m_para.realtime_spike_pili])
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
                        if f_para.subplot_posi([m_para.forward_spike_pili])
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
                if f_para.subplot_posi([m_para.spike_pili])
                    spike_diffs_l(:,1)=spike_diffs_l(:,1)+(spike_diffs_l(:,2)-spike_diffs_l(:,1)).*...
                        repmat((f_para.tmin-m_res.pili_supi(first_pili_supi_ind-2))./...
                        (m_res.pili_supi(first_pili_supi_ind)-m_res.pili_supi(first_pili_supi_ind-2)),num_profiles,1);
                end
                if f_para.subplot_posi([m_para.spike_neb_pili])
                    spike_diffs_neb_l(:,1)=spike_diffs_neb_l(:,1)+(spike_diffs_neb_l(:,2)-spike_diffs_neb_l(:,1)).*...
                        repmat((f_para.tmin-m_res.pili_supi(first_pili_supi_ind-2))./...
                        (m_res.pili_supi(first_pili_supi_ind)-m_res.pili_supi(first_pili_supi_ind-2)),num_profiles,1);
                end
                if f_para.subplot_posi([m_para.spike_eero_pili])
                    spike_diffs_eero_l(:,1)=spike_diffs_eero_l(:,1)+(spike_diffs_eero_l(:,2)-spike_diffs_eero_l(:,1)).*...
                        repmat((f_para.tmin-m_res.pili_supi(first_pili_supi_ind-2))./...
                        (m_res.pili_supi(first_pili_supi_ind)-m_res.pili_supi(first_pili_supi_ind-2)),num_profiles,1);
                end
                if f_para.subplot_posi([m_para.spike_neb_eero_pili])
                    spike_diffs_neb_eero_l(:,1)=spike_diffs_neb_eero_l(:,1)+(spike_diffs_neb_eero_l(:,2)-spike_diffs_neb_eero_l(:,1)).*...
                        repmat((f_para.tmin-m_res.pili_supi(first_pili_supi_ind-2))./...
                        (m_res.pili_supi(first_pili_supi_ind)-m_res.pili_supi(first_pili_supi_ind-2)),num_profiles,1);
                end
                if f_para.subplot_posi([m_para.realtime_spike_pili])   % linear approximation
                    spike_diffs_realtime_l(:,1)=spike_diffs_realtime_l(:,1)+(spike_diffs_realtime_l(:,2)-spike_diffs_realtime_l(:,1)).*...
                        repmat((f_para.tmin-m_res.pili_supi(first_pili_supi_ind-2))./...
                        (m_res.pili_supi(first_pili_supi_ind)-m_res.pili_supi(first_pili_supi_ind-2)),num_profiles,1);

                end
                if f_para.subplot_posi([m_para.forward_spike_pili])   % linear approximation
                    spike_diffs_forward_l(:,1)=spike_diffs_forward_l(:,1)+(spike_diffs_forward_l(:,2)-spike_diffs_forward_l(:,1)).*...
                        repmat((f_para.tmin-m_res.pili_supi(first_pili_supi_ind-1))./...
                        (m_res.pili_supi(first_pili_supi_ind)-m_res.pili_supi(first_pili_supi_ind-1)),num_profiles,1);
                end
            end
            if mod(edges,4)>1   % final value in the middle of interspike interval
                if f_para.subplot_posi([m_para.spike_pili])
                    spike_diffs_l(:,2*num_isi)=spike_diffs_l(:,2*num_isi-1)+(spike_diffs_l(:,2*num_isi)-spike_diffs_l(:,2*num_isi-1)).*...
                        repmat((f_para.tmax-m_res.pili_supi(last_pili_supi_ind))./...
                        (m_res.pili_supi(last_pili_supi_ind+2)-m_res.pili_supi(last_pili_supi_ind)),num_profiles,1);
                end
                if f_para.subplot_posi([m_para.spike_neb_pili])
                    spike_diffs_neb_l(:,2*num_isi)=spike_diffs_neb_l(:,2*num_isi-1)+(spike_diffs_neb_l(:,2*num_isi)-spike_diffs_neb_l(:,2*num_isi-1)).*...
                        repmat((f_para.tmax-m_res.pili_supi(last_pili_supi_ind))./...
                        (m_res.pili_supi(last_pili_supi_ind+2)-m_res.pili_supi(last_pili_supi_ind)),num_profiles,1);
                end
                if f_para.subplot_posi([m_para.spike_eero_pili])
                    spike_diffs_eero_l(:,2*num_isi)=spike_diffs_eero_l(:,2*num_isi-1)+(spike_diffs_eero_l(:,2*num_isi)-spike_diffs_eero_l(:,2*num_isi-1)).*...
                        repmat((f_para.tmax-m_res.pili_supi(last_pili_supi_ind))./...
                        (m_res.pili_supi(last_pili_supi_ind+2)-m_res.pili_supi(last_pili_supi_ind)),num_profiles,1);
                end
                if f_para.subplot_posi([m_para.spike_neb_eero_pili])
                    spike_diffs_neb_eero_l(:,2*num_isi)=spike_diffs_neb_eero_l(:,2*num_isi-1)+(spike_diffs_neb_eero_l(:,2*num_isi)-spike_diffs_neb_eero_l(:,2*num_isi-1)).*...
                        repmat((f_para.tmax-m_res.pili_supi(last_pili_supi_ind))./...
                        (m_res.pili_supi(last_pili_supi_ind+2)-m_res.pili_supi(last_pili_supi_ind)),num_profiles,1);
                end
                if f_para.subplot_posi([m_para.realtime_spike_pili])   % linear approximation
                    spike_diffs_realtime_l(:,2*num_isi)=spike_diffs_realtime_l(:,2*num_isi-1)+...
                        (spike_diffs_realtime_l(:,2*num_isi)-spike_diffs_realtime_l(:,2*num_isi-1)).*...
                        repmat((f_para.tmax-m_res.pili_supi(last_pili_supi_ind))./...
                        (m_res.pili_supi(last_pili_supi_ind+2)-m_res.pili_supi(last_pili_supi_ind)),num_profiles,1);
                end
                if f_para.subplot_posi([m_para.forward_spike_pili])   % linear approximation
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
        if isempty(max_ruc)
            max_ruc=1;
        end
        
        num_runs=max_ruc-min_ruc+1;
        if num_runs>1
            disp(' ')
            disp(['Number of profile loop runs: ',num2str(num_runs)])
            pwbh = waitbar(0,'Large data set. Please be patient.','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
            setappdata(pwbh,'canceling',0)
        end
        for ruc=min_ruc:max_ruc
            if num_runs>1 && getappdata(pwbh,'canceling')
                delete(pwbh)
                return
            end

            if ruc~=r_para.ruc
                if min_ruc~=1 || max_ruc~=r_para.num_runs
                    disp(['Profile-Loop-Info = ',num2str(ruc),'  (',num2str(r_para.num_runs),') --- ',...
                        num2str(ruc-min_ruc+1  ),'  (',num2str(max_ruc-min_ruc+1),')'])
                else
                    disp(['Profile-Loop-Info = ',num2str(ruc),'  (',num2str(r_para.num_runs),')'])
                end
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
                    eval(['m_res.pili_measures_mat = sl_pili_',num2str(ruc) ';']);
                    eval(['clear sl_pili_',num2str(ruc),';']);
                end
                r_para.ruc=ruc;
                if num_runs>1
                    waitbar((ruc-min_ruc+1)/num_runs,pwbh,['Profile-Loop-Info: ',num2str(ruc-min_ruc+1),'  (',num2str(num_runs),')'])
                    if ruc==max_ruc
                        delete(pwbh)
                    end
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
                    if first_winspike_ind2==last_winspike_ind2-1
                        if f_para.subplot_posi(m_para.spikesync_disc)
                            spike_sync=[0 0];
                        end
                        if f_para.subplot_posi(m_para.spikeorder_disc)
                            spike_order=[0 0];
                        end
                        if f_para.subplot_posi(m_para.spike_disc)
                            spike_diffs_disc=[0 0];
                        end
                    else
                        if f_para.subplot_posi(m_para.spikesync_disc)
                            spike_sync(1,disc_prof_run_indy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...
                                m_para.spikesync_disc),f_para.select_pairs,disc_load_run_indy),1),1))/(f_para.num_trains-1);
                        end
                        if f_para.subplot_posi(m_para.spikeorder_disc)
                            spike_order(1,disc_prof_run_indy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...
                                m_para.spikeorder_disc),f_para.select_pairs,disc_load_run_indy),1),1))/(f_para.num_trains-1);
                        end
                        if f_para.subplot_posi(m_para.spike_disc)
                            spike_diffs_disc(1,disc_prof_run_indy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...
                                m_para.spikesync_disc),f_para.select_pairs,disc_load_run_indy),1),1))/(f_para.num_trains-1);
                        end
                        edge_spikes=ismember([f_para.tmin f_para.tmax],[spikes{f_para.select_trains}]);
                        if ~ismember(win_cum_isi2(1),sel_all_cum_isi2) && ~edge_spikes(1)
                            if f_para.subplot_posi(m_para.spikesync_disc)
                                spike_sync(1,1)=spike_sync(1,2);
                            end
                            if f_para.subplot_posi(m_para.spikeorder_disc)
                                spike_order(1,1)=spike_order(1,2);
                            end
                            if f_para.subplot_posi(m_para.spike_disc)
                                spike_diffs_disc(1,1)=spike_diffs_disc(1,2);
                            end
                        elseif win_cum_isi2(1)~=sel_all_cum_isi2(1) || (edge_spikes(1) && ruc==1)
                            spike_num=spike_num+1;
                        end
                        if ~ismember(win_cum_isi2(end),sel_all_cum_isi2) && ~edge_spikes(2)
                            if f_para.subplot_posi(m_para.spikesync_disc)
                                spike_sync(1,end)=spike_sync(1,end-1);
                            end
                            if f_para.subplot_posi(m_para.spikeorder_disc)
                                spike_order(1,end)=spike_order(1,end-1);
                            end
                            if f_para.subplot_posi(m_para.spike_disc)
                                spike_diffs_disc(1,end)=spike_diffs_disc(1,end-1);
                            end
                        elseif win_cum_isi2(end)~=sel_all_cum_isi2(end) || (edge_spikes(2) && ruc==1)
                            spike_num=spike_num+2;
                        end
                    end
                end
                if m_para.num_pico_measures>0
                    if f_para.subplot_posi(m_para.isi_pico)
                        isi_ratio(1,pico_prof_run_indy)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                            m_para.isi_pico),f_para.select_pairs,pico_load_run_indy),1),1);
                    end
                    if f_para.subplot_posi(m_para.spike_pico)
                        spike_diffs(1,pico_prof_run_indy)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                            m_para.spike_pico),f_para.select_pairs,pico_load_run_indy),1),1);
                    end
                    if f_para.subplot_posi(m_para.realtime_spike_pico)
                        spike_diffs_realtime(1,pico_prof_run_indy)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                            m_para.realtime_spike_pico),f_para.select_pairs,pico_load_run_indy),1),1);
                    end
                    if f_para.subplot_posi(m_para.forward_spike_pico)
                        spike_diffs_forward(1,pico_prof_run_indy)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                            m_para.forward_spike_pico),f_para.select_pairs,pico_load_run_indy),1),1);
                    end
                end
                if m_para.num_pili_measures>0
                    if f_para.subplot_posi([m_para.spike_pili])
                        spike_diffs_l(1,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                            m_para.spike_pili),f_para.select_pairs,pili_load_run_indy),1),1);
                    end
                    if f_para.subplot_posi([m_para.spike_neb_pili])
                        spike_diffs_neb_l(1,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                            m_para.spike_neb_pili),f_para.select_pairs,pili_load_run_indy),1),1);
                    end
                    if f_para.subplot_posi([m_para.spike_eero_pili])
                        spike_diffs_eero_l(1,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                            m_para.spike_pili),f_para.select_pairs,pili_load_run_indy),1),1);
                    end
                    if f_para.subplot_posi([m_para.spike_neb_eero_pili])
                        spike_diffs_neb_eero_l(1,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                            m_para.spike_neb_pili),f_para.select_pairs,pili_load_run_indy),1),1);
                    end
                    if f_para.subplot_posi(m_para.realtime_spike_pili)
                        spike_diffs_realtime_l(1,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(m_para.realtime_spike_pili),...
                            f_para.select_pairs,pili_load_run_indy),1),1);
                        % spike_diffs_realtime_l_ave $$$$$$
                    end
                    if f_para.subplot_posi(m_para.forward_spike_pili)
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
                            if f_para.subplot_posi(m_para.spikesync_disc)
                                spike_sync(gsgz,prof_dummindy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...
                                    m_para.spikesync_disc),gm_indy,load_dummindy),1),1))/(f_para.num_select_group_trains(sgc)-1);
                                spike_sync(sum(f_para.num_select_group_trains>1)+gsgz,prof_dummindy)=1;
                            end
                            if f_para.subplot_posi(m_para.spikeorder_disc)
                                spike_order(gsgz,prof_dummindy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...
                                    m_para.spikeorder_disc),gm_indy,load_dummindy),1),1))/(f_para.num_select_group_trains(sgc)-1);
                                spike_order(sum(f_para.num_select_group_trains>1)+gsgz,prof_dummindy)=1;
                            end
                            if f_para.subplot_posi(m_para.spike_disc)
                                spike_diffs_disc(gsgz,prof_dummindy)=double(sum(shiftdim(m_res.disc_measures_mat(m_para.measure_indy(...
                                    m_para.spikesync_disc),gm_indy,load_dummindy),1),1))/(f_para.num_select_group_trains(sgc)-1);
                                spike_diffs_disc(sum(f_para.num_select_group_trains>1)+gsgz,prof_dummindy)=1;
                            end
                            edge_spikes=ismember([f_para.tmin f_para.tmax],[spikes{f_para.select_trains(f_para.select_group_vect==select_group)}]);
                            if ruc==1 && ~ismember(win_cum_isi2(prof_dummindy(1)),sel_all_cum_isi2(2:end-1)) && ~edge_spikes(1)
                                if f_para.subplot_posi(m_para.spikesync_disc)
                                    spike_sync(gsgz,prof_dummindy(1))=spike_sync(gsgz,prof_dummindy(2));
                                end
                                if f_para.subplot_posi(m_para.spikeorder_disc)
                                    spike_order(gsgz,prof_dummindy(1))=spike_order(gsgz,prof_dummindy(2));
                                end
                                if f_para.subplot_posi(m_para.spike_disc)
                                    spike_diffs_disc(gsgz,prof_dummindy(1))=spike_diffs_disc(gsgz,prof_dummindy(2));
                                end
                            elseif (win_cum_isi2(prof_dummindy(1))~=sel_all_cum_isi2(1) || (edge_spikes(1) && ruc==1)) && f_para.profile_mode==2 && gsgz==mod(f_para.profile_mode,2)+1
                                spike_num=spike_num+1;
                            end
                            if ruc==r_para.num_runs && ~ismember(win_cum_isi2(prof_dummindy(end)),sel_all_cum_isi2(2:end-1)) && ~edge_spikes(2)
                                if f_para.subplot_posi(m_para.spikesync_disc)
                                    spike_sync(gsgz,prof_dummindy(end))=spike_sync(gsgz,prof_dummindy(end-1));
                                end
                                if f_para.subplot_posi(m_para.spikeorder_disc)
                                    spike_order(gsgz,prof_dummindy(end))=spike_order(gsgz,prof_dummindy(end-1));
                                end
                                if f_para.subplot_posi(m_para.spike_disc)
                                    spike_diffs_disc(gsgz,prof_dummindy(end))=spike_diffs_disc(gsgz,prof_dummindy(end-1));
                                end
                            elseif (win_cum_isi2(prof_dummindy(end))~=sel_all_cum_isi2(end) || (edge_spikes(2) && ruc==1)) && f_para.profile_mode==2 && gsgz==mod(f_para.profile_mode,2)+1
                                spike_num=spike_num+2;
                            end
                        end
                        if m_para.num_pico_measures>0
                            if f_para.subplot_posi(m_para.isi_pico)
                                isi_ratio(gsgz,pico_prof_run_indy)=mean(shiftdim(m_res.pico_measures_mat(m_para.measure_indy(...
                                    m_para.isi_pico),gm_indy,pico_load_run_indy),1),1);
                            end
                            if f_para.subplot_posi(m_para.spike_pico)
                                spike_diffs(gsgz,pico_prof_run_indy)=mean(shiftdim(m_res.pico_measures_mat(...
                                    m_para.measure_indy(m_para.spike_pico),gm_indy,pico_load_run_indy),1),1);
                            end
                            if f_para.subplot_posi(m_para.realtime_spike_pico)
                                spike_diffs_realtime(gsgz,pico_prof_run_indy)=mean(shiftdim(m_res.pico_measures_mat(...
                                    m_para.measure_indy(m_para.realtime_spike_pico),gm_indy,pico_load_run_indy),1),1);
                            end
                            if f_para.subplot_posi(m_para.forward_spike_pico)
                                spike_diffs_forward(gsgz,pico_prof_run_indy)=mean(shiftdim(m_res.pico_measures_mat(...
                                    m_para.measure_indy(m_para.forward_spike_pico),gm_indy,pico_load_run_indy),1),1);
                            end
                        end

                        if m_para.num_pili_measures>0
                            if f_para.subplot_posi([m_para.spike_pili])
                                spike_diffs_l(gsgz,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(...
                                    m_para.measure_indy(m_para.spike_pili),gm_indy,pili_load_run_indy),1),1);
                            end
                            if f_para.subplot_posi([m_para.spike_neb_pili])
                                spike_diffs_neb_l(gsgz,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(...
                                    m_para.measure_indy(m_para.spike_neb_pili),gm_indy,pili_load_run_indy),1),1);
                            end
                            if f_para.subplot_posi([m_para.spike_eero_pili])
                                spike_diffs_eero_l(gsgz,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(...
                                    m_para.measure_indy(m_para.spike_pili),gm_indy,pili_load_run_indy),1),1);
                            end
                            if f_para.subplot_posi([m_para.spike_neb_eero_pili])
                                spike_diffs_neb_eero_l(gsgz,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(...
                                    m_para.measure_indy(m_para.spike_neb_pili),gm_indy,pili_load_run_indy),1),1);
                            end
                            if f_para.subplot_posi(m_para.realtime_spike_pili)
                                spike_diffs_realtime_l(gsgz,pili_prof_run_indy)=mean(shiftdim(m_res.pili_measures_mat(m_para.measure_indy(...
                                    m_para.realtime_spike_pili),gm_indy,pili_load_run_indy),1),1);
                            end
                            if f_para.subplot_posi(m_para.forward_spike_pili)
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

if f_para.subplot_posi(m_para.psth) && num_profiles>0
    bin_width=(f_para.tmax-f_para.tmin)/f_para.psth_num_bins;
    bins=f_para.tmin:bin_width:f_para.tmax;
    psth_x=bins(1:f_para.psth_num_bins)+(bins(2)-bins(1))/2;
    
    m_res.psth=zeros(num_profiles,f_para.psth_num_bins+1);
    if mod(f_para.profile_mode,2)==1
        for trac=1:f_para.num_trains
            if ~isempty(pspikes{trac})
                m_res.psth(1,1:f_para.psth_num_bins+1)=m_res.psth(1,1:f_para.psth_num_bins+1)+histc(pspikes{trac},bins);
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
                    m_res.psth(gsgz,1:f_para.psth_num_bins+1)=m_res.psth(gsgz,1:f_para.psth_num_bins+1)+histc(pspikes{trac},bins);
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
    eval('results.PSTH.name=''PSTH'';')         % this is for window
    eval('results.PSTH.time=bins(1:f_para.psth_num_bins)+(bins(2)-bins(1))/2; %#ok<NASGU>')
    eval('results.PSTH.profile=m_res.psth;')
    %eval('results.PSTH.norm=psth_norm;')
    results=orderfields(results);
    assignin('base','SPIKY_results',results);
end

% ##################################################################################################################################
% ############################################################## Plotting ##########################################################
% ##################################################################################################################################

if mod(f_para.plot_mode,2)>0
    if s_para.window_mode==1                                                              % limits for plotting
        pmin=s_para.itmin-0.02*s_para.itrange;
        pmax=s_para.itmax+0.02*s_para.itrange;
    else
        pmin2=min([pspikes{:}]);
        pmax2=max([pspikes{:}]);
        prange2=pmax2-pmin2;
        pmin=pmin2-0.02*prange2;
        pmax=pmax2+0.02*prange2;
    end

    if any(f_para.subplot_posi(m_para.bi_measures))
        
        if f_para.profile_norm_mode~=4
            m_para.minbivals=zeros(1,m_para.num_all_measures);
        else
            m_para.minbivals=inf*ones(1,m_para.num_all_measures);
        end
        if f_para.profile_norm_mode>3
            if f_para.subplot_posi(m_para.isi_pico)
                m_para.minbivals(m_para.isi_pico)=min(min(isi_ratio));
            end
            if f_para.subplot_posi(m_para.spike_pili)
                m_para.minbivals(m_para.spike_pili)=min(min(spike_diffs_l));
            end
            if f_para.subplot_posi(m_para.spikeorder_disc)
                m_para.minbivals(m_para.spikeorder_disc)=min(min(spike_order));
            end
            if f_para.subplot_posi(m_para.spike_neb_pili)
                m_para.minbivals(m_para.spike_neb_pili)=min(min(spike_diffs_neb_l));
            end
            if f_para.subplot_posi(m_para.spike_eero_pili)
                m_para.minbivals(m_para.spike_eero_pili)=min(min(spike_diffs_eero_l));
            end
            if f_para.subplot_posi(m_para.spike_neb_eero_pili)
                m_para.minbivals(m_para.spike_neb_eero_pili)=min(min(spike_diffs_neb_eero_l));
            end
            if f_para.subplot_posi(m_para.realtime_spike_pili)
                m_para.minbivals(m_para.realtime_spike_pili)=min(min(spike_diffs_realtime_l));
            end
            if f_para.subplot_posi(m_para.forward_spike_pili)
                m_para.minbivals(m_para.forward_spike_pili)=min(min(spike_diffs_forward_l));
            end
            if f_para.subplot_posi(m_para.spike_pico)
                m_para.minbivals(m_para.spike_pico)=min(min(spike_diffs));
            end
            if f_para.subplot_posi(m_para.realtime_spike_pico)
                m_para.minbivals(m_para.realtime_spike_pico)=min(min(spike_diffs_realtime));
            end
            if f_para.subplot_posi(m_para.forward_spike_pico)
                m_para.minbivals(m_para.forward_spike_pico)=min(min(spike_diffs_forward));
            end
            if f_para.subplot_posi(m_para.spike_disc)
                m_para.minbivals(m_para.spike_disc)=min(min(spike_diffs_disc));
            end
            if f_para.subplot_posi(m_para.spike_neb_disc)
                m_para.minbivals(m_para.spike_neb_disc)=min(min(spike_diffs_neb_disc));
            end
            if f_para.subplot_posi(m_para.spike_eero_disc)
                m_para.minbivals(m_para.spike_eero_disc)=min(min(spike_diffs_eero_disc));
            end
            if f_para.subplot_posi(m_para.spike_neb_eero_disc)
                m_para.minbivals(m_para.spike_neb_eero_disc)=min(min(spike_diffs_neb_eero_disc));
            end
            if f_para.profile_norm_mode==4
                m_para.minbivals=min(m_para.minbivals)*ones(1,m_para.num_all_measures);
            end
        end
            
        if f_para.profile_norm_mode==1
            m_para.maxbivals=ones(1,m_para.num_all_measures);
        else                
            m_para.maxbivals=zeros(1,m_para.num_all_measures);
            if f_para.subplot_posi(m_para.isi_pico)
                m_para.maxbivals(m_para.isi_pico)=max(max(isi_ratio));
            end
            if f_para.subplot_posi(m_para.spike_pili)
                m_para.maxbivals(m_para.spike_pili)=max(max(spike_diffs_l));
            end
            if f_para.subplot_posi(m_para.spikesync_disc)
                m_para.maxbivals(m_para.spikesync_disc)=max(max(spike_sync));
            end
            if f_para.subplot_posi(m_para.spikeorder_disc)
                m_para.maxbivals(m_para.spikeorder_disc)=max(max(spike_order));
            end
            if f_para.subplot_posi(m_para.spike_neb_pili)
                m_para.maxbivals(m_para.spike_neb_pili)=max(max(spike_diffs_neb_l));
            end
            if f_para.subplot_posi(m_para.spike_eero_pili)
                m_para.maxbivals(m_para.spike_eero_pili)=max(max(spike_diffs_eero_l));
            end
            if f_para.subplot_posi(m_para.spike_neb_eero_pili)
                m_para.maxbivals(m_para.spike_neb_eero_pili)=max(max(spike_diffs_neb_eero_l));
            end
            if f_para.subplot_posi(m_para.realtime_spike_pili)
                m_para.maxbivals(m_para.realtime_spike_pili)=max(max(spike_diffs_realtime_l));
            end
            if f_para.subplot_posi(m_para.forward_spike_pili)
                m_para.maxbivals(m_para.forward_spike_pili)=max(max(spike_diffs_forward_l));
            end
            if f_para.subplot_posi(m_para.spike_pico)
                m_para.maxbivals(m_para.spike_pico)=max(max(spike_diffs));
            end
            if f_para.subplot_posi(m_para.realtime_spike_pico)
                m_para.maxbivals(m_para.realtime_spike_pico)=max(max(spike_diffs_realtime));
            end
            if f_para.subplot_posi(m_para.forward_spike_pico)
                m_para.maxbivals(m_para.forward_spike_pico)=max(max(spike_diffs_forward));
            end
            if f_para.subplot_posi(m_para.spike_disc)
                m_para.maxbivals(m_para.spike_disc)=max(max(spike_diffs_disc));
            end
            if f_para.subplot_posi(m_para.spike_neb_disc)
                m_para.maxbivals(m_para.spike_neb_disc)=max(max(spike_diffs_neb_disc));
            end
            if f_para.subplot_posi(m_para.spike_eero_disc)
                m_para.maxbivals(m_para.spike_eero_disc)=max(max(spike_diffs_eero_disc));
            end
            if f_para.subplot_posi(m_para.spike_neb_eero_disc)
                m_para.maxbivals(m_para.spike_neb_eero_disc)=max(max(spike_diffs_neb_eero_disc));
            end
            
            if ismember(f_para.profile_norm_mode,[2 4])
                m_para.maxbivals=max(m_para.maxbivals)*ones(1,m_para.num_all_measures);
            end
        end
    else
        m_para.minbivals=zeros(1,m_para.num_all_measures);
        m_para.maxbivals=zeros(1,m_para.num_all_measures);
    end
    if f_para.subplot_posi(m_para.psth)
        if f_para.profile_norm_mode<3
            m_para.minbivals(m_para.psth)=0;
        else
            m_para.minbivals(m_para.psth)=min(min(m_res.psth));
        end
        m_para.maxbivals(m_para.psth)=max(max(m_res.psth));
    end
    if f_para.subplot_posi(m_para.spikeorder_disc)
        if f_para.profile_norm_mode<3
            m_para.minbivals(m_para.spikeorder_disc)=-1;
        else
            m_para.minbivals(m_para.spikeorder_disc)=min(min(spike_order));
        end
        %m_para.maxbivals(m_para.psth)=max(max(m_res.psth));
    end
    % #####################################################################

    fig=figure(f_para.num_fig);
    
    subplot('Position',f_para.supo1)
    
    if f_para.histogram
        xlim([pmin pmax+0.2*(pmax-pmin)])
    else
        xlim([pmin pmax])
    end

    ylim([0 sum(f_para.subplot_size(f_para.sing_subplots))])
    s_para.xl=xlim; s_para.yl=ylim;
    sp_seps_cmenu = uicontextmenu;
    sp_seps_lh=zeros(1,m_para.num_all_measures);
    for spc=1:m_para.num_all_measures
        if f_para.subplot_posi(spc)>0 && abs(f_para.subplot_start(spc)-regplotsize)>0.00001 && f_para.subplot_start(spc)~=0  && f_para.subplot_posi(spc)~=max(f_para.subplot_posi)
            sp_seps_lh(spc)=line(s_para.xl,(s_para.yl(2)-f_para.subplot_start(spc))*ones(1,2),...
                'Visible',p_para.sp_seps_vis,'Color',p_para.sp_seps_col,'LineStyle',p_para.sp_seps_ls,'LineWidth',p_para.sp_seps_lw,'UIContextMenu',sp_seps_cmenu);
        end
    end
    lh_str='sp_seps';
    SPIKY_handle_line
    yt=[]; ytl=[];

    if f_para.subplot_posi(m_para.stimulus)>0                                                                          % Stimulus
        % here you can plot the stimulus. The example below (if uncommented) shows a sine wave.
        stim=0.5+sin((0:1/((s_para.itmax-s_para.itmin)/d_para.dts):1)*2*pi)/2;
        xvals=s_para.itmin:d_para.dts:s_para.itmax;
        stim_cmenu = uicontextmenu;
        stim_lh=zeros(1,2);
        stim_lh(1)=plot(xvals,s_para.yl(2)-f_para.subplot_start(1)+0.05+stim/1.1*f_para.subplot_size(1),...
            'Visible',p_para.stim_vis,'Color',p_para.stim_col,'LineStyle',p_para.stim_ls,'LineWidth',p_para.stim_lw,'UIContextMenu',stim_cmenu);
        lh_str='stim';
        SPIKY_handle_line
        max_stim_val=1;
        stim_lab=[-1 0 1];
        stim_pos=[0 0.5 1];
        yt=[yt s_para.yl(2)-f_para.subplot_start(1)+(0.05+stim_pos/max_stim_val)/1.1*f_para.subplot_size(1)];
        ytl=[ytl stim_lab];
        
        stimf_cmenu = uicontextmenu;
        stimf_fh=text(s_para.xl(1)-0.095*(s_para.xl(2)-s_para.xl(1)),s_para.yl(2)-f_para.subplot_start(1)+0.75/1.1*f_para.subplot_size(1),'Stimulus',...
            'Visible',p_para.stimf_vis,'Color',p_para.stimf_col,'FontSize',p_para.stimf_fs,'FontWeight',p_para.stimf_fw,'FontAngle',p_para.stimf_fa,'UIContextMenu',stimf_cmenu);
        fh_str='stimf';
        SPIKY_handle_font

        stim_bounds_cmenu = uicontextmenu;
        stim_bounds_lh=zeros(1,2);
        stim_bounds_lh(1)=line(s_para.xl,s_para.yl(2)-f_para.subplot_start(1)+0.05/1.1*f_para.subplot_size(1)*ones(1,2),...
            'Visible',p_para.stim_bounds_vis,'Color',p_para.stim_bounds_col,'LineStyle',p_para.stim_bounds_ls,'LineWidth',p_para.stim_bounds_lw,'UIContextMenu',stim_bounds_cmenu);
        stim_bounds_lh(2)=line(s_para.xl,s_para.yl(2)-f_para.subplot_start(1)+1.05/1.1*f_para.subplot_size(1)*ones(1,2),...
            'Visible',p_para.stim_bounds_vis,'Color',p_para.stim_bounds_col,'LineStyle',p_para.stim_bounds_ls,'LineWidth',p_para.stim_bounds_lw,'UIContextMenu',stim_bounds_cmenu);
        lh_str='stim_bounds';
        SPIKY_handle_line
    end

else
    f_para.subplot_size=zeros(1,m_para.num_all_measures);
    f_para.subplot_start=zeros(1,m_para.num_all_measures);
    subplot_index=f_para.subplot_posi;
    subplot_numbers=f_para.subplot_posi;
    subplot_paras=[f_para.subplot_posi',f_para.subplot_size',f_para.subplot_start',subplot_index'];
    maxintval=0; maxmeanintval=0; maxrateval=0; maxmeanrateval=0;
    minbivals=zeros(1,length(m_para.bi_measures)); maxbivals=zeros(1,length(m_para.bi_measures));
    yt=[]; ytl=[]; s_para.xl=[]; s_para.yl=[];
end

% ######################################################################################################################################
% ######################################################################################################################################
% ######################################################################################################################################

%if f_para.num_trains==2
    ab_str='';
%else
%    ab_str='^a';
%end

% 1           2         3      4            5     6  7   8      9    10   11      12   13   14
% Stimulus    Spikes    PSTH   SPIKE-Sync   I     S  S_r S_f    S_N  S_E  S_NE    Sp   Sp_r Sp_f
%
%     X-input         Y-input                    Label                            Min-value                          Max-value                       Average Datatype
measure_paras={...
    {'';             '';    m_para.all_measures_str{m_para.stimulus};             0;                                 0;                                 0;   0};...    %  1 Stimulus
    {'';             '';    m_para.all_measures_str{m_para.spikes};               0;                                 0;                                 0;   0};...    %  2 Spike train
    {'psth_x';'m_res.psth'; m_para.all_measures_str{m_para.psth};                 m_para.minbivals(m_para.psth);     m_para.maxbivals(m_para.psth);     0;   3};...    %  3 PSTH
    {'isi';   'isi_ratio';  [m_para.all_measures_str{m_para.isi_pico},ab_str];    m_para.minbivals(m_para.isi_pico); m_para.maxbivals(m_para.isi_pico); 0;   1};...    %  4 ISI

    {'isi'; 'spike_diffs_l';          [m_para.all_measures_str{m_para.spike_pili},ab_str];     m_para.minbivals(m_para.spike_pili); m_para.maxbivals(m_para.spike_pili); 0;        2};...            % 5 SPIKE
    {'isi'; 'spike_diffs_realtime_l'; [m_para.all_measures_str{m_para.realtime_spike_pili},ab_str];   m_para.minbivals(m_para.realtime_spike_pili); m_para.maxbivals(m_para.realtime_spike_pili); spike_diffs_realtime_l_ave; 2};... % 6 SPIKE-realtime
    {'isi'; 'spike_diffs_forward_l';   [m_para.all_measures_str{m_para.forward_spike_pili},ab_str];     m_para.minbivals(m_para.forward_spike_pili); m_para.maxbivals(m_para.forward_spike_pili); spike_diffs_forward_l_ave;  2};...   % 7 SPIKE-forward

    {'win_cum_isi2';  'spike_sync';  [m_para.all_measures_str{m_para.spikesync_disc},ab_str];    m_para.minbivals(m_para.spikesync_disc); m_para.maxbivals(m_para.spikesync_disc); 0;   3};...    %  8 SPIKE-Synchro
    {'win_cum_isi2';  'spike_order';  [m_para.all_measures_str{m_para.spikeorder_disc},ab_str];    m_para.minbivals(m_para.spikeorder_disc); m_para.maxbivals(m_para.spikeorder_disc); 0;   3};...    %  9 SPIKE-Synchro

    {'isi'; 'spike_diffs_neb_l';          [m_para.all_measures_str{m_para.spike_neb_pili},ab_str];     m_para.minbivals(m_para.spike_neb_pili); m_para.maxbivals(m_para.spike_neb_pili); 0;        2};...            % 10 SPIKE-Neb
    {'isi'; 'spike_diffs_eero_l';          [m_para.all_measures_str{m_para.spike_eero_pili},ab_str];     m_para.minbivals(m_para.spike_eero_pili); m_para.maxbivals(m_para.spike_eero_pili); 0;        2};...            % 11 SPIKE-Eero
    {'isi'; 'spike_diffs_neb_eero_l';          [m_para.all_measures_str{m_para.spike_neb_eero_pili},ab_str];     m_para.minbivals(m_para.spike_neb_eero_pili); m_para.maxbivals(m_para.spike_neb_eero_pili); 0;        2};...            % 12 SPIKE-Neb-Eero

    {'isi';  'spike_diffs';          [m_para.all_measures_str{m_para.spike_pico},ab_str];           m_para.minbivals(m_para.spike_pico); m_para.maxbivals(m_para.spike_pico); 0;          1};...    % 13
    {'isi';  'spike_diffs_realtime'; [m_para.all_measures_str{m_para.realtime_spike_pico},ab_str];  m_para.minbivals(m_para.realtime_spike_pico); m_para.maxbivals(m_para.realtime_spike_pico); 0; 1};...    % 14
    {'isi';  'spike_diffs_forward';   [m_para.all_measures_str{m_para.forward_spike_pico},ab_str];    m_para.minbivals(m_para.forward_spike_pico); m_para.maxbivals(m_para.forward_spike_pico); 0;   1};...    % 15

    {'win_cum_isi2';  'spike_diffs_disc';  [m_para.all_measures_str{m_para.spike_disc},ab_str];    m_para.minbivals(m_para.spike_disc); m_para.maxbivals(m_para.spike_disc); 0;   3};...    %  16 SPIKE-Disc
    {'win_cum_isi2';  'spike_diffs_neb_disc';  [m_para.all_measures_str{m_para.spike_neb_disc},ab_str];    m_para.minbivals(m_para.spike_neb_disc); m_para.maxbivals(m_para.spike_neb_disc); 0;   3};...    %  17 SPIKE-Disc-Neb
    {'win_cum_isi2';  'spike_diffs_eero_disc';  [m_para.all_measures_str{m_para.spike_eero_disc},ab_str];    m_para.minbivals(m_para.spike_eero_disc); m_para.maxbivals(m_para.spike_eero_disc); 0;   3};...    %  18 SPIKE-Disc-Eero
    {'win_cum_isi2';  'spike_diffs_neb_eero_disc';  [m_para.all_measures_str{m_para.spike_neb_eero_disc},ab_str];    m_para.minbivals(m_para.spike_neb_eero_disc); m_para.maxbivals(m_para.spike_neb_eero_disc); 0;   3};...    %  19 SPIKE-Disc-Neb-Eero
};
%     X-input         Y-input                    Label                            Min-value                          Max-value                       Average Datatype

if length(f_para.subplot_posi(f_para.subplot_posi>0))~=length(unique(f_para.subplot_posi(f_para.subplot_posi>0))) % same normalization in case of double subplots
    for supc=unique(f_para.subplot_posi(f_para.subplot_posi>0))
        if length(find(f_para.subplot_posi==supc))>1
            maxval=0;
            for supc2=find(f_para.subplot_posi==supc)
                maxval=max([maxval measure_paras{supc2}{5}]);
            end
            for supc2=find(f_para.subplot_posi==supc)
                measure_paras{supc2}{5}=maxval;
            end
        end
    end
end

distances=[];
p_para.sp_bounds_cmenu = uicontextmenu;
p_para.sp_bounds_lh=zeros(m_para.num_all_measures,2);
p_para.prof_cmenu = uicontextmenu;
p_para.prof_lh=zeros(m_para.num_all_measures,size(s_para.dcols,1));
if get(handles.fpara_moving_average_mode_popupmenu,'Value')>1
    p_para.ma_prof_cmenu = uicontextmenu;
    p_para.ma_prof_lh=zeros(m_para.num_all_measures,size(s_para.dcols,1));
end
p_para.ave_cmenu = uicontextmenu;
p_para.ave_lh=zeros(1,m_para.num_all_measures);
p_para.prof_ave_cmenu = uicontextmenu;
p_para.prof_ave_fh=zeros(1,m_para.num_all_measures);
p_para.measure_cmenu = uicontextmenu;
p_para.measure_fh=zeros(1,m_para.num_all_measures);

s_para.plot_mode=f_para.plot_mode;
s_para.profile_average_line=f_para.profile_average_line;
s_para.profile_mode=f_para.profile_mode;
s_para.spike_ave=f_para.spike_ave;
s_para.num_all_isi=m_res.num_all_isi;
s_para.zero_intervals=find(m_res.all_isi==0);
%s_para.dts=d_para.dts;
subplot_tick=zeros(1,s_para.num_subplots);
for supc=m_para.num_diff_measures+1:m_para.num_all_measures
    p_para.supc=supc;
    if f_para.subplot_posi(supc)>0        
        mac=f_para.subplot_posi(supc)-length(find(f_para.subplot_posi(1:m_para.num_diff_measures)));
        if ismember(supc,m_para.realtime_measures)
            s_para.causal=1;
        elseif ismember(supc,m_para.forward_measures)
            s_para.causal=2;
        else
            s_para.causal=0;
        end
        if ismember(supc,m_para.disc_measures)
            s_para.spike_disc=spike_num;
        else
            s_para.spike_disc=0;
        end
        s_para.spike_order=(supc==m_para.spikeorder_disc);
        if supc==m_para.psth
            s_para.psth=psth_norm;
        else
            s_para.psth=0;
        end
        s_para.profile_norm_mode=f_para.profile_norm_mode;
        %s_para.line_width=max(subplot_index)+1-subplot_index(supc);
        dcolors='kbrgmckbrgmc'; % s_para.colors=repmat(dcolors(subplot_index(supc)),1,6);
        p_para.prof_col=dcolors(subplot_index(supc));
        p_para.prof_ave_col=dcolors(subplot_index(supc));
        p_para.ave_col=dcolors(subplot_index(supc));

        subplot_tick(f_para.subplot_posi(supc))=subplot_tick(f_para.subplot_posi(supc))+1;
        if subplot_tick(f_para.subplot_posi(supc))<subplot_numbers(f_para.subplot_posi(supc))           % last trace (maybe only one)
            dyt=yt; dytl=ytl;
            command=[ '[ distances, yt, ytl, p_para ] = SPIKY_f_measure_profiles( distances, yt, ytl, '...
                measure_paras{supc}{1} ', ' measure_paras{supc}{2} ', '''  ''', subplot_paras(' num2str(supc) ',:), ' ...
                num2str(measure_paras{supc}{4}) ', ' num2str(measure_paras{supc}{5}) ', [' num2str(measure_paras{supc}{6}) '], ' num2str(measure_paras{supc}{7}) ...
                ', s_para, p_para, mac);' ];
            eval(command);
            yt=dyt; ytl=dytl;
        else
            p_para.prof_ls='-';
            p_para.prof_lw=1;
            command=[ '[ distances, yt, ytl, p_para ] = SPIKY_f_measure_profiles( distances, yt, ytl, '...
                measure_paras{supc}{1} ', ' measure_paras{supc}{2} ', ''' measure_paras{supc}{3} ''', subplot_paras(' num2str(supc) ',:), ' ...
                num2str(measure_paras{supc}{4}) ', ' num2str(measure_paras{supc}{5}) ', [' num2str(measure_paras{supc}{6}) '], ' num2str(measure_paras{supc}{7}) ...
                ', s_para, p_para, mac);' ];
            eval(command);
        end
        if isfield(eval(['results.',char(m_para.all_measures_string(supc))]),'window_time')
            if ismember(supc,m_para.select_bi_measures)
                if ismember(supc,m_para.disc_measures)
                    eval(['results.',char(m_para.all_measures_string(supc)),'=rmfield(results.',char(m_para.all_measures_string(supc)),',''window_synchro'');'])
                else
                    eval(['results.',char(m_para.all_measures_string(supc)),'=rmfield(results.',char(m_para.all_measures_string(supc)),',''window_distance'');'])
                end
            end
            eval(['results.',char(m_para.all_measures_string(supc)),'=rmfield(results.',char(m_para.all_measures_string(supc)),',''window_time'');'])
            eval(['results.',char(m_para.all_measures_string(supc)),'=rmfield(results.',char(m_para.all_measures_string(supc)),',''window_profile'');'])
        end
        if ismember(supc,m_para.select_bi_measures)
            if d_para.tmin~=f_para.tmin || d_para.tmax~=f_para.tmax || d_para.num_trains~=f_para.num_trains
                if ismember(supc,m_para.disc_measures)
                    eval(['results.',char(m_para.all_measures_string(supc)),'.window_synchro=distances;'])
                else
                    eval(['results.',char(m_para.all_measures_string(supc)),'.window_distance=distances;'])
                end
                if ismember(supc,m_para.pili_measures)
                    eval(['results.',char(m_para.all_measures_string(supc)),'.window_time=pili_supi;'])
                elseif ~ismember(supc,m_para.disc_measures)
                    eval(['results.',char(m_para.all_measures_string(supc)),'.window_time=',measure_paras{supc}{1},';'])
                end
                if ismember(supc,m_para.disc_measures)
                    if (m_res.num_tmin_spikes==0 && d_para.tmin~=f_para.tmin) && (m_res.num_tmax_spikes==0 && d_para.tmax~=f_para.tmax)
                        eval(['results.',char(m_para.all_measures_string(supc)),'.window_time=',measure_paras{supc}{1},'(2:end-1);'])
                        eval(['results.',char(m_para.all_measures_string(supc)),'.window_profile=',measure_paras{supc}{2},'(2:end-1);'])
                    elseif m_res.num_tmin_spikes==0 && d_para.tmin~=f_para.tmin
                        eval(['results.',char(m_para.all_measures_string(supc)),'.window_time=',measure_paras{supc}{1},'(2:end);'])
                        eval(['results.',char(m_para.all_measures_string(supc)),'.window_profile=',measure_paras{supc}{2},'(2:end);'])
                    elseif m_res.num_tmax_spikes==0 && d_para.tmax~=f_para.tmax
                        eval(['results.',char(m_para.all_measures_string(supc)),'.window_time=',measure_paras{supc}{1},'(1:end-1);'])
                        eval(['results.',char(m_para.all_measures_string(supc)),'.window_profile=',measure_paras{supc}{2},'(1:end-1);'])
                    else
                        eval(['results.',char(m_para.all_measures_string(supc)),'.window_time=',measure_paras{supc}{1},';'])
                        eval(['results.',char(m_para.all_measures_string(supc)),'.window_profile=',measure_paras{supc}{2},';'])
                    end
                else
                    eval(['results.',char(m_para.all_measures_string(supc)),'.window_profile=',measure_paras{supc}{2},';'])
                end
            elseif f_para.profile_mode>1
                eval(['results.',char(m_para.all_measures_string(supc)),'.profile=',measure_paras{supc}{2},';'])
            end
        else
            if d_para.tmin~=f_para.tmin || d_para.tmax~=f_para.tmax || d_para.num_trains~=f_para.num_trains
                %eval('results.PSTH.window_time=psth_x;                                                         % ######## is equal to time, maybe change this
                %eval('results.PSTH.window_profile=m_res.psth;')
            end
        end
    end
end

lh_str='p_para.sp_bounds';
SPIKY_handle_line
lh_str='p_para.prof';
SPIKY_handle_line
if get(handles.fpara_moving_average_mode_popupmenu,'Value')>1
    lh_str='p_para.ma_prof';
    SPIKY_handle_line
end
lh_str='p_para.ave';
SPIKY_handle_line
fh_str='p_para.prof_ave';
SPIKY_handle_font
fh_str='p_para.measure';
SPIKY_handle_font

if mod(s_para.plot_mode,2)>0

    if any(f_para.subplot_size(m_para.isi_pico+1:m_para.num_all_measures))                           % mark perfectly synchronous events (SPIKE-Distances only)
        common=pspikes{1}(1:f_para.num_pspikes(1));
        for trac=2:f_para.num_trains
            common=intersect(common,pspikes{trac}(1:f_para.num_pspikes(trac)));
        end
        num_commons=length(common);

        com_cmenu = uicontextmenu;
        com_lh=zeros(m_para.num_all_measures-m_para.isi_pico,num_commons);
        for spc=m_para.isi_pico+1:m_para.num_all_measures
            if f_para.subplot_size(spc)>0
                for cc=1:num_commons
                    com_lh(spc-m_para.isi_pico,cc)=line(common(cc)*ones(1,2),s_para.yl(2)-f_para.subplot_start(spc)+[0.05 1.05]/1.1*f_para.subplot_size(spc),...
                        'Visible',p_para.com_vis,'Color',p_para.com_col,'LineStyle',p_para.com_ls,'LineWidth',p_para.com_lw,'UIContextMenu',com_cmenu);
                end
            end
        end
        lh_str='com';
        SPIKY_handle_line
    end

    tbounds_cmenu = uicontextmenu;
    tbounds_lh=zeros(2,m_para.num_all_measures-m_para.num_diff_measures);
    for spc=m_para.num_diff_measures+1:m_para.num_all_measures
        if f_para.subplot_size(spc)>0
            tbounds_lh(1)=line(f_para.tmin*ones(1,2),s_para.yl(2)-f_para.subplot_start(spc)+[0.05 1.05]/1.1*f_para.subplot_size(spc),...
                'Visible',p_para.tbounds_vis,'Color',p_para.tbounds_col,'LineStyle',p_para.tbounds_ls,'LineWidth',p_para.tbounds_lw,'UIContextMenu',tbounds_cmenu);
            tbounds_lh(2)=line(f_para.tmax*ones(1,2),s_para.yl(2)-f_para.subplot_start(spc)+[0.05 1.05]/1.1*f_para.subplot_size(spc),...
                'Visible',p_para.tbounds_vis,'Color',p_para.tbounds_col,'LineStyle',p_para.tbounds_ls,'LineWidth',p_para.tbounds_lw,'UIContextMenu',tbounds_cmenu);

        end
    end
    lh_str='tbounds';
    SPIKY_handle_line

    xlab_cmenu = uicontextmenu;
    xlab_fh=xlabel(['Time ',f_para.time_unit_string],...
        'Visible',p_para.xlab_vis,'Color',p_para.xlab_col,'FontSize',p_para.xlab_fs,'FontWeight',p_para.xlab_fw,'FontAngle',p_para.xlab_fa,'UIContextMenu',xlab_cmenu);
    fh_str='xlab';
    SPIKY_handle_font

    if f_para.extreme_spikes
        min_last_spike=inf;
        max_first_spike=-inf;
        for trac=1:f_para.num_trains
            if f_para.num_pspikes(trac)>0
                min_last_spike=min([min_last_spike pspikes{trac}(end)]);
                max_first_spike=max([max_first_spike pspikes{trac}(1)]);
            end
        end
        
        extreme_cmenu = uicontextmenu;
        extreme_lh=zeros(2,m_para.num_all_measures-m_para.num_diff_measures);
        for spc=m_para.num_diff_measures+1:m_para.num_all_measures
            if f_para.subplot_size(spc)>0
                extreme_lh(1,spc-m_para.num_diff_measures)=line(max_first_spike*ones(1,2),s_para.yl(2)-f_para.subplot_start(spc)+[0.05 1.05]/1.1*f_para.subplot_size(spc),...
                    'Visible',p_para.extreme_vis,'Color',p_para.extreme_col,'LineStyle',p_para.extreme_ls,'LineWidth',p_para.extreme_lw,'UIContextMenu',extreme_cmenu);
                extreme_lh(2,spc-m_para.num_diff_measures)=line(min_last_spike*ones(1,2),s_para.yl(2)-f_para.subplot_start(spc)+[0.05 1.05]/1.1*f_para.subplot_size(spc),...
                    'Visible',p_para.extreme_vis,'Color',p_para.extreme_col,'LineStyle',p_para.extreme_ls,'LineWidth',p_para.extreme_lw,'UIContextMenu',extreme_cmenu);
            end
        end
        lh_str='extreme';
        SPIKY_handle_line
    end


    [syt,syti]=sort(yt);
    sytl=ytl(syti);

    if ~f_para.subplot_posi(m_para.spikes)
        set(gca,'XTickMode','auto','XTickLabelMode','auto')
        xt=get(gca,'XTick');
        xtc=xt(xt>=s_para.itmin & xt<=s_para.itmax);
        if mod((xtc(end)-xtc(1)),f_para.x_scale)==0 && mod((xtc(2)-xtc(1)),f_para.x_scale)==0
            xtl=(xtc+f_para.x_offset)/f_para.x_scale;
            set(gca,'XTick',xtc,'XTickLabel',xtl)
        else
            xxx=SPIKY_f_lab(xtc/f_para.x_scale,length(xtc),f_para.x_offset==0,0);
            xxx2=xxx(xxx*f_para.x_scale>=s_para.itmin & xxx*f_para.x_scale<=s_para.itmax);
            set(gca,'XTick',xxx2*f_para.x_scale,'XTickLabel',xxx2+f_para.x_offset/f_para.x_scale)
        end
    end

    set(gca,'Color','w','Box','on','YTick',syt,'YTickLabel',str2num(num2str(sytl,3)),'XColor',p_para.prof_tick_col,'YColor',p_para.prof_tick_col,...
        'FontSize',p_para.prof_tick_fs,'FontWeight',p_para.prof_tick_fw,'FontAngle',p_para.prof_tick_fa)

    prof_tick_cmenu = uicontextmenu;
    prof_tick_fh=zeros(1,2);
    prof_tick_fh(1)=line(xl,yl(1)*ones(1,2),'Color',p_para.prof_tick_col,'UIContextMenu',prof_tick_cmenu);
    prof_tick_fh(2)=line(xl(1)*ones(1,2),yl,'Color',p_para.prof_tick_col,'UIContextMenu',prof_tick_cmenu);
    fh_str='prof_tick';
    SPIKY_handle_set_property

    if isfield(d_para,'thick_markers')
        sp_thick_mar_cmenu = uicontextmenu;
        sp_thick_mar_lh=zeros(length(d_para.thick_markers),m_para.num_all_measures-m_para.num_diff_measures);
        for mac=1:length(d_para.thick_markers)
            for spc=m_para.num_diff_measures+1:m_para.num_all_measures
                if f_para.subplot_size(spc)>0
                    sp_thick_mar_lh(mac,spc-length(find(f_para.subplot_posi(1:m_para.num_diff_measures))))=...
                        line(d_para.thick_markers(mac)*ones(1,2),s_para.yl(2)-f_para.subplot_start(spc)+...
                        [0.05 1.05]/1.1*f_para.subplot_size(spc),'Visible',p_para.sp_thick_mar_vis,'Color',p_para.sp_thick_mar_col,...
                        'LineStyle',p_para.sp_thick_mar_ls,'LineWidth',p_para.sp_thick_mar_lw,'UIContextMenu',sp_thick_mar_cmenu);
                end
            end
        end
        lh_str='sp_thick_mar';
        SPIKY_handle_line
    end
    if isfield(d_para,'thin_markers')
        sp_thin_mar_cmenu = uicontextmenu;
        sp_thin_mar_lh=zeros(length(d_para.thin_markers),m_para.num_all_measures-m_para.num_diff_measures);
        for mac=1:length(d_para.thin_markers)
            for spc=m_para.num_diff_measures+1:m_para.num_all_measures
                if f_para.subplot_size(spc)>0
                    sp_thin_mar_lh(mac,spc-length(find(f_para.subplot_posi(1:m_para.num_diff_measures))))=line(d_para.thin_markers(mac)*...
                        ones(1,2),s_para.yl(2)-f_para.subplot_start(spc)+[0.05 1.05]/1.1*f_para.subplot_size(spc),...
                        'Visible',p_para.sp_thin_mar_vis,'Color',p_para.sp_thin_mar_col,'LineStyle',p_para.sp_thin_mar_ls,...
                        'LineWidth',p_para.sp_thin_mar_lw,'UIContextMenu',sp_thin_mar_cmenu);
                end
            end
        end
        lh_str='sp_thin_mar';
        SPIKY_handle_line
    end

    if get(handles.print_figures_checkbox,'Value')==1 && ~(get(handles.plots_frame_comparison_checkbox,'Value')==1 || ...
            get(handles.plots_frame_sequence_checkbox,'Value')==1 || get(handles.record_movie_checkbox,'Value')==1)   % Create postscript file
        if f_para.publication==1
            set(gcf,'PaperOrientation','Portrait'); set(gcf,'PaperType', 'A4');
            set(gcf,'PaperUnits','Normalized','PaperPosition',[0 0.45 1.0 0.5]);
        else
            set(gcf,'PaperOrientation','Landscape'); set(gcf,'PaperType', 'A4');
            set(gcf,'PaperUnits','Normalized','PaperPosition', [0 0 1.0 1.0]);
        end
        psname=[f_para.imagespath,d_para.comment_string,f_para.comment_string,'.ps'];
        print(gcf,'-dpsc',psname);
    end
end
