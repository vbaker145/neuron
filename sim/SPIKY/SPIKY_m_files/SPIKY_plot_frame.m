% This plots the matrices and dendrograms for one frame of the movie.

if any(m_para.measure_bi_indy(m_para.select_disc_measures)) && (frc<=f_para.num_instants || frc>f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames)  % for SPIKE_synchro and SPIKE_order only selective averaging
    pf_mats=setdiff(1:h_para.num_all_matrices,unique([m_para.measure_bi_indy(m_para.select_disc_measures) m_para.measure_bi_indy(m_para.select_disc_measures)*(f_para.group_matrices+1)]));
    h_para.d_num_measures=h_para.num_measures-length(m_para.select_disc_measures);
    h_para.d_num_all_matrices=h_para.num_all_matrices-(length(m_para.select_disc_measures)+f_para.group_matrices);
    h_para.d_num_all_subplots=h_para.num_all_subplots-(length(m_para.select_disc_measures)+f_para.group_matrices)*(f_para.dendrograms+1);
else
    pf_mats=1:h_para.num_all_matrices;
    h_para.d_num_measures=h_para.num_measures;
    h_para.d_num_all_matrices=h_para.num_all_matrices;
    h_para.d_num_all_subplots=h_para.num_all_subplots;
end
h_para.d_supos=h_para.supos{h_para.d_num_all_subplots};
h_para.d_rows=h_para.rows{h_para.d_num_all_subplots};
h_para.d_cols=h_para.cols{h_para.d_num_all_subplots};


fig=figure(f_para.num_fig);
subplot('Position',f_para.supo1)
f_para.supo1=h_para.supo1;
set(gca,'Position',f_para.supo1)
profs_cmenu = uicontextmenu;
profs_sph=subplot('Position',f_para.supo1,'UIContextMenu',profs_cmenu);
sph_str='profs';
SPIKY_handle_subplot

if isfield(f_para,'dendro_order')
    f_para=rmfield(f_para,'dendro_order');
end
if isfield(f_para,'group_dendro_order')
    f_para=rmfield(f_para,'group_dendro_order');
end

yl=ylim;
if frc<=f_para.num_instants
    if f_para.num_selective_averages>0 && any(any(mov_handles.selave_line_lh))
        for selc=1:max(f_para.num_sel_ave)
            if mov_handles.selave_line_lh(1,selc)>0
                set(mov_handles.selave_line_lh(1,selc),'XData',[],'YData',[])
            end
            if mov_handles.selave_line_lh(2,selc)>0
                set(mov_handles.selave_line_lh(2,selc),'XData',[],'YData',[])
            end
        end
        mov_handles.selave_line_lh=zeros(2,max(f_para.num_sel_ave));
    end
    if f_para.num_triggered_averages>0 && any(mov_handles.trigave_plot_lh)
        if mov_handles.trigave_plot_lh(1)>0
            set(mov_handles.trigave_plot_lh(1),'XData',[],'YData',[])
        end
        if mov_handles.trigave_plot_lh(2)>0
            set(mov_handles.trigave_plot_lh(2),'XData',[],'YData',[])
        end
        mov_handles.trigave_plot_lh=zeros(1,2);
    end
    ms=f_para.instants(frc);
    mi=frc;
    if f_para.num_instants==f_para.num_frames
        count_str=['Frame ',num2str(frc),' (',num2str(f_para.num_instants),')'];
    else
        count_str=['Frame ',num2str(frc),' (',num2str(f_para.num_instants),')    ---    Total ',num2str(frc),...
            ' (',num2str(f_para.num_frames),')'];
    end
    if f_para.publication==0 && f_para.show_title==1
        if isfield(d_para,'interval_divisions') && ~isempty(d_para.interval_divisions) && isfield(d_para,'interval_names') && ...
                ~isempty(d_para.interval_names) && length(d_para.interval_names)==length(d_para.interval_divisions)+1
            inty=find(ms>d_para.interval_divisions,1,'last')+1;
            if isempty(inty)
                inty=1;
            end
            title_str=['   ---   ',d_para.interval_names{inty}];
        else
            title_str='';
        end
        prof_title_cmenu = uicontextmenu;
        prof_title_fh=title([f_para.title_string,'   ---   ',count_str,title_str],...
            'Visible',p_para.prof_title_vis,'Color',p_para.prof_title_col,'FontSize',p_para.prof_title_fs,...
            'FontWeight',p_para.prof_title_fw,'FontAngle',p_para.prof_title_fa,'UIContextMenu',prof_title_cmenu);
        fh_str='prof_title';
        SPIKY_handle_font
    end
    if ~any(mov_handles.mov_line_lh)
        mov_handles.mov_line_cmenu = uicontextmenu;
        if f_para.x_realtime_mode==0
            xval=f_para.instants(frc);
        else
            xval=d_para.tmax;
            mov_handles.mov_line_lh(3)=line(xval*ones(1,2),sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+[0.15 1.15]/1.3*f_para.subplot_size(2),...
                'Visible',p_para.mov_vis,'Color',p_para.mov_col,'LineStyle',':','LineWidth',p_para.mov_lw,'UIContextMenu',mov_handles.mov_line_cmenu);
        end
        mov_handles.mov_line_lh(1)=line(xval*ones(1,2),sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+[0 0.15]/1.3*f_para.subplot_size(2),...
            'Visible',p_para.mov_vis,'Color',p_para.mov_col,'LineStyle',p_para.mov_ls,'LineWidth',p_para.mov_lw,'UIContextMenu',mov_handles.mov_line_cmenu);
        mov_handles.mov_line_lh(2)=line(xval*ones(1,2),sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+[1.15 1.3]/1.3*f_para.subplot_size(2),...
            'Visible',p_para.mov_vis,'Color',p_para.mov_col,'LineStyle',p_para.mov_ls,'LineWidth',p_para.mov_lw,'UIContextMenu',mov_handles.mov_line_cmenu);
        lh_str='mov_handles.mov_line';
        SPIKY_handle_line
    elseif f_para.x_realtime_mode==0
        set(mov_handles.mov_line_lh(1),'XData',f_para.instants(frc)*ones(1,2))
        set(mov_handles.mov_line_lh(2),'XData',f_para.instants(frc)*ones(1,2))
        %set(mov_handles.mov_line_lh(3),'XData',f_para.instants(frc)*ones(1,2))
    end
    if f_para.x_realtime_mode>0
        pspikes=get(gca,'UserData');
        for trac=1:f_para.num_trains
            for sc=1:f_para.num_pspikes(trac)
                if pspikes{trac}(sc)<=f_para.instants(frc)
                    set(mov_handles.spike_lh{trac}(sc),'Visible','on','XData',(pspikes{trac}(sc)+d_para.tmax-f_para.instants(frc))*ones(1,2))
                else
                    set(mov_handles.spike_lh{trac}(sc),'Visible','off')
                end
            end
        end
        if isfield(mov_handles,'thick_mar_lh')
            for mac=1:length(d_para.thick_markers)
                if d_para.thick_markers(mac)<=f_para.instants(frc)
                    set(mov_handles.thick_mar_lh(mac),'Visible','on','XData',(d_para.thick_markers(mac)+d_para.tmax-f_para.instants(frc))*ones(1,2))
                else
                    set(mov_handles.thick_mar_lh(mac),'Visible','off')
                end
            end
        end
        if isfield(mov_handles,'thin_mar_lh')
            for mac=1:length(d_para.thin_markers)
                if d_para.thin_markers(mac)<=f_para.instants(frc)
                    set(mov_handles.thin_mar_lh(mac),'Visible','on','XData',(d_para.thin_markers(mac)+d_para.tmax-f_para.instants(frc))*ones(1,2))
                else
                    set(mov_handles.thin_mar_lh(mac),'Visible','off')
                end
            end
        end
        f_para.x_realtime_mode=1;
    end
