% For very large datasets this function provides a way to reduce the number of spikes of your datasets even before the plotting
% of the spikes (which can take very long for a huge number of spikes).You can select/eliminate spike trains and change their
% order manually via the buttons at the top but you can also sort the spike trains according to some predefined criteria
% (such as number of spikes). Finally, you can restrict the time window.

function SPIKY_select_spikes(hObject, eventdata, d_para, handles)

f_para=getappdata(handles.figure1,'figure_parameters');

spikes=eventdata.spikes;
all_num_trains=length(spikes);
num_trains=all_num_trains;
select_trains=(1:num_trains)';
all_num_spikes=cellfun('length',spikes);
wmin=d_para.tmin;
wmax=d_para.tmax;
num_spikes=all_num_spikes(select_trains)';

SSP.fig=figure('units','normalized','menubar','none','position',[0.05 0.07 0.4 0.86],'Name','Large dataset: Reduction of number of spikes',...
    'NumberTitle','off','Color',[0.9294 0.9176 0.851],'KeyPressFcn',{@SSP_keyboard},'DeleteFcn',{@SPIKY_select_spikes_Close},...
    'WindowStyle','modal');
% SSP.fig=figure('units','normalized','menubar','none','position',[0.05 0.07 0.4 0.86],'Name','Large dataset: Reduction of number of spikes',...
%     'NumberTitle','off','Color',[0.9294 0.9176 0.851],'KeyPressFcn',{@SSP_keyboard},'DeleteFcn',{@SPIKY_select_spikes_Close});

SSP.lb=uicontrol('style','listbox','units','normalized','position',[0.1 0.12 0.4 0.84],'FontSize',10,...
    'BackgroundColor','w','string',[num2str(select_trains),repmat(blanks(25),length(select_trains),1),num2str(num_spikes)],...
    'Min',1,'Max',num_trains,'HorizontalAlignment','center','Value',1,'KeyPressFcn',{@SSP_keyboard});

SSP.top_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.92 0.2 0.035],...
    'string','Top','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spikes_ListBox_callback});
SSP.up_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.865 0.2 0.035],...
    'string','Up','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spikes_ListBox_callback});
SSP.down_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.82 0.2 0.035],...
    'string','Down','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spikes_ListBox_callback});
SSP.bottom_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.765 0.2 0.035],...
    'string','Bottom','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spikes_ListBox_callback});
SSP.delete_pb=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.7 0.2 0.035],...
    'string','Delete','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spikes_ListBox_callback});

SSP.sn_panel=uipanel('units','normalized','position',[0.52 0.27 0.46 0.37],'title','Number of spikes in time window:','FontSize',14,'parent',SSP.fig);
uicontrol('style','text','units','normalized','position',[0.565 0.57 0.1 0.03],'HorizontalAlignment','left',...
    'string','All:','FontSize',13,'FontWeight','bold','FontUnits','normalized');
uicontrol('style','text','units','normalized','position',[0.55 0.53 0.07 0.03],'HorizontalAlignment','left',...
    'string','Start:','FontSize',13,'FontUnits','normalized');
SSP.tmin_edit=uicontrol('style','edit','units','normalized','position',[0.63 0.535 0.11 0.025],'BackgroundColor','w',...
    'string',num2str(d_para.tmin),'FontSize',13,'FontUnits','normalized','Enable','off');
uicontrol('style','text','units','normalized','position',[0.755 0.53 0.07 0.03],'HorizontalAlignment','left',...
    'string','End:','FontSize',13,'FontUnits','normalized');
SSP.tmax_edit=uicontrol('style','edit','units','normalized','position',[0.83 0.535 0.11 0.025],'BackgroundColor','w',...
    'string',num2str(d_para.tmax),'FontSize',13,'FontUnits','normalized','Enable','off');
uicontrol('style','text','units','normalized','position',[0.565 0.495 0.1 0.03],'HorizontalAlignment','left',...
    'string','Window:','FontSize',13,'FontWeight','bold','FontUnits','normalized');
uicontrol('style','text','units','normalized','position',[0.55 0.455 0.07 0.03],'HorizontalAlignment','left',...
    'string','Start:','FontSize',13,'FontUnits','normalized');
SSP.wmin_edit=uicontrol('style','edit','units','normalized','position',[0.63 0.46 0.11 0.025],'BackgroundColor','w',...
    'string',num2str(wmin),'FontSize',13,'FontUnits','normalized');
uicontrol('style','text','units','normalized','position',[0.755 0.455 0.07 0.03],'HorizontalAlignment','left',...
    'string','End:','FontSize',13,'FontUnits','normalized');
