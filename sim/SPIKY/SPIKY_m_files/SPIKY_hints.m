% This sets the short hints (tooltip strings) that are displayed when the mouse hovers
% above an element of the graphical user interface SPIKY
% (if 'Hints (Tooltips)' is selected in the 'Options' menu).
%
% #########################################################################
%     Selection: Data
% ######################################
%
set(handles.Data_listbox,'TooltipString',sprintf('Select one of the pre-defined examples.\n You can also add your own examples via the Matlab function "SPIKY_f_generate_spikes".'))
set(handles.List_pushbutton,'TooltipString',sprintf('Loads the example selected in the listbox.\n Once the spike trains are created the "Parameters: Data" panel is activated.'))
set(handles.Workspace_pushbutton,'TooltipString','Another way to select data:\n Loads Matlab variable from the workspace.')
set(handles.Event_Detector_pushbutton,'TooltipString',sprintf('Another way to select data: Opens new window in which it is possible\n to detect discrete events from continuous data.'))
set(handles.Generator_pushbutton,'TooltipString',sprintf('Another way to select data:\n Starts spike train generator in a new window.\n Once the spike trains are created the "Parameters: Data" panel is activated.'))
%
% #########################################################################
%     Parameters: Data - Time
% ######################################
%
set(handles.dpara_tmin_edit,'TooltipString',sprintf('Beginning of the recording/simulation.'))
set(handles.dpara_tmin_text,'TooltipString',get(handles.dpara_tmin_edit,'TooltipString'))
set(handles.dpara_tmax_edit,'TooltipString',sprintf('Termination of the recording/simulation.'))
set(handles.dpara_tmax_text,'TooltipString',get(handles.dpara_tmax_edit,'TooltipString'))

set(handles.dpara_dts_edit,'TooltipString',sprintf('Defines the temporal resolution of the recording/simulation.'))
set(handles.dpara_dts_text1,'TooltipString',get(handles.dpara_dts_edit,'TooltipString'))
set(handles.dpara_dts_text2,'TooltipString',get(handles.dpara_dts_edit,'TooltipString'))

set(handles.dpara_thick_markers_edit,'TooltipString',sprintf('Defines individual moments in time which will be marked by another kind of (typically thick) line.\n Use Matlab syntax, e.g. "10 100" or "10:10:100" (without the apostrophes).'))
set(handles.dpara_thick_markers_text,'TooltipString',get(handles.dpara_thick_markers_edit,'TooltipString'))
set(handles.dpara_thin_markers_edit,'TooltipString',sprintf('Defines individual moments in time which will be marked by one kind of (typically thin) line.\n Use Matlab syntax, e.g. "10 100" or "10:10:100" (without the apostrophes).'))
set(handles.dpara_thin_markers_text,'TooltipString',get(handles.dpara_thin_markers_edit,'TooltipString'))
set(handles.SM_pushbutton,'TooltipString',sprintf('This opens a graphical input form which lets you select either via keyboard or via mouse\n the time instants for the thick and the thin markers.'))
%
% ######################################
%     Parameters: Data - Spike trains
% ######################################
%
set(handles.dpara_select_train_mode_popupmenu,'TooltipString',sprintf('This allows you to select a subset of spike trains or spike train groups for which the spike train distances will be calculated.\n Since the computational cost scales with the squared number of spike trains (N^2),\n it can save a considerable amount of computation time to exclude spike trains that are not really needed from the calculation.'))
set(handles.dpara_select_train_mode_text,'TooltipString',get(handles.dpara_select_train_mode_popupmenu,'TooltipString'))
set(handles.dpara_trains_edit,'TooltipString',sprintf('If "Select trains" is selected, you can either identify the spike trains directly using Matlab notation or use the bottom below and select them from a list.\n Use Matlab syntax, e.g. "2 10" or "2:2:10" (without the apostrophes).'))
set(handles.dpara_trains_text,'TooltipString',get(handles.dpara_trains_edit,'TooltipString'))
set(handles.dpara_train_groups_edit,'TooltipString',sprintf('If "Select groups" is selected, you can either identify the spike train groups directly using Matlab notation or use the bottom below and select them from a list.\n Use Matlab syntax, e.g. "2 10" or "2:2:10" (without the apostrophes).'))
set(handles.dpara_train_groups_text,'TooltipString',get(handles.dpara_train_groups_edit,'TooltipString'))
set(handles.dpara_select_trains_pushbutton,'TooltipString',sprintf('This allows you to select the spike trains for which you would like to calculate the spike train distances from a list.'))
set(handles.dpara_select_train_groups_pushbutton,'TooltipString',sprintf('This allows you to select the spike train groups you would like to calculate the spike train distances from a list.'))

