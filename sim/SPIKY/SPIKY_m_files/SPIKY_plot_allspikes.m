% This plots the spikes once they are loaded (either via 'Select from list', 'Spike train generator' or the 'Load' buttons)

d_para.tmin=round(d_para.tmin/d_para.dts)*d_para.dts;
d_para.tmax=round(d_para.tmax/d_para.dts)*d_para.dts;
s_para.itmin=d_para.tmin;
s_para.itmax=d_para.tmax;
s_para.itrange=s_para.itmax-s_para.itmin;

fig=figure(f_para.num_fig);
set(gcf,'Name',[d_para.comment_string])
clf;
set(gca,'Position',f_para.supo1)
plot(-1000,-1000);
hold on
xlim([s_para.itmin-0.02*s_para.itrange s_para.itmax+0.02*s_para.itrange])
ylim([0 1.1])
xl=xlim; yl=ylim;
%set(gca,'XTickMode','auto','XTickLabelMode','auto')
box on

d_para.num_trains=length(d_para.preselect_trains);
d_para.num_pairs=(d_para.num_trains*d_para.num_trains-d_para.num_trains)/2;

d_para.num_allspikes=zeros(1,d_para.num_trains);
spike_cmenu = uicontextmenu;
spike_lh=cell(1,d_para.num_trains);
for trac=1:d_para.num_trains
    pspikes{trac}=round(sort(allspikes{d_para.preselect_trains(trac)})/d_para.dts)*d_para.dts;
    d_para.num_allspikes(trac)=length(pspikes{trac});
    if d_para.num_total_spikes<d_para.max_total_spikes
        for sc=1:d_para.num_allspikes(trac)
            spike_lh{trac}(sc)=line(pspikes{trac}(sc)*ones(1,2),0.05+(d_para.num_trains-1-(trac-1)+[0.05 0.95])/d_para.num_trains,...
                'Color',p_para.spike_col,'LineStyle',p_para.spike_ls,'LineWidth',p_para.spike_lw,'UIContextMenu',spike_cmenu);
        end
    end
end
allspikes=pspikes;
d_para.max_num_allspikes=max(d_para.num_allspikes);
image_lh=zeros(1);
if d_para.num_total_spikes>=d_para.max_total_spikes
    image_cmenu = uicontextmenu;
    spike_density=zeros(d_para.num_trains,f_para.psth_num_bins);
    for trac=1:d_para.num_trains
        [histo_y,histo_x]=hist([pspikes{trac}],f_para.psth_num_bins);
        spike_density(trac,1:f_para.psth_num_bins)=histo_y;
    end
    xl=xlim; yl=ylim;
    image_lh=imagesc(spike_density,'XData',[s_para.itmin+s_para.itrange/(2*f_para.psth_num_bins) s_para.itmax-s_para.itrange/(2*f_para.psth_num_bins)],...
        'YData',[0.05+1/(2*d_para.num_trains) 1.05-1/(2*d_para.num_trains)],'UIContextMenu',image_cmenu);
    if d_para.num_trains<30 && f_para.psth_num_bins<30
        for trac=1:d_para.num_trains-1
            line([s_para.itmin s_para.itmax],(0.05+trac/d_para.num_trains)*ones(1,2),'Color','k','LineStyle',':')
        end
        for bc=1:f_para.psth_num_bins-1
            line(s_para.itmin+bc*s_para.itrange/f_para.psth_num_bins*ones(1,2),[0.05 1.05],'Color','k','LineStyle',':')
        end
    end
    lh_str='image';
    SPIKY_handle_line 
end
setappdata(handles.figure1,'image_mh',image_lh)

%d_para.spike_number=d_para.num_allspikes;
%d_para.first=zeros(1,length(allspikes));
%ok=cellfun('length',allspikes)>0;
%d_para.first(logical(ok))=cell2mat(cellfun(@(x) x(1),allspikes(ok),'UniformOutput',false));
%d_para.first(setdiff(1:length(allspikes),find(ok)))=inf;
%d_para.latency=cell2mat(cellfun(@(x) x(1),allspikes,'UniformOutput',false));

set(gca,'UserData',pspikes)
lh_str='spike';
SPIKY_handle_line
setappdata(handles.figure1,'spike_lh',spike_lh)

