% This function is the only file you might need to deal with. It consists of two parts. 
% The upper part can be used to define some of the standard parameters of SPIKY. The lower part
% can be used to generate predefined spike train datasets which can then be called via the listbox in the 'Selection: Data' panel.
% Always make sure that the variable 'listbox_str' labels correctly the datasets defined in the subsequent indices.

function [spikes,d_para,f_para,d_para_default,f_para_default,s_para_default,p_para_default,listbox_str]=SPIKY_f_user_interface(d_para,f_para,calc)

% structure 'd_para': parameters that describe the data, for a description see comments at the end of this file
d_para_default=struct('tmin',[],'tmax',[],'dts',[],'max_total_spikes',100000,'max_memo_init',100000000,'num_trains',[],...
    'select_train_mode',1,'select_train_groups',[],'preselect_trains',[],'latency_onset',[],...
    'num_all_train_groups',1,'all_train_group_names',[],'all_train_group_sizes',[],...
    'thick_separators',[],'thin_separators',[],'thick_markers',[],'thin_markers',[],'interval_divisions',[],'interval_names','',...
    'instants_str','','selective_averages_str','','triggered_averages_str','','spikes_variable','',...
    'comment_string','SPIKY','example',3);

% structure 'f_para': parameters that determine the appearance of the figures (and the movie), for a description see comments at the end of this file
f_para_default=struct('imagespath',['.',filesep],'moviespath',['.',filesep],...    % Default values
    'matpath',['.',filesep],'print_mode',0,'movie_mode',0,'publication',1,'comment_string','','num_fig',123,...
    'pos_fig',[0.5 0.01 0.5 0.8867],'supo1',[0.1 0.1 0.8 0.8],'hints',0,'show_title',1,'time_unit_string','',...
    'x_offset',0,'x_scale',1,'x_realtime_mode',0,'extreme_spikes',0,'ma_mode',1,'mao',20,'frames_per_second',1,'num_average_frames',1,...
    'profile_mode',1,'profile_norm_mode',1,'profile_average_line',0,'color_norm_mode',1,'colorbar',1,...   % profile_norm_mode=4 only one tic? ###
    'group_matrices',1,'dendrograms',1,'histogram',0,'spike_train_color_coding_mode',1,'spike_col',2,'plot_mode',5,...
    'subplot_size',[],'psth_num_bins',1000,'psth_window',5,'edge_correction',1,'isi_thr',0,'spike_ave',0,...   % 0-time,1-spike,2-spike+zero intervals
    'subplot_posi',[0     1         0      0       2      0               0              0           0]);
% subplot_posi:     Stim  Spikes    PSTH   ISI     SPIKE  SPIKE-realtime  SPIKE-forward  SPIKE-Sync  SPIKE-Order   

% SPIKE-Neb SPIKE-Eero SPIKE-Neb-Eero       SPIKE-pico SPIKE-rt-pico SPIKE-fut-pico  SPIKE-disc SPIKE-disc-Neb SPIKE-disc-Eero SPIKE-disc-Neb-Eero   Vic vR
f_para_default.subplot_posi(length(f_para_default.subplot_posi)+(1:12))=[0 0 0    0 0 0    0 0 0 0   0 0];  % please ignore, for testing purposes only   ##### disc_NE still to be done for groups ######
%f_para_default.subplot_posi(length(f_para_default.subplot_posi)+(1:12))=[0 3 0    0 0 0    0 0 0 0   0 0];  % please ignore, for testing purposes only   ##### disc_NE still to be done for groups ######
%f_para_default.subplot_posi(length(f_para_default.subplot_posi)+(1:12))=[3 4 5    0 0 0    2 3 4 5   0 0];  % please ignore, for testing purposes only   ##### disc_NE still to be done for groups ######
                                                                                                                 % ##### SPIKE-disc-Neb>1 for burst-test ######
f_para_default.run_test=0; f_para_default.fast_mode=0; f_para_default.save_results=0;

f_para_default.rel_subplot_size=ones(1,length(f_para_default.subplot_posi(f_para_default.subplot_posi>0)));
f_para_default.regexp_str_scalar_integer='[^-1234567890]';
f_para_default.regexp_str_scalar_float='[^-1234567890e\.]';
f_para_default.regexp_str_vector_integers='[^-1234567890: ]';
f_para_default.regexp_str_vector_floats='[^-1234567890:e \.]';
f_para_default.regexp_str_cell_floats='[^-1234567890:e[]{},; \.]';
% structure 's_para': parameters that describe the appearance of the individual subplots (measure time profiles)
% for a description see comments at the end of this file
% (this structure is less relevant for you since most of these parameters are set automatically)
s_para_default=struct('window_mode',1,'nma',1,'causal',1,'itmin',[],'itmax',[],...
    'num_subplots',[],'xl',[],'yl',[],'plot_mode',1);

