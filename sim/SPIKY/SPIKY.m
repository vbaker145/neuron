%
% ##### Copyright Thomas Kreuz, Nebojsa Bozanic;  Beta-Version 3.0, March 2017 #####
%
% SPIKY is a graphical user interface (Matlab) which can be used to calculate and
% visualize both the SPIKE- and the ISI-distance between two (or more) spike trains.
%
% More information on SPIKY can be found here:
%
% ##### Kreuz T, Mulansky M, Bozanic N: SPIKY: A graphical user interface for monitoring spike train synchrony. J Neurophysiol 113, 3432 (2015) #####
% This manuscript can also be found on the ArXiV: http://arxiv.org/pdf/1410.6910v3.pdf
%
% Information about the new algorithm involving SPIKE-order and Spike train order can be found here:
%
% Kreuz T, Satuvuori E, Pofahl M, Mulansky M: Leaders and followers: Quantifying consistency in spatio-temporal propagation patterns
% Submitted, already available on the arXiv (2017): https://arxiv.org/pdf/1610.07986v2.pdf.
%
% More information on the spike train distances (ISI and SPIKE) can be found under "http://www.fi.isc.cnr.it/users/thomas.kreuz/Source-Code/SPIKY.html" and/or in
%
% ##### Mulansky M, Bozanic N, Sburlea A, Kreuz T: A guide to time-resolved and parameter-free measures of spike train synchrony.
% IEEE Proceeding on Event-based Control, Communication, and Signal Processing (EBCCSP), 1-8 and the arXiv (2015): http://arxiv.org/pdf/1603.03293v2.pdf #####
% ##### Kreuz T, Chicharro D, Houghton C, Andrzejak RG, Mormann F: Monitoring spike train synchrony. J Neurophysiol 109, 1457 (2013) #####
% ##### Kreuz T: SPIKE-distance. Scholarpedia 7(12):30652 (2012). #####
%
% Kreuz T: Measures of spike train synchrony. Scholarpedia, 6(10):11934 (2011).
% Kreuz T, Chicharro D, Greschner M, Andrzejak RG: Time-resolved and time-scale adaptive measures of spike train synchrony. J Neurosci Methods 195, 92 (2011).
% Kreuz T, Chicharro D, Andrzejak RG, Haas JS, Abarbanel HDI: Measuring multiple spike train synchrony. J Neurosci Methods 183, 287 (2009).
% Kreuz T, Haas JS, Morelli A, Abarbanel HDI, Politi A: Measuring spike train synchrony. J Neurosci Methods 165, 151 (2007)
%
% For questions and comments please contact us at "thomaskreuz (at) cnr.it".
%
% BSD license:
% Copyright (c) 2016, Thomas Kreuz, Nebojsa Bozanic
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution.
%     * Neither the name of the author nor the
%       names of its contributors may be used to endorse or promote products
%       derived from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


function varargout=SPIKY(varargin)

% Begin initialization code-DO NOT EDIT
gui_Singleton=1;
gui_State=struct('gui_Name',  mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @SPIKY_OpeningFcn, ...
    'gui_OutputFcn',  @SPIKY_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback=str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}]=gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code-DO NOT EDIT
if ~isappdata(0,'guifigh')
    guifigh=findall(0,'type','figure');
    setappdata(0,'guifigh',guifigh)
    set(guifigh(1),'Position',[0 0.0067 0.5 0.8878])    % 0.0 0.08 0.5 0.8888888888888888
end
end


% --- Executes just before SPIKY is made visible.
function SPIKY_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% varargin   command line arguments to SPIKY (see VARARGIN)

% Choose default command line output for SPIKY
handles.output=hObject;

% Update handles structure
guidata(hObject, handles);

addpath(genpath('SPIKY'))
addpath(genpath('.'))

clc

disp(' '); disp(' '); disp(' '); disp(' ');

[d1,d_para,f_para,d_para_default,f_para_default,s_para_default,p_para_default,listbox_str]=SPIKY_f_user_interface([],[],0);

d_para_default_default=d_para_default;
setappdata(handles.figure1,'data_parameters_default_default',d_para_default_default)
setappdata(handles.figure1,'data_parameters_default',d_para_default)
setappdata(handles.figure1,'figure_parameters_default',f_para_default)
setappdata(handles.figure1,'subplot_parameters_default',s_para_default)
setappdata(handles.figure1,'plot_parameters_default',p_para_default)

d_para=d_para_default;
f_para=f_para_default;
setappdata(handles.figure1,'data_parameters',d_para)
setappdata(handles.figure1,'figure_parameters',f_para)


if isfield(f_para_default,'ma_mode') && ~isempty(f_para_default.ma_mode)
    if f_para_default.ma_mode==1 s_para_default.nma=1; elseif f_para_default.ma_mode==2 s_para_default.nma=2; else s_para_default.nma=[1 2]; end %#ok<SEPEX>
end
if isfield(f_para_default,'mao') && ~isempty(f_para_default.mao)
    s_para_default.mao=f_para_default.mao;    % order of the moving average (pooled ISI)
end

set(handles.Data_listbox,'String',listbox_str,'Value',d_para.example);

fig=figure(f_para.num_fig);
set(fig,'DeleteFcn',{@SPIKY_ClosingFcn})

clf
set(fig,'units','normalized','Position',f_para_default.pos_fig)
subplot('Position',f_para_default.supo1)
plot([-1000 -1001],[-1000 -1001])
xlim([0 1])
ylim([0 1])
set(gca,'XTick',[],'YTick',[])

set(handles.Movie_play_pushbutton,'UserData',0);
set(handles.List_pushbutton,'FontWeight','bold')
set(handles.Workspace_pushbutton,'FontWeight','bold')
set(handles.Event_Detector_pushbutton,'FontWeight','bold')
set(handles.Generator_pushbutton,'FontWeight','bold')

uicontrol(handles.List_pushbutton)

if f_para.hints
    SPIKY_hints
end

set(gcf,'DeleteFcn',{@SPIKY_ClosingFcn})

end


function SPIKY_ClosingFcn(varargin)

if exist('SPIKY_AZBYCX.mat','file')
    delete('SPIKY_AZBYCX.mat')
end
setappdata(varargin{1},'closed',1)
fff=findobj('type','figure');
delete(fff)
if isappdata(0,'guifigh')
    rmappdata(0,'guifigh')
end

end


function varargout=SPIKY_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1}=handles.output;
%results=getappdata(handles.figure1,'results');
%varargout{2}=results;
end


function InfoMenu_Callback(hObject, eventdata, handles)

Info_fig=figure('units','normalized','menubar','none','position',[0.35 0.2 0.3 0.45],'Name','SPIKY-Info','NumberTitle','off',...
    'Color',[0.9294 0.9176 0.851],'WindowStyle','modal'); % Create a new figure.

axes('units','normalized','position',[0.25 0.75 0.2 0.2]);
if exist('SPIKY-Logo_gray.png','file')
    png=imread('SPIKY-Logo_gray.png');
    image(png)
end
gcol=[236 233 216]/255;
set(gca,'Color','w','XColor',gcol,'YColor',gcol,'XTick',[],'YTick',[],'box','on')

%uicontrol('style','text','units','normalized','position',[0.1 0.85 0.5 0.08],'string','SPIKY','FontSize',20,'FontWeight','bold')
uicontrol('style','text','units','normalized','position',[0.09 0.715 0.5 0.04],'string','Beta-Version 2.2','FontSize',12)
uicontrol('style','text','units','normalized','position',[0.45 0.835 0.5 0.04],'string','Thomas Kreuz','FontSize',12,'FontWeight','bold')
uicontrol('style','text','units','normalized','position',[0.463 0.795 0.5 0.04],'string','Nebojsa Bozanic','FontSize',12,'FontWeight','bold')
uicontrol('style','text','units','normalized','position',[0.1 0.596 0.8 0.04],'string','Kreuz T, Bozanic N','FontSize',12)
uicontrol('style','text','units','normalized','position',[0.05 0.555 0.9 0.04],...
    'string','SPIKY: A graphical user interface for monitoring spike train synchrony','FontSize',12,'FontWeight','bold')
uicontrol('style','text','units','normalized','position',[0.1 0.514 0.8 0.04],'string','J Neurophysiol 113, 3432 (2015)','FontSize',12)
uicontrol('style','text','units','normalized','position',[0.1 0.426 0.8 0.04],...
    'string','Kreuz T, Chicharro D, Houghton C, Andrzejak RG, Mormann F','FontSize',12)
uicontrol('style','text','units','normalized','position',[0.1 0.385 0.8 0.04],...
    'string','Monitoring spike train synchrony','FontSize',12,'FontWeight','bold')
uicontrol('style','text','units','normalized','position',[0.1 0.344 0.8 0.04],'string','J Neurophysiol 109, 1457 (2013)','FontSize',12)
uicontrol('style','text','units','normalized','position',[0.05 0.221 0.9 0.04],...
    'string','http://www.fi.isc.cnr.it/users/thomas.kreuz/Source-Code/SPIKY.html','FontSize',12,'FontWeight','bold')

Info_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.4 0.06 0.2 0.07],'string','OK','FontSize',14,...
    'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@Info_pushbutton_callback});
uicontrol(Info_pushbutton)

    function Info_pushbutton_callback(varargin)
        close(Info_fig)  % Close secondary figure.
    end
end


function uipushtool_new_Callback(hObject, eventdata, handles)

set(handles.figure1,'Visible','on')
set(handles.Para_data_uipanel,'Visible','off')
set(handles.Selection_masures_uipanel,'Visible','off')
set(handles.Selection_plots_uipanel,'Visible','off')
set(handles.Para_figure_uipanel,'Visible','off')
set(handles.Movie_uipanel,'Visible','off')
set(handles.Para_movie_uipanel,'Visible','off')
%set(handles.subplot_stimulus_posi_edit,'Enable','on')
set(handles.subplot_spikes_posi_edit,'Enable','on')
set(handles.subplot_psth_posi_edit,'Enable','on')
set(handles.subplot_isi_posi_edit,'Enable','on')
set(handles.subplot_spike_posi_edit,'Enable','on')
set(handles.subplot_spike_realtime_posi_edit,'Enable','on')
set(handles.subplot_spike_forward_posi_edit,'Enable','on')
set(handles.subplot_spikesync_posi_edit,'Enable','on')
set(handles.subplot_spikeorder_posi_edit,'Enable','on')
set(handles.dpara_trains_edit,'String','')
set(handles.dpara_train_groups_edit,'String','')
set(handles.dpara_instants_edit,'Enable','on','String','')
set(handles.dpara_selective_averages_edit,'Enable','on','String','')
set(handles.dpara_triggered_averages_edit,'Enable','on','String','')
set(handles.SIA_pushbutton,'Enable','on')
set(handles.plots_profiles_popupmenu,'Enable','on')
set(handles.fpara_x_realtime_mode_checkbox,'Enable','on')
set(handles.fpara_extreme_spikes_checkbox,'Enable','on')
set(handles.fpara_moving_average_mode_popupmenu,'Enable','on')
set(handles.fpara_mao_edit,'Enable','on')
set(handles.fpara_psth_window_edit,'Enable','on')
set(handles.fpara_profile_norm_mode_popupmenu,'Enable','on')
set(handles.fpara_color_norm_mode_popupmenu,'Enable','on')
set(handles.fpara_spike_train_color_coding_mode_popupmenu,'Enable','on')
set(handles.fpara_group_matrices_checkbox,'Enable','on')
set(handles.fpara_dendrograms_checkbox,'Enable','on')
set(handles.fpara_colorbar_checkbox,'Enable','on')
set(handles.fpara_select_train_mode_popupmenu,'String',{'All';'Select trains';'Select groups'})
set(handles.fpara_trains_edit,'Enable','on')
set(handles.fpara_select_trains_pushbutton,'Enable','on')
set(handles.fpara_train_groups_edit,'Enable','on')
set(handles.fpara_select_train_groups_pushbutton,'Enable','on')
set(handles.Movie_frame_slider,'Value',get(handles.Movie_frame_slider,'Min'))

disp(' '); disp(' ');

[d1,d_para,f_para,d_para_default,f_para_default,s_para_default,p_para_default,listbox_str]=SPIKY_f_user_interface([],[],0);

d_para_default_default=d_para_default;
setappdata(handles.figure1,'data_parameters_default_default',d_para_default_default)
setappdata(handles.figure1,'data_parameters_default',d_para_default)
setappdata(handles.figure1,'figure_parameters_default',f_para_default)
setappdata(handles.figure1,'subplot_parameters_default',s_para_default)
setappdata(handles.figure1,'plot_parameters_default',p_para_default)

d_para=d_para_default;
f_para=f_para_default;
s_para=s_para_default;
p_para=p_para_default;
setappdata(handles.figure1,'data_parameters',d_para)
setappdata(handles.figure1,'figure_parameters',f_para)
setappdata(handles.figure1,'subplot_parameters',s_para)
setappdata(handles.figure1,'plot_parameters',p_para)

spike_lh=[];
allspikes=[];
setappdata(handles.figure1,'spike_lh',spike_lh)
setappdata(handles.figure1,'allspikes',allspikes)


if isfield(f_para_default,'ma_mode') && ~isempty(f_para_default.ma_mode)
    if f_para_default.ma_mode==1 s_para_default.nma=1; elseif f_para_default.ma_mode==2 s_para_default.nma=2; else s_para_default.nma=[1 2]; end %#ok<SEPEX>
end
if isfield(f_para_default,'mao') && ~isempty(f_para_default.mao)
    s_para_default.mao=f_para_default.mao;    % order of the moving average (pooled ISI)
end

set(handles.Data_listbox,'String',listbox_str,'Value',d_para.example);

if isappdata(handles.figure1,'measure_results')
    rmappdata(handles.figure1,'measure_results')
end
if isappdata(handles.figure1,'measure_parameters')
    rmappdata(handles.figure1,'measure_parameters')
end
if isappdata(handles.figure1,'movie_handles')
    rmappdata(handles.figure1,'movie_handles')
end
if isappdata(handles.figure1,'help_parameters')
    rmappdata(handles.figure1,'help_parameters')
end
if isappdata(handles.figure1,'spikes')
    rmappdata(handles.figure1,'spikes')
end

if isappdata(handles.figure1,'thick_mar_lh')
    rmappdata(handles.figure1,'thick_mar_lh')
end
if isappdata(handles.figure1,'thin_mar_lh')
    rmappdata(handles.figure1,'thin_mar_lh')
end
if isappdata(handles.figure1,'thick_sep_lh')
    rmappdata(handles.figure1,'thick_sep_lh')
end
if isappdata(handles.figure1,'thin_sep_lh')
    rmappdata(handles.figure1,'thin_sep_lh')
end
if isappdata(handles.figure1,'sgs_lh')
    rmappdata(handles.figure1,'sgs_lh')
end

figure(f_para.num_fig);
set(gcf,'UserData',[],'Name','')
%set(gcf,'Position',f_para.pos_fig)
clf
subplot('Position',f_para.supo1);
plot([-1000 -1001],[-1000 -1001])
xlim([0 1])
ylim([0 1])
set(gca,'XTick',[],'YTick',[])
xlabel('')
ylabel('')


set(handles.Data_listbox,'Enable','on')
set(handles.Generator_pushbutton,'Enable','on','FontWeight','bold')
set(handles.List_pushbutton,'Enable','on','FontWeight','bold')
set(handles.Workspace_pushbutton,'Enable','on','FontWeight','bold')
set(handles.Event_Detector_pushbutton,'Enable','on','FontWeight','bold')
set(handles.Calculate_pushbutton,'Enable','on','FontWeight','bold')
set(handles.Update_pushbutton,'UserData',0)
set(handles.SM_pushbutton,'Enable','on')
set(handles.SS_pushbutton,'Enable','on')
set(handles.SG_pushbutton,'Enable','on')
set(handles.SS_pushbutton,'Enable','on')
uicontrol(handles.List_pushbutton)
end


function uipushtool_reset_Callback(hObject, eventdata, handles)

if strcmp(get(handles.Para_data_uipanel,'Visible'),'off')
    uipushtool_new_Callback(hObject, eventdata, handles)
