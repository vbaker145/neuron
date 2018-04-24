% This function which is called by several other functions allows changing properties
% (such as color, font weight, font angle, and font size) of matrix tick labels.
% It can be invoked by hovering above (not outside!) the very left part of the matrix subplot 
% and pressing the right mouse button.

eval([ 'fcol_item = uimenu (' fh_str '_cmenu, ''Label'', ''Color''); '])
eval([ 'fw_item = uimenu (' fh_str '_cmenu, ''Label'', ''FontWeight''); '])
eval([ 'fa_item = uimenu (' fh_str '_cmenu, ''Label'', ''FontAngle''); '])
eval([ 'fs_item = uimenu (' fh_str '_cmenu, ''Label'', ''FontSize''); '])

fcol_item1 = uimenu(fcol_item,'Label','black','ForegroundColor','black','Callback','set(gca,''XColor'',''k'',''YColor'',''k'')');
fcol_item2 = uimenu(fcol_item,'Label','blue','ForegroundColor','blue','Callback','set(gca,''XColor'',''b'',''YColor'',''b'')');
fcol_item3 = uimenu(fcol_item,'Label','red','ForegroundColor','red','Callback','set(gca,''XColor'',''r'',''YColor'',''r'')');
fcol_item4 = uimenu(fcol_item,'Label','green','ForegroundColor','green','Callback','set(gca,''XColor'',''g'',''YColor'',''g'')');
fcol_item5 = uimenu(fcol_item,'Label','cyan','ForegroundColor','cyan','Callback','set(gca,''XColor'',''c'',''YColor'',''c'')');
fcol_item6 = uimenu(fcol_item,'Label','magenta','ForegroundColor','magenta','Callback','set(gca,''XColor'',''m'',''YColor'',''m'')');
fcol_item7 = uimenu(fcol_item,'Label','yellow','ForegroundColor','yellow','Callback','set(gca,''XColor'',''y'',''YColor'',''y'')');
fcol_item8 = uimenu(fcol_item,'Label','white','ForegroundColor','black','Callback','set(gca,''XColor'',''w'',''YColor'',''w'')');
fcol_item9 = uimenu(fcol_item,'Label','invisible','ForegroundColor','black','Callback','set(gca,''Visible'',''off'')');

fw_item1 = uimenu(fw_item,'Label','normal','Callback','set(gca,''FontWeight'',''normal'')');
fw_item2 = uimenu(fw_item,'Label','light','Callback','set(gca,''FontWeight'',''light'')');
fw_item3 = uimenu(fw_item,'Label','demi','Callback','set(gca,''FontWeight'',''demi'')');
fw_item4 = uimenu(fw_item,'Label','bold','Callback','set(gca,''FontWeight'',''bold'')');

fa_item1 = uimenu(fa_item,'Label','normal','Callback','set(gca,''FontAngle'',''normal'')');
fa_item2 = uimenu(fa_item,'Label','italic','Callback','set(gca,''FontAngle'',''italic'')');
fa_item3 = uimenu(fa_item,'Label','oblique','Callback','set(gca,''FontAngle'',''oblique'')');

fs_itemm8 = uimenu(fs_item,'Label','-8','Callback','set(gca,''FontSize'',get(gca,''FontSize'')-8)');
fs_itemm4 = uimenu(fs_item,'Label','-4','Callback','set(gca,''FontSize'',get(gca,''FontSize'')-4)');
fs_itemm2 = uimenu(fs_item,'Label','-2','Callback','set(gca,''FontSize'',get(gca,''FontSize'')-2)');
fs_itemm1 = uimenu(fs_item,'Label','-1','Callback','set(gca,''FontSize'',get(gca,''FontSize'')-1)');
fs_itemp1 = uimenu(fs_item,'Label','+1','Callback','set(gca,''FontSize'',get(gca,''FontSize'')+1)','Separator','on');
fs_itemp2 = uimenu(fs_item,'Label','+2','Callback','set(gca,''FontSize'',get(gca,''FontSize'')+2)');
fs_itemp4 = uimenu(fs_item,'Label','+4','Callback','set(gca,''FontSize'',get(gca,''FontSize'')+4)');
fs_itemp8 = uimenu(fs_item,'Label','+8','Callback','set(gca,''FontSize'',get(gca,''FontSize'')+8)');
fs_item1 = uimenu(fs_item,'Label','10','Callback','set(gca,''FontSize'',10)','Separator','on');
fs_item2 = uimenu(fs_item,'Label','15','Callback','set(gca,''FontSize'',15)');
fs_item3 = uimenu(fs_item,'Label','20','Callback','set(gca,''FontSize'',20)');

