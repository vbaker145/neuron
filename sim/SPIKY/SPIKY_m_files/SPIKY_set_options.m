function SPIKY_set_options(hObject, eventdata, handles)

d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');

Options_fig=figure('units','normalized','menubar','none','position',[0.35 0.2 0.3 0.45],'Name','SPIKY-Options','NumberTitle','off',...
    'Color',[0.9294 0.9176 0.851],'WindowStyle','modal'); % Create a new figure.

Options_panel=uipanel('units','normalized','position',[0.05 0.16 0.9 0.79],'parent',Options_fig);
Load_panel=uipanel('units','normalized','position',[0.05 0.61 0.9 0.36],'parent',Options_panel,...
    'Title','Load parameters: Please enter filename','FontWeight','bold','FontSize',16);
Save_panel=uipanel('units','normalized','position',[0.05 0.19 0.9 0.36],'parent',Options_panel,...
    'Title','Save parameters: Please enter filename','FontWeight','bold','FontSize',16);
Hints_cb=uicontrol('style','checkbox','units','normalized','position',[0.35 0.05 0.5 0.1],'string','Hints (Tooltips)',...
    'HorizontalAlignment','left','FontSize',13,'parent',Options_panel,'Value',f_para.hints);

Load_Parameters_edit=uicontrol('style','edit','units','normalized','position',[0.1 0.55 0.8 0.3],'FontSize',16,...
    'BackgroundColor',[0.8353 0.8235 0.7922],'BackgroundColor','w','parent',Load_panel,'Enable','off');
Save_Parameters_edit=uicontrol('style','edit','units','normalized','position',[0.1 0.55 0.8 0.3],'FontSize',16,...
    'BackgroundColor',[0.8353 0.8235 0.7922],'BackgroundColor','w','parent',Save_panel,'Enable','off');
Load_Parameters_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.36 0.15 0.28 0.3],'string','Load','FontSize',16,...
    'BackgroundColor',[0.8353 0.8235 0.7922],'parent',Load_panel,'CallBack',{@Load_Parameters_pushbutton_callback},'Enable','off');
Save_Parameters_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.36 0.15 0.28 0.3],'string','Save','FontSize',16,...
    'BackgroundColor',[0.8353 0.8235 0.7922],'parent',Save_panel,'CallBack',{@Save_Parameters_pushbutton_callback},'Enable','off');


Options_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.4 0.04 0.2 0.075],'string','OK','FontSize',16,...
    'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@Options_pushbutton_callback});
uicontrol(Options_pushbutton)

set(Hints_cb,'TooltipString',sprintf('This will display a small hint whenever you hover with the mouse cursor above some SPIKY element.'))
if f_para.hints==1
    set(Load_Parameters_edit,'TooltipString',sprintf('Please enter name for parameter file (without extension.'))
    set(Save_Parameters_edit,'TooltipString',sprintf('Please enter name for parameter file (without extension.'))
    set(Load_Parameters_pushbutton,'TooltipString',sprintf('This will load the parameters saved in the file entered above.'))
    set(Save_Parameters_pushbutton,'TooltipString',sprintf('This will save the parameters to the file entered above.'))
    set(Options_pushbutton,'TooltipString',sprintf('Go back to SPIKY'))
else
    set(Load_Parameters_edit,'TooltipString','')
    set(Save_Parameters_edit,'TooltipString','')
    set(Load_Parameters_pushbutton,'TooltipString','')
    set(Save_Parameters_pushbutton,'TooltipString','')
    set(Options_pushbutton,'TooltipString','')
