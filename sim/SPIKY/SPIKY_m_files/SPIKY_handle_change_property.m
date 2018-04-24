% This function which is called by several other functions  allows changing properties of objects
% like lines, patches and texts in the figure.

function [] = SPIKY_handle_change_property(varargin)

if varargin{7}==1 || (isempty(gco) && numel(varargin{4}(varargin{4}>0))>1)                                                           % all
    if length(varargin)>8 && ~strcmp(varargin{9},'Separator') % color-coded spikes
        cols=reshape(str2num(varargin{9}),size(varargin{4},1),3); %#ok<ST2NM>
    end
    for lhc1=1:size(varargin{4},1)
        for lhc2=1:size(varargin{4},2)
            for lhc3=1:size(varargin{4},3)
                if varargin{4}(lhc1,lhc2,lhc3)>0
                    if length(varargin)>8 && ~strcmp(varargin{9},'Separator')  % color-coded spikes
                        new_val=cols(lhc1,:);
                    else
                        new_val=varargin{6};
                    end
                    if isnumeric(new_val)
                        if abs(new_val)>100
                            new_val=get(varargin{4}(lhc1,lhc2,lhc3),varargin{5})+sign(new_val)*(abs(new_val)-100);
                        end
                        if new_val<=0
                            set(0,'DefaultUIControlFontSize',16);
                            mbh=msgbox(sprintf('Negative values are not possible!'),'Warning','warn','modal');
                            htxt = findobj(mbh,'Type','text');
                            set(htxt,'FontSize',12,'FontWeight','bold')
                            mb_pos=get(mbh,'Position');
                            set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                            uiwait(mbh);
                            return;
                        end
                    end
                    set(varargin{4}(lhc1,lhc2,lhc3),varargin{5},new_val)
                end
            end
        end
    end
else                                                           % one element only
    new_val=varargin{6};
    if isnumeric(new_val)
        if abs(new_val)>100
            if ~isempty(gco)
                new_val=get(gco,varargin{5})+sign(new_val)*(abs(new_val)-100);
            else
                new_val=get(varargin{4},varargin{5})+sign(new_val)*(abs(new_val)-100);
            end
        end
        if new_val<=0
            set(0,'DefaultUIControlFontSize',16);
            mbh=msgbox(sprintf('Negative values are not possible!'),'Warning','warn','modal');
            htxt = findobj(mbh,'Type','text');
            set(htxt,'FontSize',12,'FontWeight','bold')
            mb_pos=get(mbh,'Position');
            set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
            uiwait(mbh);
            return;
        end
    end
    if numel(varargin{4}(varargin{4}>0))==1
        set(varargin{4}(varargin{4}>0),varargin{5},new_val)
    else
        if ~isempty(gco)
            set(gco,varargin{5},new_val)
        else
            set(gcbo,varargin{5},new_val)
        end
    end
end

if varargin{7}==1 || numel(varargin{4}(varargin{4}>0))==1
    if nargin>7                                                                 % save new value in variable
        p_para=getappdata(varargin{3}.figure1,'plot_parameters');
        if strcmpi(varargin{5},'LineWidth') || strcmpi(varargin{5},'FontSize')
            eval(['p_para.',varargin{8},'=',sprintf('%i',new_val),';']);
        else
            if length(varargin)<9 || strcmp(new_val,'off')
                eval(['p_para.',varargin{8},'=''',sprintf('%s',new_val),''';']);
            else
                eval(['p_para.',varargin{8},'=''k'';']);
            end
        end
        setappdata(varargin{3}.figure1,'plot_parameters',p_para)
    end
end

end
