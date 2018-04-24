% This function provides an input mask for the selection and sorting of your input spike trains before the calculation
% of the dissimilarity measures. You can select/eliminate spike trains and change their order manually via the buttons
% at the top but you can also sort the spike trains according to some predefined criteria (such as number of spikes and latency).

function SPIKY_select_spike_trains_calc(hObject, eventdata, handles)

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
if size(d_para.preselect_trains,2)>size(d_para.preselect_trains,1)
    d_para.preselect_trains=d_para.preselect_trains';
end
d_para.spike_number_onset=d_para.tmin;
d_para.spike_number_offset=d_para.tmax;
d_para.latency_onset=d_para.tmin;


STC.fig=figure('units','normalized','menubar','none','position',[0.05 0.07 0.4 0.86],'Name','Spike train selection and sorting',...
    'NumberTitle','off','Color',[0.9294 0.9176 0.851],'KeyPressFcn',{@STC_keyboard},'DeleteFcn',{@SPIKY_select_spike_trains_calc_Close},...
    'WindowStyle','modal');

STC.lb=uicontrol('style','listbox','units','normalized','position',[0.1 0.12 0.4 0.84],'FontSize',10,...
    'BackgroundColor','w','string',num2str(d_para.preselect_trains),'Min',1,'Max',d_para.num_all_trains,...
    'HorizontalAlignment','center','Value',1,'KeyPressFcn',{@STC_keyboard});

STC.top_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.92 0.2 0.035],...
    'string','Top','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_calc_ListBox_callback});
STC.up_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.865 0.2 0.035],...
    'string','Up','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_calc_ListBox_callback});
STC.down_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.82 0.2 0.035],...
    'string','Down','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_calc_ListBox_callback});
STC.bottom_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.765 0.2 0.035],...
    'string','Bottom','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_calc_ListBox_callback});
STC.delete_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.7 0.2 0.035],...
    'string','Delete','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_calc_ListBox_callback});

STC.sn_panel=uipanel('units','normalized','position',[0.52 0.42 0.46 0.22],'title','Spike number:','FontSize',14,'parent',STC.fig);
uicontrol('style','text','units','normalized','position',[0.55 0.575 0.07 0.03],'HorizontalAlignment','left',...
    'string','Onset:','FontSize',13,'FontUnits','normalized');
STC.spike_number_onset_edit=uicontrol('style','edit','units','normalized','position',[0.63 0.58 0.11 0.025],'BackgroundColor','w',...
    'string',num2str(d_para.tmin),'FontSize',13,'FontUnits','normalized');
uicontrol('style','text','units','normalized','position',[0.755 0.575 0.07 0.03],'HorizontalAlignment','left',...
    'string','Offset:','FontSize',13,'FontUnits','normalized');
STC.spike_number_offset_edit=uicontrol('style','edit','units','normalized','position',[0.83 0.58 0.11 0.025],'BackgroundColor','w',...
    'string',num2str(d_para.tmax),'FontSize',13,'FontUnits','normalized');
uicontrol('style','text','units','normalized','position',[0.565 0.54 0.1 0.03],'HorizontalAlignment','left',...
    'string','All:','FontSize',13,'FontWeight','bold','FontUnits','normalized');
STC.decreasing_spike_number_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.51 0.18 0.03],...
    'string','Decreasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_calc_Reset});
STC.increasing_spike_number_pb=uicontrol('style','pushbutton','units','normalized','position',[0.77 0.51 0.18 0.03],...
    'string','Increasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_calc_Reset});

STC.lat_panel=uipanel('units','normalized','position',[0.52 0.21 0.46 0.2],'title','Latency:','FontSize',14,'parent',STC.fig);
uicontrol('style','text','units','normalized','position',[0.65 0.35 0.07 0.03],'HorizontalAlignment','left',...
    'string','Onset:','FontSize',13,'FontUnits','normalized');
STC.latency_onset_edit=uicontrol('style','edit','units','normalized','position',[0.73 0.355 0.12 0.025],'BackgroundColor','w',...
    'string',num2str(d_para.tmin),'FontSize',13,'FontUnits','normalized');
uicontrol('style','text','units','normalized','position',[0.565 0.33 0.1 0.03],'HorizontalAlignment','left',...
    'string','All:','FontSize',13,'FontWeight','bold','FontUnits','normalized');
STC.decreasing_latency_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.3 0.18 0.03],...
    'string','Decreasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_calc_Reset});
