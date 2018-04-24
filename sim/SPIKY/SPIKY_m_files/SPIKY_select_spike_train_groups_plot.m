% This function provides an input mask for the selection and sorting of your input spike trains before the calculation
% of the dissimilarity measures. You can select/eliminate spike train groups and change their order manually via the buttons
% at the top but you can also sort the spike train groups according to some predefined criteria (such as number of spikes and latency).
% Furthermore, once you have plotted some dendrograms you can also sort the spike train groups according to the clustering obtained.

function SPIKY_select_spike_train_groups_plot(hObject, eventdata, handles)

f_para=getappdata(handles.figure1,'figure_parameters');

if f_para.num_all_train_groups>1
    h_para=getappdata(handles.figure1,'help_parameters');
    if ~isfield(f_para,'select_train_groups') || isempty(f_para.select_train_groups)
        f_para.select_train_groups=1:f_para.num_all_train_groups;
        f_para.num_select_train_groups=length(f_para.select_train_groups);
    end
    if size(f_para.select_train_groups,2)<size(f_para.select_train_groups,1)
        f_para.select_train_groups=f_para.select_train_groups';
    end

    STGP.fig=figure('units','normalized','menubar','none','position',[0.05 0.07 0.4 0.86],'Name','Spike train group selection and sorting',...
        'NumberTitle','off','Color',[0.9294 0.9176 0.851],'KeyPressFcn',{@STGP_keyboard},'DeleteFcn',{@SPIKY_select_spike_train_groups_plot_Close},...
        'WindowStyle','modal'); 

    STGP.lb=uicontrol('style','listbox','units','normalized','position',[0.1 0.12 0.4 0.84],'FontSize',10,...
        'BackgroundColor','w','string',num2str(f_para.select_train_groups'),'Min',1,'Max',f_para.num_select_train_groups,...
        'HorizontalAlignment','center','Value',1,'KeyPressFcn',{@STGP_keyboard});

    STGP.top_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.92 0.2 0.04],...
        'string','Top','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_train_groups_plot_ListBox_callback});
    STGP.up_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.86 0.2 0.04],...
        'string','Up','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_train_groups_plot_ListBox_callback});
    STGP.down_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.81 0.2 0.04],...
        'string','Down','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_train_groups_plot_ListBox_callback});
    STGP.bottom_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.75 0.2 0.04],...
        'string','Bottom','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_train_groups_plot_ListBox_callback});
    STGP.delete_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.67 0.2 0.04],...
        'string','Delete','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_train_groups_plot_ListBox_callback});
    
    if isfield(f_para,'group_dendro_order')
        if h_para.num_measures>1
            STGP.dendro_panel=uipanel('units','normalized','position',[0.52 0.37 0.46 0.175],'title','Cluster order:','FontSize',14,'parent',STGP.fig);
            STGP.cluster_lb=uicontrol('style','listbox','units','normalized','position',[0.54 0.43 0.42 0.08],'FontSize',10,...
                'BackgroundColor','w','string',num2str((1:h_para.num_measures)'),'Min',1,'Max',h_para.num_measures,...
                'HorizontalAlignment','center','Value',1);
            STGP.decreasing_group_dendro_order_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.385 0.18 0.03],...
                'string','Decreasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
                'CallBack',{@SPIKY_select_spike_train_groups_plot_Reset});
            STGP.increasing_group_dendro_order_pb=uicontrol('style','pushbutton','units','normalized','position',[0.77 0.385 0.18 0.03],...
                'string','Increasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
                'CallBack',{@SPIKY_select_spike_train_groups_plot_Reset});
        else
            STGP.dendro_panel=uipanel('units','normalized','position',[0.52 0.4 0.46 0.1],'title','Cluster order:','FontSize',14,'parent',STGP.fig);
            STGP.decreasing_group_dendro_order_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.43 0.18 0.03],...
                'string','Decreasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
                'CallBack',{@SPIKY_select_spike_train_groups_plot_Reset});
            STGP.increasing_group_dendro_order_pb=uicontrol('style','pushbutton','units','normalized','position',[0.77 0.43 0.18 0.03],...
                'string','Increasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
                'CallBack',{@SPIKY_select_spike_train_groups_plot_Reset});
        end
    end

    STGP.reset_pb=uicontrol('style','pushbutton','units','normalized','position',[0.6 0.2 0.3 0.04],...
        'string','Reset','FontSize',14,'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_train_groups_plot_Reset});

    STGP.cancel_pb=uicontrol('style','pushbutton','units','normalized','position',[0.15 0.04 0.3 0.04],...
        'string','Cancel','FontSize',14,'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_train_groups_plot_Close});
    STGP.ok_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.04 0.3 0.04],...
        'string','OK','FontSize',14,'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_train_groups_plot_Close},'UserData',0);
else
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('This action does not make sense for just one group.'),'Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    set(handles.fpara_select_train_mode_popupmenu,'Value',1)
    set(handles.fpara_trains_edit,'String','','Enable','off')
    set(handles.fpara_train_groups_edit,'String','','Enable','off')
    set(handles.fpara_select_trains_pb,'Enable','off')
    set(handles.fpara_select_train_groups_pb,'Enable','off')
    uiwait(mbh);
end

    function SPIKY_select_spike_train_groups_plot_ListBox_callback(varargin)

        figure(f_para.num_fig);
        lb_marked=get(STGP.lb,'Value');
        lb_str=get(STGP.lb,'String');
        lb_num_strings=size(lb_str,1);
        
        if gcbo==STGP.top_pb
            dummy=lb_str(lb_marked,:);
            dummy2=lb_str(setdiff(1:lb_num_strings,lb_marked),:);
            lb_str(1:length(lb_marked),:)=dummy;
            lb_str(length(lb_marked)+1:lb_num_strings,:)=dummy2;            
            set(STGP.lb,'Value',1:length(lb_marked))
        elseif gcbo==STGP.up_pb
            for mc=1:length(lb_marked)
                if lb_marked(mc)>mc
                    dummy=lb_str(lb_marked(mc)-1,:);
                    lb_str(lb_marked(mc)-1,:)=lb_str(lb_marked(mc),:);
                    lb_str(lb_marked(mc),:)=dummy;
                    lb_marked(mc)=lb_marked(mc)-1;
                end
            end
            set(STGP.lb,'Value',lb_marked)
        elseif gcbo==STGP.down_pb
            for mc=length(lb_marked):-1:1
                if lb_marked(mc)<lb_num_strings-(length(lb_marked)-mc)
                    dummy=lb_str(lb_marked(mc)+1,:);
                    lb_str(lb_marked(mc)+1,:)=lb_str(lb_marked(mc),:);
                    lb_str(lb_marked(mc),:)=dummy;
                    lb_marked(mc)=lb_marked(mc)+1;
                end
            end
            set(STGP.lb,'Value',lb_marked)
        elseif gcbo==STGP.bottom_pb
            dummy=lb_str(lb_marked,:);
            dummy2=lb_str(setdiff(1:lb_num_strings,lb_marked),:);
            lb_str(1:lb_num_strings-length(lb_marked),:)=dummy2;
            lb_str(lb_num_strings-length(lb_marked)+1:lb_num_strings,:)=dummy;            
            set(STGP.lb,'Value',lb_num_strings-length(lb_marked)+1:lb_num_strings)
        elseif gcbo==STGP.delete_pb || (nargin==1 && varargin{1}==STGP.delete_pb)
            for mc=length(lb_marked):-1:1
                lb_str(lb_marked(mc):lb_num_strings-1,:)=lb_str(lb_marked(mc)+1:lb_num_strings,:);
                lb_num_strings=lb_num_strings-1;
                lb_str=lb_str(1:lb_num_strings,:);
            end            
            set(STGP.lb,'Value',1)
        end
        set(STGP.lb,'String',lb_str)
        f_para.select_train_groups=str2num(lb_str);
        f_para.num_select_train_groups=length(f_para.select_train_groups);
        setappdata(handles.figure1,'figure_parameters',f_para);
    end

    function SPIKY_select_spike_train_groups_plot_Reset(varargin)
        if gcbo==STGP.reset_pb
            f_para.select_train_groups=1:f_para.num_all_train_groups;
            f_para.num_select_train_groups=f_para.num_all_train_groups;
        elseif isfield(f_para,'group_dendro_order') && (gcbo==STGP.decreasing_group_dendro_order_pb || gcbo==STGP.increasing_group_dendro_order_pb)
            dummy=sort(f_para.select_train_groups);
            if h_para.num_measures>1
                indy=get(STP.cluster_lb,'Value');
            else
                indy=1;
            end
            if gcbo==STGP.decreasing_group_dendro_order_pb
                f_para.select_train_groups=dummy(f_para.group_dendro_order{indy});
            else
                f_para.select_train_groups=dummy(f_para.group_dendro_order{indy}(end:-1:1));
            end
            f_para.num_select_train_groups=length(f_para.select_train_groups);
        end
        set(STGP.lb,'string',num2str(f_para.select_train_groups'))
        set(STGP.lb,'Value',1)
    end

    function STGP_keyboard(varargin)
        if strcmp(varargin{2}.Key,'delete')
            SPIKY_select_spike_train_groups_plot_ListBox_callback(STGP.delete_pb);
        end
    end

    function SPIKY_select_spike_train_groups_plot_Close(varargin)
        if (gcbo==STGP.cancel_pb || gcbo==STGP.fig) && get(STGP.ok_pb,'UserData')==0
           f_para.select_train_groups=1:f_para.num_all_train_groups;
        elseif gcbo==STGP.ok_pb
            f_para.select_train_groups=str2num(get(STGP.lb,'String'))';
            f_para.num_select_train_groups=length(f_para.select_train_groups);
            set(STGP.ok_pb,'UserData',1)
        end
        set(handles.fpara_train_groups_edit,'String',regexprep(num2str(f_para.select_train_groups),'\s+',' '))
        setappdata(handles.figure1,'figure_parameters',f_para);
        delete(gcbf)
    end
end
