% This function allows changing the string, the position, and various properties (such as color, font size, font weight, and font angle)
% of text objects in the figure.

eval([ 'fstr_item = uimenu (' fh_str '_cmenu, ''Label'', ''String'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_edit_string,handles,' fh_str '_fh}); '])
eval([ 'fxpos_item = uimenu (' fh_str '_cmenu, ''Label'', ''XPos'', ''Separator'', ''on''); '])
eval([ 'fypos_item = uimenu (' fh_str '_cmenu, ''Label'', ''YPos''); '])

dummy=eval([fh_str '_fh']);
if ~strcmp(fh_str,'xlab') && ~strcmp(fh_str,'title') && ~strcmp(fh_str,'mat_title') && ~strcmp(fh_str,'mat_label') && ~strcmp(fh_str,'synf_title') && ~strcmp(fh_str,'synf_label') && numel(dummy(dummy>0))>1
    eval([ 'fxpos_all_item = uimenu (' fh_str '_cmenu, ''Label'', ''All XPos'', ''Separator'', ''on''); '])
    eval([ 'fypos_all_item = uimenu (' fh_str '_cmenu, ''Label'', ''All YPos''); '])
end

eval([ 'fcol_item = uimenu( ' fh_str '_cmenu, ''Label'', ''Color'', ''Separator'', ''on''); '])
eval([ 'fs_item = uimenu( ' fh_str '_cmenu, ''Label'', ''FontSize''); '])
eval([ 'fw_item = uimenu( ' fh_str '_cmenu, ''Label'', ''FontWeight''); '])
eval([ 'fa_item = uimenu( ' fh_str '_cmenu, ''Label'', ''FontAngle''); '])

if ~strcmp(fh_str,'xlab') && ~strcmp(fh_str,'title') && ~strcmp(fh_str,'mat_title') && ~strcmp(fh_str,'mat_label') && ~strcmp(fh_str,'measure_label') && ~strcmp(fh_str,'synf_title') && ~strcmp(fh_str,'synf_label') && numel(dummy(dummy>0))>1
    eval([ 'fcol_all_item = uimenu( ' fh_str '_cmenu, ''Label'', ''All Color'', ''Separator'', ''on''); '])
    eval([ 'fs_all_item = uimenu( ' fh_str '_cmenu, ''Label'', ''All FontSize''); '])
    eval([ 'fw_all_item = uimenu( ' fh_str '_cmenu, ''Label'', ''All FontWeight''); '])
    eval([ 'fa_all_item = uimenu( ' fh_str '_cmenu, ''Label'', ''All FontAngle''); '])
end

eval([ 'fxpos_item1 = uimenu (fxpos_item, ''Label'', ''+0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''+0.16'', 0 }); '])
eval([ 'fxpos_item2 = uimenu (fxpos_item, ''Label'', ''+0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''+0.08'', 0 }); '])
eval([ 'fxpos_item3 = uimenu (fxpos_item, ''Label'', ''+0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''+0.04'', 0 }); '])
eval([ 'fxpos_item4 = uimenu (fxpos_item, ''Label'', ''+0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''+0.02'', 0 }); '])
eval([ 'fxpos_item5 = uimenu (fxpos_item, ''Label'', ''+0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''+0.01'', 0 }); '])
eval([ 'fxpos_item6 = uimenu (fxpos_item, ''Label'', ''-0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''-0.01'', 0}, ''Separator'', ''on'' ); '])
eval([ 'fxpos_item7 = uimenu (fxpos_item, ''Label'', ''-0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''-0.02'', 0 }); '])
eval([ 'fxpos_item8 = uimenu (fxpos_item, ''Label'', ''-0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''-0.04'', 0 }); '])
eval([ 'fxpos_item9 = uimenu (fxpos_item, ''Label'', ''-0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''-0.08'', 0 }); '])
eval([ 'fxpos_item10 = uimenu (fxpos_item, ''Label'', ''-0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''-0.16'', 0 }); '])

eval([ 'fypos_item1 = uimenu (fypos_item, ''Label'', ''+0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''+0.16'', 0 }); '])
eval([ 'fypos_item2 = uimenu (fypos_item, ''Label'', ''+0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''+0.08'', 0 }); '])
eval([ 'fypos_item3 = uimenu (fypos_item, ''Label'', ''+0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''+0.04'', 0 }); '])
eval([ 'fypos_item4 = uimenu (fypos_item, ''Label'', ''+0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''+0.02'', 0 }); '])
eval([ 'fypos_item5 = uimenu (fypos_item, ''Label'', ''+0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''+0.01'', 0 }); '])
eval([ 'fypos_item6 = uimenu (fypos_item, ''Label'', ''-0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''-0.01'', 0}, ''Separator'', ''on'' ); '])
eval([ 'fypos_item7 = uimenu (fypos_item, ''Label'', ''-0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''-0.02'', 0 }); '])
eval([ 'fypos_item8 = uimenu (fypos_item, ''Label'', ''-0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''-0.04'', 0 }); '])
eval([ 'fypos_item9 = uimenu (fypos_item, ''Label'', ''-0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''-0.08'', 0 }); '])
eval([ 'fypos_item10 = uimenu (fypos_item, ''Label'', ''-0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''-0.16'', 0 }); '])