% structure 'p_para': parameters that describe the appearance of the individual plot elements (described at the end of each line)
p_para_default=struct(...
    'stim_vis','on','stim_col','k','stim_ls','-','stim_lw',1,...                                % lines: stimulus
    'spike_vis','on','spike_col','k','spike_ls','-','spike_lw',1,'spike_marked_col','r',...     % lines: spikes (raster plot)
    'tbounds_vis','on','tbounds_col','k','tbounds_ls','--','tbounds_lw',1,...                   % lines: overall time bounds
    'sp_seps_vis','on','sp_seps_col','k','sp_seps_ls','-','sp_seps_lw',2,...                    % lines: subplot separators
    'stim_bounds_vis','on','stim_bounds_col','k','stim_bounds_ls',':','stim_bounds_lw',1,...    % lines: stimulus time bounds
    'sp_bounds_vis','on','sp_bounds_col','k','sp_bounds_ls',':','sp_bounds_lw',1,...            % lines: subplot bounds
    'st_sep_vis','on','st_sep_col','k','st_sep_ls',':','st_sep_lw',1,...                        % lines: spike train separators
    'onset_vis','on','onset_col','b','onset_ls','-','onset_lw',2,...                            % lines: onset / f_para.offset
    'thick_sep_vis','on','thick_sep_col','r','thick_sep_marked_col','b','thick_sep_ls','-','thick_sep_lw',2,... % lines: thick spike train separators
    'thin_sep_vis','on','thin_sep_col','r','thin_sep_marked_col','b','thin_sep_ls','--','thin_sep_lw',1,...     % lines: thin spike train separators
    'thick_mar_vis','on','thick_mar_col','r','thick_mar_marked_col','b','thick_mar_ls','-','thick_mar_lw',2,... % lines: thick time markers
    'thin_mar_vis','on','thin_mar_col','r','thin_mar_marked_col','b','thin_mar_ls','--','thin_mar_lw',1.5,...   % lines: thin time markers
    'sp_thick_mar_vis','on','sp_thick_mar_col','r','sp_thick_mar_ls','-','sp_thick_mar_lw',2,...% lines: thick subplot time markers
    'sp_thin_mar_vis','on','sp_thin_mar_col','r','sp_thin_mar_ls','--','sp_thin_mar_lw',1.5,... % lines: thin subplot time markers
    'sgs_vis','on','sgs_col','k','sgs_marked_col','r','sgs_ls','--','sgs_lw',1,...              % lines: spike train group separators
    'mat_sgs_vis','on','mat_sgs_col','w','mat_sgs_ls',':','mat_sgs_lw',1.5,...                  % lines: matrix spike train group separators
    'mat_thick_sep_vis','on','mat_thick_sep_col','k','mat_thick_sep_ls','-','mat_thick_sep_lw',1,...% lines: thick matrix spike train separators
    'mat_thin_sep_vis','on','mat_thin_sep_col','k','mat_thin_sep_ls',':','mat_thin_sep_lw',1,...% lines: thin matrix spike train separators
    'prof_vis','on','prof_col','k','prof_ls','-','prof_lw',1,...                                % lines: measure profiles
    'ma_prof_vis','on','ma_prof_col','c','ma_prof_ls','-','ma_prof_lw',2,...                    % lines: measure profiles (analysis window)
    'ave_vis','on','ave_col','k','ave_ls','--','ave_lw',2,...                                   % lines: average of measure profiles
    'com_vis','on','com_col','k','com_ls',':','com_lw',1,...                                    % lines: common spikes
    'extreme_vis','on','extreme_col','k','extreme_ls',':','extreme_lw',1,...                    % lines: extrems spikes
    'dendrol_vis','on','dendrol_ls','-','dendrol_lw',1,...                                      % lines: dendrogram lines
    'mov_vis','on','mov_col','g','mov_ls','-','mov_lw',2,...                                    % lines: moving line
    'instants_vis','on','instants_col','g','instants_marked_col','r','instants_ls','-','instants_lw',2,...% lines: instants
    'selave_vis','on','selave_col','g','selave_active_col','b','selave_marked_col','r','selave_overlap_col','m','selave_ls','-','selave_lw',3,...% lines: selective averaging lines
    'trigave_vis','on','trigave_col','g','trigave_active_col','b','trigave_marked_col','r','trigave_ls','none','trigave_lw',2.5,...
    'trigave_symb_top','v','trigave_symb_bot','^','trigave_symb','+',...                        % plot: triggered averaging symbols
    'title_vis','on','title_col','k','title_fs',18,'title_fw','bold','title_fa','normal',...                              % texts: title
    'xlab_vis','on','xlab_col','k','xlab_fs',15,'xlab_fw','bold','xlab_fa','normal',...                                   % texts: profile x-label
    'prof_title_vis','on','prof_title_col','k','prof_title_fs',14,'prof_title_fw','bold','prof_title_fa','normal',...     % texts: profile title
    'prof_ave_vis','on','prof_ave_col','k','prof_ave_fs',16,'prof_ave_fw','bold','prof_ave_fa','normal',...               % texts: profile average
    'prof_tick_vis','on','prof_tick_col','k','prof_tick_fs',13,'prof_tick_fw','normal','prof_tick_fa','normal',...        % texts: profile ticks
    'mat_title_vis','on','mat_title_col','k','mat_title_fs',15,'mat_title_fw','bold','mat_title_fa','normal',...          % texts: matrix title
    'mat_label_vis','on','mat_label_col','k','mat_label_fs',14,'mat_label_fw','bold','mat_label_fa','normal',...          % texts: matrix label
    'mat_tick_vis','on','mat_tick_col','k','mat_tick_fs',12,'mat_tick_fw','normal','mat_tick_fa','normal',...             % texts: matrix ticks
    'measure_vis','on','measure_col','k','measure_fs',16,'measure_fw','bold','measure_fa','normal',...                    % texts: measure names
    'stimf_vis','on','stimf_col','k','stimf_fs',13,'stimf_fw','bold','stimf_fa','normal',...                              % texts: stimulus
    'group_names_vis','on','group_names_col','k','group_names_fs',15,'group_names_fw','bold','group_names_fa','normal',...% texts: group names
    'hist_max_vis','on','hist_max_col','k','hist_max_fs',12,'hist_max_fw','bold','hist_max_fa','normal',...               % texts: histogram maximum
    'synf_title_vis','on','synf_title_col','k','synf_title_fs',12,'synf_title_fw','bold','synf_title_fa','normal',...     % texts: synfire title
    'synf_label_vis','on','synf_label_col','k','synf_label_fs',12,'synf_label_fw','bold','synf_label_fa','normal',...     % texts: synfire label
    'synf_c_result_vis','on','synf_c_result_col','k','synf_c_result_fs',12,'synf_c_result_fw','normal','synf_c_result_fa','normal',... % texts: synfire c-result
    'synf_f_result_vis','on','synf_f_result_col','k','synf_f_result_fs',13,'synf_f_result_fw','bold','synf_f_result_fa','normal',...   % texts: synfire f-result
    'synf_sublabel_vis','on','synf_sublabel_col','k','synf_sublabel_fs',12,'synf_sublabel_fw','bold','synf_sublabel_fa','normal',...   % texts: synfire subplot label
    'synf_cblabel_vis','on','synf_cblabel_col','k','synf_cblabel_fs',12,'synf_cblabel_fw','bold','synf_cblabel_fa','normal',...        % texts: synfire colorbar label
    'synf_c_line_vis','on','synf_c_line_col','k','synf_c_line_ls','-','synf_c_line_lw',1,'synf_c_line_m','.','synf_c_line_ms',15,...   % lines: synfire c-line
    'synf_e_line_vis','on','synf_e_line_col','k','synf_e_line_ls','-','synf_e_line_lw',2,'synf_e_line_m','.','synf_e_line_ms',16,...   % lines: synfire e-line
    'synf_halfmat_line_vis','on','synf_halfmat_line_col','k','synf_halfmat_line_ls','-','synf_halfmat_line_lw',2,...                   % lines: synfire e-line
    'mat_height',0.2,'mat_width',0.2,... % subplots: images
    'image_vis','on',...                 % subplots: images
    'colpat_vis','on'...                 % spike train group color patches
);