set(handles.dpara_thick_separators_edit,'TooltipString',sprintf('Defines lines between spike trains which will be marked by another kind of (typically thick) line.\n Use Matlab syntax, e.g. "2 10" or "2:2:10" (without the apostrophes).'))
set(handles.dpara_thick_separators_text,'TooltipString',get(handles.dpara_thick_separators_edit,'TooltipString'))
set(handles.dpara_thin_separators_edit,'TooltipString',sprintf('Defines lines between spike trains which will be marked by another kind of (typically thin) line.\n Use Matlab syntax, e.g. "2 10" or "2:2:10" (without the apostrophes).'))
set(handles.dpara_thin_separators_text,'TooltipString',get(handles.dpara_thin_separators_edit,'TooltipString'))
set(handles.SS_pushbutton,'TooltipString',sprintf('This opens a graphical input form which lets you select either via keyboard or via mouse\n the thick and thin separators between spike train groups.'))

set(handles.dpara_group_sizes_edit,'TooltipString',sprintf('Then identify their sizes using Matlab notation, e.g. "10 10 10 10" (without the apostrophes).\n Numbers should add up to the total number of spike trains.'))
set(handles.dpara_group_sizes_text,'TooltipString',get(handles.dpara_group_sizes_edit,'TooltipString'))
set(handles.dpara_group_names_edit,'TooltipString',sprintf('Before you can select spike train groups you should define them here.\n Identify their names each separated by ";" and a space as well as ending with a ";", e.g. "G1; G2; G3; G4;" (without the apostrophes).'))
set(handles.dpara_group_names_text,'TooltipString',get(handles.dpara_group_names_edit,'TooltipString'))
set(handles.SG_pushbutton,'TooltipString',sprintf('This opens a graphical input form which lets you select either via keyboard or via mouse\n the separators between spike train groups (which define the sizes of these groups).\n Subsequently you will be asked to name the groups.'))
%
% ######################################
%     Parameters: Data
% ######################################
%
set(handles.dpara_comment_edit,'TooltipString',sprintf('Data-comment, will be part of the file names (ps-images and avi-movies).'))
set(handles.dpara_comment_text,'TooltipString',get(handles.dpara_comment_edit,'TooltipString'))
set(handles.Update_pushbutton,'TooltipString',sprintf('This confirms all selections made in this panel.\n At the same time the "Selection: Measures" panel is activated.'))
%
% #########################################################################
%     Selection: Measures I
% ######################################
%
set(handles.subplot_stimulus_posi_edit,'TooltipString',sprintf('This will add a subplot with a graphical representation of the stimulus.'))
set(handles.subplot_stimulus_posi_text,'TooltipString',get(handles.subplot_stimulus_posi_edit,'TooltipString'))
set(handles.subplot_spikes_posi_edit,'TooltipString',sprintf('This will add a subplot with the spike rasterplot in which\n for each spike train (y-axis) the times (x-axis) of the spikes are marked by vertical lines.'))
set(handles.subplot_spikes_posi_text,'TooltipString',get(handles.subplot_spikes_posi_edit,'TooltipString'))
set(handles.subplot_psth_posi_edit,'TooltipString',sprintf('This will add a subplot with the peristimulus time histogram. The PSTH can be smoothed with a Gaussian filter of desired kernel width.'))
set(handles.subplot_psth_posi_text,'TooltipString',get(handles.subplot_psth_posi_edit,'TooltipString'))

