% This doublechecks all inputs made in the SPIKY panel 'Parameters: Data'

ret=0;

tmin_str_in=get(handles.dpara_tmin_edit,'String');
tmin_in=str2double(regexprep(tmin_str_in,f_para.regexp_str_scalar_float,''));
if ~isempty(tmin_in)
    tmin_str_out=num2str(tmin_in(1));
else
    tmin_str_out='';
end

tmax_str_in=get(handles.dpara_tmax_edit,'String');
tmax_in=str2double(regexprep(tmax_str_in,f_para.regexp_str_scalar_float,''));
if ~isempty(tmax_in)
    tmax_str_out=num2str(tmax_in(1));
else
    tmax_str_out='';
end

dts_str_in=get(handles.dpara_dts_edit,'String');
dts_in=abs(str2double(regexprep(dts_str_in,f_para.regexp_str_scalar_float,'')));
if ~isempty(dts_in)
    dts_str_out=num2str(dts_in(1));
else
    dts_str_out='';
end

thin_markers_str_in=regexprep(get(handles.dpara_thin_markers_edit,'String'),'\s+',' ');
thin_markers=unique(str2num(regexprep(thin_markers_str_in,f_para.regexp_str_vector_floats,'')));
thin_markers=thin_markers(thin_markers>=d_para.tmin & thin_markers<=d_para.tmax);
thin_markers_str_out=regexprep(num2str(thin_markers),'\s+',' ');
thick_markers_str_in=regexprep(get(handles.dpara_thick_markers_edit,'String'),'\s+',' ');
thick_markers=unique(str2num(regexprep(thick_markers_str_in,f_para.regexp_str_vector_floats,'')));
thick_markers=thick_markers(thick_markers>=d_para.tmin & thick_markers<=d_para.tmax);
thick_markers_str_out=regexprep(num2str(thick_markers),'\s+',' ');

d_para.select_train_mode=get(handles.dpara_select_train_mode_popupmenu,'Value');
if d_para.select_train_mode==2
    preselect_trains_str_in=regexprep(get(handles.dpara_trains_edit,'String'),'\s+',' ');
    preselect_trains_str_out=regexprep(num2str(SPIKY_f_unique_not_sorted(round(abs(str2num(regexprep(preselect_trains_str_in,f_para.regexp_str_vector_integers,'')))))),'\s+',' ');
elseif d_para.select_train_mode==3
    select_train_groups_str_in=regexprep(get(handles.dpara_train_groups_edit,'String'),'\s+',' ');
    select_train_groups_str_out=regexprep(num2str(SPIKY_f_unique_not_sorted(round(abs(str2num(regexprep(select_train_groups_str_in,f_para.regexp_str_vector_integers,'')))))),'\s+',' ');
end

thin_separators_str_in=regexprep(get(handles.dpara_thin_separators_edit,'String'),'\s+',' ');
thin_separators=unique(str2num(regexprep(thin_separators_str_in,f_para.regexp_str_vector_integers,'')));
thin_separators=thin_separators(thin_separators>0 & thin_separators<d_para.num_trains);
thin_separators_str_out=regexprep(num2str(thin_separators),'\s+',' ');
thick_separators_str_in=regexprep(get(handles.dpara_thick_separators_edit,'String'),'\s+',' ');
thick_separators=unique(str2num(regexprep(thick_separators_str_in,f_para.regexp_str_vector_integers,'')));
thick_separators=thick_separators(thick_separators>0 & thick_separators<d_para.num_trains);
thick_separators_str_out=regexprep(num2str(thick_separators),'\s+',' ');

group_sizes_str_in=regexprep(get(handles.dpara_group_sizes_edit,'String'),'\s+',' ');
group_sizes=str2num(regexprep(group_sizes_str_in,f_para.regexp_str_vector_integers,''));
group_sizes=group_sizes(group_sizes>0);
group_sizes(group_sizes>d_para.num_trains)=d_para.num_trains;
group_sizes_str_out=regexprep(num2str(group_sizes),'\s+',' ');

ds=strtrim(get(handles.dpara_group_names_edit,'String'));
if ~isempty(ds)
    if ds(end)~=';'
        ds=[ds,';'];
    end
    num_all_train_group_names=length(find(ds==';'));
    group_names=cell(1,num_all_train_group_names);
    for strc=1:num_all_train_group_names
        group_names{strc}=ds(1:find(ds==';',1,'first')-1);
        ds=ds(find(ds==';',1,'first')+2:end);
    end
else
    group_names='';
end