if ~strcmp(fh_str,'xlab') && ~strcmp(fh_str,'title') && ~strcmp(fh_str,'mat_title') && ~strcmp(fh_str,'mat_label') && ~strcmp(fh_str,'measure_label') && ~strcmp(fh_str,'synf_title') && ~strcmp(fh_str,'synf_label') && numel(dummy(dummy>0))>1
    eval([ 'fxpos_all_item1 = uimenu (fxpos_all_item, ''Label'', ''+0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''+0.16'', 1 }); '])
    eval([ 'fxpos_all_item2 = uimenu (fxpos_all_item, ''Label'', ''+0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''+0.08'', 1 }); '])
    eval([ 'fxpos_all_item3 = uimenu (fxpos_all_item, ''Label'', ''+0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''+0.04'', 1 }); '])
    eval([ 'fxpos_all_item4 = uimenu (fxpos_all_item, ''Label'', ''+0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''+0.02'', 1 }); '])
    eval([ 'fxpos_all_item5 = uimenu (fxpos_all_item, ''Label'', ''+0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''+0.01'', 1 }); '])
    eval([ 'fxpos_all_item6 = uimenu (fxpos_all_item, ''Label'', ''-0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''-0.01'', 1}, ''Separator'', ''on'' ); '])
    eval([ 'fxpos_all_item7 = uimenu (fxpos_all_item, ''Label'', ''-0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''-0.02'', 1 }); '])
    eval([ 'fxpos_all_item8 = uimenu (fxpos_all_item, ''Label'', ''-0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''-0.04'', 1 }); '])
    eval([ 'fxpos_all_item9 = uimenu (fxpos_all_item, ''Label'', ''-0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''-0.08'', 1 }); '])
    eval([ 'fxpos_all_item10 = uimenu (fxpos_all_item, ''Label'', ''-0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''xpos'', ''-0.16'', 1 }); '])

    eval([ 'fypos_all_item1 = uimenu (fypos_all_item, ''Label'', ''+0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''+0.16'', 1 }); '])
    eval([ 'fypos_all_item2 = uimenu (fypos_all_item, ''Label'', ''+0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''+0.08'', 1 }); '])
    eval([ 'fypos_all_item3 = uimenu (fypos_all_item, ''Label'', ''+0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''+0.04'', 1 }); '])
    eval([ 'fypos_all_item4 = uimenu (fypos_all_item, ''Label'', ''+0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''+0.02'', 1 }); '])
    eval([ 'fypos_all_item5 = uimenu (fypos_all_item, ''Label'', ''+0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''+0.01'', 1 }); '])
    eval([ 'fypos_all_item6 = uimenu (fypos_all_item, ''Label'', ''-0.01'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''-0.01'', 1}, ''Separator'', ''on'' ); '])
    eval([ 'fypos_all_item7 = uimenu (fypos_all_item, ''Label'', ''-0.02'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''-0.02'', 1 }); '])
    eval([ 'fypos_all_item8 = uimenu (fypos_all_item, ''Label'', ''-0.04'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''-0.04'', 1 }); '])
    eval([ 'fypos_all_item9 = uimenu (fypos_all_item, ''Label'', ''-0.08'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''-0.08'', 1 }); '])
    eval([ 'fypos_all_item10 = uimenu (fypos_all_item, ''Label'', ''-0.16'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_font_position, ' fh_str '_fh, ''ypos'', ''-0.16'', 1 }); '])
end

