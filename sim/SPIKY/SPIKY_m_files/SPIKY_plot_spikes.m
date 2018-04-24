    % This plots the spikes once all the measures have been calculated (after the 'Calculate' button has been pressed).

disp(' '); disp(' '); disp(' ');

if isfield(f_para,'all_train_group_names') && isfield(f_para,'all_train_group_sizes') && ~isempty(f_para.all_train_group_sizes) && length(f_para.all_train_group_names)==length(f_para.all_train_group_sizes)
    cum_group=[0 cumsum(f_para.all_train_group_sizes)];
    f_para.group_vect=zeros(1,f_para.num_all_trains);
    for gc=1:f_para.num_all_train_groups
        f_para.group_vect(cum_group(gc)+(1:f_para.all_train_group_sizes(gc)))=gc;
    end
else
    f_para.group_vect=ones(1,f_para.num_all_trains);
end

if f_para.select_train_mode==1                                       % All
    f_para.select_trains=1:f_para.num_all_trains;
    f_para.select_train_groups=1:f_para.num_all_train_groups;
    f_para.num_select_train_groups=f_para.num_all_train_groups;
elseif f_para.select_train_mode==2                                   % Selected trains
    f_para.select_train_groups=SPIKY_f_unique_not_sorted(f_para.group_vect(f_para.select_trains));
    f_para.num_select_train_groups=length(f_para.select_train_groups);
elseif f_para.select_train_mode==3                                   % Selected groups
    f_para.num_select_train_groups=length(f_para.select_train_groups);
    f_para.select_trains = [];
    for gc=1:f_para.num_select_train_groups
        f_para.select_trains=[f_para.select_trains find(f_para.group_vect==f_para.select_train_groups(gc))];
    end
end

f_para.select_group_vect=f_para.group_vect(f_para.select_trains);
f_para.num_select_group_trains=zeros(1,f_para.num_select_train_groups);
for scc=1:f_para.num_select_train_groups
    f_para.num_select_group_trains(scc)=length(find(f_para.select_group_vect==f_para.select_train_groups(scc)));
end
f_para.cum_num_select_group_trains=cumsum(f_para.num_select_group_trains);
f_para.select_group_center=[0 f_para.cum_num_select_group_trains(1:f_para.num_select_train_groups-1)]+diff([0 f_para.cum_num_select_group_trains(1:f_para.num_select_train_groups)])/2;

if isfield(f_para,'all_train_group_names') && isfield(f_para,'all_train_group_sizes') && ~isempty(f_para.all_train_group_sizes) && length(f_para.all_train_group_names)==length(f_para.all_train_group_sizes)
    f_para.select_group_names=f_para.all_train_group_names(f_para.select_train_groups);
else
    f_para.select_group_names='';
    f_para.num_select_train_groups=1;
end
f_para.num_trains=length(f_para.select_trains);


f_para.num_pairs=(f_para.num_trains*f_para.num_trains-f_para.num_trains)/2;
f_para.tmin=round(f_para.tmin/d_para.dts)*d_para.dts;
f_para.tmax=round(f_para.tmax/d_para.dts)*d_para.dts;
s_para.itmin=f_para.tmin;
s_para.itmax=f_para.tmax;
s_para.itrange=s_para.itmax-s_para.itmin;

f_para.num_pspikes=zeros(1,f_para.num_trains);
pspikes=cell(1,f_para.num_trains);                            % original spikes used for plotting (in units of d_para.dts)
for trac=1:f_para.num_trains
    dummy1=spikes{f_para.select_trains(trac)};
    if any(dummy1)
        pspikes{trac}=dummy1(dummy1>=f_para.tmin & dummy1<=f_para.tmax);
        pspikes{trac}=round(sort(pspikes{trac})/d_para.dts)*d_para.dts;
        f_para.num_pspikes(trac)=length(pspikes{trac});
    end
end
f_para.max_num_pspikes=max(f_para.num_pspikes);


if ~any(f_para.subplot_posi==1)
    f_para.subplot_posi=(f_para.subplot_posi-min(f_para.subplot_posi(f_para.subplot_posi>0))+1).*(f_para.subplot_posi>0);
end
s_para.num_subplots=max(f_para.subplot_posi);