if ~strcmp(tmin_str_in,tmin_str_out) || ~strcmp(tmax_str_in,tmax_str_out) || ...
        (~strcmp(dts_str_in,dts_str_out) && str2double(dts_str_in)~=str2double(dts_str_out)) || ...
        ~strcmp(thin_markers_str_in,thin_markers_str_out) || ~strcmp(thick_markers_str_in,thick_markers_str_out) || ...
        (d_para.select_train_mode==2 && ~strcmp(preselect_trains_str_in,preselect_trains_str_out)) ||...
        (d_para.select_train_mode==3 && ~strcmp(select_train_groups_str_in,select_train_groups_str_out)) || ...
        ~strcmp(thin_separators_str_in,thin_separators_str_out) || ~strcmp(thick_separators_str_in,thick_separators_str_out) || ...
        ~strcmp(group_sizes_str_in,group_sizes_str_out)

    if ~isempty(tmin_str_out)
        set(handles.dpara_tmin_edit,'String',tmin_str_out)
    else
        set(handles.dpara_tmin_edit,'String',num2str(d_para.tmin))
    end

    if ~isempty(tmax_str_out)
        set(handles.dpara_tmax_edit,'String',tmax_str_out)
    else
        set(handles.dpara_tmax_edit,'String',num2str(d_para.tmax))
    end

    if ~isempty(dts_str_out)
        set(handles.dpara_dts_edit,'String',dts_str_out)
    else
        set(handles.dpara_dts_edit,'String',num2str(d_para.dts))
    end

    if strcmp(thin_markers_str_in,thin_markers_str_out) || ~isempty(thin_markers_str_out)
        set(handles.dpara_thin_markers_edit,'String',thin_markers_str_out)
    else
        set(handles.dpara_thin_markers_edit,'String',regexprep(num2str(d_para.thin_markers),'\s+',' '))
    end

    if strcmp(thick_markers_str_in,thick_markers_str_out) || ~isempty(thick_markers_str_out)
        set(handles.dpara_thick_markers_edit,'String',thick_markers_str_out)
    else
        set(handles.dpara_thick_markers_edit,'String',regexprep(num2str(d_para.thick_markers),'\s+',' '))
    end

    if d_para.select_train_mode==2
        if ~isempty(preselect_trains_str_out)
            set(handles.dpara_trains_edit,'String',preselect_trains_str_out)
        else
            set(handles.dpara_trains_edit,'String',regexprep(num2str(d_para.preselect_trains),'\s+',' '))
        end
    elseif d_para.select_train_mode==3
        if ~isempty(select_train_groups_str_out)
            set(handles.dpara_train_groups_edit,'String',select_train_groups_str_out)
        else
            set(handles.dpara_train_groups_edit,'String',regexprep(num2str(d_para.select_train_groups),'\s+',' '))
        end
    end

    if strcmp(thin_separators_str_in,thin_separators_str_out) || ~isempty(thin_separators_str_out)
        set(handles.dpara_thin_separators_edit,'String',thin_separators_str_out)
    else
        set(handles.dpara_thin_separators_edit,'String',regexprep(num2str(d_para.thin_separators),'\s+',' '))
    end

    if strcmp(thick_separators_str_in,thick_separators_str_out) || ~isempty(thick_separators_str_out)
        set(handles.dpara_thick_separators_edit,'String',thick_separators_str_out)
    else
        set(handles.dpara_thick_separators_edit,'String',regexprep(num2str(d_para.thick_separators),'\s+',' '))
    end

    if strcmp(group_sizes_str_in,group_sizes_str_out) || ~isempty(group_sizes_str_out)
        set(handles.dpara_group_sizes_edit,'String',group_sizes_str_out)
    else
        set(handles.dpara_group_sizes_edit,'String',regexprep(num2str(d_para.all_train_group_sizes),'\s+',' '))
    end

    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox('The input has been corrected !','Warning','warn','modal');
    htxt=findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.3 mb_pos(4)])
    uiwait(mbh);
    ret=1;
    return
end
tmin_in=str2double(tmin_str_in);
tmax_in=str2double(tmax_str_in);
dts_in=str2double(dts_str_in);

if tmin_in>=tmax_in
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('The beginning of the recording can not be later\nthan the end of the recording!'),'Warning','warn','modal');
    htxt=findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    set(handles.dpara_tmin_edit,'String',num2str(d_para.tmin))
    set(handles.dpara_tmax_edit,'String',num2str(d_para.tmax))
    return
end

if get(handles.dpara_select_train_mode_popupmenu,'Value')==2 && ~isnumeric(str2num(get(handles.dpara_trains_edit,'String')))
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('Please select individual spike trains or select all spike trains!'),'Warning','warn','modal');
    htxt=findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    set(handles.dpara_trains_edit,'String',[])
    return
end

if get(handles.dpara_select_train_mode_popupmenu,'Value')==3 && ~isnumeric(str2num(get(handles.dpara_train_groups_edit,'String')))
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('Please select spike train groups or select all spike trains!'),'Warning','warn','modal');
    htxt=findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    set(handles.dpara_train_groups_edit,'String',[])
    return
end

if d_para.num_all_trains==d_para.num_trains && ~isempty(group_sizes) && sum(group_sizes)~=d_para.num_trains   % ######### 
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('The group sizes must add up to the number of selected spike trains!'),'Warning','warn','modal');
    htxt=findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    set(handles.dpara_group_sizes_edit,'String',[])
    return
end

if length(group_sizes)~=length(group_names)
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('Number of group sizes must equal number of group names!'),'Warning','warn','modal');
    htxt=findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    set(handles.dpara_group_sizes_edit,'String',[])
    return
end

