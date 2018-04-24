% This doublechecks all inputs made in the SPIKY panel 'Selection: Measures'

ret=0;

stimulus_str_in=get(handles.subplot_stimulus_posi_edit,'String');
stimulus_in=unique(round(abs(str2num(regexprep(stimulus_str_in,f_para.regexp_str_scalar_integer,'')))));
if ~isempty(stimulus_in)
    stimulus_str_out=num2str(stimulus_in(1));
else
    stimulus_str_out='';
end

spikes_str_in=get(handles.subplot_spikes_posi_edit,'String');
spikes_in=unique(round(abs(str2num(regexprep(spikes_str_in,f_para.regexp_str_scalar_integer,'')))));
if ~isempty(spikes_in)
    spikes_str_out=num2str(spikes_in(1));
else
    spikes_str_out='';
end

isi_str_in=get(handles.subplot_isi_posi_edit,'String');
isi_in=unique(round(abs(str2num(regexprep(isi_str_in,f_para.regexp_str_scalar_integer,'')))));
if ~isempty(isi_in)
    isi_str_out=num2str(isi_in(1));
else
    isi_str_out='';
end

spike_str_in=get(handles.subplot_spike_posi_edit,'String');
spike_in=unique(round(abs(str2num(regexprep(spike_str_in,f_para.regexp_str_scalar_integer,'')))));
if ~isempty(spike_in)
    spike_str_out=num2str(spike_in(1));
else
    spike_str_out='';
end

spike_realtime_str_in=get(handles.subplot_spike_realtime_posi_edit,'String');
spike_realtime_in=unique(round(abs(str2num(regexprep(spike_realtime_str_in,f_para.regexp_str_scalar_integer,'')))));
if ~isempty(spike_realtime_in)
    spike_realtime_str_out=num2str(spike_realtime_in(1));
else
    spike_realtime_str_out='';
end

spike_forward_str_in=get(handles.subplot_spike_forward_posi_edit,'String');
spike_forward_in=unique(round(abs(str2num(regexprep(spike_forward_str_in,f_para.regexp_str_scalar_integer,'')))));
if ~isempty(spike_forward_in)
    spike_forward_str_out=num2str(spike_forward_in(1));
else
    spike_forward_str_out='';
end

instants_str_in=get(handles.dpara_instants_edit,'String');
if isempty(instants_str_in)
    instants_str_in='';
end
if exist(instants_str_in,'file')
    instants_str_out=instants_str_in;
else
    instants_str_out=regexprep(num2str(unique(str2num(regexprep(instants_str_in,f_para.regexp_str_vector_floats,'')))),'\s+',' ');
    if isempty(instants_str_out)
        instants_str_out='';
    end
end

selave_str_in=regexprep(get(handles.dpara_selective_averages_edit,'String'),'\s+',' ');
if isempty(selave_str_in)
    selave_str_in='';
end
if exist(selave_str_in,'file')
    selave_str_out=selave_str_in;
else
    selave_str_out=regexprep(regexprep(selave_str_in,f_para.regexp_str_cell_floats,''),'\s+',' ');
    if isempty(selave_str_out)
        selave_str_out='';
    end
end

trigave_str_in=regexprep(get(handles.dpara_triggered_averages_edit,'String'),'\s+',' ');
if isempty(trigave_str_in)
    trigave_str_in='';
end
if exist(trigave_str_in,'file')
    trigave_str_out=trigave_str_in;
else
    trigave_str_out=regexprep(regexprep(trigave_str_in,f_para.regexp_str_cell_floats,''),'\s+',' ');
    if isempty(trigave_str_out)
        trigave_str_out='';
    end
end