else
    if f_para.x_realtime_mode==1
        pspikes=get(gca,'UserData');
        for trac=1:f_para.num_trains
            for sc=1:f_para.num_pspikes(trac)
                set(mov_handles.spike_lh{trac}(sc),'Visible','on','XData',pspikes{trac}(sc)*ones(1,2))
            end
        end
        if isfield(mov_handles,'thick_mar_lh')
            for mac=1:length(d_para.thick_markers)
                set(mov_handles.thick_mar_lh(mac),'Visible','on','XData',d_para.thick_markers(mac)*ones(1,2))
            end
        end
        if isfield(mov_handles,'thin_mar_lh')
            for mac=1:length(d_para.thin_markers)
                set(mov_handles.thin_mar_lh(mac),'Visible','on','XData',d_para.thin_markers(mac)*ones(1,2))
            end
        end
        f_para.x_realtime_mode=2;
    end
    if f_para.num_instants>0 && any(mov_handles.mov_line_lh)>0
        set(mov_handles.mov_line_lh,'XData',[],'YData',[])
        mov_handles.mov_line_lh=0;
    end
    if f_para.num_triggered_averages>0 && any(mov_handles.trigave_plot_lh)
        if mov_handles.trigave_plot_lh(1)>0
            set(mov_handles.trigave_plot_lh(1),'XData',[],'YData',[])
        end
        if mov_handles.trigave_plot_lh(2)>0
            set(mov_handles.trigave_plot_lh(2),'XData',[],'YData',[])
        end
        mov_handles.trigave_plot_lh=zeros(1,2);
    end
    if frc<=f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames
        savc=ceil((frc-f_para.num_instants)/f_para.num_average_frames);      % frame
        savc2=mod((frc-f_para.num_instants-1),f_para.num_average_frames)+1;  % frame repetition
        mi=f_para.num_instants+savc;
        %[frc savc savc2 mi]
        if f_para.publication==0 && f_para.show_title==1
            if isfield(d_para,'interval_divisions') && ~isempty(d_para.interval_divisions) && isfield(d_para,'interval_names') && ...
                    ~isempty(d_para.interval_names) && length(d_para.interval_names)==length(d_para.interval_divisions)+1
                inty_mat=zeros(f_para.num_sel_ave(savc),2);
                for selc=1:f_para.num_sel_ave(savc)
                    inty=find(f_para.selective_averages{savc}(2*selc-1)>=d_para.interval_divisions,1,'last')+1;
                    if isempty(inty)
                        inty=1;
                    end
                    inty_mat(selc,1)=inty;
                    inty=find(f_para.selective_averages{savc}(2*selc)>d_para.interval_divisions,1,'last')+1;
                    if isempty(inty)
                        inty=1;
                    end
                    inty_mat(selc,2)=inty;
                end
                if numel(unique(inty_mat))==1
                    title_str=['   ---   ',d_para.interval_names{unique(inty_mat)}];
                else
                    title_str='';
                end
            else
                title_str='';
            end
            if f_para.num_selective_averages*f_para.num_average_frames==f_para.num_frames
                count_str=['Selective Mean ',num2str(savc),'  (',num2str(f_para.num_selective_averages),')'];
            else
                count_str=['Selective Mean ',num2str(savc),'  (',num2str(f_para.num_selective_averages),')    ---    Total ',num2str(frc),...
                    ' (',num2str(f_para.num_frames),')'];
            end
            prof_title_cmenu = uicontextmenu;
            prof_title_fh=title([f_para.title_string,'   ---   ',count_str,title_str],...
                'Visible',p_para.prof_title_vis,'Color',p_para.prof_title_col,'FontSize',p_para.prof_title_fs,...
                'FontWeight',p_para.prof_title_fw,'FontAngle',p_para.prof_title_fa,'UIContextMenu',prof_title_cmenu);
            fh_str='prof_title';
            SPIKY_handle_font
        end
        if savc2==1
            if any(any(mov_handles.selave_line_lh))
                for selc=1:max(f_para.num_sel_ave)
                    if mov_handles.selave_line_lh(1,selc)>0
                        set(mov_handles.selave_line_lh(1,selc),'XData',[],'YData',[])
                    end
                    if mov_handles.selave_line_lh(2,selc)>0
                        set(mov_handles.selave_line_lh(2,selc),'XData',[],'YData',[])
                    end
                end
                mov_handles.selave_line_lh=zeros(2,max(f_para.num_sel_ave));
            end
            mov_handles.selave_line_cmenu = uicontextmenu;
            for selc=1:f_para.num_sel_ave(savc)
                mov_handles.selave_line_lh(1,selc)=line(f_para.selective_averages{savc}(2*selc-1:2*selc),...
                    (sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+0.075/1.3*f_para.subplot_size(2))*ones(1,2),...
                    'Visible',p_para.selave_vis,'Color',p_para.selave_col,'LineStyle',p_para.selave_ls,...
                    'LineWidth',p_para.selave_lw,'UIContextMenu',mov_handles.selave_line_cmenu);
                mov_handles.selave_line_lh(2,selc)=line(f_para.selective_averages{savc}(2*selc-1:2*selc),...
                    (sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+1.225/1.3*f_para.subplot_size(2))*ones(1,2),...
                    'Visible',p_para.selave_vis,'Color',p_para.selave_col,'LineStyle',p_para.selave_ls,...
                    'LineWidth',p_para.selave_lw,'UIContextMenu',mov_handles.selave_line_cmenu);
            end
            lh_str='mov_handles.selave_line';
            SPIKY_handle_line
        end
    else
        tavc=ceil((frc-f_para.num_instants-f_para.num_selective_averages*f_para.num_average_frames)/f_para.num_average_frames);      % frame
        tavc2=mod((frc-f_para.num_instants-f_para.num_selective_averages*f_para.num_average_frames-1),f_para.num_average_frames)+1;  % frame repetition
        mi=f_para.num_instants+f_para.num_selective_averages+tavc;   % f_para.num_average_frames
        %[frc tavc tavc2 mi]
        if f_para.num_instants>0 && any(mov_handles.mov_line_lh)>0
            set(mov_handles.mov_line_lh,'XData',[],'YData',[])
            mov_handles.mov_line_lh=0;
        end
        if f_para.num_selective_averages>0 && any(any(mov_handles.selave_line_lh))
            for selc=1:max(f_para.num_sel_ave)
                if mov_handles.selave_line_lh(1,selc)>0
                    set(mov_handles.selave_line_lh(1,selc),'XData',[],'YData',[])
                end
                if mov_handles.selave_line_lh(2,selc)>0
                    set(mov_handles.selave_line_lh(2,selc),'XData',[],'YData',[])
                end
            end
            mov_handles.selave_line_lh=zeros(2,max(f_para.num_sel_ave));
        end
        if f_para.publication==0 && f_para.show_title==1
            if isfield(d_para,'interval_divisions') && ~isempty(d_para.interval_divisions) && isfield(d_para,'interval_names') && ...
                    ~isempty(d_para.interval_names) && length(d_para.interval_names)==length(d_para.interval_divisions)+1
                inty_vect=zeros(1,length(f_para.triggered_averages(tavc)));
                for tac=1:length(f_para.triggered_averages{tavc})
                    inty=find(f_para.triggered_averages{tavc}(tac)>=d_para.interval_divisions,1,'last')+1;
                    if isempty(inty)
                        inty=1;
                    end
                    inty_vect(tac)=inty;
                end
                if numel(unique(inty_vect))==1
                    title_str=['   ---   ',d_para.interval_names{unique(inty_vect)}];
                else
                    title_str='';
                end
            else
                title_str='';
            end
            if f_para.num_triggered_averages*f_para.num_average_frames==f_para.num_frames
                count_str=['Triggered Mean ',num2str(tavc),'  (',num2str(f_para.num_triggered_averages),')'];
            else
                count_str=['Triggered Mean ',num2str(tavc),'  (',num2str(f_para.num_triggered_averages),')    ---    Total ',num2str(frc),...
                    ' (',num2str(f_para.num_frames),')'];
            end
            prof_title_cmenu = uicontextmenu;
            prof_title_fh=title([f_para.title_string,'   ---   ',count_str,title_str],...
                'Visible',p_para.prof_title_vis,'Color',p_para.prof_title_col,'FontSize',p_para.prof_title_fs,...
                'FontWeight',p_para.prof_title_fw,'FontAngle',p_para.prof_title_fa,'UIContextMenu',prof_title_cmenu);
            fh_str='prof_title';
            SPIKY_handle_font
        end
        if ~any(mov_handles.trigave_plot_lh)
            mov_handles.trigave_plot_cmenu = uicontextmenu;
            mov_handles.trigave_plot_lh(1)=plot(f_para.triggered_averages{tavc},(sum(f_para.subplot_size(...
                f_para.sing_subplots))-f_para.subplot_start(2)+0.075/1.3*f_para.subplot_size(2))*ones(1,length(f_para.triggered_averages{tavc})),...
                'Visible',p_para.trigave_vis,'Marker',p_para.trigave_symb_bot,'MarkerFaceColor',p_para.trigave_col,...
                'Color',p_para.trigave_col,'LineStyle','none','LineWidth',p_para.trigave_lw,'UIContextMenu',mov_handles.trigave_plot_cmenu);
            mov_handles.trigave_plot_lh(2)=plot(f_para.triggered_averages{tavc},(sum(f_para.subplot_size(...
                f_para.sing_subplots))-f_para.subplot_start(2)+1.225/1.3*f_para.subplot_size(2))*ones(1,length(f_para.triggered_averages{tavc})),...
                'Visible',p_para.trigave_vis,'Marker',p_para.trigave_symb_top,'MarkerFaceColor',p_para.trigave_col,...
                'Color',p_para.trigave_col,'LineStyle','none','LineWidth',p_para.trigave_lw,'UIContextMenu',mov_handles.trigave_plot_cmenu);
            lh_str='mov_handles.trigave_plot';
            SPIKY_handle_line
        else
            set(trigaver_plot_lh(1),'XData',f_para.triggered_averages{tavc},'YData',...
                (sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+0.075/1.3*...
                f_para.subplot_size(2))*ones(1,length(f_para.triggered_averages{tavc})))
            set(trigaver_plot_lh(2),'XData',f_para.triggered_averages{tavc},'YData',...
                (sum(f_para.subplot_size(f_para.sing_subplots))-f_para.subplot_start(2)+1.225/1.3*...
                f_para.subplot_size(2))*ones(1,length(f_para.triggered_averages{tavc})))
        end
    end
