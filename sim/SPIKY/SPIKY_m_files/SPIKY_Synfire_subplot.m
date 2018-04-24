if run==1
    if multi_figure==1
        figure(100*dc)
    else
        figure(555)
    end
    clf
    set(gcf,'Name',[measure_name,'   ---   ',para.dataset_str])
    set(gcf,'Units','normalized','Position',[0 0.0044 1.0000 0.8900])
    subplotc=0;
    
    cm=colormap;
    dcol_indy=round(64:-63/(para.num_trains-1):1);
    dcols=cm(dcol_indy,:);
    synf_title_cmenu = uicontextmenu;
    synf_title_fh=zeros(1,7);
    synf_label_cmenu = uicontextmenu;
    synf_label_fh=zeros(1,3);
    synf_c_result_cmenu = uicontextmenu;
    synf_f_result_fh=zeros(1,2);
    synf_f_result_cmenu = uicontextmenu;
    synf_c_result_fh=zeros(1,2);
    synf_sublabel_cmenu = uicontextmenu;
    synf_sublabel_fh=zeros(1,6);
    synf_cblabel_cmenu = uicontextmenu;
    synf_cblabel_fh=zeros(1,2);
    synf_c_line_cmenu = uicontextmenu;
    synf_c_line_lh=zeros(1,4);
    synf_e_line_cmenu = uicontextmenu;
    synf_e_line_lh=zeros(1,2);
    synf_halfmat_line_cmenu = uicontextmenu;
    synf_halfmat_line_lh=zeros(2,(para.num_trains*(para.num_trains-1)/2)*2);
end





% ###################################################################################
% ##############################                       ##############################
% ##############################         Spikes        ##############################
% ##############################                       ##############################
% ###################################################################################