subplot_numbers=zeros(1,s_para.num_subplots);
f_para.sing_subplots=zeros(1,s_para.num_subplots);
for suc=1:s_para.num_subplots
    f_para.sing_subplots(suc)=find(f_para.subplot_posi==suc,1,'first');                               % new subplot
    subplot_numbers(suc)=length(find(f_para.subplot_posi==suc));
end
doubles=intersect(setxor(1:length(f_para.subplot_posi),f_para.sing_subplots),find(f_para.subplot_posi>0));     % repeated subplot
doublesref=f_para.sing_subplots(f_para.subplot_posi(doubles));                                                 % corresponding new subplot

relsubplot_size=f_para.rel_subplot_size(1:find(f_para.rel_subplot_size>0,1,'last'));
if length(relsubplot_size)~=max(f_para.subplot_posi)
    relsubplot_size=ones(1,max(f_para.subplot_posi));
end

regplotsize=s_para.num_subplots*1.1;
normsubplot_size=relsubplot_size/sum(relsubplot_size);
dumsubplot_size=normsubplot_size*regplotsize;
f_para.subplot_start2=cumsum(dumsubplot_size);
subplot_size2=diff([0 f_para.subplot_start2]);

f_para.subplot_size=zeros(1,m_para.num_all_measures);                % normalized size of subplots
f_para.subplot_size(f_para.sing_subplots)=subplot_size2;
f_para.subplot_size(doubles)=f_para.subplot_size(doublesref);

f_para.subplot_start=zeros(1,m_para.num_all_measures);               % normalized position of subplots
f_para.subplot_start(f_para.sing_subplots)=f_para.subplot_start2;
f_para.subplot_start(doubles)=f_para.subplot_start(doublesref);

if f_para.subplot_size(2)>0
    f_para.subplot_start(f_para.subplot_start>0 & f_para.subplot_posi>=f_para.subplot_posi(2))=f_para.subplot_start(f_para.subplot_start>0 & f_para.subplot_posi>=f_para.subplot_posi(2))+0.2;
    f_para.subplot_size(2)=f_para.subplot_size(2)+0.2;
end

subplot_index=zeros(1,m_para.num_all_measures);
subplot_index(logical(f_para.subplot_posi))=1;
for spc=2:m_para.num_all_measures
    if f_para.subplot_posi(spc)>0
        subplot_index(spc)=length(find(f_para.subplot_posi(1:spc-1)==f_para.subplot_posi(spc)))+1;
    end
end

subplot_paras=[f_para.subplot_posi',f_para.subplot_size',f_para.subplot_start',subplot_index'];



fig=figure(f_para.num_fig);
clf;
set(gcf,'Name',[f_para.comment_string])
if (get(handles.plots_frame_comparison_checkbox,'Value')==0 && get(handles.plots_frame_sequence_checkbox,'Value')==0) || ...
        ~isfield(f_para,'supo1')
    f_para_default=getappdata(handles.figure1,'figure_parameters_default');
    f_para.supo1=f_para_default.supo1;
end
profs_cmenu = uicontextmenu;
profs_sph=subplot('Position',f_para.supo1,'UIContextMenu',profs_cmenu);
sph_str='profs';
SPIKY_handle_subplot

hold on
xlim([s_para.itmin-0.02*s_para.itrange s_para.itmax+0.02*s_para.itrange])
ylim(sum(f_para.subplot_size(f_para.subplot_posi>f_para.subplot_posi(2) & subplot_index==1))+[0 1.3]/1.3*f_para.subplot_size(2))
xl=xlim; yl=ylim;

box on

tbounds_cmenu = uicontextmenu;
tbounds_lh=zeros(1,2);
tbounds_lh(1)=line(f_para.tmin*ones(1,2),yl,...
    'Color',p_para.tbounds_col,'LineStyle',p_para.tbounds_ls,'LineWidth',p_para.tbounds_lw,'UIContextMenu',tbounds_cmenu);
tbounds_lh(2)=line(f_para.tmax*ones(1,2),yl,...
    'Color',p_para.tbounds_col,'LineStyle',p_para.tbounds_ls,'LineWidth',p_para.tbounds_lw,'UIContextMenu',tbounds_cmenu);
lh_str='tbounds';
SPIKY_handle_line

sp_bounds_cmenu = uicontextmenu;
sp_bounds_lh=zeros(1,2);
sp_bounds_lh(1)=line(xl,(sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+0.15/1.3*f_para.subplot_size(2))*ones(1,2),...
    'Color',p_para.sp_bounds_col,'LineStyle',p_para.sp_bounds_ls,'LineWidth',p_para.sp_bounds_lw,'UIContextMenu',sp_bounds_cmenu);