else
    set(handles.figure1,'Visible','on')
    set(handles.Selection_plots_uipanel,'Visible','off')
    set(handles.Para_figure_uipanel,'Visible','off')
    set(handles.Movie_uipanel,'Visible','off')
    set(handles.Para_movie_uipanel,'Visible','off')

    set(handles.dpara_tmin_edit,'Enable','on')
    set(handles.dpara_tmax_edit,'Enable','on')
    set(handles.dpara_dts_edit,'Enable','on')
    set(handles.dpara_thick_markers_edit,'Enable','on')
    set(handles.dpara_thin_markers_edit,'Enable','on')
    set(handles.dpara_select_train_mode_popupmenu,'Enable','on')
    if get(handles.dpara_select_train_mode_popupmenu,'Value')==1
        set(handles.dpara_train_groups_edit,'Enable','off')
        set(handles.dpara_select_train_groups_pushbutton,'Enable','off')
        set(handles.dpara_trains_edit,'Enable','off')
        set(handles.dpara_select_trains_pushbutton,'Enable','off')
    elseif get(handles.dpara_select_train_mode_popupmenu,'Value')==2
        set(handles.dpara_trains_edit,'Enable','on')
        set(handles.dpara_select_trains_pushbutton,'Enable','on')
        set(handles.dpara_train_groups_edit,'String','','Enable','off')
        set(handles.dpara_select_train_groups_pushbutton,'Enable','off')
    else
        set(handles.dpara_trains_edit,'String','','Enable','off')
        set(handles.dpara_select_trains_pushbutton,'Enable','off')
        set(handles.dpara_train_groups_edit,'Enable','on')
        set(handles.dpara_select_train_groups_pushbutton,'Enable','on')
    end
    set(handles.dpara_group_names_edit,'Enable','on')
    set(handles.dpara_group_sizes_edit,'Enable','on')
    set(handles.dpara_thin_separators_edit,'Enable','on')
    set(handles.dpara_thick_separators_edit,'Enable','on')
    set(handles.dpara_interval_divisions_edit,'Enable','on')
    set(handles.dpara_interval_names_edit,'Enable','on')
    set(handles.dpara_comment_edit,'Enable','on')
    set(handles.Generator_pushbutton,'Enable','on','FontWeight','bold')
    set(handles.Calculate_pushbutton,'Enable','on','FontWeight','bold')
    set(handles.Update_pushbutton,'Enable','on','FontWeight','bold')
    set(handles.SM_pushbutton,'Enable','on')
    set(handles.SS_pushbutton,'Enable','on')
    set(handles.SG_pushbutton,'Enable','on')
    set(handles.SS_pushbutton,'Enable','on')

    %set(handles.subplot_stimulus_posi_edit,'Enable','on')
    set(handles.subplot_spikes_posi_edit,'Enable','on')
    set(handles.subplot_psth_posi_edit,'Enable','on')
    set(handles.subplot_isi_posi_edit,'Enable','on')
    set(handles.subplot_spike_posi_edit,'Enable','on')
    set(handles.subplot_spike_realtime_posi_edit,'Enable','on')
    set(handles.subplot_spike_forward_posi_edit,'Enable','on')
    set(handles.subplot_spikesync_posi_edit,'Enable','on')
    set(handles.subplot_spikeorder_posi_edit,'Enable','on')
    set(handles.dpara_instants_edit,'Enable','on')
    set(handles.dpara_selective_averages_edit,'Enable','on')
    set(handles.dpara_triggered_averages_edit,'Enable','on')
    set(handles.SIA_pushbutton,'Enable','on')
    set(handles.plots_profiles_popupmenu,'Enable','on')
    set(handles.plots_frame_comparison_checkbox,'Enable','on')
    set(handles.plots_frame_sequence_checkbox,'Enable','on')
    set(handles.fpara_group_matrices_checkbox,'Enable','on')
    set(handles.fpara_dendrograms_checkbox,'Enable','on')
    set(handles.fpara_colorbar_checkbox,'Enable','on')
    set(handles.fpara_trains_edit,'Enable','on')
    set(handles.fpara_select_trains_pushbutton,'Enable','on')
    set(handles.fpara_train_groups_edit,'Enable','on')
    set(handles.fpara_select_train_groups_pushbutton,'Enable','on')
    set(handles.fpara_x_realtime_mode_checkbox,'Enable','on')
    set(handles.fpara_extreme_spikes_checkbox,'Enable','on')
    set(handles.fpara_moving_average_mode_popupmenu,'Enable','on')
    set(handles.fpara_mao_edit,'Enable','on')
    set(handles.fpara_profile_norm_mode_popupmenu,'Enable','on')
    set(handles.fpara_color_norm_mode_popupmenu,'Enable','on')
    set(handles.fpara_spike_train_color_coding_mode_popupmenu,'Enable','on')
    set(handles.Movie_frame_slider,'Value',get(handles.Movie_frame_slider,'Min'))

    disp(' '); disp(' ');

    if strcmp(get(handles.Selection_masures_uipanel,'Visible'),'on')
        if isappdata(handles.figure1,'measure_results')
            rmappdata(handles.figure1,'measure_results')
        end
        if isappdata(handles.figure1,'measure_parameters')
            rmappdata(handles.figure1,'measure_parameters')
        end
        if isappdata(handles.figure1,'movie_handles')
            rmappdata(handles.figure1,'movie_handles')
        end
        if isappdata(handles.figure1,'help_parameters')
            rmappdata(handles.figure1,'help_parameters')
        end
        if isappdata(handles.figure1,'spikes')
            rmappdata(handles.figure1,'spikes')
        end
        Update_pushbutton_Callback(hObject, eventdata, handles)
    end
    if exist('results','var')
        if isfield(results,'matrices')
            results=rmfield(results,'matrices');
        end
        if isfield(results,'group_matrices')
            results=rmfield(results,'group_matrices');
        end
        if isfield(results,'dendros')
            results=rmfield(results,'dendros');
        end
        if isfield(results,'group_dendros')
            results=rmfield(results,'group_dendros');
        end
    end
end
end


function uipushtool_open_mat_Callback(hObject, eventdata, handles)

d_para_default=getappdata(handles.figure1,'data_parameters_default');
f_para_default=getappdata(handles.figure1,'figure_parameters_default');
s_para_default=getappdata(handles.figure1,'subplot_parameters_default');
p_para_default=getappdata(handles.figure1,'plot_parameters_default');
d_para=d_para_default;
f_para=f_para_default;
s_para=s_para_default;
p_para=p_para_default;

[d_para.filename,d_para.path]=uigetfile('*.mat','Pick a .mat-file');
if isequal(d_para.filename,0) || isequal(d_para.path,0)
    return
end
d_para.matfile=[d_para.path d_para.filename];
if ~isequal(d_para.matfile,0)
    if strcmp(get(handles.Para_data_uipanel,'Visible'),'on')
        uipushtool_new_Callback(hObject, eventdata, handles)
    end
    
    SPIKY_check_spikes
    if ret==1
        return
    end
    allspikes=spikes;

    d_para.comment_string=d_para.filename;
    SPIKY_paras_set
    SPIKY_plot_allspikes
    SPIKY_paras_set

    setappdata(handles.figure1,'data_parameters',d_para)
    setappdata(handles.figure1,'figure_parameters',f_para)
    setappdata(handles.figure1,'subplot_parameters',s_para)
    setappdata(handles.figure1,'plot_parameters',p_para)
    setappdata(handles.figure1,'allspikes',allspikes)

    set(handles.Data_listbox,'String',[get(handles.Data_listbox,'String');d_para.matfile])
    set(handles.Data_listbox,'Value',size(get(handles.Data_listbox,'String'),1))

    set(handles.Data_listbox,'Enable','off')
    set(handles.Selection_data_uipanel,'HighlightColor','w')

    set(handles.Para_data_uipanel,'Visible','on','HighlightColor','k')
    set(handles.Update_pushbutton,'Enable','on','FontWeight','bold')
    set(handles.List_pushbutton,'Enable','off','FontWeight','normal')
    set(handles.Workspace_pushbutton,'Enable','off','FontWeight','normal')
    set(handles.Event_Detector_pushbutton,'Enable','off','FontWeight','normal')
    uicontrol(handles.Update_pushbutton)
end

end


function uipushtool_open_txt_Callback(hObject, eventdata, handles)

d_para_default=getappdata(handles.figure1,'data_parameters_default');
f_para_default=getappdata(handles.figure1,'figure_parameters_default');
s_para_default=getappdata(handles.figure1,'subplot_parameters_default');
p_para_default=getappdata(handles.figure1,'plot_parameters_default');
d_para=d_para_default;
f_para=f_para_default;
s_para=s_para_default;
p_para=p_para_default;

[d_para.filename,d_para.path]=uigetfile('*.txt','Pick a .txt-file');
if isequal(d_para.filename,0) || isequal(d_para.path,0)
    return
end
d_para.txtfile=[d_para.path d_para.filename];
if ~isequal(d_para.txtfile, 0)
    if strcmp(get(handles.Para_data_uipanel,'Visible'),'on')
        uipushtool_new_Callback(hObject, eventdata, handles)
    end
    spikes=dlmread(d_para.txtfile);
    if size(spikes,2)==1 && size(spikes,1)>9
        fid = fopen(d_para.txtfile);
        spiks=textscan(fid,'%s','Delimiter','\n');
        fclose(fid);
        eost=[0; find(strcmp(spiks{1},'')); length(spiks{1})+1];
        deo=diff(eost);
        eost=eost(find(deo~=1,1,'first'):find(deo~=1,1,'last')+1);
        spikes=cell(1,length(eost)-1);
        for trac=1:length(eost)-1
           spikes{trac}=str2num(char(spiks{1}(eost(trac)+1:eost(trac+1)-1)))';
        end
    end

    SPIKY_check_spikes
    if ret==1
        return
    end
    allspikes=spikes;

    d_para.comment_string=d_para.filename;
    SPIKY_paras_set
    SPIKY_plot_allspikes
    SPIKY_paras_set
    
    setappdata(handles.figure1,'data_parameters',d_para)
    setappdata(handles.figure1,'figure_parameters',f_para)
    setappdata(handles.figure1,'subplot_parameters',s_para)
    setappdata(handles.figure1,'plot_parameters',p_para)
    setappdata(handles.figure1,'allspikes',allspikes)

    set(handles.Data_listbox,'String',[get(handles.Data_listbox,'String');d_para.txtfile])
    set(handles.Data_listbox,'Value',size(get(handles.Data_listbox,'String'),1))

    set(handles.Data_listbox,'Enable','off')
    set(handles.Selection_data_uipanel,'HighlightColor','w')

    set(handles.List_pushbutton,'Enable','off','FontWeight','normal')
    set(handles.Workspace_pushbutton,'Enable','off','FontWeight','normal')
    set(handles.Event_Detector_pushbutton,'Enable','off','FontWeight','normal')
    set(handles.Para_data_uipanel,'Visible','on','HighlightColor','k')
    set(handles.Update_pushbutton,'Enable','on','FontWeight','bold')
    uicontrol(handles.Update_pushbutton)

end

end


function SPIKY_event_detector_callback(hObject, eventdata, handles)

    d_para=getappdata(handles.figure1,'data_parameters');
    f_para=getappdata(handles.figure1,'figure_parameters');
    s_para_default=getappdata(handles.figure1,'subplot_parameters_default');
    p_para_default=getappdata(handles.figure1,'plot_parameters_default');
    s_para=s_para_default;
    p_para=p_para_default;
    
    if isappdata(handles.figure1,'events')
        spikes=getappdata(handles.figure1,'events');
        SPIKY_check_spikes
        if ret==1
            return
        end
        allspikes=spikes;
        
        d_para.comment_string='Events';
        SPIKY_paras_set
        SPIKY_plot_allspikes
        SPIKY_paras_set
        
        setappdata(handles.figure1,'data_parameters',d_para)
        setappdata(handles.figure1,'figure_parameters',f_para)
        setappdata(handles.figure1,'subplot_parameters',s_para)
        setappdata(handles.figure1,'plot_parameters',p_para)
        setappdata(handles.figure1,'allspikes',allspikes)
                
        set(handles.Data_listbox,'Enable','off')
        set(handles.Selection_data_uipanel,'HighlightColor','w')
        
        set(handles.Para_data_uipanel,'Visible','on','HighlightColor','k')
        set(handles.Update_pushbutton,'Enable','on','FontWeight','bold')
        set(handles.List_pushbutton,'Enable','off','FontWeight','normal')
        set(handles.Workspace_pushbutton,'Enable','off','FontWeight','normal')
        set(handles.Event_Detector_pushbutton,'Enable','off','FontWeight','normal')
        uicontrol(handles.Update_pushbutton)
    end
    
end


function uipushtool_save_mat_Callback(hObject, eventdata, handles)

d_para_default=getappdata(handles.figure1,'data_parameters_default');
f_para_default=getappdata(handles.figure1,'figure_parameters_default');
s_para_default=getappdata(handles.figure1,'subplot_parameters_default');
p_para_default=getappdata(handles.figure1,'plot_parameters_default');
d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
s_para=getappdata(handles.figure1,'subplot_parameters');
p_para=getappdata(handles.figure1,'plot_parameters');
m_para=getappdata(handles.figure1,'measure_parameters');
h_para=getappdata(handles.figure1,'help_parameters');
m_res=getappdata(handles.figure1,'measure_results');
mov_handles=getappdata(handles.figure1,'movie_handles');

d_para.comment_string=get(handles.dpara_comment_edit,'String');
f_para.comment_string=get(handles.fpara_comment_edit,'String');
matname_default=[f_para.imagespath,d_para.comment_string,f_para.comment_string,'.mat'];
matname=uiputfile(matname_default,'Save workspace as .mat');
if ~isequal(matname, 0)
    save(matname);
end

end


function uipushtool_save_fig_Callback(hObject, eventdata, handles)

d_para.comment_string=get(handles.dpara_comment_edit,'String');
f_para=getappdata(handles.figure1,'figure_parameters');
f_para.comment_string=get(handles.fpara_comment_edit,'String');
fig=figure(f_para.num_fig);
figname_default=[f_para.imagespath,d_para.comment_string,f_para.comment_string,'.fig'];
figname=uiputfile(figname_default,'Save figure as .fig');
if ~isequal(figname, 0)
    saveas(fig,figname,'fig');
end

end


function uipushtool_print_ps_Callback(hObject, eventdata, handles)

d_para.comment_string=get(handles.dpara_comment_edit,'String');
f_para=getappdata(handles.figure1,'figure_parameters');
f_para.comment_string=get(handles.fpara_comment_edit,'String');
figure(f_para.num_fig);
if f_para.publication==0
    set(gcf,'PaperOrientation','Portrait'); set(gcf,'PaperType', 'A4')
    set(gcf,'PaperUnits','Normalized','PaperPosition',[0 0.45 1.0 0.5])
else
    set(gcf,'PaperOrientation','Landscape'); set(gcf,'PaperType', 'A4')
    set(gcf,'PaperUnits','Normalized','PaperPosition',[0 0 1.0 1.0])
end
psname_default=[f_para.imagespath,d_para.comment_string,f_para.comment_string,'.ps'];
psname=uiputfile(psname_default,'Print figure as .ps');
if ~isequal(psname, 0)
    print(f_para.num_fig,'-dpsc',psname);
end

end

function fpara_moving_average_mode_popupmenu_Callback(hObject, eventdata, handles)

if get(handles.fpara_moving_average_mode_popupmenu,'Value')==1
    set(handles.fpara_mao_edit,'Enable','off')
else
    m_para=getappdata(handles.figure1,'measure_parameters');
    if m_para.num_pico_measures>0 || m_para.num_disc_measures>0 || m_para.num_pili_measures>0
        set(handles.fpara_mao_edit,'Enable','on')
    end
end

end


function dpara_select_train_mode_popupmenu_Callback(hObject, eventdata, handles)

d_para=getappdata(handles.figure1,'data_parameters');

if get(handles.dpara_select_train_mode_popupmenu,'Value')==1
    set(handles.dpara_trains_edit,'String','','Enable','off')
    set(handles.dpara_train_groups_edit,'String','','Enable','off')
    set(handles.dpara_select_trains_pushbutton,'Enable','off')
    set(handles.dpara_select_train_groups_pushbutton,'Enable','off')
elseif get(handles.dpara_select_train_mode_popupmenu,'Value')==2
    set(handles.dpara_trains_edit,'Enable','on')
    set(handles.dpara_select_trains_pushbutton,'Enable','on')
    set(handles.dpara_train_groups_edit,'String','','Enable','off')
    set(handles.dpara_select_train_groups_pushbutton,'Enable','off')
else
    set(handles.dpara_train_groups_edit,'Enable','on')
    set(handles.dpara_select_train_groups_pushbutton,'Enable','on')
    set(handles.dpara_trains_edit,'String','','Enable','off')
    set(handles.dpara_select_trains_pushbutton,'Enable','off')
end

setappdata(handles.figure1,'data_parameters',d_para);
end


function fpara_select_train_mode_popupmenu_Callback(hObject, eventdata, handles)

if get(handles.fpara_select_train_mode_popupmenu,'Value')==1
    set(handles.fpara_train_groups_edit,'String','','Enable','off')
    set(handles.fpara_trains_edit,'String','','Enable','off')
    set(handles.fpara_select_train_groups_pushbutton,'Enable','off')
    set(handles.fpara_select_trains_pushbutton,'Enable','off')
elseif get(handles.fpara_select_train_mode_popupmenu,'Value')==2
    set(handles.fpara_trains_edit,'Enable','on')
    set(handles.fpara_select_trains_pushbutton,'Enable','on')
    set(handles.fpara_train_groups_edit,'String','','Enable','off')
    set(handles.fpara_select_train_groups_pushbutton,'Enable','off')
else
    set(handles.fpara_train_groups_edit,'Enable','on')
    set(handles.fpara_select_train_groups_pushbutton,'Enable','on')
    set(handles.fpara_trains_edit,'String','','Enable','off')
    set(handles.fpara_select_trains_pushbutton,'Enable','off')
end
end


function plots_profiles_checkbox_Callback(hObject, eventdata, handles)
if get(handles.plots_profiles_checkbox,'Value')==0
    set(handles.plots_profiles_popupmenu,'Enable','off')
    set(handles.fpara_profile_average_line_checkbox,'Enable','off')
    set(handles.fpara_extreme_spikes_checkbox,'Enable','off')
    set(handles.fpara_moving_average_mode_popupmenu,'Enable','off')
    set(handles.fpara_mao_edit,'Enable','off')
    set(handles.fpara_profile_norm_mode_popupmenu,'Enable','off')
    set(handles.fpara_subplot_size_edit,'Enable','off')
    
else
    m_para=getappdata(handles.figure1,'measure_parameters');
    d_para=getappdata(handles.figure1,'data_parameters');
    if d_para.num_select_train_groups>1
        set(handles.plots_profiles_popupmenu,'Enable','on')
    end
    set(handles.fpara_profile_average_line_checkbox,'Enable','on')
    set(handles.fpara_extreme_spikes_checkbox,'Enable','on')
    set(handles.fpara_moving_average_mode_popupmenu,'Enable','on')
    if m_para.num_pico_measures || m_para.num_disc_measures>0 || m_para.num_pili_measures
        set(handles.fpara_mao_edit,'Enable','on')
    end
    set(handles.fpara_profile_norm_mode_popupmenu,'Enable','on')
    set(handles.fpara_subplot_size_edit,'Enable','on')
end
end


function plots_profiles_popupmenu_Callback(hObject, eventdata, handles)
if get(handles.plots_profiles_popupmenu,'Value')>1
    set(handles.fpara_spike_train_color_coding_mode_popupmenu,'Value',2,'Enable','off')
else
    set(handles.fpara_spike_train_color_coding_mode_popupmenu,'Enable','on')
end
end


function plots_frame_comparison_checkbox_Callback(hObject, eventdata, handles)
if get(handles.plots_frame_comparison_checkbox,'Value')==0
    if get(handles.plots_frame_sequence_checkbox,'Value')==0
        set(handles.fpara_group_matrices_checkbox,'Enable','off')
        set(handles.fpara_dendrograms_checkbox,'Enable','off')
        set(handles.fpara_colorbar_checkbox,'Enable','off')
        set(handles.fpara_color_norm_mode_popupmenu,'Enable','off')
    end
else
    set(handles.plots_frame_sequence_checkbox,'Value',0)
    plots_frame_sequence_checkbox_Callback(hObject, eventdata, handles)
    set(handles.fpara_color_norm_mode_popupmenu,'Enable','on')
    set(handles.fpara_colorbar_checkbox,'Enable','on')
    d_para=getappdata(handles.figure1,'data_parameters');
    if d_para.num_select_train_groups>1
        set(handles.fpara_group_matrices_checkbox,'Enable','on')
    end
    if d_para.num_trains>2
        set(handles.fpara_dendrograms_checkbox,'Enable','on')
    end
end
end


function plots_frame_sequence_checkbox_Callback(hObject, eventdata, handles)
if get(handles.plots_frame_sequence_checkbox,'Value')==0 % && get(handles.record_movie_checkbox,'Value')==0
    set(handles.Para_movie_uipanel,'Visible','off')
    set(handles.Movie_uipanel,'Visible','off')
    set(handles.fpara_x_realtime_mode_checkbox,'Enable','off','Value',0)
    if get(handles.plots_frame_comparison_checkbox,'Value')==0
        set(handles.fpara_group_matrices_checkbox,'Enable','off')
        set(handles.fpara_dendrograms_checkbox,'Enable','off')
        set(handles.fpara_colorbar_checkbox,'Enable','off')
        set(handles.fpara_color_norm_mode_popupmenu,'Enable','off')
    end