if ((run==1 && mod(plotting,2)>0) || (run==2 && mod(plotting,16)>7))
    subplotc=subplotc+1;
    subplot(num_plots,2,plot_pos(subplotc)*2+[-1 0])
    for trc=1:para.num_trains
        if sync_thr2>0
            if run==1
                for spc=1:length(or_spikes{trc})
                    line(or_spikes{trc}(spc)*ones(1,2),para.num_trains-[trc-1 trc],'Color','k','LineWidth',1)
                end
            else
                for spc=1:length(or_spikes{st_indy(trc)})
                    line(or_spikes{st_indy(trc)}(spc)*ones(1,2),para.num_trains-[trc-1 trc],'Color','k','LineWidth',1)
                end
            end
        end
        if run==1
            sync=results.SPIKE_synchro.profile(logical(all_trains==trc));
            order=results.SPIKE_order.spike_order_profile(logical(all_trains==trc));
        else
            sync=results.SPIKE_synchro.profile(logical(all_trains==st_indy(trc)));
            order=results.SPIKE_order.spike_order_profile(logical(all_trains==st_indy(trc)));
        end
        coli=ceil((order+1.01)*31.5);
        for spc=1:length(spikes{trc})
            if sync(spc)<=sync_thr || mod(color_spikes,2)==0
                line(spikes{trc}(spc)*ones(1,2),para.num_trains-[trc-1 trc],'Color','k','LineWidth',1+sync(spc)*2)
            else
                line(spikes{trc}(spc)*ones(1,2),para.num_trains-[trc-1 trc],'Color',cm(coli(spc),:),'LineWidth',1+sync(spc)*2)
            end
        end
    end
    xlim([para.tmin-0.02*para.range para.tmax+0.02*para.range])
    ylim([0 1]*para.num_trains)
    xl=xlim; yl=ylim;
    if para.num_trains<11
        if run==1
            set(gca,'YTick',-0.5+(1:para.num_trains),'YTickLabel',fliplr(1:para.num_trains))
        else
            set(gca,'YTick',-0.5+(1:para.num_trains),'YTickLabel',flipud(st_indy))
        end
    else
        set(gca,'YTick',[])
    end
    if run==1
        synf_title_fh(1)=title('Spike trains',...
            'Visible',para.synf_title_vis,'Color',para.synf_title_col,'FontSize',para.synf_title_fs,...
            'FontWeight',para.synf_title_fw,'FontAngle',para.synf_title_fa,'UIContextMenu',synf_title_cmenu);
    else
        synf_title_fh(7)=title('Sorted spike trains',...
            'Visible',para.synf_title_vis,'Color',para.synf_title_col,'FontSize',para.synf_title_fs,...
            'FontWeight',para.synf_title_fw,'FontAngle',para.synf_title_fa,'UIContextMenu',synf_title_cmenu);
    end
    if run==2 || plotting<2
        synf_label_fh(1)=xlabel('Time',...
            'Visible',para.synf_label_vis,'Color',para.synf_label_col,'FontSize',para.synf_label_fs,...
            'FontWeight',para.synf_label_fw,'FontAngle',para.synf_label_fa,'UIContextMenu',synf_label_cmenu);
    end
    if mod(color_spikes,2)>0
        cb=colorbar;
        if num_plots<3 && d_para.num_trains>10
            set(cb,'YTick',1:63/10:64,'YTickLabel',-1:0.2:1)
        elseif num_plots<5 && d_para.num_trains>4
            set(cb,'YTick',1:63/4:64,'YTickLabel',-1:0.5:1)
        else
            set(cb,'YTick',1:63/2:64,'YTickLabel',-1:1)
        end
        xl=xlim;
        yl=ylim;
        synf_cblabel_fh(run)=text(xl(1)+1.1*diff(xl),yl(2)-0.25*diff(yl),'D',...
            'Visible',para.synf_cblabel_vis,'Color',para.synf_cblabel_col,'FontSize',para.synf_cblabel_fs,...
            'FontWeight',para.synf_cblabel_fw,'FontAngle',para.synf_cblabel_fa,'UIContextMenu',synf_cblabel_cmenu);
        gcp=get(gca,'Position');
    end
    if patching==1
        if run==1
            %coli=ceil((st_indy+1.01)*31.5)
            %coli=ceil(((st_indy-1)/(para.num_trains-1))*63)+1
            for trc=1:para.num_trains
                patch([para.tmin-0.01*para.range para.tmin-0.02*para.range*ones(1,2) para.tmin-0.01*para.range],para.num_trains+1-trc-1+[0 0 1 1],...
                    dcols(trc,:),'EdgeColor',dcols(trc,:));
                %patch([para.tmax+0.01*para.range para.tmax+0.02*para.range*ones(1,2) para.tmax+0.01*para.range],para.num_trains+1-trc-1+[0 0 1 1],...
                %    dcols(trc,:),'EdgeColor',dcols(trc,:));
            end
        else
            %coli=ceil((sorted_st_order+1.01)*31.5);
            coli=ceil(((st_indy-1)/(para.num_trains-1))*63)+1;
            for trc=1:para.num_trains
                patch([para.tmin-0.01*para.range para.tmin-0.025*para.range*ones(1,2) para.tmin-0.01*para.range],para.num_trains+1-trc-1+[0 0 1 1],...
                    dcols(st_indy(trc),:),'EdgeColor',dcols(st_indy(trc),:));
                %patch([para.tmax+0.01*para.range para.tmax+0.025*para.range*ones(1,2) para.tmax+0.01*para.range],para.num_trains+1-trc-1+[0 0 1 1],...
                %    dcols(st_indy(trc),:),'EdgeColor',dcols(st_indy(trc),:));
            end
        end
    end
    if num_plots>1
        synf_sublabel_fh(plot_pos(subplotc))=text(xl(1)-0.06*(xl(2)-xl(1)),yl(2)+0.05*(yl(2)-yl(1)),['(',alphabet(plot_pos(subplotc)),')'],...
            'Visible',para.synf_sublabel_vis,'Color',para.synf_sublabel_col,'FontSize',para.synf_sublabel_fs,...
            'FontWeight',para.synf_sublabel_fw,'FontAngle',para.synf_sublabel_fa,'UIContextMenu',synf_sublabel_cmenu);
    end
    box on
    
    prof_tick_cmenu = uicontextmenu;
    prof_tick_fh=zeros(1,2);
    prof_tick_fh(1)=line(xl,yl(1)*ones(1,2),'Color',para.prof_tick_col,'UIContextMenu',prof_tick_cmenu);
    prof_tick_fh(2)=line(xl(1)*ones(1,2),yl,'Color','w','UIContextMenu',prof_tick_cmenu);
    fh_str='prof_tick';
    SPIKY_handle_set_property
end





% ###################################################################################
% ############################                           ############################
% ############################   Dissimilarity profile   ############################
% ############################                           ############################
% ###################################################################################

