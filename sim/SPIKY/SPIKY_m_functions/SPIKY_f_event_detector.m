% This function provides an input mask for detecting discrete events in continuous data. The resulting events are then used as spike input in SPIKY.

function SPIKY_f_event_detector(hObject, eventdata, handles)

set(handles.figure1,'Visible','off')

d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
%e_para=getappdata(handles.figure1,'event_parameters');

% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% @@@@@@@@@@@@ here you should initialize your parameters @@@@@@@@@
% @@@@@@@@@@@@ (set standard values, just add parameters) @@@@@@@@@
% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

e_para=struct('event_type',2,'movave',0,'movave_order',3,'max_window',2,'max_elevation',0.01,'min_window',2,'min_elevation',0.01,...
    'event_plot',1,'event_symbol','x','event_color','r','event_linewidth',1,'event_marker_size',12,'event_precol',1,'event_postcol',1,...
    'crossthreshold',0,'tc_upwards',1,...
    'smin',1,'smax',30000,'channels',[],'downsampling',1,'normalize',1,'yscale',1,...
    'xhisto_all_trials',1,'num_trials',2,'xhisto_equi_custom',10,'xhisto_num_bins',10,'xhisto_edges',[256 2.5*256 4*256 5.5*256 7*256 8.5*256 10*256],'xhisto_grand_average',1,...
    'threshold',0.8, 'type',1, 'MC',[10 11 14 15 16 19 20], 'nonMC',[1:9 12 13 17 18 21:30]);

% Structure with event parameters:
% 
% event_type: 1-Minima,2-Maxima,3-threshold crossings
% moveave: Moving average (smoothing) of continuous data before event detection (0-no,1-yes)
% movave_order: Order of this moving average
% max_window: for event_type=1 temporal duration of maximum, 1: /\, 2: //\\, 3: ///\\\, etc.
% max_elevation: for event_type=1 amplitude height of maximum
% min_window: for event_type=1 temporal duration of minimum, 1: \/, 2: \\//, 3: \\\///, etc.
% min_elevation: for event_type=1 amplitude height of minimum
% event_plot: how to mark events (1:put vertical line (spike),2:put symbol,3-mark part of signal (needs additional parameters about extent of event))
% event_symbol: symbol of events (xodv...)
% event_color: color of events
% event_linewidth: line width of events
% event_marker_size: marker size of events
% event_precol/event_postcol: extension of event marking before and after the event (only for event_plot=3)

% smin/smax: first and last sample of continuous data
% channels: selection of channels for event detection
% downsampling: downsampling factor
% normalize: normalize continuous data to zero mean and unit variance (0-no,1-yes)
% yscale: scale factor for the y-axis (amplitudes) used when plotting the continuous data

% xhisto_equi_custom: 
% xhisto_all_trials: 

% threshold = 5 
% type = 0 (fixed)
EVD_fig=figure('units','normalized','menubar','none','position',[0.01 0.07 0.48 0.86],'Name','Event detector',...
    'NumberTitle','off','Color',[0.9294 0.9176 0.851],'DeleteFcn',{@EVD_close_callback}); % ,'WindowStyle','modal'

EVD_fm= uimenu('Label','Data');
uimenu(EVD_fm,'Label','Reset','Callback','EVD_reset');
uimenu(EVD_fm,'Label','Load file','Callback',{@EVD_open_mat_file});
uimenu(EVD_fm,'Label','Load from workspace','Callback',{@EVD_workspace_callback});
uimenu(EVD_fm,'Label','Quit','Callback','EVD_close_callback','Separator','on','Accelerator','Q');


set(EVD_fig,'Toolbar','figure');
tbh=findall(EVD_fig,'Type','uitoolbar');
upt=findall(EVD_fig,'Type','uipushtool');
delete(upt(1:4))
delete(findall(EVD_fig,'Type','uitoggletool'))
delete(findall(EVD_fig,'Type','uitogglesplittool'))
upt=findall(EVD_fig,'Type','uipushtool');
set(upt(1),'ClickedCallback',{@EVD_open_mat_file})
set(upt(2),'ClickedCallback',{@EVD_reset})
uipushtool(tbh,'cdata',get(upt(1),'cdata'), 'tooltip','Load from workspace','ClickedCallback',{@EVD_workspace_callback});

EVD_Data_panel=uipanel('units','normalized','position',[0.03 0.76 0.94 0.23],'Title','Continuous data','FontSize',15,'FontWeight','bold');
uicontrol('style','text','units','normalized','position',[0.04 0.75 0.16 0.15],'string','First sample:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','FontUnits','normalized','parent',EVD_Data_panel);
EVD_smin_edit=uicontrol('style','edit','units','normalized','position',[0.21 0.77 0.17 0.17],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_Data_panel,'String',num2str(e_para.smin));
uicontrol('style','text','units','normalized','position',[0.42 0.75 0.16 0.15],'string','Last sample:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','FontUnits','normalized','parent',EVD_Data_panel);
EVD_smax_edit=uicontrol('style','edit','units','normalized','position',[0.6 0.77 0.17 0.17],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_Data_panel);
uicontrol('style','text','units','normalized','position',[0.04 0.54 0.16 0.15],'string','Downsampling:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','FontUnits','normalized','parent',EVD_Data_panel);
EVD_downsampling_edit=uicontrol('style','edit','units','normalized','position',[0.21 0.56 0.17 0.17],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_Data_panel,'String',num2str(e_para.downsampling));
uicontrol('style','text','units','normalized','position',[0.42 0.54 0.2 0.15],'string','Amplitude scale:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','FontUnits','normalized','parent',EVD_Data_panel);
EVD_yscale_edit=uicontrol('style','edit','units','normalized','position',[0.6 0.56 0.17 0.17],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_Data_panel,'String',num2str(e_para.yscale));
EVD_normalize_checkbox=uicontrol('style','checkbox','units','normalized','position',[0.82 0.725 0.18 0.1],'string','Normalize',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','parent',EVD_Data_panel,'Value',e_para.normalize);
uicontrol('style','text','units','normalized','position',[0.04 0.31 0.16 0.15],'string','Channels:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','FontUnits','normalized','parent',EVD_Data_panel);
EVD_channels_edit=uicontrol('style','edit','units','normalized','position',[0.21 0.33 0.77 0.17],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_Data_panel);
EVD_Data_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.1 0.08 0.2 0.17],'string','Cancel',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'parent',EVD_Data_panel,'CallBack',{@EVD_close_callback});
EVD_Data_Update_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.4 0.08 0.2 0.17],'string','Update','Enable','off',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'parent',EVD_Data_panel,'CallBack',{@EVD_data_update_callback});
EVD_Data_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.7 0.08 0.2 0.17],'string','OK','Enable','off',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'parent',EVD_Data_panel,'CallBack',{@EVD_data_ok_callback});


