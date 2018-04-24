% This sets the various parameter structures to the values of the various components
% of the graphical user interface SPIKY (somehow inverse to SPIKY_paras_set)

% structure 'd_para': parameters that describe the data

d_para.tmin=str2double(get(handles.dpara_tmin_edit,'String'));
d_para.tmax=str2double(get(handles.dpara_tmax_edit,'String'));
d_para.dts=str2double(get(handles.dpara_dts_edit,'String'));

d_para.thick_markers=str2num(get(handles.dpara_thick_markers_edit,'String'));
d_para.thick_markers=unique(round(d_para.thick_markers(round(d_para.thick_markers/d_para.dts)*d_para.dts>=d_para.tmin & ...
    round(d_para.thick_markers/d_para.dts)*d_para.dts<=d_para.tmax)/d_para.dts)*d_para.dts);
set(handles.dpara_thick_markers_edit,'String',regexprep(num2str(d_para.thick_markers),'\s+',' '))
d_para.thin_markers=str2num(get(handles.dpara_thin_markers_edit,'String'));
d_para.thin_markers=unique(round(d_para.thin_markers(round(d_para.thin_markers/d_para.dts)*d_para.dts>=d_para.tmin & ...
    round(d_para.thin_markers/d_para.dts)*d_para.dts<=d_para.tmax)/d_para.dts)*d_para.dts);
set(handles.dpara_thin_markers_edit,'String',regexprep(num2str(d_para.thin_markers),'\s+',' '))

d_para.select_train_mode=get(handles.dpara_select_train_mode_popupmenu,'Value');
if d_para.select_train_mode==2
    d_para.preselect_trains=round(str2num(get(handles.dpara_trains_edit,'String')));
    d_para.preselect_trains=d_para.preselect_trains(mod(d_para.preselect_trains,1)==0);
    d_para.preselect_trains=d_para.preselect_trains(d_para.preselect_trains>=1 & d_para.preselect_trains<=d_para.num_all_trains);
    set(handles.dpara_trains_edit,'String',regexprep(num2str(d_para.preselect_trains),'\s+',' '))
elseif d_para.select_train_mode==3
    d_para.select_train_groups=round(str2num(get(handles.dpara_train_groups_edit,'String')));
    set(handles.dpara_train_groups_edit,'String',regexprep(num2str(d_para.select_train_groups),'\s+',' '))
end

d_para.thick_separators=str2num(get(handles.dpara_thick_separators_edit,'String'));
d_para.thick_separators=unique(round(d_para.thick_separators(round(d_para.thick_separators)>0 & round(d_para.thick_separators)<d_para.num_all_trains)));
set(handles.dpara_thick_separators_edit,'String',regexprep(num2str(d_para.thick_separators),'\s+',' '))
d_para.thin_separators=str2num(get(handles.dpara_thin_separators_edit,'String'));
d_para.thin_separators=unique(round(d_para.thin_separators(round(d_para.thin_separators)>0 & round(d_para.thin_separators)<d_para.num_all_trains)));
set(handles.dpara_thin_separators_edit,'String',regexprep(num2str(d_para.thin_separators),'\s+',' '))

ds=strtrim(get(handles.dpara_group_names_edit,'String'));
if ~isempty(ds)
    if ds(end)~=';'
        ds=[ds,';'];
    end
    num_all_train_group_names=length(find(ds==';'));
    d_para.all_train_group_names=cell(1,num_all_train_group_names);
    for strc=1:num_all_train_group_names
        d_para.all_train_group_names{strc}=ds(1:find(ds==';',1,'first')-1);
        ds=ds(find(ds==';',1,'first')+2:end);
    end
else
    d_para.all_train_group_names='';
end

d_para.all_train_group_sizes=str2num(get(handles.dpara_group_sizes_edit,'String'));
d_para.all_train_group_sizes=round(d_para.all_train_group_sizes(d_para.all_train_group_sizes>0 & d_para.all_train_group_sizes<=d_para.num_all_trains));
set(handles.dpara_group_sizes_edit,'String',regexprep(num2str(d_para.all_train_group_sizes),'\s+',' '))


d_para.comment_string=get(handles.dpara_comment_edit,'String');

