% SPIKY_loop_trigger --- Copyright Thomas Kreuz, Nebojsa Bozanic; March 2015
%
% This is similar to 'SPIKY_loop.m' only that you do not look at different
% datasets, rather you look at different epochs within the same dataset. The typical
% setup would be a continuous recording during which different stimuli are
% presented in some random order. The task is to separate the responses
% to different stimuli and align them to their trigger onset. This could be
% very useful in order to investigate neuronal coding.
%
% 'SPIKY_loop_trigger' is the main program where the variables are set and from where the funtion 'SPIKY_loop_f_distances' is called.
% This function uses a minimum number of input and output variables (described below).
%
% ########################################################################################################################
% ##### This program should work already but it is not yet completely finished, there will be some refinements soon. #####
% ########################################################################################################################
%
% More information on the program and the spike train distances can be found under
% "http://www.fi.isc.cnr.it/users/thomas.kreuz/Source-Code/SPIKY.html" and/or in
%
% Kreuz T, Mulansky M, Bozanic N: SPIKY: A graphical user interface for monitoring spike train synchrony. J Neurophysiol 113, 3432 (2015)
% Kreuz T, Chicharro D, Houghton C, Andrzejak RG, Mormann F: Monitoring spike train synchrony. J Neurophysiol 109, 1457 (2013)
% Kreuz T: SPIKE-distance. Scholarpedia 7(12):30652 (2012).
% Kreuz T: Measures of spike train synchrony. Scholarpedia, 6(10):11934 (2011).
% Kreuz T, Chicharro D, Greschner M, Andrzejak RG: Time-resolved and time-scale adaptive measures of spike train synchrony. J Neurosci Methods 195, 92 (2011).
% Kreuz T, Chicharro D, Andrzejak RG, Haas JS, Abarbanel HDI: Measuring multiple spike train synchrony. J Neurosci Methods 183, 287 (2009).
% Kreuz T, Haas JS, Morelli A, Abarbanel HDI, Politi A: Measuring spike train synchrony. J Neurosci Methods 165, 151 (2007)
%
% For questions and comments please contact us at "thomaskreuz (at) cnr.it".
%
%
%
% Input:
% ======
%
% Cell 'spikes' with two or more spike trains (each cell array contains the spike times of one spike train)
%
% Parameter structure 'para' that describe the data (see below)
%
% tmin:            Beginning of recording
% tmax:            End of recording
% dts:             Sampling interval, precision of spike times
%                  [!!! Please make sure that this value is not larger than the actual sampling size,
%                   otherwise two spikes can occur at the same time instant and this can lead to problems in the algorithm !!!]
% select_measures: Vector with measure selection (for order see below)
%
%
% Output (Structure 'SPIKY_results'):
% =============================
%
%    SPIKY_results.<Measure>.name:     Name of selected measures (helps to identify the order within all_ other variables)
%    SPIKY_results.<Measure>.distance: Level of dissimilarity over all_ spike trains and the whole interval
%                                just one value, obtained by averaging over both spike trains and time
%    SPIKY_results.<Measure>.matrix:   Pairwise distance matrices, obtained by averaging over time
%    SPIKY_results.<Measure>.time:        Time-values of overall_ dissimilarity profile
%    SPIKY_results.<Measure>.profile:        Overall_ dissimilarity profile obtained by averaging over spike train pairs
%
% Note: For the ISI-distance the function 'SPIKY_f_pico' can be used to obtain the average value as well as
% x- and y-vectors for plotting (see example below):
%
% [overall_dissimilarity,plot_x_values,plot_y_values] = SPIKY_f_pico(SPIKY_results.isi,SPIKY_results.dissimilarity_profiles{1},para.tmin);
%

clear all
close all
%clc
para=struct('tmin',[],'tmax',[],'dts',[],'select_measures',[]);            % Initialization of parameter structure
colors='kbrgcmy';



% Measure order:    1-ISI  2-SPIKE  3-SPIKE_realtime  4-SPIKE_forward  7-PSTH   (SPIKE-Synchro and SPIKE-order are omitted since they are not useful here)
para.select_measures      =[0 1 0 0 0];  % Select measures (0-calculate,1-do not calculate)

m_para.all_measures_string={'ISI';'SPIKE';'SPIKE_realtime';'SPIKE_forward';'SPIKE_synchro';'SPIKE_order';'PSTH';};  % order of select_measures

para.select_measures      =[1 1 0 0 0 0 0];  % Select measures (0-calculate,1-do not calculate)

m_para.isi=1;
m_para.spike=[2 3 4];
m_para.spike_sync=[5 6];
m_para.psth=7;

