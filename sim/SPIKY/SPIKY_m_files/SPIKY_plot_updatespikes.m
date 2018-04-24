% This plots the spikes once the 'Parameters: Data' have been updated (after the 'Update' button has been pressed).

if isfield(d_para,'all_train_group_names') && isfield(d_para,'all_train_group_sizes') && ~isempty(d_para.all_train_group_sizes) && length(d_para.all_train_group_names)==length(d_para.all_train_group_sizes)
    d_para.num_all_train_groups=length(d_para.all_train_group_names);
    cum_group=[0 cumsum(d_para.all_train_group_sizes)];
    d_para.group_vect=zeros(1,d_para.num_all_trains);
    for gc=1:d_para.num_all_train_groups
        d_para.group_vect(cum_group(gc)+(1:d_para.all_train_group_sizes(gc)))=gc;
    end
else
    d_para.group_vect=ones(1,d_para.num_all_trains);
    d_para.num_all_train_groups=1;
end


if d_para.select_train_mode==1                                       % All
    d_para.select_trains=1:d_para.num_all_trains;
elseif d_para.select_train_mode==2                                   % Selected trains
    d_para.select_trains=d_para.preselect_trains;
elseif d_para.select_train_mode==3                                   % Selected groups
    d_para.select_trains = [];
    for gc=d_para.select_train_groups
        d_para.select_trains=[d_para.select_trains find(d_para.group_vect==gc)];
    end
end
d_para.select_trains=d_para.select_trains(mod(d_para.select_trains,1)==0);
d_para.select_trains=d_para.select_trains(d_para.select_trains>=1 & d_para.select_trains<=d_para.num_all_trains);

d_para.thin_separators2=d_para.thin_separators;
d_para.thick_separators2=d_para.thick_separators;
for tsc=1:length(d_para.thin_separators2)
    d_para.thin_separators2(tsc)=length(find(d_para.select_trains<=d_para.thin_separators2(tsc)));
end
d_para.thin_separators2=unique(d_para.thin_separators2(d_para.thin_separators2>0 & d_para.thin_separators2<length(d_para.select_trains)));
for tsc=1:length(d_para.thick_separators2)
    d_para.thick_separators2(tsc)=length(find(d_para.select_trains<=d_para.thick_separators2(tsc)));
end
d_para.thick_separators2=unique(d_para.thick_separators2(d_para.thick_separators2>0 & d_para.thick_separators2<length(d_para.select_trains)));


d_para.select_group_vect=d_para.group_vect(d_para.select_trains);
d_para.select_train_groups=SPIKY_unique_not_sorted(d_para.select_group_vect);
d_para.num_select_train_groups=length(d_para.select_train_groups);
d_para.num_select_group_trains=zeros(1,d_para.num_select_train_groups);
for scc=1:d_para.num_select_train_groups
    d_para.num_select_group_trains(scc)=length(find(d_para.select_group_vect==d_para.select_train_groups(scc)));
end
d_para.cum_num_select_group_trains=cumsum(d_para.num_select_group_trains);
d_para.select_group_center=[0 d_para.cum_num_select_group_trains(1:d_para.num_select_train_groups-1)]+diff([0 d_para.cum_num_select_group_trains(1:d_para.num_select_train_groups)])/2;

if isfield(d_para,'all_train_group_names') && isfield(d_para,'all_train_group_sizes') && ~isempty(d_para.all_train_group_sizes) && length(d_para.all_train_group_names)==length(d_para.all_train_group_sizes)
    d_para.select_group_names=d_para.all_train_group_names(d_para.select_train_groups);
    f_para.all_train_group_names=d_para.all_train_group_names(d_para.select_train_groups);
    f_para.all_train_group_sizes=d_para.num_select_group_trains;
    f_para.num_all_train_groups=length(f_para.all_train_group_names);
else
    d_para.select_group_names='';
    d_para.num_select_train_groups=1;
    f_para.num_all_train_groups=1;
end
spikes=allspikes(d_para.select_trains);
d_para.num_trains=length(spikes);
ret=0;
if d_para.num_trains<2
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('At least two spike trains are needed in\norder to quantify spike train synchrony!'),'Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    ret=1;
    return
end
f_para.num_all_trains=d_para.num_trains;


d_para.num_pairs=(d_para.num_trains*d_para.num_trains-d_para.num_trains)/2;
d_para.tmin=round(d_para.tmin/d_para.dts)*d_para.dts;
d_para.tmax=round(d_para.tmax/d_para.dts)*d_para.dts;

