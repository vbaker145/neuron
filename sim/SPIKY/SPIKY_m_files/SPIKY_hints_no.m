% This disables the short hints (tooltip strings) that are displayed when the mouse hovers
% above an element of the graphical user interface SPIKY
% (if 'Hints (Tooltips)' is not selected in the 'Options' menu).
%
% #########################################################################
%     Selection: Data
% ######################################
%
set(handles.Data_listbox,'TooltipString','')
set(handles.List_pushbutton,'TooltipString','')
set(handles.Workspace_pushbutton,'TooltipString','')
set(handles.Event_Detector_pushbutton,'TooltipString','')
set(handles.Generator_pushbutton,'TooltipString','')
%
% #########################################################################
%     Parameters: Data - Time
% ######################################
%
set(handles.dpara_tmin_edit,'TooltipString','')
set(handles.dpara_tmin_text,'TooltipString',get(handles.dpara_tmin_edit,'TooltipString'))
set(handles.dpara_tmax_edit,'TooltipString','')
set(handles.dpara_tmax_text,'TooltipString',get(handles.dpara_tmax_edit,'TooltipString'))

set(handles.dpara_dts_edit,'TooltipString','')
set(handles.dpara_dts_text1,'TooltipString',get(handles.dpara_dts_edit,'TooltipString'))
set(handles.dpara_dts_text2,'TooltipString',get(handles.dpara_dts_edit,'TooltipString'))

set(handles.dpara_thick_markers_edit,'TooltipString','')
set(handles.dpara_thick_markers_text,'TooltipString',get(handles.dpara_thick_markers_edit,'TooltipString'))
set(handles.dpara_thin_markers_edit,'TooltipString','')
set(handles.dpara_thin_markers_text,'TooltipString',get(handles.dpara_thin_markers_edit,'TooltipString'))
set(handles.SM_pushbutton,'TooltipString','')
%
% ######################################
%     Parameters: Data - Spike trains
% ######################################
%
set(handles.dpara_select_train_mode_popupmenu,'TooltipString','')
set(handles.dpara_select_train_mode_text,'TooltipString',get(handles.dpara_select_train_mode_popupmenu,'TooltipString'))
set(handles.dpara_trains_edit,'TooltipString','')
set(handles.dpara_trains_text,'TooltipString',get(handles.dpara_trains_edit,'TooltipString'))
set(handles.dpara_train_groups_edit,'TooltipString','')
set(handles.dpara_train_groups_text,'TooltipString',get(handles.dpara_train_groups_edit,'TooltipString'))
set(handles.dpara_select_trains_pushbutton,'TooltipString','')
set(handles.dpara_select_train_groups_pushbutton,'TooltipString','')

set(handles.dpara_thick_separators_edit,'TooltipString','')
set(handles.dpara_thick_separators_text,'TooltipString',get(handles.dpara_thick_separators_edit,'TooltipString'))
set(handles.dpara_thin_separators_edit,'TooltipString','')
set(handles.dpara_thin_separators_text,'TooltipString',get(handles.dpara_thin_separators_edit,'TooltipString'))
set(handles.SS_pushbutton,'TooltipString','')

set(handles.dpara_group_names_edit,'TooltipString','')
set(handles.dpara_group_names_text,'TooltipString',get(handles.dpara_group_names_edit,'TooltipString'))
set(handles.dpara_group_sizes_edit,'TooltipString','')
set(handles.dpara_group_sizes_text,'TooltipString',get(handles.dpara_group_sizes_edit,'TooltipString'))
set(handles.SG_pushbutton,'TooltipString','')
%
% ######################################
%     Parameters: Data
% ######################################
%
set(handles.dpara_comment_edit,'TooltipString','')
set(handles.dpara_comment_text,'TooltipString',get(handles.dpara_comment_edit,'TooltipString'))
set(handles.Update_pushbutton,'TooltipString','')
%
% #########################################################################
%     Selection: Measures I
% ######################################
%
set(handles.subplot_stimulus_posi_edit,'TooltipString','')
set(handles.subplot_stimulus_posi_text,'TooltipString',get(handles.subplot_stimulus_posi_edit,'TooltipString'))
set(handles.subplot_spikes_posi_edit,'TooltipString','')
set(handles.subplot_spikes_posi_text,'TooltipString',get(handles.subplot_spikes_posi_edit,'TooltipString'))
set(handles.subplot_psth_posi_edit,'TooltipString','')
set(handles.subplot_psth_posi_text,'TooltipString',get(handles.subplot_psth_posi_edit,'TooltipString'))

