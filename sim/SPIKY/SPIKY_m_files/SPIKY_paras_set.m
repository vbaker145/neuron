% This initializes the components of the graphical user interface SPIKY to the values
% stored in the various parameter structures (somehow inverse to SPIKY_paras_get)

% structure 'd_para': parameters that describe the data

set(handles.dpara_tmin_edit,'String',num2str(d_para.tmin),'Enable','on')
set(handles.dpara_tmax_edit,'String',num2str(d_para.tmax),'Enable','on')
set(handles.dpara_dts_edit,'String',num2str(d_para.dts),'Enable','on')
d_para.thick_markers=unique(round(d_para.thick_markers(round(d_para.thick_markers/d_para.dts)*d_para.dts>=d_para.tmin & ...
    round(d_para.thick_markers/d_para.dts)*d_para.dts<=d_para.tmax)/d_para.dts)*d_para.dts);
set(handles.dpara_thick_markers_edit,'String',regexprep(num2str(d_para.thick_markers),'\s+',' '),'Enable','on')
d_para.thin_markers=unique(round(d_para.thin_markers(round(d_para.thin_markers/d_para.dts)*d_para.dts>=d_para.tmin & ...
    round(d_para.thin_markers/d_para.dts)*d_para.dts<=d_para.tmax)/d_para.dts)*d_para.dts);
set(handles.dpara_thin_markers_edit,'String',regexprep(num2str(d_para.thin_markers),'\s+',' '),'Enable','on')
set(handles.dpara_select_train_mode_popupmenu,'Value',d_para.select_train_mode,'Enable','on')
if get(handles.dpara_select_train_mode_popupmenu,'Value')==1
    set(handles.dpara_train_groups_edit,'Enable','off')
    set(handles.dpara_select_train_groups_pushbutton,'Enable','off')
    set(handles.dpara_trains_edit,'String','','Enable','off')
    set(handles.dpara_select_trains_pushbutton,'Enable','off')
elseif get(handles.dpara_select_train_mode_popupmenu,'Value')==2
    set(handles.dpara_trains_edit,'String',regexprep(num2str(d_para.preselect_trains),'\s+',' '),'Enable','on')
    set(handles.dpara_select_trains_pushbutton,'Enable','on')
    set(handles.dpara_train_groups_edit,'String','','Enable','off')
    set(handles.dpara_select_train_groups_pushbutton,'Enable','off')
else
    set(handles.dpara_trains_edit,'String','','Enable','off')
    set(handles.dpara_select_trains_pushbutton,'Enable','off')
    set(handles.dpara_train_groups_edit,'String',regexprep(num2str(d_para.select_train_groups(d_para.select_train_groups<=...
        d_para.num_all_train_groups)),'\s+',' '),'Enable','on')
    set(handles.dpara_select_train_groups_pushbutton,'Enable','on')
end

dpara_all_train_group_names_str='';
for strc=1:numel(d_para.all_train_group_names)
    dpara_all_train_group_names_str=[dpara_all_train_group_names_str,char(d_para.all_train_group_names{strc}),'; '];
end

