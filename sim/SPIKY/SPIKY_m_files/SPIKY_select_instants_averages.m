% This function provides an input mask (for keyboard and mouse) for selecting instants
% as well as selective and triggered averages (intervals and time instants, respectively).

function SPIKY_select_instants_averages(hObject, eventdata, handles)

set(handles.figure1,'Visible','off')

d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
p_para=getappdata(handles.figure1,'plot_parameters');
% s_para=getappdata(handles.figure1,'subplot_parameters');

SIA_fig=figure('units','normalized','menubar','none','position',[0.05 0.07 0.4 0.86],'Name','Select instants and averages',...
    'NumberTitle','off','Color',[0.9294 0.9176 0.851],'DeleteFcn',{@SIA_Close_callback}); % ,'WindowStyle','modal'

SI_panel=uipanel('units','normalized','position',[0.05 0.82 0.9 0.16],'Title','Instants','FontSize',13,'FontWeight','bold','HighlightColor','k');
SI_edit=uicontrol('style','edit','units','normalized','position',[0.08 0.9 0.84 0.04],...
    'FontSize',13,'FontUnits','normalized','BackgroundColor','w');
SI_Load_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.08 0.84 0.16 0.04],'string','Load from file',...
    'FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SI_Load_instants});
SI_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.29 0.84 0.12 0.04],'string','Cancel',...
    'FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SI_callback});
SI_Reset_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.46 0.84 0.12 0.04],'string','Reset',...
    'FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SI_callback});
SI_Apply_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.63 0.84 0.12 0.04],'string','Apply',...
    'FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SI_callback});
SI_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.8 0.84 0.12 0.04],'string','OK',...
    'FontSize',13,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SI_callback});
uicontrol(SI_OK_pushbutton)

SSA_panel=uipanel('units','normalized','position',[0.05 0.42 0.9 0.38],'Title','Selective averages','FontSize',13,...
    'FontWeight','bold','Visible','off');
SSA_edit=uicontrol('style','edit','units','normalized','position',[0.08 0.72 0.84 0.04],...
    'FontSize',13,'FontUnits','normalized','BackgroundColor','w','Visible','off');
SSA_Down_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.135 0.66 0.12 0.04],...
    'string','Down','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SSA_ListBox_callback},'Visible','off');
SSA_Up_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.2875 0.66 0.12 0.04],...
    'string','Up','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SSA_ListBox_callback},'Visible','off');
SSA_Delete_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.44 0.66 0.12 0.04],...
    'string','Delete','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SSA_ListBox_callback},'Visible','off');
SSA_Replace_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.5925 0.66 0.12 0.04],...
    'string','Replace','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SSA_ListBox_callback},'Visible','off');
SSA_Add_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.745 0.66 0.12 0.04],...
    'string','Add','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SSA_ListBox_callback},'Visible','off');
SSA_listbox=uicontrol('style','listbox','units','normalized','position',[0.08 0.5 0.84 0.14],...
    'FontSize',13,'FontUnits','normalized','BackgroundColor','w','CallBack',{@SSA_ListBox_callback},'min',0,'max',1,'Visible','off');
SSA_Load_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.1 0.44 0.2 0.04],...
    'string','Load from file','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SSA_Load_selave},'Visible','off');
SSA_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.32 0.44 0.18 0.04],...
    'string','Cancel','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SSA_callback},'Visible','off');
SSA_Reset_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.52 0.44 0.18 0.04],...
    'string','Reset','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SSA_callback},'Visible','off');
SSA_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.72 0.44 0.18 0.04],...
    'string','OK','FontSize',13,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SSA_callback},'Visible','off');

STA_panel=uipanel('units','normalized','position',[0.05 0.02 0.9 0.38],'Title','Triggered averages',...
    'FontSize',13,'FontWeight','bold','Visible','off');
STA_edit=uicontrol('style','edit','units','normalized','position',[0.08 0.32 0.84 0.04],...
    'FontSize',13,'FontUnits','normalized','BackgroundColor','w','Visible','off');
STA_Down_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.135 0.26 0.12 0.04],...
    'string','Down','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@STA_ListBox_callback},'Visible','off');
STA_Up_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.2875 0.26 0.12 0.04],...
    'string','Up','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@STA_ListBox_callback},'Visible','off');
STA_Delete_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.44 0.26 0.12 0.04],...
    'string','Delete','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@STA_ListBox_callback},'Visible','off');
STA_Replace_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.5925 0.26 0.12 0.04],...
    'string','Replace','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@STA_ListBox_callback},'Visible','off');
STA_Add_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.745 0.26 0.12 0.04],...
    'string','Add','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@STA_ListBox_callback},'Visible','off');
STA_listbox=uicontrol('style','listbox','units','normalized','position',[0.08 0.1 0.84 0.14],...
    'FontSize',13,'FontUnits','normalized','BackgroundColor','w','CallBack',{@STA_ListBox_callback},'min',0,'max',1,'Visible','off');
STA_Load_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.1 0.04 0.2 0.04],...
    'string','Load from file','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@STA_Load_trigave},'Visible','off');
STA_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.32 0.04 0.18 0.04],...
    'string','Cancel','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@STA_callback},'Visible','off');
STA_Reset_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.52 0.04 0.18 0.04],...
    'string','Reset','FontSize',13,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@STA_callback},'Visible','off');
STA_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.72 0.04 0.18 0.04],...
    'string','OK','FontSize',13,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@STA_callback},'Visible','off');

figure(f_para.num_fig);
thick_mar_lh=getappdata(handles.figure1,'thick_mar_lh');
if exist('thick_mar_lh','var') && ~isempty(thick_mar_lh)
    set(thick_mar_lh,'Visible','off')
end
thin_mar_lh=getappdata(handles.figure1,'thin_mar_lh');
if exist('thin_mar_lh','var') && ~isempty(thin_mar_lh)
    set(thin_mar_lh,'Visible','off')
end
thick_sep_lh=getappdata(handles.figure1,'thick_sep_lh');
if exist('thick_sep_lh','var') && ~isempty(thick_sep_lh)
    set(thick_sep_lh,'Visible','off')
end
thin_sep_lh=getappdata(handles.figure1,'thin_sep_lh');
if exist('thin_sep_lh','var') && ~isempty(thin_sep_lh)
    set(thin_sep_lh,'Visible','off')
end
sgs_lh=getappdata(handles.figure1,'sgs_lh');
if exist('sgs_lh','var') && ~isempty(sgs_lh)
    set(sgs_lh,'Visible','off')
end

if isfield(d_para,'instants')
    set(SI_edit,'String',num2str(d_para.instants))
    SI_UserData.lh=zeros(1,length(d_para.instants));
    for lhc=1:length(d_para.instants)
        SI_UserData.lh(lhc)=line(d_para.instants(lhc)*ones(1,2),[0.05 1.05],...
            'Color',p_para.instants_col,'LineStyle',p_para.instants_ls,'LineWidth',p_para.instants_lw);
    end
end
SI_UserData.fh=gcf;
SI_UserData.ah=gca;
set(SI_UserData.fh,'Units','Normalized')

SI_UserData.tmin=d_para.tmin;
SI_UserData.tmax=d_para.tmax;
SI_UserData.dts=d_para.dts;
SI_UserData.instants_col=p_para.instants_col;
SI_UserData.instants_marked_col=p_para.instants_marked_col;
SI_UserData.instants_ls=p_para.instants_ls;
SI_UserData.instants_lw=p_para.instants_lw;
SI_UserData.flag=0;
SI_UserData.marked_indy=[];
SI_UserData.tx=uicontrol('style','tex','String','','unit','normalized','backg',get(SI_UserData.fh,'Color'),...
    'position',[0.4 0.907 0.4 0.04],'FontSize',18,'FontWeight','bold','HorizontalAlignment','left');

SI_UserData.instants=[];
if isfield(SI_UserData,'lh')
    if ~isempty(SI_UserData.lh)
        for lhc=1:length(d_para.instants)
            dummy=get(SI_UserData.lh(lhc),'XData');
            SI_UserData.instants(lhc)=dummy(1);
        end
    end
end
SI_UserData.spike_lh=getappdata(handles.figure1,'spike_lh');
SI_UserData.image_mh=getappdata(handles.figure1,'image_mh');
SI_UserData.thin_mar_lh=getappdata(handles.figure1,'thin_mar_lh');
SI_UserData.thick_mar_lh=getappdata(handles.figure1,'thick_mar_lh');
SI_UserData.thin_sep_lh=getappdata(handles.figure1,'thin_sep_lh');
SI_UserData.thick_sep_lh=getappdata(handles.figure1,'thick_sep_lh');
SI_UserData.sgs_lh=getappdata(handles.figure1,'sgs_lh');

set(SI_UserData.fh,'Userdata',SI_UserData)
SI_UserData.cm=uicontextmenu;
SI_UserData.um=uimenu(SI_UserData.cm,'label','Delete Frame(s)','CallBack',{@SI_delete_instants,SI_UserData});
set(SI_UserData.fh,'WindowButtonMotionFcn',{@SI_get_coordinates,SI_UserData},'KeyPressFcn',{@SI_keyboard,SI_UserData});
if isfield(SI_UserData,'lh')
        set(SI_UserData.lh,'ButtonDownFcn',{@SI_start_move_instants,SI_UserData},'UIContextMenu',SI_UserData.cm)    