if ((run==1 && mod(plotting,4)>1) || (run==2 && mod(plotting,32)>15))
    subplotc=subplotc+1;
    subplot(num_plots,2,plot_pos(subplotc)*2+[-1 0])
    
    mean_all=results.SPIKE_order.overall;
    if sync_thr==0
        x=results.SPIKE_order.time;
        mean_thr=mean_all;
    else
        x=results.SPIKE_order.time(results.SPIKE_synchro.profile>=sync_thr);
    end
    
    hold on
    xlim([para.tmin-0.02*para.range para.tmax+0.02*para.range])
    ylim([-1.1 1.1])
    xl=xlim; yl=ylim;
    line(xl,ones(1,2),'LineStyle',':','Color','k')
    line(xl,-ones(1,2),'LineStyle',':','Color','k')
    line(xl,zeros(1,2),'LineStyle',':','Color','k')
    
    prc2=0;
    if mod(plot_profiles,8)>3                                               % E-profile (symmetric, to be maximized)
        prc2=prc2+1;
        if sync_thr==0
            e_prof=results.SPIKE_order.spike_train_order_profile;
        else
            e_prof=results.SPIKE_order.spike_train_order_profile(results.SPIKE_synchro.profile>=sync_thr);
            mean_thr=mean(e_prof);
        end
        para.synf_e_line_col=prof_color(1);
        if plot_profiles==4
            para.synf_e_line_ls=':';
            synf_e_line_lh(run)=plot(x,e_prof(1,:),...
                'Visible',para.synf_e_line_vis,'Color',para.synf_e_line_col,'LineStyle',para.synf_e_line_ls,'LineWidth',para.synf_e_line_lw,...
                'Marker',para.synf_e_line_m,'MarkerSize',para.synf_e_line_ms,'UIContextMenu',synf_e_line_cmenu);
        else
            para.synf_e_line_ls='-';
            synf_e_line_lh(run)=plot(x,e_prof(1,:),...
                'Visible',para.synf_e_line_vis,'Color',para.synf_e_line_col,'LineStyle',para.synf_e_line_ls,'LineWidth',para.synf_e_line_lw,...
                'Marker',para.synf_e_line_m,'MarkerSize',para.synf_e_line_ms,'UIContextMenu',synf_e_line_cmenu);
            %ylabel('C, E','FontSize',fs,'FontWeight','bold','Rotation',0)
            %text(xl(1)-0.06*(xl(2)-xl(1)),0.6,'C, E','FontSize',fs,'FontWeight','bold','Rotation',0)
        end
        if sync_thr==0
            %line(xl,mean_all*ones(1,2),'LineStyle','--','Color',prof_color(1))
        else
            %line(xl,mean_all*ones(1,2),'LineStyle',':','Color',prof_color(1))
            %line(xl,mean_thr*ones(1,2),'LineStyle','--','Color',prof_color(1))
        end
        para.synf_f_result_col=prof_color(1);
        if run==1
            %text(xl(2)+0.01*(xl(2)-xl(1)),yl(1)+(0.75-(prof_pos(prc2)-1)*0.25-0.25*(mod(plot_profiles,4)<=1))*(yl(2)-yl(1)),[prof_letter(3),'_u=',num2str(mean_thr,3)],...
            %    'Color',prof_color(1),'FontSize',fs+1,'FontWeight','bold')
            synf_f_result_fh(run)=text(xl(2)+0.01*(xl(2)-xl(1)),yl(1)+(0.75-(prof_pos(prc2)-1)*0.25-0.25*(mod(plot_profiles,4)<=1))*(yl(2)-yl(1)),[prof_letter(3),'_u=',num2str(mean_thr,3)],...
                'Visible',para.synf_f_result_vis,'Color',para.synf_f_result_col,'FontSize',para.synf_f_result_fs,...
                'FontWeight',para.synf_f_result_fw,'FontAngle',para.synf_f_result_fa,'UIContextMenu',synf_f_result_cmenu);
        else
            %text(xl(2)+0.01*(xl(2)-xl(1)),yl(1)+(0.75-(prof_pos(prc2)-1)*0.25-0.25*(mod(plot_profiles,4)<=1))*(yl(2)-yl(1)),[prof_letter(3),'_s=',num2str(mean_thr,3)],...
            %    'Color',prof_color(1),'FontSize',fs+1,'FontWeight','bold')
            synf_f_result_fh(run)=text(xl(2)+0.01*(xl(2)-xl(1)),yl(1)+(0.75-(prof_pos(prc2)-1)*0.25-0.25*(mod(plot_profiles,4)<=1))*(yl(2)-yl(1)),[prof_letter(3),'_s=',num2str(mean_thr,3)],...
                'Visible',para.synf_f_result_vis,'Color',para.synf_f_result_col,'FontSize',para.synf_f_result_fs,...
                'FontWeight',para.synf_f_result_fw,'FontAngle',para.synf_f_result_fa,'UIContextMenu',synf_f_result_cmenu);
        end
    end
    
    if mod(plot_profiles,2)>0                                               % SPIKE-Sync-profile C (symmetric envelope)
        prc2=prc2+1;
        if sync_thr==0
            c_prof=results.SPIKE_synchro.profile;
        else
            c_prof=results.SPIKE_synchro.profile(results.SPIKE_synchro.profile>=sync_thr);
            line(xl,sync_thr*ones(1,2),'LineStyle',':','Color',prof_color(3))
            line(xl,-sync_thr*ones(1,2),'LineStyle',':','Color',prof_color(3))
        end
        para.synf_c_line_col=prof_color(3);
        if plot_profiles==1
            para.synf_c_line_ls='-';
            synf_c_line_lh(run)=plot(x,c_prof(1,:),...
                'Visible',para.synf_c_line_vis,'Color',para.synf_c_line_col,'LineStyle',para.synf_c_line_ls,'LineWidth',para.synf_c_line_lw,...
                'Marker',para.synf_c_line_m,'MarkerSize',para.synf_c_line_ms,'UIContextMenu',synf_c_line_cmenu);
            %plot(x,c_prof(1,:),['.-',prof_color(3)],'LineWidth',1,'MarkerSize',15)
            ylim([-0.05 1.05])
        else
            para.synf_c_line_ls='--';
            synf_c_line_lh(run*2-1)=plot(x,c_prof(1,:),...
                'Visible',para.synf_c_line_vis,'Color',para.synf_c_line_col,'LineStyle',para.synf_c_line_ls,'LineWidth',para.synf_c_line_lw,...
                'Marker',para.synf_c_line_m,'MarkerSize',para.synf_c_line_ms,'UIContextMenu',synf_c_line_cmenu);
            synf_c_line_lh(run*2)=plot(x,-c_prof(1,:),...
                'Visible',para.synf_c_line_vis,'Color',para.synf_c_line_col,'LineStyle',para.synf_c_line_ls,'LineWidth',para.synf_c_line_lw,...
                'Marker',para.synf_c_line_m,'MarkerSize',para.synf_c_line_ms,'UIContextMenu',synf_c_line_cmenu);
            %plot(x,c_prof(1,:),['.--',prof_color(3)],'LineWidth',1)
            %plot(x,-c_prof(1,:),['.--',prof_color(3)],'LineWidth',1)
        end
        mean_y3=mean(c_prof);
        para.synf_c_result_col=prof_color(3);
        %line(xl,mean_y3*ones(1,2),'LineStyle','--','Color',prof_color(3))
        synf_c_result_fh(run)=text(xl(2)+0.01*(xl(2)-xl(1)),yl(1)+(0.75-(prof_pos(prc2)-1)*0.25)*(yl(2)-yl(1)),[prof_letter(1),'=',num2str(mean_y3,3)],...
            'Visible',para.synf_c_result_vis,'Color',para.synf_c_result_col,'FontSize',para.synf_c_result_fs,...
            'FontWeight',para.synf_c_result_fw,'FontAngle',para.synf_c_result_fa,'UIContextMenu',synf_c_result_cmenu);
        %text(xl(2)+0.01*(xl(2)-xl(1)),yl(1)+(0.75-(prof_pos(prc2)-1)*0.25)*(yl(2)-yl(1)),[prof_letter(1),'=',num2str(mean_y3,3)],'Color',prof_color(3),'FontSize',fs+1)
    end
    
    if mod(plot_profiles,4)>1                                               % D-profile (anti-symmetric, mostly useless)
        %prc2=prc2+1;
        if sync_thr==0
            d_prof=results.SPIKE_order.spike_order_profile;
        else
            d_prof=results.SPIKE_order.spike_order_profile(results.SPIKE_synchro.profile>=sync_thr);
        end
        mean_y2=round(mean(d_prof)/0.0001)*0.0001;
        plot(x,d_prof(1,:),['.-',prof_color(2)],'LineWidth',1)
        line(xl,zeros(1,2),'LineStyle','--','Color',prof_color(2))
        %text(xl(2)+0.01*(xl(2)-xl(1)),yl(1)+(0.75-(prof_pos(prc2)-1)*0.25)*(yl(2)-yl(1)),[prof_letter(2),'=',num2str(mean_y2,3)],'Color',prof_color(2),'FontSize',fs+1,'FontWeight','bold')
        text(xl(2)+0.01*(xl(2)-xl(1)),yl(1)+0.5*(yl(2)-yl(1)),[prof_letter(2),'=',num2str(mean_y2,3)],'Color',prof_color(2),'FontSize',fs+1,'FontWeight','bold')
    end
    
    if mod(plot_profiles,16)>7 % && sync_thr2>0                               % ########### E-Values per global event (x-values found using D-Profile) ##############
        if mod(plot_profiles,4)<=1
            if sync_thr==0
                d_prof=results.SPIKE_order.spike_order_profile;
            else
                d_prof=results.SPIKE_order.spike_order_profile(results.SPIKE_synchro.profile>=sync_thr);
            end
        end
        ddp=diff(d_prof);
        end_events=unique([find(ddp>0 & d_prof(1:end-1)<0 & d_prof(2:end)>0) length(ddp)+1]);     % ###### make it work with noisy background spikes !!!!! ######
        start_events=unique([1 end_events(1:end-1)+1]);
        num_events=length(start_events);
        event_ave=zeros(1,num_events);
        event_time=zeros(1,num_events);
        for ec=1:num_events
            event_ave(ec)=mean(e_prof(start_events(ec):end_events(ec)));
            event_time(ec)=mean(x(start_events(ec):end_events(ec)));
        end
        plot(event_time,event_ave,'.g','LineWidth',4,'MarkerSize',26)
        event_seps=mean([end_events(1:num_events-1); start_events(2:num_events)]);
    end
    
    
    if num_plots<3
        set(gca,'YTick',-1:0.5:1)
    else
        set(gca,'YTick',-1:1)
    end
    prc2=0;
    for prc=1:3
        if profs(prc)>0
            prc2=prc2+1;
            if prc<3
                %text(xl(1)-0.05*(xl(2)-xl(1)),yl(1)+(0.8-(prof_pos(prc2)-1)*0.25)*(yl(2)-yl(1)),prof_letter(prc),'FontSize',fs-1,'Rotation',0,'Color',prof_color(prc),'FontWeight','bold')
            else
                %text(xl(1)-0.05*(xl(2)-xl(1)),yl(1)+(0.8-(prof_pos(prc2)-1)*0.25)*(yl(2)-yl(1)),prof_letter(prc),'FontSize',fs-1,'Rotation',0,'Color',prof_color(prc))
            end
        end
    end
    if plotting<4
        synf_label_cmenu = uicontextmenu;
        synf_label_fh(1)=xlabel('Time',...
            'Visible',para.synf_label_vis,'Color',para.synf_label_col,'FontSize',para.synf_label_fs,...
            'FontWeight',para.synf_label_fw,'FontAngle',para.synf_label_fa,'UIContextMenu',synf_label_cmenu);
    end
    if run==1
        synf_title_fh(2)=title(['Time profile ',prof_letter(4)],...
            'Visible',para.synf_title_vis,'Color',para.synf_title_col,'FontSize',para.synf_title_fs,...
            'FontWeight',para.synf_title_fw,'FontAngle',para.synf_title_fa,'UIContextMenu',synf_title_cmenu);
    else
        synf_title_fh(6)=title(['Time profile ',prof_letter(4),' for sorted spike trains'],...
            'Visible',para.synf_title_vis,'Color',para.synf_title_col,'FontSize',para.synf_title_fs,...
            'FontWeight',para.synf_title_fw,'FontAngle',para.synf_title_fa,'UIContextMenu',synf_title_cmenu);
    end
    if mod(color_spikes,2)>0
        gcp2=get(gca,'Position'); gcp2(3)=gcp(3);
        set(gca,'Position',gcp2);
    end
    if num_plots>1
        synf_sublabel_fh(plot_pos(subplotc))=text(xl(1)-0.06*(xl(2)-xl(1)),yl(2)+0.05*(yl(2)-yl(1)),['(',alphabet(plot_pos(subplotc)),')'],...
            'Visible',para.synf_sublabel_vis,'Color',para.synf_sublabel_col,'FontSize',para.synf_sublabel_fs,...
            'FontWeight',para.synf_sublabel_fw,'FontAngle',para.synf_sublabel_fa,'UIContextMenu',synf_sublabel_cmenu);
        if run==1 && mod(plotting,8)>5    % First matrix
            synf_sublabel_fh(plot_pos(subplotc)+1)=text(xl(1)-0.06*(xl(2)-xl(1)),yl(1)-0.4*(yl(2)-yl(1)),['(',alphabet(plot_pos(subplotc)+1),')'],...
                'Visible',para.synf_sublabel_vis,'Color',para.synf_sublabel_col,'FontSize',para.synf_sublabel_fs,...
                'FontWeight',para.synf_sublabel_fw,'FontAngle',para.synf_sublabel_fa,'UIContextMenu',synf_sublabel_cmenu);
        elseif run==2 && num_plots==6     % Second matrix
            synf_sublabel_fh(plot_pos(subplotc)-1)=text(xl(1)-0.06*(xl(2)-xl(1)),yl(2)+1.4*(yl(2)-yl(1)),['(',alphabet(plot_pos(subplotc)-1),')'],...
                'Visible',para.synf_sublabel_vis,'Color',para.synf_sublabel_col,'FontSize',para.synf_sublabel_fs,...
                'FontWeight',para.synf_sublabel_fw,'FontAngle',para.synf_sublabel_fa,'UIContextMenu',synf_sublabel_cmenu);
        end
    end
    box on
    
    prof_tick_cmenu = uicontextmenu;
    prof_tick_fh=zeros(1,2);
    prof_tick_fh(1)=line(xl,yl(1)*ones(1,2),'Color',para.prof_tick_col,'UIContextMenu',prof_tick_cmenu);
    prof_tick_fh(2)=line(xl(1)*ones(1,2),yl,'Color','w','UIContextMenu',prof_tick_cmenu);
    fh_str='prof_tick';
    SPIKY_handle_set_property