EVD_events_panel=uipanel('units','normalized','position',[0.03 0.1 0.94 0.65],'Title','Event detector','FontSize',15,'FontWeight','bold','Visible','off');

EVD_Eventtype_uibg=uibuttongroup('units','normalized','position',[0.02 0.12 0.46 0.86],'Title','Events','FontSize',15,...
    'FontWeight','bold','SelectionChangeFcn',{@EVD_eventtype_rb_callback},'parent',EVD_events_panel);
EVD_min_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.06 0.93 0.4 0.06],'string','Minima',...
    'FontSize',15,'FontUnits','normalized','parent',EVD_Eventtype_uibg,'BackgroundColor',[0.8353 0.8235 0.7922],'Value',e_para.event_type==1);
EVD_max_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.5 0.93 0.4 0.06],'string','Maxima',...
    'FontSize',15,'FontUnits','normalized','parent',EVD_Eventtype_uibg,'BackgroundColor',[0.8353 0.8235 0.7922],'Value',e_para.event_type==2);
EVD_crossing_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.06 0.85 0.8 0.06],'string','Threshold crossing',...
    'FontSize',15,'FontUnits','normalized','parent',EVD_Eventtype_uibg,'BackgroundColor',[0.8353 0.8235 0.7922],'Value',e_para.event_type==3);



EVD_Eventplot_uibg=uibuttongroup('units','normalized','position',[0.03 0.5 0.94 0.3],'Title','How to plot events','FontSize',15,...
    'FontWeight','bold','SelectionChangeFcn',{@EVD_eventtype_rb_callback},'parent',EVD_Eventtype_uibg);
EVD_spikes_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.05 0.7 0.4 0.2],'string','Spikes',...
    'FontSize',15,'FontUnits','normalized','parent',EVD_Eventplot_uibg,'BackgroundColor',[0.8353 0.8235 0.7922],'Value',e_para.event_plot==1);
EVD_symbol_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.05 0.4 0.4 0.2],'string','Symbols',...
    'FontSize',15,'FontUnits','normalized','parent',EVD_Eventplot_uibg,'BackgroundColor',[0.8353 0.8235 0.7922],'Value',e_para.event_plot==2);
EVD_signal_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.05 0.1 0.4 0.2],'string','Data',...
    'FontSize',15,'FontUnits','normalized','parent',EVD_Eventplot_uibg,'BackgroundColor',[0.8353 0.8235 0.7922],'Value',e_para.event_plot==3);
uicontrol('style','text','units','normalized','position',[0.48 0.53 0.4 0.3],'string','Color:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','FontUnits','normalized','parent',EVD_Eventplot_uibg);
EVD_event_color_edit=uicontrol('style','edit','units','normalized','position',[0.78 0.55 0.17 0.3],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_Eventplot_uibg,'String',e_para.event_color);
uicontrol('style','text','units','normalized','position',[0.48 0.15 0.4 0.3],'string','Line width:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','FontUnits','normalized','parent',EVD_Eventplot_uibg);
EVD_event_linewidth_edit=uicontrol('style','edit','units','normalized','position',[0.78 0.17 0.17 0.3],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_Eventplot_uibg,'String',num2str(e_para.event_linewidth));

EVD_Histo_panel=uipanel('units','normalized','position',[0.03 0.02 0.94 0.46],'Title','X-Histogram','FontSize',15,'FontWeight','bold',...
    'parent',EVD_Eventtype_uibg);
EVD_all_trials_uibg=uibuttongroup('units','normalized','position',[0.03 0.75 0.94 0.22],'FontSize',15,...
    'FontWeight','bold','SelectionChangeFcn',{@EVD_all_trials_rb_callback},'parent',EVD_Histo_panel);
EVD_all_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.05 0.2 0.4 0.6],'string','All',...
    'FontSize',15,'FontUnits','normalized','parent',EVD_all_trials_uibg,'BackgroundColor',[0.8353 0.8235 0.7922],'Value',e_para.xhisto_all_trials==1);
EVD_trials_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.5 0.2 0.4 0.6],'string','Trials',...
    'FontSize',15,'FontUnits','normalized','parent',EVD_all_trials_uibg,'BackgroundColor',[0.8353 0.8235 0.7922],'Value',e_para.xhisto_all_trials==2);

uicontrol('style','text','units','normalized','position',[0.03 0.52 0.2 0.16],'string','#Trials:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','FontUnits','normalized','parent',EVD_Histo_panel);
EVD_numtrials_edit=uicontrol('style','edit','units','normalized','position',[0.24 0.54 0.24 0.17],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_Histo_panel,'String',num2str(e_para.num_trials));
EVD_xhisto_grand_average_checkbox=uicontrol('style','checkbox','units','normalized','position',[0.52 0.55 0.46 0.16],'string','Grand average',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',EVD_Histo_panel,'Value',e_para.xhisto_grand_average);

EVD_equi_custom_uibg=uibuttongroup('units','normalized','position',[0.03 0.27 0.94 0.22],'FontSize',15,...
    'FontWeight','bold','SelectionChangeFcn',{@EVD_equi_custom_rb_callback},'parent',EVD_Histo_panel);
EVD_equi_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.05 0.2 0.4 0.6],'string','Equidistant',...
    'FontSize',15,'FontUnits','normalized','parent',EVD_equi_custom_uibg,'BackgroundColor',[0.8353 0.8235 0.7922],'Value',e_para.xhisto_equi_custom==1);
EVD_custom_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.5 0.2 0.4 0.6],'string','Custom',...
    'FontSize',15,'FontUnits','normalized','parent',EVD_equi_custom_uibg,'BackgroundColor',[0.8353 0.8235 0.7922],'Value',e_para.xhisto_equi_custom==2);