d_para.num_spikes_ori=zeros(1,d_para.num_trains);
d_para.num_spikes=zeros(1,d_para.num_trains);
%spikes=cell(size(spikes));                             % original spikes used for plotting (in units of d_para.dts)
for trac=1:d_para.num_trains
    dummy1=spikes{trac};
    if any(dummy1)
        dummy2=dummy1(dummy1>=d_para.tmin & dummy1<=d_para.tmax);
        d_para.num_spikes_ori(trac)=length(dummy2);
        spikes{trac}=unique(round(dummy2/d_para.dts)*d_para.dts);   % sometimes spikes with integer values get rounded to integer, sometimes not ?
        d_para.num_spikes(trac)=length(spikes{trac});
    end
end

fig=figure(f_para.num_fig);
set(gcf,'Name',[d_para.comment_string])
clf;
f_para_default=getappdata(handles.figure1,'figure_parameters_default');
f_para.supo1=f_para_default.supo1;
set(gca,'Position',f_para.supo1)
plot(-1000,-1000);

hold on
s_para.itmin=d_para.tmin;
s_para.itmax=d_para.tmax;
s_para.itrange=s_para.itmax-s_para.itmin;
if s_para.window_mode==1                                                               % all (recording limits)
    s_para.wmin=s_para.itmin; s_para.wmax=s_para.itmax;
else
    if s_para.window_mode==2                                                           % outer spikes (overall)
        s_para.wmin=min(min(min(spikes(spikes~=0))));
        s_para.wmax=max(max(max(spikes(spikes~=0))));
    elseif s_para.window_mode==3                                                       % inner spikes (overall)
        s_para.wmin=max(spikes(1:d_para.num_trains,1));
        s_para.wmax=inf;
        for trac=1:num_trains
            if num_spikes(trac)>0
                if spikes(trac,d_para.num_spikes(trac))<s_para.itmax
                    s_para.wmax=spikes(trac,d_para.num_spikes(trac));
                end
            end
        end
    elseif s_para.window_mode==4 && isempty(s_para.wmin) && isempty(s_para.wmax)       % select
        s_para.wmin=d_para.tmin+0.25*(d_para.tmax-d_para.tmin);
        s_para.wmax=d_para.tmax-0.25*(d_para.tmax-d_para.tmin);
    end
    s_para.wmin=round(s_para.wmin/d_para.dts)*d_para.dts;
    s_para.wmax=round(s_para.wmax/d_para.dts)*d_para.dts;
    xlim([s_para.itmin-0.02*s_para.itrange s_para.itmax+0.02*s_para.itrange])
end
if s_para.window_mode==2
    s_para.wmin=max([s_para.itmin s_para.wmin]);
    s_para.wmax=min([s_para.itmax s_para.wmax]);
end

xlim([s_para.itmin-0.02*s_para.itrange s_para.itmax+0.02*s_para.itrange])
ylim([0 1.1])
xl=xlim; yl=ylim;
%set(gca,'XTickMode','auto','XTickLabelMode','auto')


box on

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

set(gca,'XColor',p_para.prof_tick_col,'YColor',p_para.prof_tick_col,'FontSize',p_para.prof_tick_fs,'FontWeight',p_para.prof_tick_fw,'FontAngle',p_para.prof_tick_fa)

prof_tick_cmenu = uicontextmenu;
prof_tick_fh=zeros(1,2);
prof_tick_fh(1)=line(xl,yl(1)*ones(1,2),'Color',p_para.prof_tick_col,'UIContextMenu',prof_tick_cmenu);
prof_tick_fh(2)=line(xl(1)*ones(1,2),yl,'Color',p_para.prof_tick_col,'UIContextMenu',prof_tick_cmenu);
fh_str='prof_tick';
SPIKY_handle_set_property

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

if d_para.num_select_train_groups>1
    sgs_cmenu = uicontextmenu;
    sgs_lh=zeros(1,d_para.num_select_train_groups-1);
    group_names_cmenu = uicontextmenu;
    group_names_fh=zeros(1,d_para.num_select_train_groups);
    for sgc=1:d_para.num_select_train_groups
        if sgc<d_para.num_select_train_groups
            sgs_lh(sgc)=line([s_para.itmin s_para.itmax],(1.05-d_para.cum_num_select_group_trains(sgc)/d_para.num_trains)*ones(1,2),...
                'Color',p_para.sgs_col,'LineStyle',p_para.sgs_ls,'LineWidth',p_para.sgs_lw,'UIContextMenu',sgs_cmenu);
        end
        group_names_fh(sgc)=text(xl(1)-0.06*(xl(2)-xl(1)),1.05-d_para.select_group_center(sgc)/d_para.num_trains,d_para.select_group_names{sgc},...
            'Color',p_para.group_names_col,'FontSize',p_para.group_names_fs,'FontWeight',p_para.group_names_fw,'FontAngle',p_para.group_names_fa,'UIContextMenu',group_names_cmenu);
        set(gca,'YTick',fliplr(1.05-d_para.cum_num_select_group_trains/d_para.num_trains),'YTickLabel',fliplr(d_para.cum_num_select_group_trains))
    end
    lh_str='sgs';
    SPIKY_handle_line
    setappdata(handles.figure1,'sgs_lh',sgs_lh)
    fh_str='group_names';
    SPIKY_handle_font
    set(gca,'YTick',fliplr(1.05-d_para.cum_num_select_group_trains/d_para.num_trains),'YTickLabel',fliplr(d_para.cum_num_select_group_trains))
    setappdata(handles.figure1,'sgs_lh',sgs_lh)