spikes=[];
listbox_str={...
    'Frequency mismatch';...            % 1
    'Spiking events';...                % 2
    'Clustering';...                    % 3
    'Non-spurious events';...           % 4
    'Poisson Divergence';...            % 5
    'Splay state vs. identical';...     % 6
    'Testfile-Txt';...                  % 7
    'Testfile-Mat';...                  % 8 this is the mat-file '...-ca', the other two files '...-zp' and '...-01' work analogously, see comments at case f_para.offset+8
    'SPIKY-Paper';...                   % 9
    'Reliable';...                      % 10
    'Random';...                        % 11
    'Bursts';...                        % 12
    'Poisson';...                       % 13
};

f_para.offset=0;     % 
if calc
    switch d_para.sel_index
                        
        case f_para.offset+1                                % Bi: Frequency mismatch

            d_para.tmin=0;
            d_para.tmax=1300;
            d_para.dts=1;
            spikes=cell(1,2);
            spikes{1}=100:100:1200;
            spikes{2}=100:110:1200;
            %spikes{3}=[spikes{1}-30 1270];
            d_para.comment_string='SPIKY_Bi-Frequency-Mismatch';
            d_para.selective_averages={ [0 650]; [650 1300]};
            d_para.instants=[200];

        case f_para.offset+2                                % Multi: decreasing noise + 5 events

            d_para.tmin=0;
            d_para.tmax=4000;
            d_para.dts=1;

            num_trains=50; num_spikes=40;               % Set spikes
            noise=[1:-1/(num_spikes/4-1):0 0];
            num_noises=length(noise);
            num_events=5;
            spikes=cell(1,num_trains);
            for trac=1:num_trains
                spikes{trac}=sort(rand(1,num_spikes/2),2)*d_para.tmax/2;
                for nc=1:num_events
                    spikes{trac}=[spikes{trac} nc*d_para.tmax/2/num_events+50*noise(ceil(num_noises-(nc-1)*num_noises/num_events)).*randn];
                end
                spikes{trac}=[spikes{trac} 100*(num_spikes/2-1)+200*(1:num_spikes/4+1)+50*noise.*randn(1,num_spikes/4+1)];
            end            
            d_para.comment_string='Multi-Events';
            
        case f_para.offset+3                                      % Clustering
            
            parts=3;   % 1-first half,2-second half,3-all

            d_para.tmin=0;
            d_para.tmax=4000;
            d_para.dts=1;

            d_para.all_train_group_names={'G1';'G2';'G3';'G4'};
            d_para.all_train_group_sizes=[10 10 10 10];
            
            %d_para.num_all_train_groups=length(d_para.all_train_group_sizes);

            num_trains=40; num_spikes=16;
            noise=[0.1 0.15 0.2 0.25 0.2 0.15 0.1 0.1];

            matspikes=zeros(num_trains,num_spikes);
            %d_para.interval_names{1}='2 Cluster - AABB';
            for nc=1:num_spikes/8
                matspikes(1:num_trains/2,nc)=(nc-0.5)/num_spikes*d_para.tmax+50*noise(1).*randn(1,num_trains/2)';
                matspikes(num_trains/2+(1:num_trains/2),nc)=nc/num_spikes*d_para.tmax+50*noise(1).*randn(1,num_trains/2)';
            end

            %d_para.interval_names{2}='2 Cluster - ABBA';
            for nc=num_spikes/8+(1:num_spikes/8)
                matspikes(num_trains/4+(1:num_trains/2),nc)=(nc-0.5)/num_spikes*d_para.tmax+50*noise(2).*randn(1,num_trains/2)';
                matspikes([1:num_trains/4 num_trains*3/4+(1:num_trains/4)],nc)=nc/num_spikes*d_para.tmax+50*noise(2).*randn(1,num_trains/2)';
            end

            %d_para.interval_names{3}='2 Cluster - ABAB';
            for nc=num_spikes/4+(1:num_spikes/8)
                matspikes([1:num_trains/4 num_trains/2+(1:num_trains/4)],nc)=(nc-0.5)/num_spikes*d_para.tmax+50*noise(3).*randn(1,num_trains/2)';
                matspikes([num_trains/4+(1:num_trains/4) num_trains*3/4+(1:num_trains/4)],nc)=nc/num_spikes*d_para.tmax+50*noise(3).*randn(1,num_trains/2)';
            end

            %d_para.interval_names{4}='2 Cluster - Random association';
            rand_st=randperm(num_trains);
            for nc=num_spikes*3/8+(1:num_spikes/8)
                matspikes(rand_st(1:num_trains/2),nc)=(nc-0.5)/num_spikes*d_para.tmax+50*noise(4).*randn(1,num_trains/2)';
                matspikes(rand_st(num_trains/2+(1:num_trains/2)),nc)=nc/num_spikes*d_para.tmax+50*noise(4).*randn(1,num_trains/2)';
            end

            %d_para.interval_names{5}='3 Cluster - ABBC';
            for nc=num_spikes/2+(1:num_spikes/8)
                matspikes(1:num_trains/4,nc)=(nc-0.25)/num_spikes*d_para.tmax+50*noise(5).*randn(1,num_trains/4)';
                matspikes(num_trains/4+(1:num_trains/2),nc)=(nc-0.5)/num_spikes*d_para.tmax+50*noise(5).*randn(1,num_trains/2)';
                matspikes(num_trains*3/4+(1:num_trains/4),nc)=nc/num_spikes*d_para.tmax+50*noise(5).*randn(1,num_trains/4)';
            end
            matspikes(matspikes>0)=matspikes(matspikes>0)-60;

            %d_para.interval_names{6}='4 Cluster - ABCD';
            for nc=num_spikes*5/8+(1:num_spikes/8)
                matspikes(1:num_trains/4,nc)=nc/num_spikes*d_para.tmax+50*noise(6).*randn(1,num_trains/4)'-30;
                matspikes(num_trains/4+(1:num_trains/4),nc)=(nc-0.25)/num_spikes*d_para.tmax+50*noise(6).*randn(1,num_trains/4)'-30;
                matspikes(num_trains/2+(1:num_trains/4),nc)=(nc-0.5)/num_spikes*d_para.tmax+50*noise(6).*randn(1,num_trains/4)'-30;
                matspikes(num_trains*3/4+(1:num_trains/4),nc)=(nc-0.75)/num_spikes*d_para.tmax+50*noise(6).*randn(1,num_trains/4)'-30;
            end

            %d_para.interval_names{7}='8 Cluster - ABCDEFGH';
            for nc=num_spikes*6/8+(1:num_spikes/8)
                matspikes(1:num_trains/8,nc)=(nc-0.11)/num_spikes*d_para.tmax+50*noise(7)/2.*randn(1,num_trains/8)';
                matspikes(num_trains/8+(1:num_trains/8),nc)=(nc-0.22)/num_spikes*d_para.tmax+50*noise(7)/2.*randn(1,num_trains/8)';
                matspikes(num_trains/4+(1:num_trains/8),nc)=(nc-0.33)/num_spikes*d_para.tmax+50*noise(7)/2.*randn(1,num_trains/8)';
                matspikes(num_trains*3/8+(1:num_trains/8),nc)=(nc-0.44)/num_spikes*d_para.tmax+50*noise(7)/2.*randn(1,num_trains/8)';
                matspikes(num_trains/2+(1:num_trains/8),nc)=(nc-0.55)/num_spikes*d_para.tmax+50*noise(7)/2.*randn(1,num_trains/8)';
                matspikes(num_trains*5/8+(1:num_trains/8),nc)=(nc-0.66)/num_spikes*d_para.tmax+50*noise(7)/2.*randn(1,num_trains/8)';
                matspikes(num_trains*3/4+(1:num_trains/8),nc)=(nc-0.77)/num_spikes*d_para.tmax+50*noise(7)/2.*randn(1,num_trains/8)';
                matspikes(num_trains*7/8+(1:num_trains/8),nc)=(nc-0.88)/num_spikes*d_para.tmax+50*noise(7)/2.*randn(1,num_trains/8)';
            end

            %d_para.interval_names{8}='Random Spiking';
            for nc=num_spikes*7/8+(1:num_spikes/8)
                matspikes(1:num_trains,nc)=nc/num_spikes*d_para.tmax-d_para.tmax/num_spikes.*rand(1,num_trains)';
            end
            
            if parts==1
                d_para.tmin=0;
                d_para.tmax=2000;
            elseif parts==2
                d_para.tmin=2000;
                d_para.tmax=4000;
            end
            spikes=cell(1,num_trains);
            for trac=1:num_trains
                spikes{trac}=matspikes(trac,(matspikes(trac,:)>d_para.tmin & matspikes(trac,:)<d_para.tmax))-d_para.tmin;
            end
            d_para.tmax=d_para.tmax-d_para.tmin;
            d_para.tmin=0;
            clear matspikes

            d_para.instants= (250:500:3750);
            %d_para.instants= 250;
            %d_para.instants= [];

            d_para.selective_averages={ [0 4000];...
                 [0 500]; [500 1000]; [1000 1500]; [1500 2000]; [2000 2500]; [2500 3000]; [3000 3500]; [3500 4000];...
                 [0 1000]; [500 1500]; [1000 2000]; [1500 2500]; [2000 3000]; [2500 3500]; [3000 4000];...
                 [0 500 1000 1500]; [500 1000 1500 2000]; [1000 1500 2000 2500]; [1500 2000 2500 3000]; [2000 2500 3000 3500]; [2500 3000 3500 4000];...
                 [0 500 1000 1500 2000 2500 3000 3500]; [500 1000 1500 2000 2500 3000 3500 4000];...     % Selected average over different intervals
                 [0 4000]};
            %d_para.selective_averages={ [0 4000]};
            %d_para.selective_averages=[];

            tracs=1:num_trains;
            d_para.triggered_averages=cell(1,length(tracs));
            for trac=1:length(tracs)
                d_para.triggered_averages{trac}=round(spikes{tracs(trac)}/d_para.dts)*d_para.dts;       % Triggered averaging over all time instants when a certain neuron fires
            end
            %d_para.triggered_averages=[];

            d_para.thin_separators=[];
            d_para.thick_separators=[];
            d_para.thin_markers=500:500:d_para.tmax-500;
            d_para.thick_markers=[];

            d_para.interval_names={'2 Cluster - AABB';'2 Cluster - ABBA';'2 Cluster - ABAB';'2 Cluster - Random association';...
                '3 Cluster - ABBC';'4 Cluster - ABCD';'8 Cluster - ABCDEFGH';'Random Spiking'};
            d_para.interval_divisions=500:500:d_para.tmax-500; % Edges of subsections
            d_para.comment_string='SPIKY_Clustering';
            f_para.comment_string='';
            f_para.spike_train_color_coding_mode=2;
            
            %spikes=spikes(1:4);
            
