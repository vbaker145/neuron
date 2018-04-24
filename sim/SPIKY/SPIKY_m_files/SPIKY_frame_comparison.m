% This compares the dissimilarity matrices selected in the panel ?Selection: Measures? for different time instants
% and/or selected or triggered averages (once the 'Plot' button is pressed and if 'Frame comparison' is checked).

fig=figure(f_para.num_fig);
%set(gcf,'Name',[f_para.filename,'  ',d_para.comment_string,'  ',f_para.comment_string,'  ',f_para.title_string])
subplot('Position',f_para.supo1)
f_para.supo1=h_para.supo1;
set(gca,'position',f_para.supo1)
prof_cmenu = uicontextmenu;
prof_sph=subplot('Position',f_para.supo1,'UIContextMenu',prof_cmenu);
sph_str='prof';
SPIKY_handle_subplot
h_para.d_supos=h_para.supos{h_para.num_all_subplots};

yl=ylim;
for frc=1:f_para.num_instants
    line(d_para.instants(frc)*ones(1,2),sum(f_para.subplot_size)-f_para.subplot_start(2)+[0 0.15]/1.3*f_para.subplot_size(2),'Color',p_para.mov_col,'LineStyle',p_para.mov_ls,'LineWidth',p_para.mov_lw)
    line(d_para.instants(frc)*ones(1,2),sum(f_para.subplot_size)-f_para.subplot_start(2)+[1.15 1.3]/1.3*f_para.subplot_size(2),'Color',p_para.mov_col,'LineStyle',p_para.mov_ls,'LineWidth',p_para.mov_lw)
    line(d_para.instants(frc)*ones(1,2),sum(f_para.subplot_size)-f_para.subplot_start(2)+[0.15 1.15]/1.3*f_para.subplot_size(2),'Color',p_para.mov_col,'LineStyle',':','LineWidth',p_para.mov_lw)
end
if f_para.num_selective_averages>0
    for savc=1:f_para.num_selective_averages
        for selc=1:f_para.num_sel_ave(savc)
            mov_handles.selave_line_lh(1,selc)=line(d_para.selective_averages{savc}(2*selc-1:2*selc),(sum(f_para.subplot_size)-f_para.subplot_start(2)+0.075/1.3*f_para.subplot_size(2))*ones(1,2),...
                'Color',p_para.mov_col,'LineStyle',p_para.mov_ls,'LineWidth',p_para.mov_lw);
            mov_handles.selave_line_lh(2,selc)=line(d_para.selective_averages{savc}(2*selc-1:2*selc),(sum(f_para.subplot_size)-f_para.subplot_start(2)+1.225/1.3*f_para.subplot_size(2))*ones(1,2),...
                'Color',p_para.mov_col,'LineStyle',p_para.mov_ls,'LineWidth',p_para.mov_lw);
        end
    end
end
if f_para.num_triggered_averages>0
    for tavc=1:f_para.num_triggered_averages
        mov_handles.trigave_plot_cmenu = uicontextmenu;
        mov_handles.trigave_plot_lh(1)=plot(d_para.triggered_averages{tavc},(sum(f_para.subplot_size)-f_para.subplot_start(2)+0.075/1.3*f_para.subplot_size(2))*ones(1,length(d_para.triggered_averages{tavc})),...
            'Visible',p_para.trigave_vis,'Marker',p_para.trigave_symb_bot,'MarkerFaceColor',p_para.trigave_col,...
            'Color',p_para.trigave_col,'LineStyle','none','LineWidth',p_para.trigave_lw,'UIContextMenu',mov_handles.trigave_plot_cmenu);
        mov_handles.trigave_plot_lh(2)=plot(d_para.triggered_averages{tavc},(sum(f_para.subplot_size)-f_para.subplot_start(2)+1.225/1.3*f_para.subplot_size(2))*ones(1,length(d_para.triggered_averages{tavc})),...
            'Visible',p_para.trigave_vis,'Marker',p_para.trigave_symb_top,'MarkerFaceColor',p_para.trigave_col,...
            'Color',p_para.trigave_col,'LineStyle','none','LineWidth',p_para.trigave_lw,'UIContextMenu',mov_handles.trigave_plot_cmenu);
        lh_str='mov_handles.trigave_plot';
        SPIKY_handle_line
    end
