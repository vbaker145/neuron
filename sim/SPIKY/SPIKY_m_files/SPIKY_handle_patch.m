% This function allows eliminating the color coding for spike train groups (used for example in the dendrograms).

eval([ 'vis_item = uimenu (' ph_str '_cmenu, ''Label'', ''invisible'', ''ForegroundColor'', ''black'', ''Callback'', { @SPIKY_handle_change_property,handles,' ph_str '_ph, ''Visible'', ''off'', 1, ''' ph_str '_vis'' }); '])

