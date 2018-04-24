% This function which is called by 'SPIKY_handle_subplot.m' allows changing the position (x and y) and the size (width and height)
% of the matrix subplots in the figure 

function [] = SPIKY_handle_change_subplot_size(varargin)

stri={'xpos';'ypos';'width';'height'};
pos = find(strcmp(varargin{5},stri));

h_para=getappdata(varargin{3}.figure1,'help_parameters');
if nargin<=6                                                                % just one subplot (gco)
    posi = get(gco,'Position');
    if all(posi==h_para.supo1)
        sup=0;
    else
        sup=find(ismember(h_para.d_supos,posi,'rows'));       % #######
    end
    if strncmp(varargin{6},'+',1) || strncmp(varargin{6},'-',1)
        posi(pos) = posi(pos) + str2double(varargin{6});
    else
        posi(pos) = str2double(varargin{6});
    end
    set(gco,'Position',posi)
    if ~isempty(sup)
        if sup==0
            eval(['h_para.supo1 = [',num2str(posi),'];']);
        elseif sup<=size(h_para.d_supos,1)
            eval(['h_para.d_supos(',num2str(sup),',:) = [',num2str(posi),'];']);
        end
    end
else                                                                        % all subplots (full matrix varargin{3})
    if strncmp(varargin{6},'+',1) || strncmp(varargin{6},'-',1)   % relative shift
        for lhc1=1:size(varargin{4},1)
            for lhc2=1:size(varargin{4},2)
                for lhc3=1:size(varargin{4},3)
                    if varargin{4}(lhc1,lhc2,lhc3)>0
                        posi = get(varargin{4}(lhc1,lhc2,lhc3),'Position');
                        sup=lhc1*lhc2*lhc3;
                        posi(pos) = posi(pos) + str2double(varargin{6});
                        set(varargin{4}(lhc1,lhc2,lhc3),'Position',posi)
                        eval(['h_para.d_supos(',num2str(sup),',:) = [',num2str(posi),'];']);   % ######
                    end
                end
            end
        end
    else                                                          % absolute position
        for lhc1=1:size(varargin{4},1)
            for lhc2=1:size(varargin{4},2)
                for lhc3=1:size(varargin{4},3)
                    if varargin{4}(lhc1,lhc2,lhc3)>0
                        posi=get(varargin{4}(lhc1,lhc2,lhc3),'Position');
                        sup=lhc1*lhc2*lhc3;
                        posi(pos)=str2double(varargin{6});
                        set(varargin{4}(lhc1,lhc2,lhc3),'Position',posi)
                        eval(['h_para.d_supos(',num2str(sup),',:) = [',num2str(posi),'];']);
                    end
                end
            end
        end
    end
end
setappdata(varargin{3}.figure1,'help_parameters',h_para)                  % save new value in variable
end