uicontrol('style','text','units','normalized','position',[0.01 0.04 0.4 0.16],'string','#Bins:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','FontUnits','normalized','parent',EVD_Histo_panel);
EVD_xhisto_numbins_edit=uicontrol('style','edit','units','normalized','position',[0.17 0.05 0.16 0.17],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_Histo_panel,'String',num2str(e_para.xhisto_num_bins));
uicontrol('style','text','units','normalized','position',[0.35 0.04 0.18 0.16],'string','Edges:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','FontUnits','normalized','parent',EVD_Histo_panel);
EVD_xhisto_edges_edit=uicontrol('style','edit','units','normalized','position',[0.54 0.05 0.44 0.17],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_Histo_panel,'String',num2str(e_para.xhisto_edges));


% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
% @@@@@@@@@@@@ here you add GUI-elements for your parameters @@@@@@@@@@
% @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

EVD_parameter_panel=uipanel('units','normalized','position',[0.5 0.12 0.48 0.86],'Title','Parameters','FontSize',15,'FontWeight','bold','parent',EVD_events_panel);

EVD_movave_checkbox=uicontrol('style','checkbox','units','normalized','position',[0.06 0.9 0.46 0.05],'string','Moving averages',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','parent',EVD_parameter_panel,'callback',{@EVD_movave_callback},'Value',e_para.movave);
EVD_movave_order_text=uicontrol('style','text','units','normalized','position',[0.12 0.8 0.46 0.08],'string','Order:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','parent',EVD_parameter_panel);
EVD_movave_order_edit=uicontrol('style','edit','units','normalized','position',[0.62 0.82 0.35 0.08],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_parameter_panel,'String',num2str(e_para.movave_order));

EVD_max_window_text=uicontrol('style','text','units','normalized','position',[0.06 0.68 0.38 0.08],'string','Window:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','FontUnits','normalized','parent',EVD_parameter_panel,'Visible','off');
EVD_max_window_edit=uicontrol('style','edit','units','normalized','position',[0.62 0.7 0.35 0.08],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_parameter_panel,'String',num2str(e_para.max_window),'Visible','off');
EVD_max_elevation_text=uicontrol('style','text','units','normalized','position',[0.06 0.58 0.38 0.08],'string','Elevation:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','parent',EVD_parameter_panel,'Visible','off');
EVD_max_elevation_edit=uicontrol('style','edit','units','normalized','position',[0.62 0.6 0.35 0.08],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_parameter_panel,'String',num2str(e_para.max_elevation),'Visible','off');

EVD_min_window_text=uicontrol('style','text','units','normalized','position',[0.06 0.68 0.38 0.08],'string','Window:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','FontUnits','normalized','parent',EVD_parameter_panel,'Visible','off');
EVD_min_window_edit=uicontrol('style','edit','units','normalized','position',[0.62 0.7 0.35 0.08],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_parameter_panel,'String',num2str(e_para.min_window),'Visible','off');
EVD_min_elevation_text=uicontrol('style','text','units','normalized','position',[0.06 0.58 0.38 0.08],'string','Elevation:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','parent',EVD_parameter_panel,'Visible','off');
EVD_min_elevation_edit=uicontrol('style','edit','units','normalized','position',[0.62 0.6 0.35 0.08],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_parameter_panel,'String',num2str(e_para.min_elevation),'Visible','off');


EVD_threshold_text=uicontrol('style','text','units','normalized','position',[0.06 0.63 0.48 0.08],'string','Threshold:',...
    'HorizontalAlignment','left','FontSize',14,'FontUnits','normalized','FontUnits','normalized','parent',EVD_parameter_panel,'Visible','off');
EVD_threshold_edit=uicontrol('style','edit','units','normalized','position',[0.62 0.65 0.35 0.08],...
    'FontSize',14,'FontUnits','normalized','BackgroundColor','w','parent',EVD_parameter_panel,'String',num2str(e_para.crossthreshold),'Visible','off');
EVD_tcdirection_uibg=uibuttongroup('units','normalized','position',[0.03 0.47 0.94 0.14],'FontSize',15,...
    'FontWeight','bold','SelectionChangeFcn',{@EVD_equi_custom_rb_callback},'parent',EVD_parameter_panel,'Visible','off');
EVD_upwards_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.05 0.2 0.4 0.6],'string','Upwards',...
    'FontSize',15,'FontUnits','normalized','parent',EVD_tcdirection_uibg,'BackgroundColor',[0.8353 0.8235 0.7922],'Value',e_para.tc_upwards>0);
EVD_downwards_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.5 0.2 0.4 0.6],'string','Downwards',...
    'FontSize',15,'FontUnits','normalized','parent',EVD_tcdirection_uibg,'BackgroundColor',[0.8353 0.8235 0.7922],'Value',e_para.tc_upwards<0);

uicontrol('style','pushbutton','units','normalized','position',[0.075 0.03 0.25 0.06],'string','Back',...
    'FontSize',15,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'parent',EVD_events_panel,'CallBack',{@EVD_Back_callback});
EVD_Update_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.675 0.03 0.25 0.06],'string','Update',...
    'FontSize',15,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'parent',EVD_events_panel,'CallBack',{@EVD_Update_callback});


EVD_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.2 0.03 0.25 0.04],'string','Cancel',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@EVD_close_callback},'Visible','off');
EVD_Done_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.03 0.25 0.04],'string','Done','Enable','off',...
    'FontSize',15,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@EVD_done_callback},'Visible','off');