end





% ###################################################################################
% ############################                          #############################
% ############################   Dissimilarity matrix   #############################
% ############################                          #############################
% ###################################################################################

if (run==1 && mod(plotting,8)>3) || (run==2 && mod(plotting,64)>31)
    
    if run==1
        subplotc=subplotc+1;
        subplot(num_plots,3,plot_pos(subplotc)*3-2)
    else
        subplot(num_plots,3,plot_pos(subplotc)*3-4)
    end
    imagesc(results.SPIKE_order.matrix_cum)
    axis square
    set(gca,'FontSize',fs-2)
    caxis([-1 1]*max(num_spikes))
    xlim([0.5 para.num_trains+0.5])
    ylim([0.5 para.num_trains+0.5])
    if para.num_trains<10
        set(gca,'XTick',1:para.num_trains,'YTick',1:para.num_trains)
    end
    if run==1
        synf_title_fh(3)=title(['Pairwise matrix ',prof_letter(2)],...
            'Visible',para.synf_title_vis,'Color',para.synf_title_col,'FontSize',para.synf_title_fs,...
            'FontWeight',para.synf_title_fw,'FontAngle',para.synf_title_fa,'UIContextMenu',synf_title_cmenu);
    else
        synf_title_fh(4)=title(['Sorted pairwise matrix ',prof_letter(2)],...
            'Visible',para.synf_title_vis,'Color',para.synf_title_col,'FontSize',para.synf_title_fs,...
            'FontWeight',para.synf_title_fw,'FontAngle',para.synf_title_fa,'UIContextMenu',synf_title_cmenu);
    end
    %set(gca,'XTick',50:50:150,'YTick',50:50:150)
    if run==2
        colorbar
    end
    if mark_upper_matrix_half==1
        for trc=1:para.num_trains-1
            synf_halfmat_line_lh(run,trc*2-1)=line((trc+0.5)*ones(1,2),[trc-0.5 trc+0.5],...
                'Visible',para.synf_halfmat_line_vis,'Color',para.synf_halfmat_line_col,'LineStyle',para.synf_halfmat_line_ls,'LineWidth',para.synf_halfmat_line_lw,...
                'UIContextMenu',synf_halfmat_line_cmenu);
            synf_halfmat_line_lh(run,trc*2)=line([trc+0.5 trc+1.5],(trc+0.5)*ones(1,2),...
                'Visible',para.synf_halfmat_line_vis,'Color',para.synf_halfmat_line_col,'LineStyle',para.synf_halfmat_line_ls,'LineWidth',para.synf_halfmat_line_lw,...
                'UIContextMenu',synf_halfmat_line_cmenu);

            %line((trc+0.5)*ones(1,2),[trc-0.5 trc+0.5],'Color','k','LineWidth',2)
            %line([trc+0.5 trc+1.5],(trc+0.5)*ones(1,2),'Color','k','LineWidth',2)
        end
        synf_halfmat_line_lh(run,para.num_trains*2-1)=line((para.num_trains+0.5)*ones(1,2),[0.5 para.num_trains-0.5],...
            'Visible',para.synf_halfmat_line_vis,'Color',para.synf_halfmat_line_col,'LineStyle',para.synf_halfmat_line_ls,'LineWidth',para.synf_halfmat_line_lw,...
            'UIContextMenu',synf_halfmat_line_cmenu);
        synf_halfmat_line_lh(run,para.num_trains*2)=line([1.5 para.num_trains+0.5],0.5*ones(1,2),...
            'Visible',para.synf_halfmat_line_vis,'Color',para.synf_halfmat_line_col,'LineStyle',para.synf_halfmat_line_ls,'LineWidth',para.synf_halfmat_line_lw,...
            'UIContextMenu',synf_halfmat_line_cmenu);
        %line((para.num_trains+0.5)*ones(1,2),[0.5 para.num_trains-0.5],'Color','k','LineWidth',2)
        %line([1.5 para.num_trains+0.5],0.5*ones(1,2),'Color','k','LineWidth',2)
    end
    matr_one_plot=0;
    box on
    xl=xlim; yl=ylim;
    %line(xl,yl,'Color','k','LineStyle',':','LineWidth',1)
    box on
    
    mat_tick_cmenu = uicontextmenu;
    mat_tick_fh=zeros(1,2);
    mat_tick_fh(1)=line(xl,yl(1)*ones(1,2),'Color','w','LineWidth',0.5,'UIContextMenu',mat_tick_cmenu);
    mat_tick_fh(2)=line(xl(1)*ones(1,2),yl,'Color','w','LineWidth',0.5,'UIContextMenu',mat_tick_cmenu);
    fh_str='mat_tick';
    SPIKY_handle_set_property