end

h_para.max_col=min([h_para.num_frames 10]);

%h_para.rows=reshape(cumsum(ones(h_para.num_measures,h_para.num_frames))',1,h_para.num_measures*h_para.num_frames);
%h_para.cols=reshape(cumsum(ones(h_para.num_frames,h_para.num_measures)),1,h_para.num_measures*h_para.num_frames);

mat_title_cmenu = uicontextmenu;
mat_title_fh=zeros(h_para.num_all_subplots,1+h_para.dendrograms);
mat_label_cmenu = uicontextmenu;
mat_label_fh=zeros(h_para.num_all_subplots,2*(1+h_para.dendrograms));
measure_label_cmenu = uicontextmenu;
measure_label_fh=zeros(1,h_para.num_measures*(1+f_para.group_matrices));
if f_para.num_select_train_groups>1
    mat_sgs_cmenu = uicontextmenu;
    mat_sgs_lh=zeros(h_para.num_all_subplots,f_para.num_select_train_groups-1,2);
end
mat_thick_sep_cmenu = uicontextmenu;
mat_thick_sep_lh=zeros(h_para.num_all_subplots,length(d_para.thick_separators),2);
mat_thin_sep_cmenu = uicontextmenu;
mat_thin_sep_lh=zeros(h_para.num_all_subplots,length(d_para.thin_separators),2);
mat_cmenu = uicontextmenu;
mat_sph=zeros(1,h_para.num_all_matrices);
if h_para.dendrograms==1
    dendrol_cmenu = uicontextmenu;
    dendrol_lh=zeros(h_para.num_all_matrices,f_para.num_trains,2);
    dendros_cmenu = uicontextmenu;
    dendros_sph=zeros(1,h_para.num_all_matrices);
end

h_para.bm_order=1;   % 1-first all matrices, then all group matrices ,2-all matrices for same frame together
p_para.mat_label_fw='normal';

for frc=1:h_para.num_frames
    for matc=1:h_para.num_measures*(1+f_para.group_matrices)
        
        if h_para.bm_order==1 || f_para.group_matrices==0;
            spc=(matc-1)*h_para.num_frames+frc;
        else
            grc=(matc-1)*h_para.num_frames+frc;
            spc=(h_para.num_all_matrices+grc)/2*(mod(grc,2)==0)+(grc+1)/2*(mod(grc,2)==1);
        end
        
        mat_sph(spc)=subplot('position',h_para.d_supos(spc,:),'UIContextMenu',mat_cmenu);
        if ~(ismember(matc,m_para.measure_bi_indy(m_para.select_disc_measures)) && (frc<=f_para.num_instants || frc>f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames))
            %if spc==8
            %h_para.supos(spc,3)=h_para.supos(spc,3)*1.2434;
            %end
            
            if r_para.num_runs==1
                if matc<=h_para.num_measures
                    plot_mat=squeeze(m_res.movie_mat(matc,1:f_para.num_trains,1:f_para.num_trains,frc));
                    if frc==1 && matc==1
                        results.matrices=zeros(h_para.num_frames*h_para.num_measures,f_para.num_trains,f_para.num_trains);
                    end
                    results.matrices((frc-1)*h_para.num_measures+matc,:,:)=plot_mat;
                else
                    plot_mat=squeeze(m_res.group_movie_mat(matc-h_para.num_measures,1:f_para.num_select_train_groups,1:f_para.num_select_train_groups,frc));
                    if frc==1 && matc==h_para.num_measures+1
                        results.group_matrices=zeros(h_para.num_frames*h_para.num_measures,f_para.num_select_train_groups,f_para.num_select_train_groups);
                    end
                    results.group_matrices((frc-1)*h_para.num_measures+matc-h_para.num_measures,:,:)=plot_mat;
                end
            else
                if matc<=h_para.num_measures
                    if frc<=f_para.num_instants
                        plot_vect=squeeze(m_res.movie_vects(matc,:,frc));
                    elseif frc<=f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames
                        savc=ceil((frc-f_para.num_instants)/f_para.num_average_frames);
                        plot_vect=squeeze(m_res.movie_vects_sa(matc,:,savc));
                    else
                        tavc=ceil((frc-f_para.num_instants-f_para.num_selective_averages*f_para.num_average_frames)/f_para.num_average_frames);      % frame
                        plot_vect=squeeze(m_res.movie_vects_ta(matc,:,tavc));
                    end
                    plot_mat=zeros(f_para.num_trains,f_para.num_trains);
                    plot_mat(sub2ind([f_para.num_trains f_para.num_trains],f_para.mat_indy(:,1),f_para.mat_indy(:,2)))=plot_vect;
                    plot_mat=plot_mat+plot_mat';
                    if m_para.num_disc_measures>0 && strcmp(m_res.bi_mat_str{matc},m_para.all_measures_str{m_para.spikesync_disc}) && selave==1
                        plot_mat(1:f_para.num_trains+1:end)=1;   % #######
                    end
                    if frc==1 && matc==1
                        results.matrices=zeros(h_para.num_frames*h_para.num_measures,f_para.num_trains,f_para.num_trains);
                    end
                    results.matrices((frc-1)*h_para.num_measures+matc,:,:)=plot_mat;
                else
                    if frc<=f_para.num_instants
                        plot_mat=squeeze(m_res.group_movie_mat(matc-h_para.num_measures,:,:,frc));
                    elseif frc<=f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames
                        plot_mat=squeeze(m_res.group_movie_mat_sa(matc-h_para.num_measures,:,:,savc));
                    else
                        plot_mat=squeeze(m_res.group_movie_mat_ta(matc-h_para.num_measures,:,:,tavc));
                    end
                    if frc==1 && matc==h_para.num_measures+1
                        results.group_matrices=zeros(h_para.num_frames*h_para.num_measures,f_para.num_select_train_groups,f_para.num_select_train_groups);
                    end
                    results.group_matrices((frc-1)*h_para.num_measures+matc-h_para.num_measures,:,:)=plot_mat;
                end
            end
            
            im_cmenu = uicontextmenu;
            im_ih=imagesc(flipud(plot_mat),'UIContextMenu',im_cmenu);
            set(gca,'YDir','normal')
            
            set(im_ih,'UserData',matc,'Tag',m_res.bi_mat_str{matc})
            im_assign_cb = 'assignin(''base'', [''SPIKY_matrix_'' num2str(get(gco,''UserData''))], get(gco,''CData'') );    assignin(''base'', [''SPIKY_matrix_name_'' num2str(get(gco,''UserData''))], get(gco,''Tag'') ); ';
            ev_item = uimenu (im_cmenu, 'Label', 'Extract variable: Matrix', 'Callback', im_assign_cb );
            
            if f_para.color_norm_mode==1
                if isempty(m_para.measure_bi_indy(m_para.asym_bi_measures))
                    set(gca,'CLim',[0 1])
                else
                    set(gca,'CLim',[-1 1])
                end
            elseif f_para.color_norm_mode==2
                max_mat_val=max(max(max(max(m_res.movie_mat))));
                if isempty(m_para.measure_bi_indy(m_para.asym_bi_measures))
                    if max_mat_val>0
                        set(gca,'CLim',[0 max_mat_val])
                    end
                else
                    min_mat_val=min([0 min(min(min(min(m_res.movie_mat))))]);
                    if max_mat_val>min_mat_val
                        set(gca,'CLim',[min_mat_val max_mat_val])
                    end
                end
            elseif f_para.color_norm_mode==3
                max_mat_val=max(max(plot_mat));
                if isempty(m_para.measure_bi_indy(m_para.asym_bi_measures))
                    if max_mat_val>0
                        set(gca,'CLim',[0 max_mat_val])
                    end
                else
                    min_min_val=min([0 min(min(plot_mat))]);
                    if max_mat_val>min_min_val
                        set(gca,'CLim',[min_min_val max_mat_val])
                    end
                end
            elseif f_para.color_norm_mode==4
                min_mat_val=min(min(min(min(m_res.movie_mat))));
                max_mat_val=max(max(max(max(m_res.movie_mat))));
                if max_mat_val>min_mat_val
                    set(gca,'CLim',[min_mat_val max_mat_val])
                end
            elseif f_para.color_norm_mode==5
                min_mat_val=min(min(plot_mat));
                max_mat_val=max(max(plot_mat));
                if max_mat_val>min_mat_val
                    set(gca,'CLim',[min_mat_val max_mat_val])
                end
            end
            if matc<=h_para.num_measures
                xlim([0.5 f_para.num_trains+0.5])
                ylim([0.5 f_para.num_trains+0.5])
                if f_para.num_select_train_groups>1
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
                set(gca,'XTick',1:f_para.num_select_train_groups,'XTickLabel',f_para.all_train_group_names)
                set(gca,'YTick',1:f_para.num_select_train_groups,'YTickLabel',fliplr(f_para.all_train_group_names))
            end
            %xlim([0.5 f_para.num_trains+0.5])
            %ylim([0.5 f_para.num_trains+0.5])
            if length(get(gca,'YTick'))>f_para.num_trains
                set(gca,'YTick',(1:f_para.num_trains),'YTickLabel',fliplr(1:f_para.num_trains));
            end
            xl=xlim; yl=ylim;
            
            if f_para.colorbar && ((matc==h_para.num_measures && frc==h_para.num_frames) || ismember(f_para.color_norm_mode,[3 5]))
                colorbar
                set(gca,'position',h_para.d_supos(spc,1:4))
            end
            axis square
            %if f_para.publication==0 && h_para.rows{h_para.num_all_subplots}(spc)==1 && frc<=f_para.num_instants
            %end
            %if matc==h_para.num_measures
            if h_para.rows{h_para.num_all_subplots}(spc)==max(h_para.rows{h_para.num_all_subplots}) || h_para.dendrograms
                if matc<=h_para.num_measures
                    mat_label_fh(spc,1)=xlabel('Spike trains',...
                        'Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs,...
                        'FontWeight',p_para.mat_label_fw,'FontAngle',p_para.mat_label_fa,'UIContextMenu',mat_label_cmenu);
                else
                    mat_label_fh(spc,1)=xlabel('Spike train groups',...
                        'Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs,...
                        'FontWeight',p_para.mat_label_fw,'FontAngle',p_para.mat_label_fa,'UIContextMenu',mat_label_cmenu);
                end
            end
            %end
            %[frc matc spc spc spc]
            
            
            if frc==1 %|| h_para.cols{h_para.num_all_subplots}(spc)==1
                measure_label_fh(h_para.rows{h_para.num_all_subplots}(spc))=text(xl(1)-(0.38-0.1*(max(h_para.cols{h_para.num_all_subplots})>2))*(xl(2)-xl(1)),...
                    yl(1)+0.46*(yl(2)-yl(1)),m_res.bi_mat_str{matc},'Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs+2,...
                    'FontWeight','bold','FontAngle',p_para.mat_label_fa,'UIContextMenu',measure_label_cmenu);
            end
            if h_para.num_all_subplots<=4 && (h_para.cols{h_para.num_all_subplots}(spc)==1 || (f_para.group_matrices && (h_para.bm_order==1 || frc==1)))
                if matc<=h_para.num_measures
                    mat_label_fh(spc,2)=ylabel('Spike trains','Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs,...
                        'FontWeight',p_para.mat_label_fw,'FontAngle',p_para.mat_label_fa,'UIContextMenu',mat_label_cmenu);
                else
                    mat_label_fh(spc,2)=ylabel('Spike train groups','Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs,...
                        'FontWeight',p_para.mat_label_fw,'FontAngle',p_para.mat_label_fa,'UIContextMenu',mat_label_cmenu);
                end
            end
            if matc<=h_para.num_measures % || max(h_para.rows)==1
                if frc<=f_para.num_instants
                    title_str=['T = ',num2str(f_para.instants(frc))];
                elseif frc<=f_para.num_instants+f_para.num_selective_averages*f_para.num_average_frames
                    savc=ceil((frc-f_para.num_instants)/f_para.num_average_frames);
                    title_str=['Sel #',num2str(savc)];
                else
                    tavc=ceil((frc-f_para.num_instants-f_para.num_selective_averages*f_para.num_average_frames)/f_para.num_average_frames);      % frame
                    title_str=['Trig #',num2str(tavc)];
                end
                
                if h_para.num_all_matrices<4
                    mat_title_fh(spc,2)=title(title_str,'Visible',p_para.mat_title_vis,'Color',p_para.mat_title_col,'FontSize',p_para.mat_title_fs,...
                        'FontWeight',p_para.mat_title_fw,'FontAngle',p_para.mat_title_fa,'UIContextMenu',mat_title_cmenu);
                else
                    mat_title_fh(spc,2)=title(title_str,'Visible',p_para.mat_title_vis,'Color',p_para.mat_title_col,'FontSize',p_para.mat_title_fs-2,...
                        'FontWeight',p_para.mat_title_fw,'FontAngle',p_para.mat_title_fa,'UIContextMenu',mat_title_cmenu);
                end
            end
            
            if f_para.num_select_train_groups>1
                for sgc=1:f_para.num_select_train_groups-1
                    mat_sgs_lh(spc,sgc,1)=line(xl,(0.5+f_para.num_trains-f_para.cum_num_select_group_trains(sgc))*ones(1,2),'Visible',p_para.mat_sgs_vis,...
                        'Color',p_para.mat_sgs_col,'LineStyle',p_para.mat_sgs_ls,'LineWidth',p_para.mat_sgs_lw,'UIContextMenu',mat_sgs_cmenu);
                    mat_sgs_lh(spc,sgc,2)=line((0.5+f_para.cum_num_select_group_trains(sgc))*ones(1,2),yl,'Visible',p_para.mat_sgs_vis,'Color',p_para.mat_sgs_col,...
                        'LineStyle',p_para.mat_sgs_ls,'LineWidth',p_para.mat_sgs_lw,'UIContextMenu',mat_sgs_cmenu);
                end
            end
            if isfield(d_para,'thick_separators') && ~isempty(d_para.thick_separators)
                for sec=1:length(d_para.thick_separators)
                    mat_thick_sep_lh(spc,sec,1)=line(xl,(0.5+f_para.num_trains-d_para.thick_separators(sec))*ones(1,2),'Visible',p_para.mat_thick_sep_vis,...
                        'Color',p_para.mat_thick_sep_col,'LineStyle',p_para.mat_thick_sep_ls,'LineWidth',p_para.mat_thick_sep_lw,'UIContextMenu',mat_thick_sep_cmenu);
                    mat_thick_sep_lh(spc,sec,2)=line((0.5+d_para.thick_separators(sec))*ones(1,2),yl,'Visible',p_para.mat_thick_sep_vis,...
                        'Color',p_para.mat_thick_sep_col,'LineStyle',p_para.mat_thick_sep_ls,'LineWidth',p_para.mat_thick_sep_lw,'UIContextMenu',mat_thick_sep_cmenu);
                end
            end
            if isfield(d_para,'thin_separators') && ~isempty(d_para.thin_separators)
                for sec=1:length(d_para.thin_separators)
                    mat_thin_sep_lh(spc,sec,1)=line(xl,(0.5+f_para.num_trains-d_para.thin_separators(sec))*ones(1,2),'Visible',p_para.mat_thin_sep_vis,...
                        'Color',p_para.mat_thin_sep_col,'LineStyle',p_para.mat_thin_sep_ls,'LineWidth',p_para.mat_thin_sep_lw,'UIContextMenu',mat_thin_sep_cmenu);
                    mat_thin_sep_lh(spc,sec,2)=line((0.5+d_para.thin_separators(sec))*ones(1,2),yl,'Visible',p_para.mat_thin_sep_vis,...
                        'Color',p_para.mat_thin_sep_col,'LineStyle',p_para.mat_thin_sep_ls,'LineWidth',p_para.mat_thin_sep_lw,'UIContextMenu',mat_thin_sep_cmenu);
                end
            end
            mat_tick_cmenu = uicontextmenu;
            mat_tick_fh=zeros(1,2);
            mat_tick_fh(1)=line(xl,yl(1)*ones(1,2),'Color','w','LineWidth',0.5,'UIContextMenu',mat_tick_cmenu);
            mat_tick_fh(2)=line(xl(1)*ones(1,2),yl,'Color','w','LineWidth',0.5,'UIContextMenu',mat_tick_cmenu);
            fh_str='mat_tick';
            SPIKY_handle_set_property
            if frc>1
                set(gca,'YTick',[])
            end
            
            %[spc get(gca,'Position')]
            if h_para.dendrograms==1
                fig=figure(f_para.num_fig);
                dendros_sph(spc)=subplot('position',h_para.d_supos(h_para.num_all_matrices+spc,1:4),'UIContextMenu',dendros_cmenu);
                if matc<=h_para.num_measures
                    mm=plot_mat(logical(tril(ones(f_para.num_trains),-1)));     % Back-Transformation necessary? Get data directly ######
                else
                    mm=plot_mat(logical(tril(ones(f_para.num_select_train_groups),-1)));
                end
                if ~any(any(isnan(plot_mat))) && size(mm,1)>1
                    sdm_linkage=linkage(mm');
                    dh=dendrogram(sdm_linkage,0);
                    if matc<=h_para.num_measures
                        if frc==1 && matc==1
                            results.dendros=cell(1,h_para.num_measures);
                        end
                        results.dendros{(frc-1)*h_para.num_measures+matc}=sdm_linkage;
                    else
                        if frc==1 && matc==h_para.num_measures+1
                            results.group_dendros=cell(1,h_para.num_frames*h_para.num_measures);
                        end
                        results.group_dendros{(frc-1)*h_para.num_measures+matc-h_para.num_measures}=sdm_linkage;
                    end
                    set(dendros_sph(spc),'UserData',sdm_linkage,'Tag',[m_res.bi_mat_str{matc},num2str(spc)])
                    
                    if f_para.spike_train_color_coding_mode>1
                        cm=colormap;
                        if matc>h_para.num_measures || (f_para.spike_train_color_coding_mode==2 && f_para.num_select_train_groups>1)
                            dcol_indy=round(1:63/(f_para.num_select_train_groups-1):64);
                            if matc<=h_para.num_measures
                                dh_para.cols=cm(dcol_indy(f_para.select_group_vect),:);
                            else
                                dh_para.cols=cm(dcol_indy,:);
                            end
                        else
                            dcol_indy=round(1:63/(f_para.num_trains-1):64);
                            dh_para.cols=cm(dcol_indy,:);
                        end
                        yl=ylim;
                        xtl=get(gca,'XTickLabel');
                        xtln=zeros(1,f_para.num_trains);
                        for trac=1:size(plot_mat,1)
                            xtln(trac)=str2double(xtl(trac,:));
                        end
                        
                        if size(sdm_linkage,1)>30 || (h_para.num_all_matrices>1 && size(sdm_linkage,1)>20) || (h_para.num_all_matrices>2 && size(sdm_linkage,1)>10)
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
                                        'Visible',p_para.dendrol_vis,'Color',dh_para.cols(sdm_linkage(lic,cc),:),'LineStyle',p_para.dendrol_ls,...
                                        'LineWidth',dlw,'UIContextMenu',dendrol_cmenu);
                                end
                            end
                        end
                    end
                    set(gca,'YTick',[])
                    if h_para.num_all_subplots>3
                        set(gca,'YTick',[])
                    end
                    if matc<=h_para.num_measures
                        if f_para.num_trains>30
                            set(gca,'XTickLabel',[])
                        elseif f_para.num_trains>15
                            set(gca,'FontSize',8)
                        end
                    else
                        if f_para.num_select_train_groups>30
                            set(gca,'XTickLabel',[])
                        end
                    end
                    %hold on
                    if h_para.num_all_subplots<4
                        mat_title_fh(matc,2)=title(m_res.bi_mat_str{matc},...
                            'Visible',p_para.mat_title_vis,'Color',p_para.mat_title_col,'FontSize',p_para.mat_title_fs,...
                            'FontWeight',p_para.mat_title_fw,'FontAngle',p_para.mat_title_fa,'UIContextMenu',mat_title_cmenu);
                    elseif h_para.num_all_subplots~=8
                        mat_title_fh(matc,2)=title(m_res.bi_mat_str{matc},...
                            'Visible',p_para.mat_title_vis,'Color',p_para.mat_title_col,'FontSize',p_para.mat_title_fs-2,...
                            'FontWeight',p_para.mat_title_fw,'FontAngle',p_para.mat_title_fa,'UIContextMenu',mat_title_cmenu);
                    end
                    if h_para.rows(h_para.num_all_matrices+matc)==max(h_para.rows) || h_para.num_all_subplots<4
                        if matc<=h_para.num_measures
                            mat_label_fh(matc,3)=xlabel('Spike trains',...
                                'Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs,...
                                'FontWeight',p_para.mat_label_fw,'FontAngle',p_para.mat_label_fa,'UIContextMenu',mat_label_cmenu);
                        else
                            xl=xlim; yl=ylim;
                            mat_label_fh(matc,3)=text(xl(1)+0.13*(diff(xl)),yl(1)-0.17*(diff(yl)),'Spike train groups',...
                                'Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs,...
                                'FontWeight',p_para.mat_label_fw,'FontAngle',p_para.mat_label_fa,'UIContextMenu',mat_label_cmenu);
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
        else
            axis([0 1 0 1])
            xl=xlim; yl=ylim;
            line(xl(1)+[0.3 0.7]*diff(xl),yl(1)+[0.3 0.7]*diff(yl),'Color','r','LineWidth',2)
            line(xl(1)+[0.3 0.7]*diff(xl),yl(2)-[0.3 0.7]*diff(yl),'Color','r','LineWidth',2)
            set(gca,'XTick',[],'YTick',[])
            axis off
            if frc==1 %|| h_para.cols{h_para.num_all_subplots}(spc)==1
                measure_label_fh(h_para.rows{h_para.num_all_subplots}(spc))=text(xl(1)-(0.18-0.1*(max(h_para.cols{h_para.num_all_subplots})>2))*(xl(2)-xl(1)),...
                    yl(1)+0.46*(yl(2)-yl(1)),m_res.bi_mat_str{matc},'Visible',p_para.mat_label_vis,'Color',p_para.mat_label_col,'FontSize',p_para.mat_label_fs+2,...
                    'FontWeight','bold','FontAngle',p_para.mat_label_fa,'UIContextMenu',measure_label_cmenu);
            end
        end
    end
end

fh_str='mat_title';
SPIKY_handle_font
fh_str='mat_label';
SPIKY_handle_font
fh_str='measure_label';
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
if h_para.dendrograms==1
    lh_str='dendrol';
    SPIKY_handle_line
    sph_str='dendros';
    SPIKY_handle_subplot
end


if get(handles.print_figures_checkbox,'Value')==1                                                                         % Create postscript file
    if f_para.publication==1
        set(gcf,'PaperOrientation','Portrait');set(gcf,'PaperType', 'A4');
        set(gcf,'PaperUnits','Normalized','PaperPosition',[0 0.15 1.0 0.8]);
    else
        set(gcf,'PaperOrientation','Landscape');set(gcf,'PaperType', 'A4');
        set(gcf,'PaperUnits','Normalized','PaperPosition', [0 0 1.0 1.0]);
    end
    psname=[f_para.imagespath,d_para.comment_string,f_para.comment_string,'_Frame_Comparison.ps'];
    print(gcf,'-dpsc',psname);
end