figure(f_para.num_fig);
EVD_UserData.fh=gcf;
set(EVD_UserData.fh,'Units','Normalized','Userdata',EVD_UserData)


    function EVD_reset(varargin)        
        figure(f_para.num_fig);
        clf
        subplot('Position',f_para.supo1);
        plot([-1000 -1001],[-1000 -1001])
        xlim([0 1]); ylim([0 1])
        set(gca,'XTick',[],'YTick',[])
        xlabel(''); ylabel('')
        set(EVD_smin_edit,'String','1')
        set(EVD_smax_edit,'String','')
        set(EVD_downsampling_edit,'String','1')
        set(EVD_yscale_edit,'String',1)
        set(EVD_channels_edit,'String','')
        set(EVD_Data_Cancel_pushbutton,'Enable','on')
        set(EVD_Data_Update_pushbutton,'Enable','off')
        set(EVD_Data_OK_pushbutton,'Enable','off')
        set(EVD_events_panel,'Visible','off')
        set(EVD_Cancel_pushbutton,'Visible','off')
        set(EVD_Done_pushbutton,'Visible','off')
    end


    function EVD_open_mat_file(varargin)
        figure(f_para.num_fig);
        [d_para.contfilename,d_para.contpath]=uigetfile('*.mat','Pick a .mat-file');
        if isequal(d_para.contfilename,0) || isequal(d_para.contpath,0)
            return
        end
        d_para.contmatfile=[d_para.contpath d_para.contfilename];
        if ~isequal(d_para.contmatfile,0)
            EVD_UserData=get(f_para.num_fig,'UserData');
            data.matfile=d_para.contmatfile;
            data.default_variable='';
            data.content='continuous data';
            
            matfile_data=load(data.matfile);
            variables=fieldnames(matfile_data);
            if length(variables)==1 && ~isstruct(matfile_data.(variables{1}))
                variable=variables{1};
                data=matfile_data;
            else
                SPIKY('SPIKY_select_variable',gcbo,data,handles)
                variable=getappdata(handles.figure1,'variable');
                data=getappdata(handy.figure1,'data');
            end
            
            if ~isempty(variable) && ~strcmp(variable,'A9ZB1YC8X')
                EVD_UserData.ori_cont_data=squeeze(data.(variable));
                EVD_UserData.cont_data=EVD_UserData.ori_cont_data;
                EVD_UserData.data_source=char(d_para.contfilename);
                EVD_UserData.new_data=1;
                set(EVD_UserData.fh,'Userdata',EVD_UserData)
                EVD_check_data
            end
            set(EVD_yscale_edit,'Enable','on')
            set(EVD_downsampling_edit,'Enable','on')
            set(EVD_smin_edit,'Enable','on')
            set(EVD_smax_edit,'Enable','on')
            set(EVD_channels_edit,'Enable','on')
            set(EVD_normalize_checkbox,'Enable','on')
        end
    end


    function EVD_workspace_callback(varargin)

        figure(f_para.num_fig);
        EVD_UserData=get(gcf,'Userdata');

        d_para_default=getappdata(handles.figure1,'data_parameters_default');
        d_para=d_para_default;
        
        data.content='continuous data';
        data.default_variable=d_para.spikes_variable;
        variables=evalin('base','who');
        
        if ~isempty(variables)
            if length(variables)==1 && ~isstruct(evalin('base',char(variables)))   % just one variable: take it automatically?
                EVD_UserData.ori_cont_data=evalin('base',char(variables));
                variable=variables;
            else
                SPIKY('SPIKY_select_variable',gcbo,data,handles)
                variable=getappdata(handles.figure1,'variable');
                if ~isempty(variable) && ~strcmp(variable,'A9ZB1YC8X')
                    data=getappdata(handles.figure1,'data');
                    variable=['data.',variable];
                    EVD_UserData.ori_cont_data=squeeze(eval(variable));
                end
            end
            if isfield(EVD_UserData,'ori_cont_data')
                EVD_UserData.data_source=char(variable);
                EVD_UserData.cont_data=EVD_UserData.ori_cont_data;
                EVD_UserData.new_data=1;
                set(EVD_UserData.fh,'Userdata',EVD_UserData)
                EVD_check_data
            end
            set(EVD_yscale_edit,'Enable','on')
            set(EVD_downsampling_edit,'Enable','on')
            set(EVD_smin_edit,'Enable','on')
            set(EVD_smax_edit,'Enable','on')
            set(EVD_channels_edit,'Enable','on')
            set(EVD_normalize_checkbox,'Enable','on')
        else
            set(0,'DefaultUIControlFontSize',16);
            mbh=msgbox(sprintf('The workspace is empty.'),'Warning','warn','modal');
            htxt=findobj(mbh,'Type','text');
            set(htxt,'FontSize',12,'FontWeight','bold')
            mb_pos=get(mbh,'Position');
            set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
            uiwait(mbh);
        end
        
    end


    function EVD_check_data(varargin)
        figure(f_para.num_fig);
        EVD_UserData=get(gcf,'Userdata');
        
        ret=0;
        if iscell(EVD_UserData.cont_data)
            dummy=EVD_UserData.cont_data;
            if all(cellfun('ndims',dummy)==2) && length(unique(cellfun('length',dummy)))==1
                EVD_UserData.cont_data=zeros(length(dummy),length(dummy{1}));
                for rc=1:length(dummy)
                    if numel(dummy{rc})==length(dummy{rc})
                        EVD_UserData.cont_data(rc,:)=dummy{rc};
                    else
                        ret=1;
                        break;
                    end
                end
            else
                ret=1;
            end
        end
            
        if ret==1 && ~isnumeric(EVD_UserData.cont_data) || ndims(EVD_UserData.cont_data)~=2 || ~all(size(EVD_UserData.cont_data)>1)
            set(0,'DefaultUIControlFontSize',16);
            mbh=msgbox(sprintf('No matrix with continuous data has been chosen. Please try again!'),'Warning','warn','modal');
            htxt=findobj(mbh,'Type','text');
            set(htxt,'FontSize',12,'FontWeight','bold')
            mb_pos=get(mbh,'Position');
            set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
            uiwait(mbh);
            return
        end
        if size(EVD_UserData.cont_data,2)<size(EVD_UserData.cont_data,1)
            EVD_UserData.cont_data=EVD_UserData.cont_data';
        end

        if EVD_UserData.new_data==1
            set(EVD_smax_edit,'String',num2str(size(EVD_UserData.cont_data,2)))
            set(EVD_channels_edit,'String',num2str(1:size(EVD_UserData.cont_data,1)))
        end
        set(EVD_UserData.fh,'Userdata',EVD_UserData)
        EVD_plot_data
        set(EVD_Data_Update_pushbutton,'Enable','on')
        set(EVD_Data_OK_pushbutton,'Enable','on')
        
        set(EVD_UserData.fh,'Userdata',EVD_UserData)
    end


    function EVD_data_update_callback(varargin)       
        figure(f_para.num_fig);
        EVD_UserData=get(gcf,'Userdata');
        EVD_UserData.new_data=0;
        set(EVD_UserData.fh,'Userdata',EVD_UserData)
        EVD_check_data
    end


    function EVD_data_ok_callback(varargin)       
        figure(f_para.num_fig);
        EVD_UserData=get(gcf,'Userdata');
        EVD_UserData.new_data=0;
        set(EVD_UserData.fh,'Userdata',EVD_UserData)
        EVD_check_data
        EVD_movave_callback
        EVD_eventtype_rb_callback
        EVD_all_trials_rb_callback
        EVD_equi_custom_rb_callback
        set(EVD_yscale_edit,'Enable','off')
        set(EVD_downsampling_edit,'Enable','off')
        set(EVD_smin_edit,'Enable','off')
        set(EVD_smax_edit,'Enable','off')
        set(EVD_channels_edit,'Enable','off')
        set(EVD_normalize_checkbox,'Enable','off')
        set(EVD_Data_Cancel_pushbutton,'Enable','off')
        set(EVD_Data_Update_pushbutton,'Enable','off')
        set(EVD_Data_OK_pushbutton,'Enable','off')
        set(EVD_Update_pushbutton,'Enable','on')
        set(EVD_events_panel,'Visible','on')
        set(EVD_Cancel_pushbutton,'Visible','on')
        set(EVD_Done_pushbutton,'Visible','on')
    end

        
    function EVD_plot_data(varargin)        
        figure(f_para.num_fig);
        clf; hold on

        EVD_UserData=get(gcf,'Userdata');
        
        % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        % @@@@@@@@@ here you could downsample your data @@@@@@@@@
        % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                
        EVD_UserData.smin=str2double(get(EVD_smin_edit,'String'));
        EVD_UserData.smax=str2double(get(EVD_smax_edit,'String'));
        EVD_UserData.channels=str2num(get(EVD_channels_edit,'String'));
        EVD_UserData.downsampling=str2double(get(EVD_downsampling_edit,'String'));
        EVD_UserData.yscale=str2double(get(EVD_yscale_edit,'String'));
        EVD_UserData.normalize=get(EVD_normalize_checkbox,'Value');
        
        EVD_UserData.cont_data=EVD_UserData.ori_cont_data(EVD_UserData.channels,EVD_UserData.smin:EVD_UserData.downsampling:EVD_UserData.smax);
        
        EVD_UserData.num_channels=size(EVD_UserData.cont_data,1);
        EVD_UserData.num_samples=size(EVD_UserData.cont_data,2);
        xlim([0 EVD_UserData.num_samples*1.2])
        ylim([-EVD_UserData.num_channels*0.2 EVD_UserData.num_channels])

        EVD_UserData.dh=zeros(1,EVD_UserData.num_channels);
        EVD_UserData.data=zeros(EVD_UserData.num_channels,EVD_UserData.num_samples);
        EVD_UserData.plot_data=zeros(EVD_UserData.num_channels,EVD_UserData.num_samples);
        EVD_UserData.plot_min=zeros(EVD_UserData.num_channels);
        EVD_UserData.plot_max=zeros(EVD_UserData.num_channels);
        for rc=1:EVD_UserData.num_channels
            if e_para.normalize
                chan=EVD_UserData.cont_data(rc,1:EVD_UserData.num_samples);
                EVD_UserData.data(rc,1:EVD_UserData.num_samples)=(chan-mean(chan))/std(chan);
            else
                EVD_UserData.data(rc,1:EVD_UserData.num_samples)=EVD_UserData.cont_data(rc,1:EVD_UserData.num_samples);                
            end
            chan=EVD_UserData.data(rc,1:EVD_UserData.num_samples);
            EVD_UserData.plot_data(rc,1:EVD_UserData.num_samples)=(chan-min(chan))/(max(chan)-min(chan));
            EVD_UserData.plot_min(rc)=min(chan);
            EVD_UserData.plot_max(rc)=max(chan);
            EVD_UserData.dh(rc)=plot(EVD_UserData.num_channels-rc+EVD_UserData.plot_data(rc,:)*EVD_UserData.yscale,'b');
            if rc<EVD_UserData.num_channels
                line([0 EVD_UserData.num_samples],(EVD_UserData.num_channels-rc)*ones(1,2),'LineStyle',':','Color','k')
            end
        end
        EVD_UserData.xl=xlim; EVD_UserData.yl=ylim;
        line(EVD_UserData.num_samples*ones(1,2),EVD_UserData.yl,'LineStyle','-','Color','k')
        line(EVD_UserData.xl,zeros(1,2),'LineStyle','-','Color','k')
        xt=get(gca,'XTick');
        set(gca,'XTick',xt(xt<=EVD_UserData.num_samples))
        set(gca,'YTick',(1:EVD_UserData.num_channels)-0.5,'YTickLabel',fliplr(1:EVD_UserData.num_channels))
        data_title='Continuous data';
        if isfield(EVD_UserData,'data_source')
            data_title=[data_title,' - ',regexprep(EVD_UserData.data_source,'_','-')];
        end
        title(data_title,'FontSize',16,'FontWeight','bold')
        xlabel('Sample points','FontSize',15,'FontWeight','bold')
        ylabel('Channels','FontSize',15,'FontWeight','bold')
        set(gca,'FontSize',14)

        set(EVD_UserData.fh,'Userdata',EVD_UserData)
    end


    function EVD_movave_callback(varargin)
        if get(EVD_movave_checkbox,'Value')==1
            set(EVD_movave_order_text,'Enable','on')
            set(EVD_movave_order_edit,'Enable','on')
        else
            set(EVD_movave_order_text,'Enable','off')
            set(EVD_movave_order_edit,'Enable','off')
        end
    end


    function EVD_all_trials_rb_callback(varargin)
        if get(EVD_all_radiobutton,'Value')==1
            set(EVD_numtrials_edit,'Enable','off')
            set(EVD_xhisto_grand_average_checkbox,'Enable','off')
        else
            set(EVD_numtrials_edit,'Enable','on')
            set(EVD_xhisto_grand_average_checkbox,'Enable','on')
        end
    end


    function EVD_equi_custom_rb_callback(varargin)
        if get(EVD_equi_radiobutton,'Value')==1
            set(EVD_xhisto_numbins_edit,'Enable','on')
            set(EVD_xhisto_edges_edit,'Enable','off')
        else
            set(EVD_xhisto_numbins_edit,'Enable','off')
            set(EVD_xhisto_edges_edit,'Enable','on')
        end
    end


    function EVD_eventtype_rb_callback(varargin)
        
        % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        % @@@@@@@@@@@@ here you set visibility depending on the event type @@@@@@@@@@
        % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

        if get(EVD_min_radiobutton,'Value')==1    % only for minima
            set(EVD_min_window_text,'Visible','on')
            set(EVD_min_window_edit,'Visible','on')
            set(EVD_min_elevation_text,'Visible','on')
            set(EVD_min_elevation_edit,'Visible','on')
        else
            set(EVD_min_window_text,'Visible','off')
            set(EVD_min_window_edit,'Visible','off')
            set(EVD_min_elevation_text,'Visible','off')
            set(EVD_min_elevation_edit,'Visible','off')
        end
        if get(EVD_max_radiobutton,'Value')==1    % only for maxima
            set(EVD_max_window_text,'Visible','on')
            set(EVD_max_window_edit,'Visible','on')
            set(EVD_max_elevation_text,'Visible','on')
            set(EVD_max_elevation_edit,'Visible','on')
        else
            set(EVD_max_window_text,'Visible','off')
            set(EVD_max_window_edit,'Visible','off')
            set(EVD_max_elevation_text,'Visible','off')
            set(EVD_max_elevation_edit,'Visible','off')
        end
        if get(EVD_crossing_radiobutton,'Value')==1    % only for threshold crossing
            set(EVD_threshold_text,'Visible','on')
            set(EVD_threshold_edit,'Visible','on')
            set(EVD_tcdirection_uibg,'Visible','on')
        else
            set(EVD_threshold_text,'Visible','off')
            set(EVD_threshold_edit,'Visible','off')
            set(EVD_tcdirection_uibg,'Visible','off')
        end        
    end
    

    function EVD_plot_events(varargin)        
        figure(f_para.num_fig);
        hold on
        
        e_para.event_plot=get(EVD_spikes_radiobutton,'Value')+2*get(EVD_symbol_radiobutton,'Value')+3*get(EVD_signal_radiobutton,'Value');
        e_para.event_color=get(EVD_event_color_edit,'String');
        e_para.event_linewidth=str2double(get(EVD_event_linewidth_edit,'String'));
        
        e_para.xhisto_all_trials=get(EVD_all_radiobutton,'Value')+2*get(EVD_trials_radiobutton,'Value');
        e_para.num_trials=str2double(get(EVD_numtrials_edit,'String'));
        e_para.xhisto_grand_average=get(EVD_xhisto_grand_average_checkbox,'Value');
        e_para.xhisto_equi_custom=get(EVD_equi_radiobutton,'Value')+2*get(EVD_custom_radiobutton,'Value');
        e_para.xhisto_num_bins=str2double(get(EVD_xhisto_numbins_edit,'String'));
        e_para.xhisto_edges=str2num(get(EVD_xhisto_edges_edit,'String'));


        EVD_UserData=get(gcf,'Userdata');
        [r,c]=find(EVD_UserData.evm);
        EVD_UserData.num_total_events=length(r);
        ec=1;
        EVD_UserData.eh=zeros(1,EVD_UserData.num_total_events);
        
        
        if e_para.event_plot==1
            for efc=1:EVD_UserData.num_total_events
                EVD_UserData.eh(efc)=line(c(efc)*ones(1,2),EVD_UserData.num_channels-r(efc)+[0.1 0.9],...
                    'Color',e_para.event_color(ec),'LineWidth',e_para.event_linewidth(ec));
            end
        elseif e_para.event_plot==2
            for efc=1:EVD_UserData.num_total_events
                EVD_UserData.eh(efc)=plot(c(efc),EVD_UserData.num_channels-r(efc)+EVD_UserData.plot_data(r(efc),c(efc))*EVD_UserData.yscale,...
                    e_para.event_symbol(ec),'Color',e_para.event_color(ec),'LineWidth',e_para.event_linewidth(ec),'MarkerSize',e_para.event_marker_size(ec));
            end
        elseif e_para.event_plot==3
            for efc=1:EVD_UserData.num_total_events
                EVD_UserData.eh(efc)=line(max([c(efc)-e_para.event_precol(ec) 1]):min([c(efc)+e_para.event_postcol(ec) EVD_UserData.num_samples]),EVD_UserData.num_channels-r(efc)+...
                    EVD_UserData.plot_data(r(efc),max([c(efc)-e_para.event_precol(ec) 1]):min([c(efc)+e_para.event_postcol(ec) EVD_UserData.num_samples]))*EVD_UserData.yscale,...
                    'color',e_para.event_color(ec),'LineWidth',e_para.event_linewidth(ec));
            end
        end

        EVD_UserData.num_events_per_channel=sum(EVD_UserData.evm~=0,2);             % currently allows one event only
        EVD_UserData.num_total_events=sum(EVD_UserData.num_events_per_channel);
        xl=xlim; yl=ylim;
        
        if isfield(EVD_UserData,'tlh') && any(ishandle(EVD_UserData.tlh))           % threshold lines
            for rc=1:EVD_UserData.num_channels
                delete(EVD_UserData.tlh(rc))
            end
        end
        if e_para.event_type==3
            EVD_UserData.tlh=zeros(1,EVD_UserData.num_channels);
            for rc=1:EVD_UserData.num_channels
                EVD_UserData.tlh(rc)=line([0 EVD_UserData.smax-EVD_UserData.smin],(EVD_UserData.num_channels-rc+(e_para.crossthreshold-EVD_UserData.plot_min(rc))/...
                    (EVD_UserData.plot_max(rc)-EVD_UserData.plot_min(rc))*EVD_UserData.yscale)*ones(1,2),...
                    'Color','k','LineWidth',1,'LineStyle',':');
            end            
        end
        
        if isfield(EVD_UserData,'th') && any(ishandle(EVD_UserData.th))
            for rc=1:EVD_UserData.num_channels
                delete(EVD_UserData.th(rc))
            end
        end
        
        EVD_UserData.hh1=bar(EVD_UserData.num_events_per_channel);                                  % Y-Histo
        set(EVD_UserData.hh1,'XData',(1:EVD_UserData.num_channels)-0.5)
        set(EVD_UserData.hh1,'BaseValue',EVD_UserData.num_samples)
        set(EVD_UserData.hh1,'YData',(EVD_UserData.num_samples+flipud(EVD_UserData.num_events_per_channel)/...
            (max(EVD_UserData.num_events_per_channel)+(max(EVD_UserData.num_events_per_channel)==0))*0.2*EVD_UserData.num_samples))        
        set(EVD_UserData.hh1,'horizontal','on')
        set(EVD_UserData.hh1,'FaceColor','b')
        
        
        if e_para.xhisto_all_trials==1
            if e_para.xhisto_equi_custom==2 && ~isempty(e_para.xhisto_edges)
                bins=unique([EVD_UserData.smin e_para.xhisto_edges EVD_UserData.smax]);
                e_para.xhisto_num_bins=length(bins)-1;
            else
                bin_width=EVD_UserData.num_samples/e_para.xhisto_num_bins;
                bins=0:bin_width:EVD_UserData.num_samples;
            end            
        else
            EVD_UserData.num_samples_per_trial=EVD_UserData.num_samples/e_para.num_trials;
            if e_para.xhisto_equi_custom==2 && ~isempty(e_para.xhisto_edges)
                e_para.xhisto_edges=e_para.xhisto_edges(e_para.xhisto_edges<EVD_UserData.num_samples_per_trial);
                
                bins=[];
                for tc=1:e_para.num_trials
                    bins=[bins unique([e_para.xhisto_edges EVD_UserData.num_samples_per_trial])+EVD_UserData.num_samples_per_trial*(tc-1)];
                end
                bins=unique([EVD_UserData.smin bins EVD_UserData.smax]);
                e_para.xhisto_num_bins=length(bins)-1;
            else
                bin_width=EVD_UserData.num_samples_per_trial/e_para.xhisto_num_bins;
                bins=0:bin_width:EVD_UserData.num_samples;
                e_para.xhisto_num_bins=e_para.xhisto_num_bins*e_para.num_trials;
            end            
        end
        
        if e_para.xhisto_equi_custom==1                                              % X-Histo
            EVD_UserData.histo_x=bins(1:e_para.xhisto_num_bins)+diff(bins)/2;
            EVD_UserData.histo_y=zeros(1,e_para.xhisto_num_bins+1);
            EVD_UserData.spikes=cell(1,EVD_UserData.num_channels);
            for rc=1:EVD_UserData.num_channels
                EVD_UserData.spikes{rc}=c(r==rc);
                EVD_UserData.histo_y=EVD_UserData.histo_y+histc(EVD_UserData.spikes{rc}',bins);
            end
            if e_para.xhisto_all_trials==2 && e_para.xhisto_grand_average
                EVD_UserData.histo_x=EVD_UserData.histo_x(1:e_para.xhisto_num_bins/e_para.num_trials);
                e_para.xhisto_num_bins=length(EVD_UserData.histo_x);
                for bc=1:e_para.xhisto_num_bins
                    EVD_UserData.histo_y(bc)=mean(EVD_UserData.histo_y(bc+e_para.xhisto_num_bins*(0:e_para.num_trials-1)));
                end
                EVD_UserData.histo_y=EVD_UserData.histo_y(1:e_para.xhisto_num_bins);
            end
            EVD_UserData.hh2=bar(EVD_UserData.histo_y);
            set(EVD_UserData.hh2,'XData',EVD_UserData.histo_x)
            set(EVD_UserData.hh2,'YData',(-EVD_UserData.histo_y(1:e_para.xhisto_num_bins)/...
                (max(EVD_UserData.histo_y(1:e_para.xhisto_num_bins))+(max(EVD_UserData.histo_y(1:e_para.xhisto_num_bins))==0))*0.2*EVD_UserData.num_channels))
            set(EVD_UserData.hh2,'BaseValue',0)
            set(EVD_UserData.hh2,'FaceColor','b')
        else
            EVD_UserData.histo_x=bins(1:e_para.xhisto_num_bins)+diff(bins)/2;
            EVD_UserData.histo_y=zeros(1,e_para.xhisto_num_bins+1);
            EVD_UserData.spikes=cell(1,EVD_UserData.num_channels);
            for rc=1:EVD_UserData.num_channels
                EVD_UserData.spikes{rc}=c(r==rc);
                EVD_UserData.histo_y=EVD_UserData.histo_y+histc(EVD_UserData.spikes{rc}',bins);
            end
            if e_para.xhisto_all_trials==2 && e_para.xhisto_grand_average
                EVD_UserData.histo_x=EVD_UserData.histo_x(1:e_para.xhisto_num_bins/e_para.num_trials);
                e_para.xhisto_num_bins=length(EVD_UserData.histo_x);
                for bc=1:e_para.xhisto_num_bins
                    EVD_UserData.histo_y(bc)=mean(EVD_UserData.histo_y(bc+e_para.xhisto_num_bins*(0:e_para.num_trials-1)));
                end
                EVD_UserData.histo_y=EVD_UserData.histo_y(1:e_para.xhisto_num_bins);
            end
            
            dbins=diff(bins);
            mv=max(EVD_UserData.histo_y(1:e_para.xhisto_num_bins));
            EVD_UserData.rh=zeros(1,e_para.xhisto_num_bins);
            for bc=1:e_para.xhisto_num_bins
                y=EVD_UserData.histo_y(bc)/(mv+(mv==0))*0.2*EVD_UserData.num_channels;
                posi=[bins(bc) -y dbins(bc) y];
                if(y~=0)
                    EVD_UserData.rh(bc)=rectangle('Position',posi,'FaceColor','b');
                end
            end
        end

        %a=EVD_UserData.histo_x
        %b=EVD_UserData.histo_y(1:e_para.xhisto_num_bins)
        
        EVD_UserData.th=zeros(1,EVD_UserData.num_channels+3);
        for rc=1:EVD_UserData.num_channels
            EVD_UserData.th(rc)=text(xl(2)+0.02*(xl(2)-xl(1)),EVD_UserData.num_channels-rc+0.5,num2str(EVD_UserData.num_events_per_channel(rc)));
        end
        EVD_UserData.th(EVD_UserData.num_channels+1)=text(xl(2)-0.11*(xl(2)-xl(1)),yl(1)+0.12*(yl(2)-yl(1)),'Total:','FontSize',15,'FontWeight','bold');
        EVD_UserData.th(EVD_UserData.num_channels+2)=text(xl(2)-0.11*(xl(2)-xl(1)),yl(1)+0.08*(yl(2)-yl(1)),num2str(EVD_UserData.num_total_events),'FontSize',15,'FontWeight','bold');        
        EVD_UserData.th(EVD_UserData.num_channels+3)=text(xl(2)-0.15*(xl(2)-xl(1)),yl(1)+0.015*(yl(2)-yl(1)),num2str(max(EVD_UserData.histo_y)),'FontSize',13);        

        set(EVD_UserData.fh,'Userdata',EVD_UserData)
    end


    function EVD_Update_callback(varargin)
        figure(f_para.num_fig);        
        EVD_UserData=get(gcf,'Userdata');
        if isfield(EVD_UserData,'eh') && all(ishandle(EVD_UserData.eh))
            for hc=1:length(EVD_UserData.eh)
                if EVD_UserData.eh(hc)~=0
                    delete(EVD_UserData.eh(hc))
                end
            end
            EVD_UserData=rmfield(EVD_UserData,'eh');
        end
        if isfield(EVD_UserData,'rh') && all(ishandle(EVD_UserData.rh))
            for hc=1:length(EVD_UserData.rh)
                if EVD_UserData.rh(hc)~=0
                    delete(EVD_UserData.rh(hc))
                end
            end
            EVD_UserData=rmfield(EVD_UserData,'rh');
        end
        if isfield(EVD_UserData,'th') && all(ishandle(EVD_UserData.th))
            for hc=1:length(EVD_UserData.th)
                if EVD_UserData.th(hc)~=0
                    delete(EVD_UserData.th(hc))
                end
            end
            EVD_UserData=rmfield(EVD_UserData,'th');
        end
        if isfield(EVD_UserData,'hh1') && all(ishandle(EVD_UserData.hh1))
            for hc=1:length(EVD_UserData.hh1)
                if EVD_UserData.hh1(hc)~=0
                    delete(EVD_UserData.hh1(hc))
                end
            end
            EVD_UserData=rmfield(EVD_UserData,'hh1');
        end
        if isfield(EVD_UserData,'hh2') && all(ishandle(EVD_UserData.hh2))
            for hc=1:length(EVD_UserData.hh2)
                if EVD_UserData.hh2(hc)~=0
                    delete(EVD_UserData.hh2(hc))
                end
            end
            EVD_UserData=rmfield(EVD_UserData,'hh2');
        end
        
        % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        % @@@@@@@@@@@@ here you should put your parameters @@@@@@@@@@@@@@@@
        % @@@@@@@@@@@@ (which you then get from the GUI-elements) @@@@@@@@@
        % @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

        e_para.event_type=get(EVD_min_radiobutton,'Value')+2*get(EVD_max_radiobutton,'Value')+3*get(EVD_crossing_radiobutton,'Value');
        e_para.movave=get(EVD_movave_checkbox,'Value');
        e_para.movave_order=str2double(get(EVD_movave_order_edit,'String'));
        if e_para.event_type==1
            e_para.min_window=str2double(get(EVD_min_window_edit,'String'));
            e_para.min_elevation=str2double(get(EVD_min_elevation_edit,'String'));
        elseif e_para.event_type==2
            e_para.max_window=str2double(get(EVD_max_window_edit,'String'));
            e_para.max_elevation=str2double(get(EVD_max_elevation_edit,'String'));
        elseif e_para.event_type==3
            e_para.crossthreshold=str2double(get(EVD_threshold_edit,'String'));
            e_para.tc_upwards=get(EVD_upwards_radiobutton,'Value');
        end
        
        [EVD_UserData.evm,e_para]=SPIKY_f_get_events(EVD_UserData.data,e_para);
        set(EVD_UserData.fh,'Userdata',EVD_UserData)
        EVD_plot_events                
        set(EVD_Done_pushbutton,'Enable','on')
    end


    function EVD_Back_callback(varargin)
        if isfield(EVD_UserData,'eh') && all(ishandle(EVD_UserData.eh))
            for hc=1:length(EVD_UserData.eh)
                if EVD_UserData.eh(hc)~=0
                    delete(EVD_UserData.eh(hc))
                end
            end
            EVD_UserData=rmfield(EVD_UserData,'eh');
        end
        if isfield(EVD_UserData,'rh') && all(ishandle(EVD_UserData.rh))
            for hc=1:length(EVD_UserData.rh)
                if EVD_UserData.rh(hc)~=0
                    delete(EVD_UserData.rh(hc))
                end
            end
            EVD_UserData=rmfield(EVD_UserData,'rh');
        end
        if isfield(EVD_UserData,'th') && all(ishandle(EVD_UserData.th))
            for hc=1:length(EVD_UserData.th)
                if EVD_UserData.th(hc)~=0
                    delete(EVD_UserData.th(hc))
                end
            end
            EVD_UserData=rmfield(EVD_UserData,'th');
        end
        if isfield(EVD_UserData,'hh1') && all(ishandle(EVD_UserData.hh1))
            for hc=1:length(EVD_UserData.hh1)
                if EVD_UserData.hh1(hc)~=0
                    delete(EVD_UserData.hh1(hc))
                end
            end
            EVD_UserData=rmfield(EVD_UserData,'hh1');
        end
        if isfield(EVD_UserData,'hh2') && all(ishandle(EVD_UserData.hh2))
            for hc=1:length(EVD_UserData.hh2)
                if EVD_UserData.hh2(hc)~=0
                    delete(EVD_UserData.hh2(hc))
                end
            end
            EVD_UserData=rmfield(EVD_UserData,'hh2');
        end
        set(EVD_yscale_edit,'Enable','on')
        set(EVD_downsampling_edit,'Enable','on')
        set(EVD_smin_edit,'Enable','on')
        set(EVD_smax_edit,'Enable','on')
        set(EVD_channels_edit,'Enable','on')
        set(EVD_normalize_checkbox,'Enable','on')
        set(EVD_Data_Cancel_pushbutton,'Enable','on')
        set(EVD_Data_Update_pushbutton,'Enable','on')
        set(EVD_Data_OK_pushbutton,'Enable','on')
        set(EVD_events_panel,'Visible','off')        
        set(EVD_Cancel_pushbutton,'Visible','off')        
        set(EVD_Done_pushbutton,'Visible','off')        
    end


    function EVD_done_callback(varargin)
        figure(f_para.num_fig);
        clf;
        EVD_UserData=get(gcf,'Userdata');
        
        setappdata(handles.figure1,'events',EVD_UserData.spikes)
        
        delete(EVD_fig)
        set(handles.figure1,'Visible','on')

        SPIKY('SPIKY_event_detector_callback',hObject, eventdata, handles)        
    end


    function EVD_close_callback(varargin)
        figure(f_para.num_fig);
        clf;
        EVD_UserData=get(gcf,'Userdata');
        
        if gcbo==EVD_Done_pushbutton
            setappdata(handles.figure1,'events',EVD_UserData.spikes)
        %elseif isappdata(handles.figure1,'events')
            %rmappdata(handles.figure1,'events')
        end
        
        set(handles.figure1,'Visible','on')
        delete(EVD_fig)
        %if gcbo==EVD_Done_pushbutton
            %SPIKY('SPIKY_event_detector_callback',hObject, eventdata, handles)
        %end
    end

end