else
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
end

if isfield(d_para,'thick_separators') && ~isempty(d_para.thick_separators2)
    thick_sep_cmenu = uicontextmenu;
    thick_sep_lh=zeros(1,length(d_para.thick_separators2));
    for sec=1:length(d_para.thick_separators)
        thick_sep_lh(sec)=line([s_para.itmin s_para.itmax],(1.05-d_para.thick_separators2(sec)/d_para.num_trains)*ones(1,2),...
            'Color',p_para.thick_sep_col,'LineStyle',p_para.thick_sep_ls,'LineWidth',p_para.thick_sep_lw,'UIContextMenu',thick_sep_cmenu);
    end
    lh_str='thick_sep';
    SPIKY_handle_line
    setappdata(handles.figure1,'thick_sep_lh',thick_sep_lh)
end

if isfield(d_para,'thin_separators') && ~isempty(d_para.thin_separators2)
    thin_sep_cmenu = uicontextmenu;
    thin_sep_lh=zeros(1,length(d_para.thin_separators2));
    for sec=1:length(d_para.thin_separators2)
        thin_sep_lh(sec)=line([s_para.itmin s_para.itmax],(1.05-d_para.thin_separators2(sec)/d_para.num_trains)*ones(1,2),...
            'Color',p_para.thin_sep_col,'LineStyle',p_para.thin_sep_ls,'LineWidth',p_para.thin_sep_lw,'UIContextMenu',thin_sep_cmenu);
    end
    lh_str='thin_sep';
    SPIKY_handle_line
    setappdata(handles.figure1,'thin_sep_lh',thin_sep_lh)
end

if isfield(d_para,'thick_markers') && ~isempty(d_para.thick_markers)
    thick_mar_cmenu = uicontextmenu;
    thick_mar_lh=zeros(1,length(d_para.thick_markers));
    for mac=1:length(d_para.thick_markers)
        thick_mar_lh(mac)=line(d_para.thick_markers(mac)*ones(1,2),[0.05 1.05],...
            'Color',p_para.thick_mar_col,'LineStyle',p_para.thick_mar_ls,'LineWidth',p_para.thick_mar_lw,'UIContextMenu',thick_mar_cmenu);
    end
    lh_str='thick_mar';
    SPIKY_handle_line
    setappdata(handles.figure1,'thick_mar_lh',thick_mar_lh)
end

if isfield(d_para,'thin_markers') && ~isempty(d_para.thin_markers)
    thin_mar_cmenu = uicontextmenu;
    thin_mar_lh=zeros(1,length(d_para.thin_markers));
    for mac=1:length(d_para.thin_markers)
        thin_mar_lh(mac)=line(d_para.thin_markers(mac)*ones(1,2),[0.05 1.05],...
            'Color',p_para.thin_mar_col,'LineStyle',p_para.thin_mar_ls,'LineWidth',p_para.thin_mar_lw,'UIContextMenu',thin_mar_cmenu);
    end
    lh_str='thin_mar';
    SPIKY_handle_line
    setappdata(handles.figure1,'thin_mar_lh',thin_mar_lh)
end

