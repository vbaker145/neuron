% This doublechecks all inputs made in the SPIKY panel 'Selection: Plots'

ret=0;

tmin_str_in=get(handles.fpara_tmin_edit,'String');
tmin_in=str2double(regexprep(tmin_str_in,f_para.regexp_str_scalar_float,''));
if ~isempty(tmin_in)
    tmin_str_out=num2str(tmin_in(1));
else
    tmin_str_out='';
end

tmax_str_in=get(handles.fpara_tmax_edit,'String');
tmax_in=str2double(regexprep(tmax_str_in,f_para.regexp_str_scalar_float,''));
if ~isempty(tmin_in)
    tmax_in=tmax_in(tmax_in>tmin_in);
end
if ~isempty(tmax_in)
    tmax_str_out=num2str(tmax_in(1));
else
    tmax_str_out='';
end

x_offset_str_in=get(handles.fpara_x_offset_edit,'String');
x_offset_in=str2double(regexprep(x_offset_str_in,f_para.regexp_str_scalar_float,''));
if ~isempty(x_offset_in)
    x_offset_str_out=num2str(x_offset_in(1));
else
    x_offset_str_out='';
end

x_scale_str_in=get(handles.fpara_x_scale_edit,'String');
x_scale_in=abs(str2double(regexprep(x_scale_str_in,f_para.regexp_str_scalar_float,'')));
x_scale_in=x_scale_in(x_scale_in>0);
if ~isempty(x_scale_in)
    x_scale_str_out=num2str(x_scale_in(1));
else
    x_scale_str_out='';
end

mao_str_in=get(handles.fpara_mao_edit,'String');
mao_in=abs(round(str2double(regexprep(mao_str_in,f_para.regexp_str_scalar_integer,''))));
mao_in=mao_in(mao_in>0);
if ~isempty(mao_in)
    mao_str_out=num2str(mao_in(1));
else
    mao_str_out='';
end

psth_window_str_in=get(handles.fpara_psth_window_edit,'String');
psth_window_in=abs(round(str2double(regexprep(psth_window_str_in,f_para.regexp_str_scalar_integer,''))));
psth_window_in=psth_window_in(psth_window_in>=0);
if ~isempty(psth_window_in)
    psth_window_str_out=num2str(psth_window_in(1));
else
    psth_window_str_out='';
end

f_para.select_train_mode=get(handles.fpara_select_train_mode_popupmenu,'Value');
if f_para.select_train_mode==2
    select_trains_str_in=regexprep(get(handles.fpara_trains_edit,'String'),'\s+',' ');
    select_trains_str_out=regexprep(num2str(SPIKY_f_unique_not_sorted(round(abs(str2num(regexprep(select_trains_str_in,f_para.regexp_str_vector_integers,'')))))),'\s+',' ');
elseif f_para.select_train_mode==3
    select_train_groups_str_in=regexprep(get(handles.fpara_train_groups_edit,'String'),'\s+',' ');
    select_train_groups_str_out=regexprep(num2str(SPIKY_f_unique_not_sorted(round(abs(str2num(regexprep(select_train_groups_str_in,f_para.regexp_str_vector_integers,'')))))),'\s+',' ');
end

interval_divisions_str_in=regexprep(get(handles.dpara_interval_divisions_edit,'String'),'\s+',' ');
interval_divisions=unique(str2num(regexprep(interval_divisions_str_in,f_para.regexp_str_vector_floats,'')));
interval_divisions=interval_divisions(interval_divisions>=d_para.tmin & interval_divisions<=d_para.tmax);
interval_divisions_str_out=regexprep(num2str(interval_divisions),'\s+',' ');