STC.increasing_latency_pb=uicontrol('style','pushbutton','units','normalized','position',[0.77 0.3 0.18 0.03],...
    'string','Increasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spike_trains_calc_Reset});

if d_para.num_all_train_groups>1
    uicontrol('style','text','units','normalized','position',[0.565 0.47 0.15 0.03],'HorizontalAlignment','left',...
        'string','Within group:','FontSize',13,'FontWeight','bold','FontUnits','normalized');
    STC.decreasing_spike_number_within_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.44 0.18 0.03],...
        'string','Decreasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_trains_calc_Reset});
    STC.increasing_spike_number_within_pb=uicontrol('style','pushbutton','units','normalized','position',[0.77 0.44 0.18 0.03],...
        'string','Increasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_trains_calc_Reset});
    uicontrol('style','text','units','normalized','position',[0.565 0.26 0.15 0.03],'HorizontalAlignment','left',...
        'string','Within group:','FontSize',13,'FontWeight','bold','FontUnits','normalized');
    STC.decreasing_latency_within_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.23 0.18 0.03],...
        'string','Decreasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_trains_calc_Reset});
    STC.increasing_latency_within_pb=uicontrol('style','pushbutton','units','normalized','position',[0.77 0.23 0.18 0.03],...
        'string','Increasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
        'CallBack',{@SPIKY_select_spike_trains_calc_Reset});
end

