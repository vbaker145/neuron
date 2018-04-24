% This function provides an input mask for the selection and sorting of your input spike trains after the calculation
% of the dissimilarity measures. You can select/eliminate spike trains and change their order manually via the buttons
% at the top but you can also sort the spike trains according to some predefined criteria (such as number of spikes and latency).
% Furthermore, once you have plotted some dendrograms you can also sort the spike trains according to the clustering obtained.

function SPIKY_select_spike_trains_plot(hObject, eventdata, handles)

h_para=getappdata(handles.figure1,'help_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
if size(f_para.select_trains,2)>size(f_para.select_trains,1)
    f_para.select_trains=f_para.select_trains';
end
f_para.tmin=str2double(get(handles.fpara_tmin_edit,'String'));
f_para.tmax=str2double(get(handles.fpara_tmax_edit,'String'));
spikes=getappdata(handles.figure1,'spikes');


STP.fig=figure('units','normalized','menubar','none','position',[0.05 0.07 0.4 0.86],'Name','Spike train selection and sorting',...
    'NumberTitle','off','Color',[0.9294 0.9176 0.851],'KeyPressFcn',{@STP_keyboard},'DeleteFcn',{@SPIKY_select_spike_trains_plot_Close},...
    'WindowStyle','modal'); 

STP.lb=uicontrol('style','listbox','units','normalized','position',[0.1 0.12 0.4 0.84],'FontSize',10,...
    'BackgroundColor','w','string',num2str(f_para.select_trains),'Min',1,'Max',f_para.num_all_trains,...
    'HorizontalAlignment','center','Value',1,'KeyPressFcn',{@STP_keyboard});

STP.top_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.93 0.2 0.03],...
    'string','Top','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_plot_ListBox_callback});
STP.up_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.89 0.2 0.03],...
    'string','Up','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_plot_ListBox_callback});
STP.down_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.855 0.2 0.03],...
    'string','Down','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_plot_ListBox_callback});
STP.bottom_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.815 0.2 0.03],...
    'string','Bottom','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_plot_ListBox_callback});
STP.delete_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.77 0.2 0.03],...
    'string','Delete','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_plot_ListBox_callback});

STP.sn_panel=uipanel('units','normalized','position',[0.52 0.38 0.46 0.175],'title','Spike number:','FontSize',14,'parent',STP.fig);
uicontrol('style','text','units','normalized','position',[0.55 0.5 0.07 0.03],'HorizontalAlignment','left',...
    'string','Onset:','FontSize',13,'FontUnits','normalized');
STP.spike_number_onset_edit=uicontrol('style','edit','units','normalized','position',[0.63 0.505 0.11 0.025],'BackgroundColor','w',...
    'string',num2str(f_para.tmin),'FontSize',13,'FontUnits','normalized');
uicontrol('style','text','units','normalized','position',[0.755 0.5 0.07 0.03],'HorizontalAlignment','left',...
    'string','Offset:','FontSize',13,'FontUnits','normalized');
STP.spike_number_offset_edit=uicontrol('style','edit','units','normalized','position',[0.83 0.505 0.11 0.025],'BackgroundColor','w',...
    'string',num2str(f_para.tmax),'FontSize',13,'FontUnits','normalized');
uicontrol('style','text','units','normalized','position',[0.565 0.48 0.05 0.03],'HorizontalAlignment','left',...
    'string','All:','FontSize',13,'FontWeight','bold','FontUnits','normalized');
STP.decreasing_spike_number_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.455 0.18 0.03],...
    'string','Decreasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_plot_Reset});
STP.increasing_spike_number_pb=uicontrol('style','pushbutton','units','normalized','position',[0.77 0.455 0.18 0.03],...
    'string','Increasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_plot_Reset});

STP.lat_panel=uipanel('units','normalized','position',[0.52 0.195 0.46 0.175],'title','Latency:','FontSize',14,'parent',STP.fig);
uicontrol('style','text','units','normalized','position',[0.65 0.315 0.07 0.03],'HorizontalAlignment','left',...
    'string','Onset:','FontSize',13,'FontUnits','normalized');
STP.latency_onset_edit=uicontrol('style','edit','units','normalized','position',[0.73 0.32 0.12 0.025],'BackgroundColor','w',...
    'string',num2str(f_para.tmin),'FontSize',13,'FontUnits','normalized');
uicontrol('style','text','units','normalized','position',[0.565 0.295 0.05 0.03],'HorizontalAlignment','left',...
    'string','All:','FontSize',13,'FontWeight','bold','FontUnits','normalized');
STP.decreasing_latency_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.27 0.18 0.03],...
    'string','Decreasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_plot_Reset});