sp_bounds_lh(2)=line(xl,(sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+1.15/1.3*f_para.subplot_size(2))*ones(1,2),...
    'Color',p_para.sp_bounds_col,'LineStyle',p_para.sp_bounds_ls,'LineWidth',p_para.sp_bounds_lw,'UIContextMenu',sp_bounds_cmenu);
lh_str='sp_bounds';
SPIKY_handle_line

if f_para.show_title
    title_cmenu = uicontextmenu;
    title_fh=title(f_para.title_string,'Color',p_para.title_col,'FontSize',p_para.title_fs,'FontWeight',p_para.title_fw,...
        'FontAngle',p_para.title_fa,'UIContextMenu',title_cmenu);
    fh_str='title';
    SPIKY_handle_font
end

xlab_cmenu = uicontextmenu;
xlab_fh=xlabel(['Time ',f_para.time_unit_string],...
    'Color',p_para.xlab_col,'FontSize',p_para.xlab_fs,'FontWeight',p_para.xlab_fw,'FontAngle',p_para.xlab_fa,'UIContextMenu',xlab_cmenu);
fh_str='xlab';
SPIKY_handle_font

if f_para.num_select_train_groups>1 && length(find(diff(f_para.select_group_vect)))==f_para.num_select_train_groups-1
    sgs_cmenu = uicontextmenu;
    sgs_lh=zeros(1,f_para.num_select_train_groups-1);
    group_names_cmenu = uicontextmenu;
    %group_names_fh=zeros(1,f_para.num_select_train_groups);
    group_names_fh=zeros(f_para.num_select_train_groups,1);
    for sgc=1:f_para.num_select_train_groups
        if sgc<f_para.num_select_train_groups
            sgs_lh(sgc)=line([s_para.itmin s_para.itmax],(sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(1.15-f_para.cum_num_select_group_trains(sgc)/f_para.num_trains)/1.3*f_para.subplot_size(2))*ones(1,2),...
                'Color',p_para.sgs_col,'LineStyle',p_para.sgs_ls,'LineWidth',p_para.sgs_lw,'UIContextMenu',sgs_cmenu);
        end
        group_names_fh(sgc)=text(xl(1)-0.06*(xl(2)-xl(1)),sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(1.15-f_para.select_group_center(sgc)/f_para.num_trains)/1.3*f_para.subplot_size(2),f_para.select_group_names{sgc},...
            'Color',p_para.group_names_col,'FontSize',p_para.group_names_fs,'FontWeight',p_para.group_names_fw,'FontAngle',p_para.group_names_fa,'UIContextMenu',group_names_cmenu);
    end
    lh_str='sgs';
    SPIKY_handle_line
    fh_str='group_names';
    SPIKY_handle_font
    set(gca,'YTick',fliplr(sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(1.15-f_para.cum_num_select_group_trains/f_para.num_trains)/1.3*f_para.subplot_size(2)),'YTickLabel',fliplr(f_para.cum_num_select_group_trains))
else
    group_names_cmenu = uicontextmenu;
    group_names_fh=zeros(1,2);
    group_names_fh(1)=text(xl(1)-0.1*(xl(2)-xl(1)),yl(1)+0.7*(yl(2)-yl(1)),'Spike',...
        'Color',p_para.group_names_col,'FontSize',p_para.group_names_fs,'FontWeight',p_para.group_names_fw,'FontAngle',p_para.group_names_fa,'UIContextMenu',group_names_cmenu);
    group_names_fh(2)=text(xl(1)-0.1*(xl(2)-xl(1)),yl(1)+0.35*(yl(2)-yl(1)),'trains',...
        'Color',p_para.group_names_col,'FontSize',p_para.group_names_fs,'FontWeight',p_para.group_names_fw,'FontAngle',p_para.group_names_fa,'UIContextMenu',group_names_cmenu);
    fh_str='group_names';
    SPIKY_handle_font
    if mod(f_para.num_trains,2)==0
        set(gca,'YTick',sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(0.15+[0 0.5])/1.3*f_para.subplot_size(2),'YTickLabel',[f_para.num_trains f_para.num_trains/2])
    else
        set(gca,'YTick',sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(0.15+[0 1-(f_para.num_trains-1)/2/f_para.num_trains])/1.3*f_para.subplot_size(2),'YTickLabel',[f_para.num_trains (f_para.num_trains-1)/2])
    end