if gco==handles.Calculate_pushbutton || gco==handles.Plot_pushbutton

    d_para.instants_str=strtrim(get(handles.dpara_instants_edit,'String'));
    if ~isempty(d_para.instants_str)
        if exist(d_para.instants_str,'file')
            eval(d_para.instants_str)
            dummy_str='';
            if isfield(d_para,'instants') && ~isempty(d_para.instants)
                dummy_str=num2str(d_para.instants);
            end
        else
            dummy=strtrim(regexp(d_para.instants_str,'([^;]*)','tokens'));
            dummy_str='';
            dummy_num=str2num(char(dummy{1}));
            dummy_num2=dummy_num(dummy_num>=d_para.tmin & dummy_num<=d_para.tmax);
            if ~isempty(dummy_num2)
                d_para.instants=dummy_num2;
                dummy_str=num2str(d_para.instants);
            end
        end
        set(handles.dpara_instants_edit,'String',strtrim(regexprep(dummy_str,'\s+',' ')))
    else
        d_para.instants=[];
    end
    
    
    d_para.selective_averages_str=strtrim(get(handles.dpara_selective_averages_edit,'String'));
    if ~isempty(d_para.selective_averages_str)
        if exist(d_para.selective_averages_str,'file')
            eval(d_para.selective_averages_str)
            dummy_str='';
            if iscell(d_para.selective_averages) && ~isempty(d_para.selective_averages)
                for selc=1:length(d_para.selective_averages)
                    dummy_str=[dummy_str,'[',num2str(d_para.selective_averages{selc}),']; '];
                end
            end
        else
            dummy=strtrim(regexp(d_para.selective_averages_str,'([^;]*)','tokens'));
            %dummy{1}{:}(1)='';
            %dummy{end}{:}(end)='';
            d_para.selective_averages=cell(1,length(dummy));
            dummy_str=''; sac=0;
            for cc=1:length(dummy)
                dummy_num=str2num(char(dummy{cc}));
                dummy_num2=[];
                for cc2=1:length(dummy_num)/2
                    sa_int=dummy_num(cc2*2-1:cc2*2);
                    if sa_int(1)<=d_para.tmax && sa_int(2)>=d_para.tmin
                        dummy_num2=[dummy_num2 max([d_para.tmin sa_int(1)]) min([d_para.tmax sa_int(2)])];
                    end
                end
                if ~isempty(dummy_num2)
                    sac=sac+1;
                    d_para.selective_averages{sac}=dummy_num2;
                    dummy_str=[dummy_str,'[',num2str(d_para.selective_averages{sac}),']; '];
                end
            end
            d_para.selective_averages=d_para.selective_averages(1:sac);
        end
        set(handles.dpara_selective_averages_edit,'String',strtrim(regexprep(dummy_str,'\s+',' ')))
    else
        d_para.selective_averages=[];
    end

    d_para.triggered_averages_str=strtrim(get(handles.dpara_triggered_averages_edit,'String'));
    if ~isempty(d_para.triggered_averages_str)
        if exist(d_para.triggered_averages_str,'file')
            eval(d_para.triggered_averages_str)
            dummy_str='';
            if iscell(d_para.triggered_averages) && ~isempty(d_para.triggered_averages)
                for trigc=1:length(d_para.triggered_averages)
                    dummy_str=[dummy_str,'[',num2str(d_para.triggered_averages{trigc}),']; '];
                end
            end
        else
            dummy=strtrim(regexp(d_para.triggered_averages_str,'([^;]*)','tokens'));
            d_para.triggered_averages=cell(1,length(dummy));
            dummy_str=''; tac=0;
            for cc=1:length(dummy)
                dummy_num=str2num(char(dummy{cc}));
                dummy_num2=dummy_num(dummy_num>=d_para.tmin & dummy_num<=d_para.tmax);
                if ~isempty(dummy_num2)
                    tac=tac+1;
                    d_para.triggered_averages{tac}=dummy_num2;
                    dummy_str=[dummy_str,'[',num2str(d_para.triggered_averages{tac}),']; '];
                end
            end
            d_para.triggered_averages=d_para.triggered_averages(1:tac);
        end
        %dummy{1}{:}(1)='';
        %dummy{end}{:}(end)='';
        set(handles.dpara_triggered_averages_edit,'String',strtrim(regexprep(dummy_str,'\s+',' ')))
    else
        d_para.triggered_averages=[];
    end
    
    if gco==handles.Plot_pushbutton
        d_para.interval_divisions=str2num(get(handles.dpara_interval_divisions_edit,'String'));
        ds=get(handles.dpara_interval_names_edit,'String');
        d_para.interval_names=cell(1,length(find(ds==';')));
        for strc=1:length(find(ds==';'))
            d_para.interval_names{strc}=ds(1:find(ds==';',1,'first')-1);
            ds=ds(find(ds==';',1,'first')+2:end);
        end

        % structure 'f_para': parameters that determine the appearance of the figures (and the movie)
        
        if get(handles.plots_frame_sequence_checkbox,'Value')
            set(handles.plots_frame_comparison_checkbox,'Value',0)
        end
        f_para.plot_mode=get(handles.plots_frame_sequence_checkbox,'Value')*4+...
            get(handles.plots_frame_comparison_checkbox,'Value')*2+get(handles.plots_profiles_checkbox,'Value');
        f_para.profile_mode=get(handles.plots_profiles_popupmenu,'Value');
        f_para.rel_subplot_size=str2num(get(handles.fpara_subplot_size_edit,'String'));
        f_para.show_title=get(handles.fpara_title_checkbox,'Value');
        f_para.x_realtime_mode=get(handles.fpara_x_realtime_mode_checkbox,'Value');
        f_para.extreme_spikes=get(handles.fpara_extreme_spikes_checkbox,'Value');
        f_para.x_offset=str2double(get(handles.fpara_x_offset_edit,'String'));
        f_para.x_scale=str2double(get(handles.fpara_x_scale_edit,'String'));
        f_para.tmin=str2double(get(handles.fpara_tmin_edit,'String'));
        f_para.tmax=str2double(get(handles.fpara_tmax_edit,'String'));
        f_para.select_train_mode=get(handles.fpara_select_train_mode_popupmenu,'Value');
        if f_para.select_train_mode==2
            f_para.select_trains=SPIKY_unique_not_sorted(round(str2num(get(handles.fpara_trains_edit,'String'))));
            if isempty(f_para.select_trains)
                f_para.select_trains=1:f_para.num_all_trains;
            end
            f_para.select_trains=f_para.select_trains(mod(f_para.select_trains,1)==0);
            f_para.select_trains=SPIKY_unique_not_sorted(f_para.select_trains(f_para.select_trains>=1 & f_para.select_trains<=f_para.num_all_trains));
            set(handles.fpara_trains_edit,'String',regexprep(num2str(f_para.select_trains),'\s+',' '))
        elseif f_para.select_train_mode==3
            f_para.select_train_groups=SPIKY_unique_not_sorted(round(str2num(get(handles.fpara_train_groups_edit,'String'))));
            if isempty(f_para.select_trains)
                f_para.select_train_groups=1:f_para.num_all_train_groups;
            end
            set(handles.fpara_train_groups_edit,'String',regexprep(num2str(f_para.select_train_groups),'\s+',' '))
        end
        f_para.ma_mode=get(handles.fpara_moving_average_mode_popupmenu,'Value');
        f_para.mao=str2num(get(handles.fpara_mao_edit,'String'));
        f_para.psth_window=str2num(get(handles.fpara_psth_window_edit,'String'));
        f_para.spike_train_color_coding_mode=get(handles.fpara_spike_train_color_coding_mode_popupmenu,'Value');
        f_para.profile_norm_mode=get(handles.fpara_profile_norm_mode_popupmenu,'Value');
        f_para.profile_average_line=get(handles.fpara_profile_average_line_checkbox,'Value');
        f_para.color_norm_mode=get(handles.fpara_color_norm_mode_popupmenu,'Value');
        f_para.histogram=get(handles.fpara_histogram_checkbox,'Value');
        f_para.group_matrices=get(handles.fpara_group_matrices_checkbox,'Value');
        f_para.dendrograms=get(handles.fpara_dendrograms_checkbox,'Value');
        f_para.colorbar=get(handles.fpara_colorbar_checkbox,'Value');
        f_para.frames_per_second=str2num(get(handles.fpara_frames_per_second_edit,'String'));
        %f_para.num_average_frames=str2num(get(handles.fpara_num_average_frames_edit,'String'));
        f_para.comment_string=get(handles.fpara_comment_edit,'String');
        f_para.title_string=regexprep([d_para.comment_string f_para.comment_string],'_','-');
        
        f_para.print_mode=get(handles.print_figures_checkbox,'Value');
        f_para.movie_mode=get(handles.record_movie_checkbox,'Value');

        if isfield(f_para,'ma_mode') && ~isempty(f_para.ma_mode)
            if f_para.ma_mode==1 s_para.nma=1; elseif f_para.ma_mode==2 s_para.nma=2; else s_para.nma=[1 2]; end %#ok<SEPEX>
        end
        if isfield(f_para,'mao') && ~isempty(f_para.mao)
            s_para.mao=f_para.mao;    % order of the moving average (piecewise profiles)
        end
    end

end