if ~strcmp(tmin_str_in,tmin_str_out) || ~strcmp(tmax_str_in,tmax_str_out) || ...
        ~strcmp(x_offset_str_in,x_offset_str_out) || ~strcmp(x_scale_str_in,x_scale_str_out) || ...
        ~strcmp(mao_str_in,mao_str_out) || ~strcmp(psth_window_str_in,psth_window_str_out) ||...
        (f_para.select_train_mode==2 && ~strcmp(select_trains_str_in,select_trains_str_out)) ||...
        (f_para.select_train_mode==3 && ~strcmp(select_train_groups_str_in,select_train_groups_str_out)) || ...
        ~strcmp(interval_divisions_str_in,interval_divisions_str_out)
    
    if ~isempty(tmin_str_out)
        set(handles.fpara_tmin_edit,'String',tmin_str_out)
    else
        set(handles.fpara_tmin_edit,'String',num2str(f_para.tmin))
    end

    if ~isempty(tmax_str_out)
        set(handles.fpara_tmax_edit,'String',tmax_str_out)
    else
        set(handles.fpara_tmax_edit,'String',num2str(f_para.tmax))
    end
    
    if ~isempty(x_offset_str_out)
        set(handles.fpara_x_offset_edit,'String',x_offset_str_out)
    else
        set(handles.fpara_x_offset_edit,'String',num2str(f_para.x_offset))
    end

    if ~isempty(x_scale_str_out)
        set(handles.fpara_x_scale_edit,'String',x_scale_str_out)
    else
        set(handles.fpara_x_scale_edit,'String',num2str(f_para.x_scale))
    end
    
    if ~isempty(mao_str_out)
        set(handles.fpara_mao_edit,'String',mao_str_out)
    else
        set(handles.fpara_mao_edit,'String',num2str(f_para.mao))
    end
    
    if ~isempty(psth_window_str_out)
        set(handles.fpara_psth_window_edit,'String',psth_window_str_out)
    else
        set(handles.fpara_psth_window_edit,'String',num2str(f_para.psth_window))
    end
    
    if f_para.select_train_mode==2
        if ~isempty(select_trains_str_out)
            set(handles.fpara_trains_edit,'String',select_trains_str_out)
        else
            set(handles.fpara_trains_edit,'String',regexprep(num2str(f_para.select_trains),'\s+',' '))
        end
    elseif f_para.select_train_mode==3
        if ~isempty(select_train_groups_str_out)
            set(handles.fpara_train_groups_edit,'String',select_train_groups_str_out)
        else
            set(handles.fpara_train_groups_edit,'String',regexprep(num2str(f_para.select_train_groups),'\s+',' '))
        end
    end

    if strcmp(interval_divisions_str_in,interval_divisions_str_out) || ~isempty(interval_divisions_str_out)
        set(handles.dpara_interval_divisions_edit,'String',interval_divisions_str_out)
    else
        set(handles.dpara_interval_divisions_edit,'String',regexprep(num2str(d_para.interval_divisions),'\s+',' '))
    end
    
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox('The input has been corrected !','Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.3 mb_pos(4)])
    uiwait(mbh);
    ret=1;
    return
end

if str2double(get(handles.fpara_tmin_edit,'String'))>=str2double(get(handles.fpara_tmax_edit,'String'))
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('The beginning of the analysis window can not be later\nthan the end of the analysis window!'),'Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    set(handles.fpara_tmin_edit,'String',num2str(f_para.tmin))
    set(handles.fpara_tmax_edit,'String',num2str(f_para.tmax))
    ret=1;
    return
end
if str2double(get(handles.fpara_tmin_edit,'String'))<str2double(get(handles.dpara_tmin_edit,'String'))
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('The beginning of the analysis window can not be earlier\nthan the beginning of the recording!'),'Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    set(handles.fpara_tmin_edit,'String',num2str(d_para.tmin))
    ret=1;
    return
end
if str2double(get(handles.fpara_tmax_edit,'String'))>str2double(get(handles.dpara_tmax_edit,'String'))
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('The end of the analysis window can not be later\nthan the end of the recording!'),'Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    set(handles.fpara_tmax_edit,'String',num2str(d_para.tmax))
    ret=1;
    return
end
if get(handles.fpara_select_train_mode_popupmenu,'Value')==2 && ~isnumeric(str2num(get(handles.fpara_trains_edit,'String')))
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('Please select individual spike trains\nor select all spike trains!'),'Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    %set(handles.fpara_select_train_mode_popupmenu,'Value',1)
    set(handles.fpara_trains_edit,'String',[])   % ,'Enable','off'
    ret=1;
    return
end
if get(handles.fpara_select_train_mode_popupmenu,'Value')==3 && ~isnumeric(str2num(get(handles.fpara_train_groups_edit,'String')))
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('Please select spike train groups\nor select all spike trains!'),'Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    %set(handles.fpara_select_train_mode_popupmenu,'Value',1)
    set(handles.fpara_train_groups_edit,'String',[])   % ,'Enable','off'
    ret=1;
    return
end

if isfield(results,'matrices')
    results=rmfield(results,'matrices');
end
if isfield(results,'group_matrices')
    results=rmfield(results,'group_matrices');
end
if isfield(results,'dendros')
    results=rmfield(results,'dendros');
end
if isfield(results,'group_dendros')
    results=rmfield(results,'group_dendros');
end