dpara_all_train_group_names_str=regexprep(dpara_all_train_group_names_str,';\s+','; ');
set(handles.dpara_group_names_edit,'String',regexprep(dpara_all_train_group_names_str,'\s+',' '),'Enable','on')
set(handles.dpara_group_sizes_edit,'String',regexprep(num2str(d_para.all_train_group_sizes),'\s+',' '),'Enable','on')
d_para.thin_separators=d_para.thin_separators(mod(d_para.thin_separators,1)==0);
d_para.thin_separators=unique(d_para.thin_separators(d_para.thin_separators>0 & d_para.thin_separators<d_para.num_all_trains));
set(handles.dpara_thin_separators_edit,'String',regexprep(num2str(d_para.thin_separators),'\s+',' '),'Enable','on')
d_para.thick_separators=d_para.thick_separators(mod(d_para.thick_separators,1)==0);
d_para.thick_separators=unique(d_para.thick_separators(d_para.thick_separators>0 & d_para.thick_separators<d_para.num_all_trains));
set(handles.dpara_thick_separators_edit,'String',regexprep(num2str(d_para.thick_separators),'\s+',' '),'Enable','on')
set(handles.dpara_interval_divisions_edit,'String',regexprep(num2str(d_para.interval_divisions),'\s+',' '),'Enable','on')
%set(handles.dpara_interval_names_edit,'String',regexprep(d_para.interval_names,'\s+',' '),'Enable','on')
%set(handles.dpara_interval_names_edit,'String',char(regexprep(d_para.interval_names,'\s+',' ')),'Enable','on')
dpara_interval_names_str='';
for strc=1:numel(d_para.interval_names)
    dpara_interval_names_str=[dpara_interval_names_str,char(d_para.interval_names{strc}),'; '];
end
dpara_interval_names_str=regexprep(dpara_interval_names_str,';\s+','; ');
set(handles.dpara_interval_names_edit,'String',regexprep(dpara_interval_names_str,'\s+',' '),'Enable','on')
set(handles.dpara_comment_edit,'String',d_para.comment_string,'Enable','on')


if ~isempty(d_para.instants_str)
    if d_para.instants_str(1)=='{'
        d_para.instants_str=d_para.instants_str(2:end);
    end
    if d_para.instants_str(end)=='}'
        d_para.instants_str=d_para.instants_str(1:end-1);
    end
    set(handles.dpara_instants_edit,'String',strtrim(regexprep(d_para.instants_str,'\s+',' ')),'Enable','on')
elseif isfield (d_para,'instants') && ~isempty(d_para.instants)
    instants_str=regexprep(num2str(d_para.instants),'\s+',' ');
    set(handles.dpara_instants_edit,'String',strtrim(instants_str));
end


if ~isempty(d_para.selective_averages_str)
    if d_para.selective_averages_str(1)=='{'
        d_para.selective_averages_str=d_para.selective_averages_str(2:end);
    end
    if d_para.selective_averages_str(end)=='}'
        d_para.selective_averages_str=d_para.selective_averages_str(1:end-1);
    end
    set(handles.dpara_selective_averages_edit,'String',strtrim(regexprep(d_para.selective_averages_str,'\s+',' ')),'Enable','on')
elseif isfield(d_para,'selective_averages') && ~isempty(d_para.selective_averages)
    sel_str=[];
    for selc=1:length(d_para.selective_averages)
        sel_str=[sel_str,'[',regexprep(num2str(d_para.selective_averages{selc}),'\s+',' '),']; '];
    end
    set(handles.dpara_selective_averages_edit,'String',strtrim(sel_str));
end
if ~isempty(d_para.triggered_averages_str)
    if d_para.triggered_averages_str(1)=='{'
        d_para.triggered_averages_str=d_para.triggered_averages_str(2:end);
    end
    if d_para.triggered_averages_str(end)=='}'
        d_para.triggered_averages_str=d_para.triggered_averages_str(1:end-1);
    end
    set(handles.dpara_triggered_averages_edit,'String',strtrim(regexprep(d_para.triggered_averages_str,'\s+',' ')),'Enable','on')
elseif isfield (d_para,'triggered_averages') && ~isempty(d_para.triggered_averages)
    trig_str=[];
    for trigc=1:length(d_para.triggered_averages)
        trig_str=[trig_str,'[',regexprep(num2str(d_para.triggered_averages{trigc}),'\s+',' '),']; '];
    end
    set(handles.dpara_triggered_averages_edit,'String',strtrim(trig_str));
end


% Panel 'Selection: Measures'