plotting=3;           % +1:spikes,+2:dissimilarity profile
profile_plots=7;      % +1:individual trials,+2:all trails,+4:average over trials with specific stimuli
printing=0;           % 0:no,1;yes

% ######################################################################### Here you can set the general parameters that define the triggering
% ######################################################################### For this example play with select_stimuli and select_neuron_groups
% ######################################################################### to see different kind of results

tmin=0; tmax=200;                                                          % Recording limits in sec (overall time window)

triggers=[19 36 55 75 93 111 129 147 166 186];                             % Trigger times (here random trigger intervals between 17 and 20 sec)

pre=2; post=3;                                                             % Window around trigger times that will be taken into account

num_stimuli=3;                                                             % Overall number of stimuli
select_stimuli=[1 2 3];                                                      % which of these stimuli would you like to plot?

num_neurons_per_group=[10 10];                                             % We also separated data into two neuron groups who are differently affected by the stimuli
select_neuron_groups=[1 2];


% #########################################################################
% ######################################################################### Below we generate spikes thereby simulating the experimental setup described above
% #########################################################################

mean_rate=1;                                                               % Parameters of Poisson spike trains in this example
refrac=0.001;
precision=0.0001;

len=tmax-tmin;
win=pre+post;

num_groups=length(num_neurons_per_group);
num_total_neurons=sum(num_neurons_per_group);
num_select_neuron_groups=length(select_neuron_groups);
num_select_stimuli=length(select_stimuli);

num_triggers=length(triggers);
%iti_min=17;                                                                % Intertrial-interval (Randomized between iti_min and iti_max)
%iti_max=20;                                                                % these values could result in the vector 'triggers' (above the vector is simply set)
%iti_range=iti_max-iti_min;
%
%triggers=zeros(1,ceil(len/iti_min));                                       % vector 'trigger': Trial times, here obtained with randomized intertrial intervals
%triggers(1)=round(iti_min+rand*iti_range);
%num_triggers=1;
%while triggers(num_triggers)<tmax-iti_max
%    num_triggers=num_triggers+1;
%    triggers(num_triggers)=triggers(num_triggers-1)+round(iti_min+rand*iti_range);
%end
%triggers=triggers(1:num_triggers);

sp=0;
stimulus_label=zeros(1,num_triggers);                                      % Randomized stimulus order
for sc=1:num_stimuli
    stimulus_label(sp+(1:fix(num_triggers/num_stimuli)))=sc;
    sp=sp+fix(num_triggers/num_stimuli);
end
stimulus_label(sp+1:num_triggers)=ceil(rand(1,rem(num_triggers,num_stimuli))*num_stimuli);
stimulus_label=stimulus_label(randperm(num_triggers));
stim_col=1+(1:num_stimuli);

stimuli_pos=cell(1,num_stimuli);                                           % Indices of trial numbers for different stimuli
for sc=1:num_stimuli
    stimuli_pos{sc}=find(stimulus_label==sc);
end
num_stimulus_rep=cellfun('length',stimuli_pos);                            % Number of stimulus repetitions for different stimuli
select_trials=sort([stimuli_pos{select_stimuli}]);
num_select_trials=length(select_trials);

group_neurons=cell(1,num_groups);                                          % Indices of neurons for different neuron groups
for gc=1:num_groups
    group_neurons{gc}=sum(num_neurons_per_group(1:gc-1))+(1:num_neurons_per_group(gc));
end
select_neurons=[group_neurons{select_neuron_groups}];
num_trains=length(select_neurons);

all_spikes=cell(1,num_total_neurons);                                      % Spike train initialization (Poisson)
for trac=1:num_total_neurons
    dummy=tmin+cumsum(SPIKY_f_poisson(mean_rate*1.2*len,mean_rate,refrac));
    dummy=ceil(dummy(dummy<tmax)/precision)*precision;
    all_spikes{trac}=dummy;
end

for trac=1:num_trains                                                      % Create 'reliable spiking event' for first stimulus and all spike trains
    for tc=stimuli_pos{1}
        dummy=abs((all_spikes{trac}-triggers(tc)));
        [d,indy]=min(dummy);
        all_spikes{trac}(indy)=triggers(tc)+0.5+0.1*(rand-0.5);                 % short delay, low reliability
    end
end
if num_stimuli>1                                                           % Create 'specific spiking event' for second stimulus but only for first neuron group
    for trac=group_neurons{1}
        for tc=stimuli_pos{2}
            dummy=abs((all_spikes{trac}-triggers(tc)));
            [d,indy]=min(dummy);
            all_spikes{trac}(indy)=triggers(tc)+1+0.05*(rand-0.5);              % long delay, quite high reliability
        end
    end
