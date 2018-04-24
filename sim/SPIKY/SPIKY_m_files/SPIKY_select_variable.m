% This function allows to select the variable / field of a Matlab-file that contains the spikes to be loaded into SPIKY.

function SPIKY_select_variable(hObject, data, handles)

default_variable=data.default_variable;
%data=rmfield(data,'default_variable');
content=data.content;
if ~isfield(data,'content')
    data.content='desired values';
end
%data=rmfield(data,'content');
if isfield(data,'matfile')
    data=load(data.matfile);
    fields=fieldnames(orderfields(data));
else
    data=[];
    fields=evalin('base','who');
    for fic=1:length(fields)
        dummy=evalin('base',char(fields{fic}));
        eval(['data.',fields{fic},'=dummy;'])
    end
end

SSVN.fig = figure('Units','normalized','menubar','none','Position',[0.15 0.15 0.7 0.7],'Name','Name of variable / field','NumberTitle','off',...
     'Color',[0.9294 0.9176 0.851],'DeleteFcn',{@SPIKY_select_variable_Close},'WindowStyle','modal','UserData','');
uicontrol('style','text','Units','normalized','Position',[0.1 0.89 0.8 0.05],'FontWeight','bold','FontSize',16,...
    'String','Please select the name of the variable / field:')
uicontrol('style','text','Units','normalized','Position',[0.1 0.84 0.8 0.05],'FontWeight','bold','FontSize',16,...
    'String',['that contains the ',content,':'])
SSVN.lb=uicontrol('style','listbox','Units','normalized','Position',[0.08 0.3 0.32 0.5],'FontSize',10,...
    'BackgroundColor','w','String','','Min',1,'Max',1,'HorizontalAlignment','center',...
    'Value',1,'CallBack',{@SPIKY_select_variable_lb_callback});
SSVN.lb2=uicontrol('style','listbox','Units','normalized','Position',[0.41 0.3 0.32 0.5],'FontSize',10,...
    'BackgroundColor','w','String','','Min',1,'Max',1,'HorizontalAlignment','center',...
    'Value',1,'Enable','off');
SSVN.back_pb=uicontrol('style','pushbutton','Units','normalized','Position',[0.75 0.75 0.17 0.05],'String','Back','FontSize',16,...
    'BackgroundColor',[0.8353 0.8235 0.7922],'callback',{@Back_pushbutton_callback},'Enable','off');
SSVN.reset_pb=uicontrol('style','pushbutton','Units','normalized','Position',[0.75 0.67 0.17 0.05],'String','Reset','FontSize',16,...
    'BackgroundColor',[0.8353 0.8235 0.7922],'callback',{@Reset_pushbutton_callback},'Enable','off');
SSVN.load_pb=uicontrol('style','pushbutton','Units','normalized','Position',[0.75 0.55 0.17 0.05],'String','Load other file','FontSize',16,...
    'BackgroundColor',[0.8353 0.8235 0.7922],'callback',{@Load_pushbutton_callback});
SSVN.variable_edit=uicontrol('style','edit','Units','normalized','Position',[0.06 0.2 0.88 0.06],...
    'String',default_variable,'FontSize',16,'FontWeight','bold','BackgroundColor','w');
SSVN.cancel_pb=uicontrol('style','pushbutton','Units','normalized','Position',[0.2 0.08 0.25 0.06],'String','Cancel','FontSize',16,...
    'BackgroundColor',[0.8353 0.8235 0.7922],'callback',{@Cancel_pushbutton_callback});