if (f_para.dendrograms==1 && f_para.spike_train_color_coding_mode>1) || (d_para.num_select_train_groups>1 && f_para.spike_train_color_coding_mode==2)
    cm=colormap;
    if f_para.spike_train_color_coding_mode==2 && d_para.num_select_train_groups>1
        dcol_indy=round(1:63/(d_para.num_all_train_groups-1):64);
        dcols=cm(dcol_indy(d_para.select_group_vect),:);
    else
        dcol_indy=round(1:63/(d_para.num_trains-1):64);
        dcols=cm(dcol_indy,:);
    end
    d_para.dcols=cm(dcol_indy,:);
    if mod(f_para.spike_col,4)>1
        colpat_cmenu = uicontextmenu;
        colpat_ph=zeros(d_para.num_trains,2);
        for trac=1:d_para.num_trains
            colpat_ph(trac,1)=patch([d_para.tmin d_para.tmin-0.01*(d_para.tmax-d_para.tmin)*ones(1,2) d_para.tmin],1.05-(trac-1+[0 0 1 1])/...
                d_para.num_trains,dcols(trac,:),'EdgeColor',dcols(trac,:),'Visible',p_para.colpat_vis,'UIContextMenu',colpat_cmenu);
            colpat_ph(trac,2)=patch([d_para.tmax d_para.tmax+0.01*(d_para.tmax-d_para.tmin)*ones(1,2) d_para.tmax],1.05-(trac-1+[0 0 1 1])/...
                d_para.num_trains,dcols(trac,:),'EdgeColor',dcols(trac,:),'Visible',p_para.colpat_vis,'UIContextMenu',colpat_cmenu);
        end
        ph_str='colpat';
        SPIKY_handle_patch
    end
else
    d_para.dcols=[0 0 0];
    dcols=[];
end

spike_cmenu = uicontextmenu;
spike_lh=cell(1,d_para.num_trains);
image_lh=zeros(1);
if d_para.num_total_spikes<d_para.max_total_spikes
    if f_para.spike_train_color_coding_mode>1 && mod(f_para.spike_col,2)>0
        for trac=1:d_para.num_trains
            for sc=1:d_para.num_spikes(trac)
                spike_lh{trac}(sc)=line(spikes{trac}(sc)*ones(1,2),0.05+(d_para.num_trains-1-(trac-1)+[0.05 0.95])/d_para.num_trains,...
                    'Color',dcols(trac,:),'LineStyle',p_para.spike_ls,'LineWidth',p_para.spike_lw,'UIContextMenu',spike_cmenu);
            end
        end
    else
        for trac=1:d_para.num_trains
            for sc=1:d_para.num_spikes(trac)
                spike_lh{trac}(sc)=line(spikes{trac}(sc)*ones(1,2),0.05+(d_para.num_trains-1-(trac-1)+[0.05 0.95])/d_para.num_trains,...
                    'Color',p_para.spike_col,'LineStyle',p_para.spike_ls,'LineWidth',p_para.spike_lw,'UIContextMenu',spike_cmenu);
            end
        end
    end
else
    image_cmenu = uicontextmenu;
    spike_density=zeros(d_para.num_trains,f_para.psth_num_bins);
    for trac=1:d_para.num_trains
        [histo_y,histo_x]=hist([spikes{trac}],f_para.psth_num_bins);
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

if f_para.spike_train_color_coding_mode>1
    set(gca,'Tag',num2str(reshape(dcols,1,size(dcols,1)*3)))
else
    set(gca,'Tag','')
end
set(gca,'UserData',spikes)
lh_str='spike';
SPIKY_handle_line
setappdata(handles.figure1,'spike_lh',spike_lh)


if f_para.histogram
    xticks=get(gca,'XTick');
    xlim([s_para.itmin-0.02*s_para.itrange s_para.itmax+0.24*s_para.itrange])
    set(gca,'XTick',xticks)
    hh=bar(d_para.num_spikes);
    set(hh,'XData',0.05+(d_para.num_trains-1-((1:d_para.num_trains)-1)+0.5)/d_para.num_trains)
    set(hh,'BaseValue',s_para.itmin+1.02*s_para.itrange)
    set(hh,'YData',s_para.itmin+1.02*s_para.itrange+d_para.num_spikes/max(d_para.num_spikes)*0.2*s_para.itrange)
    %set(hh,'BaseLine',0.2*s_para.itrange)

    set(hh,'horizontal','on')
    %xlabel('# Spikes','Color','k','FontSize',12,'FontWeight','bold')
    line((s_para.itmin+1.22*s_para.itrange)*ones(1,2),0.05+(d_para.num_trains-1-(([0 d_para.num_trains])-1))/d_para.num_trains,'LineStyle',':','Color','k')
    hist_max_cmenu = uicontextmenu;
    hist_max_fh=text((s_para.itmin+1.18*s_para.itrange),0.025,num2str(max(d_para.num_spikes)),'Color',p_para.hist_max_col,'FontSize',p_para.hist_max_fs,...
        'FontWeight',p_para.hist_max_fw,'FontAngle',p_para.hist_max_fa,'UIContextMenu',hist_max_cmenu);
    fh_str='hist_max';
    SPIKY_handle_font
end