set(handles.subplot_isi_posi_edit,'TooltipString',sprintf('This selects the ISI-distance whose dissimilarity profile is piecewise constant.'))
set(handles.subplot_isi_posi_text,'TooltipString',get(handles.subplot_isi_posi_edit,'TooltipString'))
set(handles.subplot_spike_posi_edit,'TooltipString',sprintf('This selects the SPIKE-distance whose dissimilarity profile is piecewise linear.'))
set(handles.subplot_spike_posi_text,'TooltipString',get(handles.subplot_spike_posi_edit,'TooltipString'))
set(handles.subplot_spike_realtime_posi_edit,'TooltipString',sprintf('This selects the realtime variant of the SPIKE-distance with a piecewise constant dissimilarity profile.\n The instantaneous values rely on past information only.'))
set(handles.subplot_spike_realtime_posi_text,'TooltipString',get(handles.subplot_spike_realtime_posi_edit,'TooltipString'))
set(handles.subplot_spike_forward_posi_edit,'TooltipString',sprintf('This selects the forward variant of the SPIKE-distance with a piecewise constant dissimilarity profile. The instantaneous values rely on future information only which can be useful for triggered averages in order to evaluate the causal effect of certain external (stimulus) or internal (spikes) features on the future spiking. For a description of this spike train distance refer to the third paper cited at the end.'))
set(handles.subplot_spike_forward_posi_text,'TooltipString',get(handles.subplot_spike_forward_posi_edit,'TooltipString'))
set(handles.subplot_spikesync_posi_edit,'TooltipString',sprintf('This selects spike synchronization whose dissimilarity values are only defined at the times of the spikes.'))
set(handles.subplot_spikesync_posi_text,'TooltipString',get(handles.subplot_spikesync_posi_edit,'TooltipString'))
set(handles.subplot_spikeorder_posi_edit,'TooltipString',sprintf('This selects spike order whose directionality values are only defined at the times of the spikes.'))
set(handles.subplot_spikeorder_posi_text,'TooltipString',get(handles.subplot_spikeorder_posi_edit,'TooltipString'))
%
% ######################################
%     Selection: Measures II
% ######################################
%
set(handles.dpara_instants_text,'TooltipString',sprintf('Here you can select the individual time instants for which the instantaneous dissimilarity values will be calculated.\n Selected instants must be within the interval selected in the subpanel "Time" from the previous panel.\n Please use Matlab notation, for example is you wish to have a value for each sample point\n just write tmin:dts:tmax with tmin, tmax, and dts being the values from the subpanel "Time" from the previous panel.'))
set(handles.dpara_instants_edit,'TooltipString',get(handles.dpara_instants_text,'TooltipString'))
set(handles.dpara_selective_averages_text,'TooltipString',sprintf('Here you can select the time intervals over which you would like to average.\n Please use Matlab notation (for an example check the fifth entry in the listbox from the "Selection: Data" panel).\n In case you would like to use data-dependent averages you can also put the name of a Matlab file which will be executed before the calculation.'))
set(handles.dpara_selective_averages_edit,'TooltipString',get(handles.dpara_selective_averages_text,'TooltipString'))
set(handles.dpara_triggered_averages_text,'TooltipString',sprintf('Here you can select the time instants over which you would like to calculate a triggered average.\n Please use Matlab notation (for an example check the fifth entry in the listbox from the "Selection: Data" panel).\n If you would like to use data-dependent averages you can also put the name of a Matlab file which will be executed before the calculation.\n An example is provided (see the file SPIKY_trig_ave.mat).'))
set(handles.dpara_triggered_averages_edit,'TooltipString',get(handles.dpara_triggered_averages_text,'TooltipString'))
set(handles.SIA_pushbutton,'TooltipString',sprintf('This opens a graphical input form which lets you select either via keyboard or via mouse\n the individual instants, the intervals for the selective averaging and the time instants for the triggered averaging.'))