SSVN.OK_pb=uicontrol('style','pushbutton','Units','normalized','Position',[0.55 0.08 0.25 0.06],'String','OK','FontSize',16,...
    'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'callback',{@OK_pushbutton_callback});

level=0;
level2=0;
f_get_struct(fields,'')
if length(fields)==1
    set(SSVN.variable_edit,'String',fields{1})
end
uicontrol(SSVN.lb)
uiwait(gcf);

    function SPIKY_select_variable_lb_callback(varargin)
        edit_str=get(SSVN.variable_edit,'String');
        level2=length(find(edit_str=='.'));
        lb_str=get(SSVN.lb,'String');
        lb_str2=get(SSVN.lb2,'String');
        lb_val=get(SSVN.lb,'Value');
        set(SSVN.lb2,'Value',lb_val)
        if isempty(edit_str)
            vari=char(lb_str(lb_val));
        else
            if level>0 && level2==level
                lp=find(edit_str=='.',1,'last');
                vari=[edit_str(1:lp),char(lb_str(lb_val))];
            elseif level2==level
                vari=char(lb_str(lb_val));
            else
                vari=[edit_str,'.',char(lb_str(lb_val))];
            end
        end
        vari_type=char(lb_str2(lb_val));
        set(SSVN.variable_edit,'String',vari)
        %size(eval(['data.',vari]))
        if isstruct(eval(['data.',vari]))
            eval(['fields=fieldnames(orderfields(data.',vari,'));'])
            f_get_struct(fields,vari_type)
            if ~isempty(fields)
                level=level+1;
                if level==1
                    set(SSVN.back_pb,'Enable','on')
                    set(SSVN.reset_pb,'Enable','on')
                end
            end
            %data=data.(vari);
        end
    end

    function [] = f_get_struct(fields,vari_type)
        edit_str=get(SSVN.variable_edit,'String');
        if ~isempty(edit_str)
            edit_str=[edit_str,'.'];
        end
        if ~isempty(fields)
            num_fields=length(fields);
            lb_str2=cell(1,num_fields);
            arra=any(strfind(vari_type,'array'));
            for fc=1:num_fields
                stru=isstruct(eval(['data.',edit_str,fields{fc}]));
                cel=iscell(eval(['data.',edit_str,fields{fc}]));
                cha=ischar(eval(['data.',edit_str,fields{fc}]));
                siz=size(eval(['data.',edit_str,fields{fc}]));
                arr=prod(siz);
                siz_str=regexprep(num2str(siz),'\s+','-');
                if stru
                    if arr>1
                        lb_str2{fc}=['Struct array  ',siz_str];
                    else
                        lb_str2{fc}=['Struct   ',siz_str];
                    end
                elseif cel
                    lb_str2{fc}=['Cell   ',siz_str];
                elseif cha
                    if arra
                        lb_str2{fc}=['String field   (within ',vari_type,')'];
                    else
                        lb_str2{fc}=['String   ',siz_str];
                    end
                elseif length(siz)==2 && any(siz==1)
                    if arra
                        lb_str2{fc}=['Vector field   (within ',vari_type,')'];
                    else
                        lb_str2{fc}=['Vector   ',siz_str];
                    end
                else
                    if arra
                        lb_str2{fc}=['Matrix field   (within ',vari_type,')'];
                    else
                        lb_str2{fc}=['Matrix   ',siz_str];
                    end
                end
            end
            set(SSVN.lb2,'String',lb_str2,'Value',1)
        else
            set(SSVN.lb2,'String','','Value',1)
        end
        set(SSVN.lb,'String',fields,'Value',1)
    end

    function [] = Back_pushbutton_callback(varargin)
        edit_str=get(SSVN.variable_edit,'String');
        lp=find(edit_str=='.',1,'last');
        if ~isempty(lp)
            vari=edit_str(1:lp-1);
            if level>0 && level2==level
                lp=find(vari=='.',1,'last');
                if ~isempty(lp)
                    vari=edit_str(1:lp-1);
                    set(SSVN.variable_edit,'String',vari)
                    eval(['fields=fieldnames(orderfields(data.',vari,'));'])
                    f_get_struct(fields,'') % $$$$$$$ vari_type
                    level=level-1;
                else
                    fields=fieldnames(orderfields(data));
                    set(SSVN.variable_edit,'String','')
                    f_get_struct(fields,'')
                    set(SSVN.back_pb,'Enable','off')
                    set(SSVN.reset_pb,'Enable','off')
                    level=0;
                end
            else
                set(SSVN.variable_edit,'String',vari)
                eval(['fields=fieldnames(orderfields(data.',vari,'));'])
                f_get_struct(fields,'')
                level=level-1;
            end
        else
            fields=fieldnames(orderfields(data));
            set(SSVN.variable_edit,'String','')
            f_get_struct(fields,'')
            set(SSVN.back_pb,'Enable','off')
            set(SSVN.reset_pb,'Enable','off')
            level=0;
        end
    end

    function [] = Reset_pushbutton_callback(varargin)
        fields=fieldnames(orderfields(data));
        set(SSVN.variable_edit,'String','')
        f_get_struct(fields,'')
        set(SSVN.back_pb,'Enable','off')
        set(SSVN.reset_pb,'Enable','off')
        level=0;
    end

    function [] = Load_pushbutton_callback(varargin)
        [d_para.filename,d_para.path]=uigetfile('*.mat','Pick a .mat-file');
        if isequal(d_para.filename,0) || isequal(d_para.path,0)
            return
        end
        dummy=[d_para.path d_para.filename];
        if ~isequal(dummy,0)
            %d_para.matfile=dummy;
            data=load(dummy);
            level=0;
            level2=0;
            fields=fieldnames(orderfields(data));
            set(SSVN.variable_edit,'String','')
            f_get_struct(fields,'')
            set(SSVN.back_pb,'Enable','off')
            set(SSVN.reset_pb,'Enable','off')
        end
    end

    function [] = Cancel_pushbutton_callback(varargin)
        close(SSVN.fig)
    end

    function [] = OK_pushbutton_callback(varargin)
        variable=get(SSVN.variable_edit,'String');
        if isempty(variable)
            set(0,'DefaultUIControlFontSize',16);
            mbh=msgbox('Variable does not exist!','Warning','warn','modal');
            htxt = findobj(mbh,'Type','text');
            set(htxt,'FontSize',12,'FontWeight','bold')
            mb_pos=get(mbh,'Position');
            set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.3 mb_pos(4)])
            uiwait(mbh);
            return
        end
        %variable=variable_str_in;
        set(SSVN.fig,'UserData',variable)
        delete(SSVN.fig)
    end

    function SPIKY_select_variable_Close(varargin)
        if ~isempty(get(SSVN.fig,'UserData'))
            setappdata(handles.figure1,'variable',get(SSVN.fig,'UserData'));
            setappdata(handles.figure1,'data',data);
        else
            setappdata(handles.figure1,'variable','A9ZB1YC8X');
        end
        delete(gcbf)
    end
end
