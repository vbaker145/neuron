% This function which is called by ?SPIKY_handle_font.m? allows changing the string of text objects
% (such as axis labels or subplot titles) in the figure.

function [] = SPIKY_handle_edit_string(varargin)

vara=varargin{4}(varargin{4}>0);

if length(vara)==1
    Edit_fig = figure('units','normalized','menubar','none','position',[0.35 0.4 0.3 0.2],'Name','Edit text','NumberTitle','off',...
        'Color',[0.9294 0.9176 0.851],'WindowStyle','modal');
    uicontrol('style','text','units','normalized','position',[0.25 0.7 0.5 0.15],'string','Please edit text:','FontSize',14,...
        'FontWeight','bold')
    String_Edit=uicontrol('style','edit','units','normalized','position',[0.15 0.45 0.7 0.2],'string',get(vara,'String'),'FontSize',14,...
        'FontWeight','bold','BackgroundColor','w');
    uicontrol('style','pushbutton','units','normalized','position',[0.2 0.125 0.25 0.2],'string','Cancel','FontSize',16,...
        'BackgroundColor',[0.8353 0.8235 0.7922],'callback',{@Cancel_pushbutton_callback});
    Edit_pushbutton = uicontrol('style','pushbutton','units','normalized','position',[0.55 0.125 0.25 0.2],'string','OK','FontSize',16,...
        'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'callback',{@Edit_pushbutton_callback,vara});
else
    Edit_fig = figure('units','normalized','menubar','none','position',[0.3 0.3 0.4 0.4],'Name','Edit text','NumberTitle','off',...
        'Color',[0.9294 0.9176 0.851],'WindowStyle','modal');
    uicontrol('style','text','units','normalized','position',[0.25 0.75 0.5 0.15],'string','Please edit text:','FontSize',16,...
        'FontWeight','bold')
    String_Edit=uicontrol('style','edit','units','normalized','position',[0.15 0.25 0.7 0.5],'string',get(vara,'String'),'FontSize',16,...
        'FontWeight','bold','BackgroundColor','w','min',0,'max',2);
    uicontrol('style','pushbutton','units','normalized','position',[0.2 0.075 0.25 0.1],'string','Cancel','FontSize',18,...
        'BackgroundColor',[0.8353 0.8235 0.7922],'callback',{@Cancel_pushbutton_callback});
    Edit_pushbutton = uicontrol('style','pushbutton','units','normalized','position',[0.55 0.075 0.25 0.1],'string','OK','FontSize',18,...
        'FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'callback',{@Edit_pushbutton_callback,vara});
end

uicontrol(Edit_pushbutton)

    function [] = Cancel_pushbutton_callback(varargin)
        close(Edit_fig)
    end

    function [] = Edit_pushbutton_callback(varargin)
        
        new_string=get(String_Edit,'String');

        if numel(varargin{3})==1
            set(varargin{3},'String',new_string)
        else
            if ~isempty(new_string)
                for sc=1:length(varargin{3})
                    set(varargin{3}(sc),'String',new_string{sc})
                end
            else
                for sc=1:length(varargin{3})
                    set(varargin{3}(sc),'String','')
                end
            end
        end
        close(Edit_fig)
    end

end
