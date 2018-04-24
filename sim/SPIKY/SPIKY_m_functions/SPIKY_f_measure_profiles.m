% This function plots the individual time profiles of the selected spike train distances and calculates their average.

function [fave,yt,ytl,p_para]=SPIKY_f_measure_profiles(fave,fyt,fytl,fx,fy,fheadline,...
    fsp_paras,fminval,fmaxval,profi_ave,fdata_type,s_para,p_para,mac)

fsp_posi=fsp_paras(1);
fsp_size=fsp_paras(2);
fsp_start=fsp_paras(3);

for nmac=1:length(s_para.nma)
    mova=0;
    if s_para.nma(nmac)==2 && fdata_type==3 && s_para.spike_disc==0
        %continue
    end
    if s_para.causal>0
        p_para.prof_ls=':';  % for realtime and future (in order to indicate the linear simplification)
    end
    if s_para.nma(nmac)==2 && size(fy,1)==1                                                       % moving average
        if s_para.causal==0                                                % regular (average over both past and future values)
            if fdata_type==1          % piecewise constant
                for trac=1:size(fy,1)
                    fy(trac,:)=SPIKY_f_moving_average_weighted(fy(trac,:),fx,s_para.mao);
                end
            elseif fdata_type==2      % piecewise linear
                mova=1;
                for trac=1:size(fy,1)
                    %fx=fx(2:2:end)-fx([1 2:2:end-2]);
                    fy(trac,1:length(fx))=mean([fy(trac,2:2:end); fy(trac,1:2:end)]);
                    fy(trac,1:length(fx))=SPIKY_f_moving_average_weighted(fy(trac,1:length(fx)),fx,s_para.mao);
                end
                fy=fy(:,1:length(fx));
            elseif fdata_type==3      % sampled
                if size(fy,1)==1
                    fy=SPIKY_f_moving_average(fy,s_para.mao);
                else
                    fy=SPIKY_f_moving_average_para(fy,s_para.mao);
                end
            end
        elseif s_para.causal==1                                            % realtime (average over past values only)
            if fdata_type==1          % piecewise constant
                for trac=1:size(fy,1)
                    fy(trac,:)=SPIKY_f_moving_average_weighted_p(fy(trac,:),fx,s_para.mao);
                end
            elseif fdata_type==2      % piecewise linear
                mova=1;
                for trac=1:size(fy,1)
                    %fx=fx(2:2:end)-fx([1 2:2:end-2]);
                    fy(trac,1:length(fx))=mean([fy(trac,2:2:end); fy(trac,1:2:end)]);
                    fy(trac,1:length(fx))=SPIKY_f_moving_average_weighted_p(fy(trac,1:length(fx)),fx,s_para.mao);
                end
                fy=fy(:,1:length(fx));
            elseif fdata_type==3      % sampled
                if size(fy,1)==1
                    fy=SPIKY_f_moving_average_p(fy,s_para.mao);
                else
                    fy=SPIKY_f_moving_average_para_p(fy,s_para.mao);
                end
            end
        elseif s_para.causal==2                                            % forward (average over future values only)
            if fdata_type==1          % piecewise constant
                for trac=1:size(fy,1)
                    fy(trac,:)=SPIKY_f_moving_average_weighted_f(fy(trac,:),fx,s_para.mao);
                end
            elseif fdata_type==2      % piecewise linear
                mova=1;
                for trac=1:size(fy,1)
                    %fx=fx(2:2:end)-fx([1 2:2:end-2]);
                    fy(trac,1:length(fx))=mean([fy(trac,2:2:end); fy(trac,1:2:end)]);
                    fy(trac,1:length(fx))=SPIKY_f_moving_average_weighted_f(fy(trac,1:length(fx)),fx,s_para.mao);
                end
                fy=fy(:,1:length(fx));
            elseif fdata_type==3      % sampled
                if size(fy,1)==1
                    fy=SPIKY_f_moving_average_f(fy,s_para.mao);
                else
                    fy=SPIKY_f_moving_average_para_f(fy,s_para.mao);
                end
            end
        end
        %fheadline=[fheadline,'*'];
    end
                                                                                    %
    if fdata_type==1 || mova==1                                            % using vectors of length "num_isi" (piecewise constant, pico)
        ctfx=cumsum([0 fx]);
        pfx=s_para.itmin+sort([ctfx(1:end) ctfx(2:end-1)]);
        if size(fy,1)==1
            pfy=reshape([fy; fy],1,length(fy)*2);
        end
        if s_para.spike_ave==0                          % time-weighted average
            ave=sum(fy.*repmat(fx,size(fy,1),1),2)/sum(fx);
        elseif s_para.spike_ave==1
            ave=mean(fy);                               % spike-weighted average
        elseif s_para.spike_ave==2
            ave=sum(fy);                               % spike-weighted average, include intervals of zero length
            if ~isempty(s_para.zero_intervals)
                dummy=s_para.zero_intervals;
                for zic=1:length(dummy)
                    zi=dummy(zic);
                    ave=ave+(fy(zi-1)+fy(zi))/2;
                    dummy(zic+1:end)=dummy(zic+1:end)-1;
                end
            end
            ave=ave/s_para.num_all_isi;
        end
    elseif fdata_type==2                                                   % using vectors of length "2*num_isi" (piecewise linear, pili)
        ctfx=cumsum([0 fx]);
        pfx=s_para.itmin+sort([ctfx(1:end) ctfx(2:end-1)]);
        pfy=fy;
        if s_para.causal==0
            odds=1:2:length(fx)*2;
            evens=odds+1;
            if s_para.spike_ave==0                          % time-weighted average            
                ave=sum((fy(:,odds)+fy(:,evens))/2.*repmat(fx,size(fy,1),1),2)/sum(fx);
            elseif s_para.spike_ave==1
                ave=mean((fy(:,odds)+fy(:,evens))/2);       % spike-weighted average
            elseif s_para.spike_ave==2
                ave=sum((fy(:,odds)+fy(:,evens))/2);       % spike-weighted average, include intervals of zero length
                if ~isempty(s_para.zero_intervals)
                    dummy=s_para.zero_intervals;
                    for zic=1:length(dummy)
                        zi=dummy(zic);
                        ave=ave+(fy(zi*2-2)+fy(zi*2-1))/2;
                        dummy(zic+1:end)=dummy(zic+1:end)-1;
                    end
                end
                ave=ave/s_para.num_all_isi;
            end
        else                                             % 1-realtime,2-future
            ave=profi_ave';
        end
    elseif fdata_type==3                                                   % using vectors of length "len" (not really used anymore apart from PSTH)
        pfx=fx;
        pfy=fy;
        if s_para.spike_disc==0
            num_profs=size(fy,1);
            ave=mean(fy,2)*(s_para.psth+(s_para.psth==0));
        else
            num_profs=mod(size(fy,1),2)+(size(fy,1)-mod(size(fy,1),2))/2;
            ave=zeros(num_profs,1);
            if length(fy)>2
                if s_para.spike_disc==1
                    spike_sync_indy=2:length(fy)-1;  % no spike at beginning and end
                elseif s_para.spike_disc==2
                    spike_sync_indy=1:length(fy)-1;  % spike at beginning
                elseif s_para.spike_disc==3
                    spike_sync_indy=2:length(fy);    % spike at end
                elseif s_para.spike_disc==4
                    spike_sync_indy=1:length(fy);    % spike at beginning and end
                end
                if mod(s_para.profile_mode,2)>0
                    ave(1)=mean(fy(1,spike_sync_indy),2);    % check profiles only % ########
                end
            else
                ave(1)=1;
            end
        end
    end
    
    if mod(s_para.plot_mode,2)>0 && fsp_posi>0                                                              % plotting
        if s_para.profile_norm_mode<4
            num_vals=2;
            if s_para.num_subplots<4
                intvals=[0.5 1];
            elseif s_para.num_subplots<8
                intvals=[0.4 0.8];
            else
                intvals=[0.3 0.6];
            end
            intlab=unique([0 SPIKY_f_lab(intvals*fmaxval,num_vals,1,1)]);
        else
            num_vals=3;
            if s_para.num_subplots<4
                intvals=[fminval fmaxval];
                if fminval==0 && fmaxval==1
                    num_vals=2;
                end
            elseif s_para.num_subplots<8
                intvals=[fminval+0.1*(fmaxval-fminval) fmaxval-0.1*(fmaxval-fminval)];
            else
                intvals=[fminval+0.25*(fmaxval-fminval) fmaxval-0.25*(fmaxval-fminval)];
            end
            intlab=unique(SPIKY_f_lab(intvals,num_vals,0,1));
        end
        if ~isempty(intlab) && ~all(intlab==1) && ~all(intlab==0)
            intlab=unique(intlab([1 end]));
        else
            if fmaxval==fminval
                if fmaxval==1
                    intlab=[0.8 1 1.2];
                elseif fmaxval==0
                    intlab=[-0.2 0 0.2];
                else
                    intlab=[0 fmaxval 1];
                end
            end
        end
        if s_para.psth>0
            intlab(1)=0;
        end
        if s_para.spike_order
            intlab=unique([-intlab(2) intlab]);
        end
        %intlab
        %[fminval fmaxval]
        if s_para.profile_norm_mode>3 && fmaxval==fminval
            fminval=intlab(1);
            fmaxval=intlab(end);
            yt=[fyt s_para.yl(2)-fsp_start+(0.05+(intlab(2)-fminval)/(fmaxval-fminval))/1.1*fsp_size];
            intlab=intlab(2);
        else
            yt=[fyt s_para.yl(2)-fsp_start+(0.05+(intlab-fminval)/(fmaxval-fminval))/1.1*fsp_size];
        end
        intlab(end)=intlab(end)*(s_para.psth+(s_para.psth==0));
        ytl=[fytl intlab];
        
        if length(fheadline)>10
            text(s_para.xl(1)-0.1*(s_para.xl(2)-s_para.xl(1)),s_para.yl(2)-fsp_start+0.6/1.1*fsp_size,fheadline,...
                'Visible',p_para.measure_vis,'Color',p_para.measure_col,'FontSize',p_para.measure_fs,'FontWeight',p_para.measure_fw,...
                'FontAngle',p_para.measure_fa,'UIContextMenu',p_para.measure_cmenu);
        else
            text(s_para.xl(1)-0.08*(s_para.xl(2)-s_para.xl(1)),s_para.yl(2)-fsp_start+0.6/1.1*fsp_size,fheadline,...
                'Visible',p_para.measure_vis,'Color',p_para.measure_col,'FontSize',p_para.measure_fs,'FontWeight',p_para.measure_fw,...
                'FontAngle',p_para.measure_fa,'UIContextMenu',p_para.measure_cmenu);
        end
        line(s_para.xl,s_para.yl(2)-fsp_start+0.05/1.1*fsp_size*ones(1,2),...
            'Visible',p_para.sp_bounds_vis,'Color',p_para.sp_bounds_col,'LineStyle',p_para.sp_bounds_ls,...
            'LineWidth',p_para.sp_bounds_lw,'UIContextMenu',p_para.sp_bounds_cmenu);
        line(s_para.xl,s_para.yl(2)-fsp_start+1.05/1.1*fsp_size*ones(1,2),...
            'Visible',p_para.sp_bounds_vis,'Color',p_para.sp_bounds_col,'LineStyle',p_para.sp_bounds_ls,...
            'LineWidth',p_para.sp_bounds_lw,'UIContextMenu',p_para.sp_bounds_cmenu);
        
        if size(fy,1)==1                                                                % only one profile
            
            if s_para.nma(nmac)==1
                if length(pfx)~=length(pfy)
                    p_para.prof_lh(p_para.supc,1)=plot(pfx,s_para.yl(2)-fsp_start+((0.05+pfy-fminval)/(fmaxval-fminval))/1.1*fsp_size,...  % '.-',
                        'Visible',p_para.prof_vis,'Color',p_para.prof_col,'LineStyle',p_para.prof_ls,...
                        'LineWidth',p_para.prof_lw,'UIContextMenu',p_para.prof_cmenu);
                else
                    p_para.prof_lh(p_para.supc,1)=plot(pfx,s_para.yl(2)-fsp_start+(0.05+(pfy-fminval)/(fmaxval-fminval))/1.1*fsp_size,...
                        'Visible',p_para.prof_vis,'Color',p_para.prof_col,'LineStyle',p_para.prof_ls,...
                        'LineWidth',p_para.prof_lw,'UIContextMenu',p_para.prof_cmenu);
                    if s_para.spike_disc>0          % same handle ???
                        if length(pfy)>2
                            if length(pfy)<100
                                p_para.prof_lh(p_para.supc,1)=plot(pfx(spike_sync_indy),s_para.yl(2)-fsp_start+(0.05+(pfy(spike_sync_indy)-fminval)/(fmaxval-fminval))/1.1*fsp_size,'*',...
                                    'Visible',p_para.prof_vis,'Color',p_para.prof_col,'LineStyle',p_para.prof_ls,...
                                    'LineWidth',p_para.prof_lw,'UIContextMenu',p_para.prof_cmenu);
                            elseif length(pfy)<1000
                                p_para.prof_lh(p_para.supc,1)=plot(pfx(spike_sync_indy),s_para.yl(2)-fsp_start+(0.05+(pfy(spike_sync_indy)-fminval)/(fmaxval-fminval))/1.1*fsp_size,'.',...
                                    'Visible',p_para.prof_vis,'Color',p_para.prof_col,'LineStyle',p_para.prof_ls,...
                                    'LineWidth',p_para.prof_lw,'UIContextMenu',p_para.prof_cmenu,'MarkerSize',15);
                            else
                                p_para.prof_lh(p_para.supc,1)=plot(pfx(spike_sync_indy),s_para.yl(2)-fsp_start+(0.05+(pfy(spike_sync_indy)-fminval)/(fmaxval-fminval))/1.1*fsp_size,'.',...
                                    'Visible',p_para.prof_vis,'Color',p_para.prof_col,'LineStyle',p_para.prof_ls,...
                                    'LineWidth',p_para.prof_lw,'UIContextMenu',p_para.prof_cmenu,'MarkerSize',12);
                            end
                        end
                        %xl=xlim; yl=ylim;
                        %text(xl(1)+0.67*(xl(2)-xl(1)),yl(1)+0.965*(yl(2)-yl(1)),num2str(ave,12),'FontWeight','bold','FontSize',18,'Color','r')   % ######
                    end
                end
                if length(pfx)==length(pfy) && s_para.spike_disc~=0 && length(pfy)>2
                    set(p_para.prof_lh(p_para.supc),'UserData',[pfx(spike_sync_indy) mac; pfy(spike_sync_indy) 0],'Tag',fheadline)
                else
                    set(p_para.prof_lh(p_para.supc),'UserData',[pfx mac; pfy 0],'Tag',fheadline)
                end
            else
                p_para.ma_prof_lh(p_para.supc,1)=plot(pfx,s_para.yl(2)-fsp_start+(0.05+(pfy-fminval)/(fmaxval-fminval))/1.1*fsp_size,...
                    'Visible',p_para.ma_prof_vis,'Color',p_para.ma_prof_col,'LineStyle',p_para.ma_prof_ls,...
                    'LineWidth',p_para.ma_prof_lw,'UIContextMenu',p_para.ma_prof_cmenu);
                if length(pfx)==length(pfy) && s_para.spike_disc~=0 && length(pfy)>2
                    set(p_para.ma_prof_lh(p_para.supc),'UserData',[pfx(spike_sync_indy) mac; pfy(spike_sync_indy) 0],'Tag',fheadline)
                else
                    set(p_para.ma_prof_lh(p_para.supc),'UserData',[pfx mac; pfy 0],'Tag',fheadline)
                end
            end
            if s_para.profile_average_line && nmac==1
                if s_para.spike_disc==0
                    ypos=0.93;
                else
                    ypos=0.73;
                end
                p_para.ave_lh(p_para.supc)=line([s_para.itmin s_para.itmax],s_para.yl(2)-fsp_start+(0.05+(ave-fminval)/(fmaxval-fminval))/1.1*fsp_size*ones(1,2),...
                   'Visible',p_para.ave_vis,'Color',p_para.ave_col,'LineStyle',p_para.ave_ls,...
                   'LineWidth',p_para.ave_lw,'UIContextMenu',p_para.ave_cmenu);
                if ave>0.82 && ave<0.92
                    p_para.prof_ave_fh(p_para.supc)=text(s_para.xl(2)-0.16*(s_para.xl(2)-s_para.xl(1)),s_para.yl(2)-fsp_start+(ypos-0.1)/1.1*fsp_size,num2str(ave,4),...
                        'Color',p_para.prof_ave_col,'FontSize',p_para.prof_ave_fs,'FontWeight',p_para.prof_ave_fw,'UIContextMenu',p_para.prof_ave_cmenu);
                else
                    p_para.prof_ave_fh(p_para.supc)=text(s_para.xl(2)-0.16*(s_para.xl(2)-s_para.xl(1)),s_para.yl(2)-fsp_start+ypos/1.1*fsp_size,num2str(ave,4),...
                        'Color',p_para.prof_ave_col,'FontSize',p_para.prof_ave_fs,'FontWeight',p_para.prof_ave_fw,'UIContextMenu',p_para.prof_ave_cmenu);
                end
            end
            
        elseif nmac<2                                                                   % ISIs and rates for individual trials
            
            if fdata_type==1                                               % using vectors of length "num_isi" (piecewise constant)
                pfyy=zeros(size(fy));
                for trac=1:size(fy,1)
                    fyy=fy(trac,:);
                    pfyy(trac,1:length(fyy)*2)=reshape([fyy; fyy],1,length(fyy)*2);
                    if isfield(s_para,'dcols') && size(s_para.dcols,1)==size(fy,1)
                        if s_para.profile_mode==3 && trac==1
                            p_para.prof_lh(p_para.supc,trac)=plot(pfx,s_para.yl(2)-fsp_start+(0.05+(pfyy(trac,1:length(fyy)*2)-fminval)/(fmaxval-fminval))/1.1*fsp_size,...
                                'Visible',p_para.prof_vis,'Color',s_para.dcols(trac,:),'LineStyle',p_para.prof_ls,...
                                'LineWidth',p_para.prof_lw+1,'UIContextMenu',p_para.prof_cmenu);
                        else
                            p_para.prof_lh(p_para.supc,trac)=plot(pfx,s_para.yl(2)-fsp_start+(0.05+(pfyy(trac,1:length(fyy)*2)-fminval)/(fmaxval-fminval))/1.1*fsp_size,...
                                'Visible',p_para.prof_vis,'Color',s_para.dcols(trac,:),'LineStyle',p_para.prof_ls,...
                                'LineWidth',p_para.prof_lw,'UIContextMenu',p_para.prof_cmenu);
                        end
                    else
                        p_para.prof_lh(p_para.supc,trac)=plot(pfx,s_para.yl(2)-fsp_start+(0.05+(pfyy(trac,1:length(fyy)*2)-fminval)/(fmaxval-fminval))/1.1*fsp_size,...
                            'Visible',p_para.prof_vis,'Color',p_para.prof_col,'LineStyle',p_para.prof_ls,...
                            'LineWidth',p_para.prof_lw,'UIContextMenu',p_para.prof_cmenu);
                    end
                    if s_para.profile_average_line && trac==1
                        p_para.ave_lh(p_para.supc)=line([s_para.itmin s_para.itmax],s_para.yl(2)-fsp_start+(0.05+(ave(1)-fminval)/(fmaxval-fminval))/1.1*fsp_size*ones(1,2),...
                            'Visible',p_para.ave_vis,'Color',p_para.ave_col,'LineStyle',p_para.ave_ls,...
                            'LineWidth',p_para.ave_lw,'UIContextMenu',p_para.ave_cmenu);
                        if ave(1)>0.82 && ave<0.92
                            p_para.prof_ave_fh(p_para.supc)=text(s_para.xl(2)-0.16*(s_para.xl(2)-s_para.xl(1)),s_para.yl(2)-fsp_start+0.83/1.1*fsp_size,num2str(ave(1),4),...
                                'Color',p_para.prof_ave_col,'FontSize',p_para.prof_ave_fs,'FontWeight',p_para.prof_ave_fw,'UIContextMenu',p_para.prof_ave_cmenu);
                        else
                            p_para.prof_ave_fh(p_para.supc)=text(s_para.xl(2)-0.16*(s_para.xl(2)-s_para.xl(1)),s_para.yl(2)-fsp_start+0.93/1.1*fsp_size,num2str(ave(1),4),...
                                'Color',p_para.prof_ave_col,'FontSize',p_para.prof_ave_fs,'FontWeight',p_para.prof_ave_fw,'UIContextMenu',p_para.prof_ave_cmenu);
                        end
                    end
                end
                set(p_para.prof_lh(p_para.supc),'UserData',[pfx mac; pfyy zeros(1,size(fy,1))'],'Tag',fheadline)
            else                                    % using vectors of length length "2*num_isi" (piecewise linear) or "len" (sampled)
                if s_para.spike_disc==0
                    num_profs=size(fy,1);
                end
                for trac=1:num_profs
                    pfyy=fy(trac,:);
                    if isfield(s_para,'dcols') && size(s_para.dcols,1)==num_profs
                        if s_para.profile_mode==3 && trac==1
                            p_para.prof_lh(p_para.supc,trac)=plot(pfx,s_para.yl(2)-fsp_start+(0.05+(pfyy-fminval)/(fmaxval-fminval))/1.1*fsp_size,...
                                'Visible',p_para.prof_vis,'Color',s_para.dcols(trac,:),'LineStyle',p_para.prof_ls,...
                                'LineWidth',p_para.prof_lw,'UIContextMenu',p_para.prof_cmenu);
                            if s_para.spike_disc~=0 && length(pfyy)>2
                                if length(pfyy)<100
                                    plot(pfx(spike_sync_indy),s_para.yl(2)-fsp_start+(0.05+(pfyy(spike_sync_indy)-fminval)/(fmaxval-fminval))/1.1*fsp_size,'*',...
                                        'Visible',p_para.prof_vis,'Color',s_para.dcols(trac,:),'LineStyle','none');
                                else
                                    plot(pfx(spike_sync_indy),s_para.yl(2)-fsp_start+(0.05+(pfyy(spike_sync_indy)-fminval)/(fmaxval-fminval))/1.1*fsp_size,'.',...
                                        'Visible',p_para.prof_vis,'Color',s_para.dcols(trac,:),'LineStyle','none');
                                end
                            end
                        else
                            if s_para.spike_disc==0
                                p_para.prof_lh(p_para.supc,trac)=plot(pfx,s_para.yl(2)-fsp_start+(0.05+(pfyy-fminval)/(fmaxval-fminval))/1.1*fsp_size,...
                                    'Visible',p_para.prof_vis,'Color',s_para.dcols(trac,:),'LineStyle',p_para.prof_ls,...
                                    'LineWidth',p_para.prof_lw,'UIContextMenu',p_para.prof_cmenu);
                            else
                                pfindy=find(fy(trac+(size(fy,1)-mod(size(fy,1),2))/2,:));
                                if ~isempty(pfindy)
                                    p_para.prof_lh(p_para.supc,trac)=plot(pfx(pfindy),s_para.yl(2)-fsp_start+(0.05+(pfyy(pfindy)-fminval)/(fmaxval-fminval))/1.1*fsp_size,...
                                        'Visible',p_para.prof_vis,'Color',s_para.dcols(trac,:),'LineStyle',p_para.prof_ls,...
                                        'LineWidth',p_para.prof_lw,'UIContextMenu',p_para.prof_cmenu);
                                    if length(pfyy)>2
                                        dummindy=intersect(pfindy,spike_sync_indy);
                                        if length(pfyy)<100
                                            plot(pfx(dummindy),s_para.yl(2)-fsp_start+(0.05+(pfyy(dummindy)-fminval)/(fmaxval-fminval))/1.1*fsp_size,'*',...
                                                'Visible',p_para.prof_vis,'Color',s_para.dcols(trac,:),'LineStyle','none');
                                        else
                                            plot(pfx(dummindy),s_para.yl(2)-fsp_start+(0.05+(pfyy(dummindy)-fminval)/(fmaxval-fminval))/1.1*fsp_size,'.',...
                                                'Visible',p_para.prof_vis,'Color',s_para.dcols(trac,:),'LineStyle','none');
                                        end
                                        ave(trac)=mean(pfyy(1,dummindy),2);
                                    end
                                end
                            end
                        end
                    else
                        p_para.prof_lh(p_para.supc,trac)=plot(pfx,s_para.yl(2)-fsp_start+(0.05+(pfyy-fminval)/(fmaxval-fminval))/1.1*fsp_size,...
                            'Visible',p_para.prof_vis,'Color',p_para.prof_col,'LineStyle',p_para.prof_ls,...
                            'LineWidth',p_para.prof_lw,'UIContextMenu',p_para.prof_cmenu);
                    end
                    if s_para.profile_average_line && trac==1
                        p_para.ave_lh(p_para.supc)=line([s_para.itmin s_para.itmax],s_para.yl(2)-fsp_start+(0.05+(ave(1)-fminval)/(fmaxval-fminval))/1.1*fsp_size*ones(1,2),...
                            'Visible',p_para.ave_vis,'Color',p_para.ave_col,'LineStyle',p_para.ave_ls,...
                            'LineWidth',p_para.ave_lw,'UIContextMenu',p_para.ave_cmenu);
                        if ave(1)>0.82 && ave<0.92
                            p_para.prof_ave_fh(p_para.supc)=text(s_para.xl(2)-0.16*(s_para.xl(2)-s_para.xl(1)),s_para.yl(2)-fsp_start+0.83/1.1*fsp_size,num2str(ave(1),4),...
                                'Color',p_para.prof_ave_col,'FontSize',p_para.prof_ave_fs,'FontWeight',p_para.prof_ave_fw,'UIContextMenu',p_para.prof_ave_cmenu);
                        else
                            p_para.prof_ave_fh(p_para.supc)=text(s_para.xl(2)-0.16*(s_para.xl(2)-s_para.xl(1)),s_para.yl(2)-fsp_start+0.93/1.1*fsp_size,num2str(ave(1),4),...
                                'Color',p_para.prof_ave_col,'FontSize',p_para.prof_ave_fs,'FontWeight',p_para.prof_ave_fw,'UIContextMenu',p_para.prof_ave_cmenu);
                        end
                    end
                end
                set(p_para.prof_lh(p_para.supc),'UserData',[pfx mac; fy zeros(1,size(fy,1))'],'Tag',fheadline)
                % if length(pfx)==length(pfy) && s_para.spike_disc~=0 && length(pfy)>2
                %     set(p_para.prof_lh(p_para.supc),'UserData',[pfx(spike_sync_indy) mac; fy(spike_sync_indy) zeros(1,size(fy(spike_sync_indy),1))'],'Tag',fheadline)   % #####
                % else
                %     set(p_para.prof_lh(p_para.supc),'UserData',[pfx mac; fy zeros(1,size(fy,1))'],'Tag',fheadline)
                % end
            end
        end
    else
        yt=[];
        ytl=[];
    end
end
%if size(fy,1)==1
fave=[fave ave];
%else
end