set(handles.Calculate_pushbutton,'TooltipString',sprintf('This starts the calculation of the selected spike train distances for the selected spike trains (see subpanel "Spike trains" from the previous panel)\n within the selected time interval (see subpanel "Time" from the previous panel).\n At the same time the "Selection: Plots" panel is activated.'))
set(handles.STO_pushbutton,'TooltipString',sprintf('This starts the calculation of the SPIKE-Order and Spike Train Order algorithm. Results will be displayed in an additional figure, independent of the any other calculations.'))
%
% #########################################################################
%     Selection: Plots - Type
% ######################################
%
set(handles.plots_profiles_checkbox,'TooltipString',sprintf('This will add a subplot with the stimulus/spikes/dissimilarity profiles selected in the panel "Selection: Measures".\n Its position can be changed by clicking the left mouse on its axes.'))
set(handles.plots_profiles_popupmenu,'TooltipString',sprintf('This chooses which dissimilarity profiles will be shown.'))
set(handles.fpara_profile_average_line_checkbox,'TooltipString',sprintf('This will add a line with the average value to each dissimilarity profile.'))
set(handles.fpara_histogram_checkbox,'TooltipString',sprintf('This will add a spike count histogram on the right hand side of the spike trains.'))
set(handles.fpara_group_matrices_checkbox,'TooltipString',sprintf('This will add subplots with group matrices (averages over groups of spike trains) of the dissimilarity measures selected in the panel "Selection: Measures".\n The position of the matrices can be changed (either individually or all together) by clicking the left mouse on their axes.'))
set(handles.fpara_dendrograms_checkbox,'TooltipString',sprintf('This will add subplots with dendrograms (obtained from the dissimilarity measures selected in the panel "Selection: Measures").\n The position of the dendrograms can be changed (either individually or all together) by clicking the left mouse on their axes.'))
set(handles.plots_frame_comparison_checkbox,'TooltipString',sprintf('This will compare the dissimilarity matrices selected in the panel "Selection: Measures" for different instants and/or selected or triggered averages.\n The position of the matrices can be changed (either individually or all together) by clicking the left mouse on their axes.'))
set(handles.plots_frame_sequence_checkbox,'TooltipString',sprintf('This will add subplots with the dissimilarity matrices selected in the panel "Selection: Measures".\n  The position of the matrices can be changed (either individually or all together) by clicking the left mouse on their axes.'))
set(handles.fpara_colorbar_checkbox,'TooltipString',sprintf('This will add colorbars to the dissimilarity matrices. The range of the colorbars as well as\n whether there are colorbars for each matrix or just for the last matrix depends on the setting\n of the Popupmenu "Matrix normalization" in the panel "Parameters: Figure."'))
%
% ######################################
%     Selection: Plots - Time
% ######################################
%
set(handles.fpara_tmin_edit,'TooltipString',sprintf('Beginning of the analysis window'))
set(handles.fpara_tmin_text,'TooltipString',get(handles.fpara_tmin_edit,'TooltipString'))
set(handles.fpara_tmax_edit,'TooltipString',sprintf('End of analysis window'))
set(handles.fpara_tmax_text,'TooltipString',get(handles.fpara_tmax_edit,'TooltipString'))
%
% ######################################
%     Selection: Plots - Spike trains
% ######################################
%
set(handles.fpara_select_train_mode_popupmenu,'TooltipString',sprintf('This allows you to select a subset of spike trains or spike train groups\n for which the spike train distances will be calculated.\n Since the computational cost scales with the squared number of spike trains (N^2),\n it can save a considerable amount of computation time to exclude spike trains\n that are not really needed from the calculation.'))
set(handles.fpara_select_train_mode_text,'TooltipString',get(handles.fpara_select_train_mode_popupmenu,'TooltipString'))
set(handles.fpara_trains_edit,'TooltipString',sprintf('If "Select trains" is selected, you can either identify the spike trains for which you would like to visualize the spike train distances\n directly using Matlab notation or use the bottom below and select them from a list.\n Use Matlab syntax, e.g. "2 10" or "2:2:10" (without the apostrophes).'))
set(handles.fpara_trains_text,'TooltipString',get(handles.fpara_trains_edit,'TooltipString'))
set(handles.fpara_train_groups_edit,'TooltipString',sprintf('If "Select trains" is selected, you can either identify the spike train groups for which you would like to visualize the spike train distances\n directly using Matlab notation or use the bottom below and select them from a list.\n Use Matlab syntax, e.g. "2 10" or "2:2:10" (without the apostrophes).'))
set(handles.fpara_train_groups_text,'TooltipString',get(handles.fpara_train_groups_edit,'TooltipString'))
set(handles.fpara_select_trains_pushbutton,'TooltipString',sprintf('This allows you to select the spike trains for which you would like to visualize the spike train distances from a list.'))
set(handles.fpara_select_train_groups_pushbutton,'TooltipString',sprintf('This allows you to select the spike train groups you would like to visualize the spike train distances from a list.'))