STP.increasing_latency_pb=uicontrol('style','pushbutton','units','normalized','position',[0.77 0.27 0.18 0.03],...
    'string','Increasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_plot_Reset});

if f_para.num_all_train_groups>1
    uicontrol('style','text','units','normalized','position',[0.565 0.415 0.15 0.03],'HorizontalAlignment','left',...
        'string','Within group:','FontSize',13,'FontWeight','bold','FontUnits','normalized');
    STP.decreasing_spike_number_within_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.39 0.18 0.03],...
        'string','Decreasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_trains_plot_Reset});
    STP.increasing_spike_number_within_pb=uicontrol('style','pushbutton','units','normalized','position',[0.77 0.39 0.18 0.03],...
        'string','Increasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_trains_plot_Reset});
    
    uicontrol('style','text','units','normalized','position',[0.565 0.23 0.15 0.03],'HorizontalAlignment','left',...
        'string','Within group:','FontSize',13,'FontWeight','bold','FontUnits','normalized');
    STP.decreasing_latency_within_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.205 0.18 0.03],...
        'string','Decreasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_trains_plot_Reset});
    STP.increasing_latency_within_pb=uicontrol('style','pushbutton','units','normalized','position',[0.77 0.205 0.18 0.03],...
        'string','Increasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_trains_plot_Reset});
end

if isfield(f_para,'dendro_order')
    if h_para.num_measures>1
        STP.dendro_panel=uipanel('units','normalized','position',[0.52 0.57 0.46 0.175],'title','Cluster order:','FontSize',14,'parent',STP.fig);
        STP.cluster_lb=uicontrol('style','listbox','units','normalized','position',[0.54 0.63 0.42 0.08],'FontSize',10,...
            'BackgroundColor','w','string',num2str((1:h_para.num_measures)'),'Min',1,'Max',h_para.num_measures,...
            'HorizontalAlignment','center','Value',1);
        STP.decreasing_dendro_order_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.585 0.18 0.03],...
            'string','Decreasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
            'CallBack',{@SPIKY_select_spike_trains_plot_Reset});
        STP.increasing_dendro_order_pb=uicontrol('style','pushbutton','units','normalized','position',[0.77 0.585 0.18 0.03],...
            'string','Increasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
            'CallBack',{@SPIKY_select_spike_trains_plot_Reset});
    else
        STP.dendro_panel=uipanel('units','normalized','position',[0.52 0.61 0.46 0.1],'title','Cluster order:','FontSize',14,'parent',STP.fig);
        STP.decreasing_dendro_order_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.64 0.18 0.03],...
            'string','Decreasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
            'CallBack',{@SPIKY_select_spike_trains_plot_Reset});
        STP.increasing_dendro_order_pb=uicontrol('style','pushbutton','units','normalized','position',[0.77 0.64 0.18 0.03],...
            'string','Increasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
            'CallBack',{@SPIKY_select_spike_trains_plot_Reset});
    end
end