end

mat_title_cmenu = uicontextmenu;
mat_title_fh=zeros(h_para.d_num_all_matrices,1+f_para.dendrograms);
mat_label_cmenu = uicontextmenu;
mat_label_fh=zeros(h_para.d_num_all_matrices,2*(1+f_para.dendrograms));
if f_para.num_select_train_groups>1
    mat_sgs_cmenu = uicontextmenu;
    mat_sgs_lh=zeros(h_para.d_num_all_matrices,f_para.num_select_train_groups-1,2);
end
mat_thick_sep_cmenu = uicontextmenu;
mat_thick_sep_lh=zeros(h_para.d_num_all_matrices,length(d_para.thick_separators),2);
mat_thin_sep_cmenu = uicontextmenu;
mat_thin_sep_lh=zeros(h_para.d_num_all_matrices,length(d_para.thin_separators),2);
mat_cmenu = uicontextmenu;
mat_sph=zeros(1,h_para.d_num_all_matrices);
if f_para.dendrograms==1
    dendrol_cmenu = uicontextmenu;
    dendrol_lh=zeros(h_para.d_num_all_matrices,f_para.num_trains,2);
    dendros_cmenu = uicontextmenu;
    dendros_sph=zeros(1,h_para.d_num_all_matrices);
end

if any(m_para.measure_bi_indy(m_para.select_disc_measures)) && (frc<=f_para.num_instants || (frc>f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames))
    subplot('position',[0.05  0.05 0.9 0.4])
    cla    % reset lower part of screen