end

if isfield(d_para,'thick_separators') && ~isempty(d_para.thick_separators)
    f_para.thick_separators=zeros(1,length(d_para.thick_separators));
    for sec=1:length(d_para.thick_separators)
        f_para.thick_separators(sec)=sum(d_para.select_trains(f_para.select_trains)<=d_para.thick_separators(sec));
    end
    thick_sep_cmenu = uicontextmenu;
    thick_sep_lh=zeros(1,length(f_para.thick_separators));
    for sec=1:length(f_para.thick_separators)
        thick_sep_lh(sec)=line([s_para.itmin s_para.itmax],(sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(1.15-f_para.thick_separators(sec)/f_para.num_trains)/1.3*f_para.subplot_size(2))*ones(1,2),...
            'Color',p_para.thick_sep_col,'LineStyle',p_para.thick_sep_ls,'LineWidth',p_para.thick_sep_lw,'UIContextMenu',thick_sep_cmenu);
    end
    lh_str='thick_sep';
    SPIKY_handle_line
end

if isfield(d_para,'thin_separators') && ~isempty(d_para.thin_separators)
    f_para.thin_separators=zeros(1,length(d_para.thin_separators));
    for sec=1:length(d_para.thin_separators)
        f_para.thin_separators(sec)=sum(d_para.select_trains(f_para.select_trains)<=d_para.thin_separators(sec));
    end
    thin_sep_cmenu = uicontextmenu;
    thin_sep_lh=zeros(1,length(f_para.thin_separators));
    for sec=1:length(f_para.thin_separators)
        thin_sep_lh(sec)=line([s_para.itmin s_para.itmax],(sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(1.15-f_para.thin_separators(sec)/f_para.num_trains)/1.3*f_para.subplot_size(2))*ones(1,2),...
            'Color',p_para.thin_sep_col,'LineStyle',p_para.thin_sep_ls,'LineWidth',p_para.thin_sep_lw,'UIContextMenu',thin_sep_cmenu);
    end
    lh_str='thin_sep';
    SPIKY_handle_line
end

if isfield(d_para,'thick_markers') && ~isempty(d_para.thick_markers)
    thick_mar_cmenu = uicontextmenu;
    thick_mar_lh=zeros(1,length(d_para.thick_markers));
    for mac=1:length(d_para.thick_markers)
        thick_mar_lh(mac)=line(d_para.thick_markers(mac)*ones(1,2),sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+[0.15 1.15]/1.3*f_para.subplot_size(2),...
            'Color',p_para.thick_mar_col,'LineStyle',p_para.thick_mar_ls,'LineWidth',p_para.thick_mar_lw,'UIContextMenu',thick_mar_cmenu);
    end
    lh_str='thick_mar';
    SPIKY_handle_line
    mov_handles.thick_mar_lh=thick_mar_lh;
end

if isfield(d_para,'thin_markers') && ~isempty(d_para.thin_markers)
    thin_mar_cmenu = uicontextmenu;
    thin_mar_lh=zeros(1,length(d_para.thin_markers));
    for mac=1:length(d_para.thin_markers)
        thin_mar_lh(mac)=line(d_para.thin_markers(mac)*ones(1,2),sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+[0.15 1.15]/1.3*f_para.subplot_size(2),...
            'Color',p_para.thin_mar_col,'LineStyle',p_para.thin_mar_ls,'LineWidth',p_para.thin_mar_lw,'UIContextMenu',thin_mar_cmenu);
    end
    lh_str='thin_mar';
    SPIKY_handle_line
    mov_handles.thin_mar_lh=thin_mar_lh;
end

set(gca,'XTickMode','auto','XTickLabelMode','auto')
xt=get(gca,'XTick');
xtc=xt(xt>=s_para.itmin & xt<=s_para.itmax);
if mod((xtc(end)-xtc(1)),f_para.x_scale)==0 && mod((xtc(2)-xtc(1)),f_para.x_scale)==0
    xtl=(xtc+f_para.x_offset)/f_para.x_scale;
    set(gca,'XTick',xtc,'XTickLabel',xtl)