set(handles.subplot_isi_posi_edit,'TooltipString','')
set(handles.subplot_isi_posi_text,'TooltipString',get(handles.subplot_isi_posi_edit,'TooltipString'))
set(handles.subplot_spike_posi_edit,'TooltipString','')
set(handles.subplot_spike_posi_text,'TooltipString',get(handles.subplot_spike_posi_edit,'TooltipString'))
set(handles.subplot_spike_realtime_posi_edit,'TooltipString','')
set(handles.subplot_spike_realtime_posi_text,'TooltipString',get(handles.subplot_spike_realtime_posi_edit,'TooltipString'))
set(handles.subplot_spike_forward_posi_edit,'TooltipString','')
set(handles.subplot_spike_forward_posi_text,'TooltipString',get(handles.subplot_spike_forward_posi_edit,'TooltipString'))
set(handles.subplot_spikesync_posi_edit,'TooltipString','')
set(handles.subplot_spikesync_posi_text,'TooltipString',get(handles.subplot_spikesync_posi_edit,'TooltipString'))
set(handles.subplot_spikeorder_posi_edit,'TooltipString','')
set(handles.subplot_spikeorder_posi_text,'TooltipString',get(handles.subplot_spikeorder_posi_edit,'TooltipString'))
%
% ######################################
%     Selection: Measures II
% ######################################
%
set(handles.dpara_instants_text,'TooltipString','')
set(handles.dpara_instants_edit,'TooltipString',get(handles.dpara_instants_text,'TooltipString'))
set(handles.dpara_selective_averages_text,'TooltipString','')
set(handles.dpara_selective_averages_edit,'TooltipString',get(handles.dpara_selective_averages_text,'TooltipString'))
set(handles.dpara_triggered_averages_text,'TooltipString','')
set(handles.dpara_triggered_averages_edit,'TooltipString',get(handles.dpara_triggered_averages_text,'TooltipString'))
set(handles.SIA_pushbutton,'TooltipString','')

set(handles.Calculate_pushbutton,'TooltipString','')
set(handles.STO_pushbutton,'TooltipString','')
%
% #########################################################################
%     Selection: Plots - Type
% ######################################
%
set(handles.plots_profiles_checkbox,'TooltipString','')
set(handles.plots_profiles_popupmenu,'TooltipString','')
set(handles.fpara_profile_average_line_checkbox,'TooltipString','')
set(handles.fpara_histogram_checkbox,'TooltipString','')
set(handles.fpara_group_matrices_checkbox,'TooltipString','')
set(handles.fpara_dendrograms_checkbox,'TooltipString','')
set(handles.plots_frame_comparison_checkbox,'TooltipString','')
set(handles.plots_frame_sequence_checkbox,'TooltipString','')
set(handles.fpara_colorbar_checkbox,'TooltipString','')
%
% ######################################
%     Selection: Plots - Time
% ######################################
%
set(handles.fpara_tmin_edit,'TooltipString','')
set(handles.fpara_tmin_text,'TooltipString',get(handles.fpara_tmin_edit,'TooltipString'))
set(handles.fpara_tmax_edit,'TooltipString','')
set(handles.fpara_tmax_text,'TooltipString',get(handles.fpara_tmax_edit,'TooltipString'))
%
% ######################################
%     Selection: Plots - Spike trains
% ######################################
%
set(handles.fpara_select_train_mode_popupmenu,'TooltipString','')
set(handles.fpara_select_train_mode_text,'TooltipString',get(handles.fpara_select_train_mode_popupmenu,'TooltipString'))
set(handles.fpara_trains_edit,'TooltipString','')
set(handles.fpara_trains_text,'TooltipString',get(handles.fpara_trains_edit,'TooltipString'))
set(handles.fpara_train_groups_edit,'TooltipString','')
set(handles.fpara_train_groups_text,'TooltipString',get(handles.fpara_train_groups_edit,'TooltipString'))
set(handles.fpara_select_trains_pushbutton,'TooltipString','')
set(handles.fpara_select_train_groups_pushbutton,'TooltipString','')