eval([ 'fcol_item1 = uimenu( fcol_item, ''Label'', ''black'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''k'', 0, ''' fh_str '_col'' }); '])
eval([ 'fcol_item2 = uimenu( fcol_item, ''Label'', ''blue'', ''ForegroundColor'', ''blue'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''b'', 0, ''' fh_str '_col'' }); '])
eval([ 'fcol_item3 = uimenu( fcol_item, ''Label'', ''red'', ''ForegroundColor'', ''red'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''r'', 0, ''' fh_str '_col'' }); '])
eval([ 'fcol_item4 = uimenu( fcol_item, ''Label'', ''green'', ''ForegroundColor'', ''green'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''g'', 0, ''' fh_str '_col'' }); '])
eval([ 'fcol_item5 = uimenu( fcol_item, ''Label'', ''cyan'', ''ForegroundColor'', ''cyan'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''c'', 0, ''' fh_str '_col'' }); '])
eval([ 'fcol_item6 = uimenu( fcol_item, ''Label'', ''magenta'', ''ForegroundColor'', ''magenta'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''m'', 0, ''' fh_str '_col'' }); '])
eval([ 'fcol_item7 = uimenu( fcol_item, ''Label'', ''yellow'', ''ForegroundColor'', ''yellow'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''y'', 0, ''' fh_str '_col'' }); '])
eval([ 'fcol_item8 = uimenu( fcol_item, ''Label'', ''white'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''w'', 0, ''' fh_str '_col'' }); '])
eval([ 'fcol_item9 = uimenu( fcol_item, ''Label'', ''invisible'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Visible'', ''off'', 0, ''' fh_str '_vis'', ''Separator'', ''on'' }); '])

eval([ 'fs_itemp8 = uimenu( fs_item, ''Label'', ''+8'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 108, 0, ''' fh_str '_fs'' }); '])
eval([ 'fs_itemp4 = uimenu( fs_item, ''Label'', ''+4'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 104, 0, ''' fh_str '_fs'' }); '])
eval([ 'fs_itemp2 = uimenu( fs_item, ''Label'', ''+2'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 102, 0, ''' fh_str '_fs'' }); '])
eval([ 'fs_itemp1 = uimenu( fs_item, ''Label'', ''+1'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 101, 0, ''' fh_str '_fs'' }); '])
eval([ 'fs_itemm1 = uimenu( fs_item, ''Label'', ''-1'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', -101, 0, ''' fh_str '_fs'' }, ''Separator'', ''on''); '])
eval([ 'fs_itemm2 = uimenu( fs_item, ''Label'', ''-2'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', -102, 0, ''' fh_str '_fs'' }); '])
eval([ 'fs_itemm4 = uimenu( fs_item, ''Label'', ''-4'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', -104, 0, ''' fh_str '_fs'' }); '])
eval([ 'fs_itemm8 = uimenu( fs_item, ''Label'', ''-8'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', -108, 0, ''' fh_str '_fs'' }); '])
eval([ 'fs_item1 = uimenu( fs_item, ''Label'', ''10'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 10, 0, ''' fh_str '_fs'' }, ''Separator'', ''on''); '])
eval([ 'fs_item2 = uimenu( fs_item, ''Label'', ''15'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 15, 0, ''' fh_str '_fs'' }); '])
eval([ 'fs_item3 = uimenu( fs_item, ''Label'', ''20'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 20, 0, ''' fh_str '_fs'' }); '])

eval([ 'fw_item1 = uimenu( fw_item, ''Label'', ''normal'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontWeight'', ''normal'', 0, ''' fh_str '_fw'' }); '])
eval([ 'fw_item2 = uimenu( fw_item, ''Label'', ''light'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontWeight'', ''light'', 0, ''' fh_str '_fw'' }); '])
eval([ 'fw_item3 = uimenu( fw_item, ''Label'', ''demi'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontWeight'', ''demi'', 0, ''' fh_str '_fw'' }); '])
eval([ 'fw_item4 = uimenu( fw_item, ''Label'', ''bold'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontWeight'', ''bold'', 0, ''' fh_str '_fw'' }); '])

eval([ 'fa_item1 = uimenu( fa_item, ''Label'', ''normal'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontAngle'', ''normal'', 0, ''' fh_str '_fa'' }); '])
eval([ 'fa_item2 = uimenu( fa_item, ''Label'', ''italic'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontAngle'', ''italic'', 0, ''' fh_str '_fa'' }); '])
eval([ 'fa_item3 = uimenu( fa_item, ''Label'', ''oblique'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontAngle'', ''oblique'', 0, ''' fh_str '_fa'' }); '])

