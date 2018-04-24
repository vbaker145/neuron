% This function allows changing the properties (such as color, line style, and line width) of line objects in the figure.

dum=0;
if strcmp(lh_str,'p_para.prof')
    prof_assign_cb = 'ud=get(gco,''UserData''); assignin(''base'',[''SPIKY_profile_X_'' num2str(ud(1,end))], ud(1,1:end-1) );   assignin(''base'',[''SPIKY_profile_Y_'' num2str(ud(1,end))], ud(2:end,1:end-1));   assignin(''base'',[''SPIKY_profile_name_'' num2str(ud(1,end))], get(gco,''Tag'') ); clear ud' ;
    eval([ 'ev_item = uimenu (' lh_str '_cmenu, ''Label'', ''Extract variable: Profile'', ''Callback'', prof_assign_cb );   '])
    dum=1;
elseif strcmp(lh_str,'p_para.ma_prof')
    prof_assign_cb = 'ud=get(gco,''UserData''); assignin(''base'',[''SPIKY_ma_profile_X_'' num2str(ud(1,end))], ud(1,1:end-1) );   assignin(''base'',[''SPIKY_ma_profile_Y_'' num2str(ud(1,end))], ud(2:end,1:end-1));   assignin(''base'',[''SPIKY_ma_profile_name_'' num2str(ud(1,end))], get(gco,''Tag'') ); clear ud' ;
    eval([ 'ev_item = uimenu (' lh_str '_cmenu, ''Label'', ''Extract variable: MA-Profile'', ''Callback'', prof_assign_cb );   '])
    dum=1;
elseif strcmp(lh_str,'spike') || strcmp(lh_str,'image')
    spike_assign_cb = 'assignin(''base'',''SPIKY_spikes'', get(gca,''UserData''));' ;
    eval([ 'ev_item = uimenu (' lh_str '_cmenu, ''Label'', ''Extract variable: Spikes'', ''Callback'', spike_assign_cb );   '])
    dum=1;
end