else
    set(handles.plots_frame_comparison_checkbox,'Value',0)
    plots_frame_comparison_checkbox_Callback(hObject, eventdata, handles)
    set(handles.Para_movie_uipanel,'Visible','on')
    set(handles.Movie_uipanel,'Visible','on')
    set(handles.fpara_x_realtime_mode_checkbox,'Enable','on')
    set(handles.fpara_color_norm_mode_popupmenu,'Enable','on')
    set(handles.fpara_colorbar_checkbox,'Enable','on')
    d_para=getappdata(handles.figure1,'data_parameters');
    if d_para.num_select_train_groups>1
        set(handles.fpara_group_matrices_checkbox,'Enable','on')
    end
    if d_para.num_trains>2
        set(handles.fpara_dendrograms_checkbox,'Enable','on')
    end
end
end


function Data_listbox_Callback(hObject, eventdata, handles)

if ~strcmp(get(gcf,'SelectionType'),'open')
    return;
end
List_pushbutton_Callback(hObject, eventdata, handles)

end


function List_pushbutton_Callback(hObject, eventdata, handles)

d_para_default=getappdata(handles.figure1,'data_parameters_default');
f_para_default=getappdata(handles.figure1,'figure_parameters_default');
s_para_default=getappdata(handles.figure1,'subplot_parameters_default');
p_para_default=getappdata(handles.figure1,'plot_parameters_default');
d_para=d_para_default;
f_para=f_para_default;
s_para=s_para_default;
p_para=p_para_default;

d_para.sel_index=get(handles.Data_listbox,'Value');
d_para.entries=get(handles.Data_listbox,'String');
[allspikes,d_para,f_para,d1,d2,d3,d4,listbox_str]=SPIKY_f_user_interface(d_para,f_para,1);
if isempty(allspikes)
    return
end

SPIKY_paras_set
SPIKY_plot_allspikes
SPIKY_paras_set

setappdata(handles.figure1,'data_parameters',d_para)
setappdata(handles.figure1,'figure_parameters',f_para)
setappdata(handles.figure1,'subplot_parameters',s_para)
setappdata(handles.figure1,'plot_parameters',p_para)
setappdata(handles.figure1,'allspikes',allspikes)

set(handles.Data_listbox,'Enable','off')
set(handles.Selection_data_uipanel,'HighlightColor','w')

set(handles.List_pushbutton,'Enable','off','FontWeight','normal')
set(handles.Workspace_pushbutton,'Enable','off','FontWeight','normal')
set(handles.Event_Detector_pushbutton,'Enable','off','FontWeight','normal')
set(handles.Para_data_uipanel,'Visible','on','HighlightColor','k')
set(handles.Update_pushbutton,'Enable','on','FontWeight','bold')
uicontrol(handles.Update_pushbutton)

if f_para.fast_mode==1
    Update_pushbutton_Callback(hObject, eventdata, handles)
end

end


function Workspace_pushbutton_Callback(hObject, eventdata, handles)

d_para_default=getappdata(handles.figure1,'data_parameters_default');
f_para_default=getappdata(handles.figure1,'figure_parameters_default');
s_para_default=getappdata(handles.figure1,'subplot_parameters_default');
p_para_default=getappdata(handles.figure1,'plot_parameters_default');
d_para=d_para_default;
f_para=f_para_default;
s_para=s_para_default;
p_para=p_para_default;

data.content='spike times';
data.default_variable=d_para.spikes_variable;
variables=evalin('base','who');

%if length(variables)==1 && ~isstruct(evalin('base',char(variables)))
%    spikes=evalin('base',char(variables));
%    variable='';
%else
    SPIKY('SPIKY_select_variable',gcbo,data,guidata(gcbo))
    handy=guidata(gcbo);
    variable=getappdata(handy.figure1,'variable');
    %data=getappdata(handy.figure1,'data');
%end

if ~isempty(variable) && ~strcmp(variable,'A9ZB1YC8X')
    data=getappdata(handy.figure1,'data');
    variable=['data.',variable];
    if iscell(eval(variable)) && size(eval(variable),2)>1
        spikes=squeeze(eval(variable));
    else
        lp=find(variable=='.',1,'last');
        if ~isempty(lp)
            spik_var=variable(1:lp-1);
            %disp([ 'num_trains=size(',spik_var,',2);' ])
            eval([ 'num_trains=size(',spik_var,',2);' ])
        end
        %disp([ '[spikes{1:num_trains}] = deal(',variable,');' ]);
        clear spikes
        if exist('num_trains','var')
            eval([ '[spikes{1:num_trains}] = deal(',variable,');' ]);
        end
    end
end

if ~exist('spikes','var') || isempty(spikes) || ~((iscell(spikes) && length(spikes)>1 && isnumeric(spikes{1})) || ...
        (isnumeric(spikes) && ndims(spikes)==2 && size(spikes,1)>1) || ...
        (iscell(spikes) && length(spikes)==1 && ndims(spikes{1})==2 && size(spikes{1},1)>1 && isnumeric(spikes{1})))
    if ~strcmp(variable,'A9ZB1YC8X')
        set(0,'DefaultUIControlFontSize',16);
        mbh=msgbox(sprintf('No variable with spikes has been specified. Please try again!'),'Warning','warn','modal');
        htxt = findobj(mbh,'Type','text');
        set(htxt,'FontSize',12,'FontWeight','bold')
        mb_pos=get(mbh,'Position');
        set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
        uiwait(mbh);
    end
    ret=1;
    return
end

SPIKY_check_spikes
if ret==1
    return
end
allspikes=spikes;

SPIKY_paras_set
SPIKY_plot_allspikes
SPIKY_paras_set

setappdata(handles.figure1,'data_parameters',d_para)
setappdata(handles.figure1,'figure_parameters',f_para)
setappdata(handles.figure1,'subplot_parameters',s_para)
setappdata(handles.figure1,'plot_parameters',p_para)
setappdata(handles.figure1,'allspikes',allspikes)

set(handles.Data_listbox,'Enable','off')
set(handles.Selection_data_uipanel,'HighlightColor','w')

set(handles.Para_data_uipanel,'Visible','on','HighlightColor','k')
set(handles.Update_pushbutton,'Enable','on','FontWeight','bold')
set(handles.List_pushbutton,'Enable','off','FontWeight','normal')
set(handles.Workspace_pushbutton,'Enable','off','FontWeight','normal')
set(handles.Event_Detector_pushbutton,'Enable','off','FontWeight','normal')
uicontrol(handles.Update_pushbutton)

end


function Update_pushbutton_Callback(hObject, eventdata, handles)

set(handles.Update_pushbutton,'UserData',1)
d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
s_para_default=getappdata(handles.figure1,'subplot_parameters_default');
p_para=getappdata(handles.figure1,'plot_parameters');
s_para=s_para_default;

SPIKY_check_update
if ret==1
    return
end

allspikes=getappdata(handles.figure1,'allspikes');
d_para.num_all_trains=length(allspikes);
SPIKY_paras_get
SPIKY_plot_updatespikes
if ret==1
    return
end

if d_para.num_select_train_groups==1
    set(handles.plots_profiles_popupmenu,'Value',0,'Enable','off')
    set(handles.fpara_group_matrices_checkbox,'Value',0,'Enable','off')
    f_para.group_matrices=0;
    f_para.profile_mode=1;
end
if d_para.num_trains<3
    set(handles.fpara_dendrograms_checkbox,'Value',0,'Enable','off')
    f_para.dendrograms=0;
end
if get(handles.plots_frame_sequence_checkbox,'Value')==0 && get(handles.plots_frame_comparison_checkbox,'Value')==0
    set(handles.fpara_group_matrices_checkbox,'Enable','off')
    set(handles.fpara_dendrograms_checkbox,'Enable','off')
    set(handles.fpara_colorbar_checkbox,'Enable','off')
end

if get(handles.Update_pushbutton,'UserData')==1
    SPIKY_paras_set

    setappdata(handles.figure1,'data_parameters',d_para)
    setappdata(handles.figure1,'figure_parameters',f_para)
    setappdata(handles.figure1,'subplot_parameters',s_para)
    setappdata(handles.figure1,'plot_parameters',p_para)
    setappdata(handles.figure1,'spikes',spikes)

    set(handles.Para_data_uipanel,'Visible','on','HighlightColor','w')
    set(handles.Selection_masures_uipanel,'Visible','on','HighlightColor','k')
    set(handles.Calculate_pushbutton,'FontWeight','bold')
    uicontrol(handles.Calculate_pushbutton)
end

end


function Calculate_pushbutton_Callback(hObject, eventdata, handles)

spikes=getappdata(handles.figure1,'spikes');
d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
h_para=getappdata(handles.figure1,'help_parameters');
s_para=getappdata(handles.figure1,'subplot_parameters');
p_para=getappdata(handles.figure1,'plot_parameters');

SPIKY_check_update
if ret==1
    return
end
SPIKY_check_calculate
if ret==1
    return
end

SPIKY_paras_get
SPIKY_calculate_distances
if ret==1
    return
end

f_para.rel_subplot_size=str2num(get(handles.fpara_subplot_size_edit,'String'));
if length(f_para.rel_subplot_size(f_para.rel_subplot_size>0))~=length(f_para.subplot_posi(f_para.subplot_posi>0))
    f_para.rel_subplot_size=ones(1,length(f_para.subplot_posi(f_para.subplot_posi>0)));
    set(handles.fpara_subplot_size_edit,'String',regexprep(num2str(f_para.rel_subplot_size),'\s+',' '))
end

%set(handles.subplot_stimulus_posi_edit,'Enable','off')
set(handles.subplot_spikes_posi_edit,'Enable','off')
set(handles.subplot_psth_posi_edit,'Enable','off')
set(handles.subplot_isi_posi_edit,'Enable','off')
set(handles.subplot_spike_posi_edit,'Enable','off')
set(handles.subplot_spike_realtime_posi_edit,'Enable','off')
set(handles.subplot_spike_forward_posi_edit,'Enable','off')
set(handles.subplot_spikesync_posi_edit,'Enable','off')
set(handles.subplot_spikeorder_posi_edit,'Enable','off')
set(handles.dpara_instants_edit,'Enable','off')
set(handles.dpara_selective_averages_edit,'Enable','off')
set(handles.dpara_triggered_averages_edit,'Enable','off')
set(handles.SIA_pushbutton,'Enable','off')
if d_para.num_select_group_trains==1
    set(handles.plots_profiles_popupmenu,'Enable','off')
end
if mod(f_para.plot_mode,2)==0
    set(handles.fpara_profile_norm_mode_popupmenu,'Enable','off')
    set(handles.fpara_extreme_spikes_checkbox,'Enable','off')
    set(handles.fpara_moving_average_mode_popupmenu,'Enable','off')
    set(handles.fpara_mao_edit,'Enable','off')
    set(handles.plots_profiles_popupmenu,'Enable','off')
    set(handles.fpara_subplot_size_edit,'Enable','off')
end

setappdata(handles.figure1,'data_parameters',d_para)
setappdata(handles.figure1,'figure_parameters',f_para)
setappdata(handles.figure1,'help_parameters',h_para)
setappdata(handles.figure1,'subplot_parameters',s_para)
setappdata(handles.figure1,'plot_parameters',p_para)
setappdata(handles.figure1,'measure_parameters',m_para)
setappdata(handles.figure1,'run_parameters',r_para)
setappdata(handles.figure1,'measure_results',m_res)
setappdata(handles.figure1,'spikes',spikes)
setappdata(handles.figure1,'results',results)

set(handles.Update_pushbutton,'Enable','off','FontWeight','normal')
set(handles.SM_pushbutton,'Enable','off')
set(handles.SS_pushbutton,'Enable','off')
set(handles.SG_pushbutton,'Enable','off')
set(handles.SS_pushbutton,'Enable','off')
set(handles.dpara_tmin_edit,'Enable','off')
set(handles.dpara_tmax_edit,'Enable','off')
set(handles.dpara_dts_edit,'Enable','off')
set(handles.dpara_thick_markers_edit,'Enable','off')
set(handles.dpara_thin_markers_edit,'Enable','off')
set(handles.dpara_select_train_mode_popupmenu,'Enable','off')
set(handles.dpara_train_groups_edit,'Enable','off')
set(handles.dpara_trains_edit,'Enable','off')
set(handles.dpara_select_train_groups_pushbutton,'Enable','off')
set(handles.dpara_select_trains_pushbutton,'Enable','off')
set(handles.dpara_group_names_edit,'Enable','off')
set(handles.dpara_group_sizes_edit,'Enable','off')
set(handles.dpara_thick_separators_edit,'Enable','off')
set(handles.dpara_thin_separators_edit,'Enable','off')
set(handles.dpara_comment_edit,'Enable','off')
if mod(f_para.plot_mode,2)==0 || f_para.ma_mode==1 || (m_para.num_pico_measures==0 && m_para.num_pili_measures==0)
    set(handles.fpara_mao_edit,'Enable','off')
end
if ~f_para.subplot_posi(m_para.psth)
    set(handles.fpara_psth_window_edit,'Enable','off')
end
set(handles.Para_figure_uipanel,'Visible','on')
if m_para.num_sel_bi_measures==0 || d_para.num_frames==0
    set(handles.plots_frame_comparison_checkbox,'Enable','off','Value',0)
    set(handles.plots_frame_sequence_checkbox,'Enable','off','Value',0)
end
if get(handles.plots_frame_sequence_checkbox,'Value')==0 && get(handles.record_movie_checkbox,'Value')==0
    set(handles.Para_movie_uipanel,'Visible','off')
    set(handles.Movie_uipanel,'Visible','off')
    set(handles.fpara_x_realtime_mode_checkbox,'Enable','off')
    set(handles.fpara_colorbar_checkbox,'Enable','off')
else
    set(handles.Para_movie_uipanel,'Visible','on')
    set(handles.Movie_current_text,'String',num2str(1))
    %set(handles.Movie_uipanel,'Visible','on','HighlightColor','k')
end
if ~isempty(get(handles.dpara_trains_edit,'String')) && length(find(diff(d_para.select_group_vect)))~=d_para.num_select_train_groups-1
    set(handles.fpara_select_train_mode_popupmenu,'String',{'All';'Select trains'})
    set(handles.fpara_train_groups_edit,'Enable','off')
    set(handles.fpara_select_train_groups_pushbutton,'Enable','off')
end

set(handles.Generator_pushbutton,'Enable','off','FontWeight','normal')
set(handles.Update_pushbutton,'Enable','off','FontWeight','normal')
set(handles.Calculate_pushbutton,'Enable','off','FontWeight','normal')
set(handles.Selection_masures_uipanel,'Visible','on','HighlightColor','w')
set(handles.Selection_plots_uipanel,'Visible','on','HighlightColor','k')
set(handles.Plot_pushbutton,'Enable','on','FontWeight','bold')
uicontrol(handles.Plot_pushbutton)

if exist('results','var') && isstruct(results)
    results=orderfields(results);
    assignin('base','SPIKY_results',results);
end

if f_para.fast_mode==1
    Plot_pushbutton_Callback(hObject, eventdata, handles)
end

end


function STO_pushbutton_Callback(hObject, eventdata, handles)

spikes=getappdata(handles.figure1,'spikes');
d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
h_para=getappdata(handles.figure1,'help_parameters');
s_para=getappdata(handles.figure1,'subplot_parameters');
p_para=getappdata(handles.figure1,'plot_parameters');

SPIKY_check_update
if ret==1
    return
end
SPIKY_check_calculate
if ret==1
    return
end

SPIKY_paras_get

para=p_para;
para.tmin=d_para.tmin;
para.tmax=d_para.tmax;
para.comment_string=d_para.comment_string;
para.print_mode=f_para.print_mode;

SPIKY_Synfire_plot(spikes,para,handles)                  % #####################################################

end


function Plot_pushbutton_Callback(hObject, eventdata, handles)

set(handles.Calculate_pushbutton,'Enable','off')

d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
h_para=getappdata(handles.figure1,'help_parameters');
s_para=getappdata(handles.figure1,'subplot_parameters');
p_para=getappdata(handles.figure1,'plot_parameters');
m_para=getappdata(handles.figure1,'measure_parameters');
r_para=getappdata(handles.figure1,'run_parameters');
m_res=getappdata(handles.figure1,'measure_results');
results=getappdata(handles.figure1,'results');
spikes=getappdata(handles.figure1,'spikes');

SPIKY_check_plot
if ret==1
    return
end

SPIKY_paras_get
if get(handles.fpara_spike_train_color_coding_mode_popupmenu,'Value')==2 && d_para.num_select_train_groups==1
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('Color-coding spike train groups does not make sense\nsince there is only one spike train group!'),'Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    set(handles.fpara_spike_train_color_coding_mode_popupmenu,'Value',1)
    return
end

SPIKY_plot_spikes
if get(handles.fpara_dendrograms_checkbox,'Value')==1 && f_para.num_trains<3
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('Dendrograms are only possible for at least three spike trains!'),'Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    set(handles.fpara_dendrograms_checkbox,'Value',0)
    f_para.dendrograms=0;
end

