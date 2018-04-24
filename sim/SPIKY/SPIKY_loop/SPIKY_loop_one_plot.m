% SPIKY_loop_one_plot --- Copyright Thomas Kreuz; May 2015
%
% 'SPIKY_loop' is complementary to the graphical user interface 'SPIKY'.
% Both programs can be used to calculate time-resolved spike train distances (ISI and SPIKE) between two (or more) spike trains.
% However, whereas SPIKY was mainly designed to facilitate the detailed analysis of one dataset,
% 'SPIKY_loop' is meant to be used in order to compare the SPIKY_results for many different datasets (e.g. in some kind of loop).
%
% 'SPIKY_loop' is the main program where the variables are set and from where the funtion 'SPIKY_loop_f_distances' is called.
% This function uses a minimum number of input and output variables (described below).
%
% 'SPIKY_loop_one_plot' presents a simple example in which results for
% several datasets are compared in one single plot. Each dataset is shown
% in a different subplot.
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
close all
clc
alphabet='ABCDEFGH';
para=struct('tmin',[],'tmax',[],'dts',[],'select_measures',[]);            % Initialization of parameter structure


datasets=[5 6 7 8];            % 1-Frequency mismatch,2-Spiking events,3-Splay state vs. identical,4:Test


m_para.all_measures_string={'ISI';'SPIKE';'SPIKE_realtime';'SPIKE_forward';'SPIKE_synchro';'SPIKE_order';'PSTH';};  % order of select_measures
m_para.all_measures_str={'I';'S';'S_r';'S_f';'C';'D';'PSTH'}; % 1:ISI,2:SPIKE,3:realtimeSPIKE,4:forwardSPIKE,5:SPIKE-Sync,6:SPIKE-Order,7:PSTH

para.select_measures      =[1 1 0 0 0 0 0];  % Select measures (0-calculate,1-do not calculate)

m_para.isi=1;
m_para.spike=[2 3 4];
m_para.spike_sync=[5 6];
m_para.psth=7;


plotting=3;           % +1:spikes,+2:dissimilarity profile,+4:dissimilarity matrix
printing=1;
fs=14;

% ################################################### Example spike trains