%             spikes=textread('PySpike_testdata.txt');  % ###################
%             %spikes=spikes([7:8],end-2:end);
%             
%             d_para.dts=0.0000001;
%             d_para.thin_markers=[];
%             d_para.instants= [];
%             d_para.selective_averages=[];
%             d_para.triggered_averages=[];
%             d_para.all_train_group_names={};
%             d_para.all_train_group_sizes=[];
%             f_para.spike_train_color_coding_mode=1;

        case f_para.offset+4                                % Non-spurious events

            d_para.tmin=0;
            d_para.tmax=400;
            d_para.dts=1;

            num_trains=50;
            num_spikes=7;

            thr1=100; % thr2=thr1+200;

            balance=0;

            while balance~=1

                randy=rand(1,num_trains);
                matspikes=zeros(num_trains,num_spikes);
                matspikes(1:num_trains,1)=0.001;
                matspikes(1:num_trains,2)=1+randy*80;
                matspikes(1:num_trains,3)=repmat(thr1,num_trains,1)+10*(rand(num_trains,1)-0.5);
                matspikes(1:num_trains,4)=200;
                matspikes(1:num_trains,5)=201+randy*80;
                matspikes(1:num_trains,num_spikes)=d_para.tmax; %-0.001;

                matspikes(:,num_spikes-1)=matspikes(:,3)+200;
                matspikes((matspikes(:,3)>thr1),num_spikes-1)=0;

                larger=sum(matspikes(:,num_spikes-1)>0);
                balance=larger*2/num_trains;

                for trac=1:num_trains
                    dummy=sort(matspikes(trac,1:num_spikes));
                    matspikes(trac,1:num_spikes)=[dummy(dummy>0) dummy(dummy==0)];
                end
                if balance==1
                    break
                end
            end
            spikes=cell(1,num_trains);
            for trac=1:num_trains
                spikes{trac}=matspikes(trac,:);
            end
            clear matspikes
            d_para.comment_string='SPIKY_Non-spurious';
                        
        case f_para.offset+5                                % Poisson (Divergence)

            num_all_spikes=200;
            num_trig_trac1_spikes=12;
            %num_all_spikes=10; num_trig_trac1_spikes=3;

            num_trains=20;
            trig_trac1=1;
            trig_tracs1=[4 8 11 16 19];
            d_para.tmin=0;
            d_para.tmax=100; %min(matspikes(:,num_all_spikes))*1.0001;
            d_para.dts=0.001;

            matspikes=zeros(num_trains,num_all_spikes);
            for trac=setdiff(1:num_trains,trig_trac1)
                dummy=SPIKY_f_poisson(num_all_spikes,1,0);
                dummy(dummy<d_para.dts)=d_para.dts;
                matspikes(trac,1:num_all_spikes)=cumsum(dummy);
            end
            dummy=SPIKY_f_poisson(num_trig_trac1_spikes,1,0);
            dummy(dummy<d_para.dts)=d_para.dts;
            matspikes(trig_trac1,1:num_trig_trac1_spikes)=cumsum(dummy);

            matspikes(matspikes<d_para.tmin | matspikes>d_para.tmax)=0;

            num_spikes=zeros(1,num_trains);
            for trac=1:num_trains
                num_spikes(trac)=find(matspikes(trac,1:num_all_spikes),1,'last');
            end

            matspikes(trig_trac1,1:num_trig_trac1_spikes)=matspikes(trig_trac1,1:num_trig_trac1_spikes)/max(matspikes(trig_trac1,1:num_trig_trac1_spikes))*d_para.tmax*0.97;
            for trac=setdiff(1:num_trains,trig_trac1)
                matspikes(trac,1:num_spikes(trac))=matspikes(trac,1:num_spikes(trac))/max(matspikes(trac,1:num_spikes(trac)))*d_para.tmax*0.995;
                matspikes(trac,num_spikes(trac))=matspikes(trac,num_spikes(trac))-rand*5;
                matspikes(trac,1:num_spikes(trac))=sort(matspikes(trac,1:num_spikes(trac)));
            end

            max_num_spikes=max(num_spikes);
            matspikes=matspikes(:,1:max_num_spikes);

            for trac=trig_tracs1
                indy=[];
                for spic=1:num_spikes(trig_trac1)
                    rem_indy=setdiff(1:max_num_spikes,indy);
                    [dummy,index]=min(abs(matspikes(trac,rem_indy)-matspikes(trig_trac1,spic)));
                    indy=[indy rem_indy(index)];
                    matspikes(trac,rem_indy(index))=matspikes(trig_trac1,spic)+0.05*rand;
                end
                matspikes(trac,1:num_spikes(trac))=sort(matspikes(trac,1:num_spikes(trac)));
            end
            matspikes(matspikes<d_para.tmin | matspikes>d_para.tmax)=0;

            spikes=cell(1,num_trains);
            for trac=1:num_trains
                spikes{trac}=matspikes(trac,:);
            end
            clear matspikes
            
            %num_spikes2=cellfun('length',spikes);
            d_para.comment_string='SPIKY_Poisson-Driver';

        case f_para.offset+6                                % 2011 paper, Fig. 2a   (splay state vs. identical)

            d_para.tmin=0;
            d_para.tmax=800;
            d_para.dts=1;

            num_trains=20;
            num_spikes=10;
            spikes=cell(1,num_trains);
            spikes{1}(1:num_spikes)= (0:100:(num_spikes-1)*100);
            for trac=2:num_trains
                spikes{trac}(1)= spikes{1}(1);
                spikes{trac}(2:5)= (spikes{1}(1:4)+(trac-1)*100/num_trains);
                spikes{trac}(6:num_spikes)= spikes{1}(5:num_spikes-1);
                spikes{trac}=spikes{trac}(spikes{trac}<=d_para.tmax);
            end
            d_para.comment_string='SPIKY_Splay';

        case f_para.offset+7                                        % Testfile-Txt

            textfile='SPIKY_testdata.txt';
            spikes=dlmread(textfile);
            d_para.tmin=0;
            d_para.tmax=4000;
            d_para.dts=1;
            d_para.comment_string='Testfile-Txt';

        case f_para.offset+8                                        % Testfile-Mat (cell arrays)

            d_para.matfile='SPIKY_testdata_ca.mat';
            d_para.tmin=0;
            d_para.tmax=4000;
            d_para.dts=1;
            d_para.comment_string='Testfile-Mat-ca';