triu_indy=triu(ones(d_para.num_trains),1);
[ti_col,ti_row]=find(triu_indy');
f_para.num_select_pairs=f_para.num_trains*(f_para.num_trains-1)/2;
f_para.select_pairs=zeros(1,f_para.num_select_pairs);
pc=0;
for trac1=1:f_para.num_trains-1
    for trac2=trac1+1:f_para.num_trains
        pc=pc+1;
        f_para.select_pairs(pc)=find(ti_row==min(f_para.select_trains([trac1 trac2])) & ti_col==max(f_para.select_trains([trac1 trac2])));
    end
end
f_para.num_select_pairs=length(f_para.select_pairs);
d_para.mat_indy=nchoosek(1:d_para.num_trains,2);
f_para.mat_indy=nchoosek(1:f_para.num_trains,2);

if get(handles.plots_profiles_checkbox,'Value')==1
    SPIKY_plot_profiles
end
if (get(handles.plots_frame_comparison_checkbox,'Value')==1 || get(handles.plots_frame_sequence_checkbox,'Value')==1 || get(handles.record_movie_checkbox,'Value')==1) && ...
        m_para.num_sel_bi_measures>0
    
    if f_para.group_matrices && d_para.num_select_train_groups>1 && d_para.num_select_train_groups<f_para.num_trains
        grou_indy=triu(ones(f_para.num_trains),1);
        [ti_col2,ti_row2]=find(grou_indy');
    end

    SPIKY_matrices
    if ret==1
        return
    end
    if get(handles.plots_frame_sequence_checkbox,'Value')==1 && f_para.num_frames>1
        set(handles.Movie_frame_slider,'UserData',d_para.instants)
        set(handles.Movie_speed_slider,'Value',6)
        set(handles.Movie_speed_current_text,'String',num2str(6))
        set(handles.Selection_plots_uipanel,'Visible','on','HighlightColor','w')
        set(handles.Movie_uipanel,'Visible','on','HighlightColor','k')
        %frame_select=get(handles.Movie_frame_slider,'UserData');
        set(handles.Movie_last_text,'String',num2str(f_para.num_frames))
        set(handles.Movie_frame_slider,'SliderStep',[1, 1] / (get(handles.Movie_frame_slider,'Max')-get(handles.Movie_frame_slider,'Min')))
        set(handles.Movie_play_pushbutton,'FontWeight','bold')
        uicontrol(handles.Movie_play_pushbutton)
    end
end

if exist('results','var')
    results=orderfields(results);
    assignin('base','SPIKY_results',results);
    if f_para.save_results==1
        stri=get(handles.Data_listbox,'String');
        valu=get(handles.Data_listbox,'Value');
        if (valu==9 && strcmp(stri(valu),'SPIKY-Paper')) || (valu==10 && strcmp(stri(valu),'Reliable')) || ...
                (valu==11 && strcmp(stri(valu),'Random')) || (valu==12 && strcmp(stri(valu),'Bursts')) || (valu==2 && strcmp(stri(valu),'Spiking events'))
            f_para=orderfields(f_para);
            assignin('base','SPIKY_f_para',f_para);
            d_para=orderfields(d_para);
            assignin('base','SPIKY_d_para',d_para);
            m_para=orderfields(m_para);
            assignin('base','SPIKY_m_para',m_para);
            p_para=orderfields(p_para);
            assignin('base','SPIKY_p_para',p_para);
            if ~isempty(h_para)
                h_para=orderfields(h_para);
                assignin('base','SPIKY_h_para',h_para);
            end
            s_para=orderfields(s_para);
            assignin('base','SPIKY_s_para',s_para);
            r_para=orderfields(r_para);
            assignin('base','SPIKY_r_para',r_para);
            m_res=orderfields(m_res);
            assignin('base','SPIKY_m_res',m_res);
        end
    end
end

setappdata(handles.figure1,'data_parameters',d_para)
setappdata(handles.figure1,'figure_parameters',f_para)
setappdata(handles.figure1,'help_parameters',h_para)
setappdata(handles.figure1,'subplot_parameters',s_para)
setappdata(handles.figure1,'plot_parameters',p_para)
setappdata(handles.figure1,'measure_parameters',m_para)
setappdata(handles.figure1,'run_parameters',r_para)
setappdata(handles.figure1,'measure_results',m_res)
setappdata(handles.figure1,'results',results)

end


% #########################################################################
% #########################################################################
% ######################### Spike train generator #########################
% #########################################################################
% #########################################################################

function Generator_pushbutton_Callback(hObject, eventdata, handles)

set(handles.figure1,'Visible','off')
set(handles.List_pushbutton,'Enable','off')
set(handles.Workspace_pushbutton,'Enable','off')
set(handles.Event_Detector_pushbutton,'Enable','off')
%set(handles.Generator_pushbutton,'Enable','off')

f_para=getappdata(handles.figure1,'figure_parameters');
d_para=getappdata(handles.figure1,'data_parameters');
if ~isfield(d_para,'num_trains') || isempty(d_para.num_trains)
    d_para.num_trains=5;
end
if ~isfield(d_para,'dts') || isempty(d_para.dts)
    d_para.dts=0.01;
end
if ~isfield(d_para,'tmin') || isempty(d_para.tmin)
    d_para.tmin=0;
end
if ~isfield(d_para,'tmin') || isempty(d_para.tmax)
    d_para.tmax=10;
end

STG_Input_fig=figure('units','normalized','menubar','none','position',[0.05 0.1 0.4 0.8],'Name','Spike train generator',...
    'NumberTitle','off','Color',[0.9294 0.9176 0.851],'DeleteFcn',{@STG_Init_Input_callback}); % ,'WindowStyle','modal'

STG_Init_panel=uipanel('units','normalized','position',[0.05 0.67 0.9 0.3],'Title','Main parameters','FontSize',15,'FontWeight','bold');
STG_num_trains_text=uicontrol('style','text','units','normalized','position',[0.16 0.85 0.36 0.08],'string','Number of spike trains:',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized');
STG_tmin_text=uicontrol('style','text','units','normalized','position',[0.16 0.8 0.36 0.08],'string','Start time:',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized');
STG_tmax_text=uicontrol('style','text','units','normalized','position',[0.16 0.75 0.36 0.08],'string','End time:',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized');
STG_dts_text=uicontrol('style','text','units','normalized','position',[0.16 0.7 0.36 0.08],'string','Sampling interval:',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized');
STG_num_trains_edit=uicontrol('style','edit','units','normalized','position',[0.54 0.9 0.28 0.035],...
    'string',num2str(d_para.num_trains),'FontSize',13,'FontUnits','normalized','BackgroundColor','w');
STG_tmin_edit=uicontrol('style','edit','units','normalized','position',[0.54 0.85 0.28 0.035],...
    'string',num2str(d_para.tmin),'FontSize',13,'FontUnits','normalized','BackgroundColor','w');
STG_tmax_edit=uicontrol('style','edit','units','normalized','position',[0.54 0.8 0.28 0.035],...
    'string',num2str(d_para.tmax),'FontSize',13,'FontUnits','normalized','BackgroundColor','w');
STG_dts_edit=uicontrol('style','edit','units','normalized','position',[0.54 0.75 0.28 0.035],...
    'string',num2str(d_para.dts),'FontSize',13,'FontUnits','normalized','BackgroundColor','w');

STG_Init_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.25 0.69 0.2 0.04],'string','Cancel','FontSize',13,'FontUnits','normalized',...
    'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@STG_Init_Input_callback});
STG_Init_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.69 0.2 0.04],'string','OK','FontSize',13,'FontUnits','normalized','FontWeight','bold',...
    'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@STG_Init_Input_callback});
uicontrol(STG_Init_OK_pushbutton)

STG_Options_panel=uipanel('units','normalized','position',[0.05 0.13 0.9 0.51],'Title','Spike train patterns',...
    'FontSize',15,'FontWeight','bold','Visible','off');

STG_time_panel=uipanel('units','normalized','position',[0.02 0.72 0.48 0.26],'Title','Time','FontSize',13,'FontWeight','bold',...
    'parent',STG_Options_panel,'Visible','off');
STG_wmin_text=uicontrol('style','text','units','normalized','position',[0.03 0.6 0.45 0.33],'string','Start time:',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',STG_time_panel,'Visible','off');
STG_wmax_text=uicontrol('style','text','units','normalized','position',[0.03 0.17 0.45 0.33],'string','End time:',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',STG_time_panel,'Visible','off');
STG_wmin_edit=uicontrol('style','edit','units','normalized','position',[0.5 0.58 0.47 0.37],...
    'string',num2str(d_para.tmin),'FontSize',13,'FontUnits','normalized','BackgroundColor','w','parent',STG_time_panel,'Visible','off');
STG_wmax_edit=uicontrol('style','edit','units','normalized','position',[0.5 0.13 0.47 0.37],...
    'string',num2str(d_para.tmax),'FontSize',13,'FontUnits','normalized','BackgroundColor','w','parent',STG_time_panel,'Visible','off');

STG_spike_trains_panel=uipanel('units','normalized','position',[0.02 0.02 0.48 0.68],'Title','Spike trains','FontSize',13,...
    'FontWeight','bold','parent',STG_Options_panel,'Visible','off');
STG_spike_train_selection_panel=uicontrol('style','text','units','normalized','position',[0.1 0.8 0.35 0.15],'string','Selection:',...
    'HorizontalAlignment','left','FontSize',13,'parent',STG_spike_trains_panel,'Visible','off');
STG_select_train_mode_popupmenu=uicontrol('style','popupmenu','units','normalized','position',[0.5 0.7 0.43 0.26],...
    'string',{'All';'Select trains';'Select groups'},'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','BackgroundColor','w',...
    'parent',STG_spike_trains_panel,'CallBack',{@STG_select_train_mode_popupmenu_Callback},'Visible','off','Min',0,'Max',1,'Value',1);
STG_trains_text=uicontrol('style','text','units','normalized','position',[0.06 0.67 0.46 0.15],'string','Trains:',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','FontUnits','normalized','parent',STG_spike_trains_panel,'Visible','off');
STG_trains_edit=uicontrol('style','edit','units','normalized','position',[0.03 0.58 0.45 0.125],...
    'FontSize',11,'FontUnits','normalized','BackgroundColor','w','parent',STG_spike_trains_panel,'Enable','off','Value',0,'Visible','off');
STG_train_groups_text=uicontrol('style','text','units','normalized','position',[0.54 0.67 0.44 0.15],'string','Groups:',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',STG_spike_trains_panel,'Visible','off');
STG_train_groups_edit=uicontrol('style','edit','units','normalized','position',[0.52 0.58 0.45 0.125],...
    'FontSize',11,'FontUnits','normalized','BackgroundColor','w','parent',STG_spike_trains_panel,'Enable','off','Value',0,'Visible','off');
STG_trains_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.05 0.39 0.4 0.13],'string','Select trains','FontSize',13,'FontUnits','normalized',...
    'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@STG_select_trains_pushbutton_Callback},'parent',STG_spike_trains_panel,'Enable','off','Visible','off');
STG_train_groups_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.39 0.4 0.13],'string','Select groups','FontSize',13,'FontUnits','normalized',...
    'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@STG_select_train_groups_pushbutton_Callback},'parent',STG_spike_trains_panel,'Enable','off','Visible','off');
STG_group_names_text=uicontrol('style','text','units','normalized','position',[0.045 0.14 0.45 0.16],'string','Group names:',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',STG_spike_trains_panel,'Visible','off');
STG_group_names_edit=uicontrol('style','edit','units','normalized','position',[0.51 0.185 0.45 0.12],...
    'FontSize',11,'FontUnits','normalized','BackgroundColor','w','parent',STG_spike_trains_panel,'Visible','off');
STG_group_sizes_text=uicontrol('style','text','units','normalized','position',[0.045 0.01 0.45 0.16],'string','Group sizes:',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',STG_spike_trains_panel,'Visible','off');
STG_group_sizes_edit=uicontrol('style','edit','units','normalized','position',[0.51 0.035 0.45 0.12],...
    'FontSize',11,'FontUnits','normalized','BackgroundColor','w','parent',STG_spike_trains_panel,'Visible','off');

STG_sys_uibg=uibuttongroup('units','normalized','position',[0.52 0.37 0.46 0.61],'Title','Patterns','FontSize',13,...
    'FontWeight','bold','parent',STG_Options_panel,'SelectionChangeFcn',{@STG_radiobutton_callback},'Visible','off');
STG_periodic_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.05 0.69 0.33 0.14],'string','Periodic',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',STG_sys_uibg,'Visible','off');
STG_splay_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.05 0.49 0.33 0.14],'string','Splay',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',STG_sys_uibg,'Visible','off');
STG_uniform_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.05 0.29 0.33 0.14],'string','Uniform',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',STG_sys_uibg,'Visible','off');
STG_poisson_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.05 0.09 0.33 0.14],'string','Poisson',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',STG_sys_uibg,'Value',1,'Visible','off');
STG_rate_text=uicontrol('style','text','units','normalized','position',[0.45 0.86 0.3 0.14],'string','Rate',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',STG_sys_uibg,'Visible','off');
STG_periodic_rate_edit=uicontrol('style','edit','units','normalized','position',[0.4 0.68 0.24 0.15],'String','1',...
    'FontSize',11,'FontUnits','normalized','BackgroundColor','w','parent',STG_sys_uibg,'Enable','off','Visible','off');
STG_splay_rate_edit=uicontrol('style','edit','units','normalized','position',[0.4 0.48 0.24 0.15],'String','1',...
    'FontSize',11,'FontUnits','normalized','BackgroundColor','w','parent',STG_sys_uibg,'Enable','off','Visible','off');
STG_uniform_rate_edit=uicontrol('style','edit','units','normalized','position',[0.4 0.28 0.24 0.15],'String','1',...
    'FontSize',11,'FontUnits','normalized','BackgroundColor','w','parent',STG_sys_uibg,'Enable','off','Visible','off');
STG_poisson_rate_edit=uicontrol('style','edit','units','normalized','position',[0.4 0.08 0.24 0.15],'String','1',...
    'FontSize',11,'FontUnits','normalized','BackgroundColor','w','parent',STG_sys_uibg,'Visible','off');
STG_jitter_text=uicontrol('style','text','units','normalized','position',[0.77 0.86 0.22 0.14],'string','Jitter',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',STG_sys_uibg,'Visible','off');
STG_periodic_jitter_edit=uicontrol('style','edit','units','normalized','position',[0.72 0.68 0.24 0.15],'String','0',...
    'FontSize',11,'FontUnits','normalized','BackgroundColor','w','parent',STG_sys_uibg,'Enable','off','Visible','off');
STG_splay_jitter_edit=uicontrol('style','edit','units','normalized','position',[0.72 0.48 0.24 0.15],'String','0',...
    'FontSize',11,'FontUnits','normalized','BackgroundColor','w','parent',STG_sys_uibg,'Enable','off','Visible','off');

STG_add_Replace_uibg=uibuttongroup('units','normalized','position',[0.52 0.18 0.46 0.17],'Title','Mode','FontSize',13,'FontUnits','normalized',...
    'FontWeight','bold','parent',STG_Options_panel,'SelectionChangeFcn',{@STG_radiobutton_callback},'Visible','off');
STG_add_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.1 0.15 0.43 0.7],'string','Add',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',STG_add_Replace_uibg,'Value',1,'Visible','off');
STG_replace_radiobutton=uicontrol('style','radiobutton','units','normalized','position',[0.55 0.15 0.43 0.7],'string','Replace',...
    'HorizontalAlignment','left','FontSize',13,'FontUnits','normalized','parent',STG_add_Replace_uibg,'Visible','off');

STG_Options_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.05 0.2 0.085],'string','OK','FontSize',13,'FontUnits','normalized',...
    'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@STG_Options_callback},'parent',STG_Options_panel,'Visible','off');

STG_Final_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.125 0.05 0.15 0.04],'string','Cancel','FontSize',13,'FontUnits','normalized',...
    'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@STG_Final_callback},'Visible','off');
STG_Final_Reset_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.325 0.05 0.15 0.04],'string','Reset','FontSize',13,'FontUnits','normalized',...
    'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@STG_Final_Reset_callback},'Visible','off');
STG_Final_Edit_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.525 0.05 0.15 0.04],'string','Edit','FontSize',13,'FontUnits','normalized',...
    'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_edit_spikes},'Visible','off');
STG_Final_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.725 0.05 0.15 0.04],'string','Done','FontSize',13,'FontUnits','normalized','FontWeight','bold',...
    'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@STG_Final_callback},'Visible','off','UserData',0);




SPIKY_hints_STG

spike_lh=getappdata(handles.figure1,'spike_lh');
if ~isempty(spike_lh)
    STG_Init_Input_callback
