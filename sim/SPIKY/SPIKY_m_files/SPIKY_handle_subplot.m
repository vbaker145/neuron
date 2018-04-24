% This function which calls 'SPIKY_handle_change_subplot_size.m' allows changing the position (x and y) and the size (width and height)
% of the matrix subplots in the figure 

dum=0;
if strcmp(sph_str,'dendros')
    dendro_assign_cb = 'tag=get(gca,''Tag''); assignin(''base'',[''SPIKY_dendrogram_'' tag(end)], get(gca,''UserData'')); assignin(''base'',[''SPIKY_dendrogram_name_'' tag(end)], tag(1:end-1)); clear tag' ;
    eval([ 'sp_dendro_item = uimenu (' sph_str '_cmenu, ''Label'', ''Extract variable: Dendrogram'', ''Callback'', dendro_assign_cb );   '])
    dum=1;
end
if dum==1
    eval([ 'sp_position_item = uimenu (' sph_str '_cmenu, ''Label'', ''Position'', ''Separator'', ''on'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_edit_subplot_position, handles, ' sph_str '_sph, sph_str}); '])
else
    eval([ 'sp_position_item = uimenu (' sph_str '_cmenu, ''Label'', ''Position'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_edit_subplot_position, handles, ' sph_str '_sph, sph_str}); '])
end
eval([ 'sp_xpos_item = uimenu (' sph_str '_cmenu, ''Label'', ''XPos'', ''Separator'', ''on''); '])
eval([ 'sp_ypos_item = uimenu (' sph_str '_cmenu, ''Label'', ''YPos''); '])
eval([ 'sp_width_item = uimenu (' sph_str '_cmenu, ''Label'', ''Width''); '])
eval([ 'sp_height_item = uimenu (' sph_str '_cmenu, ''Label'', ''Height''); '])

if ~strcmp(sph_str,'profs') && h_para.num_all_matrices>1
    eval([ 'sp_all_xpos_item = uimenu (' sph_str '_cmenu, ''Label'', ''All XPos'', ''Separator'', ''on''); '])
    eval([ 'sp_all_ypos_item = uimenu (' sph_str '_cmenu, ''Label'', ''All YPos''); '])
    eval([ 'sp_all_width_item = uimenu (' sph_str '_cmenu, ''Label'', ''All Width''); '])
    eval([ 'sp_all_height_item = uimenu (' sph_str '_cmenu, ''Label'', ''All Height''); '])
end

eval([ 'sp_xpos_item1 = uimenu (sp_xpos_item, ''Label'', ''+0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''+0.16'' }); '])
eval([ 'sp_xpos_item2 = uimenu (sp_xpos_item, ''Label'', ''+0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''+0.08'' }); '])
eval([ 'sp_xpos_item3 = uimenu (sp_xpos_item, ''Label'', ''+0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''+0.04'' }); '])
eval([ 'sp_xpos_item4 = uimenu (sp_xpos_item, ''Label'', ''+0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''+0.02'' }); '])
eval([ 'sp_xpos_item5 = uimenu (sp_xpos_item, ''Label'', ''+0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''+0.01'' }); '])
eval([ 'sp_xpos_item6 = uimenu (sp_xpos_item, ''Label'', ''-0.01'', ''Separator'', ''on'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''-0.01'' }); '])
eval([ 'sp_xpos_item7 = uimenu (sp_xpos_item, ''Label'', ''-0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''-0.02'' }); '])
eval([ 'sp_xpos_item8 = uimenu (sp_xpos_item, ''Label'', ''-0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''-0.04'' }); '])
eval([ 'sp_xpos_item9 = uimenu (sp_xpos_item, ''Label'', ''-0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''-0.08'' }); '])
eval([ 'sp_xpos_item10 = uimenu (sp_xpos_item, ''Label'', ''-0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''-0.16'' }); '])

eval([ 'sp_ypos_item1 = uimenu (sp_ypos_item, ''Label'', ''+0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''+0.16'' }); '])
eval([ 'sp_ypos_item2 = uimenu (sp_ypos_item, ''Label'', ''+0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''+0.08'' }); '])
eval([ 'sp_ypos_item3 = uimenu (sp_ypos_item, ''Label'', ''+0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''+0.04'' }); '])
eval([ 'sp_ypos_item4 = uimenu (sp_ypos_item, ''Label'', ''+0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''+0.02'' }); '])
eval([ 'sp_ypos_item5 = uimenu (sp_ypos_item, ''Label'', ''+0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''+0.01'' }); '])
eval([ 'sp_ypos_item6 = uimenu (sp_ypos_item, ''Label'', ''-0.01'', ''Separator'', ''on'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''-0.01'' }); '])
eval([ 'sp_ypos_item7 = uimenu (sp_ypos_item, ''Label'', ''-0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''-0.02'' }); '])
eval([ 'sp_ypos_item8 = uimenu (sp_ypos_item, ''Label'', ''-0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''-0.04'' }); '])
eval([ 'sp_ypos_item9 = uimenu (sp_ypos_item, ''Label'', ''-0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''-0.08'' }); '])
eval([ 'sp_ypos_item10 = uimenu (sp_ypos_item, ''Label'', ''-0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''-0.16'' }); '])