set(handles.Plot_pushbutton,'TooltipString','')
%
% #########################################################################
%     Parameters: Figure
% ######################################
%
set(handles.fpara_subplot_size_edit,'TooltipString','')
set(handles.fpara_subplot_size_text,'TooltipString',get(handles.fpara_subplot_size_edit,'TooltipString'))
%
% ######################################
%     Parameters: Figure - Time axis
% ######################################
%
set(handles.fpara_x_realtime_mode_checkbox,'TooltipString','')
set(handles.fpara_extreme_spikes_checkbox,'TooltipString','')
set(handles.fpara_x_offset_edit,'TooltipString','')
set(handles.fpara_x_offset_text,'TooltipString',get(handles.fpara_x_offset_edit,'TooltipString'))
set(handles.fpara_x_scale_edit,'TooltipString','')
set(handles.fpara_x_scale_text,'TooltipString',get(handles.fpara_x_scale_edit,'TooltipString'))
%
% ###########################################
%     Parameters: Figure - Moving Average
% ###########################################
%
set(handles.fpara_moving_average_mode_popupmenu,'TooltipString','')
set(handles.fpara_moving_average_mode_text,'TooltipString',get(handles.fpara_moving_average_mode_popupmenu,'TooltipString'))
set(handles.fpara_mao_edit,'TooltipString','')
set(handles.fpara_mao_text,'TooltipString',get(handles.fpara_mao_edit,'TooltipString'))
set(handles.fpara_psth_window_edit,'TooltipString','')
set(handles.fpara_psth_window_text,'TooltipString',get(handles.fpara_psth_window_edit,'TooltipString'))
%
% ######################################
%     Parameters: Figure
% ######################################
%
set(handles.fpara_spike_train_color_coding_mode_popupmenu,'TooltipString','')
set(handles.fpara_spike_train_color_coding_mode_text1,'TooltipString',get(handles.fpara_spike_train_color_coding_mode_popupmenu,'TooltipString'))
set(handles.fpara_spike_train_color_coding_mode_text2,'TooltipString',get(handles.fpara_spike_train_color_coding_mode_popupmenu,'TooltipString'))
set(handles.fpara_profile_norm_mode_popupmenu,'TooltipString','')
set(handles.fpara_profile_norm_mode_text1,'TooltipString',get(handles.fpara_profile_norm_mode_popupmenu,'TooltipString'))
set(handles.fpara_profile_norm_mode_text2,'TooltipString',get(handles.fpara_profile_norm_mode_popupmenu,'TooltipString'))
set(handles.fpara_color_norm_mode_popupmenu,'TooltipString','')
set(handles.fpara_color_norm_mode_text1,'TooltipString',get(handles.fpara_color_norm_mode_popupmenu,'TooltipString'))
set(handles.fpara_color_norm_mode_text2,'TooltipString',get(handles.fpara_color_norm_mode_popupmenu,'TooltipString'))

set(handles.fpara_comment_edit,'TooltipString','')
set(handles.fpara_comment_text,'TooltipString',get(handles.fpara_comment_edit,'TooltipString'))
%
% #########################################################################
%     Parameters: Movie
% ######################################
%
set(handles.fpara_frames_per_second_edit,'TooltipString','')
set(handles.fpara_frames_per_second_text,'TooltipString',get(handles.fpara_frames_per_second_edit,'TooltipString'))
%set(handles.fpara_num_average_frames_edit,'TooltipString','')
%set(handles.fpara_num_average_frames_text,'TooltipString',get(handles.fpara_num_average_frames_edit,'TooltipString'))

set(handles.dpara_interval_divisions_edit,'TooltipString','')
set(handles.dpara_interval_divisions_text,'TooltipString',get(handles.dpara_interval_divisions_edit,'TooltipString'))
set(handles.dpara_interval_names_edit,'TooltipString','')
set(handles.dpara_interval_names_text,'TooltipString',get(handles.dpara_interval_names_edit,'TooltipString'))
%
% ######################################
%     Movie Console
% ######################################
%
set(handles.Movie_frame_slider,'TooltipString','')
set(handles.Movie_first_text,'TooltipString','')
set(handles.Movie_last_text,'TooltipString','')
set(handles.Movie_current_text,'TooltipString','')
set(handles.Movie_first_pushbutton,'TooltipString','')
set(handles.Movie_play_pushbutton,'TooltipString','')
set(handles.Movie_stop_pushbutton,'TooltipString','')
set(handles.Movie_last_pushbutton,'TooltipString','')

set(handles.Movie_speed_slider,'TooltipString','')

set(handles.Movie_backward_radiobutton,'TooltipString','')
set(handles.Movie_forward_radiobutton,'TooltipString','')

set(handles.print_figures_checkbox,'TooltipString','')
set(handles.record_movie_checkbox,'TooltipString','')