end

    function STG_Init_Input_callback(varargin)

        if gcbo==STG_Init_OK_pushbutton || gcbo==handles.Generator_pushbutton

            num_trains_str_in=get(STG_num_trains_edit,'String');
            num_trains_in=unique(round(abs(str2double(regexprep(num_trains_str_in,f_para.regexp_str_scalar_integer,'')))));
            if ~isempty(num_trains_in)
                num_trains_str_out=num2str(num_trains_in(1));
            else
                num_trains_str_out='';
            end
            tmin_str_in=get(STG_tmin_edit,'String');
            tmin_in=unique(str2double(regexprep(tmin_str_in,f_para.regexp_str_scalar_float,'')));
            if ~isempty(tmin_in)
                tmin_str_out=num2str(tmin_in(1));
            else
                tmin_str_out='';
            end
            tmax_str_in=get(STG_tmax_edit,'String');
            tmax_in=unique(str2double(regexprep(tmax_str_in,f_para.regexp_str_scalar_float,'')));
            if ~isempty(tmax_in)
                tmax_str_out=num2str(tmax_in(1));
            else
                tmax_str_out='';
            end
            dts_str_in=get(STG_dts_edit,'String');
            dts_in=unique(abs(str2double(regexprep(dts_str_in,f_para.regexp_str_scalar_float,''))));
            if ~isempty(dts_in)
                dts_str_out=num2str(dts_in(1));
            else
                dts_str_out='';
            end

            if ~strcmp(num_trains_str_in,num_trains_str_out) || ~strcmp(tmin_str_in,tmin_str_out) || ...
                    ~strcmp(tmax_str_in,tmax_str_out) || ~strcmp(dts_str_in,dts_str_out)
                if ~isempty(num_trains_str_out)
                    set(STG_num_trains_edit,'String',num_trains_str_out)
                else
                    set(STG_num_trains_edit,'String',num2str(d_para.num_trains))
                end
                if ~isempty(tmin_str_out)
                    set(STG_tmin_edit,'String',tmin_str_out)
                else
                    set(STG_tmin_edit,'String',num2str(d_para.tmin))
                end
                if ~isempty(tmax_str_out)
                    set(STG_tmax_edit,'String',tmax_str_out)
                else
                    set(STG_tmax_edit,'String',num2str(d_para.tmax))
                end
                if ~isempty(dts_str_out)
                    set(STG_dts_edit,'String',dts_str_out)
                else
                    set(STG_dts_edit,'String',num2str(d_para.dts))
                end
                set(0,'DefaultUIControlFontSize',16);
                mbh=msgbox('The input has been corrected !','Warning','warn','modal');
                htxt = findobj(mbh,'Type','text');
                set(htxt,'FontSize',12,'FontWeight','bold')
                mb_pos=get(mbh,'Position');
                set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.3 mb_pos(4)])
                uiwait(mbh);
                return
            end

            num_trains_in=str2double(num_trains_str_in);
            if isempty(num_trains_in) || mod(num_trains_in,1)~=0 || num_trains_in<2
                set(0,'DefaultUIControlFontSize',16);
                mbh=msgbox(sprintf('The number of spike trains must be an\ninteger value larger than 1 !'),'Warning','warn','modal');
                htxt = findobj(mbh,'Type','text');
                set(htxt,'FontSize',12,'FontWeight','bold')
                mb_pos=get(mbh,'Position');
                set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                uiwait(mbh);
                set(STG_num_trains_edit,'String',num2str(d_para.num_trains))
                return
            end
            tmin_in=str2double(tmin_str_in);
            tmax_in=str2double(tmax_str_in);
            dts_in=str2double(dts_str_in);
            if tmin_in>=tmax_in
                set(0,'DefaultUIControlFontSize',16);
                mbh=msgbox(sprintf('The beginning of the analysis window must come\nbefore the end of the analysis window!'),'Warning','warn','modal');
                htxt = findobj(mbh,'Type','text');
                set(htxt,'FontSize',12,'FontWeight','bold')
                mb_pos=get(mbh,'Position');
                set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                uiwait(mbh);
                set(STG_tmin_edit,'String',num2str(d_para.tmin))
                set(STG_tmax_edit,'String',num2str(d_para.tmax))
                return
            end
            if dts_in>=tmax_in-tmin_in
                set(0,'DefaultUIControlFontSize',16);
                mbh=msgbox(sprintf('The sampling interval must be smaller than the analysis window!'),'Warning','warn','modal');
                htxt = findobj(mbh,'Type','text');
                set(htxt,'FontSize',12,'FontWeight','bold')
                mb_pos=get(mbh,'Position');
                set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                uiwait(mbh);
                set(STG_tmin_edit,'String',num2str(d_para.tmin))
                set(STG_tmax_edit,'String',num2str(d_para.tmax))
                set(STG_dts_edit,'String',num2str(d_para.dts))
                return
            end
            d_para.num_trains=str2double(get(STG_num_trains_edit,'String'));
            d_para.tmin=str2double(get(STG_tmin_edit,'String'));
            d_para.tmax=str2double(get(STG_tmax_edit,'String'));
            d_para.dts=str2double(get(STG_dts_edit,'String'));

            set(STG_wmin_edit,'string',num2str(d_para.tmin));
            set(STG_wmax_edit,'string',num2str(d_para.tmax));

            setappdata(handles.figure1,'data_parameters',d_para)
            set(STG_num_trains_edit,'Enable','off')
            set(STG_tmin_edit,'Enable','off')
            set(STG_tmax_edit,'Enable','off')
            set(STG_dts_edit,'Enable','off')
            set(STG_Init_Cancel_pushbutton,'Enable','off')
            set(STG_Init_OK_pushbutton,'Enable','off')

            set(STG_Options_panel,'Visible','on')
            set(STG_time_panel,'Visible','on')
            set(STG_wmin_text,'Visible','on')
            set(STG_wmax_text,'Visible','on')
            set(STG_wmin_edit,'Visible','on')
            set(STG_wmax_edit,'Visible','on')
            set(STG_spike_trains_panel,'Visible','on')
            set(STG_spike_train_selection_panel,'Visible','on')
            set(STG_select_train_mode_popupmenu,'Visible','on')
            set(STG_trains_text,'Visible','on')
            set(STG_trains_edit,'Visible','on')
            set(STG_train_groups_text,'Visible','on')
            set(STG_train_groups_edit,'Visible','on')
            set(STG_trains_pushbutton,'Visible','on')
            set(STG_train_groups_pushbutton,'Visible','on')
            set(STG_group_names_text,'Visible','on')
            set(STG_group_names_edit,'Visible','on')
            set(STG_group_sizes_text,'Visible','on')
            set(STG_group_sizes_edit,'Visible','on')
            set(STG_sys_uibg,'Visible','on')
            set(STG_periodic_radiobutton,'Visible','on')
            set(STG_splay_radiobutton,'Visible','on')
            set(STG_uniform_radiobutton,'Visible','on')
            set(STG_poisson_radiobutton,'Visible','on')
            set(STG_rate_text,'Visible','on')
            set(STG_periodic_rate_edit,'Visible','on')
            set(STG_splay_rate_edit,'Visible','on')
            set(STG_uniform_rate_edit,'Visible','on')
            set(STG_poisson_rate_edit,'Visible','on')
            set(STG_jitter_text,'Visible','on')
            set(STG_periodic_jitter_edit,'Visible','on')
            set(STG_splay_jitter_edit,'Visible','on')
            set(STG_add_Replace_uibg,'Visible','on')
            set(STG_add_radiobutton,'Visible','on')
            set(STG_replace_radiobutton,'Visible','on')
            set(STG_Options_OK_pushbutton,'Visible','on')
            set(STG_Final_Cancel_pushbutton,'Visible','on')
            set(STG_Final_Reset_pushbutton,'Visible','on')
            set(STG_Final_Edit_pushbutton,'Visible','on')
            set(STG_Final_OK_pushbutton,'Visible','on')

            STG(hObject, eventdata, handles)
            set(STG_Options_OK_pushbutton,'FontWeight','bold')
            set(STG_Final_OK_pushbutton,'FontWeight','bold')
            uicontrol(STG_Final_OK_pushbutton)
        elseif gcbo==STG_Init_Cancel_pushbutton || gcbo==STG_Input_fig
            fig=figure(f_para.num_fig);
            STG_UserData=get(fig,'UserData');
            if ~isempty(STG_UserData)
                set(STG_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
                %set(STG_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
                set(fig,'UserData',STG_UserData);
            end
            if get(STG_Final_OK_pushbutton,'UserData')~=1 && ~isappdata(f_para.num_fig,'closed')
                uipushtool_new_Callback(hObject, eventdata, handles)
            end
            delete(STG_Input_fig)
        end
    end


    function STG_select_train_mode_popupmenu_Callback(varargin)

        if get(STG_select_train_mode_popupmenu,'Value')==1
            set(STG_train_groups_edit,'String','')
            set(STG_trains_edit,'String','')
            set(STG_train_groups_edit,'Enable','off')
            set(STG_trains_edit,'Enable','off')
            set(STG_train_groups_pushbutton,'Enable','off')
            set(STG_trains_pushbutton,'Enable','off')
        elseif get(STG_select_train_mode_popupmenu,'Value')==2
            set(STG_train_groups_edit,'String','')
            set(STG_train_groups_edit,'Enable','off')
            set(STG_trains_edit,'Enable','on')
            set(STG_train_groups_pushbutton,'Enable','off')
            set(STG_trains_pushbutton,'Enable','on')
        else
            set(STG_trains_edit,'String','')
            set(STG_trains_edit,'Enable','off')
            set(STG_train_groups_edit,'Enable','on')
            set(STG_train_groups_pushbutton,'Enable','on')
            set(STG_trains_pushbutton,'Enable','off')
        end
    end


    function STG_select_trains_pushbutton_Callback(varargin)

        d_para=getappdata(handles.figure1,'data_parameters');
        STG_select_trains.fig=figure('units','normalized','menubar','none','position',[0.3 0.05 0.4 0.9],...
            'Name','Train selection','NumberTitle','off',...
            'Color',[0.9294 0.9176 0.851],'WindowStyle','modal');
        STG_select_trains.t1=uicontrol('style','text','units','normalized','position',[0.3 0.9 0.4 0.075],...
            'string','Please select trains:','FontSize',12,'FontWeight','bold');
        STG_select_trains.lb=uicontrol('style','listbox','units','normalized','position',[0.4 0.12 0.2 0.8],'FontSize',12,...
            'string',num2str((1:d_para.num_all_trains)'),'Min',1,'Max',max([d_para.num_all_trains 3]));
        set(STG_select_trains.lb,'Value',str2num(get(STG_trains_edit,'String')))
        STG_select_trains.pb=uicontrol('style','pushbutton','units','normalized','position',[0.4 0.04 0.2 0.04],'string','OK','FontSize',14,...
            'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@STG_select_trains_pushbutton_callback});

        function STG_select_trains_pushbutton_callback(varargin)
            d_para.preselect_trains=get(STG_select_trains.lb,'Value');
            set(STG_trains_edit,'String',num2str(get(STG_select_trains.lb,'Value')))
            setappdata(handles.figure1,'data_parameters',d_para);
            close(gcbf)
        end
    end


    function STG_select_train_groups_pushbutton_Callback(varargin)

        d_para=getappdata(handles.figure1,'data_parameters');
        
        ds=strtrim(get(STG_group_names_edit,'String'));
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
        
        d_para.all_train_group_sizes=str2num(get(STG_group_sizes_edit,'String'));
        d_para.num_all_train_groups=length(d_para.all_train_group_sizes);

        if d_para.num_all_train_groups>1
            STG_select_train_groups.fig=figure('units','normalized','menubar','none','position',[0.3 0.05 0.4 0.9],...
                'Name','Train group selection','NumberTitle','off','Color',[0.9294 0.9176 0.851],'WindowStyle','modal');
            STG_select_train_groups.t1=uicontrol('style','text','units','normalized','position',[0.3 0.9 0.4 0.075],...
                'string','Please select train groups:','FontSize',12,'FontWeight','bold');
            STG_select_train_groups.lb=uicontrol('style','listbox','units','normalized','position',[0.4 0.12 0.2 0.8],'FontSize',10,...
                'string',num2str((1:d_para.num_all_train_groups)'),'Min',1,'Max',d_para.num_all_train_groups+1);
            if ~isempty(get(STG_train_groups_edit,'String'))
                set(STG_select_train_groups.lb,'Value',str2num(get(STG_train_groups_edit,'String')))
            end
            STG_select_train_groups.pb=uicontrol('style','pushbutton','units','normalized','position',[0.4 0.04 0.2 0.04],...
                'string','OK','FontSize',14,'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@STG_select_train_groups_pushbutton_callback});
        else
            set(0,'DefaultUIControlFontSize',16);
            mbh=msgbox(sprintf('This action does not make sense for just one group.'),'Warning','warn','modal');
            htxt = findobj(mbh,'Type','text');
            set(htxt,'FontSize',12,'FontWeight','bold')
            mb_pos=get(mbh,'Position');
            set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
            uiwait(mbh);
            set(STG_train_groups_edit,'String','')
            set(STG_train_groups_edit,'Enable','off')
            set(STG_train_groups_pushbutton,'Enable','off')
            set(STG_select_train_mode_popupmenu,'Value',1)
        end

        function STG_select_train_groups_pushbutton_callback(varargin)
            d_para.select_train_groups=get(STG_select_train_groups.lb,'Value');
            set(STG_train_groups_edit,'String',num2str(get(STG_select_train_groups.lb,'Value')))
            setappdata(handles.figure1,'data_parameters',d_para);
            close(gcbf)
        end
    end


    function STG_radiobutton_callback(varargin)

        d_para=getappdata(handles.figure1,'data_parameters');
        set(STG_periodic_rate_edit,'Enable','off')
        set(STG_periodic_jitter_edit,'Enable','off')
        set(STG_splay_rate_edit,'Enable','off')
        set(STG_splay_jitter_edit,'Enable','off')
        set(STG_uniform_rate_edit,'Enable','off')
        set(STG_poisson_rate_edit,'Enable','off')
        if get(STG_periodic_radiobutton,'Value')==1
            set(STG_periodic_rate_edit,'Enable','on')
            set(STG_periodic_jitter_edit,'Enable','on')
        elseif get(STG_splay_radiobutton,'Value')==1
            set(STG_splay_rate_edit,'Enable','on')
            set(STG_splay_jitter_edit,'Enable','on')
        elseif get(STG_uniform_radiobutton,'Value')==1
            set(STG_uniform_rate_edit,'Enable','on')
        elseif get(STG_poisson_radiobutton,'Value')==1
            set(STG_poisson_rate_edit,'Enable','on')
        end
    end


    function STG_Options_callback(varargin)

        wmin_str_in=get(STG_wmin_edit,'String');
        wmin_in=unique(str2num(regexprep(wmin_str_in,f_para.regexp_str_scalar_float,'')));
        if ~isempty(wmin_in)
            wmin_str_out=num2str(wmin_in(1));
        else
            wmin_str_out='';
        end
        wmax_str_in=get(STG_wmax_edit,'String');
        wmax_in=unique(str2num(regexprep(wmax_str_in,f_para.regexp_str_scalar_float,'')));
        if ~isempty(wmax_in)
            wmax_str_out=num2str(wmax_in(1));
        else
            wmax_str_out='';
        end
        if get(STG_periodic_radiobutton,'Value')==1
            rate_str_in=get(STG_periodic_rate_edit,'String');
            jitter_str_in=get(STG_periodic_jitter_edit,'String');
            jitter_in=unique(abs(str2double(regexprep(jitter_str_in,f_para.regexp_str_scalar_float,''))));
            if ~isempty(jitter_in)
                jitter_str_out=num2str(jitter_in(1));
            else
                jitter_str_out='';
            end
        elseif get(STG_splay_radiobutton,'Value')==1
            rate_str_in=get(STG_splay_rate_edit,'String');
            jitter_str_in=get(STG_splay_jitter_edit,'String');
            jitter_in=unique(abs(str2double(regexprep(jitter_str_in,f_para.regexp_str_scalar_float,''))));
            if ~isempty(jitter_in)
                jitter_str_out=num2str(jitter_in(1));
            else
                jitter_str_out='';
            end
        elseif get(STG_uniform_radiobutton,'Value')==1
            rate_str_in=get(STG_uniform_rate_edit,'String');
            %jitter_str_in=''; jitter_str_out='';
        elseif get(STG_poisson_radiobutton,'Value')==1
            rate_str_in=get(STG_poisson_rate_edit,'String');
            %jitter_str_in=''; jitter_str_out='';
        end
        rate_in=unique(abs(str2double(regexprep(rate_str_in,f_para.regexp_str_scalar_float,''))));
        if ~isempty(rate_in)
            rate_str_out=num2str(rate_in(1));
        else
            rate_str_out='';
        end


        if ~strcmp(wmin_str_in,wmin_str_out) || ~strcmp(wmax_str_in,wmax_str_out) || ~strcmp(rate_str_in,rate_str_out) || ...
                ((get(STG_periodic_radiobutton,'Value')==1 || get(STG_splay_radiobutton,'Value')==1) && ~strcmp(jitter_str_in,jitter_str_out))

            if ~isempty(wmin_str_out)
                set(STG_wmin_edit,'String',wmin_str_out)
            else
                set(STG_wmin_edit,'String',num2str(d_para.tmin))
            end
            if ~isempty(wmax_str_out)
                set(STG_wmax_edit,'String',wmax_str_out)
            else
                set(STG_wmax_edit,'String',num2str(d_para.tmax))
            end
            if get(STG_periodic_radiobutton,'Value')==1
                if ~isempty(rate_str_out)
                    set(STG_periodic_rate_edit,'String',rate_str_out)
                else
                    set(STG_periodic_rate_edit,'String','1')
                end
                if ~isempty(jitter_str_out)
                    set(STG_periodic_jitter_edit,'String',jitter_str_out)
                else
                    set(STG_periodic_jitter_edit,'String','0')
                end
            elseif get(STG_splay_radiobutton,'Value')==1
                if ~isempty(rate_str_out)
                    set(STG_splay_rate_edit,'String',rate_str_out)
                else
                    set(STG_splay_rate_edit,'String','1')
                end
                if ~isempty(jitter_str_out)
                    set(STG_splay_jitter_edit,'String',jitter_str_out)
                else
                    set(STG_splay_jitter_edit,'String','0')
                end
            elseif get(STG_uniform_radiobutton,'Value')==1
                if ~isempty(rate_str_out)
                    set(STG_uniform_rate_edit,'String',rate_str_out)
                else
                    set(STG_uniform_rate_edit,'String','1')
                end
            elseif get(STG_poisson_radiobutton,'Value')==1
                if ~isempty(rate_str_out)
                    set(STG_poisson_rate_edit,'String',rate_str_out)
                else
                    set(STG_poisson_rate_edit,'String','1')
                end
            end
            set(0,'DefaultUIControlFontSize',16);
            mbh=msgbox('The input has been corrected !','Warning','warn','modal');
            htxt = findobj(mbh,'Type','text');
            set(htxt,'FontSize',12,'FontWeight','bold')
            mb_pos=get(mbh,'Position');
            set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.3 mb_pos(4)])
            uiwait(mbh);
            return
        end
        wmin_in=str2double(wmin_str_in);
        wmax_in=str2double(wmax_str_in);
        if wmin_in>=wmax_in
            set(0,'DefaultUIControlFontSize',16);
            mbh=msgbox(sprintf('The beginning of the analysis window can not be later\nthan the end of the analysis window!'),'Warning','warn','modal');
            htxt = findobj(mbh,'Type','text');
            set(htxt,'FontSize',12,'FontWeight','bold')
            mb_pos=get(mbh,'Position');
            set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
            uiwait(mbh);
            set(STG_wmin_edit,'String',num2str(d_para.tmin))
            set(STG_wmax_edit,'String',num2str(d_para.tmax))
            return
        end


        f_para=getappdata(handles.figure1,'figure_parameters');
        d_para=getappdata(handles.figure1,'data_parameters');

        STG_UserData.fh=figure(f_para.num_fig);
        STG_UserData=get(STG_UserData.fh,'UserData');

        d_para.select_train_mode=get(STG_select_train_mode_popupmenu,'Value');
        if d_para.select_train_mode==2
            d_para.preselect_trains=str2num(get(STG_trains_edit,'String'));
            d_para.preselect_trains=d_para.preselect_trains(mod(d_para.preselect_trains,1)==0);
            d_para.preselect_trains=d_para.preselect_trains(d_para.preselect_trains>=1 & d_para.preselect_trains<=d_para.num_all_trains);
            set(STG_trains_edit,'String',regexprep(num2str(d_para.preselect_trains),'\s+',' '))
        elseif d_para.select_train_mode==3
            d_para.select_train_groups=str2num(get(STG_train_groups_edit,'String'));
            set(STG_train_groups_edit,'String',regexprep(num2str(d_para.select_train_groups),'\s+',' '))
        end

        if isfield(d_para,'all_train_group_names') && isfield(d_para,'all_train_group_sizes') && ~isempty(d_para.all_train_group_sizes) && length(d_para.all_train_group_names)==length(d_para.all_train_group_sizes)
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

        d_para.select_train_mode=get(STG_select_train_mode_popupmenu,'Value');
        if d_para.select_train_mode==1                                       % All
            d_para.select_trains=1:d_para.num_all_trains;
        elseif d_para.select_train_mode==2                                   % Selected trains
            d_para.select_trains=d_para.preselect_trains;
        elseif d_para.select_train_mode==3                                   % Selected groups
            d_para.select_trains=[];
            for gc=d_para.select_train_groups
                d_para.select_trains=[d_para.select_trains find(d_para.group_vect==gc)];
            end
        end
        wmin=str2double(get(STG_wmin_edit,'String'));
        wmax=str2double(get(STG_wmax_edit,'String'));
        if get(STG_periodic_radiobutton,'Value')==1
            rate=str2double(get(STG_periodic_rate_edit,'String'));
            jitter=str2double(get(STG_periodic_jitter_edit,'String'));
        elseif get(STG_splay_radiobutton,'Value')==1
            rate=str2double(get(STG_splay_rate_edit,'String'));
            jitter=str2double(get(STG_splay_jitter_edit,'String'));
        elseif get(STG_uniform_radiobutton,'Value')==1
            rate=str2double(get(STG_uniform_rate_edit,'String'));
        elseif get(STG_poisson_radiobutton,'Value')==1
            rate=str2double(get(STG_poisson_rate_edit,'String'));
        end
        for trac=d_para.select_trains
            if get(STG_replace_radiobutton,'Value')
                obi=findobj(gca,'Type','line');
                yes=zeros(1,length(obi));
                for oc=1:length(obi)
                    obi_x=get(obi(oc),'XData');
                    obi_y=get(obi(oc),'YData');
                    st_y=0.05+(d_para.num_trains-1-(trac-1)+[0.05 0.95])/d_para.num_trains;
                    yes(oc)=(obi_x(1)>=wmin  & obi_x(2)>=wmin & obi_x(1)<=wmax  & obi_x(2)<=wmax & obi_y(1)==st_y(1) & obi_y(2)==st_y(2));
                    if yes(oc)==1
                        index=find(STG_UserData.lh{trac} == obi(oc));
                        STG_UserData.lh{trac}(index)=[];
                        STG_UserData.STG_spikes{trac}(index)=[];
                        delete(obi(oc))
                    end
                end
            end
            num_spikes=numel(STG_UserData.STG_spikes{trac});
            if get(STG_periodic_radiobutton,'Value')==1
                dummy=wmin:1/rate:wmax;
                dummy=dummy+jitter*randn(1,length(dummy));
            elseif get(STG_splay_radiobutton,'Value')==1
                dummy=(wmin:1/rate:wmax)+(trac-1)/d_para.num_trains*1/rate;
                dummy=dummy+jitter*randn(1,length(dummy));
            elseif get(STG_uniform_radiobutton,'Value')==1
                dummy=wmin+sort(rand(1,round(rate*(wmax-wmin)))*(wmax-wmin));
            elseif get(STG_poisson_radiobutton,'Value')==1
                dummy=wmin+cumsum(SPIKY_f_poisson(round(rate*(wmax-wmin)*2),rate,0));
            end
            dummy=unique(round(dummy/STG_UserData.dts)*STG_UserData.dts);
            dummy=dummy(dummy>=wmin & dummy<=wmax);
            dummy=setdiff(dummy,STG_UserData.STG_spikes{trac});

            STG_UserData.STG_spikes{trac}(num_spikes+(1:length(dummy)))=dummy;
            for sc=1:1:length(dummy)
                STG_UserData.lh{trac}=[STG_UserData.lh{trac} line(dummy(sc)*ones(1,2),0.05+(d_para.num_trains-1-(trac-1)+[0.05 0.95])/d_para.num_trains,...
                    'Color',STG_UserData.spike_col,'LineStyle',STG_UserData.spike_ls,'LineWidth',STG_UserData.spike_lw)];
            end
        end


        d_para.select_trains=1:d_para.num_trains;

        set(STG_UserData.fh,'Userdata',STG_UserData)
        set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
        set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
        set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData})
        set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
        set(STG_UserData.fh,'Userdata',STG_UserData)
    end


    function STG_Final_Reset_callback(varargin)

        f_para=getappdata(handles.figure1,'figure_parameters');
        fig=figure(f_para.num_fig);
        cla
        spike_lh=[];
        setappdata(handles.figure1,'spike_lh',spike_lh);
        STG_UserData=get(fig,'UserData');
        STG_UserData=rmfield(STG_UserData,'STG_spikes');
        set(fig,'UserData',STG_UserData);
        STG(hObject, eventdata, handles)
    end


    function STG_Final_callback(varargin)

        if gcbo==STG_Final_OK_pushbutton
            set(STG_Final_OK_pushbutton,'UserData',1)
            set(handles.figure1,'Visible','on')
            fig=figure(f_para.num_fig);
            STG_UserData=get(fig,'UserData');
            allspikes=SPIKY_f_convert_matrix(STG_UserData.STG_spikes,d_para.dts,d_para.tmin);
            set(STG_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
            set(STG_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
            setappdata(handles.figure1,'data_parameters',d_para)
            setappdata(handles.figure1,'allspikes',allspikes)
            STG_done(hObject, eventdata, handles)
            delete(STG_Input_fig)
        elseif gcbo==STG_Final_Cancel_pushbutton
            set(STG_num_trains_edit,'Enable','on')
            set(STG_tmin_edit,'Enable','on')
            set(STG_tmax_edit,'Enable','on')
            set(STG_dts_edit,'Enable','on')
            set(STG_Init_Cancel_pushbutton,'Enable','on')
            set(STG_Init_OK_pushbutton,'Enable','on')
            set(STG_Options_panel,'Visible','off')
            set(STG_Final_Cancel_pushbutton,'Visible','off')
            set(STG_Final_Edit_pushbutton,'Visible','off')
            set(STG_Final_Reset_pushbutton,'Visible','off')
            set(STG_Final_OK_pushbutton,'Visible','off')
            fig=figure(f_para.num_fig);
            STG_UserData=get(fig,'UserData');
            STG_UserData=rmfield(STG_UserData,'STG_spikes');
            STG_UserData=rmfield(STG_UserData,'cm');
            set(STG_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
            set(STG_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
            set(fig,'UserData',STG_UserData);
            set(STG_UserData.tx(1),'str','');
            set(STG_UserData.tx(2),'str','');
            cla
            set(gca,'XTick',[],'YTick',[]);
            xlabel('')
        end
    end




% ##################################################################
% ##################################################################
% ##################################################################

    function SPIKY_edit_spikes(varargin)

        set(handles.figure1,'Visible','off')

        d_para=getappdata(handles.figure1,'data_parameters');
        f_para=getappdata(handles.figure1,'figure_parameters');
        p_para=getappdata(handles.figure1,'plot_parameters');

        SS_fig=figure('units','normalized','menubar','none','position',[0.05 0.07 0.4 0.86],'Name','Select spikes',...
            'NumberTitle','off','Color',[0.9294 0.9176 0.851],'DeleteFcn',{@SS_Close_callback},'WindowStyle','modal');

        SS_edit=uicontrol('style','edit','units','normalized','position',[0.08 0.91 0.84 0.04],...
            'FontSize',13,'FontUnits','normalized','BackgroundColor','w','Visible','on');
        SS_Down_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.125 0.85 0.15 0.04],...
            'string','Down','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
            'CallBack',{@SS_ListBox_callback},'Visible','on');
        SS_Up_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.325 0.85 0.15 0.04],...
            'string','Up','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
            'CallBack',{@SS_ListBox_callback},'Visible','on');
        SS_Delete_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.525 0.85 0.15 0.04],...
            'string','Delete','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
            'CallBack',{@SS_ListBox_callback},'Visible','on');
        SS_Replace_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.725 0.85 0.15 0.04],...
            'string','Replace','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
            'CallBack',{@SS_ListBox_callback},'Visible','on');
