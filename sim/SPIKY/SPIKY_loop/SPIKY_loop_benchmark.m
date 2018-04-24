% SPIKY_loop --- Copyright Thomas Kreuz, Nebojsa Bozanic; March 2014
%
% 'SPIKY_loop' is complementary to the graphical user interface 'SPIKY'.
% Both programs can be used to calculate time-resolved spike train distances (ISI and SPIKE) between two (or more) spike trains.
% However, whereas SPIKY was mainly designed to facilitate the detailed analysis of one dataset,
% 'SPIKY_loop' is meant to be used in order to compare the SPIKY_results for many different datasets (e.g. in some kind of loop).
%
% 'SPIKY_loop' is the main program where the variables are set and from where the funtion 'SPIKY_loop_f_distances' is called.
% This function uses a minimum number of input and output variables (described below).
%
% More information on SPIKY can be found here:
%
% ##### Bozanic N, Kreuz T: SPIKY: A graphical user interface for monitoring spike train synchrony. http://arxiv.org/pdf/1410.6910v1.pdf
%
% More information on the program and the spike train distances can also be found under
% "http://www.fi.isc.cnr.it/users/thomas.kreuz/Source-Code/SPIKY.html" and/or in
%
% Kreuz T, Mulansky M, Bozanic N: SPIKY: A graphical user interface for monitoring spike train synchrony. J Neurophysiol 113, 3432 (2015)
% Kreuz T, Chicharro D, Houghton C, Andrzejak RG, Mormann F: Monitoring spike train synchrony. J Neurophysiol 109, 1457 (2013)
% Kreuz T: SPIKE-distance. Scholarpedia 7(12):30652 (2012).
% Kreuz T: Measures of spike train synchrony. Scholarpedia, 6(10):11934 (2011).
% Kreuz T, Chicharro D, Greschner M, Andrzejak RG: Time-resolved and time-scale adaptive measures of spike train synchrony. J Neurosci Methods 195, 92 (2011).
% Kreuz T, Chicharro D, Andrzejak RG, Haas JS, Abarbanel HDI: Measuring multiple spike train synchrony. J Neurosci Methods 183, 287 (2009).
% Kreuz T, Haas JS, Morelli A, Abarbanel HDI, Politi A: Measuring spike train synchrony. J Neurosci Methods 165, 151 (2007).
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
% Output (Structure 'SPIKY_loop_results'):
% =============================
%
%    SPIKY_loop_results.<Measure>.name:     Name of selected measures (helps to identify the order within all other variables)
%    SPIKY_loop_results.<Measure>.overall:  Level of (dis)similarity over all spike trains and the whole interval
%                                           just one value, obtained by averaging over both spike trains and time
%    SPIKY_loop_results.<Measure>.matrix:   Pairwise (dis)similarity matrices, obtained by averaging over time
%    SPIKY_loop_results.<Measure>.time:     Time-values of overall (dis)similarity profile
%    SPIKY_loop_results.<Measure>.profile:  Overall (dis)similarity profile obtained by averaging over spike train pairs
%
% Note: For the ISI-distance the function 'SPIKY_f_pico' can be used to obtain the average value as well as
% x- and y-vectors for plotting (see example below):
%
% [overall_dissimilarity,plot_x_values,plot_y_values] = SPIKY_f_pico(SPIKY_loop_results.<Measure>.time,SPIKY_loop_results.<Measure>.profile,para.tmin);
%

clear all
tic
close all
clc

para=struct('tmin',[],'tmax',[],'dts',[],'select_measures',[]);            % Initialization of parameter structure


%m_para.all_measures_string={'PSTH';'SPIKE_Synchro';'ISI';'SPIKE';'SPIKE_realtime';'SPIKE_forward';'SPIKE_N';'SPIKE_E';'SPIKE_NE';'SPIKE_discrete'};  % order of select_measures

%para.select_measures      =[0 1 1 1 0 0   1 1 1 1];  % Select measures (0-calculate,1-do not calculate)
%para.select_measures      =[0 0 1 1 0 0   0 0 0 0];  % Select measures (0-calculate,1-do not calculate)


m_para.all_measures_string={'PSTH';'SPIKE_Synchro';'ISI';'SPIKE';'SPIKE_realtime';'SPIKE_forward';'SPIKE_N';'SPIKE_E';'SPIKE_NE';'SPIKE_disc';'SPIKE_disc_N';'SPIKE_disc_E';'SPIKE_disc_NE'};  % order of select_measures
para.select_measures      =[0 1 1 1 0 0   1 1 1   1 1 1 1];  % Select measures (0-calculate,1-do not calculate)

m_para.all_measures_string={'ISI';'SPIKE';'SPIKE_realtime';'SPIKE_forward';'SPIKE_synchro';'SPIKE_order';'PSTH';};  % order of select_measures
para.select_measures      =[1 1 0 0 1 0 0];  % Select measures (0-calculate,1-do not calculate)

measures=find(para.select_measures);


m_para.isi=1;
m_para.spike=[2 3 4];
m_para.spike_sync=[5 6];
m_para.psth=7;

plotting=0;           % +1:spikes,+2:dissimilarity profile,+4:dissimilarity matrix
plot_profiles=1;      % 1:all,2:Groups only,3:all+groups


load bm_spikes.mat

para.tmin=0; para.tmax=100; para.dts=1e-12;
% ################################################### Example spike trains

bc_vect=1:10000;
%bc_vect=16;
%bc_vect=106;
%bc_vect=2468;
%bc_vect=1:106;