if ~strcmp(stimulus_str_in,stimulus_str_out) || ~strcmp(spikes_str_in,spikes_str_out) || ...
        ~strcmp(isi_str_in,isi_str_out) || ~strcmp(spike_str_in,spike_str_out) || ...
        ~strcmp(spike_realtime_str_in,spike_realtime_str_out) || ~strcmp(spike_forward_str_in,spike_forward_str_out) || ...
        ~strcmp(instants_str_in,instants_str_out) || ~strcmp(selave_str_in,selave_str_out) || ~strcmp(trigave_str_in,trigave_str_out)
    if ~isempty(stimulus_str_out)
        set(handles.subplot_stimulus_posi_edit,'String',stimulus_str_out)
    else
        set(handles.subplot_stimulus_posi_edit,'String',f_para.subplot_posi(1))
    end

    if ~isempty(spikes_str_out)
        set(handles.subplot_spikes_posi_edit,'String',spikes_str_out)
    else
        set(handles.subplot_spikes_posi_edit,'String',f_para.subplot_posi(2))
    end

    if ~isempty(isi_str_out)
        set(handles.subplot_isi_posi_edit,'String',isi_str_out)
    else
        set(handles.subplot_isi_posi_edit,'String',f_para.subplot_posi(3))
    end

    if ~isempty(spike_str_out)
        set(handles.subplot_spike_posi_edit,'String',spike_str_out)
    else
        set(handles.subplot_spike_posi_edit,'String',f_para.subplot_posi(4))
    end

    if ~isempty(spike_realtime_str_out)
        set(handles.subplot_spike_realtime_posi_edit,'String',spike_realtime_str_out)
    else
        set(handles.subplot_spike_realtime_posi_edit,'String',f_para.subplot_posi(5))
    end

    if ~isempty(spike_forward_str_out)
        set(handles.subplot_spike_forward_posi_edit,'String',spike_forward_str_out)
    else
        set(handles.subplot_spike_forward_posi_edit,'String',f_para.subplot_posi(6))
    end

    if strcmp(instants_str_in,instants_str_out) || ~isempty(instants_str_out)
        set(handles.dpara_instants_edit,'String',instants_str_out)
    else
        if isfield (d_para,'instants') && ~isempty(d_para.instants)
            instants_str=['[',regexprep(num2str(d_para.instants{trigc}),'\s+',' '),']'];
            set(handles.dpara_instants_edit,'String',instants_str);
        elseif ~isempty(d_para.instants_str)
            if d_para.instants_str(1)=='{'
                d_para.instants_str=d_para.instants_str(2:end);
            end
            if d_para.instants_str(end)=='}'
                d_para.instants_str=d_para.instants_str(1:end-1);
            end
            set(handles.dpara_instants_edit,'String',regexprep(d_para.instants_str,'\s+',' '),'Enable','on')
        else
            set(handles.dpara_instants_edit,'String','');
        end
    end
    
    

    if strcmp(selave_str_in,selave_str_out) || ~isempty(selave_str_out)
        set(handles.dpara_selective_averages_edit,'String',selave_str_out)
    else
        if isfield(d_para,'selective_averages') && ~isempty(d_para.selective_averages)
            sel_str=[];
            for selc=1:length(d_para.selective_averages)
                sel_str=[sel_str,'[',regexprep(num2str(d_para.selective_averages{selc}),'\s+',' '),']; '];
            end
            set(handles.dpara_selective_averages_edit,'String',sel_str);
        elseif ~isempty(d_para.selective_averages_str)
            if d_para.selective_averages_str(1)=='{'
                d_para.selective_averages_str=d_para.selective_averages_str(2:end);
            end
            if d_para.selective_averages_str(end)=='}'
                d_para.selective_averages_str=d_para.selective_averages_str(1:end-1);
            end
            set(handles.dpara_selective_averages_edit,'String',regexprep(d_para.selective_averages_str,'\s+',' '),'Enable','on')
        else
            set(handles.dpara_selective_averages_edit,'String','');
        end
    end

    if strcmp(trigave_str_in,trigave_str_out) || ~isempty(trigave_str_out)
        set(handles.dpara_triggered_averages_edit,'String',trigave_str_out)
    else
        if isfield (d_para,'triggered_averages') && ~isempty(d_para.triggered_averages)
            trig_str=[];
            for trigc=1:length(d_para.triggered_averages)
                trig_str=[trig_str,'[',regexprep(num2str(d_para.triggered_averages{trigc}),'\s+',' '),']; '];
            end
            set(handles.dpara_triggered_averages_edit,'String',trig_str);
        elseif ~isempty(d_para.triggered_averages_str)
            if d_para.triggered_averages_str(1)=='{'
                d_para.triggered_averages_str=d_para.triggered_averages_str(2:end);
            end
            if d_para.triggered_averages_str(end)=='}'
                d_para.triggered_averages_str=d_para.triggered_averages_str(1:end-1);
            end
            set(handles.dpara_triggered_averages_edit,'String',regexprep(d_para.triggered_averages_str,'\s+',' '),'Enable','on')
        else
            set(handles.dpara_triggered_averages_edit,'String','');
        end
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