if ~strcmp(fh_str,'xlab') && ~strcmp(fh_str,'title') && ~strcmp(fh_str,'mat_title') && ~strcmp(fh_str,'mat_label') && ~strcmp(fh_str,'measure_label') && ~strcmp(fh_str,'synf_title') && ~strcmp(fh_str,'synf_label') && numel(dummy(dummy>0))>1
    eval([ 'fcol_all_item1 = uimenu( fcol_all_item, ''Label'', ''black'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''k'', 1, ''' fh_str '_col'' }); '])
    eval([ 'fcol_all_item2 = uimenu( fcol_all_item, ''Label'', ''blue'', ''ForegroundColor'', ''blue'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''b'', 1, ''' fh_str '_col'' }); '])
    eval([ 'fcol_all_item3 = uimenu( fcol_all_item, ''Label'', ''red'', ''ForegroundColor'', ''red'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''r'', 1, ''' fh_str '_col'' }); '])
    eval([ 'fcol_all_item4 = uimenu( fcol_all_item, ''Label'', ''green'', ''ForegroundColor'', ''green'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''g'', 1, ''' fh_str '_col'' }); '])
    eval([ 'fcol_all_item5 = uimenu( fcol_all_item, ''Label'', ''cyan'', ''ForegroundColor'', ''cyan'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''c'', 1, ''' fh_str '_col'' }); '])
    eval([ 'fcol_all_item6 = uimenu( fcol_all_item, ''Label'', ''magenta'', ''ForegroundColor'', ''magenta'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''m'', 1, ''' fh_str '_col'' }); '])
    eval([ 'fcol_all_item7 = uimenu( fcol_all_item, ''Label'', ''yellow'', ''ForegroundColor'', ''yellow'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''y'', 1, ''' fh_str '_col'' }); '])
    eval([ 'fcol_all_item8 = uimenu( fcol_all_item, ''Label'', ''white'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Color'', ''w'', 1, ''' fh_str '_col'' }); '])
    eval([ 'fcol_all_item9 = uimenu( fcol_all_item, ''Label'', ''invisible'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''Visible'', ''off'', 1, ''' fh_str '_vis'', ''Separator'', ''on'' }); '])

    eval([ 'fs_all_itemp8 = uimenu( fs_all_item, ''Label'', ''+8'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 108, 1, ''' fh_str '_fs'' }); '])
    eval([ 'fs_all_itemp4 = uimenu( fs_all_item, ''Label'', ''+4'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 104, 1, ''' fh_str '_fs'' }); '])
    eval([ 'fs_all_itemp2 = uimenu( fs_all_item, ''Label'', ''+2'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 102, 1, ''' fh_str '_fs'' }); '])
    eval([ 'fs_all_itemp1 = uimenu( fs_all_item, ''Label'', ''+1'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 101, 1, ''' fh_str '_fs'' }); '])
    eval([ 'fs_all_itemm1 = uimenu( fs_all_item, ''Label'', ''-1'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', -101, 1, ''' fh_str '_fs'' }, ''Separator'', ''on''); '])
    eval([ 'fs_all_itemm2 = uimenu( fs_all_item, ''Label'', ''-2'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', -102, 1, ''' fh_str '_fs'' }); '])
    eval([ 'fs_all_itemm4 = uimenu( fs_all_item, ''Label'', ''-4'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', -104, 1, ''' fh_str '_fs'' }); '])
    eval([ 'fs_all_itemm8 = uimenu( fs_all_item, ''Label'', ''-8'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', -108, 1, ''' fh_str '_fs'' }); '])
    eval([ 'fs_all_item1 = uimenu( fs_all_item, ''Label'', ''10'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 10, 1, ''' fh_str '_fs'' }, ''Separator'', ''on''); '])
    eval([ 'fs_all_item2 = uimenu( fs_all_item, ''Label'', ''15'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 15, 1, ''' fh_str '_fs'' }); '])
    eval([ 'fs_all_item3 = uimenu( fs_all_item, ''Label'', ''20'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontSize'', 20, 1, ''' fh_str '_fs'' }); '])

    eval([ 'fw_all_item1 = uimenu( fw_all_item, ''Label'', ''normal'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontWeight'', ''normal'', 1, ''' fh_str '_fw'' }); '])
    eval([ 'fw_all_item2 = uimenu( fw_all_item, ''Label'', ''light'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontWeight'', ''light'', 1, ''' fh_str '_fw'' }); '])
    eval([ 'fw_all_item3 = uimenu( fw_all_item, ''Label'', ''demi'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontWeight'', ''demi'', 1, ''' fh_str '_fw'' }); '])
    eval([ 'fw_all_item4 = uimenu( fw_all_item, ''Label'', ''bold'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontWeight'', ''bold'', 1, ''' fh_str '_fw'' }); '])

    eval([ 'fa_all_item1 = uimenu( fa_all_item, ''Label'', ''normal'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontAngle'', ''normal'', 1, ''' fh_str '_fa'' }); '])
    eval([ 'fa_all_item2 = uimenu( fa_all_item, ''Label'', ''italic'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontAngle'', ''italic'', 1, ''' fh_str '_fa'' }); '])
    eval([ 'fa_all_item3 = uimenu( fa_all_item, ''Label'', ''oblique'', ''Callback'', { @SPIKY_handle_change_property, handles,' fh_str '_fh, ''FontAngle'', ''oblique'', 1, ''' fh_str '_fa'' }); '])
end