%         SS_Add_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.745 0.85 0.12 0.04],...
%             'string','Add','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
%             'CallBack',{@SS_ListBox_callback},'Visible','on');
        SS_listbox=uicontrol('style','listbox','units','normalized','position',[0.08 0.13 0.84 0.68],...
            'FontSize',13,'FontUnits','normalized','BackgroundColor','w','CallBack',{@SS_ListBox_callback},'min',0,'max',1,'Visible','on');
        SS_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.15 0.05 0.2 0.04],...
            'string','Cancel','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
            'CallBack',{@SS_callback},'Visible','on');
        SS_Reset_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.4 0.05 0.2 0.04],...
            'string','Reset','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
            'CallBack',{@SS_callback},'Visible','on');
        SS_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.05 0.2 0.04],...
            'string','OK','FontSize',13,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],...
            'CallBack',{@SS_callback},'Visible','on');

        figure(f_para.num_fig);
        SS_UserData=get(gcf,'Userdata');
        lb_num_strings=length(SS_UserData.STG_spikes);
        lb_pos=get(SS_listbox,'Value');
        lb_strings=[];
        for trac=1:lb_num_strings
            lb_strings{trac}=regexprep(num2str(sort(SS_UserData.STG_spikes{trac})),'\s+',' ');
        end
        for rc=1:length(SS_UserData.lh)
            for cc=1:length(SS_UserData.lh{rc})
                if ishandle(SS_UserData.lh{rc}(cc))
                    delete(SS_UserData.lh{rc}(cc))
                end
            end
        end
        SS_UserData.lh=cell(1,lb_num_strings);
        for trac=1:lb_num_strings
            if trac==lb_pos
                dcol=p_para.selave_active_col;
            else
                dcol=p_para.selave_col;
            end
            for selc=1:length(SS_UserData.STG_spikes{trac})
                SS_UserData.lh{trac}(selc)=plot(SS_UserData.STG_spikes{trac}(selc)*ones(1,2),(1.05-(trac-1+[0.05 0.95])/lb_num_strings),...
                    'Color',dcol,'LineStyle',SS_UserData.spike_ls,'LineWidth',SS_UserData.spike_lw);
            end
        end
        set(SS_listbox,'String',lb_strings)
        set(SS_edit,'String',lb_strings{1})
        set(SS_UserData.fh,'Userdata',SS_UserData)

        function SS_ListBox_callback(varargin)
            figure(f_para.num_fig);
            SS_UserData=get(gcf,'Userdata');
            lb_pos=get(SS_listbox,'Value');
            lb_strings=get(SS_listbox,'String');
            lb_num_strings=length(lb_strings);
            if gcbo==SS_listbox
                for trac=1:lb_num_strings
                    if trac==lb_pos
                        dcol=p_para.trigave_active_col;
                    else
                        dcol=p_para.selave_col;
                    end
                    for selc=1:length(SS_UserData.STG_spikes{trac})
                        set(SS_UserData.lh{trac}(selc),'Color',dcol);
                    end
                end
            elseif gcbo==SS_Down_pushbutton
                if lb_pos<lb_num_strings
                    dummy=lb_strings{lb_pos+1};
                    lb_strings{lb_pos+1}=lb_strings{lb_pos};
                    lb_strings{lb_pos}=dummy;
                    dummy=SS_UserData.STG_spikes{lb_pos+1};
                    SS_UserData.STG_spikes{lb_pos+1}=SS_UserData.STG_spikes{lb_pos};
                    SS_UserData.STG_spikes{lb_pos}=dummy;
                    set(SS_listbox,'Value',lb_pos+1)
                end
            elseif gcbo==SS_Up_pushbutton
                if lb_pos>1 && ~isempty(lb_strings{lb_pos})
                    dummy=lb_strings{lb_pos-1};
                    lb_strings{lb_pos-1}=lb_strings{lb_pos};
                    lb_strings{lb_pos}=dummy;
                    dummy=SS_UserData.STG_spikes{lb_pos-1};
                    SS_UserData.STG_spikes{lb_pos-1}=SS_UserData.STG_spikes{lb_pos};
                    SS_UserData.STG_spikes{lb_pos}=dummy;
                    set(SS_listbox,'Value',lb_pos-1)
                end
            elseif gcbo==SS_Delete_pushbutton
                lb_strings{lb_pos}='';
                SS_UserData.STG_spikes{lb_pos}=[];
            elseif gcbo==SS_Replace_pushbutton
                SS_str=get(SS_edit,'String');
                if ~isempty(SS_str)
                    [dummy,conv_ok]=str2num(SS_str);
                    if conv_ok==0
                        set(0,'DefaultUIControlFontSize',16);
                        mbh=msgbox(sprintf('The values entered are not numeric!'),'Warning','warn','modal');
                        htxt = findobj(mbh,'Type','text');
                        set(htxt,'FontSize',12,'FontWeight','bold')
                        mb_pos=get(mbh,'Position');
                        set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                        uiwait(mbh);
                        return
                    end
                    SS_UserData.STG_spikes{lb_pos}=round(sort(str2num(SS_str))/SS_UserData.dts)*SS_UserData.dts;
                    lb_strings{lb_pos}=num2str(SS_UserData.STG_spikes{lb_pos});
                end
            end
            if isfield(SS_UserData,'lh')
                for rc=1:length(SS_UserData.lh)
                    for cc=1:length(SS_UserData.lh{rc})
                        if ishandle(SS_UserData.lh{rc}(cc))
                            delete(SS_UserData.lh{rc}(cc))
                        end
                    end
                end
            end
            lb_pos=get(SS_listbox,'Value');

            SS_UserData.lh=cell(1,lb_num_strings);
            for trac=1:lb_num_strings
                lb_strings{trac}=regexprep(num2str(sort(SS_UserData.STG_spikes{trac})),'\s+',' ');
                if trac==lb_pos
                    dcol=p_para.trigave_active_col;
                else
                    dcol=p_para.trigave_col;
                end
                SS_UserData.lh{trac}=zeros(1,length(SS_UserData.STG_spikes{trac}));
                for selc=1:length(SS_UserData.STG_spikes{trac})
                    SS_UserData.lh{trac}(selc)=plot(SS_UserData.STG_spikes{trac}(selc)*ones(1,2),(1.05-(trac-1+[0.05 0.95])/lb_num_strings),...
                        'Color',dcol,'LineStyle',SS_UserData.spike_ls,'LineWidth',SS_UserData.spike_lw);
                end
            end
            set(SS_listbox,'String',lb_strings)
            if lb_pos>0
                set(SS_edit,'String',regexprep(lb_strings{lb_pos},'\s+',' '))
            else
                lb_pos=1;
                set(SS_listbox,'Value',lb_pos);
                set(SS_edit,'String','')
            end

            set(SS_UserData.fh,'Userdata',SS_UserData)
        end


        function SS_callback(varargin)
            d_para=getappdata(handles.figure1,'data_parameters');
            f_para=getappdata(handles.figure1,'figure_parameters');
            figure(f_para.num_fig);
            SS_UserData=get(gcf,'Userdata');

            %lb_pos=get(SS_listbox,'Value');
            lb_strings=get(SS_listbox,'String');
            lb_num_strings=length(lb_strings);
            if gcbo==SS_Cancel_pushbutton || gcbo==SS_fig
                delete(SS_fig)
            elseif gcbo==SS_Reset_pushbutton
                set(SS_edit,'String',[])
                SS_UserData.STG_spikes=[];
                SS_UserData.STG_spikes{1}=[];
                lb_strings=[];
                lb_strings{1}='';
                set(SS_listbox,'String',lb_strings,'Value',1)
                SS_UserData.STG_spikes=[];
                for rc=1:length(SS_UserData.lh)
                    for cc=1:length(SS_UserData.lh{rc})
                        if ishandle(SS_UserData.lh{rc}(cc))
                            delete(SS_UserData.lh{rc}(cc))
                        end
                    end
                end
                SS_UserData.lh=[];
                setappdata(SS_UserData.fh,'spike_lh',SS_UserData.lh);
                SS_UserData=rmfield(SS_UserData,'STG_spikes');                
                set(SS_UserData.fh,'Userdata',SS_UserData)
                cla
                STG(hObject, eventdata, handles)
            elseif gcbo==SS_OK_pushbutton
                for trac=1:lb_num_strings
                    [dummy,conv_ok]=str2num(char(lb_strings{trac}));
                    if conv_ok==0 && ~isempty(lb_strings{trac})
                        set(0,'DefaultUIControlFontSize',16);
                        mbh=msgbox(sprintf('The values entered are not numeric!'),'Warning','warn','modal');
                        htxt = findobj(mbh,'Type','text');
                        set(htxt,'FontSize',12,'FontWeight','bold')
                        mb_pos=get(mbh,'Position');
                        set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                        uiwait(mbh);
                        return
                    end
                end
                set(SS_OK_pushbutton,'UserData',1)
                set(SS_UserData.fh,'Userdata',SS_UserData)
                delete(SS_fig)
            end
        end


        function SS_Close_callback(varargin)
            figure(f_para.num_fig);
            SS_UserData=get(gcf,'Userdata');
            if isfield(SS_UserData,'lh')
                for rc=1:length(SS_UserData.lh)
                    for cc=1:length(SS_UserData.lh{rc})
                        if ishandle(SS_UserData.lh{rc}(cc))
                            delete(SS_UserData.lh{rc}(cc))
                        end
                    end
                end
                SS_UserData.lh=[];
            end
            SS_UserData.lh=cell(1,length(SS_UserData.STG_spikes));
            for trac=1:length(SS_UserData.STG_spikes)
                for selc=1:length(SS_UserData.STG_spikes{trac})
                    SS_UserData.lh{trac}(selc)=plot(SS_UserData.STG_spikes{trac}(selc)*ones(1,2),(1.05-(trac-1+[0.05 0.95])/lb_num_strings),...
                        'Color',SS_UserData.spike_col,'LineStyle',SS_UserData.spike_ls,'LineWidth',SS_UserData.spike_lw);
                end
            end
            set(SS_UserData.fh,'Userdata',SS_UserData)
        end
    end

end





function STG(hObject, eventdata, handles)

d_para=getappdata(handles.figure1,'data_parameters');
f_para_default=getappdata(handles.figure1,'figure_parameters_default');
s_para_default=getappdata(handles.figure1,'subplot_parameters_default');
p_para_default=getappdata(handles.figure1,'plot_parameters_default');
f_para=f_para_default;
s_para=s_para_default;  % used in setup
p_para=p_para_default;

d_para.num_all_trains=d_para.num_trains;

SPIKY_paras_set

fig=figure(f_para.num_fig);
%set(fig,'Units','Normalized','Position',f_para.pos_fig);
STG_UserData=get(fig,'UserData');

STG_UserData.fh=gcf;
STG_UserData.ah=gca;

STG_UserData.xl=get(STG_UserData.ah,'xlim');
STG_UserData.yl=get(STG_UserData.ah,'ylim');
STG_UserData.dxl=diff(STG_UserData.xl);
STG_UserData.dyl=diff(STG_UserData.yl);
STG_UserData.num_trains=d_para.num_trains;
STG_UserData.tmin=d_para.tmin;
STG_UserData.tmax=d_para.tmax;
STG_UserData.dts=d_para.dts;
STG_UserData.spike_col=p_para.spike_col;
STG_UserData.spike_marked_col=p_para.spike_marked_col;
STG_UserData.spike_ls=p_para.spike_ls;
STG_UserData.spike_lw=p_para.spike_lw;
STG_UserData.flag=0;

STG_UserData.tx(1)=uicontrol('Style','tex','String','','Unit','normalized','backg',get(STG_UserData.fh,'Color'),...
    'Position',[0.2 0.907 0.8 0.04],'FontSize',18,'FontWeight','bold','HorizontalAlignment','left');

STG_UserData.tx(2)=uicontrol('Style','tex','String','','Unit','normalized','backg',get(STG_UserData.fh,'Color'),...
    'Position',[0.55 0.907 0.4 0.04],'FontSize',18,'FontWeight','bold','HorizontalAlignment','left');

if ~isfield(STG_UserData,'STG_spikes')
    STG_UserData.STG_spikes=cell(1,STG_UserData.num_trains);
    STG_UserData.lh=cell(1,STG_UserData.num_trains);
    STG_UserData.marked=cell(1,STG_UserData.num_trains);
end

spike_lh=getappdata(handles.figure1,'spike_lh');
STG_UserData.num_trains=d_para.num_trains;
if isempty(spike_lh)
    cla
    STG_UserData.lh=cell(1,STG_UserData.num_trains);
    STG_UserData.marked=cell(1,STG_UserData.num_trains);
else
    for trac=1:d_para.num_trains
        for sc=1:d_para.num_allspikes(trac)
            dummy=get(spike_lh{trac}(sc),'XData');
            STG_UserData.STG_spikes{trac}(sc)=dummy(1);
        end
        STG_UserData.lh{trac}=spike_lh{trac};
    end
end

SPIKY_STG_setup

STG_UserData.cm=uicontextmenu;
STG_UserData.um=uimenu(STG_UserData.cm,'label','Delete Spike(s)','CallBack',{@STG_delete_spike,STG_UserData});
set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData})
set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
set(STG_UserData.fh,'Userdata',STG_UserData)
set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})