end
set(SI_UserData.ah,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
for trac=1:d_para.num_trains
    set(SI_UserData.spike_lh{trac},'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
end
set(SI_UserData.image_mh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
set(SI_UserData.thin_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
set(SI_UserData.thick_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
set(SI_UserData.thin_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
set(SI_UserData.thick_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
set(SI_UserData.sgs_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
set(SI_UserData.fh,'Userdata',SI_UserData)

    function SI_get_coordinates(varargin)
        SI_UserData=varargin{3};
        SI_UserData=get(SI_UserData.fh,'UserData');

        ax_pos=get(SI_UserData.ah,'CurrentPoint');
        ax_x_ok=SI_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SI_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        if ax_x_ok && ax_y_ok
            ax_x=round(ax_pos(1,1)/SI_UserData.dts)*SI_UserData.dts;
            set(SI_UserData.tx,'str',['Time: ', num2str(ax_x)]);
        else
            set(SI_UserData.tx,'str','Out of range');
        end
    end


    function SI_pick_instants(varargin)                                   % SI_marked_indy changes
        SI_UserData=varargin{3};
        SI_UserData=get(SI_UserData.fh,'UserData');

        ax_pos=get(SI_UserData.ah,'CurrentPoint');
        ax_x=round(ax_pos(1,1)/SI_UserData.dts)*SI_UserData.dts;
        ax_x_ok=SI_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SI_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        modifiers=get(SI_UserData.fh,'CurrentModifier');
        if ax_x_ok && ax_y_ok
            seltype=get(SI_UserData.fh,'SelectionType');            % Right-or-left click?
            ctrlIsPressed=ismember('control',modifiers);
            if strcmp(seltype,'normal') || ctrlIsPressed                      % right or middle
                if ~isempty(SI_UserData.instants)
                    num_lh=length(SI_UserData.instants);
                    for lhc=1:num_lh
                        if ishandle(SI_UserData.lh(lhc))
                            delete(SI_UserData.lh(lhc))
                        end
                    end
                    SI_UserData.instants=unique([SI_UserData.instants ax_x]);
                else
                    SI_UserData.instants=ax_x;
                end
                num_lh=length(SI_UserData.instants);
                SI_UserData.lh=zeros(1,num_lh);
                for selc=1:num_lh
                    if ismember(selc,SI_UserData.marked_indy)
                        SI_UserData.lh(selc)=line(SI_UserData.instants(selc)*ones(1,2),[0.05 1.05],...
                            'Visible',p_para.instants_vis,'Color',p_para.instants_marked_col,'LineStyle',p_para.instants_ls,'LineWidth',p_para.instants_lw);
                    else
                        SI_UserData.lh(selc)=line(SI_UserData.instants(selc)*ones(1,2),[0.05 1.05],...
                            'Visible',p_para.instants_vis,'Color',p_para.instants_col,'LineStyle',p_para.instants_ls,'LineWidth',p_para.instants_lw);
                    end
                end

                instants_str=['[',num2str(SI_UserData.instants),']'];
                if length(SI_UserData.instants)>1
                    instants_str=regexprep(instants_str,'\s+',' ');
                end
                set(SI_edit,'String',instants_str)
            end

            shftIsPressed=ismember('shift',modifiers);
            if ctrlIsPressed
                if isfield(SI_UserData,'marked')
                    SI_UserData.marked=unique([SI_UserData.marked ax_x]);
                else
                    SI_UserData.marked=ax_x;
                end
                [dummy,this,dummy2]=intersect(SI_UserData.instants,SI_UserData.marked);
                SI_UserData.marked_indy=this;
                set(SI_UserData.lh,'Color',p_para.instants_col)
                set(SI_UserData.lh(SI_UserData.marked_indy),'Color',p_para.instants_marked_col)
                SI_UserData.flag=1;
            elseif ~shftIsPressed
                set(SI_UserData.lh,'Color',p_para.instants_col)
                SI_UserData.marked=[];
                SI_UserData.flag=0;
                SI_UserData.marked_indy=[];
            end
        end

        dummy_marked=SI_UserData.marked_indy;
        if shftIsPressed            
            set(SI_UserData.fh,'WindowButtonUpFcn',[])
            ax_pos=get(SI_UserData.ah,'CurrentPoint');
            first_corner_x=ax_pos(1,1);
            first_corner_y=ax_pos(1,2);
            window=rectangle('Position',[first_corner_x, first_corner_y, 0.01, 0.01]);
            while shftIsPressed
                ax_pos=get(SI_UserData.ah,'CurrentPoint');
                second_corner_x=ax_pos(1,1);
                second_corner_y=ax_pos(1,2);
                if second_corner_x ~= first_corner_x && second_corner_y ~= first_corner_y
                    set(window,'Position',[min(first_corner_x, second_corner_x), min(first_corner_y, second_corner_y), abs(second_corner_x-first_corner_x), abs(second_corner_y-first_corner_y)])
                    drawnow
                    left_mark=min(first_corner_x, second_corner_x);
                    right_mark=max(first_corner_x, second_corner_x);
                    SI_UserData.marked_indy=unique([dummy_marked find(SI_UserData.instants>=left_mark & SI_UserData.instants<=right_mark)]);
                    SI_UserData.flag=(~isempty(SI_UserData.marked_indy));
                    set(SI_UserData.lh,'Color',p_para.instants_col)
                    set(SI_UserData.lh(SI_UserData.marked_indy),'Color',p_para.instants_marked_col)
                end
                pause(0.001);
                modifiers=get(SI_UserData.fh,'CurrentModifier');
                shftIsPressed=ismember('shift',modifiers);
            end
            delete(window)
            SI_UserData.marked=SI_UserData.instants(SI_UserData.marked_indy);
        end
        
%         sff=SI_UserData.instants
%         sfm=SI_UserData.marked
%         sfmi=SI_UserData.marked_indy
        
        set(SI_UserData.fh,'Userdata',SI_UserData)
        set(SI_UserData.um,'CallBack',{@SI_delete_instants,SI_UserData})
        set(SI_UserData.fh,'WindowButtonMotionFcn',{@SI_get_coordinates,SI_UserData},'KeyPressFcn',{@SI_keyboard,SI_UserData})
        set(SI_UserData.ah,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.lh,'ButtonDownFcn',{@SI_start_move_instants,SI_UserData},'UIContextMenu',SI_UserData.cm)
        for trac=1:d_para.num_trains
            set(SI_UserData.spike_lh{trac},'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        end
        set(SI_UserData.image_mh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.thin_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.thick_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.thin_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.thick_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.sgs_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.fh,'Userdata',SI_UserData)
    end


    function SI_delete_instants(varargin)
        SI_UserData=varargin{3};
        SI_UserData=get(SI_UserData.fh,'UserData');

        if (SI_UserData.flag)
            SI_UserData.instants=setdiff(SI_UserData.instants,SI_UserData.instants(SI_UserData.marked_indy));
            SI_UserData.marked_indy=[];
            SI_UserData.flag=0;
        else
            SI_UserData.instants=setdiff(SI_UserData.instants,get(gco,'XData'));
        end
        num_lh=length(SI_UserData.instants);
        instants_str=num2str(SI_UserData.instants);
        if num_lh>1
            instants_str=regexprep(instants_str,'\s+',' ');
        end
        for lhc=1:length(SI_UserData.lh)
            if ishandle(SI_UserData.lh(lhc))
                delete(SI_UserData.lh(lhc))
            end
        end
        SI_UserData.lh=zeros(1,num_lh);
        for selc=1:num_lh
            SI_UserData.lh(selc)=line(SI_UserData.instants(selc)*ones(1,2),[0.05 1.05],...
                'Visible',p_para.instants_vis,'Color',p_para.instants_col,'LineStyle',p_para.instants_ls,'LineWidth',p_para.instants_lw);
        end
        set(SI_edit,'String',instants_str)

        set(SI_UserData.fh,'Userdata',SI_UserData)
        set(SI_UserData.um,'CallBack',{@SI_delete_instants,SI_UserData})
        set(SI_UserData.fh,'WindowButtonMotionFcn',{@SI_get_coordinates,SI_UserData},'KeyPressFcn',{@SI_keyboard,SI_UserData})
        set(SI_UserData.lh,'ButtonDownFcn',{@SI_start_move_instants,SI_UserData},'UIContextMenu',SI_UserData.cm)
        set(SI_UserData.ah,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SI_UserData.spike_lh{trac},'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        end
        set(SI_UserData.image_mh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.thin_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.thick_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.thin_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.thick_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.sgs_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.fh,'Userdata',SI_UserData)
    end


    function SI_start_move_instants(varargin)
        SI_UserData=varargin{3};
        SI_UserData=get(SI_UserData.fh,'UserData');

        seltype=get(SI_UserData.fh,'SelectionType'); % Right-or-left click?
        ax_pos=get(SI_UserData.ah,'CurrentPoint');
        if strcmp(seltype,'alt')
            modifiers=get(SI_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                ax_x=get(gco,'XData');
                
                if isfield(SI_UserData,'marked')
                    SI_UserData.marked=unique([SI_UserData.marked ax_x]);
                else
                    SI_UserData.marked=ax_x;
                end
                [dummy,this,dummy2]=intersect(SI_UserData.instants,SI_UserData.marked);
                SI_UserData.marked_indy=this;
                if ~SI_UserData.flag
                    SI_UserData.flag=1;
                end
                set(gco,'Color',p_para.instants_marked_col);
                
                set(SI_UserData.fh,'Userdata',SI_UserData)
                set(SI_UserData.um,'CallBack',{@SI_delete_instants,SI_UserData})
                set(SI_UserData.fh,'WindowButtonMotionFcn',{@SI_get_coordinates,SI_UserData},'KeyPressFcn',{@SI_keyboard,SI_UserData})
                set(SI_UserData.lh,'ButtonDownFcn',{@SI_start_move_instants,SI_UserData},'UIContextMenu',SI_UserData.cm)
                set(SI_UserData.ah,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SI_UserData.spike_lh{trac},'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                end
                set(SI_UserData.image_mh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thin_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thick_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thin_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thick_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.sgs_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.fh,'Userdata',SI_UserData)
            end
        else
            SI_UserData.initial_XPos=round(ax_pos(1,1)/SI_UserData.dts)*SI_UserData.dts;
            if ~SI_UserData.flag
                num_lh=length(SI_UserData.instants);
                for selc=1:num_lh
                    set(SI_UserData.lh(selc),'Color',p_para.instants_col);
                end
                SI_UserData.marked_indy=find(SI_UserData.lh(:) == gco);
                SI_UserData.initial_XData=get(gco,'XData');
            else
                SI_UserData.initial_XData=SI_UserData.instants(SI_UserData.marked_indy);
            end
            set(SI_UserData.fh,'WindowButtonMotionFcn',{@SI_move_instants,SI_UserData})
            set(SI_UserData.ah,'ButtonDownFcn','')
            for trac=1:d_para.num_trains
                set(SI_UserData.spike_lh{trac},'ButtonDownFcn','')
            end
            set(SI_UserData.image_mh,'ButtonDownFcn','')
            set(SI_UserData.thin_mar_lh,'ButtonDownFcn','')
            set(SI_UserData.thick_mar_lh,'ButtonDownFcn','')
            set(SI_UserData.thin_sep_lh,'ButtonDownFcn','')
            set(SI_UserData.thick_sep_lh,'ButtonDownFcn','')
            set(SI_UserData.sgs_lh,'ButtonDownFcn','')
            set(SI_UserData.fh,'Userdata',SI_UserData)
        end
    end


    function SI_move_instants(varargin)
        SI_UserData=varargin{3};
        SI_UserData=get(SI_UserData.fh,'UserData');

        ax_pos=get(SI_UserData.ah,'CurrentPoint');
        ax_x_ok=SI_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SI_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;
        ax_x=round(ax_pos(1,1)/SI_UserData.dts)*SI_UserData.dts;
        for idx=1:length(SI_UserData.marked_indy)
            if ((SI_UserData.initial_XData(idx)+ax_x-SI_UserData.initial_XPos)>SI_UserData.tmin && ...
                    (SI_UserData.initial_XData(idx)+ax_x-SI_UserData.initial_XPos)<SI_UserData.tmax)
                set(SI_UserData.lh(SI_UserData.marked_indy(idx)),'Color',p_para.instants_marked_col,...
                    'XData',(SI_UserData.initial_XData(idx)+ax_x-SI_UserData.initial_XPos)*ones(1,2))
            else
                set(SI_UserData.lh(SI_UserData.marked_indy(idx)),'Color','w')
            end
        end
        drawnow;

        if ax_x_ok && ax_y_ok
            ax_x=round(ax_pos(1,1)/SI_UserData.dts)*SI_UserData.dts;
            set(SI_UserData.tx,'str',['Time: ', num2str(ax_x)]);
        else
            set(SI_UserData.tx,'str','Out of range');
        end
        set(SI_UserData.fh,'WindowButtonUpFcn',{@SI_stop_move_instants,SI_UserData})
        set(SI_UserData.fh,'Userdata',SI_UserData)
    end


    function SI_stop_move_instants(varargin)
        SI_UserData=varargin{3};
        SI_UserData=get(SI_UserData.fh,'UserData');
        
        ax_pos=get(SI_UserData.ah,'CurrentPoint');
        ax_x=round(ax_pos(1,1)/SI_UserData.dts)*SI_UserData.dts;
        
        for idx=1:length(SI_UserData.marked_indy)
            if ((SI_UserData.initial_XData(idx)+ax_x -SI_UserData.initial_XPos)>SI_UserData.tmin && ...
                    (SI_UserData.initial_XData(idx)+ax_x -SI_UserData.initial_XPos)<SI_UserData.tmax )
                SI_UserData.instants(SI_UserData.marked_indy(idx))=SI_UserData.initial_XData(idx)+ax_x-SI_UserData.initial_XPos;
            else
                SI_UserData.instants=SI_UserData.instants(setdiff(1:length(SI_UserData.instants),SI_UserData.marked_indy(idx)));
                SI_UserData.marked_indy(idx+1:end)=SI_UserData.marked_indy(idx+1:end)-1;
            end
        end
        SI_UserData.instants=unique(SI_UserData.instants);
        SI_UserData.marked_indy=[];
        SI_UserData.flag=0;
        for lhc=1:size(SI_UserData.lh,2)
            if ishandle(SI_UserData.lh(lhc))
                delete(SI_UserData.lh(lhc))     % ########## early key release !!!
            end
        end
        num_lh=length(SI_UserData.instants);
        SI_UserData.lh=zeros(1,num_lh);
        for selc=1:num_lh
            SI_UserData.lh(selc)=line(SI_UserData.instants(selc)*ones(1,2),[0.05 1.05],...
                'Visible',p_para.instants_vis,'Color',p_para.instants_col,'LineStyle',p_para.instants_ls,'LineWidth',p_para.instants_lw);
        end
        instants_str=num2str(SI_UserData.instants);
        if num_lh>1
            instants_str=regexprep(instants_str,'\s+',' ');
        end
        set(SI_edit,'String',instants_str)
        set(SI_UserData.fh,'Pointer','arrow')
        drawnow;

        set(SI_UserData.fh,'Userdata',SI_UserData)
        set(SI_UserData.um,'CallBack',{@SI_delete_instants,SI_UserData})
        set(SI_UserData.fh,'WindowButtonMotionFcn',{@SI_get_coordinates,SI_UserData},'KeyPressFcn',{@SI_keyboard,SI_UserData},...
            'WindowButtonUpFcn',[])
        set(SI_UserData.lh,'ButtonDownFcn',{@SI_start_move_instants,SI_UserData},'UIContextMenu',SI_UserData.cm)
        set(SI_UserData.ah,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SI_UserData.spike_lh{trac},'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        end
        set(SI_UserData.image_mh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.thin_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.thick_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.thin_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.thick_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.sgs_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
        set(SI_UserData.fh,'Userdata',SI_UserData)
    end


    function SI_keyboard(varargin)
        SI_UserData=varargin{3};
        SI_UserData=get(SI_UserData.fh,'UserData');
        
        if strcmp(varargin{2}.Key,'delete')
            if (SI_UserData.flag)
                SI_UserData.instants=setdiff(SI_UserData.instants,SI_UserData.instants(SI_UserData.marked_indy));
                SI_UserData.marked_indy=[];
                SI_UserData.flag=0;
                num_lh=length(SI_UserData.instants);
                instants_str=num2str(SI_UserData.instants);
                if num_lh>1
                    instants_str=regexprep(instants_str,'\s+',' ');
                end
                for lhc=1:length(SI_UserData.lh)
                    if ishandle(SI_UserData.lh(lhc))
                        delete(SI_UserData.lh(lhc))
                    end
                end
                num_lh=length(SI_UserData.instants);
                SI_UserData.lh=zeros(1,num_lh);
                for selc=1:num_lh
                    SI_UserData.lh(selc)=line(SI_UserData.instants(selc)*ones(1,2),[0.05 1.05],...
                        'Visible',p_para.instants_vis,'Color',p_para.instants_col,'LineStyle',p_para.instants_ls,'LineWidth',p_para.instants_lw);
                end
                set(SI_edit,'String',instants_str)
                
                set(SI_UserData.fh,'Userdata',SI_UserData)
                set(SI_UserData.um,'CallBack',{@SI_delete_instants,SI_UserData})
                set(SI_UserData.fh,'WindowButtonMotionFcn',{@SI_get_coordinates,SI_UserData},'KeyPressFcn',{@SI_keyboard,SI_UserData})
                set(SI_UserData.lh,'ButtonDownFcn',{@SI_start_move_instants,SI_UserData},'UIContextMenu',SI_UserData.cm)
                set(SI_UserData.ah,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SI_UserData.spike_lh{trac},'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                end
                set(SI_UserData.image_mh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thin_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thick_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thin_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thick_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.sgs_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.fh,'Userdata',SI_UserData)
            end
        elseif strcmp(varargin{2}.Key,'a')
            modifiers=get(SI_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                num_lh=length(SI_UserData.instants);
                SI_UserData.marked=SI_UserData.instants;
                SI_UserData.marked_indy=1:num_lh;
                for selc=1:num_lh
                    set(SI_UserData.lh(selc),'Color',p_para.instants_marked_col);
                end
                SI_UserData.flag=1;

                set(SI_UserData.fh,'Userdata',SI_UserData)
                set(SI_UserData.um,'CallBack',{@SI_delete_instants,SI_UserData})
                set(SI_UserData.fh,'WindowButtonMotionFcn',{@SI_get_coordinates,SI_UserData},'KeyPressFcn',{@SI_keyboard,SI_UserData})
                set(SI_UserData.lh,'ButtonDownFcn',{@SI_start_move_instants,SI_UserData},'UIContextMenu',SI_UserData.cm)
                set(SI_UserData.ah,'ButtonDownFcn',{@SI_start_pick,SI_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SI_UserData.spike_lh{trac},'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                end
                set(SI_UserData.image_mh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thin_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thick_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thin_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thick_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.sgs_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.fh,'Userdata',SI_UserData)
            end
        elseif strcmp(varargin{2}.Key,'c')
            modifiers=get(SI_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                num_lh=length(SI_UserData.instants);
                ax_x=SI_UserData.instants(SI_UserData.marked_indy);
                for idx=1:length(SI_UserData.marked_indy)
                    SI_UserData.lh(num_lh+idx)=line(SI_UserData.instants(SI_UserData.marked_indy(idx))*ones(1,2),[0.05 1.05],...
                        'Visible',p_para.instants_vis,'Color',p_para.instants_marked_col,'LineStyle',p_para.instants_ls,'LineWidth',p_para.instants_lw);
                end
                SI_UserData.marked=SI_UserData.instants(SI_UserData.marked_indy);
                SI_UserData.marked_indy=num_lh+(1:length(SI_UserData.marked_indy));
                SI_UserData.instants(SI_UserData.marked_indy)=SI_UserData.marked;
                SI_UserData.flag=1;
                ax_pos=get(SI_UserData.ah,'CurrentPoint');
                SI_UserData.initial_XPos=round(ax_pos(1,1)/SI_UserData.dts)*SI_UserData.dts;
                SI_UserData.initial_XData=ax_x;
                set(SI_UserData.ah,'ButtonDownFcn','')
                for trac=1:d_para.num_trains
                    set(SI_UserData.spike_lh{trac},'ButtonDownFcn','')
                end
                set(SI_UserData.image_mh,'ButtonDownFcn','')
                set(SI_UserData.thin_mar_lh,'ButtonDownFcn','')
                set(SI_UserData.thick_mar_lh,'ButtonDownFcn','')
                set(SI_UserData.thin_sep_lh,'ButtonDownFcn','')
                set(SI_UserData.thick_sep_lh,'ButtonDownFcn','')
                set(SI_UserData.sgs_lh,'ButtonDownFcn','')
                set(SI_UserData.fh,'WindowButtonMotionFcn',{@SI_move_instants,SI_UserData})
                set(SI_UserData.fh,'Userdata',SI_UserData)
            end
        end
    end


    function SI_Load_instants(varargin)
        if isfield(d_para,'matfile') && ischar(d_para.matfile)
            [d_para.filename,d_para.path]=uigetfile('*.mat','Pick a .mat-file',d_para.matfile);
        else
            [d_para.filename,d_para.path]=uigetfile('*.mat','Pick a .mat-file');
        end
        if isequal(d_para.filename,0) || isequal(d_para.path,0)
            return
        end
        d_para.matfile=[d_para.path d_para.filename];
        if d_para.matfile~=0
            SI_UserData=get(f_para.num_fig,'UserData');
            data.matfile=d_para.matfile;
            data.default_variable='';
            data.content='instants';
            SPIKY('SPIKY_select_variable',gcbo,data,handles)
            variable=getappdata(handles.figure1,'variable');
            if ~isempty(variable) && ~strcmp(variable,'A9ZB1YC8X')
                data=getappdata(handles.figure1,'data');
                SI_UserData.instants=squeeze(eval(['data.',variable]));
            end
            if ~isnumeric(SI_UserData.instants) || ndims(SI_UserData.instants)~=2 || ~any(size(SI_UserData.instants)==1)
                if ~strcmp(variable,'A9ZB1YC8X')
                    set(0,'DefaultUIControlFontSize',16);
                    mbh=msgbox(sprintf('No vector has been chosen. Please try again!'),'Warning','warn','modal');
                    htxt=findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                    uiwait(mbh);
                end
                ret=1;
                return
            end
            figure(f_para.num_fig)
            if isfield(SI_UserData,'lh')
                for rc=1:size(SI_UserData.lh,1)
                    for lhc=1:size(SI_UserData.lh,2)
                        if ishandle(SI_UserData.lh(lhc))
                            delete(SI_UserData.lh(lhc))
                        end
                    end
                end
                SI_UserData.lh=[];
            end

            if size(SI_UserData.instants,2)<size(SI_UserData.instants,1)
                SI_UserData.instants=SI_UserData.instants';
            end
            SI_UserData.lh=zeros(1,length(SI_UserData.instants));
            for lhc=1:length(SI_UserData.instants)
                SI_UserData.lh(lhc)=line(SI_UserData.instants(lhc)*ones(1,2),[0.05 1.05],...
                    'Color',p_para.instants_col,'LineStyle',p_para.instants_ls,'LineWidth',p_para.instants_lw);
            end
            instants_str=num2str(SI_UserData.instants);
            if length(SI_UserData.instants)>1
                instants_str=regexprep(instants_str,'\s+',' ');
            end
            set(SI_edit,'String',instants_str)
            set(SI_UserData.fh,'Userdata',SI_UserData)
        end
    end


    function SI_callback(varargin)
        d_para=getappdata(handles.figure1,'data_parameters');
        f_para=getappdata(handles.figure1,'figure_parameters');
        figure(f_para.num_fig);
        SI_UserData=get(gcf,'Userdata');

        if gcbo==SI_Reset_pushbutton || gcbo==SI_Cancel_pushbutton || gcbo==SIA_fig
            if isfield(SI_UserData,'lh')
                for rc=1:size(SI_UserData.lh,1)
                    for lhc=1:size(SI_UserData.lh,2)
                        if ishandle(SI_UserData.lh(lhc))
                            delete(SI_UserData.lh(lhc))
                        end
                    end
                end
                SI_UserData.lh=[];
            end
            if isfield(SI_UserData,'instants')
                SI_UserData.instants=[];
            end
            d_para.instants=[];
            set(SI_edit,'string',[])
            if gcbo==SI_Reset_pushbutton
                set(SI_UserData.fh,'Userdata',SI_UserData)
                set(SI_UserData.um,'CallBack',{@SI_delete_instants,SI_UserData})
                set(SI_UserData.fh,'WindowButtonMotionFcn',{@SI_get_coordinates,SI_UserData},'KeyPressFcn',{@SI_keyboard,SI_UserData})
                set(SI_UserData.lh,'ButtonDownFcn',{@SI_start_move_instants,SI_UserData},'UIContextMenu',SI_UserData.cm)
                set(SI_UserData.ah,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SI_UserData.spike_lh{trac},'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                end
                set(SI_UserData.image_mh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thin_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thick_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thin_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thick_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.sgs_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.fh,'Userdata',SI_UserData)
            elseif gcbo==SI_Cancel_pushbutton || gcbo==SIA_fig
                SI_UserData.cm=[];
                SI_UserData.um=[];
                set(SI_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
                set(SI_UserData.lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SI_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SI_UserData.spike_lh{trac},'ButtonDownFcn',[],'UIContextMenu',[])
                end
                set(SI_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SI_UserData.thin_mar_lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SI_UserData.thick_mar_lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SI_UserData.thin_sep_lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SI_UserData.thick_sep_lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SI_UserData.sgs_lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SI_UserData.fh,'Userdata',SI_UserData)
                delete(SIA_fig)
                set(handles.figure1,'Visible','on')
            end
        elseif gcbo==SI_OK_pushbutton || gcbo==SI_Apply_pushbutton
            [new_values,conv_ok]=str2num(get(SI_edit,'String'));
            if conv_ok==0 && ~isempty(new_values)
                set(0,'DefaultUIControlFontSize',16);
                mbh=msgbox(sprintf('The values entered are not numeric!'),'Warning','warn','modal');
                htxt=findobj(mbh,'Type','text');
                set(htxt,'FontSize',12,'FontWeight','bold')
                mb_pos=get(mbh,'Position');
                set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                uiwait(mbh);
                return
            end
            SI_UserData.instants=unique([new_values SI_UserData.instants]);
            if isfield(SI_UserData,'lh')
                delete(SI_UserData.lh)
                SI_UserData=rmfield(SI_UserData,'lh');
            end
            
            figure(f_para.num_fig);
            instants_cmenu=uicontextmenu;
            SI_UserData.lh=zeros(1,length(SI_UserData.instants));
            for lhc=1:length(SI_UserData.instants)
                SI_UserData.lh(lhc)=line(SI_UserData.instants(lhc)*ones(1,2),[0.05 1.05],...
                    'Color',p_para.instants_col,'LineStyle',p_para.instants_ls,'LineWidth',p_para.instants_lw,'UIContextMenu',instants_cmenu);
            end
            set(SI_UserData.fh,'Userdata',SI_UserData)

            if gcbo==SI_Apply_pushbutton
                set(SI_edit,'String',regexprep(num2str(unique(round(SI_UserData.instants/d_para.dts)*d_para.dts)),'\s+',' '))
                set(SI_UserData.fh,'Userdata',SI_UserData)
                set(SI_UserData.um,'CallBack',{@SI_delete_instants,SI_UserData})
                set(SI_UserData.fh,'WindowButtonMotionFcn',{@SI_get_coordinates,SI_UserData},'KeyPressFcn',{@SI_keyboard,SI_UserData})
                set(SI_UserData.lh,'ButtonDownFcn',{@SI_start_move_instants,SI_UserData},'UIContextMenu',SI_UserData.cm)
                set(SI_UserData.ah,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SI_UserData.spike_lh{trac},'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                end
                set(SI_UserData.image_mh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thin_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thick_mar_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thin_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.thick_sep_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.sgs_lh,'ButtonDownFcn',{@SI_pick_instants,SI_UserData},'UIContextMenu',[])
                set(SI_UserData.fh,'Userdata',SI_UserData)
            else
                set(SI_edit,'String',regexprep(num2str(unique(round(SI_UserData.instants/d_para.dts)*d_para.dts)),'\s+',' '))
                setappdata(handles.figure1,'data_parameters',d_para)

                set(SI_panel,'HighlightColor','w')
                set(SI_edit,'Enable','off')
                set(SI_Load_pushbutton,'Enable','off')
                set(SI_Cancel_pushbutton,'Enable','off')
                set(SI_Reset_pushbutton,'Enable','off')
                set(SI_Apply_pushbutton,'Enable','off')
                set(SI_OK_pushbutton,'Enable','off')
                if isfield(SI_UserData,'lh')
                    for lhc=1:length(SI_UserData.lh)
                        if ishandle(SI_UserData.lh(lhc))
                            delete(SI_UserData.lh(lhc))
                        end
                    end
                    SI_UserData.lh=[];
                end
                SI_UserData.marked_indy=[];
                SI_UserData.flag=0;
                SI_UserData.cm=[];
                SI_UserData.um=[];
                set(SI_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
                set(SI_UserData.lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SI_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SI_UserData.spike_lh{trac},'ButtonDownFcn',[],'UIContextMenu',[])
                end
                set(SI_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SI_UserData.thin_mar_lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SI_UserData.thick_mar_lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SI_UserData.thin_sep_lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SI_UserData.thick_sep_lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SI_UserData.sgs_lh,'ButtonDownFcn',[],'UIContextMenu',[])

                % ########################################################
                
                set(SSA_panel,'Visible','on','HighlightColor','k')
                set(SSA_edit,'Visible','on')
                set(SSA_Down_pushbutton,'Visible','on')
                set(SSA_Up_pushbutton,'Visible','on')
                set(SSA_Delete_pushbutton,'Visible','on')
                set(SSA_Replace_pushbutton,'Visible','on')
                set(SSA_Add_pushbutton,'Visible','on')
                set(SSA_listbox,'Visible','on')
                set(SSA_Load_pushbutton,'Visible','on')
                set(SSA_Cancel_pushbutton,'Visible','on')
                set(SSA_Reset_pushbutton,'Visible','on')
                set(SSA_OK_pushbutton,'Visible','on','FontWeight','bold')
                uicontrol(SSA_OK_pushbutton)
                SSA_UserData=SI_UserData;

                lb_strings=[];
                lb_num_strings=0;
                if isfield(d_para,'selective_averages')
                    if iscell(d_para.selective_averages)
                        lb_strings=cell(1,length(d_para.selective_averages));
                        for selc=1:length(d_para.selective_averages)
                            lb_strings{selc}=['[',num2str(d_para.selective_averages{selc}),']; '];
                        end
                        lb_num_strings=length(lb_strings);
                    end
                elseif isfield(d_para,'selective_averages_str') && ~isempty(d_para.selective_averages_str)
                    d_para.selective_averages_str2=d_para.selective_averages_str;
                    if d_para.selective_averages_str2(1)=='{'
                        d_para.selective_averages_str2=d_para.selective_averages_str2(2:end);
                    end
                    if d_para.selective_averages_str2(end)=='}'
                        d_para.selective_averages_str2=d_para.selective_averages_str2(1:end-1);
                    end
                    str_seps=[0 find(d_para.selective_averages_str2==';') length(d_para.selective_averages_str2)+1];
                    SSA_UserData.selave=cell(1,length(str_seps)-1);
                    lb_strings=cell(1,length(str_seps)-1);
                    lb_num_strings=length(lb_strings);
                    for sac=1:lb_num_strings
                        lb_strings{sac}=strtrim(d_para.selective_averages_str2(str_seps(sac)+1:str_seps(sac+1)-1));
                    end
                end
                prob=[];
                for sac=1:lb_num_strings
                    SSA_UserData.selave{sac}=str2num(lb_strings{sac});
                    num_lh=length(SSA_UserData.selave{sac})/2;
                    odds=2*(1:num_lh)-1;
                    evens=odds+1;
                    for swapc=find(SSA_UserData.selave{sac}(evens)<SSA_UserData.selave{sac}(odds))
                        dummy=SSA_UserData.selave{sac}(evens(swapc));
                        SSA_UserData.selave{sac}(evens(swapc))=SSA_UserData.selave{sac}(odds(swapc));
                        SSA_UserData.selave{sac}(odds(swapc))=dummy;
                    end
                    if num_lh>1
                        [dummy,indys]=sort(SSA_UserData.selave{sac}(odds));
                        SSA_UserData.selave{sac}=SSA_UserData.selave{sac}(reshape([odds(indys); evens(indys)],1,length(odds)*2));
                        if any(SSA_UserData.selave{sac}(evens(1:num_lh-1))>SSA_UserData.selave{sac}(odds(2:num_lh)))
                            prob=[prob sac];
                        end
                        lb_strings{sac}=['[',num2str(SSA_UserData.selave{sac}),']'];
                        lb_strings{sac}=regexprep(lb_strings{sac},'\s+',' ');
                        spacepos=find(isspace(lb_strings{sac}));
                        sindy=2:2:length(spacepos);
                        for sppc=sindy(end):-2:2
                            lb_strings{sac}=[lb_strings{sac}(1:spacepos(sppc)) '   ' lb_strings{sac}(spacepos(sppc)+1:length(lb_strings{sac}))];
                        end
                    else
                        if ~isempty(SSA_UserData.selave{sac})
                            lb_strings{sac}=['[',regexprep(num2str(SSA_UserData.selave{sac}),'\s+',' '),']'];
                        else
                            lb_strings{sac}='';
                        end
                    end
                    if ~isempty(prob)
                        set(SSA_listbox,'Value',prob(1))
                        set(0,'DefaultUIControlFontSize',16);
                        mbh=msgbox(sprintf('Intervals for one group (row) of selective averages\nmust not overlap. Please fix this!'),'Warning','warn','modal');
                        htxt=findobj(mbh,'Type','text');
                        set(htxt,'FontSize',12,'FontWeight','bold')
                        mb_pos=get(mbh,'Position');
                        set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                        uiwait(mbh);
                    end
                end
                set(SSA_listbox,'String',lb_strings)

                lb_pos=get(SSA_listbox,'Value');
                lb_strings=get(SSA_listbox,'String');
                lb_num_strings=length(lb_strings);
                figure(f_para.num_fig);
                
%                 set(SSA_UserData.fh,'Interruptible','off','BusyAction','cancel');
%                 set(SSA_UserData.ah,'Interruptible','off','BusyAction','cancel');
%                 for trac=1:d_para.num_trains
%                     set(SSA_UserData.spike_lh{trac},'Interruptible','off','BusyAction','cancel')
%                 end
%                 set(SSA_UserData.spike_lh,'Interruptible','off','BusyAction','cancel')
%                 set(SSA_UserData.image_mh,'Interruptible','off','BusyAction','cancel')
%                 set(SSA_UserData.thin_mar_lh,'Interruptible','off','BusyAction','cancel')
%                 set(SSA_UserData.thick_mar_lh,'Interruptible','off','BusyAction','cancel')
%                 set(SSA_UserData.thin_sep_lh,'Interruptible','off','BusyAction','cancel')
%                 set(SSA_UserData.thick_sep_lh,'Interruptible','off','BusyAction','cancel')
%                 set(SSA_UserData.sgs_lh,'Interruptible','off','BusyAction','cancel')
                
                SSA_UserData.lh=cell(1,lb_num_strings);
                for sac=1:lb_num_strings
                    if ~isempty(lb_strings{sac})
                        num_lh=length(SSA_UserData.selave{sac})/2;
                        if sac==lb_pos
                            dcol=p_para.selave_active_col;
                        else
                            dcol=p_para.selave_col;
                        end
                        for selc=1:num_lh
                            SSA_UserData.lh{sac}(selc)=line(SSA_UserData.selave{sac}(2*selc-1:2*selc),(1.05-(sac-1)/lb_num_strings)*ones(1,2),...
                                'Visible',p_para.selave_vis,'Color',dcol,'LineStyle',p_para.selave_ls,'LineWidth',p_para.selave_lw);
                        end
                    end
                end
                SSA_UserData.selave{lb_num_strings+1}=[];
                lb_strings{lb_num_strings+1}='';
                set(SSA_listbox,'String',lb_strings);
                set(SSA_edit,'String',lb_strings{lb_pos})

                set(SSA_UserData.fh,'Userdata',SSA_UserData)
                SSA_UserData.cm=uicontextmenu;
                SSA_UserData.um=uimenu(SSA_UserData.cm,'label','Delete Selective average(s)','CallBack',{@SSA_delete_selave,SSA_UserData});
                set(SSA_UserData.fh,'WindowButtonMotionFcn',{@SSA_get_coordinates,SSA_UserData}) %,'KeyPressFcn',{@SSA_keyboard,SSA_UserData});
                set([SSA_UserData.lh{:}],'ButtonDownFcn',[])
                if ~isempty(SSA_UserData.lh) && lb_pos<=length(SSA_UserData.lh)
                    set([SSA_UserData.lh{lb_pos}],'ButtonDownFcn',{@SSA_start_move_selave,SSA_UserData},'UIContextMenu',SSA_UserData.cm)
                end
                set(SSA_UserData.ah,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                for trac=1:d_para.num_trains
                    set(SSA_UserData.spike_lh{trac},'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                end
                set(SSA_UserData.image_mh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thin_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thick_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thin_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thick_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.sgs_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.fh,'Userdata',SSA_UserData)
            end
        end
    end


% ########################################################
% ########################################################              SSA
% ########################################################

    function SSA_ListBox_callback(varargin)
        figure(f_para.num_fig);
        SSA_UserData=get(gcf,'Userdata');
        SSA_UserData=get(SSA_UserData.fh,'UserData');

        lb_pos=get(SSA_listbox,'Value');
        lb_strings=get(SSA_listbox,'String');
        lb_num_strings=length(lb_strings)-1;
        if gcbo==SSA_listbox
            for sac=1:lb_num_strings
                if sac==lb_pos
                    dcol=p_para.selave_active_col;
                else
                    dcol=p_para.selave_col;
                end
                for selc=1:length(SSA_UserData.selave{sac})/2
                    set(SSA_UserData.lh{sac}(selc),'Color',dcol);   % ##########
                end
            end
        elseif gcbo==SSA_Down_pushbutton
            if lb_pos<lb_num_strings
                dummy=SSA_UserData.selave{lb_pos+1};
                SSA_UserData.selave{lb_pos+1}=SSA_UserData.selave{lb_pos};
                SSA_UserData.selave{lb_pos}=dummy;
                dummy=lb_strings{lb_pos+1};
                lb_strings{lb_pos+1}=lb_strings{lb_pos};
                lb_strings{lb_pos}=dummy;
                set(SSA_listbox,'Value',lb_pos+1)
            end
        elseif gcbo==SSA_Up_pushbutton
            if lb_pos>1 && ~isempty(lb_strings{lb_pos})
                dummy=SSA_UserData.selave{lb_pos-1};
                SSA_UserData.selave{lb_pos-1}=SSA_UserData.selave{lb_pos};
                SSA_UserData.selave{lb_pos}=dummy;
                dummy=lb_strings{lb_pos-1};
                lb_strings{lb_pos-1}=lb_strings{lb_pos};
                lb_strings{lb_pos}=dummy;
                set(SSA_listbox,'Value',lb_pos-1)
            end
        elseif gcbo==SSA_Delete_pushbutton
            if lb_pos<=lb_num_strings
                SSA_UserData.selave(lb_pos:lb_num_strings)=SSA_UserData.selave(lb_pos+1:lb_num_strings+1);
                lb_strings(lb_pos:lb_num_strings)=lb_strings(lb_pos+1:lb_num_strings+1);
                if lb_pos<lb_num_strings
                    set(SSA_listbox,'Value',lb_pos)
                else
                    set(SSA_listbox,'Value',lb_pos-1)
                end
                SSA_UserData.selave=SSA_UserData.selave(1:lb_num_strings);
                lb_strings=lb_strings(1:lb_num_strings);
            end
        elseif gcbo==SSA_Replace_pushbutton
            SSA_str=get(SSA_edit,'String');
            if ~isempty(SSA_str)
                [dummy,conv_ok]=str2num(SSA_str);
                if conv_ok==0
                    set(0,'DefaultUIControlFontSize',16);
                    mbh=msgbox(sprintf('The values entered are not numeric!'),'Warning','warn','modal');
                    htxt=findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                    uiwait(mbh);
                    return
                end
                SSA_UserData.selave{lb_pos}=round(dummy/SSA_UserData.dts)*SSA_UserData.dts;
                lb_strings{lb_pos}=['[',num2str(SSA_UserData.selave{lb_pos}),']'];
            end
        elseif gcbo==SSA_Add_pushbutton
            SSA_str=get(SSA_edit,'String');
            if ~isempty(get(SSA_edit,'String'))
                [dummy,conv_ok]=str2num(SSA_str);
                if conv_ok==0
                    set(0,'DefaultUIControlFontSize',16);
                    mbh=msgbox(sprintf('The values entered are not numeric!'),'Warning','warn','modal');
                    htxt=findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                    uiwait(mbh);
                    return
                end
                SSA_UserData.selave{lb_num_strings+1}=round(dummy/SSA_UserData.dts)*SSA_UserData.dts;
                lb_strings{lb_num_strings+1}=num2str(SSA_UserData.selave{lb_num_strings+1});
                SSA_UserData.selave{lb_num_strings+2}=[];
                lb_strings{lb_num_strings+2}='';
                set(SSA_listbox,'Value',lb_num_strings+1)
            end
        end
        set(SSA_listbox,'String',lb_strings)
        lb_pos=get(SSA_listbox,'Value');
        lb_num_strings=length(lb_strings)-1;
        prob=[];
        for sac=1:lb_num_strings
            num_lh=length(SSA_UserData.selave{sac})/2;
            odds=2*(1:num_lh)-1;
            evens=odds+1;
            for swapc=find(SSA_UserData.selave{sac}(evens)<SSA_UserData.selave{sac}(odds))
                dummy=SSA_UserData.selave{sac}(evens(swapc));
                SSA_UserData.selave{sac}(evens(swapc))=SSA_UserData.selave{sac}(odds(swapc));
                SSA_UserData.selave{sac}(odds(swapc))=dummy;
            end
            if num_lh>1
                [dummy,indys]=sort(SSA_UserData.selave{sac}(odds));
                SSA_UserData.selave{sac}=SSA_UserData.selave{sac}(reshape([odds(indys); evens(indys)],1,length(odds)*2));
                if any(SSA_UserData.selave{sac}(evens(1:num_lh-1))>SSA_UserData.selave{sac}(odds(2:num_lh)))
                    prob=[prob sac];
                end
                lb_strings{sac}=regexprep(lb_strings{sac},'\s+',' ');
                spacepos=find(isspace(lb_strings{sac}));
                sindy=2:2:length(spacepos);
                for sppc=sindy(end):-2:2
                    lb_strings{sac}=[lb_strings{sac}(1:spacepos(sppc)) '   ' lb_strings{sac}(spacepos(sppc)+1:length(lb_strings{sac}))];
                end
            else
                lb_strings{sac}=['[',num2str(SSA_UserData.selave{sac}),']'];
            end
        end
        if ~isempty(prob)
            set(SSA_listbox,'Value',prob(1))
            set(0,'DefaultUIControlFontSize',16);
            mbh=msgbox(sprintf('Intervals for one group (row) of selective averages\nmust not overlap. Please fix this!'),'Warning','warn','modal');
            htxt=findobj(mbh,'Type','text');
            set(htxt,'FontSize',12,'FontWeight','bold')
            mb_pos=get(mbh,'Position');
            set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
            uiwait(mbh);
        else
            if isfield(SSA_UserData,'lh')
                for rc=1:length(SSA_UserData.lh)
                    for cc=1:length(SSA_UserData.lh{rc})
                        if ishandle(SSA_UserData.lh{rc}(cc))
                            delete(SSA_UserData.lh{rc}(cc))
                        end
                    end
                end
            end
            SSA_UserData.lh=cell(1,lb_num_strings);
            for sac=1:lb_num_strings
                num_lh=length(SSA_UserData.selave{sac})/2;
                if sac==lb_pos
                    dcol=p_para.selave_active_col;
                else
                    dcol=p_para.selave_col;
                end
                for selc=1:num_lh
                    SSA_UserData.lh{sac}(selc)=line(SSA_UserData.selave{sac}(2*selc-1:2*selc),(1.05-(sac-1)/lb_num_strings)*ones(1,2),...
                        'Visible',p_para.selave_vis,'Color',dcol,'LineStyle',p_para.selave_ls,'LineWidth',p_para.selave_lw);
                end
            end
        end
        set(SSA_listbox,'String',lb_strings)
        if lb_pos>0
            set(SSA_edit,'String',lb_strings{lb_pos})
        else
            lb_pos=1;
            set(SSA_listbox,'Value',lb_pos);
            set(SSA_edit,'String','')
        end
        
        set(SSA_UserData.fh,'Userdata',SSA_UserData)
        set(SSA_UserData.um,'CallBack',{@SSA_delete_selave,SSA_UserData})
        set(SSA_UserData.fh,'WindowButtonMotionFcn',{@SSA_get_coordinates,SSA_UserData},'KeyPressFcn',{@SSA_keyboard,SSA_UserData})
        set([SSA_UserData.lh{:}],'ButtonDownFcn',[])
        if ~isempty(SSA_UserData.lh) && lb_pos<=length(SSA_UserData.lh)
            set([SSA_UserData.lh{lb_pos}],'ButtonDownFcn',{@SSA_start_move_selave,SSA_UserData},'UIContextMenu',SSA_UserData.cm)
        end
        set(SSA_UserData.ah,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        for trac=1:d_para.num_trains
            set(SSA_UserData.spike_lh{trac},'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        end
        set(SSA_UserData.image_mh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.thin_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.thick_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.thin_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.thick_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.sgs_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.fh,'Userdata',SSA_UserData)
    end


    function SSA_get_coordinates(varargin)
        SSA_UserData=varargin{3};
        SSA_UserData=get(SSA_UserData.fh,'UserData');

        ax_pos=get(SSA_UserData.ah,'CurrentPoint');
        ax_x_ok=SSA_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SSA_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        if ax_x_ok && ax_y_ok
            ax_x=round(ax_pos(1,1)/SSA_UserData.dts)*SSA_UserData.dts;
            set(SSA_UserData.tx,'str',['Time: ', num2str(ax_x)]);
        else
            set(SSA_UserData.tx,'str','Out of range');
        end
    end


    function SSA_start_selave(varargin)
        SSA_UserData=varargin{3};
        SSA_UserData=get(SSA_UserData.fh,'UserData');
        
        ax_pos=get(SSA_UserData.ah,'CurrentPoint');
        ax_x=round(ax_pos(1,1)/SSA_UserData.dts)*SSA_UserData.dts;
        ax_x_ok=SSA_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SSA_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        if ax_x_ok && ax_y_ok
            seltype=get(SSA_UserData.fh,'SelectionType'); % Right-or-left click?
            modifiers=get(SSA_UserData.fh,'CurrentModifier');
            shftIsPressed=ismember('shift',modifiers);
            ctrlIsPressed=ismember('control',modifiers);
            lb_pos=get(SSA_listbox,'Value');
            lb_strings=get(SSA_listbox,'String');
            
            if ~shftIsPressed && ~ctrlIsPressed
                if ~strcmp(seltype,'alt')
                   if ~isempty(lb_strings)
                        set(SSA_edit,'String',lb_strings{lb_pos})
                    end
                    lb_num_strings=length(lb_strings)-1;
                    if lb_num_strings>0
                        yval=1.05-(lb_pos-1)/lb_num_strings;
                    else
                        yval=1.05;
                    end
                    if lb_pos<=lb_num_strings
                        int_begs=SSA_UserData.selave{lb_pos}(1:2:length(SSA_UserData.selave{lb_pos}));
                        int_ends=SSA_UserData.selave{lb_pos}(2:2:length(SSA_UserData.selave{lb_pos}));
                    else
                        int_begs=[];
                        int_ends=[];
                    end
                    SSA_UserData.closestLeft=SSA_UserData.tmin;
                    SSA_UserData.closestRight=SSA_UserData.tmax;
                    for i=1:length(int_begs)
                        if ax_x>=min(int_begs(i),int_ends(i)) && ax_x<=max(int_begs(i),int_ends(i))
                            return
                        end
                        if int_begs(i)<ax_x && int_begs(i)>SSA_UserData.closestLeft
                            SSA_UserData.closestLeft=int_begs(i);
                        end
                        if int_ends(i)<ax_x && int_ends(i)>SSA_UserData.closestLeft
                            SSA_UserData.closestLeft=int_ends(i);
                        end
                        if int_begs(i)>ax_x && int_begs(i)<SSA_UserData.closestRight
                            SSA_UserData.closestRight=int_begs(i);
                        end
                        if int_ends(i)>ax_x && int_ends(i)<SSA_UserData.closestRight
                            SSA_UserData.closestRight=int_ends(i);
                        end
                    end

                    if lb_pos<=length(SSA_UserData.lh)
                        num_lh=length(SSA_UserData.lh{lb_pos});
                        
                        SSA_UserData.lh{lb_pos}(num_lh+1)=line([ax_x ax_x],yval*ones(1,2),...
                            'Color',p_para.selave_col,'LineStyle',p_para.selave_ls,'LineWidth',p_para.selave_lw,'UserData',ax_x);
                    else
                        
                        if isfield(SSA_UserData,'lh')
                            for rc=1:length(SSA_UserData.lh)
                                for cc=1:length(SSA_UserData.lh{rc})
                                    if ishandle(SSA_UserData.lh{rc}(cc))
                                        delete(SSA_UserData.lh{rc}(cc))
                                    end
                                end
                            end
                        end
                        lb_num_strings=length(lb_strings);
                        SSA_UserData.lh=cell(1,lb_num_strings);
                        for sac=1:lb_num_strings
                            if ~isempty(lb_strings{sac})
                                num_lh=length(SSA_UserData.selave{sac})/2;
                                if sac==lb_pos
                                    dcol=p_para.selave_active_col;
                                else
                                    dcol=p_para.selave_col;
                                end
                                for selc=1:num_lh
                                    SSA_UserData.lh{sac}(selc)=line(SSA_UserData.selave{sac}(2*selc-1:2*selc),(1.05-(sac-1)/lb_num_strings)*ones(1,2),...
                                        'Visible',p_para.selave_vis,'Color',dcol,'LineStyle',p_para.selave_ls,'LineWidth',p_para.selave_lw);
                                end
                            end
                        end
                        yval=1.05-(lb_pos-1)/lb_num_strings;
                        SSA_UserData.lh{lb_pos}(1)=line([ax_x ax_x],yval*ones(1,2),...
                            'Color',p_para.selave_col,'LineStyle',p_para.selave_ls,'LineWidth',p_para.selave_lw,'UserData',ax_x);
                    end
                    drawnow;

                    set(SSA_UserData.fh,'WindowButtonMotionFcn',{@SSA_set_selave,SSA_UserData},...
                        'WindowButtonUpFcn',{@SSA_end_selave,SSA_UserData},'Interruptible','off','BusyAction','cancel')
                    set(SSA_UserData.ah,'ButtonDownFcn','','Interruptible','off','BusyAction','cancel')
                    for trac=1:d_para.num_trains
                        set(SSA_UserData.spike_lh{trac},'ButtonDownFcn','','Interruptible','off','BusyAction','cancel')
                    end
                    set(SSA_UserData.image_mh,'ButtonDownFcn','','Interruptible','off','BusyAction','cancel')
                    set(SSA_UserData.thin_mar_lh,'ButtonDownFcn','','Interruptible','off','BusyAction','cancel')
                    set(SSA_UserData.thick_mar_lh,'ButtonDownFcn','','Interruptible','off','BusyAction','cancel')
                    set(SSA_UserData.thin_sep_lh,'ButtonDownFcn','','Interruptible','off','BusyAction','cancel')
                    set(SSA_UserData.thick_sep_lh,'ButtonDownFcn','','Interruptible','off','BusyAction','cancel')
                    set(SSA_UserData.sgs_lh,'ButtonDownFcn','','Interruptible','off','BusyAction','cancel')
                    set(SSA_UserData.fh,'Userdata',SSA_UserData)
                end
            elseif shftIsPressed
                set(SSA_UserData.fh,'WindowButtonUpFcn',[])
                lb_num_strings=length(lb_strings)-1;
                yval=1.05-(lb_pos-1)/lb_num_strings;
                if lb_pos<=lb_num_strings
                    int_begs=SSA_UserData.selave{lb_pos}(1:2:length(SSA_UserData.selave{lb_pos}));
                    int_ends=SSA_UserData.selave{lb_pos}(2:2:length(SSA_UserData.selave{lb_pos}));
                else
                    int_begs=[];
                    int_ends=[];
                end
                ax_pos=get(SSA_UserData.ah,'CurrentPoint');
                first_corner_x=ax_pos(1,1);
                first_corner_y=ax_pos(1,2);
                window=rectangle('Position',[first_corner_x, first_corner_y, 0.01, 0.01]);
                dummy_marked=SSA_UserData.marked_indy;
                while shftIsPressed
                    ax_pos=get(SSA_UserData.ah,'CurrentPoint');
                    second_corner_x=ax_pos(1,1);
                    second_corner_y=ax_pos(1,2);
                    if second_corner_x ~= first_corner_x && second_corner_y ~= first_corner_y
                        set(window,'Position',[min(first_corner_x,second_corner_x), min(first_corner_y,second_corner_y), abs(second_corner_x-first_corner_x), abs(second_corner_y-first_corner_y)])
                        drawnow
                        top_mark=max([first_corner_y second_corner_y]);
                        bottom_mark=min([first_corner_y second_corner_y]);
                        if top_mark>=yval && bottom_mark<=yval
                            left_mark=min(first_corner_x,second_corner_x);
                            right_mark=max(first_corner_x,second_corner_x);
                            SSA_UserData.marked_indy=unique([dummy_marked find(int_ends>=left_mark & int_begs<=right_mark)]);
                        else
                            SSA_UserData.marked_indy=dummy_marked;
                        end
                        SSA_UserData.flag=(~isempty(SSA_UserData.marked_indy));
                        
                        set(SSA_UserData.lh{lb_pos},'Color',p_para.selave_active_col)
                        set(SSA_UserData.lh{lb_pos}(SSA_UserData.marked_indy),'Color',p_para.selave_marked_col)
                    end
                    pause(0.001);
                    modifiers=get(SSA_UserData.fh,'CurrentModifier');
                    shftIsPressed=ismember('shift',modifiers);
                end
                delete(window)
                
                % ################################################
                
                if SSA_UserData.flag
                    SSA_UserData.initial_XData=zeros(1,length(SSA_UserData.marked_indy)*2);
                    for idx=1:length(SSA_UserData.marked_indy)
                        SSA_UserData.initial_XData(idx*2-1:idx*2)=SSA_UserData.selave{lb_pos}(SSA_UserData.marked_indy(idx)*2-1:SSA_UserData.marked_indy(idx)*2);
                    end
                    SSA_UserData.initial_XPos=ax_x;
                end
                
                set(SSA_UserData.fh,'Userdata',SSA_UserData)
                set(SSA_UserData.um,'CallBack',{@SSA_delete_selave,SSA_UserData})
                set(SSA_UserData.fh,'WindowButtonMotionFcn',{@SSA_get_coordinates,SSA_UserData},'WindowButtonUpFcn',[],...
                    'KeyPressFcn',{@SSA_keyboard,SSA_UserData})
                set([SSA_UserData.lh{:}],'ButtonDownFcn',[])
                if ~isempty(SSA_UserData.lh) && lb_pos<=length(SSA_UserData.lh)
                    set(SSA_UserData.lh{lb_pos}(SSA_UserData.marked_indy),'ButtonDownFcn',{@SSA_start_move_selave,SSA_UserData},'UIContextMenu',SSA_UserData.cm)
                end
                set(SSA_UserData.ah,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                for trac=1:d_para.num_trains
                    set(SSA_UserData.spike_lh{trac},'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                end
                set(SSA_UserData.image_mh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thin_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thick_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thin_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thick_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.sgs_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.fh,'Userdata',SSA_UserData)
            end
        end
    end


    function SSA_set_selave(varargin)
        SSA_UserData=varargin{3};
        SSA_UserData=get(SSA_UserData.fh,'UserData');

        ax_pos=get(SSA_UserData.ah,'CurrentPoint');
        ax_x_ok=SSA_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SSA_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;
        ax_x=round(ax_pos(1,1)/SSA_UserData.dts)*SSA_UserData.dts;
        
        lb_pos=get(SSA_listbox,'Value');
        num_lh=length(SSA_UserData.lh{lb_pos});
        int_beg=get(SSA_UserData.lh{lb_pos}(num_lh),'UserData');

        if (ax_x>SSA_UserData.closestLeft && ax_x<SSA_UserData.closestRight)
            set(SSA_UserData.lh{lb_pos}(num_lh),'XData',[int_beg ax_x],'Color',p_para.selave_active_col)
        else
            set(SSA_UserData.lh{lb_pos}(num_lh),'XData',[int_beg ax_x],'Color',p_para.selave_overlap_col)
        end
        drawnow;

        if ax_x_ok && ax_y_ok
            ax_x=round(ax_pos(1,1)/SSA_UserData.dts)*SSA_UserData.dts;
            if int_beg<ax_x
                set(SSA_UserData.tx,'str',['Interval: ',num2str(int_beg),' - ',num2str(ax_x)]);
            else
                set(SSA_UserData.tx,'str',['Interval: ',num2str(ax_x),' - ',num2str(int_beg)]);
            end
        else
            set(SSA_UserData.tx,'str','Out of range');
        end
        set(SSA_UserData.fh,'Userdata',SSA_UserData)
    end


    function SSA_end_selave(varargin)
        SSA_UserData=varargin{3};
        SSA_UserData=get(SSA_UserData.fh,'UserData');
        
        lb_pos=get(SSA_listbox,'Value');
        num_lh=length(SSA_UserData.lh{lb_pos});
        ax_pos=get(SSA_UserData.ah,'CurrentPoint');
        ax_x=round(ax_pos(1,1)/SSA_UserData.dts)*SSA_UserData.dts;
        if (ax_x>SSA_UserData.closestLeft && ax_x<SSA_UserData.closestRight)
            int_beg=get(SSA_UserData.lh{lb_pos}(num_lh),'UserData');
            SSA_UserData.selave{lb_pos}(2*num_lh-1:2*num_lh)=[int_beg ax_x];
            set(SSA_UserData.lh{lb_pos}(num_lh),'XData',[int_beg ax_x],'Color',p_para.selave_active_col)
        else
            delete(SSA_UserData.lh{lb_pos}(num_lh));
            SSA_UserData.lh{lb_pos}=SSA_UserData.lh{lb_pos}(1:num_lh-1);
            num_lh=num_lh-1;
        end
        drawnow;

        lb_strings=get(SSA_listbox,'String');
        odds=2*(1:num_lh)-1;
        evens=odds+1;
        for swapc=find(SSA_UserData.selave{lb_pos}(evens)<SSA_UserData.selave{lb_pos}(odds))
            dummy=SSA_UserData.selave{lb_pos}(evens(swapc));
            SSA_UserData.selave{lb_pos}(evens(swapc))=SSA_UserData.selave{lb_pos}(odds(swapc));
            SSA_UserData.selave{lb_pos}(odds(swapc))=dummy;
        end
        if num_lh>1
            [dummy,indys]=sort(SSA_UserData.selave{lb_pos}(odds));
            SSA_UserData.selave{lb_pos}=SSA_UserData.selave{lb_pos}(reshape([odds(indys); evens(indys)],1,length(odds)*2));
            lb_string=['[',num2str(SSA_UserData.selave{lb_pos}),']'];
            lb_string=regexprep(lb_string,'\s+',' ');
            spacepos=find(isspace(lb_string));
            sindy=2:2:length(spacepos);
            for sppc=sindy(end):-2:2
                lb_string=[lb_string(1:spacepos(sppc)) '   ' lb_string(spacepos(sppc)+1:length(lb_string))];
            end
        else
            lb_string=['[',num2str(SSA_UserData.selave{lb_pos}),']'];
        end

        lb_strings{lb_pos}=lb_string;
        if ~isempty(lb_strings{length(lb_strings)})
            SSA_UserData.selave{length(lb_strings)+1}=[];
            lb_strings{length(lb_strings)+1}='';
        end
        set(SSA_listbox,'String',lb_strings)
        set(SSA_edit,'String',lb_strings{lb_pos})
        
        
        if isfield(SSA_UserData,'lh')
            for rc=1:length(SSA_UserData.lh)
                for cc=1:length(SSA_UserData.lh{rc})
                    if ishandle(SSA_UserData.lh{rc}(cc))
                        delete(SSA_UserData.lh{rc}(cc))
                    end
                end
            end
        end
        lb_num_strings=length(lb_strings);
        SSA_UserData.lh=cell(1,lb_num_strings);
        for sac=1:lb_num_strings
            if ~isempty(lb_strings{sac})
                num_lh=length(SSA_UserData.selave{sac})/2;
                if sac==lb_pos
                    dcol=p_para.selave_active_col;
                else
                    dcol=p_para.selave_col;
                end
                for selc=1:num_lh
                    SSA_UserData.lh{sac}(selc)=line(SSA_UserData.selave{sac}(2*selc-1:2*selc),(1.05-(sac-1)/(lb_num_strings-1))*ones(1,2),...
                        'Visible',p_para.selave_vis,'Color',dcol,'LineStyle',p_para.selave_ls,'LineWidth',p_para.selave_lw);
                end
            end
        end
        
        set(SSA_UserData.fh,'Userdata',SSA_UserData,'Interruptible','on')
        set(SSA_UserData.um,'CallBack',{@SSA_delete_selave,SSA_UserData})
        set(SSA_UserData.fh,'WindowButtonMotionFcn',{@SSA_get_coordinates,SSA_UserData},'KeyPressFcn',{@SSA_keyboard,SSA_UserData},'WindowButtonUpFcn',[])
        set([SSA_UserData.lh{:}],'ButtonDownFcn',[])
        set([SSA_UserData.lh{lb_pos}],'ButtonDownFcn',{@SSA_start_move_selave,SSA_UserData},'UIContextMenu',SSA_UserData.cm)
        set(SSA_UserData.ah,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData},'Interruptible','on')
        for trac=1:d_para.num_trains
            set(SSA_UserData.spike_lh{trac},'ButtonDownFcn',{@SSA_start_selave,SSA_UserData},'Interruptible','on')
        end
        set(SSA_UserData.image_mh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData},'Interruptible','on')
        set(SSA_UserData.thin_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData},'Interruptible','on')
        set(SSA_UserData.thick_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData},'Interruptible','on')
        set(SSA_UserData.thin_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData},'Interruptible','on')
        set(SSA_UserData.thick_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData},'Interruptible','on')
        set(SSA_UserData.sgs_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData},'Interruptible','on')
        set(SSA_UserData.fh,'Userdata',SSA_UserData)
    end


    function SSA_delete_selave(varargin)
        SSA_UserData=varargin{3};
        SSA_UserData=get(SSA_UserData.fh,'UserData');
        
        if (SSA_UserData.flag)
            lb_pos=get(SSA_listbox,'Value');
            SSA_UserData.selave{lb_pos}=setdiff(SSA_UserData.selave{lb_pos},SSA_UserData.selave{lb_pos}([SSA_UserData.marked_indy*2-1 SSA_UserData.marked_indy*2]));
            SSA_UserData.marked_indy=[];
            SSA_UserData.flag=0;
        else
            lb_pos=get(SSA_listbox,'Value');
            dummy=find(SSA_UserData.lh{lb_pos} == gco);
            SSA_UserData.selave{lb_pos}=setdiff(SSA_UserData.selave{lb_pos},SSA_UserData.selave{lb_pos}([dummy*2-1 dummy*2]));
        end

        lb_strings=get(SSA_listbox,'String');
        num_lh=length(SSA_UserData.selave{lb_pos})/2;
        if num_lh==0
            SSA_UserData.selave=SSA_UserData.selave(setdiff(1:length(lb_strings),lb_pos));
            lb_strings=lb_strings(setdiff(1:length(lb_strings),lb_pos));
        else
            lb_string=['[',num2str(SSA_UserData.selave{lb_pos}),']'];
            if num_lh>1
                lb_string=regexprep(lb_string,'\s+',' ');
                spacepos=find(isspace(lb_string));
                sindy=2:2:length(spacepos);
                for sppc=sindy(end):-2:2
                    lb_string=[lb_string(1:spacepos(sppc)) '   ' lb_string(spacepos(sppc)+1:length(lb_string))];
                end
            end
            lb_strings{lb_pos}=lb_string;
        end
        if ~isempty(lb_strings{length(lb_strings)})
            SSA_UserData.selave{length(lb_strings)+1}=[];
            lb_strings{length(lb_strings)+1}='';
        end
        lb_num_strings=length(lb_strings)-1;
        if isfield(SSA_UserData,'lh')
            for rc=1:length(SSA_UserData.lh)
                for cc=1:length(SSA_UserData.lh{rc})
                    if ishandle(SSA_UserData.lh{rc}(cc))
                        delete(SSA_UserData.lh{rc}(cc))
                    end
                end
            end
        end
        SSA_UserData.lh=cell(1,lb_num_strings);
        for sac=1:lb_num_strings
            num_lh=length(SSA_UserData.selave{sac})/2;
            if sac==lb_pos
                dcol=p_para.selave_active_col;
            else
                dcol=p_para.selave_col;
            end
            for selc=1:num_lh
                SSA_UserData.lh{sac}(selc)=line(SSA_UserData.selave{sac}(2*selc-1:2*selc),(1.05-(sac-1)/lb_num_strings)*ones(1,2),...
                    'Visible',p_para.selave_vis,'Color',dcol,'LineStyle',p_para.selave_ls,'LineWidth',p_para.selave_lw);
            end
        end
        set(SSA_listbox,'Value',lb_pos);
        set(SSA_listbox,'String',lb_strings)
        set(SSA_edit,'String',lb_strings{lb_pos})

        set(SSA_UserData.fh,'Userdata',SSA_UserData)
        set(SSA_UserData.um,'CallBack',{@SSA_delete_selave,SSA_UserData})
        set(SSA_UserData.fh,'WindowButtonMotionFcn',{@SSA_get_coordinates,SSA_UserData},'KeyPressFcn',{@SSA_keyboard,SSA_UserData})
        set([SSA_UserData.lh{:}],'ButtonDownFcn',[])
        if ~isempty(SSA_UserData.lh) && lb_pos<=length(SSA_UserData.lh)
            set([SSA_UserData.lh{lb_pos}],'ButtonDownFcn',{@SSA_start_move_selave,SSA_UserData},'UIContextMenu',SSA_UserData.cm)
        end
        set(SSA_UserData.ah,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        for trac=1:d_para.num_trains
            set(SSA_UserData.spike_lh{trac},'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        end
        set(SSA_UserData.image_mh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.thin_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.thick_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.thin_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.thick_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.sgs_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.fh,'Userdata',SSA_UserData)
    end


    function SSA_start_move_selave(varargin)
        SSA_UserData=varargin{3};
        SSA_UserData=get(SSA_UserData.fh,'UserData');
        
        lb_pos=get(SSA_listbox,'Value');
        seltype=get(SSA_UserData.fh,'SelectionType'); % Right-or-left click?
        if strcmp(seltype,'alt')
            modifiers=get(SSA_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                index=find(SSA_UserData.lh{lb_pos}(:) == gco);
                if (~SSA_UserData.flag)
                    SSA_UserData.flag=1;
                end
                SSA_UserData.marked_indy=[SSA_UserData.marked_indy index];
                set(gco,'Color',p_para.selave_marked_col);
                set(SSA_UserData.fh,'Userdata',SSA_UserData)
                set(SSA_UserData.um,'CallBack',{@SSA_delete_selave,SSA_UserData})
                set(SSA_UserData.fh,'WindowButtonMotionFcn',{@SSA_get_coordinates,SSA_UserData},'KeyPressFcn',{@SSA_keyboard,SSA_UserData})
                set([SSA_UserData.lh{:}],'ButtonDownFcn',[])
                set([SSA_UserData.lh{lb_pos}],'ButtonDownFcn',{@SSA_start_move_selave,SSA_UserData},'UIContextMenu',SSA_UserData.cm)
                set(SSA_UserData.ah,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                for trac=1:d_para.num_trains
                    set(SSA_UserData.spike_lh{trac},'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                end
                set(SSA_UserData.image_mh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thin_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thick_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thin_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thick_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.sgs_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.fh,'Userdata',SSA_UserData)
            end
        else
            ax_x=get(SSA_UserData.ah,'CurrentPoint');
            SSA_UserData.initial_XPos=round(ax_x(1,1)/SSA_UserData.dts)*SSA_UserData.dts;
            if ~SSA_UserData.flag
                lb_strings=get(SSA_listbox,'String');
                lb_num_strings=length(lb_strings)-1;
                lb_pos=get(SSA_listbox,'Value');
                for sac=1:lb_num_strings
                    num_lh=length(SSA_UserData.selave{sac})/2;
                    if sac==lb_pos
                        dcol=p_para.selave_active_col;
                    else
                        dcol=p_para.selave_col;
                    end
                    for selc=1:num_lh
                        set(SSA_UserData.lh{sac}(selc),'Color',dcol);
                    end
                end
                SSA_UserData.marked_indy=find(SSA_UserData.lh{lb_pos}(:) == gco);
                set(SSA_listbox,'Value',lb_pos);
                set(SSA_edit,'String',lb_strings{lb_pos})
                SSA_UserData.initial_XData=get(gco,'XData');
            else
                SSA_UserData.initial_XData=zeros(1,length(SSA_UserData.marked_indy)*2);
                for idx=1:length(SSA_UserData.marked_indy)
                    SSA_UserData.initial_XData(idx*2-1:idx*2)=SSA_UserData.selave{lb_pos}(SSA_UserData.marked_indy(idx)*2-1:SSA_UserData.marked_indy(idx)*2);
                end
            end
            SSA_UserData.flag=0;
            set(SSA_UserData.fh,'WindowButtonMotionFcn',{@SSA_move_selave,SSA_UserData})
            set(SSA_UserData.ah,'ButtonDownFcn','')
            for trac=1:d_para.num_trains
                set(SSA_UserData.spike_lh{trac},'ButtonDownFcn','')
            end
            set(SSA_UserData.image_mh,'ButtonDownFcn','')
            set(SSA_UserData.thin_mar_lh,'ButtonDownFcn','')
            set(SSA_UserData.thick_mar_lh,'ButtonDownFcn','')
            set(SSA_UserData.thin_sep_lh,'ButtonDownFcn','')
            set(SSA_UserData.thick_sep_lh,'ButtonDownFcn','')
            set(SSA_UserData.sgs_lh,'ButtonDownFcn','')
            set(SSA_UserData.fh,'Userdata',SSA_UserData)
        end
    end


    function SSA_move_selave(varargin)
        SSA_UserData=varargin{3};
        SSA_UserData=get(SSA_UserData.fh,'UserData');

        ax_pos=get(SSA_UserData.ah,'CurrentPoint');
        ax_x=round(ax_pos(1,1)/SSA_UserData.dts)*SSA_UserData.dts;
        ax_x_ok=SSA_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SSA_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;
        lb_pos=get(SSA_listbox,'Value');
        for idx=1:length(SSA_UserData.marked_indy)
            XData=SSA_UserData.initial_XData(2*idx-1:2*idx)+ax_x-SSA_UserData.initial_XPos;
            if (SSA_UserData.initial_XData(2*idx-1)+ax_x-SSA_UserData.initial_XPos>SSA_UserData.tmin) && (SSA_UserData.initial_XData(2*idx)+ax_x-SSA_UserData.initial_XPos<SSA_UserData.tmax)
                set(SSA_UserData.lh{lb_pos}(SSA_UserData.marked_indy(idx)),'XData',XData,'Color',p_para.selave_marked_col)
            else
                set(SSA_UserData.lh{lb_pos}(SSA_UserData.marked_indy(idx)),'Color','w')
            end
        end
        drawnow;
        
        if ax_x_ok && ax_y_ok
            ax_x=round(ax_pos(1,1)/SSA_UserData.dts)*SSA_UserData.dts;
            if length(SSA_UserData.marked_indy)==1
                set(SSA_UserData.tx,'str',['Interval: ',num2str(XData(1)),' - ',num2str(XData(2))]);
            else
                set(SSA_UserData.tx,'str',['Time: ', num2str(ax_x)]);
            end
        else
            set(SSA_UserData.tx,'str','Out of range');
        end
        set(SSA_UserData.fh,'WindowButtonUpFcn',{@SSA_stop_move_selave,SSA_UserData})
    end


    function SSA_stop_move_selave(varargin)
        SSA_UserData=varargin{3};
        SSA_UserData=get(SSA_UserData.fh,'UserData');
        ax_pos=get(SSA_UserData.ah,'CurrentPoint');
        ax_x=round(ax_pos(1,1)/SSA_UserData.dts)*SSA_UserData.dts;

        lb_strings=get(SSA_listbox,'String');
        lb_pos=get(SSA_listbox,'Value');
        int_begs=SSA_UserData.selave{lb_pos}(1:2:length(SSA_UserData.selave{lb_pos}));
        int_ends=SSA_UserData.selave{lb_pos}(2:2:length(SSA_UserData.selave{lb_pos}));
        %int_begs=int_begs(setdiff(1:length(int_begs),SSA_UserData.marked_indy));
        %int_ends=int_ends(setdiff(1:length(int_ends),SSA_UserData.marked_indy));
        num_lh=length(int_begs);
        
        overlap=zeros(1,length(SSA_UserData.marked_indy));
        for idx=1:length(SSA_UserData.marked_indy)
            XData=SSA_UserData.initial_XData(2*idx-1:2*idx)+ax_x-SSA_UserData.initial_XPos;
            if (XData(1)>SSA_UserData.tmin) && (XData(2)<=SSA_UserData.tmax)
                for idx2=setdiff(1:num_lh,SSA_UserData.marked_indy)
                    if (XData(1)<=int_ends(idx2)) && (XData(2)>=int_begs(idx2))
                        overlap(idx)=1;
                        break
                    end
                end
            else
                overlap(idx)=1;
            end
        end
        for idx=1:length(SSA_UserData.marked_indy)
            if overlap(idx)==0
                XData=SSA_UserData.initial_XData(2*idx-1:2*idx)+ax_x-SSA_UserData.initial_XPos;
                SSA_UserData.selave{lb_pos}(2*SSA_UserData.marked_indy(idx)-1:2*SSA_UserData.marked_indy(idx))=XData;
            else
                SSA_UserData.selave{lb_pos}=SSA_UserData.selave{lb_pos}(setdiff(1:length(SSA_UserData.selave{lb_pos}),2*SSA_UserData.marked_indy(idx)-1:2*SSA_UserData.marked_indy(idx)));
                SSA_UserData.marked_indy(idx+1:end)=SSA_UserData.marked_indy(idx+1:end)-1;
            end
        end

        num_lh=length(SSA_UserData.selave{lb_pos})/2;
        odds=2*(1:num_lh)-1;
        evens=odds+1;
        for swapc=find(SSA_UserData.selave{lb_pos}(evens)<SSA_UserData.selave{lb_pos}(odds))
            dummy=SSA_UserData.selave{lb_pos}(evens(swapc));
            SSA_UserData.selave{lb_pos}(evens(swapc))=SSA_UserData.selave{lb_pos}(odds(swapc));
            SSA_UserData.selave{lb_pos}(odds(swapc))=dummy;
        end
        if num_lh>1
            [dummy,indys]=sort(SSA_UserData.selave{lb_pos}(odds));
            SSA_UserData.selave{lb_pos}=SSA_UserData.selave{lb_pos}(reshape([odds(indys); evens(indys)],1,length(odds)*2));
            lb_string=['[',num2str(SSA_UserData.selave{lb_pos}),']'];
            lb_string=regexprep(lb_string,'\s+',' ');
            spacepos=find(isspace(lb_string));
            sindy=2:2:length(spacepos);
            for sppc=sindy(end):-2:2
                lb_string=[lb_string(1:spacepos(sppc)) '   ' lb_string(spacepos(sppc)+1:length(lb_string))];
            end
        else
            lb_string=['[',num2str(SSA_UserData.selave{lb_pos}),']'];
        end
        lb_strings{lb_pos}=lb_string;

        lb_num_strings=length(lb_strings)-1;
        if isfield(SSA_UserData,'lh')
            for rc=1:length(SSA_UserData.lh)
                for cc=1:length(SSA_UserData.lh{rc})
                    if ishandle(SSA_UserData.lh{rc}(cc))
                        delete(SSA_UserData.lh{rc}(cc))
                    end
                end
            end
        end
        SSA_UserData.lh=cell(1,lb_num_strings);
        for sac=1:lb_num_strings
            num_lh=length(SSA_UserData.selave{sac})/2;
            if sac==lb_pos
                dcol=p_para.selave_active_col;
            else
                dcol=p_para.selave_col;
            end
            for selc=1:num_lh
                SSA_UserData.lh{sac}(selc)=line(SSA_UserData.selave{sac}(2*selc-1:2*selc),(1.05-(sac-1)/lb_num_strings)*ones(1,2),...
                    'Visible',p_para.selave_vis,'Color',dcol,'LineStyle',p_para.selave_ls,'LineWidth',p_para.selave_lw);
            end
        end        
        
        SSA_UserData.marked_indy=[];
        set(SSA_listbox,'String',lb_strings)
        set(SSA_edit,'String',lb_strings{lb_pos})
        set(SSA_UserData.fh,'Pointer','arrow')
        drawnow;

        set(SSA_UserData.fh,'Userdata',SSA_UserData)
        set(SSA_UserData.um,'CallBack',{@SSA_delete_selave,SSA_UserData})
        set(SSA_UserData.fh,'WindowButtonMotionFcn',{@SSA_get_coordinates,SSA_UserData},'KeyPressFcn',{@SSA_keyboard,SSA_UserData})
        set([SSA_UserData.lh{:}],'ButtonDownFcn',[])
        if ~isempty(SSA_UserData.lh) && lb_pos<=length(SSA_UserData.lh)
            set([SSA_UserData.lh{lb_pos}],'ButtonDownFcn',{@SSA_start_move_selave,SSA_UserData},'UIContextMenu',SSA_UserData.cm)
        end
        set(SSA_UserData.ah,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        for trac=1:d_para.num_trains
            set(SSA_UserData.spike_lh{trac},'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        end
        set(SSA_UserData.image_mh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.thin_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.thick_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.thin_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.thick_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.sgs_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
        set(SSA_UserData.fh,'Userdata',SSA_UserData)
    end


    function SSA_keyboard(varargin)
        SSA_UserData=varargin{3};
        SSA_UserData=get(SSA_UserData.fh,'UserData');
        
        if strcmp(varargin{2}.Key,'delete')
            lb_strings=get(SSA_listbox,'String');
            if SSA_UserData.flag
                lb_pos=get(SSA_listbox,'Value');
                SSA_UserData.selave{lb_pos}=setdiff(SSA_UserData.selave{lb_pos},SSA_UserData.selave{lb_pos}([SSA_UserData.marked_indy*2-1 SSA_UserData.marked_indy*2]));
                SSA_UserData.marked_indy=[];
                SSA_UserData.flag=0;
            else
                lb_pos=get(SSA_listbox,'Value');
                dummy=find(SSA_UserData.lh{lb_pos} == gco);
                SSA_UserData.selave{lb_pos}=setdiff(SSA_UserData.selave{lb_pos},SSA_UserData.selave{lb_pos}([dummy*2-1 dummy*2]));
            end

            num_lh=length(SSA_UserData.selave{lb_pos})/2;
            if num_lh==0
                SSA_UserData.selave=SSA_UserData.selave(setdiff(1:length(lb_strings),lb_pos));
                lb_strings=lb_strings(setdiff(1:length(lb_strings),lb_pos));
            else
                lb_string=['[',num2str(SSA_UserData.selave{lb_pos}),']'];
                if num_lh>1
                    lb_string=regexprep(lb_string,'\s+',' ');
                    spacepos=find(isspace(lb_string));
                    sindy=2:2:length(spacepos);
                    for sppc=sindy(end):-2:2
                        lb_string=[lb_string(1:spacepos(sppc)) '   ' lb_string(spacepos(sppc)+1:length(lb_string))];
                    end
                end
                lb_strings{lb_pos}=lb_string;
            end
            if ~isempty(lb_strings{length(lb_strings)})
                SSA_UserData.selave{length(lb_strings)+1}=[];
                lb_strings{length(lb_strings)+1}='';
            end
            lb_num_strings=length(lb_strings)-1;
            if lb_pos>=lb_num_strings
                lb_pos=lb_pos-1;
            end
            if isfield(SSA_UserData,'lh')
                for rc=1:length(SSA_UserData.lh)
                    for cc=1:length(SSA_UserData.lh{rc})
                        if ishandle(SSA_UserData.lh{rc}(cc))
                            delete(SSA_UserData.lh{rc}(cc))
                        end
                    end
                end
            end
            SSA_UserData.lh=cell(1,lb_num_strings);
            for sac=1:lb_num_strings
                num_lh=length(SSA_UserData.selave{sac})/2;
                if sac==lb_pos
                    dcol=p_para.selave_active_col;
                else
                    dcol=p_para.selave_col;
                end
                for selc=1:num_lh
                    SSA_UserData.lh{sac}(selc)=line(SSA_UserData.selave{sac}(2*selc-1:2*selc),(1.05-(sac-1)/lb_num_strings)*ones(1,2),...
                        'Visible',p_para.selave_vis,'Color',dcol,'LineStyle',p_para.selave_ls,'LineWidth',p_para.selave_lw);
                end
            end
            set(SSA_listbox,'Value',lb_pos);
            set(SSA_listbox,'String',lb_strings)
            set(SSA_edit,'String',lb_strings{lb_pos})
            
            set(SSA_UserData.fh,'Userdata',SSA_UserData)
            set(SSA_UserData.um,'CallBack',{@SSA_delete_selave,SSA_UserData})
            set(SSA_UserData.fh,'WindowButtonMotionFcn',{@SSA_get_coordinates,SSA_UserData},'KeyPressFcn',{@SSA_keyboard,SSA_UserData})
            set([SSA_UserData.lh{:}],'ButtonDownFcn',[])
            if ~isempty(SSA_UserData.lh) && lb_pos<=length(SSA_UserData.lh)
                set([SSA_UserData.lh{lb_pos}],'ButtonDownFcn',{@SSA_start_move_selave,SSA_UserData},'UIContextMenu',SSA_UserData.cm)
            end
            set(SSA_UserData.ah,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            for trac=1:d_para.num_trains
                set(SSA_UserData.spike_lh{trac},'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            end
            set(SSA_UserData.image_mh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            set(SSA_UserData.thin_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            set(SSA_UserData.thick_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            set(SSA_UserData.thin_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            set(SSA_UserData.thick_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            set(SSA_UserData.sgs_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            set(SSA_UserData.fh,'Userdata',SSA_UserData)
        elseif strcmp(varargin{2}.Key,'a')
            modifiers=get(SSA_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                lb_pos=get(SSA_listbox,'Value');
                num_lh=length(SSA_UserData.selave{lb_pos})/2;
                SSA_UserData.marked_indy=1:num_lh;
                for selc=1:num_lh
                    set(SSA_UserData.lh{lb_pos}(selc),'Color',p_para.selave_marked_col);
                end
                SSA_UserData.flag=1;
                set(SSA_UserData.fh,'Userdata',SSA_UserData)
                set(SSA_UserData.um,'CallBack',{@SSA_delete_selave,SSA_UserData})
                set(SSA_UserData.fh,'WindowButtonMotionFcn',{@SSA_get_coordinates,SSA_UserData},'KeyPressFcn',{@SSA_keyboard,SSA_UserData})
                set([SSA_UserData.lh{:}],'ButtonDownFcn',[])
                set([SSA_UserData.lh{lb_pos}],'ButtonDownFcn',{@SSA_start_move_selave,SSA_UserData},'UIContextMenu',SSA_UserData.cm)
                set(SSA_UserData.ah,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                for trac=1:d_para.num_trains
                    set(SSA_UserData.spike_lh{trac},'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                end
                set(SSA_UserData.image_mh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thin_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thick_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thin_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.thick_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.sgs_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
                set(SSA_UserData.fh,'Userdata',SSA_UserData)
            end
        elseif strcmp(varargin{2}.Key,'c')
            modifiers=get(SSA_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                lb_pos=get(SSA_listbox,'Value');
                lb_strings=get(SSA_listbox,'String');
                lb_num_strings=length(lb_strings)-1;
                num_lh=length(SSA_UserData.selave{lb_pos})/2;
                SSA_UserData.initial_XData=zeros(1,length(SSA_UserData.marked_indy)*2);
                for idx=1:length(SSA_UserData.marked_indy)
                    SSA_UserData.initial_XData(2*idx-1:2*idx)=SSA_UserData.selave{lb_pos}(2*SSA_UserData.marked_indy(idx)-1:2*SSA_UserData.marked_indy(idx));
                    SSA_UserData.lh{lb_pos}(num_lh+idx)=line(SSA_UserData.initial_XData(2*idx-1:2*idx),(1.05-(lb_pos-1)/lb_num_strings)*ones(1,2),...
                        'Visible',p_para.selave_vis,'Color',p_para.selave_marked_col,'LineStyle',p_para.selave_ls,'LineWidth',p_para.selave_lw);
                end
                SSA_UserData.flag=0;
                SSA_UserData.marked_indy=num_lh+(1:length(SSA_UserData.marked_indy));
                SSA_UserData.selave{lb_pos}=[SSA_UserData.selave{lb_pos} SSA_UserData.initial_XData];
                ax_pos=get(SSA_UserData.ah,'CurrentPoint');
                SSA_UserData.initial_XPos=round(ax_pos(1,1)/SSA_UserData.dts)*SSA_UserData.dts;
                set(SSA_UserData.fh,'Userdata',SSA_UserData)
                set(SSA_UserData.fh,'WindowButtonMotionFcn',{@SSA_move_selave,SSA_UserData},'WindowButtonUpFcn',{@SSA_stop_move_selave,SSA_UserData})
                set(SSA_UserData.ah,'ButtonDownFcn','')
                for trac=1:d_para.num_trains
                    set(SSA_UserData.spike_lh{trac},'ButtonDownFcn','')
                end
                set(SSA_UserData.image_mh,'ButtonDownFcn','')
                set(SSA_UserData.thin_mar_lh,'ButtonDownFcn','')
                set(SSA_UserData.thick_mar_lh,'ButtonDownFcn','')
                set(SSA_UserData.thin_sep_lh,'ButtonDownFcn','')
                set(SSA_UserData.thick_sep_lh,'ButtonDownFcn','')
                set(SSA_UserData.sgs_lh,'ButtonDownFcn','')
                set(SSA_UserData.fh,'Userdata',SSA_UserData)
            end
        end
    end


    function SSA_Load_selave(varargin)
        if isfield(d_para,'matfile') && ischar(d_para.matfile)
            [d_para.filename,d_para.path]=uigetfile('*.mat','Pick a .mat-file',d_para.matfile);
        else
            [d_para.filename,d_para.path]=uigetfile('*.mat','Pick a .mat-file');
        end
        if isequal(d_para.filename,0) || isequal(d_para.path,0)
            return
        end
        d_para.matfile=[d_para.path d_para.filename];
        if d_para.matfile~=0
            SSA_UserData=get(f_para.num_fig,'UserData');
            data.matfile=d_para.matfile;
            data.default_variable='';
            data.content='selective averages';
            SPIKY('SPIKY_select_variable',gcbo,data,handles)
            variable=getappdata(handles.figure1,'variable');
            if ~isempty(variable) && ~strcmp(variable,'A9ZB1YC8X')
                data=getappdata(handles.figure1,'data');
                SSA_UserData.selave=squeeze(eval(['data.',variable]));
            end
            if ~isfield(SSA_UserData,'selave') || isempty(SSA_UserData.selave) || ~((iscell(SSA_UserData.selave) && length(SSA_UserData.selave)>1 && isnumeric(SSA_UserData.selave{1})) || ...
                    (isnumeric(SSA_UserData.selave) && ndims(SSA_UserData.selave)==2 && size(SSA_UserData.selave,1)>1))
                if ~strcmp(variable,'A9ZB1YC8X')
                    set(0,'DefaultUIControlFontSize',16);
                    mbh=msgbox(sprintf('The format of the variable is not correct. Please try again!'),'Warning','warn','modal');
                    htxt=findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                    uiwait(mbh);
                end
                ret=1;
                return
            end
            lb_strings=[];
            set(SSA_listbox,'String',lb_strings,'Value',1)

            figure(f_para.num_fig);
            if isfield(SSA_UserData,'lh')
                for rc=1:length(SSA_UserData.lh)
                    for cc=1:length(SSA_UserData.lh{rc})
                        if ishandle(SSA_UserData.lh{rc}(cc))
                            delete(SSA_UserData.lh{rc}(cc))
                        end
                    end
                end
                SSA_UserData.lh=[];
            end
            lb_num_strings=0;
            if iscell(SSA_UserData.selave)
                lb_strings=cell(1,length(SSA_UserData.selave));
                for selc=1:length(SSA_UserData.selave)
                    lb_strings{selc}=['[',num2str(SSA_UserData.selave{selc}),']; '];
                end
                lb_num_strings=length(lb_strings);
            end
            prob=[];
            for sac=1:lb_num_strings
                num_lh=length(SSA_UserData.selave{sac})/2;
                odds=2*(1:num_lh)-1;
                evens=odds+1;
                for swapc=find(SSA_UserData.selave{sac}(evens)<SSA_UserData.selave{sac}(odds))
                    dummy=SSA_UserData.selave{sac}(evens(swapc));
                    SSA_UserData.selave{sac}(evens(swapc))=SSA_UserData.selave{sac}(odds(swapc));
                    SSA_UserData.selave{sac}(odds(swapc))=dummy;
                end
                if num_lh>1
                    [dummy,indys]=sort(SSA_UserData.selave{sac}(odds));
                    SSA_UserData.selave{sac}=SSA_UserData.selave{sac}(reshape([odds(indys); evens(indys)],1,length(odds)*2));
                    if any(SSA_UserData.selave{sac}(evens(1:num_lh-1))>SSA_UserData.selave{sac}(odds(2:num_lh)))
                        prob=[prob sac];
                    end
                    lb_strings{sac}=['[',num2str(SSA_UserData.selave{sac}),']'];
                    lb_strings{sac}=regexprep(lb_strings{sac},'\s+',' ');
                    spacepos=find(isspace(lb_strings{sac}));
                    sindy=2:2:length(spacepos);
                    for sppc=sindy(end):-2:2
                        lb_strings{sac}=[lb_strings{sac}(1:spacepos(sppc)) '   ' lb_strings{sac}(spacepos(sppc)+1:length(lb_strings{sac}))];
                    end
                else
                    if ~isempty(SSA_UserData.selave{sac})
                        lb_strings{sac}=['[',regexprep(num2str(SSA_UserData.selave{sac}),'\s+',' '),']'];
                    else
                        lb_strings{sac}='';
                    end
                end
                if ~isempty(prob)
                    set(SSA_listbox,'Value',prob(1))
                    set(0,'DefaultUIControlFontSize',16);
                    mbh=msgbox(sprintf('Intervals for one group (row) of selective averages\nmust not overlap. Please fix this!'),'Warning','warn','modal');
                    htxt=findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                    uiwait(mbh);
                end
            end
            set(SSA_listbox,'String',lb_strings,'Value',1)
            lb_pos=get(SSA_listbox,'Value');
            lb_strings=get(SSA_listbox,'String');
            lb_num_strings=length(lb_strings);

            SSA_UserData.lh=cell(1,lb_num_strings);
            for sac=1:lb_num_strings
                if ~isempty(lb_strings{sac})
                    num_lh=length(SSA_UserData.selave{sac})/2;
                    if sac==lb_pos
                        dcol=p_para.selave_active_col;
                    else
                        dcol=p_para.selave_col;
                    end
                    for selc=1:num_lh
                        SSA_UserData.lh{sac}(selc)=line(SSA_UserData.selave{sac}(2*selc-1:2*selc),(1.05-(sac-1)/lb_num_strings)*ones(1,2),...
                            'Visible',p_para.selave_vis,'Color',dcol,'LineStyle',p_para.selave_ls,'LineWidth',p_para.selave_lw);
                    end
                end
            end
            SSA_UserData.selave{lb_num_strings+1}=[];
            lb_strings{lb_num_strings+1}='';
            set(SSA_listbox,'String',lb_strings);
            set(SSA_edit,'String',lb_strings{lb_pos})
            set(SSA_UserData.fh,'Userdata',SSA_UserData)
        end
    end


    function SSA_callback(varargin)
        d_para=getappdata(handles.figure1,'data_parameters');
        f_para=getappdata(handles.figure1,'figure_parameters');
        figure(f_para.num_fig);
        SSA_UserData=get(gcf,'Userdata');

        if gcbo==SSA_Cancel_pushbutton || gcbo==SIA_fig
            delete(SIA_fig)
        elseif gcbo==SSA_Reset_pushbutton
            set(SSA_edit,'String',[])
            SSA_UserData.selave=[];
            SSA_UserData.selave{1}=[];
            lb_strings=[];
            lb_strings{1}='';
            set(SSA_listbox,'String',lb_strings,'Value',1)
            if isfield(SSA_UserData,'lh')
                for rc=1:length(SSA_UserData.lh)
                    for cc=1:length(SSA_UserData.lh{rc})
                        if ishandle(SSA_UserData.lh{rc}(cc))
                            delete(SSA_UserData.lh{rc}(cc))
                        end
                    end
                end
                SSA_UserData.lh=[];
            end

            set(SSA_UserData.fh,'Userdata',SSA_UserData)
            set(SSA_UserData.um,'CallBack',{@SSA_delete_selave,SSA_UserData})
            set(SSA_UserData.fh,'WindowButtonMotionFcn',{@SSA_get_coordinates,SSA_UserData},'KeyPressFcn',{@SSA_keyboard,SSA_UserData})
            set(SSA_UserData.ah,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            for trac=1:d_para.num_trains
                set(SSA_UserData.spike_lh{trac},'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            end
            set(SSA_UserData.image_mh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            set(SSA_UserData.thin_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            set(SSA_UserData.thick_mar_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            set(SSA_UserData.thin_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            set(SSA_UserData.thick_sep_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            set(SSA_UserData.sgs_lh,'ButtonDownFcn',{@SSA_start_selave,SSA_UserData})
            set(SSA_UserData.fh,'Userdata',SSA_UserData)
        elseif gcbo==SSA_OK_pushbutton
            lb_strings=get(SSA_listbox,'String');
            lb_num_strings=length(lb_strings)-1;
            for sac=1:lb_num_strings
                [dummy,conv_ok]=str2num(char(lb_strings{sac}));
                if conv_ok==0 && ~isempty(lb_strings{sac})
                    set(0,'DefaultUIControlFontSize',16);
                    mbh=msgbox(sprintf('The values entered are not numeric!'),'Warning','warn','modal');
                    htxt=findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                    uiwait(mbh);
                    return
                end
            end
            prob=[];
            for sac=1:lb_num_strings
                num_lh=length(SSA_UserData.selave{sac})/2;
                odds=2*(1:num_lh)-1;
                evens=odds+1;
                for swapc=find(SSA_UserData.selave{sac}(evens)<SSA_UserData.selave{sac}(odds))
                    dummy=SSA_UserData.selave{sac}(evens(swapc));
                    SSA_UserData.selave{sac}(evens(swapc))=SSA_UserData.selave{sac}(odds(swapc));
                    SSA_UserData.selave{sac}(odds(swapc))=dummy;
                end
                if num_lh>1
                    [dummy,indys]=sort(SSA_UserData.selave{sac}(odds));
                    SSA_UserData.selave{sac}=SSA_UserData.selave{sac}(reshape([odds(indys); evens(indys)],1,length(odds)*2));
                    if any(SSA_UserData.selave{sac}(evens(1:num_lh-1))>SSA_UserData.selave{sac}(odds(2:num_lh)))
                        prob=[prob sac];
                    end
                    lb_strings{sac}=['[',num2str(round(SSA_UserData.selave{sac}/d_para.dts)*d_para.dts),']'];
                    lb_strings{sac}=regexprep(lb_strings{sac},'\s+',' ');
                    spacepos=find(isspace(lb_strings{sac}));
                    sindy=2:2:length(spacepos);
                    for sppc=sindy(end):-2:2
                        lb_strings{sac}=[lb_strings{sac}(1:spacepos(sppc)) '   ' lb_strings{sac}(spacepos(sppc)+1:length(lb_strings{sac}))];
                    end
                else
                    if ~isempty(SSA_UserData.selave{sac})
                        lb_strings{sac}=['[',num2str(round(SSA_UserData.selave{sac}/d_para.dts)*d_para.dts),']'];
                    else
                        lb_strings{sac}='';
                    end
                end
            end
            if ~isempty(prob)
                set(SSA_listbox,'Value',prob(1))
                set(0,'DefaultUIControlFontSize',16);
                mbh=msgbox(sprintf('Intervals for one group (row) of selective averages\nmust not overlap. Please fix this!'),'Warning','warn','modal');
                htxt=findobj(mbh,'Type','text');
                set(htxt,'FontSize',12,'FontWeight','bold')
                mb_pos=get(mbh,'Position');
                set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                uiwait(mbh);
                if gcbo==SSA_OK_pushbutton
                    return
                end
            else
                if isfield(SSA_UserData,'lh')
                    for rc=1:length(SSA_UserData.lh)
                        for cc=1:length(SSA_UserData.lh{rc})
                            if ishandle(SSA_UserData.lh{rc}(cc))
                                delete(SSA_UserData.lh{rc}(cc))
                            end
                        end
                    end
                    SSA_UserData.lh=[];
                end
            end
            SSA_UserData.marked_indy=[];
            SSA_UserData.flag=0;
            dummy=[];
            for lbc=1:lb_num_strings
                dummy=[dummy lb_strings{lbc},'; '];
            end
            dummy=dummy(1:length(dummy)-2);
            if ~isempty(dummy)
                d_para.selective_averages_str=dummy;
            else
                d_para.selective_averages_str='';
            end
            setappdata(handles.figure1,'data_parameters',d_para)

            set(SSA_panel,'HighlightColor','w')
            set(SSA_edit,'Enable','off')
            set(SSA_Down_pushbutton,'Enable','off')
            set(SSA_Up_pushbutton,'Enable','off')
            set(SSA_Delete_pushbutton,'Enable','off')
            set(SSA_Replace_pushbutton,'Enable','off')
            set(SSA_Add_pushbutton,'Enable','off')
            set(SSA_listbox,'Enable','off','Value',1)
            set(SSA_Load_pushbutton,'Enable','off')
            set(SSA_Cancel_pushbutton,'Enable','off')
            set(SSA_Reset_pushbutton,'Enable','off')
            set(SSA_OK_pushbutton,'Enable','off')
            set(SSA_edit,'String','')
            %set(gcf,'Userdata','SSA_UserData');

            % ########################################################

            set(STA_panel,'Visible','on','HighlightColor','k')
            set(STA_Down_pushbutton,'Visible','on')
            set(STA_Up_pushbutton,'Visible','on')
            set(STA_Delete_pushbutton,'Visible','on')
            set(STA_Replace_pushbutton,'Visible','on')
            set(STA_Add_pushbutton,'Visible','on')
            set(STA_listbox,'Visible','on')
            set(STA_edit,'Visible','on')
            set(STA_Load_pushbutton,'Visible','on')
            set(STA_Cancel_pushbutton,'Visible','on')
            set(STA_Reset_pushbutton,'Visible','on')
            set(STA_OK_pushbutton,'Visible','on','FontWeight','bold')
            uicontrol(STA_OK_pushbutton)

            STA_UserData=SSA_UserData;

            figure(f_para.num_fig);
            set(STA_UserData.fh,'Interruptible','on');
            set(STA_UserData.ah,'Interruptible','on');
            for trac=1:d_para.num_trains
                set(STA_UserData.spike_lh{trac},'Interruptible','on')
            end
            set(STA_UserData.image_mh,'Interruptible','on')
            set(STA_UserData.thin_mar_lh,'Interruptible','on')
            set(STA_UserData.thick_mar_lh,'Interruptible','on')
            set(STA_UserData.thin_sep_lh,'Interruptible','on')
            set(STA_UserData.thick_sep_lh,'Interruptible','on')
            set(STA_UserData.sgs_lh,'Interruptible','on')

            lb_strings=[];
            lb_num_strings=0;
            STA_UserData.trigave=[];
            if isfield(d_para,'triggered_averages')
                if iscell(d_para.triggered_averages)
                    STA_UserData.trigave=cell(1,length(d_para.triggered_averages));
                    for trigc=1:length(d_para.triggered_averages)
                        STA_UserData.trigave{trigc}=d_para.triggered_averages{trigc};
                    end
                    lb_num_strings=length(STA_UserData.trigave);
                end
            elseif isfield(d_para,'triggered_averages_str') && ~isempty(d_para.triggered_averages_str)
                %set(STA_edit,'String',d_para.triggered_averages_str)
                d_para.triggered_averages_str2=d_para.triggered_averages_str;
                if d_para.triggered_averages_str2(1)=='{'
                    d_para.triggered_averages_str2=d_para.triggered_averages_str2(2:end);
                end
                if d_para.triggered_averages_str2(end)=='}'
                    d_para.triggered_averages_str2=d_para.triggered_averages_str2(1:end-1);
                end
                str_seps=[0 find(d_para.triggered_averages_str2==';') length(d_para.triggered_averages_str2)+1];
                STA_UserData.trigave=cell(1,length(str_seps)-1);
                lb_strings=cell(1,length(str_seps)-1);
                lb_num_strings=length(lb_strings);
                for trac=1:lb_num_strings
                    dummy=strtrim(d_para.triggered_averages_str2(str_seps(trac)+1:str_seps(trac+1)-1));
                    STA_UserData.trigave{trac}=unique(str2num(dummy));
                end
            end
            lb_pos=get(STA_listbox,'Value');
            for trac=1:lb_num_strings
                num_lh=length(STA_UserData.trigave{trac});
                lb_strings{trac}=regexprep(num2str(STA_UserData.trigave{trac}),'\s+',' ');
                if num_lh>1
                    lb_strings{trac}=['[',num2str(STA_UserData.trigave{trac}),']'];
                    lb_strings{trac}=regexprep(lb_strings{trac},'\s+',' ');
                end
            end
            STA_UserData.trigave{lb_num_strings+1}=[];
            lb_strings{lb_num_strings+1}='';
            STA_UserData.lh=cell(1,lb_num_strings);
            for trac=1:lb_num_strings
                if trac==lb_pos
                    dcol=p_para.selave_active_col;
                else
                    dcol=p_para.selave_col;
                end
                for selc=1:length(STA_UserData.trigave{trac})
                    STA_UserData.lh{trac}(selc)=plot(STA_UserData.trigave{trac}(selc),(1.05-(trac-1)/lb_num_strings),...
                        'Visible',p_para.trigave_vis,'Marker',p_para.trigave_symb,'MarkerFaceColor',p_para.trigave_col,...
                        'Color',dcol,'LineStyle','none','LineWidth',p_para.trigave_lw);
                end
            end
            set(STA_listbox,'String',lb_strings)
            set(STA_edit,'String',lb_strings{1})

            set(STA_UserData.fh,'Userdata',STA_UserData)
            STA_UserData.cm=uicontextmenu;
            STA_UserData.um=uimenu(STA_UserData.cm,'label','Delete triggered average(s)','CallBack',{@STA_delete_trigave,STA_UserData});
            set(STA_UserData.fh,'WindowButtonMotionFcn',{@STA_get_coordinates,STA_UserData},'KeyPressFcn',{@STA_keyboard,STA_UserData});
            set([STA_UserData.lh{:}],'ButtonDownFcn',[],'UIContextMenu',[])   % ############
            if ~isempty(STA_UserData.lh) && lb_pos<=length(STA_UserData.lh)
                set(STA_UserData.lh{lb_pos},'ButtonDownFcn',{@STA_start_move_trigave,STA_UserData},'UIContextMenu',STA_UserData.cm)
            end
            set(STA_UserData.ah,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
            for trac=1:d_para.num_trains
                set(STA_UserData.spike_lh{trac},'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
            end
            set(STA_UserData.image_mh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
            set(STA_UserData.thin_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
            set(STA_UserData.thick_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
            set(STA_UserData.thin_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
            set(STA_UserData.thick_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
            set(STA_UserData.sgs_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
            set(STA_UserData.fh,'Userdata',STA_UserData)
        end
    end



% ########################################################
% ########################################################      STA
% ########################################################

    function STA_ListBox_callback(varargin)
        figure(f_para.num_fig);
        STA_UserData=get(gcf,'Userdata');
        lb_pos=get(STA_listbox,'Value');
        lb_strings=get(STA_listbox,'String');
        lb_num_strings=length(lb_strings)-1;
        if gcbo==STA_listbox
            for trac=1:lb_num_strings
                if trac==lb_pos
                    dcol=p_para.trigave_active_col;
                else
                    dcol=p_para.selave_col;
                end
                for selc=1:length(STA_UserData.trigave{trac})
                    set(STA_UserData.lh{trac}(selc),'Color',dcol);
                end
            end
        elseif gcbo==STA_Down_pushbutton
            if lb_pos<lb_num_strings
                dummy=lb_strings{lb_pos+1};
                lb_strings{lb_pos+1}=lb_strings{lb_pos};
                lb_strings{lb_pos}=dummy;
                dummy=STA_UserData.trigave{lb_pos+1};
                STA_UserData.trigave{lb_pos+1}=STA_UserData.trigave{lb_pos};
                STA_UserData.trigave{lb_pos}=dummy;
                set(STA_listbox,'Value',lb_pos+1)
            end
        elseif gcbo==STA_Up_pushbutton
            if lb_pos>1 && ~isempty(lb_strings{lb_pos})
                dummy=lb_strings{lb_pos-1};
                lb_strings{lb_pos-1}=lb_strings{lb_pos};
                lb_strings{lb_pos}=dummy;
                dummy=STA_UserData.trigave{lb_pos-1};
                STA_UserData.trigave{lb_pos-1}=STA_UserData.trigave{lb_pos};
                STA_UserData.trigave{lb_pos}=dummy;
                set(STA_listbox,'Value',lb_pos-1)
            end
        elseif gcbo==STA_Delete_pushbutton
            if lb_pos<=lb_num_strings
                lb_strings(lb_pos:lb_num_strings)=lb_strings(lb_pos+1:lb_num_strings+1);
                STA_UserData.trigave(lb_pos:lb_num_strings-1)=STA_UserData.trigave(lb_pos+1:lb_num_strings);
                if lb_pos<lb_num_strings
                    set(STA_listbox,'Value',lb_pos)
                else
                    set(STA_listbox,'Value',lb_pos-1)
                end
                lb_strings=lb_strings(1:lb_num_strings);
                STA_UserData.trigave=STA_UserData.trigave(1:lb_num_strings);
            end
        elseif gcbo==STA_Replace_pushbutton
            STA_str=get(STA_edit,'String');
            if ~isempty(STA_str)
                [dummy,conv_ok]=str2num(STA_str);
                if conv_ok==0
                    set(0,'DefaultUIControlFontSize',16);
                    mbh=msgbox(sprintf('The values entered are not numeric!'),'Warning','warn','modal');
                    htxt=findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                    uiwait(mbh);
                    return
                end
                STA_UserData.trigave{lb_pos}=round(sort(str2num(STA_str))/STA_UserData.dts)*STA_UserData.dts;
                lb_strings{lb_pos}=num2str(STA_UserData.trigave{lb_pos});
            end
        elseif gcbo==STA_Add_pushbutton
            STA_str=get(STA_edit,'String');
            if ~isempty(STA_str)
                [dummy,conv_ok]=str2num(STA_str);
                if conv_ok==0
                    set(0,'DefaultUIControlFontSize',16);
                    mbh=msgbox(sprintf('The values entered are not numeric!'),'Warning','warn','modal');
                    htxt=findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                    uiwait(mbh);
                    return
                end
                STA_UserData.trigave{lb_num_strings+1}=round(sort(dummy)/STA_UserData.dts)*STA_UserData.dts;
                lb_strings{lb_num_strings+1}=num2str(STA_UserData.trigave{lb_num_strings+1});
                set(STA_listbox,'Value',lb_num_strings+1)
                STA_UserData.trigave{lb_num_strings+2}=[];
                lb_strings{lb_num_strings+2}='';
            end
        end
        if isfield(STA_UserData,'lh')
            for rc=1:length(STA_UserData.lh)
                for cc=1:length(STA_UserData.lh{rc})
                    if ishandle(STA_UserData.lh{rc}(cc))
                        delete(STA_UserData.lh{rc}(cc))
                    end
                end
            end
        end
        lb_pos=get(STA_listbox,'Value');
        lb_num_strings=length(lb_strings)-1;

        STA_UserData.lh=cell(1,lb_num_strings);
        for trac=1:lb_num_strings
            num_lh=length(STA_UserData.trigave{trac});
            if num_lh>1
                lb_strings{trac}=['[',num2str(STA_UserData.trigave{trac}),']'];
                lb_strings{trac}=regexprep(lb_strings{trac},'\s+',' ');
            end
            if trac==lb_pos
                dcol=p_para.trigave_active_col;
            else
                dcol=p_para.trigave_col;
            end
            for selc=1:length(STA_UserData.trigave{trac})
                STA_UserData.lh{trac}(selc)=plot(STA_UserData.trigave{trac}(selc),(1.05-(trac-1)/lb_num_strings),...
                    'Visible',p_para.trigave_vis,'Marker',p_para.trigave_symb,'MarkerFaceColor',p_para.trigave_col,...
                    'Color',dcol,'LineStyle','none','LineWidth',p_para.trigave_lw);
            end
        end
        set(STA_listbox,'String',lb_strings)
        if lb_pos>0
            set(STA_edit,'String',regexprep(lb_strings{lb_pos},'\s+',' '))
        else
            lb_pos=1;
            set(STA_listbox,'Value',lb_pos);
            set(STA_edit,'String','')
        end

        set(STA_UserData.fh,'Userdata',STA_UserData)
        set(STA_UserData.um,'CallBack',{@STA_delete_trigave,STA_UserData})
        set(STA_UserData.fh,'WindowButtonMotionFcn',{@STA_get_coordinates,STA_UserData},'KeyPressFcn',{@STA_keyboard,STA_UserData}) %,'WindowButtonUpFcn','');
        set([STA_UserData.lh{:}],'ButtonDownFcn',[])
        if ~isempty(STA_UserData.lh) && lb_pos<=length(STA_UserData.lh)
            set(STA_UserData.lh{lb_pos},'ButtonDownFcn',{@STA_start_move_trigave,STA_UserData},'UIContextMenu',STA_UserData.cm)
        end
        set(STA_UserData.ah,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        for trac=1:d_para.num_trains
            set(STA_UserData.spike_lh{trac},'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
        end
        set(STA_UserData.image_mh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thin_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thick_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thin_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thick_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.sgs_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.fh,'Userdata',STA_UserData)
    end


    function STA_get_coordinates(varargin)
        STA_UserData=varargin{3};
        STA_UserData=get(STA_UserData.fh,'UserData');

        ax_pos=get(STA_UserData.ah,'CurrentPoint');
        ax_x_ok=STA_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=STA_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;
        if ax_x_ok && ax_y_ok
            ax_x=round(ax_pos(1,1)/STA_UserData.dts)*STA_UserData.dts;
            set(STA_UserData.tx,'str',['Time: ', num2str(ax_x)]);
        else
            set(STA_UserData.tx,'str','Out of range');
        end
    end


    function STA_pick_trigave(varargin)
        STA_UserData=varargin{3};
        STA_UserData=get(STA_UserData.fh,'UserData');

        ax_pos=get(STA_UserData.ah,'CurrentPoint');
        ax_x=round(ax_pos(1,1)/STA_UserData.dts)*STA_UserData.dts;
        ax_x_ok=STA_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=STA_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        lb_pos=get(STA_listbox,'Value');
        lb_strings=get(STA_listbox,'String');
        lb_num_strings=length(lb_strings)-1;

        modifiers=get(STA_UserData.fh,'CurrentModifier');
        if ax_x_ok && ax_y_ok
            seltype=get(STA_UserData.fh,'SelectionType'); % Right-or-left click?
            ctrlIsPressed=ismember('control',modifiers);
            if strcmp(seltype,'normal') || ctrlIsPressed                      % right or middle
                if lb_pos<=length(STA_UserData.trigave) && ~isempty(STA_UserData.trigave{lb_pos})
                    num_lh=length(STA_UserData.trigave{lb_pos});
                    for cc=1:num_lh
                        if ishandle(STA_UserData.lh{lb_pos}(cc))
                            delete(STA_UserData.lh{lb_pos}(cc))
                        end
                    end
                    STA_UserData.lh{lb_pos}=[];
                end
                if ~isempty(STA_UserData.trigave)
                    STA_UserData.trigave{lb_pos}=unique([STA_UserData.trigave{lb_pos} ax_x]);
                else
                    STA_UserData.trigave{lb_pos}=ax_x;
                end
                for selc=1:length(STA_UserData.trigave{lb_pos})
                    STA_UserData.lh{lb_pos}(selc)=plot(STA_UserData.trigave{lb_pos}(selc),(1.05-(lb_pos-1)/lb_num_strings),...
                        'Visible',p_para.trigave_vis,'Marker',p_para.trigave_symb,'MarkerFaceColor',p_para.trigave_col,...
                        'Color',p_para.trigave_active_col,'LineStyle','none','LineWidth',p_para.trigave_lw);
                end

                lb_strings{lb_pos}=['[',num2str(STA_UserData.trigave{lb_pos}),']'];
                if length(STA_UserData.trigave{lb_pos})>1
                    lb_strings{lb_pos}=regexprep(lb_strings{lb_pos},'\s+',' ');
                else
                    for rc=1:length(STA_UserData.lh)                        % new entry, move all up one line
                        for cc=1:length(STA_UserData.lh{rc})
                            if ishandle(STA_UserData.lh{rc}(cc))
                                delete(STA_UserData.lh{rc}(cc))
                            end
                        end
                    end
                    lb_num_strings=length(lb_strings);
                    STA_UserData.lh=cell(1,lb_num_strings);
                    for trac=1:lb_num_strings
                        if ~isempty(lb_strings{trac})
                            num_lh=length(STA_UserData.trigave{trac});
                            if trac==lb_pos
                                dcol=p_para.trigave_active_col;
                            else
                                dcol=p_para.trigave_col;
                            end
                            for selc=1:num_lh
                                STA_UserData.lh{trac}(selc)=plot(STA_UserData.trigave{trac}(selc),(1.05-(trac-1)/lb_num_strings),...
                                    'Visible',p_para.trigave_vis,'Marker',p_para.trigave_symb,'MarkerFaceColor',p_para.trigave_col,...
                                    'Color',dcol,'LineStyle','none','LineWidth',p_para.trigave_lw);
                            end
                        end
                    end
                    STA_UserData.trigave{lb_pos+1}=[];
                    lb_strings{lb_pos+1}='';
                end
                set(STA_listbox,'String',lb_strings)
                set(STA_edit,'String',regexprep(lb_strings{lb_pos},'\s+',' '))
            end

            if ctrlIsPressed
                if isfield(STA_UserData,'marked')
                    STA_UserData.marked=unique([STA_UserData.marked ax_x]);
                else
                    STA_UserData.marked=ax_x;
                end
                [dummy,this,dummy2]=intersect(STA_UserData.trigave{lb_pos},STA_UserData.marked);
                STA_UserData.marked_indy=this;
                set(STA_UserData.lh{lb_pos}(STA_UserData.marked_indy),'Color',p_para.trigave_marked_col);   % #############
                STA_UserData.flag=1;
            else
                set(STA_UserData.lh{lb_pos},'Color',p_para.trigave_active_col);
                STA_UserData.marked=[];
                STA_UserData.marked_indy=[];
                STA_UserData.flag=0;
            end
        end

        shftIsPressed=ismember('shift',modifiers);
        if shftIsPressed
            set(STA_UserData.fh,'WindowButtonUpFcn',[])
            yval=1.05-(lb_pos-1)/lb_num_strings;
            ax_pos=get(STA_UserData.ah,'CurrentPoint');
            first_corner_x=ax_pos(1,1);
            first_corner_y=ax_pos(1,2);
            window=rectangle('Position',[first_corner_x, first_corner_y, 0.01, 0.01]);
            dummy_marked=STA_UserData.marked_indy;
            while shftIsPressed
                ax_pos=get(STA_UserData.ah,'CurrentPoint');
                second_corner_x=ax_pos(1,1);
                second_corner_y=ax_pos(1,2);
                if second_corner_x ~= first_corner_x && second_corner_y ~= first_corner_y
                    set(window,'Position',[min(first_corner_x, second_corner_x), min(first_corner_y, second_corner_y), abs(second_corner_x-first_corner_x), abs(second_corner_y-first_corner_y)])
                    drawnow
                    top_mark=max([first_corner_y second_corner_y]);
                    bottom_mark=min([first_corner_y second_corner_y]);
                    if top_mark>=yval && bottom_mark<=yval
                        left_mark=min(first_corner_x, second_corner_x);
                        right_mark=max(first_corner_x, second_corner_x);
                        STA_UserData.marked_indy=unique([dummy_marked find(STA_UserData.trigave{lb_pos}>=left_mark & STA_UserData.trigave{lb_pos}<=right_mark)]);
                    else
                        STA_UserData.marked_indy=dummy_marked;
                    end
                    STA_UserData.flag=(~isempty(STA_UserData.marked_indy));
                    set(STA_UserData.lh{lb_pos},'Color',p_para.trigave_active_col);
                    set(STA_UserData.lh{lb_pos}(STA_UserData.marked_indy),'Color',p_para.trigave_marked_col);
                end
                pause(0.001);
                modifiers=get(STA_UserData.fh,'CurrentModifier');
                shftIsPressed=ismember('shift',modifiers);
            end
            delete(window)
            set(STA_UserData.fh,'UserData',STA_UserData);
        end
        
        set(STA_UserData.fh,'Userdata',STA_UserData)
        set(STA_UserData.um,'CallBack',{@STA_delete_trigave,STA_UserData})
        set(STA_UserData.fh,'WindowButtonMotionFcn',{@STA_get_coordinates,STA_UserData},'KeyPressFcn',{@STA_keyboard,STA_UserData})
        set([STA_UserData.lh{:}],'ButtonDownFcn',[])
        set(STA_UserData.lh{lb_pos},'ButtonDownFcn',{@STA_start_move_trigave,STA_UserData},'UIContextMenu',STA_UserData.cm)
        set(STA_UserData.ah,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        for trac=1:d_para.num_trains
            set(STA_UserData.spike_lh{trac},'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
        end
        set(STA_UserData.image_mh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thin_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thick_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thin_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thick_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.sgs_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.fh,'Userdata',STA_UserData)
        set(STA_listbox,'String',lb_strings)
        set(STA_edit,'String',regexprep(lb_strings{lb_pos},'\s+',' '))
    end


    function STA_delete_trigave(varargin)
        STA_UserData=varargin{3};
        STA_UserData=get(STA_UserData.fh,'UserData');

        lb_strings=get(STA_listbox,'String');
        if (STA_UserData.flag)
            lb_pos=get(STA_listbox,'Value');
            STA_UserData.trigave{lb_pos}=setdiff(STA_UserData.trigave{lb_pos},STA_UserData.trigave{lb_pos}(STA_UserData.marked_indy));
            STA_UserData.marked_indy=[];
            STA_UserData.flag=0;
        else
            lb_pos=get(STA_listbox,'Value');
            dummy=find(STA_UserData.lh{lb_pos} == gco);
            STA_UserData.trigave{lb_pos}=setdiff(STA_UserData.trigave{lb_pos},get(gco,'XData'));
        end
        num_lh=length(STA_UserData.trigave{lb_pos});
        if num_lh>1
            lb_strings{lb_pos}=['[',num2str(STA_UserData.trigave{lb_pos}),']'];
            lb_strings{lb_pos}=regexprep(lb_strings{lb_pos},'\s+',' ');
        else
            lb_strings{lb_pos}=['[',num2str(STA_UserData.trigave{lb_pos}),']'];
        end
        if ~isempty(lb_strings{length(lb_strings)})
            STA_UserData.trigave{length(lb_strings)+1}=[];
            lb_strings{length(lb_strings)+1}='';
        end
        if isempty(STA_UserData.trigave{lb_pos})
            STA_UserData.trigave=STA_UserData.trigave(setdiff(1:length(lb_strings),lb_pos));
            lb_strings=lb_strings(setdiff(1:length(lb_strings),lb_pos));
        end
        lb_num_strings=length(lb_strings)-1;
        for rc=1:length(STA_UserData.lh)
            for cc=1:length(STA_UserData.lh{rc})
                if ishandle(STA_UserData.lh{rc}(cc))
                    delete(STA_UserData.lh{rc}(cc))
                end
            end
        end
        STA_UserData.lh=cell(1,lb_num_strings);
        for trac=1:lb_num_strings
            num_lh=length(STA_UserData.trigave{trac});
            if trac==lb_pos
                dcol=p_para.trigave_active_col;
            else
                dcol=p_para.trigave_col;
            end
            for selc=1:num_lh
                STA_UserData.lh{trac}(selc)=plot(STA_UserData.trigave{trac}(selc),(1.05-(trac-1)/lb_num_strings),...
                    'Visible',p_para.trigave_vis,'Marker',p_para.trigave_symb,'MarkerFaceColor',p_para.trigave_col,...
                    'Color',dcol,'LineStyle','none','LineWidth',p_para.trigave_lw);
            end
        end
        set(STA_listbox,'Value',lb_pos);
        set(STA_listbox,'String',lb_strings)
        set(STA_edit,'String',regexprep(lb_strings{lb_pos},'\s+',' '))

        set(STA_UserData.fh,'Userdata',STA_UserData)
        set(STA_UserData.um,'CallBack',{@STA_delete_trigave,STA_UserData})
        set(STA_UserData.fh,'WindowButtonMotionFcn',{@STA_get_coordinates,STA_UserData},'KeyPressFcn',{@STA_keyboard,STA_UserData})
        set([STA_UserData.lh{:}],'ButtonDownFcn',[])
        if ~isempty(STA_UserData.lh) && lb_pos<=length(STA_UserData.lh)
            set(STA_UserData.lh{lb_pos},'ButtonDownFcn',{@STA_start_move_trigave,STA_UserData},'UIContextMenu',STA_UserData.cm)
        end
        set(STA_UserData.ah,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        for trac=1:d_para.num_trains
            set(STA_UserData.spike_lh{trac},'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
        end
        set(STA_UserData.image_mh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thin_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thick_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thin_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thick_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.sgs_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.fh,'Userdata',STA_UserData)
    end


    function STA_start_move_trigave(varargin)
        STA_UserData=varargin{3};
        STA_UserData=get(STA_UserData.fh,'UserData');
        
        seltype=get(STA_UserData.fh,'SelectionType'); % Right-or-left click?
        lb_pos=get(STA_listbox,'Value');
        ax_pos=get(STA_UserData.ah,'CurrentPoint');
        if strcmp(seltype,'alt')
            modifiers=get(STA_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                %ax_x=round(ax_pos(1,1)/STA_UserData.dts)*STA_UserData.dts;
                ax_x=get(gco,'XData');
                
                if isfield(STA_UserData,'marked')
                    STA_UserData.marked=unique([STA_UserData.marked ax_x]);
                else
                    STA_UserData.marked=ax_x;
                end
                [dummy,this,dummy2]=intersect(STA_UserData.trigave{lb_pos},STA_UserData.marked);
                STA_UserData.marked_indy=this;
                if ~STA_UserData.flag
                    STA_UserData.flag=1;
                end
                set(gco,'Color',p_para.trigave_marked_col);

                set(STA_UserData.fh,'Userdata',STA_UserData)
                set(STA_UserData.um,'CallBack',{@STA_delete_trigave,STA_UserData})
                set(STA_UserData.fh,'WindowButtonMotionFcn',{@STA_get_coordinates,STA_UserData},'KeyPressFcn',{@STA_keyboard,STA_UserData})
                set([STA_UserData.lh{:}],'ButtonDownFcn',[])
                set(STA_UserData.lh{lb_pos},'ButtonDownFcn',{@STA_start_move_trigave,STA_UserData},'UIContextMenu',STA_UserData.cm)
                set(STA_UserData.ah,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                for trac=1:d_para.num_trains
                    set(STA_UserData.spike_lh{trac},'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
                end
                set(STA_UserData.image_mh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.thin_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.thick_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.thin_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.thick_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.sgs_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.fh,'Userdata',STA_UserData)
            end
        else
            STA_UserData.initial_XPos=round(ax_pos(1,1)/STA_UserData.dts)*STA_UserData.dts;
            if ~STA_UserData.flag
                lb_strings=get(STA_listbox,'String');
                lb_num_strings=length(lb_strings)-1;
                lb_pos=get(STA_listbox,'Value');
                for trac=1:lb_num_strings
                    num_lh=length(STA_UserData.trigave{trac});
                    if trac==lb_pos
                        dcol=p_para.trigave_active_col;
                    else
                        dcol=p_para.trigave_col;
                    end
                    for selc=1:num_lh
                        set(STA_UserData.lh{trac}(selc),'Color',dcol);
                    end
                end
                STA_UserData.marked_indy=find(STA_UserData.lh{lb_pos}(:) == gco);
                set(STA_listbox,'Value',lb_pos);
                STA_UserData.initial_XData=get(gco,'XData');
            else
                STA_UserData.initial_XData=STA_UserData.trigave{lb_pos}(STA_UserData.marked_indy);
            end
            set(STA_UserData.fh,'WindowButtonMotionFcn',{@STA_move_trigave,STA_UserData})
            set(STA_UserData.ah,'ButtonDownFcn','')
            for trac=1:d_para.num_trains
                set(STA_UserData.spike_lh{trac},'ButtonDownFcn','')
            end
            set(STA_UserData.image_mh,'ButtonDownFcn','')
            set(STA_UserData.thin_mar_lh,'ButtonDownFcn','')
            set(STA_UserData.thick_mar_lh,'ButtonDownFcn','')
            set(STA_UserData.thin_sep_lh,'ButtonDownFcn','')
            set(STA_UserData.thick_sep_lh,'ButtonDownFcn','')
            set(STA_UserData.sgs_lh,'ButtonDownFcn','')
            set(STA_UserData.fh,'Userdata',STA_UserData)
        end
    end


    function STA_move_trigave(varargin)
        STA_UserData=varargin{3};
        STA_UserData=get(STA_UserData.fh,'UserData');

        ax_pos=get(STA_UserData.ah,'CurrentPoint');
        ax_x_ok=STA_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=STA_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;
        ax_x=round(ax_pos(1,1)/STA_UserData.dts)*STA_UserData.dts;
        lb_pos=get(STA_listbox,'Value');
        for idx=1:length(STA_UserData.marked_indy)
            if ((STA_UserData.initial_XData(idx)+ax_x-STA_UserData.initial_XPos)>STA_UserData.tmin && ...
                    (STA_UserData.initial_XData(idx)+ax_x-STA_UserData.initial_XPos)<STA_UserData.tmax)
                set(STA_UserData.lh{lb_pos}(STA_UserData.marked_indy(idx)),'Color',p_para.trigave_marked_col,...
                    'XData',STA_UserData.initial_XData(idx)+ax_x-STA_UserData.initial_XPos)
            else
                set(STA_UserData.lh{lb_pos}(STA_UserData.marked_indy(idx)),'Color','w')
            end
        end
        drawnow;

        if ax_x_ok && ax_y_ok
            ax_x=round(ax_pos(1,1)/STA_UserData.dts)*STA_UserData.dts;
            set(STA_UserData.tx,'str',['Time: ', num2str(ax_x)]);
        else
            set(STA_UserData.tx,'str','Out of range');
        end
        set(STA_UserData.fh,'WindowButtonUpFcn',{@STA_stop_move_trigave,STA_UserData})
        set(STA_UserData.fh,'Userdata',STA_UserData)
    end


    function STA_stop_move_trigave(varargin)
        STA_UserData=varargin{3};
        STA_UserData=get(STA_UserData.fh,'UserData');

        lb_strings=get(STA_listbox,'String');
        lb_pos=get(STA_listbox,'Value');
        ax_pos=get(STA_UserData.ah,'CurrentPoint');
        ax_x=round(ax_pos(1,1)/STA_UserData.dts)*STA_UserData.dts;
        
        for idx=1:length(STA_UserData.marked_indy)
            if ((STA_UserData.initial_XData(idx)+ax_x -STA_UserData.initial_XPos)>STA_UserData.tmin && ...
                    (STA_UserData.initial_XData(idx)+ax_x -STA_UserData.initial_XPos)<STA_UserData.tmax )
                STA_UserData.trigave{lb_pos}(STA_UserData.marked_indy(idx))=...
                    STA_UserData.initial_XData(idx)+ax_x-STA_UserData.initial_XPos;
            else
                STA_UserData.trigave{lb_pos}=STA_UserData.trigave{lb_pos}(setdiff(1:length(STA_UserData.trigave{lb_pos}),STA_UserData.marked_indy(idx)));
                STA_UserData.marked_indy(idx+1:end)=STA_UserData.marked_indy(idx+1:end)-1;
            end
        end
        STA_UserData.trigave{lb_pos}=unique(STA_UserData.trigave{lb_pos});
        STA_UserData.marked_indy=[];
        STA_UserData.flag=0;
        for cc=1:length(STA_UserData.lh{lb_pos})
            if ishandle(STA_UserData.lh{lb_pos}(cc))
                delete(STA_UserData.lh{lb_pos}(cc))     % ########## early key release !!!
            end
        end
        STA_UserData.lh{lb_pos}=[];
        num_lh=length(STA_UserData.trigave{lb_pos});
        lb_num_strings=length(lb_strings)-1;
        for selc=1:num_lh
            STA_UserData.lh{lb_pos}(selc)=plot(STA_UserData.trigave{lb_pos}(selc),(1.05-(lb_pos-1)/lb_num_strings),...
                'Visible',p_para.trigave_vis,'Marker',p_para.trigave_symb,'MarkerFaceColor',p_para.trigave_col,...
                'Color',p_para.trigave_active_col,'LineStyle','none','LineWidth',p_para.trigave_lw);
        end
        if num_lh>1
            lb_strings{lb_pos}=['[',num2str(STA_UserData.trigave{lb_pos}),']'];
            lb_strings{lb_pos}=regexprep(lb_strings{lb_pos},'\s+',' ');
        else
            lb_strings{lb_pos}=['[',num2str(STA_UserData.trigave{lb_pos}),']'];
        end
        set(STA_listbox,'String',lb_strings)
        set(STA_edit,'String',regexprep(lb_strings{lb_pos},'\s+',' '))
        set(STA_UserData.fh,'Pointer','arrow')
        drawnow;

        set(STA_UserData.fh,'Userdata',STA_UserData)
        set(STA_UserData.um,'CallBack',{@STA_delete_trigave,STA_UserData})
        set(STA_UserData.fh,'WindowButtonMotionFcn',{@STA_get_coordinates,STA_UserData},'KeyPressFcn',{@STA_keyboard,STA_UserData},...
            'WindowButtonUpFcn',[])
        set([STA_UserData.lh{:}],'ButtonDownFcn',[])
        set(STA_UserData.lh{lb_pos},'ButtonDownFcn',{@STA_start_move_trigave,STA_UserData},'UIContextMenu',STA_UserData.cm)
        set(STA_UserData.ah,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        for trac=1:d_para.num_trains
            set(STA_UserData.spike_lh{trac},'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        end
        set(STA_UserData.image_mh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thin_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thick_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thin_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.thick_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.sgs_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
        set(STA_UserData.fh,'Userdata',STA_UserData)
    end


    function STA_keyboard(varargin)
        STA_UserData=varargin{3};
        STA_UserData=get(STA_UserData.fh,'UserData');

        if strcmp(varargin{2}.Key,'delete')
            if (STA_UserData.flag)
                lb_pos=get(STA_listbox,'Value');
                lb_strings=get(STA_listbox,'String');
                STA_UserData.trigave{lb_pos}=setdiff(STA_UserData.trigave{lb_pos},STA_UserData.trigave{lb_pos}(STA_UserData.marked_indy));
                STA_UserData.marked_indy=[];
                STA_UserData.flag=0;
                num_lh=length(STA_UserData.trigave{lb_pos});
                if num_lh>1
                    lb_strings{lb_pos}=['[',num2str(STA_UserData.trigave{lb_pos}),']'];
                    lb_strings{lb_pos}=regexprep(lb_strings{lb_pos},'\s+',' ');
                else
                    lb_strings{lb_pos}=['[',num2str(STA_UserData.trigave{lb_pos}),']'];
                end
                if ~isempty(lb_strings{length(lb_strings)})
                    STA_UserData.trigave{length(lb_strings)+1}=[];
                    lb_strings{length(lb_strings)+1}='';
                end
                if isempty(STA_UserData.trigave{lb_pos})
                    lb_strings=lb_strings(setdiff(1:length(lb_strings),lb_pos));
                    STA_UserData.trigave=STA_UserData.trigave(setdiff(1:length(lb_strings),lb_pos));
                end
                lb_num_strings=length(lb_strings)-1;
                for rc=1:length(STA_UserData.lh)
                    for cc=1:length(STA_UserData.lh{rc})
                        if ishandle(STA_UserData.lh{rc}(cc))
                            delete(STA_UserData.lh{rc}(cc))
                        end
                    end
                end
                STA_UserData.lh=cell(1,lb_num_strings);
                for trac=1:lb_num_strings
                    num_lh=length(STA_UserData.trigave{trac});
                    if trac==lb_pos
                        dcol=p_para.trigave_active_col;
                    else
                        dcol=p_para.trigave_col;
                    end
                    for selc=1:num_lh
                        STA_UserData.lh{trac}(selc)=plot(STA_UserData.trigave{trac}(selc),(1.05-(trac-1)/lb_num_strings),...
                            'Visible',p_para.trigave_vis,'Marker',p_para.trigave_symb,'MarkerFaceColor',p_para.trigave_col,...
                            'Color',dcol,'LineStyle','none','LineWidth',p_para.trigave_lw);
                    end
                end
                set(STA_listbox,'Value',lb_pos);
                set(STA_listbox,'String',lb_strings)
                set(STA_edit,'String',regexprep(lb_strings{lb_pos},'\s+',' '))
                
                set(STA_UserData.fh,'Userdata',STA_UserData)
                set(STA_UserData.um,'CallBack',{@STA_delete_trigave,STA_UserData})
                set(STA_UserData.fh,'WindowButtonMotionFcn',{@STA_get_coordinates,STA_UserData},'KeyPressFcn',{@STA_keyboard,STA_UserData})
                set([STA_UserData.lh{:}],'ButtonDownFcn',[])
                if ~isempty(STA_UserData.lh) && lb_pos<=length(STA_UserData.lh)
                    set(STA_UserData.lh{lb_pos},'ButtonDownFcn',{@STA_start_move_trigave,STA_UserData},'UIContextMenu',STA_UserData.cm)
                end
                set(STA_UserData.ah,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                for trac=1:d_para.num_trains
                    set(STA_UserData.spike_lh{trac},'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
                end
                set(STA_UserData.image_mh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.thin_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.thick_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.thin_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.thick_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.sgs_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.fh,'Userdata',STA_UserData)
            end
        elseif strcmp(varargin{2}.Key,'a')
            modifiers=get(STA_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                lb_pos=get(STA_listbox,'Value');
                num_lh=length(STA_UserData.trigave{lb_pos});
                STA_UserData.marked=STA_UserData.trigave{lb_pos};
                STA_UserData.marked_indy=1:num_lh;
                for selc=1:num_lh
                    set(STA_UserData.lh{lb_pos}(selc),'Color',p_para.trigave_marked_col);
                end
                STA_UserData.flag=1;

                set(STA_UserData.fh,'Userdata',STA_UserData)
                set(STA_UserData.um,'CallBack',{@STA_delete_trigave,STA_UserData})
                set(STA_UserData.fh,'WindowButtonMotionFcn',{@STA_get_coordinates,STA_UserData},'KeyPressFcn',{@STA_keyboard,STA_UserData})
                set([STA_UserData.lh{:}],'ButtonDownFcn',[])
                set(STA_UserData.lh{lb_pos},'ButtonDownFcn',{@STA_start_move_trigave,STA_UserData},'UIContextMenu',STA_UserData.cm)
                set(STA_UserData.ah,'ButtonDownFcn',{@STA_start_pick,STA_UserData})
                for trac=1:d_para.num_trains
                    set(STA_UserData.spike_lh{trac},'ButtonDownFcn',{@STA_pick_trigave,STA_UserData},'UIContextMenu',[])
                end
                set(STA_UserData.image_mh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.thin_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.thick_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.thin_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.thick_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.sgs_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
                set(STA_UserData.fh,'Userdata',STA_UserData)
            end
        elseif strcmp(varargin{2}.Key,'c')
            modifiers=get(STA_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                lb_pos=get(STA_listbox,'Value');
                lb_strings=get(STA_listbox,'String');
                lb_num_strings=length(lb_strings)-1;
                num_lh=length(STA_UserData.trigave{lb_pos});
                for idx=1:length(STA_UserData.marked_indy)
                    STA_UserData.lh{lb_pos}(num_lh+idx)=plot(STA_UserData.trigave{lb_pos}(STA_UserData.marked_indy(idx)),(1.05-(lb_pos-1)/lb_num_strings),...
                        'Visible',p_para.trigave_vis,'Marker',p_para.trigave_symb,'MarkerFaceColor',p_para.trigave_col,...
                        'Color',p_para.trigave_marked_col,'LineStyle','none','LineWidth',p_para.trigave_lw);
                end
                STA_UserData.flag=1;
                STA_UserData.marked=STA_UserData.trigave{lb_pos}(STA_UserData.marked_indy);
                STA_UserData.marked_indy=num_lh+(1:length(STA_UserData.marked_indy));
                STA_UserData.trigave{lb_pos}(STA_UserData.marked_indy)=STA_UserData.marked;
                ax_pos=get(STA_UserData.ah,'CurrentPoint');
                STA_UserData.initial_XPos=round(ax_pos(1,1)/STA_UserData.dts)*STA_UserData.dts;
                STA_UserData.initial_XData=STA_UserData.marked;

                set(STA_UserData.fh,'Userdata',STA_UserData)
                set(STA_UserData.ah,'ButtonDownFcn','')
                for trac=1:d_para.num_trains
                    set(STA_UserData.spike_lh{trac},'ButtonDownFcn','')
                end
                set(STA_UserData.image_mh,'ButtonDownFcn','')
                set(STA_UserData.thin_mar_lh,'ButtonDownFcn','')
                set(STA_UserData.thick_mar_lh,'ButtonDownFcn','')
                set(STA_UserData.thin_sep_lh,'ButtonDownFcn','')
                set(STA_UserData.thick_sep_lh,'ButtonDownFcn','')
                set(STA_UserData.sgs_lh,'ButtonDownFcn','')
                set(STA_UserData.fh,'WindowButtonMotionFcn',{@STA_move_trigave,STA_UserData})
                set(STA_UserData.fh,'Userdata',STA_UserData)
            end
        end
    end


    function STA_Load_trigave(varargin)
        if isfield(d_para,'matfile') && ischar(d_para.matfile)
            [d_para.filename,d_para.path]=uigetfile('*.mat','Pick a .mat-file',d_para.matfile);
        else
            [d_para.filename,d_para.path]=uigetfile('*.mat','Pick a .mat-file');
        end
        if isequal(d_para.filename,0) || isequal(d_para.path,0)
            return
        end
        d_para.matfile=[d_para.path d_para.filename];
        if d_para.matfile~=0
            STA_UserData=get(f_para.num_fig,'UserData');
            data.matfile=d_para.matfile;
            data.default_variable='';
            data.content='triggered averages';
            SPIKY('SPIKY_select_variable',gcbo,data,handles)
            variable=getappdata(handles.figure1,'variable');
            if ~isempty(variable) && ~strcmp(variable,'A9ZB1YC8X')
                data=getappdata(handles.figure1,'data');
                STA_UserData.trigave=squeeze(eval(['data.',variable]));
            end
            if ~isfield(STA_UserData,'trigave') || isempty(STA_UserData.trigave) || ~((iscell(STA_UserData.trigave) && length(STA_UserData.trigave)>1 && isnumeric(STA_UserData.trigave{1})) || ...
                    (isnumeric(STA_UserData.trigave) && ndims(STA_UserData.trigave)==2 && size(STA_UserData.trigave,1)>1))
                if ~strcmp(variable,'A9ZB1YC8X')
                    set(0,'DefaultUIControlFontSize',16);
                    mbh=msgbox(sprintf('The format of the variable is not correct. Please try again!'),'Warning','warn','modal');
                    htxt=findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                    uiwait(mbh);
                end
                ret=1;
                return
            end
            lb_strings=[];
            set(STA_listbox,'String',lb_strings,'Value',1)
            figure(f_para.num_fig);
            if isfield(STA_UserData,'lh')
                for rc=1:length(STA_UserData.lh)
                    for cc=1:length(STA_UserData.lh{rc})
                        if ishandle(STA_UserData.lh{rc}(cc))
                            delete(STA_UserData.lh{rc}(cc))
                        end
                    end
                end
                STA_UserData.lh=[];
            end

            lb_num_strings=length(STA_UserData.trigave);
            lb_pos=get(STA_listbox,'Value');
            for trac=1:lb_num_strings
                num_lh=length(STA_UserData.trigave{trac});
                lb_strings{trac}=regexprep(num2str(STA_UserData.trigave{trac}),'\s+',' ');
                if num_lh>1
                    lb_strings{trac}=['[',num2str(STA_UserData.trigave{trac}),']'];
                    lb_strings{trac}=regexprep(lb_strings{trac},'\s+',' ');
                end
            end
            STA_UserData.trigave{lb_num_strings+1}=[];
            lb_strings{lb_num_strings+1}='';
            STA_UserData.lh=cell(1,lb_num_strings);

            for trac=1:lb_num_strings
                if trac==lb_pos
                    dcol=p_para.selave_active_col;
                else
                    dcol=p_para.selave_col;
                end
                for selc=1:length(STA_UserData.trigave{trac})
                    STA_UserData.lh{trac}(selc)=plot(STA_UserData.trigave{trac}(selc),(1.05-(trac-1)/lb_num_strings),...
                        'Visible',p_para.trigave_vis,'Marker',p_para.trigave_symb,'MarkerFaceColor',p_para.trigave_col,...
                        'Color',dcol,'LineStyle','none','LineWidth',p_para.trigave_lw);
                end
            end
            set(STA_listbox,'String',lb_strings)
            set(STA_edit,'String',lb_strings{1})
            set(STA_listbox,'Value',1)
            set(STA_UserData.fh,'Userdata',STA_UserData)
        end
    end


    function STA_callback(varargin)
        d_para=getappdata(handles.figure1,'data_parameters');
        f_para=getappdata(handles.figure1,'figure_parameters');
        figure(f_para.num_fig);
        STA_UserData=get(gcf,'Userdata');

        %lb_pos=get(STA_listbox,'Value');
        lb_strings=get(STA_listbox,'String');
        lb_num_strings=length(lb_strings)-1;
        if gcbo==STA_Cancel_pushbutton || gcbo==SIA_fig
            delete(SIA_fig)
        elseif gcbo==STA_Reset_pushbutton
            set(STA_edit,'String',[])
            STA_UserData.trigave=[];
            STA_UserData.trigave{1}=[];
            lb_strings=[];
            lb_strings{1}='';
            set(STA_listbox,'String',lb_strings,'Value',1)
            STA_UserData.trigave=[];
            for rc=1:length(STA_UserData.lh)
                for cc=1:length(STA_UserData.lh{rc})
                    if ishandle(STA_UserData.lh{rc}(cc))
                        delete(STA_UserData.lh{rc}(cc))
                    end
                end
            end
            STA_UserData.lh=[];

            set(STA_UserData.fh,'Userdata',STA_UserData)
            set(STA_UserData.um,'CallBack',{@STA_delete_trigave,STA_UserData})
            set(STA_UserData.fh,'WindowButtonMotionFcn',{@STA_get_coordinates,STA_UserData},'KeyPressFcn',{@STA_keyboard,STA_UserData})
            set(STA_UserData.ah,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
            for trac=1:d_para.num_trains
                set(STA_UserData.spike_lh{trac},'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
            end
            set(STA_UserData.image_mh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
            set(STA_UserData.thin_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
            set(STA_UserData.thick_mar_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
            set(STA_UserData.thin_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
            set(STA_UserData.thick_sep_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
            set(STA_UserData.sgs_lh,'ButtonDownFcn',{@STA_pick_trigave,STA_UserData})
            set(STA_UserData.fh,'Userdata',STA_UserData)
        elseif gcbo==STA_OK_pushbutton
            for trac=1:lb_num_strings
                [dummy,conv_ok]=str2num(char(lb_strings{trac}));
                if conv_ok==0 && ~isempty(lb_strings{trac})
                    set(0,'DefaultUIControlFontSize',16);
                    mbh=msgbox(sprintf('The values entered are not numeric!'),'Warning','warn','modal');
                    htxt=findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                    uiwait(mbh);
                    return
                end
            end
            for trac=1:lb_num_strings
                if ~isempty(STA_UserData.trigave{trac})
                    lb_strings{trac}=['[',num2str(round(STA_UserData.trigave{trac}/d_para.dts)*d_para.dts),']'];
                else
                    lb_strings{trac}='';
                end
                lb_strings{trac}=regexprep(lb_strings{trac},'\s+',' ');
            end
            if isfield(STA_UserData,'lh')
                for rc=1:length(STA_UserData.lh)
                    for cc=1:length(STA_UserData.lh{rc})
                        if ishandle(STA_UserData.lh{rc}(cc))
                            delete(STA_UserData.lh{rc}(cc))
                        end
                    end
                end
                STA_UserData.lh=[];
            end
            dummy=[];
            for lbc=1:lb_num_strings
                dummy=[dummy lb_strings{lbc},'; '];
            end
            dummy=dummy(1:length(dummy)-2);
            if ~isempty(dummy)
                d_para.triggered_averages_str=dummy;
            else
                d_para.triggered_averages_str='';
            end
            setappdata(handles.figure1,'data_parameters',d_para)

            % ########################################################

            set(STA_OK_pushbutton,'UserData',1)
            set(handles.figure1,'Visible','on')
            d_para.instants=unique(round(STA_UserData.instants/d_para.dts)*d_para.dts);
            d_para.instants_str=num2str(d_para.instants);
            set(handles.dpara_instants_edit,'String',regexprep(d_para.instants_str,'\s+',' '))
            if ~isempty(d_para.selective_averages_str)
                dummy=regexp(d_para.selective_averages_str,'([^;]*)','tokens');
                if length(dummy)==1
                    dummy{1}{:}(1)='';
                    dummy{end}{:}(end)='';
                end
                d_para.selective_averages=cell(1,length(dummy));
                for cc=1:length(dummy)
                    d_para.selective_averages{cc}=str2num(char(dummy{cc}));
                end
            end
            set(handles.dpara_selective_averages_edit,'String',regexprep(d_para.selective_averages_str,'\s+',' '))
            if ~isempty(d_para.triggered_averages_str)
                dummy=regexp(d_para.triggered_averages_str,'([^;]*)','tokens');
                if length(dummy)==1
                    dummy{1}{:}(1)='';
                    dummy{end}{:}(end)='';
                end
                d_para.triggered_averages=cell(1,length(dummy));
                for cc=1:length(dummy)
                    d_para.triggered_averages{cc}=str2num(char(dummy{cc}));
                end
            end
            set(handles.dpara_triggered_averages_edit,'String',regexprep(d_para.triggered_averages_str,'\s+',' '))

            set(STA_UserData.fh,'Userdata',STA_UserData)
            setappdata(handles.figure1,'data_parameters',d_para)
            delete(SIA_fig)
        end
    end


    function SIA_Close_callback(varargin)
        figure(f_para.num_fig);
        thick_mar_lh=getappdata(handles.figure1,'thick_mar_lh');
        set(thick_mar_lh,'Visible','on')
        thin_mar_lh=getappdata(handles.figure1,'thin_mar_lh');
        set(thin_mar_lh,'Visible','on')
        thick_sep_lh=getappdata(handles.figure1,'thick_sep_lh');
        set(thick_sep_lh,'Visible','on')
        thin_sep_lh=getappdata(handles.figure1,'thin_sep_lh');
        set(thin_sep_lh,'Visible','on')
        sgs_lh=getappdata(handles.figure1,'sgs_lh');
        set(sgs_lh,'Visible','on')
        SIA_UserData=get(gcf,'Userdata');
        if exist('SI_UserData','var')
            if isfield(SIA_UserData,'lh')
                if iscell(SIA_UserData.lh)
                    for rc=1:length(SIA_UserData.lh)
                        for cc=1:length(SIA_UserData.lh{rc})
                            if ishandle(SIA_UserData.lh{rc}(cc))
                                delete(SIA_UserData.lh{rc}(cc))
                            end
                        end
                    end
                else
                    for cc=1:length(SIA_UserData.lh)
                        if ishandle(SIA_UserData.lh(cc))
                            delete(SIA_UserData.lh(cc))
                        end
                    end
                end
                SIA_UserData.lh=[];
            end
        end
        SIA_UserData.cm=[];
        SIA_UserData.um=[];
        set(SIA_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
        set(SIA_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SIA_UserData.spike_lh{trac},'ButtonDownFcn',[],'UIContextMenu',[])
        end
        set(SIA_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])
        set(SIA_UserData.thin_mar_lh,'ButtonDownFcn',[],'UIContextMenu',[])
        set(SIA_UserData.thick_mar_lh,'ButtonDownFcn',[],'UIContextMenu',[])
        set(SIA_UserData.thin_sep_lh,'ButtonDownFcn',[],'UIContextMenu',[])
        set(SIA_UserData.thick_sep_lh,'ButtonDownFcn',[],'UIContextMenu',[])
        set(SIA_UserData.sgs_lh,'ButtonDownFcn',[],'UIContextMenu',[])
        set(SIA_UserData.tx,'str','');
        set(SIA_UserData.fh,'Userdata',[])
        delete(SIA_fig)
        set(handles.figure1,'Visible','on')
    end

end