else
    xxx=SPIKY_f_lab(xtc/f_para.x_scale,length(xtc)-(xtc(1)==s_para.itmin && xtc(end)==s_para.itmax),xtc(1)+f_para.x_offset==0,0);
    xxx2=xxx(xxx*f_para.x_scale>=s_para.itmin & xxx*f_para.x_scale<=s_para.itmax);
    set(gca,'XTick',xxx2*f_para.x_scale,'XTickLabel',xxx2+f_para.x_offset/f_para.x_scale)
end
if f_para.x_realtime_mode>0
    set(gca,'XTickLabel',str2num(get(gca,'XTickLabel'))-s_para.itmax);
end

if (f_para.dendrograms==1 && f_para.spike_train_color_coding_mode>1) || (f_para.num_select_train_groups>1 && f_para.spike_train_color_coding_mode==2) % comment?
    cm=colormap;
    if f_para.spike_train_color_coding_mode==2
        dcol_indy=round(1:63/(d_para.num_all_train_groups-1):64);
        dcols=cm(dcol_indy(d_para.select_train_groups(f_para.select_group_vect)),:);
    else
        dcol_indy=round(1:63/(f_para.num_trains-1):64);
        dcols=cm(dcol_indy,:);
    end
    d_para.dcols=cm(dcol_indy,:);
    
    if mod(f_para.spike_col,4)>1
        colpat_cmenu = uicontextmenu;
        colpat_ph=zeros(f_para.num_trains,2);
        for trac=1:f_para.num_trains
            colpat_ph(trac,1)=patch([f_para.tmin f_para.tmin-0.01*(f_para.tmax-f_para.tmin)*ones(1,2) f_para.tmin],...
                sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(1.15-(trac-1+[0 0 1 1])/f_para.num_trains)/1.3*f_para.subplot_size(2),...
                dcols(trac,:),'EdgeColor',dcols(trac,:),'Visible',p_para.colpat_vis,'UIContextMenu',colpat_cmenu);
            colpat_ph(trac,2)=patch([f_para.tmax f_para.tmax+0.01*(f_para.tmax-f_para.tmin)*ones(1,2) f_para.tmax],...
                sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(1.15-(trac-1+[0 0 1 1])/f_para.num_trains)/1.3*f_para.subplot_size(2),...
                dcols(trac,:),'EdgeColor',dcols(trac,:),'Visible',p_para.colpat_vis,'UIContextMenu',colpat_cmenu);
        end
        ph_str='colpat';
        SPIKY_handle_patch
    end
else
    d_para.dcols=[0 0 0];
    dcols=[];
end

num_spikes=cellfun('length',pspikes);
f_para.num_total_spikes=sum(num_spikes);
spike_cmenu = uicontextmenu;
spike_lh=cell(1,f_para.num_trains);
image_lh=zeros(1);
if f_para.num_total_spikes<f_para.max_total_spikes
    if f_para.spike_train_color_coding_mode>1 && mod(f_para.spike_col,2)>0
        for trac=1:f_para.num_trains
            for sc=1:f_para.num_pspikes(trac)
                spike_lh{trac}(sc)=line(pspikes{trac}(sc)*ones(1,2),sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(0.15+(f_para.num_trains-1-(trac-1)+[0.05 0.95])/f_para.num_trains)/1.3*f_para.subplot_size(2),...
                    'Color',dcols(trac,:),'LineStyle',p_para.spike_ls,'LineWidth',p_para.spike_lw,'UIContextMenu',spike_cmenu);
            end
        end
    else
        for trac=1:f_para.num_trains
            for sc=1:f_para.num_pspikes(trac)
                spike_lh{trac}(sc)=line(pspikes{trac}(sc)*ones(1,2),sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(0.15+(f_para.num_trains-1-(trac-1)+[0.05 0.95])/f_para.num_trains)/1.3*f_para.subplot_size(2),...
                    'Color',p_para.spike_col,'LineStyle',p_para.spike_ls,'LineWidth',p_para.spike_lw,'UIContextMenu',spike_cmenu);
            end
        end
    end