end

if run==2
    
    if make_surro==1
        sto_profs=SPIKY_loop_results.SPIKE_order.spike_train_order_all_pairs;
        so_profs=SPIKY_loop_results.SPIKE_order.spike_order_all_pairs;
        
        coin_spikes=any(sto_profs,1);
        sto_profs=sto_profs(:,coin_spikes);
        so_profs=so_profs(:,coin_spikes);
        all_trains=all_trains(coin_spikes);
        
        ini=SPIKY_loop_results.SPIKE_order.overall;
        fin=sorted_SPIKY_loop_results.SPIKE_order.overall;
        
        ini_cum=sum(sum(triu(SPIKY_loop_results.SPIKE_order.matrix_cum)));
        fin_cum=sum(sum(triu(sorted_SPIKY_loop_results.SPIKE_order.matrix_cum)));
        
        %disp(['Ini: ',num2str(ini,3),'  Fin: ',num2str(fin,3)])
        surros_cum=SPIKY_Synfire_f_generate_surros(sto_profs,so_profs,all_trains,...
            num_surros,dataset,event_seps,fin);                                % ###################
        
        surros=surros_cum*2/(para.num_trains-1)/sum(num_spikes);
        %delta=(surros_cum-repmat(ini_cum,1,num_surros));
        
        [a,b]=sort([fin surros]);
        posi=num_surros+2-find(b==1);
        pval=posi/(num_surros+1);
        
        mean_surros=mean(surros);
        min_surros=min(surros);
        max_surros=max(surros);
        min_val=min([fin min_surros]);
        max_val=max([fin max_surros]);
        std_surros=std(surros);
        if std_surros>0
            z_score=(fin-mean_surros)/std_surros;
        else
            z_score=0;
        end
        if mod(plotting,128)>63
            if multi_figure==1
                figure(10*dc)
            else
                figure(555)
            end
            subplot(num_plots,3,plot_pos(subplotc)*3-3)
            cols='rk';
            [histo,cents]=hist(surros,0.0005:0.001:0.9995);
            bh=bar(cents,histo);
            set(bh,'FaceColor',cols(1),'EdgeColor',cols(1))
            if fin>0.5 || max_val>0.5
                xlim([0 1.05])
            else
                xlim([0 max([max_val fin])*1.05])
            end
            xl=xlim; yl=ylim;
            text(fin-0.075,yl(1)+0.85*(yl(2)-yl(1)),'F_s','Color',cols(2),'FontSize',fs-1,'FontWeight','bold')
            if show_z_scores==1
                line(mean_surros*ones(1,2),yl,'Color',cols(1),'LineWidth',3)
                line(mean_surros+[-std_surros std_surros],(yl(1)+0.65*(yl(2)-yl(1)))*ones(1,2),'Color',cols(1),'LineWidth',3)
                line((mean_surros-std_surros)*ones(1,2),yl(1)+[0.6 0.7]*(yl(2)-yl(1)),'Color',cols(1),'LineWidth',3)
                line((mean_surros+std_surros)*ones(1,2),yl(1)+[0.6 0.7]*(yl(2)-yl(1)),'Color',cols(1),'LineWidth',3)
                if pval<=0.05
                    synf_title_fh(5)=title(['z = ',num2str(z_score,3),'  ;  p = ',num2str(pval,2),'**'],...
                        'Visible',para.synf_title_vis,'Color',para.synf_title_col,'FontSize',para.synf_title_fs,...
                        'FontWeight',para.synf_title_fw,'FontAngle',para.synf_title_fa,'UIContextMenu',synf_title_cmenu);
                elseif pval<0.3
                    synf_title_fh(5)=title(['z = ',num2str(z_score,3),'  ;  p > 0.05'],...
                        'Visible',para.synf_title_vis,'Color',para.synf_title_col,'FontSize',para.synf_title_fs,...
                        'FontWeight',para.synf_title_fw,'FontAngle',para.synf_title_fa,'UIContextMenu',synf_title_cmenu);
                else
                    synf_title_fh(5)=title(['z = ',num2str(z_score,3),'  ;  p >> 0.05'],...
                        'Visible',para.synf_title_vis,'Color',para.synf_title_col,'FontSize',para.synf_title_fs,...
                        'FontWeight',para.synf_title_fw,'FontAngle',para.synf_title_fa,'UIContextMenu',synf_title_cmenu);
                end
            else
                if pval<=0.05
                    synf_title_fh(5)=title(['Significance:  p = ',num2str(pval,2),'**'],...
                        'Visible',para.synf_title_vis,'Color',para.synf_title_col,'FontSize',para.synf_title_fs,...
                        'FontWeight',para.synf_title_fw,'FontAngle',para.synf_title_fa,'UIContextMenu',synf_title_cmenu);
                elseif pval<0.3
                    synf_title_fh(5)=title('Significance:  p > 0.05',...
                        'Visible',para.synf_title_vis,'Color',para.synf_title_col,'FontSize',para.synf_title_fs,...
                        'FontWeight',para.synf_title_fw,'FontAngle',para.synf_title_fa,'UIContextMenu',synf_title_cmenu);
                else
                    synf_title_fh(5)=title('Significance:  p >> 0.05',...
                        'Visible',para.synf_title_vis,'Color',para.synf_title_col,'FontSize',para.synf_title_fs,...
                        'FontWeight',para.synf_title_fw,'FontAngle',para.synf_title_fa,'UIContextMenu',synf_title_cmenu);
                end
            end
            line(fin*ones(1,2),yl,'Color',cols(2),'LineStyle','--','LineWidth',3)
            synf_label_fh(2)=xlabel('F',...
                'Visible',para.synf_label_vis,'Color',para.synf_label_col,'FontSize',para.synf_label_fs,...
                'FontWeight',para.synf_label_fw,'FontAngle',para.synf_label_fa,'UIContextMenu',synf_label_cmenu);
            synf_label_fh(3)=ylabel('#',...
                'Visible',para.synf_label_vis,'Color',para.synf_label_col,'FontSize',para.synf_label_fs,...
                'FontWeight',para.synf_label_fw,'FontAngle',para.synf_label_fa,'UIContextMenu',synf_label_cmenu);
            axis square
            if any(mod(get(gca,'YTick'),1)>0)
                set(gca,'YTick',0:max(histo))
            end
            set(gca,'FontSize',fs-3)
            synf_sublabel_fh(6)=text(xl(1)-0.5*(xl(2)-xl(1)),yl(2)+0.05*(yl(2)-yl(1)),['(',alphabet(6),')'],...
                'Visible',para.synf_sublabel_vis,'Color',para.synf_sublabel_col,'FontSize',para.synf_sublabel_fs,...
                'FontWeight',para.synf_sublabel_fw,'FontAngle',para.synf_sublabel_fa,'UIContextMenu',synf_sublabel_cmenu);
        end
        SPIKY_Synfire_results.Significance.mean_surros=mean_surros;
        SPIKY_Synfire_results.Significance.std_surros=std_surros;
        SPIKY_Synfire_results.Significance.p_value=pval;
        SPIKY_Synfire_results.Significance.z_score=z_score;
        
        prof_tick_cmenu = uicontextmenu;
        prof_tick_fh=zeros(1,2);
        prof_tick_fh(1)=line(xl,yl(1)*ones(1,2),'Color',para.prof_tick_col,'UIContextMenu',prof_tick_cmenu);
        prof_tick_fh(2)=line(xl(1)*ones(1,2),yl,'Color','w','UIContextMenu',prof_tick_cmenu);
        fh_str='prof_tick';
        SPIKY_handle_set_property
    end
    
    if para.print_mode>0
        set(gcf,'PaperOrientation','Portrait'); set(gcf,'PaperType','A4');
        if num_plots==1
            set(gcf,'PaperUnits','Normalized','PaperPosition',[0 0.6 1.0 0.3]);
        elseif num_plots==2
            set(gcf,'PaperUnits','Normalized','PaperPosition',[0 0.45 1.0 0.45]);
        else
            set(gcf,'PaperUnits','Normalized','PaperPosition',[0 0.05 1.0 0.9]);
        end
        psname=['SPIKE_Order_',dataset_str,comment,'.ps'];
        print(gcf,'-dpsc',psname)
    end
    fh_str='synf_title';
    SPIKY_handle_font
    fh_str='synf_label';
    SPIKY_handle_font
    fh_str='synf_c_result';
    SPIKY_handle_font
    fh_str='synf_f_result';
    SPIKY_handle_font
    fh_str='synf_sublabel';
    SPIKY_handle_font
    fh_str='synf_cblabel';
    SPIKY_handle_font
    lh_str='synf_c_line';
    SPIKY_handle_line
    lh_str='synf_e_line';
    SPIKY_handle_line
    lh_str='synf_halfmat_line';
    SPIKY_handle_line
end