sp_bounds_cmenu = uicontextmenu;
sp_bounds_lh=zeros(1,2);
sp_bounds_lh(1)=line(xl,0.05*ones(1,2),...
    'Color',p_para.sp_bounds_col,'LineStyle',p_para.sp_bounds_ls,'LineWidth',p_para.sp_bounds_lw,'UIContextMenu',sp_bounds_cmenu);
sp_bounds_lh(2)=line(xl,1.05*ones(1,2),...
    'Color',p_para.sp_bounds_col,'LineStyle',p_para.sp_bounds_ls,'LineWidth',p_para.sp_bounds_lw,'UIContextMenu',sp_bounds_cmenu);
lh_str='sp_bounds';
SPIKY_handle_line

tbounds_cmenu = uicontextmenu;
tbounds_lh=zeros(1,2);
tbounds_lh(1)=line(d_para.tmin*ones(1,2),yl,...
    'Color',p_para.tbounds_col,'LineStyle',p_para.tbounds_ls,'LineWidth',p_para.tbounds_lw,'UIContextMenu',tbounds_cmenu);
tbounds_lh(2)=line(d_para.tmax*ones(1,2),yl,...
    'Color',p_para.tbounds_col,'LineStyle',p_para.tbounds_ls,'LineWidth',p_para.tbounds_lw,'UIContextMenu',tbounds_cmenu);
lh_str='tbounds';
SPIKY_handle_line

xlab_cmenu = uicontextmenu;
xlab_fh=xlabel(['Time ',f_para.time_unit_string],...
    'Color',p_para.xlab_col,'FontSize',p_para.xlab_fs,'FontWeight',p_para.xlab_fw,'FontAngle',p_para.xlab_fa,'UIContextMenu',xlab_cmenu);
fh_str='xlab';
SPIKY_handle_font

set(gca,'FontSize',p_para.prof_tick_fs)

%text(xl(1)-0.042*(xl(2)-xl(1)),yl(1)+0.4*(yl(2)-yl(1)),'Spike trains','FontSize',s_para.font_size,'Rotation',90)
group_names_cmenu = uicontextmenu;
group_names_fh=zeros(1,2);
group_names_fh(1)=text(xl(1)-0.1*(xl(2)-xl(1)),yl(1)+0.7*(yl(2)-yl(1)),'Spike',...
    'Color',p_para.group_names_col,'FontSize',p_para.group_names_fs,'FontWeight',p_para.group_names_fw,'FontAngle',p_para.group_names_fa,'UIContextMenu',group_names_cmenu);
group_names_fh(2)=text(xl(1)-0.1*(xl(2)-xl(1)),yl(1)+0.35*(yl(2)-yl(1)),'trains',...
    'Color',p_para.group_names_col,'FontSize',p_para.group_names_fs,'FontWeight',p_para.group_names_fw,'FontAngle',p_para.group_names_fa,'UIContextMenu',group_names_cmenu);
fh_str='group_names';
SPIKY_handle_font
    
if mod(d_para.num_trains,2)==0
    set(gca,'YTick',0.05+[0 0.5],'YTickLabel',[d_para.num_trains d_para.num_trains/2])
else
    set(gca,'YTick',0.05+[0 1-(d_para.num_trains-1)/2/d_para.num_trains],'YTickLabel',[d_para.num_trains (d_para.num_trains-1)/2])
end

set(gca,'XColor',p_para.prof_tick_col,'YColor',p_para.prof_tick_col,'FontSize',p_para.prof_tick_fs,'FontWeight',p_para.prof_tick_fw,'FontAngle',p_para.prof_tick_fa)

prof_tick_cmenu = uicontextmenu;
prof_tick_fh=zeros(1,2);
prof_tick_fh(1)=line(xl,yl(1)*ones(1,2),'Color',p_para.prof_tick_col,'UIContextMenu',prof_tick_cmenu);
prof_tick_fh(2)=line(xl(1)*ones(1,2),yl,'Color',p_para.prof_tick_col,'UIContextMenu',prof_tick_cmenu);
fh_str='prof_tick';
SPIKY_handle_set_property

box on