set(handles.subplot_stimulus_posi_edit,'String',num2str(f_para.subplot_posi(1)))
set(handles.subplot_spikes_posi_edit,'String',num2str(f_para.subplot_posi(2)))
set(handles.subplot_psth_posi_edit,'String',num2str(f_para.subplot_posi(3)))
set(handles.subplot_isi_posi_edit,'String',num2str(f_para.subplot_posi(4)))
set(handles.subplot_spike_posi_edit,'String',num2str(f_para.subplot_posi(5)))
set(handles.subplot_spike_realtime_posi_edit,'String',num2str(f_para.subplot_posi(6)))
set(handles.subplot_spike_forward_posi_edit,'String',num2str(f_para.subplot_posi(7)))
set(handles.subplot_spikesync_posi_edit,'String',num2str(f_para.subplot_posi(8)))
set(handles.subplot_spikeorder_posi_edit,'String',num2str(f_para.subplot_posi(9)))

% Panel 'Selection: Plots'

set(handles.plots_profiles_checkbox,'Value',mod(f_para.plot_mode,2)>0)
set(handles.plots_frame_comparison_checkbox,'Value',mod(f_para.plot_mode,4)>1)
set(handles.plots_frame_sequence_checkbox,'Value',mod(f_para.plot_mode,8)>3)
set(handles.plots_profiles_popupmenu,'Value',f_para.profile_mode)
set(handles.fpara_histogram_checkbox,'Value',f_para.histogram)
set(handles.fpara_group_matrices_checkbox,'Value',f_para.group_matrices)
set(handles.fpara_dendrograms_checkbox,'Value',f_para.dendrograms)
set(handles.fpara_colorbar_checkbox,'Value',f_para.colorbar)

% structure 'f_para': parameters that determine the appearance of the figures (and the movie)

set(handles.fpara_tmin_edit,'String',num2str(d_para.tmin))
set(handles.fpara_tmax_edit,'String',num2str(d_para.tmax))
set(handles.fpara_select_train_mode_popupmenu,'Value',1,'Enable','on')
set(handles.fpara_trains_edit,'String',[],'Enable','off')
set(handles.fpara_train_groups_edit,'String',[],'Enable','off')
%dummy=f_para.subplot_posi(f_para.subplot_posi>0);
%set(handles.fpara_subplot_size_edit,'String',regexprep(num2str(dummy),'\s+',' '))
set(handles.fpara_subplot_size_edit,'String',regexprep(num2str(f_para.rel_subplot_size),'\s+',' '))
set(handles.fpara_title_checkbox,'Value',f_para.show_title)
set(handles.fpara_x_realtime_mode_checkbox,'Value',f_para.x_realtime_mode)
set(handles.fpara_extreme_spikes_checkbox,'Value',f_para.extreme_spikes)
set(handles.fpara_x_offset_edit,'String',num2str(f_para.x_offset))
set(handles.fpara_x_scale_edit,'String',num2str(f_para.x_scale))
set(handles.fpara_moving_average_mode_popupmenu,'Value',f_para.ma_mode)
set(handles.fpara_mao_edit,'String',num2str(f_para.mao))
set(handles.fpara_psth_window_edit,'String',num2str(f_para.psth_window))
set(handles.fpara_spike_train_color_coding_mode_popupmenu,'Value',f_para.spike_train_color_coding_mode)
set(handles.fpara_profile_norm_mode_popupmenu,'Value',f_para.profile_norm_mode)
set(handles.fpara_profile_average_line_checkbox,'Value',f_para.profile_average_line)
set(handles.fpara_color_norm_mode_popupmenu,'Value',f_para.color_norm_mode)

set(handles.fpara_frames_per_second_edit,'String',num2str(f_para.frames_per_second))
%set(handles.fpara_num_average_frames_edit,'String',num2str(f_para.num_average_frames))
set(handles.fpara_comment_edit,'String',f_para.comment_string)

set(handles.print_figures_checkbox,'Value',f_para.print_mode)
set(handles.record_movie_checkbox,'Value',f_para.movie_mode)