num_datasets=length(datasets);
for dc=1:num_datasets
    dataset=datasets(dc);
    
    if dataset==1                    % Frequency mismatch (from Fig. 2a of 2013 paper)
        para.tmin=0; para.tmax=1300; para.dts=1;
        num_trains=2;
        spikes=cell(1,num_trains);
        spikes{1}=(100:100:1200);
        spikes{2}=(100:110:1200);
        spikes=cell(1,2);                                                          % ##############
        spikes{1}=[0 2 5 8];
        spikes{2}=[0 1 5 9];
        para.tmin=0; para.tmax=10;
    elseif dataset==2              % Spiking events (from Fig. 2b of 2013 paper)
        para.tmin=0; para.tmax=4000; para.dts=1;
        num_trains=50; num_spikes=40;
        noise=[1:-1/(num_spikes/4-1):0 0];
        num_noises=length(noise);
        num_events=5;
        spikes=cell(1,num_trains);
        for trc=1:num_trains
            spikes{trc}=sort(rand(1,num_spikes/2),2)*para.tmax/2;
            for nc=1:num_events
                spikes{trc}=[spikes{trc} nc*para.tmax/2/num_events+50*noise(ceil(num_noises-(nc-1)*num_noises/num_events)).*randn];
            end
            spikes{trc}=[spikes{trc} 100*(num_spikes/2-1)+200*(1:num_spikes/4+1)+50*noise.*randn(1,num_spikes/4+1)];
        end
    elseif dataset==3
        para.tmin=0; para.tmax=4000; para.dts=1;
        num_trains=50; num_spikes=40;
        spikes=cell(1,num_trains);
        for trc=1:num_trains
            spikes{trc}=sort(rand(1,num_spikes),2)*para.tmax;
        end
    elseif dataset==4
        para.tmin=0; para.tmax=1000; para.dts=1; num_trains=3;
        spikes=cell(1,num_trains);
        spikes{1}=[100 300 400 405 410 505 700 800 805 810 815 900];
        spikes{2}=[100 200 205 210 295 350 400 510 600 605 700 910];
        spikes{3}=[100 180 198 295 412 420 510 640 695 795 820 920];
        para.instants=[200 400];
        para.selective_averages={[0 250]; [0 1000]};
        para.triggered_averages={[300 700];[200 500 800]};
    elseif dataset==5
        load SPIKY_reli
        para.num_trains=10; num_spikes=10; dura=100;
        para.tmin=0; para.tmax=(num_spikes+1)*dura; para.dts=0.1;
    elseif dataset==6
        load SPIKY_burs
        para.num_trains=10; num_spikes=10; dura=100;
        para.tmin=0; para.tmax=(num_spikes+1)*dura; para.dts=0.1;
    elseif dataset==7
        load SPIKY_rand
        para.num_trains=10; num_spikes=10; dura=100;
        para.tmin=0; para.tmax=(num_spikes+1)*dura; para.dts=0.1;
    elseif dataset==8
        load SPIKY_even
        para.tmin=0;
        para.tmax=4000;
        para.dts=1;
    end
    if ~exist('num_trains','var')
        num_trains=length(spikes);
    end
    
    d_para=para;
    SPIKY_check_spikes
    if ret==1
        return
    end
    para=d_para;
    
    % ################################################### Actual call of function !!!!!
    
    SPIKY_loop_results = SPIKY_loop_f_distances(spikes,para) %#ok<NOPTS>
    
    % ################################################### Example plotting (just meant to be a demonstration)
    
    num_plots=(mod(plotting,2)>0)+(mod(plotting,4)>1)+(mod(plotting,8)>3);
    if num_plots>0
        measures=find(para.select_measures);
        for mc=1:length(measures)
            measure=measures(mc);
            measure_var=m_para.all_measures_string{measure};
            measure_name=regexprep(measure_var,'_','-');
            
            figure(mc);
            set(gcf,'Name',measure_name)
            set(gcf,'Units','normalized','Position',[0.0525 0.0342 0.8854 0.8867])
            subplot(num_datasets,1,dc)
            ylim([0 2.2])
            
            if mod(plotting,2)>0                                      % Spikes
                for trc=1:length(spikes)
                    for spc=1:length(spikes{trc})
                        line(spikes{trc}(spc)*ones(1,2),2.15-[trc-0.95 trc-0.05]/length(spikes),'Color','k')
                    end
                end
                xlim([para.tmin para.tmax])
                %ylim([0 length(spikes)])
                if num_trains<10
                    set(gca,'YTick',-0.5+(1:num_trains),'YTickLabel',fliplr(1:num_trains))
                else
                    set(gca,'YTick',[])
                end
                %title ('Spike trains','FontWeight','bold','FontSize',14)
            end
            
            if mod(plotting,4)>1
                if ismember(measure,m_para.isi)                                % piecewise constant profiles have first to be transformed
                    isi_x=SPIKY_loop_results.(measure_var).time;
                    isi_y=SPIKY_loop_results.(measure_var).profile;
                    plot_y_values=zeros(size(isi_y,1),length(isi_x)*2);
                    for pc=1:size(isi_y,1)
                        [overall_dissimilarity,plot_x_values,plot_y_values(pc,:)] = SPIKY_f_pico(isi_x,isi_y(pc,:),para.tmin);
                    end
                    hold on
                    plot(plot_x_values,plot_y_values)
                    plot(plot_x_values,plot_y_values(1,:),'k','LineWidth',1.5)
                elseif ismember(measure,m_para.spike)                         % piecewise linear profiles can be plotted right away
                    x=SPIKY_loop_results.(measure_var).time;
                    y=SPIKY_loop_results.(measure_var).profile;
                    hold on
                    plot(x,y)
                    plot(x,y(1,:),'k','LineWidth',1.5)
                elseif ismember(measure,m_para.spike_sync)                         % piecewise linear profiles can be plotted right away
                    x=SPIKY_loop_results.(measure_var).time;
                    y=SPIKY_loop_results.(measure_var).profile;
                    hold on
                    num_profs=mod(size(y,1),2)+(size(y,1)-mod(size(y,1),2))/2;
                    cols='krbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmcrbgmc';
                    for pc=2:num_profs
                        pfindy=find(y(pc+(size(y,1)-mod(size(y,1),2))/2,:));
                        if ~isempty(pfindy)
                            plot(x(pfindy),y(pc,pfindy),cols(pc),'LineWidth',1);
                        end
                    end
                    plot(x,y(1,:),'k','LineWidth',1.5)
                elseif measure==measure==m_para.psth                            % PSTH
                    x=SPIKY_loop_results.(measure_var).time;
                    y=SPIKY_loop_results.(measure_var).profile;
                    hold on
                    plot(x,y)
                    plot(x,y(1,:),'k','LineWidth',1.5)
                end
                %xlim([para.tmin para.tmax])
                
                
                %title ([measure_name,'   ---   Dissimilarity profile'],'FontWeight','bold','FontSize',14)
            end
            xl=xlim; yl=ylim;
            line(xl,1.1*ones(1,2),'Color','k','LineWidth',2,'LineStyle','-')
            line(xl,0.05*ones(1,2),'Color','k','LineWidth',1,'LineStyle',':')
            line(xl,1.05*ones(1,2),'Color','k','LineWidth',1,'LineStyle',':')
            line(xl,1.15*ones(1,2),'Color','k','LineWidth',1,'LineStyle',':')
            line(xl,2.15*ones(1,2),'Color','k','LineWidth',1,'LineStyle',':')
            set(gca,'FontSize',fs-2,'YTick',[0.05 1.05],'YTickLabel',[0 1])
            text(xl(1)-0.13*(xl(2)-xl(1)),yl(1)+(yl(2)-yl(1)),alphabet(dc),'Color','k','FontSize',fs+5,'FontWeight','bold');
            text(xl(1)-0.11*(xl(2)-xl(1)),yl(1)+0.8*(yl(2)-yl(1)),'Spike','Color','k','FontSize',fs,'FontWeight','bold');
            text(xl(1)-0.11*(xl(2)-xl(1)),yl(1)+0.7*(yl(2)-yl(1)),'trains','Color','k','FontSize',fs,'FontWeight','bold');
            text(xl(1)-0.105*(xl(2)-xl(1)),yl(1)+0.3*(yl(2)-yl(1)),m_para.all_measures_str{measure},'Color','k','FontSize',fs,'FontWeight','bold');
            if dc==num_datasets
                xlabel('Time','Color','k','FontSize',fs,'FontWeight','bold')
            end
            box on
            
            if mod(plotting,8)>3 && measure<measure==m_para.psth
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
end

if printing>0
    set(gcf,'PaperOrientation','Portrait'); set(gcf,'PaperType','A4');
    set(gcf,'PaperUnits','Normalized','PaperPosition',[0 0.05 1.0 0.9]);
    psname=['SPIKE_Sync_',num2str(num_datasets),'.ps'];
    print(gcf,'-dpsc',psname)
end