eval([ 'sp_width_item1 = uimenu (sp_width_item, ''Label'', ''+0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''+0.16'' }); '])
eval([ 'sp_width_item2 = uimenu (sp_width_item, ''Label'', ''+0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''+0.08'' }); '])
eval([ 'sp_width_item3 = uimenu (sp_width_item, ''Label'', ''+0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''+0.04'' }); '])
eval([ 'sp_width_item4 = uimenu (sp_width_item, ''Label'', ''+0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''+0.02'' }); '])
eval([ 'sp_width_item5 = uimenu (sp_width_item, ''Label'', ''+0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''+0.01'' }); '])
eval([ 'sp_width_item6 = uimenu (sp_width_item, ''Label'', ''-0.01'', ''Separator'', ''on'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''-0.01'' }); '])
eval([ 'sp_width_item7 = uimenu (sp_width_item, ''Label'', ''-0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''-0.02'' }); '])
eval([ 'sp_width_item8 = uimenu (sp_width_item, ''Label'', ''-0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''-0.04'' }); '])
eval([ 'sp_width_item9 = uimenu (sp_width_item, ''Label'', ''-0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''-0.08'' }); '])
eval([ 'sp_width_item10 = uimenu (sp_width_item, ''Label'', ''-0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''-0.16'' }); '])

eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''+0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''+0.16'' }); '])
eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''+0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''+0.08'' }); '])
eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''+0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''+0.04'' }); '])
eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''+0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''+0.02'' }); '])
eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''+0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''+0.01'' }); '])
eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''-0.01'', ''Separator'', ''on'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''-0.01'' }); '])
eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''-0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''-0.02'' }); '])
eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''-0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''-0.04'' }); '])
eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''-0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''-0.08'' }); '])
eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''-0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''-0.16'' }); '])