STC.reset_pb=uicontrol('style','pushbutton','units','normalized','position',[0.6 0.12 0.3 0.04],...
    'string','Reset','FontSize',14,'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_select_spike_trains_calc_Reset});

STC.cancel_pb=uicontrol('style','pushbutton','units','normalized','position',[0.15 0.04 0.3 0.04],...
    'string','Cancel','FontSize',14,'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_select_spike_trains_calc_Close});
STC.ok_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.04 0.3 0.04],...
    'string','OK','FontSize',14,'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_select_spike_trains_calc_Close},'UserData',0);

figure(f_para.num_fig);
cm=colormap;
dcol_indy=round(1:63/(d_para.num_trains-1):64);
dcols=cm(dcol_indy,:);

if d_para.num_all_train_groups>1
    dcol_indy2=round(1:63/(d_para.num_all_train_groups-1):64);
    dcols2=cm(dcol_indy2,:);
end
d_para.dcols=cm(dcol_indy,:);
colpat_ph=zeros(d_para.num_trains,2);
for trac=1:d_para.num_trains
    colpat_ph(trac,1)=patch([d_para.tmin d_para.tmin-0.01*(d_para.tmax-d_para.tmin)*ones(1,2) d_para.tmin],(1.05-(trac-1+[0 0 1 1])/d_para.num_trains),...
        dcols(trac,:),'EdgeColor',dcols(trac,:));
    if d_para.num_all_train_groups>1
        colpat_ph(trac,2)=patch([d_para.tmax d_para.tmax+0.01*(d_para.tmax-d_para.tmin)*ones(1,2) d_para.tmax],(1.05-(trac-1+[0 0 1 1])/d_para.num_trains),...
            dcols2(d_para.group_vect(d_para.preselect_trains(trac)),:),'EdgeColor',dcols2(d_para.group_vect(d_para.preselect_trains(trac)),:));
    else
        colpat_ph(trac,2)=patch([d_para.tmax d_para.tmax+0.01*(d_para.tmax-d_para.tmin)*ones(1,2) d_para.tmax],(1.05-(trac-1+[0 0 1 1])/d_para.num_trains),...
            dcols(trac,:),'EdgeColor',dcols(trac,:));
    end
end

    function SPIKY_select_spike_trains_calc_ListBox_callback(varargin)       
        if isfield(d_para,'spike_number_onset_lh')
            delete(d_para.spike_number_onset_lh)
        end
        if isfield(d_para,'spike_number_offset_lh')
            delete(d_para.spike_number_offset_lh)
        end
        if isfield(d_para,'latency_onset_lh')
            delete(d_para.latency_onset_lh)
        end
        figure(f_para.num_fig);
        lb_marked=get(STC.lb,'Value');
        lb_str=get(STC.lb,'String');
        lb_num_strings=size(lb_str,1);
        
        if gcbo==STC.top_pb %|| (nargin==1 && varargin{1}==STC.top_pb)
            dummy=lb_str(lb_marked,:);
            dummy2=lb_str(setdiff(1:lb_num_strings,lb_marked),:);
            lb_str(1:length(lb_marked),:)=dummy;
            lb_str(length(lb_marked)+1:lb_num_strings,:)=dummy2;            
            set(STC.lb,'Value',1:length(lb_marked))
        elseif gcbo==STC.up_pb %|| (nargin==1 && varargin{1}==STC.up_pb)
            for mc=1:length(lb_marked)
                if lb_marked(mc)>mc
                    dummy=lb_str(lb_marked(mc)-1,:);
                    lb_str(lb_marked(mc)-1,:)=lb_str(lb_marked(mc),:);
                    lb_str(lb_marked(mc),:)=dummy;
                    lb_marked(mc)=lb_marked(mc)-1;
                end
            end
            set(STC.lb,'Value',lb_marked)
        elseif gcbo==STC.down_pb %|| (nargin==1 && varargin{1}==STC.down_pb)
            for mc=length(lb_marked):-1:1   
                if lb_marked(mc)<lb_num_strings-(length(lb_marked)-mc)
                    dummy=lb_str(lb_marked(mc)+1,:);
                    lb_str(lb_marked(mc)+1,:)=lb_str(lb_marked(mc),:);
                    lb_str(lb_marked(mc),:)=dummy;
                    lb_marked(mc)=lb_marked(mc)+1;
                end
            end
            set(STC.lb,'Value',lb_marked)
        elseif gcbo==STC.bottom_pb %|| (nargin==1 && varargin{1}==STC.bottom_pb)
            dummy=lb_str(lb_marked,:);
            dummy2=lb_str(setdiff(1:lb_num_strings,lb_marked),:);
            lb_str(1:lb_num_strings-length(lb_marked),:)=dummy2;
            lb_str(lb_num_strings-length(lb_marked)+1:lb_num_strings,:)=dummy;            
            set(STC.lb,'Value',lb_num_strings-length(lb_marked)+1:lb_num_strings)
        elseif gcbo==STC.delete_pb || (nargin==1 && varargin{1}==STC.delete_pb)
            for mc=length(lb_marked):-1:1
                lb_str(lb_marked(mc):lb_num_strings-1,:)=lb_str(lb_marked(mc)+1:lb_num_strings,:);
                lb_num_strings=lb_num_strings-1;
                lb_str=lb_str(1:lb_num_strings,:);
            end            
            set(STC.lb,'Value',1)
        end
        set(STC.lb,'String',lb_str)
        d_para.preselect_trains=str2num(lb_str);
        setappdata(handles.figure1,'data_parameters',d_para);
        SPIKY_plot_select_spikes
    end

    function SPIKY_select_spike_trains_calc_Reset(varargin)
        if isfield(d_para,'spike_number_onset')
            d_para=rmfield(d_para,'spike_number_onset');
            d_para=rmfield(d_para,'spike_number_offset');
        end
        if isfield(d_para,'latency_onset')
            d_para=rmfield(d_para,'latency_onset');
        end
        if gcbo==STC.reset_pb
            d_para.preselect_trains=(1:d_para.num_all_trains)';
            set(STC.spike_number_onset_edit,'string',num2str(d_para.tmin))
            set(STC.spike_number_offset_edit,'string',num2str(d_para.tmax))
            set(STC.latency_onset_edit,'string',num2str(d_para.tmin))
        else
            if gcbo==STC.increasing_spike_number_pb || gcbo==STC.decreasing_spike_number_pb || ...
                   (d_para.num_all_train_groups>1 && (gcbo==STC.increasing_spike_number_within_pb || gcbo==STC.decreasing_spike_number_within_pb))
               onset_str_in=get(STC.spike_number_onset_edit,'String');
               onset_in=str2num(regexprep(onset_str_in,f_para.regexp_str_scalar_float,''));
               if ~isempty(onset_in)
                   onset_str_out=num2str(onset_in(1));
               else
                   onset_str_out='';
               end
               offset_str_in=get(STC.spike_number_offset_edit,'String');
               offset_in=str2num(regexprep(offset_str_in,f_para.regexp_str_scalar_float,''));
               if ~isempty(offset_in)
                   offset_str_out=num2str(offset_in(1));
               else
                   offset_str_out='';
               end
               if ~strcmp(onset_str_in,onset_str_out) || ~strcmp(offset_str_in,offset_str_out)
                   if ~isempty(onset_str_out)
                       set(STC.spike_number_onset_edit,'String',onset_str_out)
                   else
                       set(STC.spike_number_onset_edit,'String',num2str(d_para.spike_number_onset))
                   end
                   if ~isempty(offset_str_out)
                       set(STC.spike_number_offset_edit,'String',offset_str_out)
                   else
                       set(STC.spike_number_offset_edit,'String',num2str(d_para.spike_number_offset))
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
                   onset=str2num(get(STC.spike_number_onset_edit,'String'));
                   offset=str2num(get(STC.spike_number_offset_edit,'String'));
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
               if onset<d_para.tmin || offset>d_para.tmax
                   set(0,'DefaultUIControlFontSize',16);
                   mbh=msgbox(sprintf('Onset and offset must lie within the boundaries of the spike trains!'),'Warning','warn','modal');
                   htxt = findobj(mbh,'Type','text');
                   set(htxt,'FontSize',12,'FontWeight','bold')
                   mb_pos=get(mbh,'Position');
                   set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                   uiwait(mbh);
                   return
               end
               d_para.spike_number_onset=onset;
               d_para.spike_number_offset=offset;
               d_para.spike_number=cell2mat(cellfun(@(x) length(x(x>=d_para.spike_number_onset & x<=d_para.spike_number_offset)),allspikes,'UniformOutput',false));               
            elseif gcbo==STC.increasing_latency_pb || gcbo==STC.decreasing_latency_pb || ...
                   (d_para.num_all_train_groups>1 && (gcbo==STC.increasing_latency_within_pb || gcbo==STC.decreasing_latency_within_pb))
               latency_onset_str_in=get(STC.latency_onset_edit,'String');
               latency_onset_in=str2num(regexprep(latency_onset_str_in,f_para.regexp_str_scalar_float,''));
               if ~isempty(latency_onset_in)
                   latency_onset_str_out=num2str(latency_onset_in(1));
               else
                   latency_onset_str_out='';
               end
               if ~strcmp(latency_onset_str_in,latency_onset_str_out)
                   if ~isempty(latency_onset_str_out)
                       set(STC.latency_onset_edit,'String',latency_onset_str_out)
                   else
                       set(STC.latency_onset_edit,'String',num2str(d_para.latency_onset))
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
                   latency_onset=str2num(get(STC.latency_onset_edit,'String'));
               end
               if latency_onset<d_para.tmin || latency_onset>d_para.tmax
                   set(0,'DefaultUIControlFontSize',16);
                   mbh=msgbox(sprintf('The onset must lie within the boundaries of the spike trains!'),'Warning','warn','modal');
                   htxt = findobj(mbh,'Type','text');
                   set(htxt,'FontSize',12,'FontWeight','bold')
                   mb_pos=get(mbh,'Position');
                   set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                   uiwait(mbh);
                   return
               end
               d_para.latency_onset=latency_onset;
               d_para.latency=zeros(1,d_para.num_all_trains);
               ok=cell2mat(cellfun(@(x) ~isempty(x(x>d_para.latency_onset)),allspikes,'UniformOutput',false));
               d_para.latency(logical(ok))=cell2mat(cellfun(@(x) min(x(x>d_para.latency_onset)-d_para.latency_onset),allspikes(ok),'UniformOutput',false));
               d_para.latency(setdiff(1:d_para.num_all_trains,find(ok)))=inf;
            end
            if gcbo==STC.increasing_spike_number_pb || gcbo==STC.decreasing_spike_number_pb || ...
                   gcbo==STC.increasing_latency_pb || gcbo==STC.decreasing_latency_pb 
                dummy=sort(d_para.preselect_trains);
                if gcbo==STC.increasing_spike_number_pb
                    [vals,indy]=sort(d_para.spike_number(dummy),'ascend');
                elseif gcbo==STC.decreasing_spike_number_pb
                    [vals,indy]=sort(d_para.spike_number(dummy),'descend');
                elseif gcbo==STC.increasing_latency_pb
                    [vals,indy]=sort(d_para.latency(dummy),'ascend');
                elseif gcbo==STC.decreasing_latency_pb
                    [vals,indy]=sort(d_para.latency(dummy),'descend');
                end
                d_para.preselect_trains=dummy(indy);
            elseif d_para.num_all_train_groups>1 && (gcbo==STC.increasing_spike_number_within_pb || gcbo==STC.decreasing_spike_number_within_pb || ...
                    gcbo==STC.increasing_latency_within_pb || gcbo==STC.decreasing_latency_within_pb)
                indy=zeros(1,length(d_para.preselect_trains));
                gc=0;
                for grc=1:d_para.num_all_train_groups
                    grummy=sort(d_para.preselect_trains(d_para.group_vect(d_para.preselect_trains)==grc));
                    if gcbo==STC.increasing_spike_number_within_pb
                        [vals,grindy]=sort(d_para.spike_number(grummy),'ascend');
                    elseif gcbo==STC.decreasing_spike_number_within_pb
                        [vals,grindy]=sort(d_para.spike_number(grummy),'descend');
                    elseif gcbo==STC.increasing_latency_within_pb
                        [vals,grindy]=sort(d_para.latency(grummy),'ascend');
                    elseif gcbo==STC.decreasing_latency_within_pb
                        [vals,grindy]=sort(d_para.latency(grummy),'descend');
                    end
                    indy(gc+(1:length(grummy)))=gc+grindy;
                    gc=gc+length(grummy);
                end
                dummy=sort(d_para.preselect_trains);
                d_para.preselect_trains=dummy(indy);
            end
        end
        set(STC.lb,'string',num2str(d_para.preselect_trains))
        set(STC.lb,'Value',1)
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

        d_para.num_trains=length(d_para.preselect_trains);
        d_para.num_allspikes=zeros(1,d_para.num_trains);
        pspikes=cell(1,d_para.num_trains);
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
        
        if gcbo==STC.increasing_spike_number_pb || gcbo==STC.decreasing_spike_number_pb || ...
                (d_para.num_all_train_groups>1 && (gcbo==STC.increasing_spike_number_within_pb || gcbo==STC.decreasing_spike_number_within_pb))
            d_para.spike_number_onset_lh=line(d_para.spike_number_onset*ones(1,2),yl,'Color',p_para.onset_col,'LineStyle',p_para.onset_ls,'LineWidth',p_para.onset_lw);
            d_para.spike_number_offset_lh=line(d_para.spike_number_offset*ones(1,2),yl,'Color',p_para.onset_col,'LineStyle',p_para.onset_ls,'LineWidth',p_para.onset_lw);
        else
            if isfield(d_para,'spike_number_onset_lh')
                d_para=rmfield(d_para,'spike_number_onset_lh');
            end
            if isfield(d_para,'spike_number_offset_lh')
                d_para=rmfield(d_para,'spike_number_offset_lh');
            end
        end
        if gcbo==STC.increasing_latency_pb || gcbo==STC.decreasing_latency_pb || ...
                (d_para.num_all_train_groups>1 && (gcbo==STC.increasing_latency_within_pb || gcbo==STC.decreasing_latency_within_pb))
            d_para.latency_onset_lh=line(d_para.latency_onset*ones(1,2),yl,'Color',p_para.onset_col,'LineStyle',p_para.onset_ls,'LineWidth',p_para.onset_lw);
        else
            if isfield(d_para,'latency_onset_lh')
                d_para=rmfield(d_para,'latency_onset_lh');
            end
        end

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
        dcol_indy=round(1:63/(d_para.num_all_trains-1):64);
        dcols=cm(dcol_indy,:);
        if d_para.num_all_train_groups>1
            dcol_indy2=round(1:63/(d_para.num_all_train_groups-1):64);
            dcols2=cm(dcol_indy2,:);
        end
        d_para.dcols=cm(dcol_indy,:);
        colpat_ph=zeros(d_para.num_trains,2);
        for tracc=1:d_para.num_trains
            colpat_ph(tracc,1)=patch([d_para.tmin d_para.tmin-0.01*(d_para.tmax-d_para.tmin)*ones(1,2) d_para.tmin],(1.05-(tracc-1+[0 0 1 1])/d_para.num_trains),...
                dcols(d_para.preselect_trains(tracc),:),'EdgeColor',dcols(d_para.preselect_trains(tracc),:));
            if d_para.num_all_train_groups>1
                colpat_ph(tracc,2)=patch([d_para.tmax d_para.tmax+0.01*(d_para.tmax-d_para.tmin)*ones(1,2) d_para.tmax],(1.05-(tracc-1+[0 0 1 1])/d_para.num_trains),...
                    dcols2(d_para.group_vect(d_para.preselect_trains(tracc)),:),'EdgeColor',dcols2(d_para.group_vect(d_para.preselect_trains(tracc)),:));
            else
                colpat_ph(tracc,2)=patch([d_para.tmax d_para.tmax+0.01*(d_para.tmax-d_para.tmin)*ones(1,2) d_para.tmax],(1.05-(tracc-1+[0 0 1 1])/d_para.num_trains),...
                    dcols(d_para.preselect_trains(tracc),:),'EdgeColor',dcols(d_para.preselect_trains(tracc),:));
            end
        end
    end

    function STC_keyboard(varargin)
        if strcmp(varargin{2}.Key,'delete')
            SPIKY_select_spike_trains_calc_ListBox_callback(STC.delete_pb);
        %elseif strcmp(varargin{2}.Key,'pageup')
        %    SPIKY_select_spike_trains_calc_ListBox_callback(STC.top_pb);
        %elseif strcmp(varargin{2}.Key,'uparrow')
        %    SPIKY_select_spike_trains_calc_ListBox_callback(STC.up_pb);
        %elseif strcmp(varargin{2}.Key,'downarrow')
        %    SPIKY_select_spike_trains_calc_ListBox_callback(STC.down_pb);
        %elseif strcmp(varargin{2}.Key,'pagedown')
        %    SPIKY_select_spike_trains_calc_ListBox_callback(STC.bottom_pb);
        end
    end

    function SPIKY_select_spike_trains_calc_Close(varargin)
        if (gcbo==STC.cancel_pb || gcbo==STC.fig) && get(STC.ok_pb,'UserData')==0
            d_para.preselect_trains=1:d_para.num_all_trains;
            SPIKY_plot_select_spikes
        elseif gcbo==STC.ok_pb
            d_para.preselect_trains=str2num(get(STC.lb,'String'))';
            SPIKY_plot_select_spikes
            set(STC.ok_pb,'UserData',1)
        end
        if gcbo==STC.ok_pb || ((gcbo==STC.cancel_pb || gcbo==STC.fig) && get(STC.ok_pb,'UserData')==0)
            if exist('colpat_ph','var')
                delete(colpat_ph)
                clear colpat_ph
            end
            if isfield(d_para,'spike_number_onset_lh')
                delete(d_para.spike_number_onset_lh)
                d_para=rmfield(d_para,'spike_number_onset_lh');
            end
            if isfield(d_para,'spike_number_offset_lh')
                delete(d_para.spike_number_offset_lh)
                d_para=rmfield(d_para,'spike_number_offset_lh');
            end
            if isfield(d_para,'latency_onset_lh')
                delete(d_para.latency_onset_lh)
                d_para=rmfield(d_para,'latency_onset_lh');
            end
        end
        set(handles.dpara_trains_edit,'String',regexprep(num2str(d_para.preselect_trains),'\s+',' '))
        setappdata(handles.figure1,'data_parameters',d_para);
        delete(gcbf)
    end
end
