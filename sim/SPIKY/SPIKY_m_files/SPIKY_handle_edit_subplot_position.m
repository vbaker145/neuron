% This function which is called by ?SPIKY_handle_subplot.m? allows changing the position of individual subplots in the figure.

function [] = SPIKY_handle_edit_subplot_position(varargin)

sph_str=varargin{5};
vara=gco;
posi=get(vara,'position');
f_para=getappdata(varargin{3}.figure1,'figure_parameters');

Edit_fig = figure('units','normalized','menubar','none','position',[0.35 0.25 0.3 0.5],'Name','Edit position','NumberTitle','off',...
    'Color',[0.9294 0.9176 0.851]); %,'WindowStyle','modal');
uicontrol('style','text','units','normalized','position',[0.1 0.81 0.8 0.1],'FontWeight','bold','FontSize',18,...
    'string','Please edit position (normalized units):')
    %'string',['Please edit position of subplot #',num2str(sp_posi),':'])
uicontrol('style','text','units','normalized','position',[0.12 0.65 0.25 0.1],'string','X-Position:','FontSize',16,'HorizontalAlignment','left');
xpos_edit=uicontrol('style','edit','units','normalized','position',[0.48 0.69 0.4 0.08],'string',num2str(posi(1)),'FontSize',16,...
    'FontWeight','bold','BackgroundColor','w');
uicontrol('style','text','units','normalized','position',[0.12 0.53 0.25 0.1],'string','Y-Position:','FontSize',16,'HorizontalAlignment','left');
ypos_edit=uicontrol('style','edit','units','normalized','position',[0.48 0.57 0.4 0.08],'string',num2str(posi(2)),'FontSize',16,...
    'FontWeight','bold','BackgroundColor','w');
uicontrol('style','text','units','normalized','position',[0.12 0.41 0.25 0.1],'string','Width:','FontSize',16,'HorizontalAlignment','left');
width_edit=uicontrol('style','edit','units','normalized','position',[0.48 0.45 0.4 0.08],'string',num2str(posi(3)),'FontSize',16,...
    'FontWeight','bold','BackgroundColor','w');
uicontrol('style','text','units','normalized','position',[0.12 0.29 0.25 0.1],'string','Height:','FontSize',16,'HorizontalAlignment','left');
height_edit=uicontrol('style','edit','units','normalized','position',[0.48 0.33 0.4 0.08],'string',num2str(posi(4)),'FontSize',16,...
    'FontWeight','bold','BackgroundColor','w');
uicontrol('style','pushbutton','units','normalized','position',[0.2 0.1 0.25 0.1],'string','Cancel','FontSize',16,...
    'BackgroundColor',[0.8353 0.8235 0.7922],'callback',{@Cancel_pushbutton_callback});
Edit_pushbutton = uicontrol('style','pushbutton','units','normalized','position',[0.55 0.1 0.25 0.1],'string','OK','FontSize',16,...
    'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'callback',{@Edit_pushbutton_callback,varargin{3},vara});

uicontrol(Edit_pushbutton)

    function [] = Cancel_pushbutton_callback(varargin)
        close(Edit_fig)
    end

    function [] = Edit_pushbutton_callback(varargin)
        
        xpos_str_in=get(xpos_edit,'String');
        xpos_in=abs(str2double(regexprep(xpos_str_in,f_para.regexp_str_scalar_float,'')));
        if ~isempty(xpos_in)
            xpos_str_out=num2str(xpos_in(1));
        else
            xpos_str_out='';
        end
        ypos_str_in=get(ypos_edit,'String');
        ypos_in=abs(str2double(regexprep(ypos_str_in,f_para.regexp_str_scalar_float,'')));
        if ~isempty(ypos_in)
            ypos_str_out=num2str(ypos_in(1));
        else
            ypos_str_out='';
        end
        width_str_in=get(width_edit,'String');
        width_in=abs(str2double(regexprep(width_str_in,f_para.regexp_str_scalar_float,'')));
        if ~isempty(width_in)
            width_str_out=num2str(width_in(1));
        else
            width_str_out='';
        end
        height_str_in=get(height_edit,'String');
        height_in=abs(str2double(regexprep(height_str_in,f_para.regexp_str_scalar_float,'')));
        if ~isempty(height_in)
            height_str_out=num2str(height_in(1));
        else
            height_str_out='';
        end
        if ~strcmp(xpos_str_in,xpos_str_out) || ~strcmp(width_str_in,width_str_out) || ...
                ~strcmp(ypos_str_in,ypos_str_out) || ~strcmp(height_str_in,height_str_out)
            if ~isempty(xpos_str_out)
                set(xpos_edit,'String',xpos_str_out)
            else
                set(xpos_edit,'String',num2str(posi(1)))
            end
            if ~isempty(ypos_str_out)
                set(ypos_edit,'String',ypos_str_out)
            else
                set(ypos_edit,'String',num2str(posi(3)))
            end
            if ~isempty(width_str_out)
                set(width_edit,'String',width_str_out)
            else
                set(width_edit,'String',num2str(posi(2)))
            end
            if ~isempty(height_str_out)
                set(height_edit,'String',height_str_out)
            else
                set(height_edit,'String',num2str(posi(4)))
            end
            set(0,'DefaultUIControlFontSize',16);
            mbh=msgbox('The input has been corrected !','Warning','warn','modal');
            htxt = findobj(mbh,'Type','text');
            set(htxt,'FontSize',12,'FontWeight','bold')
            mb_pos=get(mbh,'Position');
            set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.3 mb_pos(4)])
            uiwait(mbh);
            return
        end
        
        new_pos=[str2double(get(xpos_edit,'String')) str2double(get(ypos_edit,'String')) str2double(get(width_edit,'String')) ...
            str2double(get(height_edit,'String'))];
        set(varargin{4},'Position',new_pos)
        
        h_para=getappdata(varargin{3}.figure1,'help_parameters');
        if ~strcmp(sph_str,'profs')
            sp_posi=find(ismember(round(h_para.supos/0.001)*0.001,round(posi/0.001)*0.001,'rows'));
            if ~isempty(sp_posi)
                h_para.supos(sp_posi,1:4)=new_pos;
            end
        else
            h_para.supo1=new_pos;
        end
        setappdata(varargin{3}.figure1,'help_parameters',h_para)
        close(Edit_fig)
    end

end