%             d_para.matfile='SPIKY_testdata_zp.mat';  % Testfile-Mat (matrix with zero padding)
%             d_para.tmin=0;
%             d_para.tmax=4000;
%             d_para.dts=1;
%             d_para.comment_string='Testfile-Mat-zp';
% 
%             d_para.matfile='SPIKY_testdata_01.mat';  % Testfile-Mat (matrix with 0 and 1)
%             d_para.tmin=0;
%             d_para.tmax=4000;
%             d_para.dts=1;
%             d_para.comment_string='Testfile-Mat-01';

        case f_para.offset+9                                       % SPIKY-Paper-Example

            d_para.tmin=0;
            d_para.tmax=2000;
            d_para.dts=1;

            d_para.all_train_group_names={'G1';'G2';'G3';'G4'};
            d_para.all_train_group_sizes=[5 5 5 5];
            %d_para.num_all_train_groups=length(d_para.all_train_group_sizes);

            num_trains=20; num_spikes=8;
            noise=[0.1 0.1 0.1];
            cnoise=[0 50 100 150 75];

            matspikes=zeros(num_trains,num_spikes);
            %d_para.interval_names{1}='2 Cluster - AABB';
            for nc=1:num_spikes/4
                matspikes(1:num_trains/4,nc)=(nc-0.75)/num_spikes*d_para.tmax+cnoise(1)*noise(1).*randn(1,num_trains/4)';
                matspikes(num_trains/4+(1:num_trains/4),nc)=(nc-0.75)/num_spikes*d_para.tmax+cnoise(2)*noise(1).*randn(1,num_trains/4)';
                matspikes(num_trains/2+(1:num_trains/4),nc)=(nc-0.25)/num_spikes*d_para.tmax+cnoise(3)*noise(1).*randn(1,num_trains/4)';
                matspikes(3*num_trains/4+(1:num_trains/4),nc)=(nc-0.25)/num_spikes*d_para.tmax+cnoise(4)*noise(1).*randn(1,num_trains/4)';
            end
            %d_para.interval_names{2}='2 Cluster - Random association';
            %rand_st=randperm(num_trains);
            rand_st=[1 3 6 8 10 11 15 16 18 20 2 4 5 7 9 12 13 14 17 19];
            for nc=num_spikes*1/4+(1:num_spikes/4)
                matspikes(rand_st(1:num_trains/2),nc)=(nc-0.75)/num_spikes*d_para.tmax+cnoise(5)*noise(2).*randn(1,num_trains/2)';
                matspikes(rand_st(num_trains/2+(1:num_trains/2)),nc)=(nc-0.25)/num_spikes*d_para.tmax+cnoise(5)*noise(2).*randn(1,num_trains/2)';
            end
            %d_para.interval_names{3}='4 Cluster - ABCD';
            for nc=num_spikes*1/2+(1:num_spikes/4)
                matspikes(1:num_trains/4,nc)=nc/num_spikes*d_para.tmax+cnoise(1)*noise(3).*randn(1,num_trains/4)'-30;
                matspikes(num_trains/4+(1:num_trains/4),nc)=(nc-0.25)/num_spikes*d_para.tmax+cnoise(2)*noise(3).*randn(1,num_trains/4)'-30;
                matspikes(num_trains/2+(1:num_trains/4),nc)=(nc-0.5)/num_spikes*d_para.tmax+cnoise(3)*noise(3).*randn(1,num_trains/4)'-30;
                matspikes(num_trains*3/4+(1:num_trains/4),nc)=(nc-0.75)/num_spikes*d_para.tmax+cnoise(4)*noise(3).*randn(1,num_trains/4)'-30;
            end
            %d_para.interval_names{4}='Random Spiking';
            for nc=num_spikes*3/4+(1:num_spikes/4)
                matspikes(1:num_trains,nc)=nc/num_spikes*d_para.tmax-d_para.tmax/num_spikes.*rand(1,num_trains)';
            end

            tracs=7;                % introducing some extra correlations
            tracf=[2 9 14 19];
            
            matspikes(tracs,3)=min(matspikes([tracs tracf],3));
            matspikes(tracs,3)=687.5;
            matspikes(tracf,3)=matspikes(tracs,3)+2*rand(1,length(tracf));
            matspikes(tracs,4)=min(matspikes([tracs tracf],4));
            matspikes(tracs,4)=937.5;
            matspikes(tracf,4)=matspikes(tracs,4)+2*rand(1,length(tracf));

            matspikes(tracs,7)=min(matspikes([tracs tracf],7));
            matspikes(tracs,7)=1625;
            matspikes(tracf,7)=matspikes(tracs,7)+2*rand(1,length(tracf));
            matspikes(tracs,8)=min(matspikes([tracs tracf],8));
            matspikes(tracs,8)=1875;
            matspikes(tracf,8)=matspikes(tracs,8)+2*rand(1,length(tracf));
            
            matspikes(:,9)=500;
            matspikes(:,10)=1000+randn(num_trains,1)*0;
            matspikes(:,11)=1500;
            
            spikes=cell(1,num_trains);
            for trac=1:num_trains
                spikes{trac}=sort(matspikes(trac,(matspikes(trac,:)>d_para.tmin & matspikes(trac,:)<d_para.tmax))-d_para.tmin);
            end
            d_para.tmax=d_para.tmax-d_para.tmin;
            d_para.tmin=0;
            clear matspikes
            d_para.instants=250;

            d_para.selective_averages={ [0 500 1000 1500]; [0 2000] };

            d_para.triggered_averages=cell(1,length(tracs));
            for trac=1:length(tracs)
                d_para.triggered_averages{trac}=round(spikes{tracs(trac)}/d_para.dts)*d_para.dts;       % Triggered averaging over all time instants when a certain neuron fires
            end
            d_para.triggered_averages{trac}=d_para.triggered_averages{trac}([4 5 10 11]);   % 2nd and 4th subinterval only
            %d_para.triggered_averages{trac}=d_para.triggered_averages{trac}([1 2 4 5 7 8 10 11])   % subintervals only

            d_para.thin_markers=500:500:d_para.tmax-500;
            d_para.thin_markers=[];
            d_para.thick_markers=[];
            d_para.thin_separators=[];
            d_para.thick_separators=[];

            d_para.interval_names={'2 Cluster - AABB';'2 Cluster - Random association';'4 Cluster - ABCD';'Random Spiking'};
            d_para.interval_divisions=500:500:d_para.tmax-500; % Edges of subsections
            d_para.comment_string='SPIKY_Clustering';
            f_para.comment_string='';
            f_para.spike_train_color_coding_mode=2;
            f_para.profile_norm_mode=2;
            f_para.group_matrices=0;
            f_para.dendrograms=1;
            f_para.show_title=0;
            f_para.profile_mode=3;
            f_para.profile_average_line=1;
            f_para.extreme_spikes=0;
            f_para.print_mode=1;
            f_para.plot_mode=1;
            
        case f_para.offset+10                                       % Reliable
            
            d_para.num_trains=10; num_spikes=d_para.num_trains; dura=100;
            rng(1000)
            noise=rand(d_para.num_trains,num_spikes);
            spikes=zeros(d_para.num_trains,num_spikes);
            for trc=1:d_para.num_trains
                spikes(trc,1:num_spikes)=((1:num_spikes)+0.2*noise(trc,1:num_spikes))*dura;
            end
            d_para.tmin=0; d_para.tmax=(num_spikes+1)*dura; d_para.dts=0.001;
            spikes=round(spikes/d_para.dts)*d_para.dts;
            spikes(spikes<d_para.tmin | spikes>d_para.tmax)=0;            
            d_para.comment_string='Reliable';
            
        case f_para.offset+11                                       % Random
            
            d_para.num_trains=10; num_spikes=d_para.num_trains; dura=100;
            rng(1000)
            noise=rand(d_para.num_trains,num_spikes);
            spikes=zeros(d_para.num_trains,num_spikes);
            for trc=1:d_para.num_trains
                spikes(trc,1:num_spikes)=((1:num_spikes)+0.2*noise(trc,1:num_spikes))*dura;
            end
            d_para.tmin=0; d_para.tmax=(num_spikes+1)*dura; d_para.dts=0.001;
            spikes=round(spikes/d_para.dts)*d_para.dts;
            spikes(spikes<d_para.tmin | spikes>d_para.tmax)=0;
            all_spikes=reshape(spikes,1,d_para.num_trains*num_spikes);
            all_spikes2=all_spikes(randperm(d_para.num_trains*num_spikes));
            spikes=sort(reshape(all_spikes2,d_para.num_trains,num_spikes),2);            
            d_para.num_trains=length(spikes);
            d_para.comment_string='Random';
            
        case f_para.offset+12                                       % Bursts
            
            d_para.num_trains=10; num_spikes=d_para.num_trains; dura=100;
            rng(1000)
            noise=rand(d_para.num_trains,num_spikes);
            spikes=zeros(d_para.num_trains,num_spikes);
            for trc=1:d_para.num_trains
                spikes(trc,1:num_spikes)=(trc+0.2*noise(1:num_spikes,trc))*dura;
            end
            d_para.tmin=0; d_para.tmax=(num_spikes+1)*dura; d_para.dts=0.001;
            spikes=round(spikes/d_para.dts)*d_para.dts;
            spikes(spikes<d_para.tmin | spikes>d_para.tmax)=0;            
            d_para.comment_string='Bursts';
            
        case f_para.offset+13                                      % Poisson
            
            para.tmin=0;
            para.tmax=1000;
            para.dts=0.000001;
            num_trains=20;
            rates=ones(1,num_trains)*10;
            spikes=cell(1,num_trains);
            for trc=1:num_trains
                dummy=cumsum(SPIKY_f_poisson(ceil(para.tmax*rates(trc)*2),rates(trc),0));
                dummy=dummy(dummy<para.tmax);
                spikes{trc}=dummy;
            end
            d_para.comment_string='Poisson';
            
        otherwise

            entries = d_para.entries;
            entry=char(entries(d_para.sel_index));
            if stracmp(entry(length(entry)-3:length(entry)),'.mat')
                d_para.matfile=entry;
            elseif stracmp(entry(length(entry)-3:length(entry)),'.txt')
                txtfile=entry;
                spikes=dlmread(txtfile);
            end
            d_para.comment_string=entry;
    end

    SPIKY_check_spikes
    if ret==1
        spikes=[];
        return
    end