else
    image_cmenu = uicontextmenu;
    spike_density=zeros(f_para.num_trains,f_para.psth_num_bins);
    for trac=1:f_para.num_trains
        [histo_y,histo_x]=hist([pspikes{trac}],f_para.psth_num_bins);
        spike_density(trac,1:f_para.psth_num_bins)=histo_y;
    end
    xl=xlim; yl=ylim;
    image_lh=imagesc(spike_density,'XData',[s_para.itmin+s_para.itrange/(2*f_para.psth_num_bins) s_para.itmax-s_para.itrange/(2*f_para.psth_num_bins)],...
        'YData',sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+[(0.15+1/(2*f_para.num_trains))/1.3*f_para.subplot_size(2) ...
        (1.15-1/(2*f_para.num_trains))/1.3*f_para.subplot_size(2)],'UIContextMenu',image_cmenu);
    if f_para.num_trains<30 && f_para.psth_num_bins<30
        for trac=1:d_para.num_trains-1
            line([s_para.itmin s_para.itmax],(sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(0.15+...
                trac/f_para.num_trains)/1.3*f_para.subplot_size(2))*ones(1,2),'Color','k','LineStyle',':')
        end
        for bc=1:f_para.psth_num_bins-1
            line(s_para.itmin+bc*s_para.itrange/f_para.psth_num_bins*ones(1,2),...
                sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+[0.15/1.3*f_para.subplot_size(2) 1.15/1.3*f_para.subplot_size(2)],'Color','k','LineStyle',':')
        end
    end
    lh_str='image';
    SPIKY_handle_line
end

if f_para.spike_train_color_coding_mode>1
    set(gca,'Tag',num2str(reshape(dcols,1,size(dcols,1)*3)))
else
    set(gca,'Tag','')
end
set(gca,'UserData',pspikes)
lh_str='spike';
SPIKY_handle_line
mov_handles.spike_lh=spike_lh;


set(gca,'XColor',p_para.prof_tick_col,'YColor',p_para.prof_tick_col,'FontSize',p_para.prof_tick_fs,'FontWeight',p_para.prof_tick_fw,'FontAngle',p_para.prof_tick_fa)

prof_tick_cmenu = uicontextmenu;
prof_tick_fh=zeros(1,2);
prof_tick_fh(1)=line(xl,yl(1)*ones(1,2),'Color',p_para.prof_tick_col,'UIContextMenu',prof_tick_cmenu);
prof_tick_fh(2)=line(xl(1)*ones(1,2),yl,'Color','w','UIContextMenu',prof_tick_cmenu);
fh_str='prof_tick';
SPIKY_handle_set_property

if f_para.histogram
    xticks=get(gca,'XTick');
    xlim([s_para.itmin-0.02*s_para.itrange s_para.itmax+0.24*s_para.itrange])
    set(gca,'XTick',xticks)
    hh=bar(f_para.num_pspikes);
    set(hh,'XData',sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(0.15+(f_para.num_trains-1-((1:f_para.num_trains)-1)+0.5)/f_para.num_trains)/1.3*f_para.subplot_size(2))
    set(hh,'BaseValue',s_para.itmin+1.02*s_para.itrange)
    set(hh,'YData',(s_para.itmin+1.02*s_para.itrange+f_para.num_pspikes/max(f_para.num_pspikes)*0.2*s_para.itrange))
    %set(hh,'BaseLine',0.2*s_para.itrange)

    set(hh,'horizontal','on')
    %xlabel('# Spikes','Color','k','FontSize',12,'FontWeight','bold')
    line((s_para.itmin+1.22*s_para.itrange)*ones(1,2),sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+(0.15+(f_para.num_trains-1-(([0 f_para.num_trains])-1))/f_para.num_trains)/1.3*f_para.subplot_size(2),'LineStyle',':','Color','k')
    %text(1.18*s_para.itrange,sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+0.1,num2str(max(f_para.num_pspikes)),'FontSize',12)
    hist_max_cmenu = uicontextmenu;
    hist_max_fh=text((s_para.itmin+1.18*s_para.itrange),sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+0.05/1.3*f_para.subplot_size(2),num2str(max(f_para.num_pspikes)),'Color',p_para.hist_max_col,'FontSize',p_para.hist_max_fs,...
        'FontWeight',p_para.hist_max_fw,'FontAngle',p_para.hist_max_fa,'UIContextMenu',hist_max_cmenu);
    fh_str='hist_max';
    SPIKY_handle_font
end

if isfield(results,'window_spikes')
    results=rmfield(results,'window_spikes');
end
if d_para.tmin~=f_para.tmin || d_para.tmax~=f_para.tmax || d_para.num_trains~=f_para.num_trains
    results.window_spikes=pspikes;
end