end

    function Load_Parameters_pushbutton_callback(varargin)
        if isempty(get(Load_Parameters_edit,'String'))
            [d_para.filename,d_para.path]=uigetfile('*.txt','Pick a .txt-file');
            if isequal(d_para.filename,0) || isequal(d_para.path,0)
                return
            end
            load_parameters_filename=[d_para.path d_para.filename];
            set(Load_Parameters_edit,'String',load_parameters_filename)
        else
            load_parameters_filename=get(Load_Parameters_edit,'String');
            if ~exist(load_parameters_filename,'file')
                load_parameters_filename=[get(Load_Parameters_edit,'String'),'.txt'];
            end
        end
        if isempty(get(Load_Parameters_edit,'String')) || ~exist(load_parameters_filename,'file')
            set(0,'DefaultUIControlFontSize',16);
            mbh=msgbox(sprintf('Please enter name for parameter file !'),'Warning','warn','modal');
            htxt = findobj(mbh,'Type','text');
            set(htxt,'FontSize',12,'FontWeight','bold')
            mb_pos=get(mbh,'Position');
            set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
            uiwait(mbh);
            set(Load_Parameters_edit,'String','')
            return
        end

        fid=fopen(load_parameters_filename,'r');

        d_para.tmin=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';','Headerlines',6));
        d_para.tmax=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        d_para.dts=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));

        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        d_para.markers=str2num(cell2mat(dummy{1}));
        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        d_para.thick_markers=str2num(cell2mat(dummy{1}));

        d_para.select_train_mode=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        d_para.preselect_trains=str2num(cell2mat(dummy{1}));
        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        d_para.select_train_groups=str2num(cell2mat(dummy{1}));

        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        cdummy=char(dummy{1});
        indy=[-2 strfind(cdummy,'#$%')];
        for ic=1:length(indy)-1
            d_para.all_train_group_names{ic}=cdummy(indy(ic)+3:indy(ic+1)-1);
        end
        d_para.all_train_group_names=char(d_para.all_train_group_names');
        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        d_para.all_train_group_sizes=str2num(cell2mat(dummy{1}));

        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        d_para.separators=str2num(cell2mat(dummy{1}));
        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        d_para.thick_separators=str2num(cell2mat(dummy{1}));

        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        d_para.comment_string=char(dummy{1});

        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';','Headerlines',3);
        f_para.imagespath=char(dummy{1});
        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        f_para.moviespath=char(dummy{1});
        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        f_para.matpath=char(dummy{1});
        f_para.x_realtime_mode=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        f_para.x_scale=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        f_para.time_unit_string=char(dummy{1});

        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        cdummy=char(dummy{1});
        indy=[-2 strfind(cdummy,'#$%')];
        for ic=1:length(indy)-1
            d_para.interval_names{ic}=cdummy(indy(ic)+3:indy(ic+1)-1);
        end
        d_para.interval_names=char(d_para.interval_names');
        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        d_para.interval_divisions=str2num(cell2mat(dummy{1}));

        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        d_para.instants_str=char(dummy{1});
        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        d_para.selective_averages_str=char(dummy{1});
        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        d_para.triggered_averages_str=char(dummy{1});


        f_para.print_mode=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        f_para.movie_mode=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        f_para.hints=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        f_para.num_fig=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));

        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        f_para.pos_fig=str2num(cell2mat(dummy{1}));
        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        f_para.supo1=str2num(cell2mat(dummy{1}));

        f_para.ma_mode=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        f_para.mao=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));

        f_para.frames_per_second=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        f_para.num_average_frames=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        f_para.plot_mode=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        f_para.profile_mode=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));

        f_para.profile_norm_mode=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        f_para.color_norm_mode=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        f_para.spike_train_color_coding_mode=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));

        f_para.group_matrices=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        f_para.dendrograms=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));
        f_para.histogram=cell2mat(textscan(fid,'%f',1,'commentstyle','%','Delimiter',';'));

        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        f_para.subplot_posi=str2num(cell2mat(dummy{1}));
        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        f_para.subplot_size=str2num(cell2mat(dummy{1}));

        dummy=textscan(fid,'%s',1,'commentstyle','%','Delimiter',';');
        f_para.comment_string=char(dummy{1});

        fclose(fid);

        set(0,'DefaultUIControlFontSize',16);
        mbh=msgbox(['Parameters were loaded from file ',load_parameters_filename],'none','modal');
        htxt = findobj(mbh,'Type','text');
        set(htxt,'FontSize',12,'FontWeight','bold')
        mb_pos=get(mbh,'Position');
        set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
        uiwait(mbh);

        setappdata(handles.figure1,'data_parameters',d_para);
        setappdata(handles.figure1,'figure_parameters',f_para);
    end


    function Save_Parameters_pushbutton_callback(varargin)
        if isempty(get(Save_Parameters_edit,'String'))
            [d_para.filename,d_para.path]=uigetfile('*.txt','Pick a .txt-file');
            if isequal(d_para.filename,0) || isequal(d_para.path,0)
                return
            end
            save_parameters_filename=[d_para.path d_para.filename];
            set(Save_Parameters_edit,'String',save_parameters_filename)
        else
            save_parameters_filename=get(Save_Parameters_edit,'String');
            if ~exist(save_parameters_filename,'file')
                save_parameters_filename=[get(Save_Parameters_edit,'String'),'.txt'];
            end
        end
        if isempty(get(Save_Parameters_edit,'String')) || ~exist(save_parameters_filename,'file')
            set(0,'DefaultUIControlFontSize',16);
            mbh=msgbox(sprintf('Please enter name for parameter file !'),'Warning','warn','modal');
            htxt = findobj(mbh,'Type','text');
            set(htxt,'FontSize',12,'FontWeight','bold')
            mb_pos=get(mbh,'Position');
            set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
            uiwait(mbh);
            set(Save_Parameters_edit,'String','')
            return
        end

        fid=fopen(save_parameters_filename,'w');

        fprintf(fid,'\n%s\n\n','% structure ''Please leave exact structure intact, only edit line by line.');

        fprintf(fid,'\n%s\n\n','% structure ''d_para'': parameters that describe the data');

        fprintf(fid,'%s;\t\t%s\n',num2str(d_para.tmin),'% Beginning of recording');
        fprintf(fid,'%s;\t\t%s\n',num2str(d_para.tmax),'% End of recording');
        fprintf(fid,'%s;\t\t%s\n',num2str(d_para.dts),'% Sampling interval, precision of spike times');

        fprintf(fid,'%s;\t\t%s\n',num2str(d_para.thin_markers),'% Relevant time instants');
        fprintf(fid,'%s;\t\t%s\n',num2str(d_para.thick_markers),'% Even more relevant time instants');

        fprintf(fid,'%s;\t\t%s\n',num2str(d_para.select_train_mode),'% Selection of spike trains (1-all,2-selected groups,3-selected trains)');
        fprintf(fid,'%s;\t\t%s\n',num2str(d_para.preselect_trains),'% Selected spike trains (if ''select_train_mode==3'')');
        fprintf(fid,'%s;\t\t%s\n',num2str(d_para.select_train_groups),'% Selected spike train groups (if ''select_train_mode==2'')');

        cdummy=char(d_para.all_train_group_names);
        sdummy=reshape(cat(2,cdummy,repmat('#$%',size(cdummy,1),1))',1,size(cdummy,1)*(size(cdummy,2)+3));
        fprintf(fid,'%s;\t\t%s\n',sdummy,'% Names of spike train groups');
        fprintf(fid,'%s;\t\t%s\n',num2str(d_para.all_train_group_sizes),'% Sizes of respective spike train groups');

        fprintf(fid,'%s;\t\t%s\n',num2str(d_para.thin_separators),'% Relevant seperations between groups of spike trains');
        fprintf(fid,'%s;\t\t%s\n',num2str(d_para.thick_separators),'% Even more relevant seperations between groups of spike trains');

        fprintf(fid,'%s;\t\t%s\n',d_para.comment_string,'% Additional comment on the example, will be used in file and figure names');


        fprintf(fid,'\n%s\n\n','% structure ''f_para'': parameters that determine the appearance of the figures (and the movie)');

        fprintf(fid,'%s;\t\t%s\n',f_para.imagespath,'% Path where images (postscript) will be stored');
        fprintf(fid,'%s;\t\t%s\n',f_para.moviespath,'% Path where movies (avi) will be stored');
        fprintf(fid,'%s;\t\t%s\n',f_para.matpath,'% Path where Matlab files (mat) will be stored');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.x_realtime_mode),'% X-axis-Realtime-Mode');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.x_scale),'% Conversion of time unit');
        fprintf(fid,'%s;\t\t%s\n',f_para.time_unit_string,'% Time unit, used in x-labels');

        cdummy=char(d_para.interval_names);
        sdummy=reshape(cat(2,cdummy,repmat('#$%',size(cdummy,1),1))',1,size(cdummy,1)*(size(cdummy,2)+3));
        fprintf(fid,'%s;\t\t%s\n',sdummy,'% Names of intervals');
        fprintf(fid,'%s;\t\t%s\n',num2str(d_para.interval_divisions),'% Edges of subsections');

        fprintf(fid,'%s;\t\t%s\n',d_para.instants_str,'% Individual time instants for which the instantaneous dissimilarity values will be calculated');
        fprintf(fid,'%s;\t\t%s\n',d_para.selective_averages_str,'% One or more continuous intervals for selective temporal averaging');
        fprintf(fid,'%s;\t\t%s\n',d_para.triggered_averages_str,'% Non-continuous time-instants for triggered temporal averaging');


        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.print_mode),'% Print to postscript file? (0-no,1-yes)');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.movie_mode),'% Record a movie? (0-no,1-yes)');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.hints),'% Display short hints when hovering over GUI element (0-no,1-yes)');

        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.num_fig),'% Number of figure');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.pos_fig),'% Position of figure (normalized units)');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.supo1),'% Position of axis (normalized units)');

        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.ma_mode),'% Moving average mode: (1-no,2-only,3-both)');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.mao),'% Order of moving average (for piecewise constant measures)');

        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.frames_per_second),'% Well, frames per second for the movie');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.num_average_frames),'% Number of frames the averages are shown at the end of the movie (important for movies with many frames)');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.plot_mode),'% +1:vs time,+2::different measures,+4:different cuts,+8:different cuts-Movie (binary addition allows all combinations)');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.profile_mode),'% 1-All only, 2-Groups only, 3-All and groups');

        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.profile_norm_mode),'% Normalization of averaged bivariate measure profiles (1-Absolute maximum value ''one'',2-Overall maximum value (from 0),3-Individual maximum value (from 0),4-Overall maximum value,5-Individual maximum value)');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.color_norm_mode),'% Normalization of pairwise dissimilarity matrices (1-Absolute maximum value ''one'',2-Overall maximum value (from 0),3-Individual maximum value (from 0),4-Overall maximum value,5-Individual maximum value)');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.spike_train_color_coding_mode),'% Coloring of dendrograms (1-no,2-groups,3-trains)');

        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.group_matrices),'% Allows tracing the overall synchronization among groups of spike trains (0-no,1-yes)');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.dendrograms),'% Cluster trees pairwise dissimilarity matrices (0-no,1-yes)');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.histogram),'% Spike count histogram on the right hand side of the spike trains (0-no,1-yes)');

        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.subplot_posi),'% Vector with order of subplots');
        fprintf(fid,'%s;\t\t%s\n',num2str(f_para.subplot_size),'% Vector with size of subplots');

        fprintf(fid,'%s;\t\t%s\n',f_para.comment_string,'% Additional comment on the example, will be used in file and figure names');
        fclose(fid);

        set(0,'DefaultUIControlFontSize',16);
        mbh=msgbox(['Parameters were saved in file ',save_parameters_filename],'none','modal');
        htxt = findobj(mbh,'Type','text');
        set(htxt,'FontSize',12,'FontWeight','bold')
        mb_pos=get(mbh,'Position');
        set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
        uiwait(mbh);
    end

    function Options_pushbutton_callback(varargin)
        f_para.hints=get(Hints_cb,'Value');
        if f_para.hints
            SPIKY_hints
        else
            SPIKY_hints_no
        end

        setappdata(handles.figure1,'data_parameters',d_para);
        setappdata(handles.figure1,'figure_parameters',f_para);
        close(Options_fig)  % Close secondary figure.
    end

end