bm_results=zeros(length(bc_vect),length(measures));
for bc=bc_vect
    para.bc=bc;
    if mod(bc,100)==0
        disp(num2str(bc))
    end
    
    spikes=bm_spikes{bc};
    
    %spikes{2}(end)
    
    d_para=para;
    SPIKY_check_spikes
    if ret==1
        return
    end
    para=d_para;
    
    %spikes{2}(end)

    % ################################################### Actual call of function !!!!!
    
    %spikes
    SPIKY_loop_results = SPIKY_loop_f_distances(spikes,para); %#ok<NOPTS>
    %SPIKY_loop_f_distances_all
    % ################################################### Example plotting (just meant to be a demonstration)
    
    num_plots=(mod(plotting,2)>0)+(mod(plotting,4)>1)+(mod(plotting,8)>3);
    if num_plots>0
        for mc=1:length(measures)
            measure=measures(mc);
            measure_var=m_para.all_measures_string{measure};
            measure_name=regexprep(measure_var,'_','-');
            
            figure(mc); clf
            set(gcf,'Name',measure_name)
            set(gcf,'Units','normalized','Position',[0.0525 0.0342 0.8854 0.8867])
            subplotc=0;
            
            if mod(plotting,2)>0
                subplotc=subplotc+1;
                subplot(num_plots,1,subplotc)                                      % Spikes
                for trc=1:length(spikes)
                    for spc=1:length(spikes{trc})
                        line(spikes{trc}(spc)*ones(1,2),length(spikes)-[trc-1 trc])
                    end
                end
                xlim([para.tmin para.tmax])
                ylim([0 length(spikes)])
                if num_trains<10
                    set(gca,'YTick',-0.5+(1:num_trains),'YTickLabel',fliplr(1:num_trains))
                else
                    set(gca,'YTick',[])
                end
                title ('Spike trains','FontWeight','bold','FontSize',14)
            end
            
            if mod(plotting,4)>1
                subplotc=subplotc+1;
                subplot(num_plots,1,subplotc)                                      % Dissimilarity profile
                if ismember(measure,m_para.isi)                                              % piecewise constant profiles (ISI) have first to be transformed
                    isi_x=SPIKY_loop_results.(measure_var).time;
                    isi_y=SPIKY_loop_results.(measure_var).profile;
                    plot_y_values=zeros(size(isi_y,1),length(isi_x)*2);
                    for pc=1:size(isi_y,1)
                        [overall_dissimilarity,plot_x_values,plot_y_values(pc,:)] = SPIKY_f_pico(isi_x,isi_y(pc,:),para.tmin);
                    end
                    hold on
                    if plot_profiles>1
                        plot(plot_x_values,plot_y_values(2:end,:))
                    end
                    if mod(plot_profiles,2)>0
                        plot(plot_x_values,plot_y_values(1,:),'k','LineWidth',1.5)
                    end
                elseif ismember(measure,m_para.spike)                               % piecewise linear profiles (SPIKE) can be plotted right away
                    x=SPIKY_loop_results.(measure_var).time;
                    y=SPIKY_loop_results.(measure_var).profile;
                    hold on
                    if plot_profiles>1
                        plot(x,y(2:end,:))
                    end
                    if mod(plot_profiles,2)>0
                        plot(x,y(1,:),'k','LineWidth',1.5)
                    end
                elseif ismember(measure,m_para.spike_sync)                                             % Group profiles for SPIKE-Sync need extra treatment since support is different for each group
                    x=SPIKY_loop_results.(measure_var).time;
                    y=SPIKY_loop_results.(measure_var).profile;
                    hold on
                    num_profs=mod(size(y,1),2)+(size(y,1)-mod(size(y,1),2))/2;
                    if plot_profiles>1
                        cols='krbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmc';
                        for pc=2:num_profs
                            pfindy=find(y(pc+(size(y,1)-mod(size(y,1),2))/2,:));
                            if ~isempty(pfindy)
                                plot(x(pfindy),y(pc,pfindy),cols(pc),'LineWidth',1);
                            end
                        end
                    end
                    if mod(plot_profiles,2)>0
                        plot(x,y(1,:),'k','LineWidth',1.5)
                    end
                elseif measure==m_para.psth                                              % PSTH
                    x=SPIKY_loop_results.(measure_var).time;
                    y=SPIKY_loop_results.(measure_var).profile;
                    hold on
                    if plot_profiles>1
                        plot(x,y(2:end,:))
                    end
                    if mod(plot_profiles,2)>0
                        plot(x,y(1,:),'k','LineWidth',1.5)
                    end
                end
                xlim([para.tmin para.tmax])
                title ([measure_name,'   ---   Dissimilarity profile'],'FontWeight','bold','FontSize',14)
            end
            
            if mod(plotting,8)>3 && measure<m_para.psth
                subplotc=subplotc+1;
                subplot(num_plots,1,subplotc)                                      % Dissimilarity matrix
                mat=SPIKY_loop_results.(measure_var).matrix;
                imagesc(mat)
                axis square
                if size(mat,1)<10
                    set(gca,'XTick',1:size(mat,1),'YTick',1:size(mat,1))
                end
                title ([measure_name,'   ---   Dissimilarity matrix'],'FontWeight','bold','FontSize',14)
                colorbar
            end
        end
    end
    %[SPIKY_loop_results.ISI.overall SPIKY_loop_results.SPIKE.overall]
    bm_results(bc,1:length(measures))=[SPIKY_loop_results.ISI.overall SPIKY_loop_results.SPIKE.overall SPIKY_loop_results.SPIKE_synchro.overall];
end
save SPIKY_benchmark bm_results
toc