end
if num_groups>1 && num_stimuli>2                                           % Create 'perfect spiking event' for third stimulus, this time only for second neuron group
    for trac=group_neurons{2}
        for tc=stimuli_pos{3}
            dummy=abs((all_spikes{trac}-triggers(tc)));
            [d,indy]=min(dummy);
            all_spikes{trac}(indy)=triggers(tc)+0.25; %+0.1*(rand-0.5);         % very short delay, absolute reliability (no randomness at all)
        end
    end
end

% #########################################################################
% ######################################################################### Replace data above with your own data
% #########################################################################

figure(55); clf; hold on
set(gcf,'Units','normalized','Position',[0.0525 0.0342 0.8854 0.8867])
for trc=1:length(all_spikes)
    for spc=1:length(all_spikes{trc})
        line(all_spikes{trc}(spc)*ones(1,2),[trc-1 trc],'Color','k')
    end
end
xlim([tmin tmax])
ylim([0 length(all_spikes)])
xl=xlim; yl=ylim;
for tc=1:num_groups-1
    line(xl,cumsum(num_neurons_per_group(1:tc))*ones(1,2),'Color','k','LineWidth',1)
end
for tc=1:num_triggers
    line(triggers(tc)*ones(1,2),yl,'Color',colors(stim_col(stimulus_label(tc))),'LineWidth',2)
end

title(['Number of stimulus types: ',num2str(num_stimuli),'   ---   Spiking response, Number of spike train groups: ',num2str(num_groups)],'FontWeight','bold','FontSize',16)
xlabel('Time','FontWeight','bold','FontSize',15)
set(gca,'FontSize',13)


%return


measures=find(para.select_measures);
num_measures=length(measures);
num_plots=(mod(plotting,2)>0)+(mod(plotting,4)>1)*num_measures+(mod(plotting,8)>3)*num_measures;

all_min=min([all_spikes{:}]);
all_max=max([all_spikes{:}]);

sx=cell(num_measures,num_select_trials);
sy=cell(num_measures,num_select_trials);

if num_plots>0
    figure(123); %clf
    set(gcf,'Name','SPIKY_loop_trigger')
    set(gcf,'Units','normalized','Position',[0.0525 0.0342 0.8854 0.8867])
end
        