set(handles.Plot_pushbutton,'TooltipString',sprintf('This calculates the instantaneous values for the selected instants as well as the selected selective and triggered averages (see previous panel).\n All results will be stored within one large matrix of dimension\n "# selected measures * # spike trains * # spike trains * (# selected instants + # selected averages + # triggered averages)"\n from which, depending on the choice of plot,\n the dissimilarity profiles and/or instantaneous or averaged dissimilarity profiles are extracted.'))
%
% #########################################################################
%     Parameters: Figure
% ######################################
%
set(handles.fpara_subplot_size_edit,'TooltipString',sprintf('This adjusts the relative sizes of the selected subplots with stimulus/spikes/dissimilarity profiles (see panel "Selection: Measures").\n For example if three subplots were selected, the vector "1 2 1"\n will result in the middle subplot being double the size as the other two subplots.'))
set(handles.fpara_subplot_size_text,'TooltipString',get(handles.fpara_subplot_size_edit,'TooltipString'))
%
% ######################################
%     Parameters: Figure - Time axis
% ######################################
%
set(handles.fpara_x_realtime_mode_checkbox,'TooltipString',sprintf('This selects the real-time mode for which in the plot the zero time is kept fixed\n whereas the spikes move from right to left.'))
set(handles.fpara_extreme_spikes_checkbox,'TooltipString',sprintf('This marks the position of the last first spike and the first last spike in the profiles.\n In the interval in between these points there is no edge effect.'))
set(handles.fpara_x_offset_edit,'TooltipString',sprintf('Offset for time axis (useful for example if you select an intermediate interval\n but want to have the time scale start at t=0).'))
set(handles.fpara_x_offset_text,'TooltipString',get(handles.fpara_x_offset_edit,'TooltipString'))
set(handles.fpara_x_scale_edit,'TooltipString',sprintf('This defines the basic time unit on the x-axis of the dissimilarity profile subplot.\n For example if the data are sampled in seconds,\n an x-factor of 3600 transforms the x-axis into units of hours.'))
set(handles.fpara_x_scale_text,'TooltipString',get(handles.fpara_x_scale_edit,'TooltipString'))
%
% ###########################################
%     Parameters: Figure - Moving Average
% ###########################################
%
set(handles.fpara_moving_average_mode_popupmenu,'TooltipString',sprintf('Choice between only regular dissimilarity profile,\n only moving average or both superimposed.'))
set(handles.fpara_moving_average_mode_text,'TooltipString',get(handles.fpara_moving_average_mode_popupmenu,'TooltipString'))
set(handles.fpara_mao_edit,'TooltipString',sprintf('Order of moving average for the measure profiles\n(note that the moving average does not use\na time window of fixed length but rather is adaptive\nsince the window length depends on the local firing rate).'))
set(handles.fpara_mao_text,'TooltipString',get(handles.fpara_mao_edit,'TooltipString'))
set(handles.fpara_psth_window_edit,'TooltipString',sprintf('Kernel width of Gaussian filter for the Peristimulus time histogram (PSTH). Set to 0 for no filtering.'))
set(handles.fpara_psth_window_text,'TooltipString',get(handles.fpara_psth_window_edit,'TooltipString'))
%
% ######################################
%     Parameters: Figure
% ######################################
%
set(handles.fpara_spike_train_color_coding_mode_popupmenu,'TooltipString',sprintf('This defines the way the spike trains are color-coded.\n In particular in cases where there are too many spike trains it is not possible to label spike trains on the x-axis\n and then color-coding can help to identify spike trains either individually\n or according to the spike train group they belong to (see subpanel "Spike trains" in the panel "Parameters: Data").'))
set(handles.fpara_spike_train_color_coding_mode_text1,'TooltipString',get(handles.fpara_spike_train_color_coding_mode_popupmenu,'TooltipString'))
set(handles.fpara_spike_train_color_coding_mode_text2,'TooltipString',get(handles.fpara_spike_train_color_coding_mode_popupmenu,'TooltipString'))
set(handles.fpara_profile_norm_mode_popupmenu,'TooltipString',sprintf('This defines the way the dissimilarity profiles are normalized.\n The first option "Absolute possible" normalizes all subplots to the theoretically possible maximum value (typically 1),\n the second option "overall occurring" normalizes all subplots to the one overall maximum (that actually occurs),\n the third option "individual" normalizes each subplot to its own maximum value (that actually occurs).\nThefourth and fifth are like the second and the third.\nThe only difference is that they do not use the full range from zero.'))
set(handles.fpara_profile_norm_mode_text1,'TooltipString',get(handles.fpara_profile_norm_mode_popupmenu,'TooltipString'))
set(handles.fpara_profile_norm_mode_text2,'TooltipString',get(handles.fpara_profile_norm_mode_popupmenu,'TooltipString'))
set(handles.fpara_color_norm_mode_popupmenu,'TooltipString',sprintf('This defines the way the dissimilarity matrices are normalized.\n The first option "Absolute possible" normalizes all matrices to the theoretically possible maximum value (typically 1),\n the second option "overall occurring" normalizes all matrices to the one overall maximum (that actually occurs),\n the third option "individual" normalizes each matrix to its own maximum value (that actually occurs).\nThefourth and fifth are like the second and the third.\nThe only difference is that they do not use the full range from zero.'))
set(handles.fpara_color_norm_mode_text1,'TooltipString',get(handles.fpara_color_norm_mode_popupmenu,'TooltipString'))
set(handles.fpara_color_norm_mode_text2,'TooltipString',get(handles.fpara_color_norm_mode_popupmenu,'TooltipString'))