if ~strcmp(sph_str,'profs') && h_para.num_all_matrices>1
    eval([ 'sp_all_xpos_item1 = uimenu (sp_all_xpos_item, ''Label'', ''+0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''+0.16'', ''All'' }); '])
    eval([ 'sp_all_xpos_item2 = uimenu (sp_all_xpos_item, ''Label'', ''+0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''+0.08'', ''All'' }); '])
    eval([ 'sp_all_xpos_item3 = uimenu (sp_all_xpos_item, ''Label'', ''+0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''+0.04'', ''All'' }); '])
    eval([ 'sp_all_xpos_item4 = uimenu (sp_all_xpos_item, ''Label'', ''+0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''+0.02'', ''All'' }); '])
    eval([ 'sp_all_xpos_item5 = uimenu (sp_all_xpos_item, ''Label'', ''+0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''+0.01'', ''All'' }); '])
    eval([ 'sp_all_xpos_item6 = uimenu (sp_all_xpos_item, ''Label'', ''-0.01'', ''Separator'', ''on'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''-0.01'', ''All'' }); '])
    eval([ 'sp_all_xpos_item7 = uimenu (sp_all_xpos_item, ''Label'', ''-0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''-0.02'', ''All'' }); '])
    eval([ 'sp_all_xpos_item8 = uimenu (sp_all_xpos_item, ''Label'', ''-0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''-0.04'', ''All'' }); '])
    eval([ 'sp_all_xpos_item9 = uimenu (sp_all_xpos_item, ''Label'', ''-0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''-0.08'', ''All'' }); '])
    eval([ 'sp_all_xpos_item10 = uimenu (sp_all_xpos_item, ''Label'', ''-0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''xpos'', ''-0.16'', ''All'' }); '])

    eval([ 'sp_all_ypos_item1 = uimenu (sp_all_ypos_item, ''Label'', ''+0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''+0.16'', ''All'' }); '])
    eval([ 'sp_all_ypos_item2 = uimenu (sp_all_ypos_item, ''Label'', ''+0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''+0.08'', ''All'' }); '])
    eval([ 'sp_all_ypos_item3 = uimenu (sp_all_ypos_item, ''Label'', ''+0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''+0.04'', ''All'' }); '])
    eval([ 'sp_all_ypos_item4 = uimenu (sp_all_ypos_item, ''Label'', ''+0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''+0.02'', ''All'' }); '])
    eval([ 'sp_all_ypos_item5 = uimenu (sp_all_ypos_item, ''Label'', ''+0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''+0.01'', ''All'' }); '])
    eval([ 'sp_all_ypos_item6 = uimenu (sp_all_ypos_item, ''Label'', ''-0.01'', ''Separator'', ''on'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''-0.01'', ''All'' }); '])
    eval([ 'sp_all_ypos_item7 = uimenu (sp_all_ypos_item, ''Label'', ''-0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''-0.02'', ''All'' }); '])
    eval([ 'sp_all_ypos_item8 = uimenu (sp_all_ypos_item, ''Label'', ''-0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''-0.04'', ''All'' }); '])
    eval([ 'sp_all_ypos_item9 = uimenu (sp_all_ypos_item, ''Label'', ''-0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''-0.08'', ''All'' }); '])
    eval([ 'sp_all_ypos_item10 = uimenu (sp_all_ypos_item, ''Label'', ''-0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''ypos'', ''-0.16'', ''All'' }); '])

    eval([ 'sp_all_width_item1 = uimenu (sp_all_width_item, ''Label'', ''+0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''+0.16'', ''All'' }); '])
    eval([ 'sp_all_width_item2 = uimenu (sp_all_width_item, ''Label'', ''+0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''+0.08'', ''All'' }); '])
    eval([ 'sp_all_width_item3 = uimenu (sp_all_width_item, ''Label'', ''+0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''+0.04'', ''All'' }); '])
    eval([ 'sp_all_width_item4 = uimenu (sp_all_width_item, ''Label'', ''+0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''+0.02'', ''All'' }); '])
    eval([ 'sp_all_width_item5 = uimenu (sp_all_width_item, ''Label'', ''+0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''+0.01'', ''All'' }); '])
    eval([ 'sp_all_width_item6 = uimenu (sp_all_width_item, ''Label'', ''-0.01'', ''Separator'', ''on'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''-0.01'', ''All'' }); '])
    eval([ 'sp_all_width_item7 = uimenu (sp_all_width_item, ''Label'', ''-0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''-0.02'', ''All'' }); '])
    eval([ 'sp_all_width_item8 = uimenu (sp_all_width_item, ''Label'', ''-0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''-0.04'', ''All'' }); '])
    eval([ 'sp_all_width_item9 = uimenu (sp_all_width_item, ''Label'', ''-0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''-0.08'', ''All'' }); '])
    eval([ 'sp_all_width_item10 = uimenu (sp_all_width_item, ''Label'', ''-0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''width'', ''-0.16'', ''All'' }); '])

    eval([ 'sp_all_height_item1 = uimenu (sp_all_height_item, ''Label'', ''+0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''+0.16'', ''All'' }); '])
    eval([ 'sp_all_height_item2 = uimenu (sp_all_height_item, ''Label'', ''+0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''+0.08'', ''All'' }); '])
    eval([ 'sp_all_height_item3 = uimenu (sp_all_height_item, ''Label'', ''+0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''+0.04'', ''All'' }); '])
    eval([ 'sp_all_height_item4 = uimenu (sp_all_height_item, ''Label'', ''+0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''+0.02'', ''All'' }); '])
    eval([ 'sp_all_height_item5 = uimenu (sp_all_height_item, ''Label'', ''+0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''+0.01'', ''All'' }); '])
    eval([ 'sp_all_height_item6 = uimenu (sp_all_height_item, ''Label'', ''-0.01'', ''Separator'', ''on'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''-0.01'', ''All'' }); '])
    eval([ 'sp_all_height_item7 = uimenu (sp_all_height_item, ''Label'', ''-0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''-0.02'', ''All'' }); '])
    eval([ 'sp_all_height_item8 = uimenu (sp_all_height_item, ''Label'', ''-0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''-0.04'', ''All'' }); '])
    eval([ 'sp_all_height_item9 = uimenu (sp_all_height_item, ''Label'', ''+0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''+0.08'', ''All'' }); '])
    eval([ 'sp_all_height_item10 = uimenu (sp_all_height_item, ''Label'', ''+0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', ''+0.16'', ''All'' }); '])
end





% eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''0.2'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', 0.2'' }); '])
% eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''0.3'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', 0.3'' }); '])
% eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''0.4'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', 0.4'' }); '])
% eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''0.5'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', 0.5'' }); '])
% eval([ 'sp_height_item1 = uimenu (sp_height_item, ''Label'', ''0.6'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_subplot_size, handles,' sph_str '_sph, ''height'', 0.6'' }); '])