end

for matc=1:h_para.d_num_all_matrices
    mat_sph(matc)=subplot('position',h_para.d_supos(matc,1:4),'UIContextMenu',mat_cmenu);
    
    hold on; cla;
    if matc<=h_para.d_num_measures
        selave=0;
        if frc<=f_para.num_instants
            plot_vect=squeeze(m_res.movie_vects(pf_mats(matc),:,mi));
        elseif frc<=f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames
            selave=1;
            if savc2==1
                plot_vect=squeeze(m_res.movie_vects_sa(pf_mats(matc),:,savc));
            end
        else
            if tavc2==1
                plot_vect=squeeze(m_res.movie_vects_ta(pf_mats(matc),:,tavc));
            end
        end
        plot_mat=zeros(f_para.num_trains,f_para.num_trains);
        plot_mat(sub2ind([f_para.num_trains f_para.num_trains],f_para.mat_indy(:,1),f_para.mat_indy(:,2)))=plot_vect;
        
        if matc~=m_para.measure_bi_indy(m_para.spikeorder_disc)
            plot_mat=plot_mat+plot_mat';
        else
            plot_mat=plot_mat-plot_mat';
        end
        
        if ismember(matc,m_para.measure_bi_indy(m_para.inv_bi_measures)) && selave==1
            plot_mat(1:f_para.num_trains+1:end)=1;    % SPIKE-Sync: Diagonal 1
        end        
        if matc==1
            results.matrices=zeros(h_para.d_num_measures,f_para.num_trains,f_para.num_trains);
        end
        results.matrices(matc,:,:)=plot_mat;
    else
        if frc<=f_para.num_instants
            plot_mat=squeeze(m_res.group_movie_mat(pf_mats(matc-h_para.d_num_measures),:,:,mi));
        elseif frc<=f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames
            if savc2==1
                plot_mat=squeeze(m_res.group_movie_mat_sa(pf_mats(matc-h_para.d_num_measures),:,:,savc));
            end
        else
            if tavc2==1
                plot_mat=squeeze(m_res.group_movie_mat_ta(pf_mats(matc-h_para.d_num_measures),:,:,tavc));
            end
        end
        if matc==h_para.d_num_measures+1
            results.group_matrices=zeros(h_para.d_num_measures,f_para.num_select_train_groups,f_para.num_select_train_groups);
        end
        results.group_matrices(matc-h_para.d_num_measures,:,:)=plot_mat;
    end
    
    im_cmenu = uicontextmenu;
    im_ih=imagesc(flipud(plot_mat),'UIContextMenu',im_cmenu);
    set(gca,'YDir','normal')
    
    set(im_ih,'UserData',matc,'Tag',m_res.bi_mat_str{matc})
    im_assign_cb = 'assignin(''base'', [''SPIKY_matrix_'' num2str(get(gco,''UserData''))], flipud(get(gco,''CData'')) );    assignin(''base'', [''SPIKY_matrix_name_'' num2str(get(gco,''UserData''))], get(gco,''Tag'') ); ';
    ev_item = uimenu(im_cmenu,'Label','Extract variable: Matrix','Callback',im_assign_cb);
    
    if f_para.color_norm_mode==1                % Set Color Limits for Matrices
        if frc<=f_para.num_instants || frc>f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames || sum(m_para.measure_bi_indy(m_para.asym_bi_measures))==0
            set(gca,'CLim',[0 1])
        else
            set(gca,'CLim',[-1 1])
        end
    elseif f_para.color_norm_mode==2
        if ~any(m_para.measure_bi_indy(m_para.inv_bi_measures))
            if frc<=f_para.num_instants
                max_mat_val=max(max(squeeze(m_res.movie_vects(:,:,mi))));
            elseif frc<=f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames
                if savc2==1
                    max_mat_val=max(max(squeeze(m_res.movie_vects_sa(:,:,savc))));
                end
            else
                if tavc2==1
                    max_mat_val=max(max(squeeze(m_res.movie_vects_ta(:,:,tavc))));
                end
            end
        else
            max_mat_val=1;
        end
        if frc<=f_para.num_instants || frc>f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames || isempty(m_para.measure_bi_indy(m_para.asym_bi_measures))
            if max_mat_val>0
                set(gca,'CLim',[0 max_mat_val])
            end
        else
            if frc<=f_para.num_instants
                min_mat_val=min(min(squeeze(m_res.movie_vects(:,:,mi))));
            elseif frc<=f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames
                if savc2==1
                    min_mat_val=min(min(squeeze(m_res.movie_vects_sa(:,:,savc))));
                end
            else
                if tavc2==1
                    min_mat_val=min(min(squeeze(m_res.movie_vects_ta(:,:,tavc))));
                end
            end
            min_mat_val=min([0 min_mat_val min(min(squeeze(-m_res.movie_vects_sa(m_para.measure_bi_indy(m_para.asym_bi_measures),:,savc))))]);
            if max_mat_val>min_mat_val
                set(gca,'CLim',[min_mat_val max_mat_val])
            end
        end
    elseif f_para.color_norm_mode==3
        if max(max(plot_mat))>0
            if frc<=f_para.num_instants || frc>f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames || isempty(m_para.measure_bi_indy(m_para.asym_bi_measures))
                set(gca,'CLim',[0 max(max(plot_mat))])
            else
                set(gca,'CLim',[min([0 min(min(plot_mat))]) max(max(plot_mat))])
            end
        end
    elseif f_para.color_norm_mode==4
        if ~any(m_para.measure_bi_indy(m_para.inv_bi_measures))
            if frc<=f_para.num_instants
                max_mat_val=max(max(squeeze(m_res.movie_vects(:,:,mi))));
            elseif frc<=f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames
                if savc2==1
                    max_mat_val=max(max(squeeze(m_res.movie_vects_sa(:,:,savc))));
                end
            else
                if tavc2==1
                    max_mat_val=max(max(squeeze(m_res.movie_vects_ta(:,:,tavc))));
                end
            end
        else
            max_mat_val=1;
        end
        if frc<=f_para.num_instants
            min_mat_val=min(min(squeeze(m_res.movie_vects(:,:,mi))));
        elseif frc<=f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames
            if savc2==1
                min_mat_val=min(min(squeeze(m_res.movie_vects_sa(:,:,savc))));
            end
        else
            if tavc2==1
                min_mat_val=min(min(squeeze(m_res.movie_vects_ta(:,:,tavc))));
            end
        end
        if ~(frc<=f_para.num_instants || frc>f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames || isempty(m_para.measure_bi_indy(m_para.asym_bi_measures)))
            min_mat_val=min([min_mat_val min(min(squeeze(-m_res.movie_vects_sa(m_para.measure_bi_indy(m_para.asym_bi_measures),:,savc))))]);
        end
        if max_mat_val>min_mat_val
            set(gca,'CLim',[min_mat_val max_mat_val])
        end
    elseif f_para.color_norm_mode==5
        if max(max(plot_mat))>min(min(plot_mat))
            set(gca,'CLim',[min(min(plot_mat)) max(max(plot_mat))])
        end
    end
    
    
    if matc<=h_para.d_num_measures
        xlim([0.5 f_para.num_trains+0.5])
        ylim([0.5 f_para.num_trains+0.5])
        if f_para.num_select_train_groups>1 && length(find(diff(f_para.select_group_vect)))==f_para.num_select_train_groups-1
            set(gca,'XTick',0.5+sort(f_para.cum_num_select_group_trains),'XTickLabel',f_para.cum_num_select_group_trains)
            set(gca,'YTick',sort(f_para.num_trains+1-f_para.cum_num_select_group_trains),'YTickLabel',fliplr(f_para.cum_num_select_group_trains))
        else
            if f_para.num_trains<10
                set(gca,'XTick',1:f_para.num_trains,'XTickLabel',1:f_para.num_trains)
            end
            set(gca,'YTick',f_para.num_trains+1-fliplr(get(gca,'XTick')),'YTickLabel',flipud(get(gca,'XTickLabel')))
        end
    else
        xlim([0.5 f_para.num_select_train_groups+0.5])
        ylim([0.5 f_para.num_select_train_groups+0.5])
        set(gca,'XTick',1:f_para.num_select_train_groups,'XTickLabel',f_para.select_group_names)
        set(gca,'YTick',1:f_para.num_select_train_groups,'YTickLabel',fliplr(f_para.select_group_names))
    end
    if length(get(gca,'YTick'))>f_para.num_trains
        set(gca,'YTick',(1:f_para.num_trains),'YTickLabel',fliplr(1:f_para.num_trains));
    end
    axis square
    if h_para.d_num_all_subplots<4
        mat_title_fh(matc,1)=title(m_res.bi_mat_str{pf_mats(matc)},...
            'Visible',p_para.mat_title_vis,'Color',p_para.mat_title_col,'FontSize',p_para.mat_title_fs,...
            'FontWeight',p_para.mat_title_fw,'FontAngle',p_para.mat_title_fa,'UIContextMenu',mat_title_cmenu);
    else
        mat_title_fh(matc,1)=title(m_res.bi_mat_str{pf_mats(matc)},...
            'Visible',p_para.mat_title_vis,'Color',p_para.mat_title_col,'FontSize',p_para.mat_title_fs-2,...
            'FontWeight',p_para.mat_title_fw,'FontAngle',p_para.mat_title_fa,'UIContextMenu',mat_title_cmenu);
    end
    if h_para.d_rows(matc)==max(h_para.d_rows) || f_para.dendrograms
        if matc<=h_para.d_num_measures
            mat_label_fh(matc,1)=xlabel('Spike trains',...
                'Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs,...
                'FontWeight',p_para.mat_label_fw,'FontAngle',p_para.mat_label_fa,'UIContextMenu',mat_label_cmenu);
        else
            mat_label_fh(matc,1)=xlabel('Spike train groups',...
                'Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs,...
                'FontWeight',p_para.mat_label_fw,'FontAngle',p_para.mat_label_fa,'UIContextMenu',mat_label_cmenu);
        end
    end
    if h_para.d_cols(matc)==1 || max(h_para.d_cols)<=2
        if matc<=h_para.d_num_measures
            mat_label_fh(matc,2)=ylabel('Spike trains',...
                'Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs,...
                'FontWeight',p_para.mat_label_fw,'FontAngle',p_para.mat_label_fa,'UIContextMenu',mat_label_cmenu);
        else
            mat_label_fh(matc,2)=ylabel('Spike train groups',...
                'Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs,...
                'FontWeight',p_para.mat_label_fw,'FontAngle',p_para.mat_label_fa,'UIContextMenu',mat_label_cmenu);
        end
    end
    xl=xlim; yl=ylim;
    if matc<=h_para.d_num_measures
        if f_para.num_select_train_groups>1 && length(find(diff(f_para.select_group_vect)))==f_para.num_select_train_groups-1
            for sgc=1:f_para.num_select_train_groups-1
                mat_sgs_lh(matc,sgc,1)=line(xl,(0.5+f_para.num_trains-f_para.cum_num_select_group_trains(sgc))*ones(1,2),...
                    'Visible',p_para.mat_sgs_vis,'Color',p_para.mat_sgs_col,'LineStyle',p_para.mat_sgs_ls,...
                    'LineWidth',p_para.mat_sgs_lw,'UIContextMenu',mat_sgs_cmenu);
                mat_sgs_lh(matc,sgc,2)=line((0.5+f_para.cum_num_select_group_trains(sgc))*ones(1,2),yl,...
                    'Visible',p_para.mat_sgs_vis,'Color',p_para.mat_sgs_col,'LineStyle',p_para.mat_sgs_ls,...
                    'LineWidth',p_para.mat_sgs_lw,'UIContextMenu',mat_sgs_cmenu);
            end
        end
        if isfield(d_para,'thick_separators') && ~isempty(d_para.thick_separators)
            for sec=1:length(d_para.thick_separators)
                mat_thick_sep_lh(matc,sec,1)=line(xl,(0.5+f_para.num_trains-d_para.thick_separators(sec))*ones(1,2),...
                    'Visible',p_para.mat_thick_sep_vis,'Color',p_para.mat_thick_sep_col,'LineStyle',p_para.mat_thick_sep_ls,...
                    'LineWidth',p_para.mat_thick_sep_lw,'UIContextMenu',mat_thick_sep_cmenu);
                mat_thick_sep_lh(matc,sec,2)=line((0.5+d_para.thick_separators(sec))*ones(1,2),yl,...
                    'Visible',p_para.mat_thick_sep_vis,'Color',p_para.mat_thick_sep_col,'LineStyle',p_para.mat_thick_sep_ls,...
                    'LineWidth',p_para.mat_thick_sep_lw,'UIContextMenu',mat_thick_sep_cmenu);
            end
        end
        if isfield(d_para,'thin_separators') && ~isempty(d_para.thin_separators)
            for sec=1:length(d_para.thin_separators)
                mat_thin_sep_lh(matc,sec,1)=line(xl,(0.5+f_para.num_trains-d_para.thin_separators(sec))*ones(1,2),...
                    'Visible',p_para.mat_thin_sep_vis,'Color',p_para.mat_thin_sep_col,'LineStyle',p_para.mat_thin_sep_ls,...
                    'LineWidth',p_para.mat_thin_sep_lw,'UIContextMenu',mat_thin_sep_cmenu);
                mat_thin_sep_lh(matc,sec,2)=line((0.5+d_para.thin_separators(sec))*ones(1,2),yl,...
                    'Visible',p_para.mat_thin_sep_vis,'Color',p_para.mat_thin_sep_col,'LineStyle',p_para.mat_thin_sep_ls,...
                    'LineWidth',p_para.mat_thin_sep_lw,'UIContextMenu',mat_thin_sep_cmenu);
            end
        end
    end
    
    mat_tick_cmenu = uicontextmenu;
    mat_tick_fh=zeros(1,2);
    mat_tick_fh(1)=line(xl,yl(1)*ones(1,2),'Color','w','LineWidth',0.5,'UIContextMenu',mat_tick_cmenu);
    mat_tick_fh(2)=line(xl(1)*ones(1,2),yl,'Color','w','LineWidth',0.5,'UIContextMenu',mat_tick_cmenu);
    fh_str='mat_tick';
    SPIKY_handle_set_property
    
    if f_para.colorbar && (matc==h_para.d_num_all_matrices || ismember(f_para.color_norm_mode,[3 5]))
        colorbar
        set(gca,'position',h_para.d_supos(matc,1:4))
    end
    
    if f_para.dendrograms==1
        fig=figure(f_para.num_fig);
        dendros_sph(matc)=subplot('position',h_para.d_supos(h_para.d_num_all_matrices+matc,1:4),'UIContextMenu',dendros_cmenu);
        if matc<=h_para.d_num_measures
            mm=plot_mat(logical(tril(ones(f_para.num_trains),-1)));     % Back-Transformation necessary? Get data directly ######
        else
            mm=plot_mat(logical(tril(ones(f_para.num_select_train_groups),-1)));
        end
        if ~any(any(isnan(plot_mat))) && size(mm,1)>1 && (m_para.measure_bi_indy(m_para.spikeorder_disc)==0 || ~ismember(matc,m_para.measure_bi_indy(m_para.spikeorder_disc)+[0 h_para.num_reg_matrices]))
            sdm_linkage=linkage(mm');
            dh=dendrogram(sdm_linkage,0);
            if matc<=h_para.d_num_measures
                if matc==1
                    results.dendros=cell(1,h_para.d_num_measures);
                end
                results.dendros{matc}=sdm_linkage;
            else
                if matc==h_para.d_num_measures+1
                    results.group_dendros=cell(1,h_para.d_num_measures);
                end
                results.group_dendros{matc-h_para.d_num_measures}=sdm_linkage;
            end
            set(dendros_sph(matc),'UserData',sdm_linkage,'Tag',[m_res.bi_mat_str{pf_mats(matc)},num2str(matc)])
            
            xtl=get(gca,'XTickLabel');
            xtln=zeros(1,size(plot_mat,1));
            for trac=1:size(plot_mat,1)
                xtln(trac)=str2double(xtl(trac,:));
            end
            if f_para.spike_train_color_coding_mode>1
                cm=colormap;
                if matc>h_para.d_num_measures || (f_para.spike_train_color_coding_mode==2 && f_para.num_select_train_groups>1)
                    dcol_indy=round(1:63/(d_para.num_all_train_groups-1):64);
                    if matc<=h_para.d_num_measures
                        dh_para.d_cols=cm(dcol_indy(d_para.select_train_groups(f_para.select_group_vect)),:);
                    else
                        dh_para.d_cols=cm(dcol_indy(d_para.select_train_groups),:);
                    end
                else
                    dcol_indy=round(1:63/(f_para.num_trains-1):64);
                    dh_para.d_cols=cm(dcol_indy,:);
                end
                yl=ylim;
                if size(sdm_linkage,1)>30 || (h_para.d_num_all_matrices>1 && size(sdm_linkage,1)>20) || (h_para.d_num_all_matrices>2 && size(sdm_linkage,1)>10)
                    dlw=1;
                else
                    dlw=p_para.dendrol_lw;
                end
                trac=0;
                for lic=1:size(sdm_linkage,1)
                    for cc=1:2
                        if sdm_linkage(lic,cc)<=size(plot_mat,1)
                            trac=trac+1;
                            dendrol_lh(matc,lic,cc)=line(find(xtln==sdm_linkage(lic,cc))*ones(1,2),[yl(1) sdm_linkage(lic,3)],...
                                'Visible',p_para.dendrol_vis,'Color',dh_para.d_cols(sdm_linkage(lic,cc),:),'LineStyle',p_para.dendrol_ls,...
                                'LineWidth',dlw,'UIContextMenu',dendrol_cmenu,'UserData',gca);
                        end
                    end
                end
            end
            set(gca,'YTick',[])
            %if h_para.d_num_all_subplots>3
            %    set(gca,'YTick',[])
            %end
            if matc<=h_para.d_num_measures
                if f_para.num_trains>20 || (f_para.num_trains>10 && h_para.d_num_all_matrices>1)
                    set(gca,'XTickLabel',[])
                elseif f_para.num_trains>10
                    set(gca,'FontSize',8)
                end
                f_para.dendro_order{matc}=xtln;
            else
                if f_para.num_select_train_groups>10
                    set(gca,'XTickLabel',[])
                end
                f_para.group_dendro_order{matc-h_para.d_num_measures}=xtln;
            end
            %hold on
            %if h_para.d_num_all_subplots<4
            %    mat_title_fh(matc,2)=title(m_res.bi_mat_str{pf_mats(matc)},...
            %        'Visible',p_para.mat_title_vis,'Color',p_para.mat_title_col,'FontSize',p_para.mat_title_fs,...
            %        'FontWeight',p_para.mat_title_fw,'FontAngle',p_para.mat_title_fa,'UIContextMenu',mat_title_cmenu);
            %elseif h_para.d_num_all_subplots~=8
            %    mat_title_fh(matc,2)=title(m_res.bi_mat_str{pf_mats(matc)},...
            %        'Visible',p_para.mat_title_vis,'Color',p_para.mat_title_col,'FontSize',p_para.mat_title_fs-2,...
            %        'FontWeight',p_para.mat_title_fw,'FontAngle',p_para.mat_title_fa,'UIContextMenu',mat_title_cmenu);
            %end
            if h_para.d_rows(h_para.d_num_all_matrices+matc)==max(h_para.d_rows) || h_para.d_num_all_subplots<4
                if matc<=h_para.d_num_measures
                    mat_label_fh(matc,3)=xlabel('Spike trains',...
                        'Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs,...
                        'FontWeight',p_para.mat_label_fw,'FontAngle',p_para.mat_label_fa,'UIContextMenu',mat_label_cmenu);
                else
                    xl=xlim; yl=ylim;
                    mat_label_fh(matc,3)=xlabel('Spike train groups',...
                        'Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs,...
                        'FontWeight',p_para.mat_label_fw,'FontAngle',p_para.mat_label_fa,'UIContextMenu',mat_label_cmenu);
                    %mat_label_fh(matc,3)=text(xl(1)+0.13*(diff(xl)),yl(1)-0.17*(diff(yl)),'Spike train groups',...
                    %    'Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs,...
                    %    'FontWeight',p_para.mat_label_fw,'FontAngle',p_para.mat_label_fa,'UIContextMenu',mat_label_cmenu);
                end
            end
        else
            axis([0 1 0 1])
            xl=xlim; yl=ylim;
            line(xl(1)+[0.3 0.7]*diff(xl),yl(1)+[0.3 0.7]*diff(yl),'Color','r','LineWidth',2)
            line(xl(1)+[0.3 0.7]*diff(xl),yl(2)-[0.3 0.7]*diff(yl),'Color','r','LineWidth',2)
            set(gca,'XTick',[],'YTick',[])
            axis off
        end
        axis square
    end
end
fh_str='mat_title';
SPIKY_handle_font
fh_str='mat_label';
SPIKY_handle_font
if f_para.num_select_train_groups>1
    lh_str='mat_sgs';
    SPIKY_handle_line
end
lh_str='mat_thick_sep';
SPIKY_handle_line
lh_str='mat_thin_sep';
SPIKY_handle_line
sph_str='mat';
SPIKY_handle_subplot
if f_para.dendrograms==1
    lh_str='dendrol';
    SPIKY_handle_line
    sph_str='dendros';
    SPIKY_handle_subplot
end

if get(handles.print_figures_checkbox,'Value')==1             % Create postscript file
    if f_para.publication==1
        set(gcf,'PaperOrientation','Portrait');set(gcf,'PaperType', 'A4');
        set(gcf,'PaperUnits','Normalized','PaperPosition',[0 0.25 1.0 0.7]);
    else
        set(gcf,'PaperOrientation','Landscape');set(gcf,'PaperType', 'A4');
        set(gcf,'PaperUnits','Normalized','PaperPosition', [0 0 1.0 1.0]);
    end
    if frc<=f_para.num_instants
        psname=[f_para.imagespath,d_para.comment_string,f_para.comment_string,num2str(frc),'.ps'];
        print(gcf,'-dpsc',psname);
    elseif frc<=f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames
        if savc2==1
            psname=[f_para.imagespath,d_para.comment_string,f_para.comment_string,'_SelAve',num2str(savc),'.ps'];
            print(gcf,'-dpsc',psname);
            %pdfname=[f_para.imagespath,d_para.comment_string,f_para.comment_string,'_SelAve',num2str(savc),'.pdf'];
            %saveas(gcf,pdfname,'pdf');
        end
    else
        if tavc2==1
            psname=[f_para.imagespath,d_para.comment_string,f_para.comment_string,'_TrigAve',num2str(tavc),'.ps'];
            print(gcf,'-dpsc',psname);
        end
    end
end

if isfield(mov_handles,'tmov')
    if get(handles.record_movie_checkbox,'Value')==1
        figure(f_para.num_fig)
        F = getframe(f_para.num_fig);
        F1 = F;
        F1.cdata(:,:,1) = flipud(F.cdata(:,:,1));
        F1.cdata(:,:,2) = flipud(F.cdata(:,:,2));
        F1.cdata(:,:,3) = flipud(F.cdata(:,:,3));
        mov_handles.tmov = addframe(mov_handles.tmov,F1);
        ft(frc,:,:,:)=F.cdata;
    else
        %if frc==f_para.num_frames
            mov_handles.tmov = close(mov_handles.tmov);
            rmfield(mov_handles,'tmov')
        %end
    end
end