setappdata(handles.figure1,'data_parameters',d_para)
setappdata(handles.figure1,'figure_parameters',f_para)
setappdata(handles.figure1,'plot_parameters',p_para)
end



function []=STG_outside(varargin)
STG_UserData=varargin{3};
set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
drawnow;
%careful with marked
STG_UserData.marked=cell(1,STG_UserData.num_trains);
set(STG_UserData.fh,'Userdata',STG_UserData)
set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData})
set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
set(STG_UserData.fh,'Userdata',STG_UserData)
end

function []=STG_get_coordinates(varargin)

STG_UserData=varargin{3};
ax_pos=get(STG_UserData.ah,'CurrentPoint');
ax_x_ok=STG_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=STG_UserData.tmax;
ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

if ax_x_ok && ax_y_ok
    ax_x=round(ax_pos(1,1)/STG_UserData.dts)*STG_UserData.dts;
    ax_y=STG_UserData.num_trains+1-ceil((ax_pos(1,2)-0.05)*STG_UserData.num_trains);
    set(STG_UserData.tx(1),'str',['Spike train: ',num2str(ax_y)]);
    set(STG_UserData.tx(2),'str',['Time: ', num2str(ax_x)]);
elseif ax_x_ok
    ax_x=round(ax_pos(1,1)/STG_UserData.dts)*STG_UserData.dts;
    set(STG_UserData.tx(1),'str','Spike train: out of range');
    set(STG_UserData.tx(2),'str',['Time: ', num2str(ax_x)]);
elseif ax_y_ok
    ax_y=STG_UserData.num_trains+1-ceil((ax_pos(1,2)-0.05)*STG_UserData.num_trains);
    set(STG_UserData.tx(1),'str',['Spike train: ',num2str(ax_y)]);
    set(STG_UserData.tx(2),'str','Time: out of range');
else
    set(STG_UserData.tx(1),'str','Spike train: out of range');
    set(STG_UserData.tx(2),'str','Time: out of range');
end
end


function []=STG_pick_spike(varargin)

STG_UserData=varargin{3};
STG_UserData=get(STG_UserData.fh, 'UserData');

ax_pos=get(STG_UserData.ah,'CurrentPoint');
ax_x=round(ax_pos(1,1)/STG_UserData.dts)*STG_UserData.dts;
ax_y=STG_UserData.num_trains+1-ceil((ax_pos(1,2)-0.05)*STG_UserData.num_trains);

ax_x_ok=STG_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=STG_UserData.tmax;
ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

modifiers=get(STG_UserData.fh,'CurrentModifier');
if ax_x_ok && ax_y_ok
    seltype=get(STG_UserData.fh,'SelectionType');
    if strcmp(seltype,'normal')
        STG_UserData.STG_spikes{ax_y}=[STG_UserData.STG_spikes{ax_y} ax_x];
        STG_UserData.lh{ax_y}=[STG_UserData.lh{ax_y} line([ax_x ax_x],0.05+(STG_UserData.num_trains-1-(ax_y-1)+[0.05 0.95])/STG_UserData.num_trains,...
            'Color',STG_UserData.spike_col,'LineStyle',STG_UserData.spike_ls,'LineWidth',STG_UserData.spike_lw)];
    end

    ctrlIsPressed=ismember('control', modifiers);
    if (ctrlIsPressed)
        STG_UserData.STG_spikes{ax_y}=[STG_UserData.STG_spikes{ax_y} ax_x];
        STG_UserData.lh{ax_y}=[STG_UserData.lh{ax_y} line([ax_x ax_x],0.05+(STG_UserData.num_trains-1-(ax_y-1)+[0.05 0.95])/STG_UserData.num_trains,...
            'Color',STG_UserData.spike_col,'LineStyle',STG_UserData.spike_ls,'LineWidth',STG_UserData.spike_lw)];
        set(STG_UserData.lh{ax_y}(end),'Color',STG_UserData.spike_marked_col);
        STG_UserData.marked{ax_y}=[STG_UserData.marked{ax_y} numel(STG_UserData.lh{ax_y})];
        STG_UserData.flag=1;
    else
        set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
        STG_UserData.flag=0;
        STG_UserData.marked=cell(1,STG_UserData.num_trains);
    end
else
    set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
    drawnow;
    %careful with marked
    STG_UserData.marked=cell(1,STG_UserData.num_trains);
    set(STG_UserData.fh,'Userdata',STG_UserData)
    set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
    set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
    set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData})
    set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
    set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
    set(STG_UserData.fh,'Userdata',STG_UserData)
end


shftIsPressed=ismember('shift',modifiers);
if (shftIsPressed)
    ax_pos=get(STG_UserData.ah,'CurrentPoint');
    firstCorner_x=ax_pos(1,1);
    firstCorner_y=ax_pos(1,2);
    window=rectangle('Position', [firstCorner_x, firstCorner_y, 0.01, 0.01]);
    while (shftIsPressed)
        ax_pos=get(STG_UserData.ah,'CurrentPoint');
        secondCorner_x=ax_pos(1,1);
        secondCorner_y=ax_pos(1,2);
        if (secondCorner_x ~= firstCorner_x)&&(secondCorner_y ~= firstCorner_y)
            set(window,'Position',[min(firstCorner_x, secondCorner_x), min(firstCorner_y, secondCorner_y), abs(secondCorner_x-firstCorner_x), abs(secondCorner_y-firstCorner_y)])
            drawnow
            upperBoundST=STG_UserData.num_trains+1-ceil(( min(firstCorner_y, secondCorner_y)-0.05)*STG_UserData.num_trains);
            if upperBoundST>STG_UserData.num_trains
                upperBoundST=STG_UserData.num_trains;
            end
            left_mark=min(firstCorner_x, secondCorner_x);
            lowerBoundST=STG_UserData.num_trains+1-ceil(( max(firstCorner_y, secondCorner_y)-0.05)*STG_UserData.num_trains);
            if lowerBoundST<1
                lowerBoundST=1;
            end
            right_mark=max(firstCorner_x, secondCorner_x);
            set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
            STG_UserData.marked = cell(1,STG_UserData.num_trains);
            for trac=lowerBoundST : upperBoundST
                index=intersect(find(STG_UserData.STG_spikes{trac}>=left_mark), find(STG_UserData.STG_spikes{trac}<=right_mark)); %% real-one or sampled one
                STG_UserData.flag=(numel(index)>0);
                set(STG_UserData.lh{trac}(index),'Color',STG_UserData.spike_marked_col);
                STG_UserData.marked{trac}=index;
            end
        end
        pause(0.001);
        modifiers=get(STG_UserData.fh,'CurrentModifier');
        shftIsPressed=ismember('shift',modifiers);
    end
    delete(window)
    set(STG_UserData.fh, 'UserData', STG_UserData);
end

set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData})
set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
set(STG_UserData.fh,'Userdata',STG_UserData)
end


function []=STG_keyboard(varargin)

STG_UserData=varargin{3};
STG_UserData=get(STG_UserData.fh, 'UserData');
if strcmp(varargin{2}.Key,'delete')
    if (STG_UserData.flag)
        for trac=1:STG_UserData.num_trains
            delete(STG_UserData.lh{trac}(STG_UserData.marked{trac}));
            STG_UserData.lh{trac}(STG_UserData.marked{trac})=[];
            STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac})=[];
        end
        STG_UserData.flag=0;
        STG_UserData.marked=cell(1,STG_UserData.num_trains);
        set(STG_UserData.fh,'Userdata',STG_UserData)
        set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
        set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
        set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData})
        set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
        set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
        set(STG_UserData.fh,'Userdata',STG_UserData)
    end
elseif strcmp(varargin{2}.Key, 'a')
    modifiers=get(STG_UserData.fh,'CurrentModifier');
    ctrlIsPressed=ismember('control',modifiers);
    if (ctrlIsPressed)
        for trac=1:STG_UserData.num_trains
            STG_UserData.marked{trac}=1:numel(STG_UserData.lh{trac});
        end
        set([STG_UserData.lh{:}],'Color',STG_UserData.spike_marked_col);
        drawnow;
        STG_UserData.flag=1;
        set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)

        set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
        set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData})
        set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
        set(STG_UserData.fh,'Userdata',STG_UserData)
    end
elseif strcmp(varargin{2}.Key,'c')
    set(STG_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
    set(STG_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
    modifiers=get(STG_UserData.fh,'CurrentModifier');
    ctrlIsPressed=ismember('control',modifiers);
    if (ctrlIsPressed)
        for trac=1:STG_UserData.num_trains
            for idx=1:numel(STG_UserData.marked{trac})
                if ~exist('ax_x','var')
                    ax_x=get(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'XData');
                    ax_y=get(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'YData');
                    ax_y=STG_UserData.num_trains+1-ceil((ax_y(1,2)-0.05)*STG_UserData.num_trains);
                end
                STG_UserData.lh{trac}=[STG_UserData.lh{trac} line(get(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'Xdata'),get(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'Ydata'),...
                    'Color','g','LineStyle',STG_UserData.spike_ls,'LineWidth',STG_UserData.spike_lw)];
                STG_UserData.STG_spikes{trac}=[STG_UserData.STG_spikes{trac} STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))];
            end
        end
        STG_UserData.y_diff=ax_y(1,1);
        STG_UserData.flag=0;
        STG_UserData.initial_XPos=ax_x(1,1);
        set(STG_UserData.fh,'Userdata',STG_UserData)
        set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_move_spike,STG_UserData})
    end
elseif strcmp(varargin{2}.Key,'uparrow')
    for trac=2:STG_UserData.num_trains
        if ~isempty( intersect( STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}), (STG_UserData.STG_spikes{trac-1}(setdiff(1:numel(STG_UserData.STG_spikes{trac-1}),STG_UserData.marked{trac-1})))) )%
            set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
            for idx=1:length(STG_UserData.marked{trac})
                set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'XData',STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))*ones(1,2));
                set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'YData',0.05+(STG_UserData.num_trains-trac+[0.05 0.95])/STG_UserData.num_trains)
            end

            drawnow;
            STG_UserData.marked=cell(1,STG_UserData.num_trains);

            set(STG_UserData.fh,'Pointer','arrow')
            set(STG_UserData.fh,'WindowButtonUpFcn','')
            set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
            set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData},...
                'WindowButtonUpFcn','')
            set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
            set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
            set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
            set(STG_UserData.fh,'Userdata',STG_UserData)
            return
        end
    end
    for idx=numel(STG_UserData.marked{1}):-1:1
        delete(STG_UserData.lh{1}(STG_UserData.marked{1}(idx)));
        STG_UserData.lh{1}(STG_UserData.marked{1}(idx)) = [];
        STG_UserData.STG_spikes{1}(STG_UserData.marked{1}(idx)) = [];
    end
    for trac=2:STG_UserData.num_trains
        for idx=numel(STG_UserData.marked{trac}):-1:1
            STG_UserData.STG_spikes{trac-1} = [STG_UserData.STG_spikes{trac-1} STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))];
            STG_UserData.lh{trac-1} = [STG_UserData.lh{trac-1} STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx))];
            STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx)) = [];
            STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)) = [];
            set(STG_UserData.lh{trac-1}(end),'YData',0.05+(STG_UserData.num_trains-trac+1+[0.05 0.95])/STG_UserData.num_trains)
        end
    end
    %set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
    drawnow;
    %careful with marked
    for trac=1:STG_UserData.num_trains-1
        STG_UserData.marked{trac} = [numel(STG_UserData.STG_spikes{trac}) - numel(STG_UserData.marked{trac+1}) + 1 : numel(STG_UserData.STG_spikes{trac})];
    end
    STG_UserData.marked{STG_UserData.num_trains} = [];
    %STG_UserData.marked=cell(1,STG_UserData.num_trains);
    set(STG_UserData.fh,'Userdata',STG_UserData)
    set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
    set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
    set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData})
    set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
    set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
    set(STG_UserData.fh,'Userdata',STG_UserData)
elseif strcmp(varargin{2}.Key,'downarrow')
    for trac=1:STG_UserData.num_trains-1
        if ~isempty( intersect( STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}), (STG_UserData.STG_spikes{trac+1}(setdiff([1:numel(STG_UserData.STG_spikes{trac+1})],STG_UserData.marked{trac+1})))) )%
            set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
            for idx=1:length(STG_UserData.marked{trac})
                set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'XData',STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))*ones(1,2));
                set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'YData',0.05+(STG_UserData.num_trains-trac+[0.05 0.95])/STG_UserData.num_trains)
            end

            drawnow;
            STG_UserData.marked=cell(1,STG_UserData.num_trains);

            set(STG_UserData.fh,'Pointer','arrow')
            set(STG_UserData.fh,'WindowButtonUpFcn','')
            set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
            set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData},...
                'WindowButtonUpFcn','')
            set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
            set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
            set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
            set(STG_UserData.fh,'Userdata',STG_UserData)
            return
        end
    end
    for idx=numel(STG_UserData.marked{STG_UserData.num_trains}):-1:1
        delete(STG_UserData.lh{STG_UserData.num_trains}(STG_UserData.marked{STG_UserData.num_trains}(idx)));
        STG_UserData.lh{STG_UserData.num_trains}(STG_UserData.marked{STG_UserData.num_trains}(idx)) = [];
        STG_UserData.STG_spikes{STG_UserData.num_trains}(STG_UserData.marked{STG_UserData.num_trains}(idx)) = [];
    end
    for trac=STG_UserData.num_trains-1:-1:1
        for idx=numel(STG_UserData.marked{trac}):-1:1
            STG_UserData.STG_spikes{trac+1} = [STG_UserData.STG_spikes{trac+1} STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))];
            STG_UserData.lh{trac+1} = [STG_UserData.lh{trac+1} STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx))];
            STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx)) = [];
            STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)) = [];
            set(STG_UserData.lh{trac+1}(end),'YData',0.05+(STG_UserData.num_trains-trac-1+[0.05 0.95])/STG_UserData.num_trains)
        end
    end
    %set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
    drawnow;
    %STG_UserData.marked=cell(1,STG_UserData.num_trains);
    for trac=STG_UserData.num_trains : -1 : 2
        STG_UserData.marked{trac} = numel(STG_UserData.STG_spikes{trac}) - numel(STG_UserData.marked{trac-1}) + 1 : numel(STG_UserData.STG_spikes{trac});
    end
    STG_UserData.marked{1} = [];
    set(STG_UserData.fh,'Userdata',STG_UserData)
    set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
    set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
    set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData})
    set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
    set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
    set(STG_UserData.fh,'Userdata',STG_UserData)
elseif strcmp(varargin{2}.Key,'rightarrow')
    for trac=1:STG_UserData.num_trains
        if ~isempty( intersect( STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac})+STG_UserData.dts, (STG_UserData.STG_spikes{trac}(setdiff([1:numel(STG_UserData.STG_spikes{trac})],STG_UserData.marked{trac})))) )%
            set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
            for idx=1:length(STG_UserData.marked{trac})
                set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'XData',STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))*ones(1,2));
                set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'YData',0.05+(STG_UserData.num_trains-trac+[0.05 0.95])/STG_UserData.num_trains)
            end

            drawnow;
            STG_UserData.marked=cell(1,STG_UserData.num_trains);

            set(STG_UserData.fh,'Pointer','arrow')
            set(STG_UserData.fh,'WindowButtonUpFcn','')
            set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
            set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData},...
                'WindowButtonUpFcn','')
            set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
            set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
            set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
            set(STG_UserData.fh,'Userdata',STG_UserData)
            return
        end
    end
    for trac=1:STG_UserData.num_trains
        for idx=numel(STG_UserData.marked{trac}):-1:1
            if (STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))+STG_UserData.dts <= STG_UserData.tmax)
                set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'XData',(STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))+STG_UserData.dts)*ones(1,2))
                STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx)) = STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))+STG_UserData.dts;
            else
                delete(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)));
                STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)) = [];
                STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx)) = [];
                STG_UserData.marked{trac} ( STG_UserData.marked{trac} > idx) = STG_UserData.marked{trac} ( STG_UserData.marked{trac} > idx) - 1;
                STG_UserData.marked{trac}(idx) = [];
            end
        end
    end
    %set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
    drawnow;
    %STG_UserData.marked=cell(1,STG_UserData.num_trains);
    set(STG_UserData.fh,'Userdata',STG_UserData)
    set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
    set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
    set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData})
    set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
    set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
    set(STG_UserData.fh,'Userdata',STG_UserData)
elseif strcmp(varargin{2}.Key,'leftarrow')
    for trac=1:STG_UserData.num_trains
        if ~isempty( intersect( STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac})-STG_UserData.dts, (STG_UserData.STG_spikes{trac}(setdiff([1:numel(STG_UserData.STG_spikes{trac})],STG_UserData.marked{trac})))) )%
            set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
            for idx=1:length(STG_UserData.marked{trac})
                set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'XData',STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))*ones(1,2));
                set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'YData',0.05+(STG_UserData.num_trains-trac+[0.05 0.95])/STG_UserData.num_trains)
            end

            drawnow;
            STG_UserData.marked=cell(1,STG_UserData.num_trains);

            set(STG_UserData.fh,'Pointer','arrow')
            set(STG_UserData.fh,'WindowButtonUpFcn','')
            set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
            set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData},...
                'WindowButtonUpFcn','')
            set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
            set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
            set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
            set(STG_UserData.fh,'Userdata',STG_UserData)
            return
        end
    end
    for trac=1:STG_UserData.num_trains
        for idx=numel(STG_UserData.marked{trac}):-1:1
            if (STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))-STG_UserData.dts > STG_UserData.tmin)
                set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'XData',(STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))-STG_UserData.dts)*ones(1,2))
                STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx)) = STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))-STG_UserData.dts;
            else
                delete(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)));
                STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)) = [];
                STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx)) = [];
                STG_UserData.marked{trac} ( STG_UserData.marked{trac} > idx) = STG_UserData.marked{trac} ( STG_UserData.marked{trac} > idx) - 1;
                STG_UserData.marked{trac}(idx) = [];

            end
        end
    end
    %set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
    drawnow;
    %careful with marked
    %STG_UserData.marked=cell(1,STG_UserData.num_trains);
    set(STG_UserData.fh,'Userdata',STG_UserData)
    set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
    set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
    set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData})
    set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
    set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
    set(STG_UserData.fh,'Userdata',STG_UserData)
elseif strcmp(varargin{2}.Key,'return')
    set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
    drawnow;
    %careful with marked
    STG_UserData.marked=cell(1,STG_UserData.num_trains);
    set(STG_UserData.fh,'Userdata',STG_UserData)
    set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
    set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
    set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData})
    set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
    set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
    set(STG_UserData.fh,'Userdata',STG_UserData)
end

end


function []=STG_delete_spike(varargin)

STG_UserData=varargin{3};
STG_UserData=get(STG_UserData.fh, 'UserData');

