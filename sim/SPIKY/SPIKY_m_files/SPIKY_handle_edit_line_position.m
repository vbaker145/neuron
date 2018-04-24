% This function which is called by 'SPIKY_handle_line.m' allows changing the position of certain lines
% (such as markers and separators) in the figure.


function [] = SPIKY_handle_edit_line_position(varargin)

co=gco;

if strcmp(varargin{5},'thick_mar') || strcmp(varargin{5},'thin_mar')
    posi=get(gco,'XData');
    old_pos=posi(1);
elseif strcmp(varargin{5},'thick_sep') || strcmp(varargin{5},'thin_sep')
    posi=get(gco,'YData');
    old_pos=posi(1);
end

Edit_fig = figure('units','normalized','menubar','none','position',[0.35 0.4 0.3 0.2],'Name','Edit position','NumberTitle','off',...
    'Color',[0.9294 0.9176 0.851],'WindowStyle','modal');
uicontrol('style','text','units','normalized','position',[0.25 0.7 0.5 0.15],'string','Please edit position:','FontSize',14,...
    'FontWeight','bold')
String_Edit=uicontrol('style','edit','units','normalized','position',[0.15 0.45 0.7 0.2],'string',num2str(old_pos),'FontSize',14,...
    'FontWeight','bold','BackgroundColor','w');
uicontrol('style','pushbutton','units','normalized','position',[0.2 0.125 0.25 0.2],'string','Cancel','FontSize',16,...
    'BackgroundColor',[0.8353 0.8235 0.7922],'callback',{@Cancel_pushbutton_callback});
Edit_pushbutton = uicontrol('style','pushbutton','units','normalized','position',[0.55 0.125 0.25 0.2],'string','OK','FontSize',16,...
    'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'callback',{@Edit_pushbutton_callback, co, varargin{5}});

uicontrol(Edit_pushbutton)

    function [] = Cancel_pushbutton_callback(varargin)
        close(Edit_fig)
    end

    function [] = Edit_pushbutton_callback(varargin)
        new_pos=str2double(get(String_Edit,'String'));
        if strcmp(varargin{4},'thick_mar') || strcmp(varargin{4},'thin_mar')
            set(varargin{3},'XData',new_pos*ones(1,2))
        elseif strcmp(varargin{4},'thick_sep') || strcmp(varargin{4},'thin_sep')
            set(varargin{3},'YData',new_pos*ones(1,2))
        end
        close(Edit_fig)
    end

end