STP.reset_pb=uicontrol('style','pushbutton','units','normalized','position',[0.6 0.12 0.3 0.04],...
    'string','Reset','FontSize',14,'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_select_spike_trains_plot_Reset});

STP.cancel_pb=uicontrol('style','pushbutton','units','normalized','position',[0.15 0.04 0.3 0.04],...
    'string','Cancel','FontSize',14,'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_select_spike_trains_plot_Close});
STP.ok_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.04 0.3 0.04],...
    'string','OK','FontSize',14,'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_select_spike_trains_plot_Close},'UserData',0);

    function SPIKY_select_spike_trains_plot_ListBox_callback(varargin)

        figure(f_para.num_fig);
        lb_marked=get(STP.lb,'Value');
        lb_str=get(STP.lb,'String');
        lb_num_strings=size(lb_str,1);
        
        if gcbo==STP.top_pb
            dummy=lb_str(lb_marked,:);
            dummy2=lb_str(setdiff(1:lb_num_strings,lb_marked),:);
            lb_str(1:length(lb_marked),:)=dummy;
            lb_str(length(lb_marked)+1:lb_num_strings,:)=dummy2;            
            set(STP.lb,'Value',1:length(lb_marked))
        elseif gcbo==STP.up_pb
            for mc=1:length(lb_marked)
                if lb_marked(mc)>mc
                    dummy=lb_str(lb_marked(mc)-1,:);
                    lb_str(lb_marked(mc)-1,:)=lb_str(lb_marked(mc),:);
                    lb_str(lb_marked(mc),:)=dummy;
                    lb_marked(mc)=lb_marked(mc)-1;
                end
            end
            set(STP.lb,'Value',lb_marked)
        elseif gcbo==STP.down_pb
            for mc=length(lb_marked):-1:1
                if lb_marked(mc)<lb_num_strings-(length(lb_marked)-mc)
                    dummy=lb_str(lb_marked(mc)+1,:);
                    lb_str(lb_marked(mc)+1,:)=lb_str(lb_marked(mc),:);
                    lb_str(lb_marked(mc),:)=dummy;
                    lb_marked(mc)=lb_marked(mc)+1;
                end
            end
            set(STP.lb,'Value',lb_marked)
        elseif gcbo==STP.bottom_pb
            dummy=lb_str(lb_marked,:);
            dummy2=lb_str(setdiff(1:lb_num_strings,lb_marked),:);
            lb_str(1:lb_num_strings-length(lb_marked),:)=dummy2;
            lb_str(lb_num_strings-length(lb_marked)+1:lb_num_strings,:)=dummy;            
            set(STP.lb,'Value',lb_num_strings-length(lb_marked)+1:lb_num_strings)
        elseif gcbo==STP.delete_pb || (nargin==1 && varargin{1}==STP.delete_pb)
            for mc=length(lb_marked):-1:1
                lb_str(lb_marked(mc):lb_num_strings-1,:)=lb_str(lb_marked(mc)+1:lb_num_strings,:);
                lb_num_strings=lb_num_strings-1;
                lb_str=lb_str(1:lb_num_strings,:);
            end            
            set(STP.lb,'Value',1)
        end
        set(STP.lb,'String',lb_str)
        f_para.select_trains=str2num(lb_str);
        setappdata(handles.figure1,'figure_parameters',f_para);
    end

    function SPIKY_select_spike_trains_plot_Reset(varargin)
        if isfield(f_para,'spike_number_onset')
            f_para=rmfield(f_para,'spike_number_onset');
            f_para=rmfield(f_para,'spike_number_offset');
        end
        if isfield(f_para,'latency_onset')
            f_para=rmfield(f_para,'latency_onset');
        end
        if gcbo==STP.reset_pb
            f_para.select_trains=(1:f_para.num_all_trains)';
            set(STP.spike_number_onset_edit,'string',num2str(f_para.tmin))
            set(STP.spike_number_offset_edit,'string',num2str(f_para.tmax))
            set(STP.latency_onset_edit,'string',num2str(f_para.tmin))
        else
            if gcbo==STP.increasing_spike_number_pb || gcbo==STP.decreasing_spike_number_pb || ...
                   (f_para.num_all_train_groups>1 && (gcbo==STP.increasing_spike_number_within_pb || gcbo==STP.decreasing_spike_number_within_pb))
               onset_str_in=get(STP.spike_number_onset_edit,'String');
               onset_in=str2num(regexprep(onset_str_in,f_para.regexp_str_scalar_float,''));
               if ~isempty(onset_in)
                   onset_str_out=num2str(onset_in(1));
               else
                   onset_str_out='';
               end
               offset_str_in=get(STP.spike_number_offset_edit,'String');
               offset_in=str2num(regexprep(offset_str_in,f_para.regexp_str_scalar_float,''));
               if ~isempty(offset_in)
                   offset_str_out=num2str(offset_in(1));
               else
                   offset_str_out='';
               end
               if ~strcmp(onset_str_in,onset_str_out) || ~strcmp(offset_str_in,offset_str_out)
                   if ~isempty(onset_str_out)
                       set(STP.spike_number_onset_edit,'String',onset_str_out)
                   else
                       set(STP.spike_number_onset_edit,'String',num2str(f_para.spike_number_onset))
                   end
                   if ~isempty(offset_str_out)
                       set(STP.spike_number_offset_edit,'String',offset_str_out)
                   else
                       set(STP.spike_number_offset_edit,'String',num2str(f_para.spike_number_offset))
                   end
                   set(0,'DefaultUIControlFontSize',16);
                   mbh=msgbox('The input has been corrected !','Warning','warn','modal');
                   htxt = findobj(mbh,'Type','text');
                   set(htxt,'FontSize',12,'FontWeight','bold')
                   mb_pos=get(mbh,'Position');
                   set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.3 mb_pos(4)])
                   uiwait(mbh);
                   return
               else
                   onset=str2num(get(STP.spike_number_onset_edit,'String'));
                   offset=str2num(get(STP.spike_number_offset_edit,'String'));
               end
               if onset>=offset
                   set(0,'DefaultUIControlFontSize',16);
                   mbh=msgbox(sprintf('Onset must be smaller than offset!'),'Warning','warn','modal');
                   htxt = findobj(mbh,'Type','text');
                   set(htxt,'FontSize',12,'FontWeight','bold')
                   mb_pos=get(mbh,'Position');
                   set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                   uiwait(mbh);
                   return
               end
               if onset<f_para.tmin || offset>f_para.tmax
                   set(0,'DefaultUIControlFontSize',16);
                   mbh=msgbox(sprintf('Onset and offset must lie within the boundaries of the spike trains!'),'Warning','warn','modal');
                   htxt = findobj(mbh,'Type','text');
                   set(htxt,'FontSize',12,'FontWeight','bold')
                   mb_pos=get(mbh,'Position');
                   set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                   uiwait(mbh);
                   return
               end
               f_para.spike_number_onset=onset;
               f_para.spike_number_offset=offset;
               f_para.spike_number=cell2mat(cellfun(@(x) length(x(x>=f_para.spike_number_onset & x<=f_para.spike_number_offset)),spikes,'UniformOutput',false));               
            elseif gcbo==STP.increasing_latency_pb || gcbo==STP.decreasing_latency_pb || ...
                   (f_para.num_all_train_groups>1 && (gcbo==STP.increasing_latency_within_pb || gcbo==STP.decreasing_latency_within_pb))
               latency_onset_str_in=get(STP.latency_onset_edit,'String');
               latency_onset_in=str2num(regexprep(latency_onset_str_in,f_para.regexp_str_scalar_float,''));
               if ~isempty(latency_onset_in)
                   latency_onset_str_out=num2str(latency_onset_in(1));
               else
                   latency_onset_str_out='';
               end
               if ~strcmp(latency_onset_str_in,latency_onset_str_out)
                   if ~isempty(latency_onset_str_out)
                       set(STP.latency_onset_edit,'String',latency_onset_str_out)
                   else
                       set(STP.latency_onset_edit,'String',num2str(f_para.latency_onset))
                   end
                   set(0,'DefaultUIControlFontSize',16);
                   mbh=msgbox('The input has been corrected !','Warning','warn','modal');
                   htxt = findobj(mbh,'Type','text');
                   set(htxt,'FontSize',12,'FontWeight','bold')
                   mb_pos=get(mbh,'Position');
                   set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.3 mb_pos(4)])
                   uiwait(mbh);
                   return
               else
                   latency_onset=str2num(get(STP.latency_onset_edit,'String'));
               end
               if latency_onset<f_para.tmin || latency_onset>f_para.tmax
                   set(0,'DefaultUIControlFontSize',16);
                   mbh=msgbox(sprintf('The onset must lie within the boundaries of the spike trains!'),'Warning','warn','modal');
                   htxt = findobj(mbh,'Type','text');
                   set(htxt,'FontSize',12,'FontWeight','bold')
                   mb_pos=get(mbh,'Position');
                   set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                   uiwait(mbh);
                   return
               end
               f_para.latency_onset=latency_onset;
               f_para.latency=zeros(1,f_para.num_all_trains);
               ok=cell2mat(cellfun(@(x) ~isempty(x(x>f_para.latency_onset)),spikes,'UniformOutput',false));
               f_para.latency(logical(ok))=cell2mat(cellfun(@(x) min(x(x>f_para.latency_onset)-f_para.latency_onset),spikes(ok),'UniformOutput',false));
               f_para.latency(setdiff(1:f_para.num_all_trains,find(ok)))=inf;
            end
            if gcbo==STP.increasing_spike_number_pb || gcbo==STP.decreasing_spike_number_pb || ...
                   gcbo==STP.increasing_latency_pb || gcbo==STP.decreasing_latency_pb 
                dummy=sort(f_para.select_trains);
                if gcbo==STP.increasing_spike_number_pb
                    [vals,indy]=sort(f_para.spike_number(dummy),'ascend');
                elseif gcbo==STP.decreasing_spike_number_pb
                    [vals,indy]=sort(f_para.spike_number(dummy),'descend');
                elseif gcbo==STP.increasing_latency_pb
                    [vals,indy]=sort(f_para.latency(dummy),'ascend');
                elseif gcbo==STP.decreasing_latency_pb
                    [vals,indy]=sort(f_para.latency(dummy),'descend');
                end
                f_para.select_trains=dummy(indy);
            elseif f_para.num_all_train_groups>1 && (gcbo==STP.increasing_spike_number_within_pb || gcbo==STP.decreasing_spike_number_within_pb || ...
                    gcbo==STP.increasing_latency_within_pb || gcbo==STP.decreasing_latency_within_pb)
                indy=zeros(1,length(f_para.select_trains));
                gc=0;
                for grc=1:f_para.num_all_train_groups
                    grummy=sort(f_para.select_trains(f_para.group_vect(f_para.select_trains)==grc));
                    if gcbo==STP.increasing_spike_number_within_pb
                        [vals,grindy]=sort(f_para.spike_number(grummy),'ascend');
                    elseif gcbo==STP.decreasing_spike_number_within_pb
                        [vals,grindy]=sort(f_para.spike_number(grummy),'descend');
                    elseif gcbo==STP.increasing_latency_within_pb
                        [vals,grindy]=sort(f_para.latency(grummy),'ascend');
                    elseif gcbo==STP.decreasing_latency_within_pb
                        [vals,grindy]=sort(f_para.latency(grummy),'descend');
                    end
                    indy(gc+(1:length(grummy)))=gc+grindy;
                    gc=gc+length(grummy);
                end
                dummy=sort(f_para.select_trains);
                f_para.select_trains=dummy(indy);
            elseif isfield(f_para,'dendro_order') && (gcbo==STP.decreasing_dendro_order_pb || gcbo==STP.increasing_dendro_order_pb)
                dummy=sort(f_para.select_trains);
                if h_para.num_measures>1
                    indy=get(STP.cluster_lb,'Value');
                else
                    indy=1;
                end
                if gcbo==STP.decreasing_dendro_order_pb
                    f_para.select_trains=dummy(f_para.dendro_order{indy});
                else
                    f_para.select_trains=dummy(f_para.dendro_order{indy}(end:-1:1));
                end
            end
        end
        set(STP.lb,'string',num2str(f_para.select_trains))
        set(STP.lb,'Value',1)
    end

    function STP_keyboard(varargin)
        if strcmp(varargin{2}.Key,'delete')
            SPIKY_select_spike_trains_plot_ListBox_callback(STP.delete_pb);
        end
    end

    function SPIKY_select_spike_trains_plot_Close(varargin)
        if (gcbo==STP.cancel_pb || gcbo==STP.fig) && get(STP.ok_pb,'UserData')==0
            f_para.select_trains=1:f_para.num_all_trains;
        elseif gcbo==STP.ok_pb
            f_para.select_trains=str2num(get(STP.lb,'String'))';
            set(STP.ok_pb,'UserData',1)
        end
        set(handles.fpara_trains_edit,'String',regexprep(num2str(f_para.select_trains),'\s+',' '))
        setappdata(handles.figure1,'figure_parameters',f_para);
        delete(gcbf)
    end
end
