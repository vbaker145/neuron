% This initializes the spike train generator (STG).

%fig=figure(f_para.num_fig);
set(gcf,'Name',[d_para.comment_string])
hold on
d_para.tmin=round(d_para.tmin/d_para.dts)*d_para.dts;
d_para.tmax=round(d_para.tmax/d_para.dts)*d_para.dts;
s_para.itmin=d_para.tmin;
s_para.itmax=d_para.tmax;

s_para.itrange=s_para.itmax-s_para.itmin;
xlim([s_para.itmin-0.02*s_para.itrange s_para.itmax+0.02*s_para.itrange])
%ylim([-0.1 1.2])
ylim([0 1.1])
xl=xlim; yl=ylim;
set(gca,'XTickMode','auto','XTickLabelMode','auto')

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
prof_tick_fh(1)=line(xl,yl(1)*ones(1,2),'Color','w','UIContextMenu',prof_tick_cmenu);
prof_tick_fh(2)=line(xl(1)*ones(1,2),yl,'Color','w','UIContextMenu',prof_tick_cmenu);
fh_str='prof_tick';
SPIKY_handle_set_property

st_sep_cmenu = uicontextmenu;
st_sep_lh=zeros(1,d_para.num_trains-1);
for stc=1:d_para.num_trains-1
    st_sep_lh(stc)=line([d_para.tmin d_para.tmax],0.05+(stc/d_para.num_trains)*ones(1,2),...
        'Color',p_para.st_sep_col,'LineStyle',p_para.st_sep_ls,'LineWidth',p_para.st_sep_lw,'UIContextMenu',st_sep_cmenu);
end
lh_str='st_sep';
SPIKY_handle_line