end
end

%
% Here are short descriptions for some of the parameters that can be set in the beginning of this file and which are loaded
% when SPIKY is started (but not when it is reset, thus in order for changes to become active you have to restart SPIKY !!!)
%
%
% structure 'd_para': parameters that describe the data (some of these will automatically be determined from the data)
% ====================================================================================================================
%
% tmin: Beginning of recording, will automatically be determined from the data 
% tmax: End of recording, will automatically be determined from the data 
% dts: Sampling interval, precision of spike times, will automatically be determined from the data 
% max_total_spikes: Maximum number of spikes that will be plotted
% max_memo_init: Memory management, should be big enough to hold the basic matrices but small enough to not run out of memory
% num_trains: Number of spike trains, will automatically be determined from the data 
% select_train_mode: Selection of spike trains (1-all,2-selected groups,3-selected trains)
% select_train_groups: Selected spike train groups (if 'select_train_mode==2')
% preselect_trains: Selected spike trains (if 'select_train_mode==3')
% latency_onset: latency of first spike after this time instant, can be used as a criterion for sorting spike trains 
% num_all_train_groups: Number of spike train groups
% all_train_group_names: Names of spike train groups
% all_train_group_sizes: Sizes of respective spike train groups
% thick_separators: Very relevant seperations between groups of spike trains
% thin_separators: Relevant seperations between groups of spike trains
% thick_markers: Even more relevant time instants
% thin_markers: Relevant time instants
% interval_divisions: Edges of subsections, can be useful in titles of the movie
% interval_names: Captions for subsections, can be shown in titles of the movie (e.g., for time instants within these intervals)
% instants_str: One or more continuous intervals for selective temporal averaging
% select_averages_str: Time instants of interest
% trigger_averages_str: Non-continuous time-instants for triggered temporal averaging, external (e.g. certain stimulus properties) but also internal (e.g. certain event times)
% spikes_variable: Default name of variable / field that cpontains the spike times
% comment_string: Additional comment on the example, will be used in file and figure names
% example: Position of preselected item in the ListBox in the 'Selection: Data' panel
%
%
% structure 'f_para': parameters that determine the appearance of the figures (and the movie)
% ===========================================================================================
%
% imagespath: Path where images (postscript) will be stored
% moviespath: Path where movies (avi) will be stored
% matpath: Path where Matlab files (mat) will be stored
% print_mode: Saving to postscript file? (0-no,1-yes)
% movie_mode: Record a movie? (0-no,1-yes)
% publication: Omits otherwise helpful information, such as additional comments (0-no,1-yes)
% comment_string: Additional comment on the example, will be used in file and figure names
% num_fig: Number of figure
% pos_fig: Position of figure
% supo1: Position (in relative units) of the first subplot which contains spikes and dissimilarity profiles
% hints: Determines whether short hints will be shown when hovering with the mouse cursor above the SPIKY elements of interest
% show_title: Determines whether a figure title will be shown (above the first subplot containing the spikes) 
% time_unit_string: Time unit, used in labels
% x_offset: f_para.offset for time axis (useful for example if you select an intermediate interval but want to have the time scale start at t=0) 
% x_scale: Scale factor of time unit
% x_realtime_mode: Sets reference system for the movie, if set during the movie the time position is kept constant while the spikes move
%       (simulating an online recorded stream of incoming spike times)
% extreme_spikes: Determines whether dotted lines are shown at the position of the extreme spikes
%       (the last first spike and the first last spike which indicate the onset of the edge effects)
% ma_mode: Moving average mode: (0-no,1-only,2-both)
% mao: Order of moving average (piecewise constant and piecewise linear dissimilarity profiles)
% frames_per_second: Well, frames per second for the movie
% num_average_frames: Number of frames the averages are shown at the end of the movie (if this is too small they are hardly visible)
% profile_mode: Allows to additionally/exclusively show dissimilarity profiles averaged over certain spike train groups only (1-all only,2-groups only,3-all and groups)
% profile_norm_mode: Normalization of averaged bivariate dissimilarity profiles (1-Absolute maximum value 'one',2-Overall maximum value (from 0/(-1 for asym)),3-Individual maximum value (from 0/(-1 for asym)),4-Overall maximum value,5-Individual maximum value)
% profile_average_line: Determines whether a line at the mean value is shown for each dissimilarity profile
% color_norm_mode: normalization of pairwise color matrices (1-Absolute maximum value,2-Overall maximum value (from 0/(-1 for asym)),3-Individual maximum value (from 0/(-1 for asym)),4-Overall maximum value,5-Individual maximum value)
% colorbar: Determines whether a colorbar is shown next to the dissimilarity matrices
% group_matrices: Allows tracing the overall synchronization among groups of spike trains (0-no,1-yes)
% dendrograms: Show cluster trees from distance matrices (0-no,1-yes)
% histogram: Show histogram with number of spikes for each spike train (on the right of the spike trains)
% spike_train_color_coding_mode: Labeling of spike trains used also in the dendrograms (1-no,2-spike train groups,3-spike trains)
% spike_col: color spikes according to group of train, depending on spike_train_color_coding_mode (0-no,+1-spike trains,+2-bars at the edges)
% plot_mode: +1:profiles,+2:frame comparison,+4:frame sequence (the latter two are mutually exclusive, otherwise binary addition allows combinations)
% psth_num_bins: Number of bins for the Peristimulus time histogram.
% psth_window: Kernel width of Gaussian filter for the Peristimulus time histogram. Set to 0 for no filtering.
% edge_correction: Determines whether the edge effect (spurious drop to zero dissimilarity at the edges caused by the auxiliary spikes) is corrected or not
% subplot_size: Vector with relative size of subplots
% subplot_posi: Vector with order of subplots
%
%
% structure 's_para': parameters that describe the appearance of the individual subplots (measure time profiles)
% ==============================================================================================================
% (this structure is less relevant for you since most of these parameters are set automatically)
%
% window_mode: time interval selection (1-all (recording limits),2:outer spikes,3-inner spikes,4-smaller analysis window)
% nma: Selected moving averages (depends on f_para.ma_mode)
% causal: determines kind of moving average, set automatically for each measure (0-no,1-yes)
% itmin: Beginning of analysis window, set automatically
% itmax: End of analysis window, set automatically
% num_subplots: depends on f_para.subplot_posi, set automatically
% xl: x-limits for plotting, set automatically
% yl: y-limits for plotting, set automatically
% plot_mode: equals f_para.plot_mode
%