if (STG_UserData.flag)
    for trac=1:STG_UserData.num_trains
        delete(STG_UserData.lh{trac}(STG_UserData.marked{trac}));
        STG_UserData.lh{trac}(STG_UserData.marked{trac})=[];
        STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac})=[];
    end
    STG_UserData.flag=0;
    STG_UserData.marked=cell(1,STG_UserData.num_trains);
else
    ax_pos_x=get(gco,'XData');
    ax_pos_y=get(gco,'YData');
    ax_x=round(ax_pos_x(1,2) /STG_UserData.dts)*STG_UserData.dts;
    ax_y=STG_UserData.num_trains+1-ceil((mean(ax_pos_y)-0.05)*STG_UserData.num_trains);
    index=find(STG_UserData.lh{ax_y} == gco);
    if length(index)>1
        stop=1;
    end
    STG_UserData.lh{ax_y}(index)=[];
    delete(gco);
    STG_UserData.STG_spikes{ax_y}(index)=[];
end

drawnow;
set(STG_UserData.fh,'WindowButtonUpFcn','')
set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData},...
    'WindowButtonUpFcn','')
set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
set(STG_UserData.fh,'Userdata',STG_UserData)
end


function STG_start_move_spike(varargin)

STG_UserData=varargin{3};
STG_UserData=get(STG_UserData.fh, 'UserData');
seltype=get(STG_UserData.fh,'SelectionType'); % Right-or-left click?
if strcmp(seltype,'alt')

    modifiers=get(STG_UserData.fh,'CurrentModifier');

    ctrlIsPressed=ismember('control', modifiers);
    if (ctrlIsPressed)
        ax_pos_y=get(gco,'YData');
        ax_y=STG_UserData.num_trains+1-ceil((mean(ax_pos_y)-0.05)*STG_UserData.num_trains);
        index=find(STG_UserData.lh{ax_y} == gco);

        if (~STG_UserData.flag)
            STG_UserData.flag=1;
        end
        STG_UserData.marked{ax_y}=[STG_UserData.marked{ax_y} index];
        set(gco,'Color',STG_UserData.spike_marked_col);
        set(STG_UserData.fh,'Userdata',STG_UserData)
        set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
        set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
        set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData})
        set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
        set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
        set(STG_UserData.fh,'Userdata',STG_UserData)
    end
else
    ax_pos_x=get(gco,'XData');
    ax_pos_y=get(gco,'YData');
    ax_x=round(ax_pos_x(1,1) /STG_UserData.dts)*STG_UserData.dts;
    ax_y=STG_UserData.num_trains+1-ceil((mean(ax_pos_y)-0.05)*STG_UserData.num_trains);

    STG_UserData.initial_XPos=ax_x;
    if ~(STG_UserData.flag)
        index=find(STG_UserData.lh{ax_y} == gco);
        STG_UserData.marked{ax_y}=index;
        STG_UserData.initial_XPos=STG_UserData.STG_spikes{ax_y}(index);
    end

    STG_UserData.y_diff=ax_y;
    STG_UserData.flag=0;

    set(STG_UserData.fh,'Userdata',STG_UserData)
    set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_move_spike,STG_UserData})
    set(STG_UserData.ah,'ButtonDownFcn','')
end
end


function STG_move_spike(varargin)

STG_UserData=varargin{3};
STG_UserData=get(STG_UserData.fh, 'UserData');
set([STG_UserData.lh{:}],'ButtonDownFcn','')
set(STG_UserData.fh,'WindowButtonUpFcn','')


ax_pos=get(STG_UserData.ah,'CurrentPoint');
ax_x_ok=STG_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=STG_UserData.tmax;
ax_y_ok=0.05<ax_pos(1,2) && ax_pos(1,2)<=1.05;

ax_x=round(ax_pos(1,1)/STG_UserData.dts)*STG_UserData.dts;
ax_y=STG_UserData.num_trains+1-ceil((ax_pos(1,2)-0.05)*STG_UserData.num_trains);
STG_UserData.y_diff1=STG_UserData.y_diff-ax_y;
for trac=1:STG_UserData.num_trains
    for idx=1:length(STG_UserData.marked{trac})
        if ((STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))+ax_x-STG_UserData.initial_XPos)>STG_UserData.tmin && (STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))+ax_x-STG_UserData.initial_XPos)<=STG_UserData.tmax && (trac-STG_UserData.y_diff1)>0 && (trac-STG_UserData.y_diff1)<(STG_UserData.num_trains+1))
            set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'XData',(STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))+ax_x-STG_UserData.initial_XPos)*ones(1,2))
            set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'YData',0.05+(STG_UserData.num_trains-1-(trac-STG_UserData.y_diff1-1)+[0.05 0.95])/STG_UserData.num_trains)
            set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'Color',STG_UserData.spike_marked_col)
        else
            set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'Color','w')
        end
    end
end
drawnow;
if ax_x_ok && ax_y_ok
    set(STG_UserData.tx(1),'str',['Spike train: ',num2str(ax_y)]);
    set(STG_UserData.tx(2),'str',['Time: ', num2str(ax_x)]);
elseif ax_x_ok
    set(STG_UserData.tx(1),'str','Spike train: out of range');
    set(STG_UserData.tx(2),'str',['Time: ', num2str(ax_x)]);
elseif ax_y_ok
    set(STG_UserData.tx(1),'str',['Spike train: ',num2str(ax_y)]);
    set(STG_UserData.tx(2),'str','Time: out of range');
else
    set(STG_UserData.tx(1),'str','Spike train: out of range');
    set(STG_UserData.tx(2),'str','Time: out of range');
end
set(STG_UserData.fh,'WindowButtonUpFcn',{@STG_stop_move_spike,STG_UserData})
end


function STG_stop_move_spike(varargin)

STG_UserData=varargin{3};
STG_UserData=get(STG_UserData.fh, 'UserData');
set([STG_UserData.lh{:}],'ButtonDownFcn','')
set(STG_UserData.fh,'WindowButtonMotionFcn','')

ax_pos=get(STG_UserData.ah,'CurrentPoint');
ax_x=round(ax_pos(1,1)/STG_UserData.dts)*STG_UserData.dts;
ax_y=STG_UserData.num_trains+1-ceil((ax_pos(1,2)-0.05)*STG_UserData.num_trains);
STG_UserData.y_diff1=STG_UserData.y_diff-ax_y;

for trac=1:STG_UserData.num_trains
    if  (trac+ax_y-STG_UserData.y_diff > 0 && trac+ax_y-STG_UserData.y_diff <= STG_UserData.num_trains)
        if ~isempty( intersect( STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac})+ax_x-STG_UserData.initial_XPos, (STG_UserData.STG_spikes{trac+ax_y-STG_UserData.y_diff}(setdiff([1:numel(STG_UserData.STG_spikes{trac+ax_y-STG_UserData.y_diff})],STG_UserData.marked{trac+ax_y-STG_UserData.y_diff})))) )%
            set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
            for idx=1:length(STG_UserData.marked{trac})
                set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'XData',STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))*ones(1,2));
                set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'YData',0.05+(STG_UserData.num_trains-trac+[0.05 0.95])/STG_UserData.num_trains)
            end
            
            drawnow;
            STG_UserData.marked=cell(1,STG_UserData.num_trains);

            set(STG_UserData.fh,'Pointer','arrow')
            set(STG_UserData.fh,'WindowButtonUpFcn','')
            set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
            set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData},...
                'WindowButtonUpFcn','')
            set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
            set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
            set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
            set(STG_UserData.fh,'Userdata',STG_UserData)
            return
        end
    end
end

for trac=1:STG_UserData.num_trains
    for idx=1:length(STG_UserData.marked{trac})
        if ((STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))+ax_x-STG_UserData.initial_XPos)>STG_UserData.tmin && (STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))+ax_x-STG_UserData.initial_XPos)<=STG_UserData.tmax && (trac-STG_UserData.y_diff1)>0 && (trac-STG_UserData.y_diff1)<(STG_UserData.num_trains+1))
            set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'XData',(STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))+ax_x-STG_UserData.initial_XPos)*ones(1,2))
            set(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)),'YData',0.05+(STG_UserData.num_trains-1-(trac-STG_UserData.y_diff1-1)+[0.05 0.95])/STG_UserData.num_trains)
            STG_UserData.lh{trac+ax_y-STG_UserData.y_diff}=[STG_UserData.lh{trac+ax_y-STG_UserData.y_diff} STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx))];
            STG_UserData.STG_spikes{trac+ax_y-STG_UserData.y_diff}=[STG_UserData.STG_spikes{trac+ax_y-STG_UserData.y_diff} STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))+ax_x-STG_UserData.initial_XPos];
        else
            delete(STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx)));
        end
    end
end

for trac=1:STG_UserData.num_trains
    for idx=length(STG_UserData.marked{trac}):-1:1
        STG_UserData.lh{trac}(STG_UserData.marked{trac}(idx))=[];
        STG_UserData.STG_spikes{trac}(STG_UserData.marked{trac}(idx))=[];
    end
end
set([STG_UserData.lh{:}],'Color',STG_UserData.spike_col);
drawnow;

STG_UserData.marked=cell(1,STG_UserData.num_trains);

set(STG_UserData.fh,'Pointer','arrow')
set(STG_UserData.fh,'WindowButtonUpFcn','')
set(STG_UserData.um,'CallBack',{@STG_delete_spike,STG_UserData})
set(STG_UserData.fh,'WindowButtonMotionFcn',{@STG_get_coordinates,STG_UserData},'KeyPressFcn',{@STG_keyboard,STG_UserData},...
    'WindowButtonUpFcn','')
set(STG_UserData.ah,'ButtonDownFcn',{@STG_pick_spike,STG_UserData})
set([STG_UserData.lh{:}],'ButtonDownFcn',{@STG_start_move_spike,STG_UserData},'UIContextMenu',STG_UserData.cm)
set(STG_UserData.fh,'ButtonDownFcn',{@STG_outside,STG_UserData})
set(STG_UserData.fh,'Userdata',STG_UserData)
end


function STG_done(hObject, eventdata, handles)

allspikes=getappdata(handles.figure1,'allspikes');
f_para=getappdata(handles.figure1,'figure_parameters');
s_para_default=getappdata(handles.figure1,'subplot_parameters_default');
p_para_default=getappdata(handles.figure1,'plot_parameters_default');
s_para=s_para_default;
p_para=p_para_default;
d_para=getappdata(handles.figure1,'data_parameters');
d_para.num_all_trains=length(allspikes);
d_para.comment_string='STG';
d_para.preselect_trains=1:d_para.num_trains;
d_para.num_trains=d_para.num_all_trains;
d_para.num_total_spikes=sum(cellfun('length',allspikes));

SPIKY_paras_set
SPIKY_plot_allspikes
SPIKY_paras_set

d_para_default=d_para;
setappdata(handles.figure1,'data_parameters_default',d_para_default)
setappdata(handles.figure1,'data_parameters',d_para)
setappdata(handles.figure1,'figure_parameters',f_para)
setappdata(handles.figure1,'subplot_parameters',s_para)
setappdata(handles.figure1,'plot_parameters',p_para)
setappdata(handles.figure1,'allspikes',allspikes)

set(handles.Data_listbox,'Enable','off')
set(handles.Selection_data_uipanel,'HighlightColor','w')

set(handles.List_pushbutton,'Enable','off','FontWeight','normal')
set(handles.Workspace_pushbutton,'Enable','off','FontWeight','normal')
set(handles.Event_Detector_pushbutton,'Enable','off','FontWeight','normal')
%set(handles.Generator_pushbutton,'Enable','off','FontWeight','normal')
set(handles.Para_data_uipanel,'Visible','on','HighlightColor','k')
set(handles.Update_pushbutton,'Enable','on','FontWeight','bold')
uicontrol(handles.Update_pushbutton)
if strcmp(get(handles.Selection_masures_uipanel,'Visible'),'on')
    Update_pushbutton_Callback(hObject, eventdata, handles)
end
end



% #########################################################################
% #########################################################################
% ################################# Movie #################################
% #########################################################################
% #########################################################################

function Movie_play_pushbutton_Callback(hObject, eventdata, handles)
m_res=getappdata(handles.figure1,'measure_results');
m_para=getappdata(handles.figure1,'measure_parameters');
d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
p_para=getappdata(handles.figure1,'plot_parameters');
h_para=getappdata(handles.figure1,'help_parameters');
r_para=getappdata(handles.figure1,'run_parameters');
mov_handles=getappdata(handles.figure1,'movie_handles');
frame_select=get(handles.Movie_frame_slider,'UserData');

if get(handles.Movie_play_pushbutton,'UserData')==1, return; end
set(handles.Movie_play_pushbutton,'UserData',1)

frc=get(handles.Movie_frame_slider,'Value');
% if frc<=f_para.num_instants
%     if isfield(mov_handles,'mov_line_lh') && any(mov_handles.mov_line_lh)>0
%         %set(mov_handles.mov_line_lh,'XData',frame_select(frc)*ones(1,2))
%     end
%     elseif frc<=f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames
% end
while get(handles.Movie_play_pushbutton,'UserData')==1 && ...
        (get(handles.Movie_frame_slider,'Value')>get(handles.Movie_frame_slider,'Min') || ...
        get(handles.Movie_forward_radiobutton,'Value')==1)...
        && (get(handles.Movie_frame_slider,'Value')<get(handles.Movie_frame_slider,'Max') || ...
        get(handles.Movie_backward_radiobutton,'Value')==1)

    if get(handles.Movie_frame_slider,'Value')<get(handles.Movie_frame_slider,'Min') || ...
            get(handles.Movie_frame_slider,'Value')>get(handles.Movie_frame_slider,'Max')
        disp('outside range #####')
        break;
    end
    if get(handles.Movie_forward_radiobutton,'Value')==1
        set(handles.Movie_frame_slider,'Value',get(handles.Movie_frame_slider,'Value')+1)
    else
        set(handles.Movie_frame_slider,'Value',get(handles.Movie_frame_slider,'Value')-1)
    end

    frc=get(handles.Movie_frame_slider,'Value');
    set(handles.Movie_current_text,'String',num2str(frc))
    SPIKY_plot_frame    % for a given frc

    pause(0.1*(11-get(handles.Movie_speed_slider,'Value')));
    setappdata(handles.figure1,'movie_handles',mov_handles)
end
if get(handles.Movie_frame_slider,'Value')==get(handles.Movie_frame_slider,'Max')
    set(handles.Movie_backward_radiobutton,'Value',1)
elseif get(handles.Movie_frame_slider,'Value')==get(handles.Movie_frame_slider,'Min')
    set(handles.Movie_forward_radiobutton,'Value',1)
end
set(handles.Movie_play_pushbutton,'UserData',0)
% set(handles.Movie_play_pushbutton,'FontWeight','normal')
% set(handles.Movie_stop_pushbutton,'FontWeight','bold')
setappdata(handles.figure1,'figure_parameters',f_para)
setappdata(handles.figure1,'plot_parameters',p_para)
setappdata(handles.figure1,'help_parameters',h_para)
end


function Movie_stop_pushbutton_Callback(hObject, eventdata, handles)
% set(handles.Movie_play_pushbutton,'FontWeight','bold')
% set(handles.Movie_stop_pushbutton,'FontWeight','normal')
set(handles.Movie_play_pushbutton,'UserData',0)
end

function Movie_first_pushbutton_Callback(hObject, eventdata, handles)
m_res=getappdata(handles.figure1,'measure_results');
m_para=getappdata(handles.figure1,'measure_parameters');
d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
p_para=getappdata(handles.figure1,'plot_parameters');
h_para=getappdata(handles.figure1,'help_parameters');
r_para=getappdata(handles.figure1,'run_parameters');
mov_handles=getappdata(handles.figure1,'movie_handles');
frame_select=get(handles.Movie_frame_slider,'UserData');

set(handles.Movie_play_pushbutton,'UserData',0)
set(handles.Movie_forward_radiobutton,'Value',1)
set(handles.Movie_frame_slider,'Value',get(handles.Movie_frame_slider,'Min'))

frc=get(handles.Movie_frame_slider,'Value');
set(handles.Movie_current_text,'String',num2str(frc))
SPIKY_plot_frame    % for a given frc

setappdata(handles.figure1,'movie_handles',mov_handles)
end

function Movie_last_pushbutton_Callback(hObject, eventdata, handles)
m_res=getappdata(handles.figure1,'measure_results');
m_para=getappdata(handles.figure1,'measure_parameters');
d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
p_para=getappdata(handles.figure1,'plot_parameters');
h_para=getappdata(handles.figure1,'help_parameters');
r_para=getappdata(handles.figure1,'run_parameters');
mov_handles=getappdata(handles.figure1,'movie_handles');
frame_select=get(handles.Movie_frame_slider,'UserData');

set(handles.Movie_play_pushbutton,'UserData',0)
set(handles.Movie_backward_radiobutton,'Value',1)
set(handles.Movie_frame_slider,'Value',get(handles.Movie_frame_slider,'Max'))

frc=get(handles.Movie_frame_slider,'Value');
set(handles.Movie_current_text,'String',num2str(frc))
SPIKY_plot_frame    % for a given frc

setappdata(handles.figure1,'movie_handles',mov_handles)
end

function Movie_frame_slider_Callback(hObject, eventdata, handles)
m_res=getappdata(handles.figure1,'measure_results');
m_para=getappdata(handles.figure1,'measure_parameters');
d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
p_para=getappdata(handles.figure1,'plot_parameters');
h_para=getappdata(handles.figure1,'help_parameters');
r_para=getappdata(handles.figure1,'run_parameters');
mov_handles=getappdata(handles.figure1,'movie_handles');
frame_select=get(handles.Movie_frame_slider,'UserData');

set(handles.Movie_play_pushbutton,'UserData',0)
set(handles.Movie_frame_slider,'Value',round(get(handles.Movie_frame_slider,'Value')))

frc=get(handles.Movie_frame_slider,'Value');
set(handles.Movie_current_text,'String',num2str(frc))
SPIKY_plot_frame    % for a given frc

setappdata(handles.figure1,'movie_handles',mov_handles)

if (get(handles.Movie_frame_slider,'Value')==get(handles.Movie_frame_slider,'Min') && get(handles.Movie_backward_radiobutton,'Value')==1) || ...
        (get(handles.Movie_frame_slider,'Value')==get(handles.Movie_frame_slider,'Max') && get(handles.Movie_forward_radiobutton,'Value')==1)
    if get(handles.Movie_frame_slider,'Value')==get(handles.Movie_frame_slider,'Min')
        set(handles.Movie_forward_radiobutton,'Value',1);
    elseif get(handles.Movie_frame_slider,'Value')==get(handles.Movie_frame_slider,'Max')
        set(handles.Movie_backward_radiobutton,'Value',1);
    end
end
end

function Movie_speed_slider_Callback(hObject, eventdata, handles)
    set(handles.Movie_speed_current_text,'String',num2str(get(handles.Movie_speed_slider,'Value')))
end