set(handles.fpara_comment_edit,'TooltipString',sprintf('Figure-comment, will be part of the file names (ps-images and avi-movies).'))
set(handles.fpara_comment_text,'TooltipString',get(handles.fpara_comment_edit,'TooltipString'))
%
% #########################################################################
%     Parameters: Movie
% ######################################
%
set(handles.fpara_frames_per_second_edit,'TooltipString',sprintf('This defines the number of frames per second in the avi-file.'))
set(handles.fpara_frames_per_second_text,'TooltipString',get(handles.fpara_frames_per_second_edit,'TooltipString'))
%set(handles.fpara_num_average_frames_edit,'TooltipString',sprintf('This allows you to increase the relative time the selective and/or triggered averages are shown.\n This is particularly useful in case there are many frames in the beginning of the movie.'))
%set(handles.fpara_num_average_frames_text,'TooltipString',get(handles.fpara_num_average_frames_edit,'TooltipString'))

set(handles.dpara_interval_divisions_edit,'TooltipString',sprintf('Here you can define temporal intervals which in the movie will be marked in the title.'))
set(handles.dpara_interval_divisions_text,'TooltipString',get(handles.dpara_interval_divisions_edit,'TooltipString'))
set(handles.dpara_interval_names_edit,'TooltipString',sprintf('Here you can define names for the temporal intervals (defined in the item right above)\n which in the movie will be marked in the title.'))
set(handles.dpara_interval_names_text,'TooltipString',get(handles.dpara_interval_names_edit,'TooltipString'))
%
% ######################################
%     Movie Console
% ######################################
%
set(handles.Movie_frame_slider,'TooltipString',sprintf('This indicates and sets the current position/frame within the movie.\n Shifting the marker to a certain position lets the movie jump to this position.\n Pressing the slider left or right of the current position of the marker lets the movie jump in the respective direction.'))
set(handles.Movie_first_text,'TooltipString',sprintf('This is the number of the first frame.'))
set(handles.Movie_last_text,'TooltipString',sprintf('This is the number of the last frame.'))
set(handles.Movie_current_text,'TooltipString',sprintf('This is the number of the current frame.'))
set(handles.Movie_first_pushbutton,'TooltipString',sprintf('Immediate jump to the beginning of the movie'))
set(handles.Movie_play_pushbutton,'TooltipString',sprintf('This starts the movie from its current position with the speed defined below (see subpanel "Speed")\n and in the direction defined below (see subpanel "Direction").'))
set(handles.Movie_stop_pushbutton,'TooltipString',sprintf('This stops the movie at its current position.'))
set(handles.Movie_last_pushbutton,'TooltipString',sprintf('Immediate jump to the end of the movie'))

set(handles.Movie_speed_slider,'TooltipString',sprintf('This indicates and sets the speed of the movie.\n Shifting the marker to a certain position lets the movie use a speed corresponding to this position.\n Pressing the slider left or right of the current position of the marker lets the movie decrease or increase its speed, respectively.'))

set(handles.Movie_backward_radiobutton,'TooltipString',sprintf('This lets the movie run towards the first frame.\n It will stop when this frame is reached.\n The direction can also be changed while the movie is running.'))
set(handles.Movie_forward_radiobutton,'TooltipString',sprintf('This lets the movie run towards the last frame.\n It will stop when this frame is reached.\n The direction can also be changed while the movie is running.'))

set(handles.print_figures_checkbox,'TooltipString',sprintf('If this is checked, each individual frame will be printed into a postscript-file.\n To be used sparingly in case of very long movies.'))
set(handles.record_movie_checkbox,'TooltipString',sprintf('If this is checked, the movie will be recorded into an avi-file.'))
