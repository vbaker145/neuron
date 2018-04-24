% This function provides an input mask for the selection and sorting of your input spike train groups
% before the calculation of the dissimilarity measures. You can select/eliminate spike train groups and
% change their order manually via the buttons at the top.

function SPIKY_select_spike_train_groups_calc(hObject, eventdata, handles)

d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
p_para=getappdata(handles.figure1,'plot_parameters');
allspikes=getappdata(handles.figure1,'allspikes');

ds=get(handles.dpara_group_names_edit,'String');
d_para.all_train_group_names=cell(1,length(find(ds==';')));
for strc=1:length(find(ds==';'))
    d_para.all_train_group_names{strc}=ds(1:find(ds==';',1,'first')-1);
    ds=ds(find(ds==';',1,'first')+2:end);
end
d_para.all_train_group_sizes=str2num(get(handles.dpara_group_sizes_edit,'String'));
if isfield(d_para,'all_train_group_names') && isfield(d_para,'all_train_group_sizes')
    % && ~isempty(d_para.all_train_group_sizes) && length(d_para.all_train_group_names)==length(d_para.all_train_group_sizes)
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

if d_para.num_all_train_groups>1
    if ~isfield(d_para,'select_train_groups') || isempty(d_para.select_train_groups)
        d_para.select_train_groups=1:d_para.num_all_train_groups;
        d_para.num_select_train_groups=d_para.num_all_train_groups;
    end
    if size(d_para.select_train_groups,2)>size(d_para.select_train_groups,1)
        d_para.select_train_groups=d_para.select_train_groups';
    end

    STGC.fig=figure('units','normalized','menubar','none','position',[0.05 0.07 0.4 0.86],'Name','Spike train group selection and sorting',...
        'NumberTitle','off','Color',[0.9294 0.9176 0.851],'KeyPressFcn',{@STGC_keyboard},'DeleteFcn',{@SPIKY_select_spike_train_groups_calc_Close},...
        'WindowStyle','modal');

    STGC.lb=uicontrol('style','listbox','units','normalized','position',[0.1 0.12 0.4 0.84],'FontSize',10,...
        'BackgroundColor','w','string',num2str(d_para.select_train_groups),'Min',1,'Max',d_para.num_all_train_groups,...
        'HorizontalAlignment','center','Value',1,'KeyPressFcn',{@STGC_keyboard});

    STGC.top_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.92 0.2 0.04],...
        'string','Top','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_train_groups_calc_ListBox_callback});
    STGC.up_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.84 0.2 0.04],...
        'string','Up','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_train_groups_calc_ListBox_callback});
    STGC.down_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.78 0.2 0.04],...
        'string','Down','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_train_groups_calc_ListBox_callback});
    STGC.bottom_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.7 0.2 0.04],...
        'string','Bottom','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_train_groups_calc_ListBox_callback});
    STGC.delete_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.58 0.2 0.04],...
        'string','Delete','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_train_groups_calc_ListBox_callback});

    STGC.reset_pb=uicontrol('style','pushbutton','units','normalized','position',[0.6 0.2 0.3 0.04],...
        'string','Reset','FontSize',14,'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_select_spike_train_groups_calc_Reset});

    STGC.cancel_pb=uicontrol('style','pushbutton','units','normalized','position',[0.15 0.04 0.3 0.04],...
        'string','Cancel','FontSize',14,'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_select_spike_train_groups_calc_Close});
    STGC.ok_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.04 0.3 0.04],...
        'string','OK','FontSize',14,'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_select_spike_train_groups_calc_Close},'UserData',0);

    figure(f_para.num_fig);
    cm=colormap;
    dcol_indy=round(1:63/(d_para.num_all_train_groups-1):64);
    dcols=cm(dcol_indy,:);
    dcol_indy2=round(1:63/(d_para.num_all_trains-1):64);
    dcols2=cm(dcol_indy2,:);
    d_para.dcols=cm(dcol_indy,:);
    colpat_ph=zeros(d_para.num_trains,2);
    for trac=1:d_para.num_trains
        colpat_ph(trac,1)=patch([d_para.tmin d_para.tmin-0.01*(d_para.tmax-d_para.tmin)*ones(1,2) d_para.tmin],(1.05-(trac-1+[0 0 1 1])/d_para.num_trains),...
            dcols(d_para.group_vect(d_para.preselect_trains(trac)),:),'EdgeColor',dcols(d_para.group_vect(d_para.preselect_trains(trac)),:));
        colpat_ph(trac,2)=patch([d_para.tmax d_para.tmax+0.01*(d_para.tmax-d_para.tmin)*ones(1,2) d_para.tmax],(1.05-(trac-1+[0 0 1 1])/d_para.num_trains),...
            dcols2(d_para.preselect_trains(trac),:),'EdgeColor',dcols2(d_para.preselect_trains(trac),:));
    end
else
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('This action does not make sense for just one group.'),'Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    set(handles.dpara_select_train_mode_popupmenu,'Value',1)
    set(handles.dpara_trains_edit,'String','','Enable','off')
    set(handles.dpara_train_groups_edit,'String','','Enable','off')
    set(handles.dpara_select_trains_pb,'Enable','off')
    set(handles.dpara_select_train_groups_pb,'Enable','off')
    uiwait(mbh);
end

    function SPIKY_select_spike_train_groups_calc_ListBox_callback(varargin)

        figure(f_para.num_fig);
        lb_marked=get(STGC.lb,'Value');
        lb_str=get(STGC.lb,'String');
        lb_num_strings=size(lb_str,1);
        
        if gcbo==STGC.top_pb
            dummy=lb_str(lb_marked,:);
            dummy2=lb_str(setdiff(1:lb_num_strings,lb_marked),:);
            lb_str(1:length(lb_marked),:)=dummy;
            lb_str(length(lb_marked)+1:lb_num_strings,:)=dummy2;            
            set(STGC.lb,'Value',1:length(lb_marked))
        elseif gcbo==STGC.up_pb
            for mc=1:length(lb_marked)
                if lb_marked(mc)>mc
                    dummy=lb_str(lb_marked(mc)-1,:);
                    lb_str(lb_marked(mc)-1,:)=lb_str(lb_marked(mc),:);
                    lb_str(lb_marked(mc),:)=dummy;
                    lb_marked(mc)=lb_marked(mc)-1;
                end
            end
            set(STGC.lb,'Value',lb_marked)
        elseif gcbo==STGC.down_pb
            for mc=length(lb_marked):-1:1
                if lb_marked(mc)<lb_num_strings-(length(lb_marked)-mc)
                    dummy=lb_str(lb_marked(mc)+1,:);
                    lb_str(lb_marked(mc)+1,:)=lb_str(lb_marked(mc),:);
                    lb_str(lb_marked(mc),:)=dummy;
                    lb_marked(mc)=lb_marked(mc)+1;
                end
            end
            set(STGC.lb,'Value',lb_marked)
        elseif gcbo==STGC.bottom_pb
            dummy=lb_str(lb_marked,:);
            dummy2=lb_str(setdiff(1:lb_num_strings,lb_marked),:);
            lb_str(1:lb_num_strings-length(lb_marked),:)=dummy2;
            lb_str(lb_num_strings-length(lb_marked)+1:lb_num_strings,:)=dummy;            
            set(STGC.lb,'Value',lb_num_strings-length(lb_marked)+1:lb_num_strings)
        elseif gcbo==STGC.delete_pb || (nargin==1 && varargin{1}==STGC.delete_pb)
            for mc=length(lb_marked):-1:1
                lb_str(lb_marked(mc):lb_num_strings-1,:)=lb_str(lb_marked(mc)+1:lb_num_strings,:);
                lb_num_strings=lb_num_strings-1;
                lb_str=lb_str(1:lb_num_strings,:);
            end            
            set(STGC.lb,'Value',1)
        end
        set(STGC.lb,'String',lb_str)
        d_para.select_train_groups=str2num(lb_str);
        d_para.num_select_train_groups=length(d_para.select_train_groups);
        setappdata(handles.figure1,'data_parameters',d_para);
        SPIKY_plot_select_spikes
    end

    function SPIKY_select_spike_train_groups_calc_Reset(varargin)
        d_para.select_train_groups=1:d_para.num_all_train_groups;
        d_para.num_select_train_groups=d_para.num_all_train_groups;
        set(STGC.lb,'string',num2str(d_para.select_train_groups'))
        set(STGC.lb,'Value',1)
        SPIKY_plot_select_spikes
    end

    function SPIKY_plot_select_spikes(varargin)
        figure(f_para.num_fig);
        set(gcf,'Name',[d_para.comment_string])
        clf;
        set(gca,'Position',f_para.supo1)
        plot(-1000,-1000);
        hold on
        xlim([d_para.tmin-0.02*(d_para.tmax-d_para.tmin) d_para.tmax+0.02*(d_para.tmax-d_para.tmin)])
        ylim([0 1.1])
        xl=xlim; yl=ylim;
        set(gca,'XTickMode','auto','XTickLabelMode','auto')
        box on
        d_para.preselect_trains=[];
        for groc=1:d_para.num_select_train_groups
            d_para.preselect_trains=[d_para.preselect_trains find(d_para.group_vect==d_para.select_train_groups(groc))];
        end
        d_para.num_trains=length(d_para.preselect_trains);
        d_para.num_select_train_groups=length(d_para.select_train_groups);
        d_para.num_allspikes=zeros(1,d_para.num_all_train_groups);
        pspikes=cell(1,d_para.num_trains);          % original allspikes used for plotting (in units of d_para.dts)
        pspikes2=cell(1,d_para.num_trains);
        spike_lh=cell(1,d_para.num_trains);
        for tracc=1:d_para.num_trains
            pspikes{tracc}=round(sort(allspikes{d_para.preselect_trains(tracc)})/d_para.dts)*d_para.dts;
            pspikes2{tracc}=pspikes{tracc}(pspikes{tracc}>=d_para.tmin & pspikes{tracc}<=d_para.tmax);
            d_para.num_allspikes(tracc)=length(pspikes2{tracc});
            for sc=1:d_para.num_allspikes(tracc)
                spike_lh{tracc}(sc)=line(pspikes2{tracc}(sc)*ones(1,2),0.05+(d_para.num_trains-1-(tracc-1)+[0.05 0.95])/d_para.num_trains,...
                    'Color',p_para.spike_col,'LineStyle',p_para.spike_ls,'LineWidth',p_para.spike_lw);
            end
        end
        d_para.max_num_allspikes=max(d_para.num_allspikes);
        set(gca,'UserData',pspikes)
        setappdata(handles.figure1,'spike_lh',spike_lh)

        line(xl,0.05*ones(1,2),'Color',p_para.sp_bounds_col,'LineStyle',p_para.sp_bounds_ls,'LineWidth',p_para.sp_bounds_lw);
        line(xl,1.05*ones(1,2),'Color',p_para.sp_bounds_col,'LineStyle',p_para.sp_bounds_ls,'LineWidth',p_para.sp_bounds_lw);

        line(d_para.tmin*ones(1,2),yl,'Color',p_para.tbounds_col,'LineStyle',p_para.tbounds_ls,'LineWidth',p_para.tbounds_lw);
        line(d_para.tmax*ones(1,2),yl,'Color',p_para.tbounds_col,'LineStyle',p_para.tbounds_ls,'LineWidth',p_para.tbounds_lw);

        xlabel(['Time ',f_para.time_unit_string],'Color',p_para.xlab_col,'FontSize',p_para.xlab_fs,'FontWeight',p_para.xlab_fw,...
            'FontAngle',p_para.xlab_fa);

        set(gca,'FontSize',p_para.prof_tick_fs)

        text(xl(1)-0.075*(xl(2)-xl(1)),yl(1)+0.7*(yl(2)-yl(1)),'Spike','Color',p_para.group_names_col,...
            'FontSize',p_para.group_names_fs,'FontWeight',p_para.group_names_fw,'FontAngle',p_para.group_names_fa);
        text(xl(1)-0.075*(xl(2)-xl(1)),yl(1)+0.35*(yl(2)-yl(1)),'trains','Color',p_para.group_names_col,...
            'FontSize',p_para.group_names_fs,'FontWeight',p_para.group_names_fw,'FontAngle',p_para.group_names_fa);

        if mod(d_para.num_trains,2)==0
            set(gca,'YTick',0.05+[0 0.5],'YTickLabel',[d_para.num_trains d_para.num_trains/2])
        else
            set(gca,'YTick',0.05+[0 1-(d_para.num_trains-1)/2/d_para.num_trains],'YTickLabel',[d_para.num_trains (d_para.num_trains-1)/2])
        end

        set(gca,'XColor',p_para.prof_tick_col,'YColor',p_para.prof_tick_col,'FontSize',p_para.prof_tick_fs,...
            'FontWeight',p_para.prof_tick_fw,'FontAngle',p_para.prof_tick_fa)

        line(xl,yl(1)*ones(1,2),'Color',p_para.prof_tick_col);
        line(xl(1)*ones(1,2),yl,'Color',p_para.prof_tick_col);

        box on
        cm=colormap;
        dcol_indy=round(1:63/(d_para.num_all_train_groups-1):64);
        dcols=cm(dcol_indy,:);
        dcol_indy2=round(1:63/(d_para.num_all_trains-1):64);
        dcols2=cm(dcol_indy2,:);
        d_para.dcols=cm(dcol_indy,:);
        colpat_ph=zeros(d_para.num_trains,2);
        for tracc=1:d_para.num_trains
            colpat_ph(tracc,1)=patch([d_para.tmin d_para.tmin-0.01*(d_para.tmax-d_para.tmin)*ones(1,2) d_para.tmin],(1.05-(tracc-1+[0 0 1 1])/d_para.num_trains),...
                dcols(d_para.group_vect(d_para.preselect_trains(tracc)),:),'EdgeColor',dcols(d_para.group_vect(d_para.preselect_trains(tracc)),:));
            %colpat_ph(tracc,2)=patch([d_para.tmax d_para.tmax+0.01*(d_para.tmax-d_para.tmin)*ones(1,2) d_para.tmax],(1.05-(tracc-1+[0 0 1 1])/d_para.num_trains),...
            %    dcols(d_para.group_vect(d_para.preselect_trains(tracc)),:),'EdgeColor',dcols(d_para.group_vect(d_para.preselect_trains(tracc)),:));
            colpat_ph(tracc,2)=patch([d_para.tmax d_para.tmax+0.01*(d_para.tmax-d_para.tmin)*ones(1,2) d_para.tmax],(1.05-(tracc-1+[0 0 1 1])/d_para.num_trains),...
                dcols2(d_para.preselect_trains(tracc),:),'EdgeColor',dcols2(d_para.preselect_trains(tracc),:));
        end
    end

    function STGC_keyboard(varargin)
        if strcmp(varargin{2}.Key,'delete')
            SPIKY_select_spike_train_groups_calc_ListBox_callback(STGC.delete_pb);
        end
    end

    function SPIKY_select_spike_train_groups_calc_Close(varargin)
        if (gcbo==STGC.cancel_pb || gcbo==STGC.fig) && get(STGC.ok_pb,'UserData')==0
            d_para.select_train_groups=1:d_para.num_all_train_groups;
            SPIKY_plot_select_spikes
            delete(colpat_ph)
        elseif gcbo==STGC.ok_pb
            d_para.select_train_groups=str2num(get(STGC.lb,'String'))';
            SPIKY_plot_select_spikes
            set(STGC.ok_pb,'UserData',1)
            delete(colpat_ph)
        end
        set(handles.dpara_train_groups_edit,'String',regexprep(num2str(d_para.select_train_groups),'\s+',' ')) % #############
        setappdata(handles.figure1,'data_parameters',d_para);
        delete(gcbf)
    end
end