if ~strcmp(lh_str,'image')
    if strcmp(lh_str,'thick_mar') || strcmp(lh_str,'thin_mar')
        eval([ 'xpos_item = uimenu (' lh_str '_cmenu, ''Label'', ''XPos'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_edit_line_position, handles,' lh_str '_lh, lh_str}); '])
        dum=1;
    end
    if strcmp(lh_str,'thick_sep') || strcmp(lh_str,'thin_sep')
        eval([ 'ypos_item = uimenu (' lh_str '_cmenu, ''Label'', ''YPos'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_edit_line_position, handles,' lh_str '_lh, lh_str}); '])
        dum=1;
    end
    if strcmp(lh_str,'dendro')
        if dum==1
            eval([ 'vis_item = uimenu (' lh_str '_cmenu, ''Label'', ''invisible'', ''Separator'', ''on'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Visible'', ''off'', ''' lh_str '_vis'' }); '])
        else
            eval([ 'vis_item = uimenu (' lh_str '_cmenu, ''Label'', ''invisible'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Visible'', ''off'', ''' lh_str '_vis'' }); '])
        end
    elseif strcmp(lh_str,'mov_handles.trigave_plot')
        if dum==1
            eval([ 'mfc_item = uimenu (' lh_str '_cmenu, ''Label'', ''MarkerFaceColor'', ''Separator'', ''on'' ); '])
        else
            eval([ 'mfc_item = uimenu (' lh_str '_cmenu, ''Label'', ''MarkerFaceColor''); '])
        end
        eval([ 'mec_item = uimenu (' lh_str '_cmenu, ''Label'', ''MarkerEdgeColor'' ); '])
    else
        if dum==1
            eval([ 'col_item = uimenu (' lh_str '_cmenu, ''Label'', ''Color'', ''Separator'', ''on'' ); '])
        else
            eval([ 'col_item = uimenu (' lh_str '_cmenu, ''Label'', ''Color''); '])
        end
    end
    if ~strcmp(lh_str,'mov_handles.trigave_plot')
        eval([ 'ls_item = uimenu (' lh_str '_cmenu, ''Label'', ''LineStyle'' ); '])
    end
    eval([ 'lw_item = uimenu (' lh_str '_cmenu, ''Label'', ''LineWidth'' ); '])
    
    if strcmp(lh_str,'thick_mar') || strcmp(lh_str,'thin_mar')
        eval([ 'xpos_all_item = uimenu (' lh_str '_cmenu, ''Label'', ''All XPos'', ''Separator'', ''on'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_edit_line_position, handles,' lh_str '_lh, lh_str}); '])
    end
    if strcmp(lh_str,'thick_sep') || strcmp(lh_str,'thin_sep')
        eval([ 'ypos_all_item = uimenu (' lh_str '_cmenu, ''Label'', ''All YPos'', ''Separator'', ''on'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_edit_line_position, handles,' lh_str '_lh, lh_str}); '])
    end
    if strcmp(lh_str,'dendro')
        eval([ 'vis_all_item = uimenu (' lh_str '_cmenu, ''Label'', ''invisible'', ''Separator'', ''on'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Visible'', ''off'', ''' lh_str '_vis'' }); '])
    elseif strcmp(lh_str,'mov_handles.trigave_plot')
        eval([ 'mfc_all_item = uimenu (' lh_str '_cmenu, ''Label'', ''All MarkerFaceColor'', ''Separator'', ''on'' ); '])
        eval([ 'mec_all_item = uimenu (' lh_str '_cmenu, ''Label'', ''All MarkerEdgeColor'' ); '])
    else
        eval([ 'col_all_item = uimenu (' lh_str '_cmenu, ''Label'', ''All Color'', ''Separator'', ''on'' ); '])
    end
    if ~strcmp(lh_str,'mov_handles.trigave_plot')
        eval([ 'ls_all_item = uimenu (' lh_str '_cmenu, ''Label'', ''All LineStyle'' ); '])
    end
    eval([ 'lw_all_item = uimenu (' lh_str '_cmenu, ''Label'', ''All LineWidth''); '])
    
    if ~strcmp(lh_str,'mov_handles.trigave_plot')
        if ~strcmp(lh_str,'dendro')
            eval([ 'col_item1 = uimenu (col_item, ''Label'', ''black'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''k'', 0, ''' lh_str '_col'' }); '])
            eval([ 'col_item2 = uimenu (col_item, ''Label'', ''blue'', ''ForegroundColor'', ''blue'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''b'', 0, ''' lh_str '_col'' }); '])
            eval([ 'col_item3 = uimenu (col_item, ''Label'', ''red'', ''ForegroundColor'', ''red'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''r'', 0, ''' lh_str '_col'' }); '])
            eval([ 'col_item4 = uimenu (col_item, ''Label'', ''green'', ''ForegroundColor'', ''green'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''g'', 0, ''' lh_str '_col'' }); '])
            eval([ 'col_item5 = uimenu (col_item, ''Label'', ''cyan'', ''ForegroundColor'', ''cyan'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''c'', 0, ''' lh_str '_col'' }); '])
            eval([ 'col_item6 = uimenu (col_item, ''Label'', ''magenta'', ''ForegroundColor'', ''magenta'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''m'', 0, ''' lh_str '_col'' }); '])
            eval([ 'col_item7 = uimenu (col_item, ''Label'', ''yellow'', ''ForegroundColor'', ''yellow'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''y'', 0, ''' lh_str '_col'' }); '])
            eval([ 'col_item8 = uimenu (col_item, ''Label'', ''white'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''w'', 0, ''' lh_str '_col''}); '])
            eval([ 'col_item9 = uimenu (col_item, ''Label'', ''invisible'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Visible'', ''off'', 0, ''' lh_str '_vis'', ''Separator'', ''on'' }); '])
            
            if strcmp(lh_str,'spike') && ~isempty(get(gca,'Tag'))
                eval([ 'tag=get(gca,''Tag''); col_all_item0 = uimenu (col_all_item, ''Label'', ''color-coded'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''k'', 1, ''' lh_str '_col'', tag }); clear tag'])
                eval([ 'col_all_item1 = uimenu (col_all_item, ''Label'', ''black'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''k'', 1, ''' lh_str '_col''}, ''Separator'', ''on'' ); '])
            else
                eval([ 'col_all_item1 = uimenu (col_all_item, ''Label'', ''black'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''k'', 1, ''' lh_str '_col'' }); '])
            end
            eval([ 'col_all_item2 = uimenu (col_all_item, ''Label'', ''blue'', ''ForegroundColor'', ''blue'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''b'', 1, ''' lh_str '_col'' }); '])
            eval([ 'col_all_item3 = uimenu (col_all_item, ''Label'', ''red'', ''ForegroundColor'', ''red'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''r'', 1, ''' lh_str '_col'' }); '])
            eval([ 'col_all_item4 = uimenu (col_all_item, ''Label'', ''green'', ''ForegroundColor'', ''green'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''g'', 1, ''' lh_str '_col'' }); '])
            eval([ 'col_all_item5 = uimenu (col_all_item, ''Label'', ''cyan'', ''ForegroundColor'', ''cyan'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''c'', 1, ''' lh_str '_col'' }); '])
            eval([ 'col_all_item6 = uimenu (col_all_item, ''Label'', ''magenta'', ''ForegroundColor'', ''magenta'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''m'', 1, ''' lh_str '_col'' }); '])
            eval([ 'col_all_item7 = uimenu (col_all_item, ''Label'', ''yellow'', ''ForegroundColor'', ''yellow'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''y'', 1, ''' lh_str '_col'' }); '])
            eval([ 'col_all_item8 = uimenu (col_all_item, ''Label'', ''white'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Color'', ''w'', 1, ''' lh_str '_col''}); '])
            eval([ 'col_all_item9 = uimenu (col_all_item, ''Label'', ''invisible'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''Visible'', ''off'', 1, ''' lh_str '_vis'', ''Separator'', ''on'' }); '])
        end
    else
        eval([ 'mfc_item1 = uimenu (mfc_item, ''Label'', ''black'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''k'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mfc_item2 = uimenu (mfc_item, ''Label'', ''blue'', ''ForegroundColor'', ''blue'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''b'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mfc_item3 = uimenu (mfc_item, ''Label'', ''red'', ''ForegroundColor'', ''red'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''r'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mfc_item4 = uimenu (mfc_item, ''Label'', ''green'', ''ForegroundColor'', ''green'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''g'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mfc_item5 = uimenu (mfc_item, ''Label'', ''cyan'', ''ForegroundColor'', ''cyan'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''c'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mfc_item6 = uimenu (mfc_item, ''Label'', ''magenta'', ''ForegroundColor'', ''magenta'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''m'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mfc_item7 = uimenu (mfc_item, ''Label'', ''yellow'', ''ForegroundColor'', ''yellow'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''y'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mfc_item8 = uimenu (mfc_item, ''Label'', ''white'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''w'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mec_item1 = uimenu (mec_item, ''Label'', ''black'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''k'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mec_item2 = uimenu (mec_item, ''Label'', ''blue'', ''ForegroundColor'', ''blue'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''b'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mec_item3 = uimenu (mec_item, ''Label'', ''red'', ''ForegroundColor'', ''red'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''r'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mec_item4 = uimenu (mec_item, ''Label'', ''green'', ''ForegroundColor'', ''green'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''g'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mec_item5 = uimenu (mec_item, ''Label'', ''cyan'', ''ForegroundColor'', ''cyan'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''c'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mec_item6 = uimenu (mec_item, ''Label'', ''magenta'', ''ForegroundColor'', ''magenta'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''m'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mec_item7 = uimenu (mec_item, ''Label'', ''yellow'', ''ForegroundColor'', ''yellow'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''y'', 0, ''' lh_str '_col'' }); '])
        eval([ 'mec_item8 = uimenu (mec_item, ''Label'', ''white'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''w'', 0, ''' lh_str '_col'' }); '])
        
        eval([ 'mfc_all_item1 = uimenu (mfc_all_item, ''Label'', ''black'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''k'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mfc_all_item2 = uimenu (mfc_all_item, ''Label'', ''blue'', ''ForegroundColor'', ''blue'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''b'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mfc_all_item3 = uimenu (mfc_all_item, ''Label'', ''red'', ''ForegroundColor'', ''red'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''r'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mfc_all_item4 = uimenu (mfc_all_item, ''Label'', ''green'', ''ForegroundColor'', ''green'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''g'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mfc_all_item5 = uimenu (mfc_all_item, ''Label'', ''cyan'', ''ForegroundColor'', ''cyan'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''c'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mfc_all_item6 = uimenu (mfc_all_item, ''Label'', ''magenta'', ''ForegroundColor'', ''magenta'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''m'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mfc_all_item7 = uimenu (mfc_all_item, ''Label'', ''yellow'', ''ForegroundColor'', ''yellow'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''y'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mfc_all_item8 = uimenu (mfc_all_item, ''Label'', ''white'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerFaceColor'', ''w'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mec_all_item1 = uimenu (mec_all_item, ''Label'', ''black'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''k'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mec_all_item2 = uimenu (mec_all_item, ''Label'', ''blue'', ''ForegroundColor'', ''blue'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''b'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mec_all_item3 = uimenu (mec_all_item, ''Label'', ''red'', ''ForegroundColor'', ''red'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''r'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mec_all_item4 = uimenu (mec_all_item, ''Label'', ''green'', ''ForegroundColor'', ''green'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''g'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mec_all_item5 = uimenu (mec_all_item, ''Label'', ''cyan'', ''ForegroundColor'', ''cyan'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''c'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mec_all_item6 = uimenu (mec_all_item, ''Label'', ''magenta'', ''ForegroundColor'', ''magenta'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''m'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mec_all_item7 = uimenu (mec_all_item, ''Label'', ''yellow'', ''ForegroundColor'', ''yellow'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''y'', 1, ''' lh_str '_col'' }); '])
        eval([ 'mec_all_item8 = uimenu (mec_all_item, ''Label'', ''white'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''MarkerEdgeColor'', ''w'', 1, ''' lh_str '_col'' }); '])
    end
    
    if ~strcmp(lh_str,'mov_handles.trigave_plot')
        eval([ 'ls_item1 = uimenu (ls_item, ''Label'', ''solid -'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineStyle'', ''-'', 0, ''' lh_str '_ls'' }); '])
        eval([ 'ls_item2 = uimenu (ls_item, ''Label'', ''dotted :'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineStyle'', '':'', 0, ''' lh_str '_ls'' }); '])
        eval([ 'ls_item3 = uimenu (ls_item, ''Label'', ''dashdot -.'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineStyle'', ''-.'', 0, ''' lh_str '_ls'' }); '])
        eval([ 'ls_item4 = uimenu (ls_item, ''Label'', ''dashed --'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineStyle'', ''--'', 0, ''' lh_str '_ls'' }); '])
        
        eval([ 'ls_all_item1 = uimenu (ls_all_item, ''Label'', ''solid -'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineStyle'', ''-'', 1, ''' lh_str '_ls'' }); '])
        eval([ 'ls_all_item2 = uimenu (ls_all_item, ''Label'', ''dotted :'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineStyle'', '':'', 1, ''' lh_str '_ls'' }); '])
        eval([ 'ls_all_item3 = uimenu (ls_all_item, ''Label'', ''dashdot -.'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineStyle'', ''-.'', 1, ''' lh_str '_ls'' }); '])
        eval([ 'ls_all_item4 = uimenu (ls_all_item, ''Label'', ''dashed --'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineStyle'', ''--'', 1, ''' lh_str '_ls'' }); '])
    end
    
    eval([ 'lw_itemp2 = uimenu( lw_item, ''Label'', ''+2'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', 102, 0, ''' lh_str '_lw'' }); '])
    eval([ 'lw_itemp1 = uimenu( lw_item, ''Label'', ''+1'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', 101, 0, ''' lh_str '_lw'' }); '])
    eval([ 'lw_itemph = uimenu( lw_item, ''Label'', ''+0.5'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', 100.5, 0, ''' lh_str '_lw'' }); '])
    eval([ 'lw_itemmh = uimenu( lw_item, ''Label'', ''-0.5'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', -100.5, 0, ''' lh_str '_lw'' }, ''Separator'', ''on''); '])
    eval([ 'lw_itemm1 = uimenu( lw_item, ''Label'', ''-1'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', -101, 0, ''' lh_str '_lw'' }); '])
    eval([ 'lw_itemm2 = uimenu( lw_item, ''Label'', ''-2'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', -102, 0, ''' lh_str '_lw'' }); '])
    eval([ 'lw_item1 = uimenu( lw_item, ''Label'', ''1'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', 1, 0, ''' lh_str '_lw'' }, ''Separator'', ''on''); '])
    
    eval([ 'lw_all_itemp2 = uimenu( lw_all_item, ''Label'', ''+2'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', 102, 1, ''' lh_str '_lw'' }); '])
    eval([ 'lw_all_itemp1 = uimenu( lw_all_item, ''Label'', ''+1'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', 101, 1, ''' lh_str '_lw'' }); '])
    eval([ 'lw_all_itemph = uimenu( lw_all_item, ''Label'', ''+0.5'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', 100.5, 1, ''' lh_str '_lw'' }); '])
    eval([ 'lw_all_itemmh = uimenu( lw_all_item, ''Label'', ''-0.5'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', -100.5, 1, ''' lh_str '_lw'' }, ''Separator'', ''on''); '])
    eval([ 'lw_all_itemm1 = uimenu( lw_all_item, ''Label'', ''-1'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', -101, 1, ''' lh_str '_lw'' }); '])
    eval([ 'lw_all_itemm2 = uimenu( lw_all_item, ''Label'', ''-2'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', -102, 1, ''' lh_str '_lw'' }); '])
    eval([ 'lw_all_item1 = uimenu( lw_all_item, ''Label'', ''1'', ''Callback'', { @SPIKY_handle_change_property, handles,' lh_str '_lh, ''LineWidth'', 1, 1, ''' lh_str '_lw'' }, ''Separator'', ''on''); '])
end