for tc=1:num_select_trials
    disp(['Trial: ',num2str(tc),'  (',num2str(num_select_trials),')']);
    trig=select_trials(tc);

    wmin=triggers(trig)-pre;
    wmax=triggers(trig)+post;
    para.wmin=0;
    para.wmax=win;

    spikes=cell(1,num_trains);
    for trac=1:num_trains
        spikes{trac}=all_spikes{select_neurons(trac)}(all_spikes{select_neurons(trac)}>=wmin & all_spikes{select_neurons(trac)}<=wmax)-wmin;
    end

    d_para=para;
    SPIKY_check_spikes
    if ret==1
        return
    end
    para=d_para;

    % ################################################### Actual call_ of function !!!!!

    lspikes=spikes(cellfun('length',spikes)>0);
    para.num_trains=length(lspikes);
    SPIKY_results = SPIKY_loop_f_distances(lspikes,para); %#ok<NOPTS>

    % ################################################### Example plotting (just as a demonstration)

    if num_plots>0 
        subplotc=0;
        if mod(plotting,2)>0
            subplotc=subplotc+1;
            subplot(num_plots,1,subplotc)                                      % Spikes
            for trc=1:length(spikes)
                for spc=1:length(spikes{trc})
                    line(spikes{trc}(spc)*ones(1,2),[trc-1 trc],'Color',colors(stim_col(stimulus_label(trig))))
                end
            end
            xlim([para.wmin para.wmax])
            ylim([0 length(spikes)])
            title ('Spike trains','FontWeight','bold','FontSize',16)
            if tc==num_select_trials
                xl=xlim; yl=ylim;
                line(pre*ones(1,2),yl,'Color','k','LineWidth',2)
                for tc2=1:num_groups-1
                    line(xl,cumsum(num_neurons_per_group(1:tc2))*ones(1,2),'Color','k','LineWidth',1)
                end
            end
            xlabel('Time','FontWeight','bold','FontSize',15)
            set(gca,'XTick',0:len,'XTickLabel',-pre:post,'FontSize',13)
        end

        if mod(plotting,4)>1
            for mc=num_measures:-1:1
                measure=measures(mc);
                measure_var=m_para.all_measures_string{measure};
                measure_name=regexprep(measure_var,'_','-');

                subplotc=subplotc+1;
                subplot(num_plots,1,subplotc)                                      % Dissimilarity profile
                if measure==m_para.spike_sync                              % SPIKE-Synchronization not useful in this context since its profile is not continuous
                elseif measure==m_para.isi                                 % piecewise constant profiles have first to be transformed
                    isi_x=SPIKY_results.(measure_var).time;
                    isi_y=SPIKY_results.(measure_var).profile;
                    plot_y_values=zeros(size(isi_y,1),length(isi_x)*2);
                    for pc=1:size(isi_y,1)
                        [overall_dissimilarity,plot_x_values,plot_y_values(pc,:)] = SPIKY_f_pico(isi_x,isi_y(pc,:),para.wmin);
                    end
                    hold on
                    if mod(profile_plots,2)>0
                        plot(plot_x_values,plot_y_values,'Color',colors(stim_col(stimulus_label(trig))))
                    end
                elseif ismember(measure,m_para.spike)             % piecewise linear profiles can be plotted right away
                    x=SPIKY_results.(measure_var).time;
                    y=SPIKY_results.(measure_var).profile;
                    hold on
                    if mod(profile_plots,2)>0
                        plot(x,y,'Color',colors(stim_col(stimulus_label(trig))))
                    end
                elseif measure==m_para.psth                            % PSTH profile can be plotted right away
                    if tc==1
                        ylim([0 1])
                    end
                    x=SPIKY_results.(measure_var).time;
                    y=SPIKY_results.(measure_var).profile;
                    hold on
                    if mod(profile_plots,2)>0
                        plot(x,y,'Color',colors(stim_col(stimulus_label(trig))))
                    end
                end
                xlim([para.wmin para.wmax])
                title(measure_name,'FontWeight','bold','FontSize',16)
                if mc==1
                    xlabel('Time','FontWeight','bold','FontSize',15)
                end
                if tc==1 || tc==num_select_trials
                    if tc==num_select_trials
                        yl=ylim;
                        ylim([0 yl(2)])
                    end
                    yl=ylim;
                    line(pre*ones(1,2),yl,'Color','k','LineWidth',2)
                end
                set(gca,'XTick',0:len,'XTickLabel',-pre:post,'FontSize',13)
                if measure==m_para.isi
                    sx{mc,tc}=plot_x_values;
                    sy{mc,tc}=plot_y_values;
                else
                    sx{mc,tc}=SPIKY_results.(measure_var).time;
                    sy{mc,tc}=SPIKY_results.(measure_var).profile;
                end

                if tc==num_select_trials
                    if mod(profile_plots,4)>1
                        selection=1:num_select_trials; col=colors(1);
                        if measure<m_para.psth
                            [sxr_ave,syr_ave]=SPIKY_f_average_pi(sx(mc,selection),sy(mc,selection),para.dts);   % The values of X should be distinct.
                        else
                            sxr_ave=sx{mc,1};
                            syr_ave=zeros(1,length(sxr_ave));
                            for tc2=selection
                                syr_ave=syr_ave+sy{mc,tc2};
                            end
                            syr_ave=syr_ave/length(selection);
                        end
                        plot(sxr_ave,syr_ave,col,'LineWidth',2)
                    end
                    
                    if mod(profile_plots,8)>3
                        for sc=1:num_select_stimuli
                            stim=select_stimuli(sc);
                            if ~isempty(stimuli_pos(stim))
                                selection=find(ismember(select_trials,stimuli_pos{stim})); col=colors(stim_col(stim));
                                if measure<m_para.psth
                                    [sxr_ave,syr_ave]=SPIKY_f_average_pi(sx(mc,selection),sy(mc,selection),para.dts);   % The values of X should be distinct.
                                else
                                    sxr_ave=sx{mc,1};
                                    syr_ave=zeros(1,length(sxr_ave));
                                    for tc2=selection
                                        syr_ave=syr_ave+sy{mc,tc2};
                                    end
                                    syr_ave=syr_ave/length(selection);
                                end
                                plot(sxr_ave,syr_ave,col,'LineWidth',2)
                            end
                        end
                    end
                end
            end
        end

%         if mod(plotting,8)>3 && measure<m_para.psth
%             subplotc=subplotc+1;
%             subplot(num_plots,1,subplotc)                                      % Dissimilarity matrix
%             mat=SPIKY_results.(measure_var).matrix;
%             imagesc(mat)
%             axis square
%             if size(mat,1)<10
%                 set(gca,'XTick',1:size(mat,1),'YTick',1:size(mat,1))
%             end
%             title([measure_name,'   ---   Dissimilarity matrix'],'FontWeight','bold','FontSize',16)
%         end
    end
end

if printing==1
    set(gcf,'PaperOrientation','Landscape'); set(gcf,'PaperType', 'A4');
    set(gcf,'PaperUnits','Normalized','PaperPosition', [0 0 1.0 1.0]);
    psname=['SPIKY_loop_trigger','.ps'];
    print(gcf,'-dpsc',psname);
end