SSP.wmax_edit=uicontrol('style','edit','units','normalized','position',[0.83 0.46 0.11 0.025],'BackgroundColor','w',...
    'string',num2str(wmax),'FontSize',13,'FontUnits','normalized');
SSP.update_spike_number_pb=uicontrol('style','pushbutton','units','normalized','position',[0.66 0.41 0.18 0.03],...
    'string','Update','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spikes_Reset});
SSP.decreasing_spike_number_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.34 0.18 0.03],...
    'string','Decreasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spikes_Reset});
SSP.increasing_spike_number_pb=uicontrol('style','pushbutton','units','normalized','position',[0.77 0.34 0.18 0.03],...
    'string','Increasing','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spikes_Reset});
SSP.sort_spike_trains_pb=uicontrol('style','pushbutton','units','normalized','position',[0.66 0.29 0.18 0.03],...
    'string','Original order','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SPIKY_select_spikes_Reset});

SSP.delete_empty_pb=uicontrol('style','pushbutton','units','normalized','position',[0.6 0.18 0.3 0.04],...
    'string','Delete empty trains','FontSize',14,'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_select_spikes_Reset});
SSP.reset_pb=uicontrol('style','pushbutton','units','normalized','position',[0.6 0.12 0.3 0.04],...
    'string','Reset','FontSize',14,'BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_select_spikes_Reset});

SSP.cancel_pb=uicontrol('style','pushbutton','units','normalized','position',[0.15 0.04 0.3 0.04],...
    'string','Cancel','FontSize',14,'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_select_spikes_Close});
SSP.ok_pb=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.04 0.3 0.04],...
    'string','OK','FontSize',14,'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SPIKY_select_spikes_Close},'UserData',0);

SPIKY_plot_histo

uicontrol(SSP.lb)
uiwait(gcf);

    function SPIKY_select_spikes_ListBox_callback(varargin)
        figure(f_para.num_fig);
        lb_marked=get(SSP.lb,'Value');
        lb_str=get(SSP.lb,'String');
        lb_num_strings=size(lb_str,1);

        if gcbo==SSP.top_pb %|| (nargin==1 && varargin{1}==SSP.top_pb)
            dummy=lb_str(lb_marked,:);
            dummy2=lb_str(setdiff(1:lb_num_strings,lb_marked),:);
            lb_str(1:length(lb_marked),:)=dummy;
            lb_str(length(lb_marked)+1:lb_num_strings,:)=dummy2;
            set(SSP.lb,'Value',1:length(lb_marked))
        elseif gcbo==SSP.up_pb %|| (nargin==1 && varargin{1}==SSP.up_pb)
            for mc=1:length(lb_marked)
                if lb_marked(mc)>mc
                    dummy=lb_str(lb_marked(mc)-1,:);
                    lb_str(lb_marked(mc)-1,:)=lb_str(lb_marked(mc),:);
                    lb_str(lb_marked(mc),:)=dummy;
                    lb_marked(mc)=lb_marked(mc)-1;
                end
            end
            set(SSP.lb,'Value',lb_marked)
        elseif gcbo==SSP.down_pb %|| (nargin==1 && varargin{1}==SSP.down_pb)
            for mc=length(lb_marked):-1:1
                if lb_marked(mc)<lb_num_strings-(length(lb_marked)-mc)
                    dummy=lb_str(lb_marked(mc)+1,:);
                    lb_str(lb_marked(mc)+1,:)=lb_str(lb_marked(mc),:);
                    lb_str(lb_marked(mc),:)=dummy;
                    lb_marked(mc)=lb_marked(mc)+1;
                end
            end
            set(SSP.lb,'Value',lb_marked)
        elseif gcbo==SSP.bottom_pb %|| (nargin==1 && varargin{1}==SSP.bottom_pb)
            dummy=lb_str(lb_marked,:);
            dummy2=lb_str(setdiff(1:lb_num_strings,lb_marked),:);
            lb_str(1:lb_num_strings-length(lb_marked),:)=dummy2;
            lb_str(lb_num_strings-length(lb_marked)+1:lb_num_strings,:)=dummy;
            set(SSP.lb,'Value',lb_num_strings-length(lb_marked)+1:lb_num_strings)
        elseif gcbo==SSP.delete_pb || (nargin==1 && varargin{1}==SSP.delete_pb)
            for mc=length(lb_marked):-1:1
                lb_str(lb_marked(mc):lb_num_strings-1,:)=lb_str(lb_marked(mc)+1:lb_num_strings,:);
                lb_num_strings=lb_num_strings-1;
                lb_str=lb_str(1:lb_num_strings,:);
            end
            set(SSP.lb,'Value',1)
        end
        set(SSP.lb,'String',lb_str)
        select_trains=zeros(size(lb_str,1),1);
        for sc=1:size(lb_str,1)
            select_trains(sc)=str2num(lb_str(sc,1:strfind(lb_str(sc,:),blanks(10))));
        end
        SPIKY_plot_histo
    end

    function SPIKY_select_spikes_Reset(varargin)
        if gcbo==SSP.reset_pb
            select_trains=(1:all_num_trains)';
            wmin=d_para.tmin;
            wmax=d_para.tmax;
            set(SSP.wmin_edit,'string',num2str(wmin))
            set(SSP.wmax_edit,'string',num2str(wmax))
        elseif gcbo==SSP.delete_empty_pb
            if wmin>d_para.tmin || wmax<d_para.tmax
                num_spikes=cell2mat(cellfun(@(x) length(x(x>=wmin & x<=wmax)),spikes(select_trains),'UniformOutput',false))';
            else
                num_spikes=all_num_spikes(select_trains)';
            end
            select_trains=select_trains(num_spikes>0);
        elseif gcbo==SSP.sort_spike_trains_pb
            select_trains=sort(select_trains);
        else
            if gcbo==SSP.update_spike_number_pb || gcbo==SSP.increasing_spike_number_pb || gcbo==SSP.decreasing_spike_number_pb
                wmin_str_in=get(SSP.wmin_edit,'String');
                wmin_in=str2num(regexprep(wmin_str_in,f_para.regexp_str_scalar_float,''));
                if ~isempty(wmin_in)
                    wmin_str_out=num2str(wmin_in(1));
                else
                    wmin_str_out='';
                end
                wmax_str_in=get(SSP.wmax_edit,'String');
                wmax_in=str2num(regexprep(wmax_str_in,f_para.regexp_str_scalar_float,''));
                if ~isempty(wmax_in)
                    wmax_str_out=num2str(wmax_in(1));
                else
                    wmax_str_out='';
                end
                if ~strcmp(wmin_str_in,wmin_str_out) || ~strcmp(wmax_str_in,wmax_str_out)
                    if ~isempty(wmin_str_out)
                        set(SSP.wmin_edit,'String',wmin_str_out)
                    else
                        set(SSP.wmin_edit,'String',num2str(d_para.wmin))
                    end
                    if ~isempty(wmax_str_out)
                        set(SSP.wmax_edit,'String',wmax_str_out)
                    else
                        set(SSP.wmax_edit,'String',num2str(d_para.wmax))
                    end
                    set(0,'DefaultUIControlFontSize',16);
                    mbh=msgbox('The input has been corrected !','Warning','warn','modal');
                    htxt = findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.3 mb_pos(4)])
                    uiwait(mbh);
                    return
                else
                    wmin=str2num(get(SSP.wmin_edit,'String'));
                    wmax=str2num(get(SSP.wmax_edit,'String'));
                end
                if wmin>=wmax
                    set(0,'DefaultUIControlFontSize',16);
                    mbh=msgbox(sprintf('wmin must be smaller than wmax!'),'Warning','warn','modal');
                    htxt = findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                    uiwait(mbh);
                    return
                end
                if wmin<d_para.tmin
                    wmin=d_para.tmin;
                end
                if wmax>d_para.tmax
                    wmax=d_para.tmax;
                end
%                 if wmin<d_para.tmin || wmax>d_para.tmax   % &&&&&&&&
%                     set(0,'DefaultUIControlFontSize',16);
%                     mbh=msgbox(sprintf('wmin and tmax must lie within the boundaries of the spike trains!'),'Warning','warn','modal');
%                     htxt = findobj(mbh,'Type','text');
%                     set(htxt,'FontSize',12,'FontWeight','bold')
%                     mb_pos=get(mbh,'Position');
%                     set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
%                     uiwait(mbh);
%                     return
%                 end
                if gcbo==SSP.increasing_spike_number_pb || gcbo==SSP.decreasing_spike_number_pb
                    spike_number=cell2mat(cellfun(@(x) length(x(x>=wmin & x<=wmax)),spikes,'UniformOutput',false));
                    dummy=sort(select_trains);
                    if gcbo==SSP.increasing_spike_number_pb
                        [vals,indy]=sort(spike_number(dummy),'ascend');
                    elseif gcbo==SSP.decreasing_spike_number_pb
                        [vals,indy]=sort(spike_number(dummy),'descend');
                    end
                    select_trains=dummy(indy);
                end
            end
        end
%         if size(select_trains,1)<size(select_trains,2)
%             select_trains=select_trains';
%         end
%         num_spikes=all_num_spikes(select_trains)';
%         num2str(select_trains)
%         repmat(blanks(25),length(select_trains),1)
%         num2str(num_spikes)
%         [num2str(select_trains),repmat(blanks(25),length(select_trains),1),num2str(num_spikes)]
        if wmin>d_para.tmin || wmax<d_para.tmax
            num_spikes=cell2mat(cellfun(@(x) length(x(x>=wmin & x<=wmax)),spikes(select_trains),'UniformOutput',false))';
        else
            num_spikes=all_num_spikes(select_trains)';
        end
        set(SSP.lb,'string',[num2str(select_trains),repmat(blanks(25),length(select_trains),1),num2str(num_spikes)])
        set(SSP.lb,'Value',1)
        SPIKY_plot_histo
    end

    function SPIKY_plot_histo(varargin)
        
        if wmin>d_para.tmin || wmax<d_para.tmax
            num_spikes=cell2mat(cellfun(@(x) length(x(x>=wmin & x<=wmax)),spikes(select_trains),'UniformOutput',false));
        else
            num_spikes=all_num_spikes(select_trains);
        end
        num_trains=length(select_trains);
        max_num_spikes=max(num_spikes);
        num_total_win_spikes=sum(num_spikes);
        
        spike_density=zeros(num_trains,f_para.psth_num_bins);
        for trac=1:num_trains
            [histo_y,histo_x]=hist([spikes{select_trains(trac)}],f_para.psth_num_bins);
            spike_density(trac,1:f_para.psth_num_bins)=histo_y;
        end
        
        figure(f_para.num_fig);

        subplot('Position',[0.09 0.06 0.88 0.23])
        edges=d_para.tmin:(d_para.tmax-d_para.tmin)/f_para.psth_num_bins:d_para.tmax+(d_para.tmax-d_para.tmin)/10000;
        histo_y=histc([spikes{select_trains}],edges);
        %[histo_y,histo_x]=histc([spikes{select_trains}],edges);
        max_histo_y=max(histo_y);
        xt=(edges-d_para.tmin)/(d_para.tmax-d_para.tmin);
        bar(xt,histo_y/max_histo_y,'histc');  % ,'BaseValue',0
        xlim([-0.02 1.02])
        ylim([-0.02 1.02])
        if mod(length(xt),2)==0
            set(gca,'XTick',xt([1 length(xt)/2 end]),'XTickLabel',edges([1 length(xt)/2 end]))
        else
            set(gca,'XTick',xt([1 (length(xt)+1)/2 end]),'XTickLabel',edges([1 (length(xt)+1)/2 end]))
        end
        if mod(max_num_spikes,2)==0
            set(gca,'YTick',[0 0.5 1],'YTickLabel',[0 max_num_spikes/2 max_num_spikes])
        else
            set(gca,'YTick',[0 (max_num_spikes-1)/2 max_num_spikes]/max_num_spikes,'YTickLabel',[0 (max_num_spikes-1)/2 max_num_spikes])
        end
        %title('PSTH','Color','k','FontSize',14,'FontWeight','bold')
        ylabel('PSTH:  Number of spikes','Color','k','FontSize',13,'FontWeight','bold')
        xlabel('Time','Color','k','FontSize',12,'FontWeight','bold')
        wmin=str2num(get(SSP.wmin_edit,'String'));
        wmax=str2num(get(SSP.wmax_edit,'String'));
        line((wmin-d_para.tmin)/(d_para.tmax-d_para.tmin)*ones(1,2),(num_trains-1-(([0 num_trains])-1))/num_trains,'LineStyle',':','Color','r')
        line((wmax-d_para.tmin)/(d_para.tmax-d_para.tmin)*ones(1,2),(num_trains-1-(([0 num_trains])-1))/num_trains,'LineStyle',':','Color','r')
        set(gca,'FontSize',11)

        subplot('Position',[0.09 0.67 0.88 0.28])
        hh=bar((num_trains-1-((1:num_trains)-1)+0.5)/num_trains,num_spikes/max(num_spikes),'horizontal','on','BaseValue',0);
        xd=get(hh,'XData');
        xlim([-0.02 1.02])
        ylim([-0.02 1.02])
        set(gca,'XTickMode','auto','XTickLabelMode','auto')
        if mod(num_trains,2)==0
            set(gca,'YTick',xd([num_trains num_trains/2]),'YTickLabel',[num_trains num_trains/2])
        else
            set(gca,'YTick',xd([num_trains (num_trains-1)/2]),'YTickLabel',[num_trains (num_trains-1)/2])
        end
        if mod(max_num_spikes,2)==0
            set(gca,'XTick',[0 0.5 1],'XTickLabel',[0 max_num_spikes/2 max_num_spikes])
        else
            set(gca,'XTick',[0 (max_num_spikes-1)/2 max_num_spikes]/max_num_spikes,'XTickLabel',[0 (max_num_spikes-1)/2 max_num_spikes])
        end
        line(1*ones(1,2),(num_trains-1-(([0 num_trains])-1))/num_trains,'LineStyle',':','Color','k')
        xlabel('# Spikes','Color','k','FontSize',12,'FontWeight','bold')
        ylabel('Histogram:  Spike trains','Color','k','FontSize',13,'FontWeight','bold')
        title([num2str(num_total_win_spikes),' spikes in ',num2str(num_trains),' spike trains'],'Color','k','FontSize',15,'FontWeight','bold')
        set(gca,'FontSize',11)

        subplot('Position',[0.09 0.34 0.88 0.28])
        imagesc(spike_density)
        %colormap gray
        xlim(0.5+[-0.02 1.02]*f_para.psth_num_bins)
        ylim(0.5+[-0.02 1.02]*num_trains)
        if mod(length(xt),2)==0
            set(gca,'XTick',0.5+xt([1 length(xt)/2 end])*f_para.psth_num_bins,'XTickLabel',edges([1 length(xt)/2 end]))
        else
            set(gca,'XTick',0.5+xt([1 (length(xt)+1)/2 end])*f_para.psth_num_bins,'XTickLabel',edges([1 (length(xt)+1)/2 end]))
        end
        if mod(num_trains,2)==0
            set(gca,'YTick',num_trains+0.5-xd([num_trains/2 num_trains])*num_trains,'YTickLabel',[num_trains/2 num_trains])
        else
            set(gca,'YTick',num_trains+0.5-xd([(num_trains-1)/2 num_trains])*num_trains,'YTickLabel',[(num_trains-1)/2 num_trains])
        end
        xlabel('Time','Color','k','FontSize',12,'FontWeight','bold')
        ylabel('Spike density:  Spike trains','Color','k','FontSize',13,'FontWeight','bold')
        
        if num_trains<30 && f_para.psth_num_bins<30
            for trac=1:num_trains-1
                line(0.5+xt([1 end])*f_para.psth_num_bins,(0.5+trac)*ones(1,2),'Color','k','LineStyle',':')
            end
            for bc=1:f_para.psth_num_bins-1
                line((0.5+bc)*ones(1,2),[0.5 num_trains+0.5],'Color','k','LineStyle',':')
            end
        end
        line(0.5+(wmin-d_para.tmin)/(d_para.tmax-d_para.tmin)*f_para.psth_num_bins*ones(1,2),[0.5 num_trains+0.5],'LineStyle',':','Color','r')
        line(0.5+(wmax-d_para.tmin)/(d_para.tmax-d_para.tmin)*f_para.psth_num_bins*ones(1,2),[0.5 num_trains+0.5],'LineStyle',':','Color','r')
        set(gca,'FontSize',11)
    end

    function SSP_keyboard(varargin)
        if strcmp(varargin{2}.Key,'delete')
            SPIKY_select_spikes_ListBox_callback(SSP.delete_pb);
        end
    end

    function SPIKY_select_spikes_Close(varargin)
        if (gcbo==SSP.cancel_pb || gcbo==SSP.fig) && get(SSP.ok_pb,'UserData')==0
            ss_para.select_trains=[];
            ss_para.wmin=d_para.tmin;
            ss_para.wmax=d_para.tmax;
            setappdata(handles.figure1,'ss_para',ss_para);
        elseif gcbo==SSP.ok_pb
            lb_str=get(SSP.lb,'String');
            ss_para.select_trains=zeros(1,size(lb_str,1));
            for sc=1:size(lb_str,1)
                ss_para.select_trains(sc)=str2num(lb_str(sc,1:strfind(lb_str(sc,:),blanks(10))));
            end
            ss_para.wmin=wmin;
            ss_para.wmax=wmax;
            set(SSP.ok_pb,'UserData',1)
            setappdata(handles.figure1,'ss_para',ss_para);
        end
        figure(f_para.num_fig);
        clf
        subplot('Position',f_para.supo1)
        %plot([-1000 -1001],[-1000 -1001])
        xlim([0 1])
        ylim([0 1])
        set(gca,'XTick',[],'YTick',[])
        delete(gcbf)
    end
end
