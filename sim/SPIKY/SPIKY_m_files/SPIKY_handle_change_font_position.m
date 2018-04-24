% This function which is called by ‘SPIKY_handle_font.m’ allows changing the position (x and y) of text objects
% (such as axis or tick labels) in the figure.

function [] = SPIKY_handle_change_font_position(varargin)

stri={'xpos';'ypos'};   % ;'height';'width'
pos = find(strcmp(varargin{4},stri));

if pos==1
    shift=str2double(varargin{5})*diff(xlim);
elseif pos==2
    shift=str2double(varargin{5})*diff(ylim);
end

if varargin{6}==1 || (isempty(gco) && numel(varargin{3}(varargin{3}>0))>1)  % $$$$$$$
    if strncmp(varargin{5},'+',1) || strncmp(varargin{5},'-',1)
        for lhc1=1:size(varargin{3},1)
            for lhc2=1:size(varargin{3},2)
                for lhc3=1:size(varargin{3},3)
                    if varargin{3}(lhc1,lhc2,lhc3)>0
                        posi = get(varargin{3}(lhc1,lhc2,lhc3),'Position');
                        posi(pos) = posi(pos) + shift;
                        set(varargin{3}(lhc1,lhc2,lhc3),'Position',posi)
                    end
                end
            end
        end
    else
        for lhc1=1:size(varargin{3},1)
            for lhc2=1:size(varargin{3},2)
                for lhc3=1:size(varargin{3},3)
                    if varargin{3}(lhc1,lhc2,lhc3)>0
                        posi=get(varargin{3}(lhc1,lhc2,lhc3),'Position');
                        posi(pos) = str2num(varargin{5});
                        set(varargin{3}(lhc1,lhc2,lhc3),'Position',posi)
                    end
                end
            end
        end
    end
else
    if strncmp(varargin{5},'+',1) || strncmp(varargin{5},'-',1)
        if ~isempty(gco)
            posi = get(gco,'Position');
            posi(pos) = posi(pos) + shift;
            set(gco,'Position',posi)
        else
            posi = get(varargin{3},'Position');
            posi(pos) = posi(pos) + shift;
            set(varargin{3},'Position',posi)
        end
    else
        if ~isempty(gco)
            posi=get(gco,'Position');
            posi(pos) = str2num(varargin{5});
            set(gco,'Position',posi)
        else
            posi=get(varargin{3},'Position');
            posi(pos) = str2num(varargin{5});
            set(varargin{3},'Position',posi)
        end
    end
end

end

