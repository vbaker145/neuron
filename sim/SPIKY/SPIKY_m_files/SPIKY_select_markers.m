% This function provides an input mask (for keyboard and mouse) for selecting thick and thin time markers
% (lines denoting the times of specific events).

function SPIKY_select_markers(hObject, eventdata, handles)

set(handles.figure1,'Visible','off')

d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
p_para=getappdata(handles.figure1,'plot_parameters');

SM_fig=figure('units','normalized','menubar','none','position',[0.05 0.17 0.4 0.66],'Name','Select thick and thin markers',...
    'NumberTitle','off','Color',[0.9294 0.9176 0.851],'DeleteFcn',{@SM_Close_callback}); % ,'WindowStyle','modal'

SM1_panel=uipanel('units','normalized','position',[0.05 0.56 0.9 0.38],'Title','Thick markers','FontSize',15,...
    'FontWeight','bold','HighlightColor','k');
SM1_edit=uicontrol('style','edit','units','normalized','position',[0.08 0.8 0.84 0.06],...
    'FontSize',15,'FontUnits','normalized','BackgroundColor','w');
SM1_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.15 0.69 0.2 0.05],'string','Cancel',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SM1_callback});
SM1_Reset_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.4 0.69 0.2 0.05],'string','Reset',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SM1_callback});
SM1_Apply_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.69 0.2 0.05],'string','Apply',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SM1_callback});
SM1_Load_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.2 0.6 0.25 0.05],'string','Load from file',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SM1_Load_markers});
SM1_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.6 0.25 0.05],'string','OK',...
    'FontSize',15,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SM1_callback});
uicontrol(SM1_OK_pushbutton)

SM2_panel=uipanel('units','normalized','position',[0.05 0.06 0.9 0.38],'Title','Thin markers','FontSize',15,...
    'FontWeight','bold','HighlightColor','k','Visible','off');
SM2_edit=uicontrol('style','edit','units','normalized','position',[0.08 0.3 0.84 0.06],...
    'FontSize',15,'FontUnits','normalized','BackgroundColor','w','Visible','off');
SM2_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.15 0.19 0.2 0.05],'string','Cancel',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SM2_callback},'Visible','off');
SM2_Reset_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.4 0.19 0.2 0.05],'string','Reset',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SM2_callback},'Visible','off');
SM2_Apply_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.19 0.2 0.05],'string','Apply',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SM2_callback},'Visible','off');
SM2_Load_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.2 0.1 0.25 0.05],'string','Load from file',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SM2_Load_markers},'Visible','off');
SM2_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.1 0.25 0.05],'string','OK',...
    'FontSize',15,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SM2_callback},...
    'Visible','off');
uicontrol(SM2_OK_pushbutton)


figure(f_para.num_fig);
if isfield(d_para,'thick_markers')
    if ~isempty(d_para.thick_markers)
        thick_mar_lh=getappdata(handles.figure1,'thick_mar_lh');
        for lhc=1:length(thick_mar_lh)
            set(thick_mar_lh,'Visible','off')
        end
    end
    set(SM1_edit,'String',regexprep(num2str(d_para.thick_markers),'\s+',' '))
    SM1_UserData.lh=zeros(1,length(d_para.thick_markers));
    for lhc=1:length(d_para.thick_markers)
        SM1_UserData.lh(lhc)=line(d_para.thick_markers(lhc)*ones(1,2),[0.05 1.05],...
            'Color',p_para.thick_mar_col,'LineStyle',p_para.thick_mar_ls,'LineWidth',p_para.thick_mar_lw);
    end
    SM1_UserData.thick_markers=d_para.thick_markers;
else
    SM1_UserData.thick_markers=[];
end
if isfield(d_para,'thin_markers') && ~isempty(d_para.thin_markers)
    thin_mar_lh=getappdata(handles.figure1,'thin_mar_lh');
    for lhc=1:length(thin_mar_lh)
        set(thin_mar_lh,'Visible','off')
    end
end
SM1_UserData.fh=gcf;
SM1_UserData.ah=gca;
set(SM1_UserData.fh,'Units','Normalized')
SM1_UserData.tmin=d_para.tmin;
SM1_UserData.tmax=d_para.tmax;
SM1_UserData.dts=d_para.dts;
SM1_UserData.flag=0;
SM1_UserData.marked_indy=[];
SM1_UserData.tx=uicontrol('style','tex','String','','unit','normalized','backg',get(SM1_UserData.fh,'Color'),...
    'position',[0.4 0.907 0.4 0.04],'FontSize',18,'FontWeight','bold','HorizontalAlignment','left');
SM1_UserData.spike_lh=getappdata(handles.figure1,'spike_lh');
SM1_UserData.image_mh=getappdata(handles.figure1,'image_mh');

set(SM1_UserData.fh,'Userdata',SM1_UserData)
SM1_UserData.cm=uicontextmenu;
SM1_UserData.um=uimenu(SM1_UserData.cm,'label','Delete thick marker(s)','CallBack',{@SM1_delete_thick_markers,SM1_UserData});
set(SM1_UserData.fh,'WindowButtonMotionFcn',{@SM1_get_coordinates,SM1_UserData},'KeyPressFcn',{@SM1_keyboard,SM1_UserData});
set(SM1_UserData.lh,'ButtonDownFcn',{@SM1_start_move_thick_markers,SM1_UserData},'UIContextMenu',SM1_UserData.cm)
set(SM1_UserData.ah,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
for trac=1:d_para.num_trains
    set(SM1_UserData.spike_lh{trac},'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
end
set(SM1_UserData.image_mh,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
set(SM1_UserData.fh,'Userdata',SM1_UserData)

    function SM1_get_coordinates(varargin)
        SM1_UserData=varargin{3};
        SM1_UserData=get(SM1_UserData.fh,'UserData');

        ax_pos=get(SM1_UserData.ah,'CurrentPoint');
        ax_x_ok=SM1_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SM1_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        if ax_x_ok && ax_y_ok
            ax_x=round(ax_pos(1,1)/SM1_UserData.dts)*SM1_UserData.dts;
            set(SM1_UserData.tx,'str',['Time: ', num2str(ax_x)]);
        else
            set(SM1_UserData.tx,'str','Out of range');
        end
    end


    function SM1_pick_thick_markers(varargin)                                   % SM1_marked_indy changes
        SM1_UserData=varargin{3};
        SM1_UserData=get(SM1_UserData.fh,'UserData');

        ax_pos=get(SM1_UserData.ah,'CurrentPoint');
        ax_x=round(ax_pos(1,1)/SM1_UserData.dts)*SM1_UserData.dts;
        ax_x_ok=SM1_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SM1_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        modifiers=get(SM1_UserData.fh,'CurrentModifier');
        if ax_x_ok && ax_y_ok
            seltype=get(SM1_UserData.fh,'SelectionType');            % Right-or-left click?
            ctrlIsPressed=ismember('control',modifiers);
            if strcmp(seltype,'normal') || ctrlIsPressed                      % right or middle
                if ~isempty(SM1_UserData.thick_markers)
                    num_lh=length(SM1_UserData.thick_markers);
                    for lhc=1:num_lh
                        if ishandle(SM1_UserData.lh(lhc))
                            delete(SM1_UserData.lh(lhc))
                        end
                    end
                    SM1_UserData.thick_markers=unique([SM1_UserData.thick_markers ax_x]);
                else
                    SM1_UserData.thick_markers=ax_x;
                end
                num_lh=length(SM1_UserData.thick_markers);
                SM1_UserData.lh=zeros(1,num_lh);
                for selc=1:num_lh
                    if ismember(selc,SM1_UserData.marked_indy)
                        SM1_UserData.lh(selc)=line(SM1_UserData.thick_markers(selc)*ones(1,2),[0.05 1.05],...
                            'Visible',p_para.thick_mar_vis,'Color',p_para.thick_mar_marked_col,'LineStyle',p_para.thick_mar_ls,'LineWidth',p_para.thick_mar_lw);
                    else
                        SM1_UserData.lh(selc)=line(SM1_UserData.thick_markers(selc)*ones(1,2),[0.05 1.05],...
                            'Visible',p_para.thick_mar_vis,'Color',p_para.thick_mar_col,'LineStyle',p_para.thick_mar_ls,'LineWidth',p_para.thick_mar_lw);
                    end
                end

                thick_mar_str=num2str(SM1_UserData.thick_markers);
                if length(SM1_UserData.thick_markers)>1
                    thick_mar_str=regexprep(thick_mar_str,'\s+',' ');
                end
                set(SM1_edit,'String',thick_mar_str)
            end

            shftIsPressed=ismember('shift',modifiers);
            if ctrlIsPressed
                if isfield(SM1_UserData,'marked')
                    SM1_UserData.marked=unique([SM1_UserData.marked ax_x]);
                else
                    SM1_UserData.marked=ax_x;
                end
                [dummy,this,dummy2]=intersect(SM1_UserData.thick_markers,SM1_UserData.marked);
                SM1_UserData.marked_indy=this;
                set(SM1_UserData.lh,'Color',p_para.thick_mar_col)
                set(SM1_UserData.lh(SM1_UserData.marked_indy),'Color',p_para.thick_mar_marked_col)
                SM1_UserData.flag=1;
            elseif ~shftIsPressed
                set(SM1_UserData.lh,'Color',p_para.thick_mar_col)
                SM1_UserData.marked=[];
                SM1_UserData.flag=0;
                SM1_UserData.marked_indy=[];
            end
        end

        dummy_marked=SM1_UserData.marked_indy;
        shftIsPressed=ismember('shift',modifiers);
        if shftIsPressed
            set(SM1_UserData.fh,'WindowButtonUpFcn',[])
            ax_pos=get(SM1_UserData.ah,'CurrentPoint');
            first_corner_x=ax_pos(1,1);
            first_corner_y=ax_pos(1,2);
            window=rectangle('Position',[first_corner_x, first_corner_y, 0.01, 0.01]);
            while shftIsPressed
                ax_pos=get(SM1_UserData.ah,'CurrentPoint');
                second_corner_x=ax_pos(1,1);
                second_corner_y=ax_pos(1,2);
                if second_corner_x ~= first_corner_x && second_corner_y ~= first_corner_y
                    set(window,'Position',[min(first_corner_x, second_corner_x), min(first_corner_y, second_corner_y), abs(second_corner_x-first_corner_x), abs(second_corner_y-first_corner_y)])
                    drawnow
                    left_mark=min(first_corner_x, second_corner_x);
                    right_mark=max(first_corner_x, second_corner_x);
                    SM1_UserData.marked_indy=unique([dummy_marked find(SM1_UserData.thick_markers>=left_mark & SM1_UserData.thick_markers<=right_mark)]);
                    SM1_UserData.flag=(~isempty(SM1_UserData.marked_indy));
                    set(SM1_UserData.lh,'Color',p_para.thick_mar_col)
                    set(SM1_UserData.lh(SM1_UserData.marked_indy),'Color',p_para.thick_mar_marked_col)
                end
                pause(0.001);
                modifiers=get(SM1_UserData.fh,'CurrentModifier');
                shftIsPressed=ismember('shift',modifiers);
            end
            delete(window)
            SM1_UserData.marked=SM1_UserData.thick_markers(SM1_UserData.marked_indy);
        end

        set(SM1_UserData.fh,'Userdata',SM1_UserData)
        set(SM1_UserData.um,'CallBack',{@SM1_delete_thick_markers,SM1_UserData})
        set(SM1_UserData.fh,'WindowButtonMotionFcn',{@SM1_get_coordinates,SM1_UserData},'KeyPressFcn',{@SM1_keyboard,SM1_UserData})
        set(SM1_UserData.lh,'ButtonDownFcn',{@SM1_start_move_thick_markers,SM1_UserData},'UIContextMenu',SM1_UserData.cm)
        set(SM1_UserData.ah,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SM1_UserData.spike_lh{trac},'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
        end
        set(SM1_UserData.image_mh,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
        set(SM1_UserData.fh,'Userdata',SM1_UserData)
    end


    function SM1_delete_thick_markers(varargin)
        SM1_UserData=varargin{3};
        SM1_UserData=get(SM1_UserData.fh,'UserData');

        if (SM1_UserData.flag)
            SM1_UserData.thick_markers=setdiff(SM1_UserData.thick_markers,SM1_UserData.thick_markers(SM1_UserData.marked_indy));
            SM1_UserData.marked_indy=[];
            SM1_UserData.flag=0;
        else
            SM1_UserData.thick_markers=setdiff(SM1_UserData.thick_markers,get(gco,'XData'));
        end
        num_lh=length(SM1_UserData.thick_markers);
        thick_mar_str=num2str(SM1_UserData.thick_markers);
        if num_lh>1
            thick_mar_str=regexprep(thick_mar_str,'\s+',' ');
        end
        for lhc=1:length(SM1_UserData.lh)
            if ishandle(SM1_UserData.lh(lhc))
                delete(SM1_UserData.lh(lhc))
            end
        end
        SM1_UserData.lh=zeros(1,num_lh);
        for selc=1:num_lh
            SM1_UserData.lh(selc)=line(SM1_UserData.thick_markers(selc)*ones(1,2),[0.05 1.05],...
                'Visible',p_para.thick_mar_vis,'Color',p_para.thick_mar_col,'LineStyle',p_para.thick_mar_ls,'LineWidth',p_para.thick_mar_lw);
        end
        set(SM1_edit,'String',thick_mar_str)

        set(SM1_UserData.fh,'Userdata',SM1_UserData)
        set(SM1_UserData.um,'CallBack',{@SM1_delete_thick_markers,SM1_UserData})
        set(SM1_UserData.fh,'WindowButtonMotionFcn',{@SM1_get_coordinates,SM1_UserData},'KeyPressFcn',{@SM1_keyboard,SM1_UserData})
        set(SM1_UserData.lh,'ButtonDownFcn',{@SM1_start_move_thick_markers,SM1_UserData},'UIContextMenu',SM1_UserData.cm)
        set(SM1_UserData.ah,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SM1_UserData.spike_lh{trac},'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
        end
        set(SM1_UserData.image_mh,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
        set(SM1_UserData.fh,'Userdata',SM1_UserData)
    end


    function SM1_start_move_thick_markers(varargin)
        SM1_UserData=varargin{3};
        SM1_UserData=get(SM1_UserData.fh,'UserData');

        seltype=get(SM1_UserData.fh,'SelectionType'); % Right-or-left click?
        ax_pos=get(SM1_UserData.ah,'CurrentPoint');
        if strcmp(seltype,'alt')
            modifiers=get(SM1_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                ax_x=get(gco,'XData');

                if isfield(SM1_UserData,'marked')
                    SM1_UserData.marked=unique([SM1_UserData.marked ax_x]);
                else
                    SM1_UserData.marked=ax_x;
                end
                [dummy,this,dummy2]=intersect(SM1_UserData.thick_markers,SM1_UserData.marked);
                SM1_UserData.marked_indy=this;
                if ~SM1_UserData.flag
                    SM1_UserData.flag=1;
                end
                set(gco,'Color',p_para.thick_mar_marked_col);

                set(SM1_UserData.fh,'Userdata',SM1_UserData)
                set(SM1_UserData.um,'CallBack',{@SM1_delete_thick_markers,SM1_UserData})
                set(SM1_UserData.fh,'WindowButtonMotionFcn',{@SM1_get_coordinates,SM1_UserData},'KeyPressFcn',{@SM1_keyboard,SM1_UserData})
                set(SM1_UserData.lh,'ButtonDownFcn',{@SM1_start_move_thick_markers,SM1_UserData},'UIContextMenu',SM1_UserData.cm)
                set(SM1_UserData.ah,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SM1_UserData.spike_lh{trac},'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                end
                set(SM1_UserData.image_mh,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                set(SM1_UserData.fh,'Userdata',SM1_UserData)
            end
        else
            SM1_UserData.initial_XPos=round(ax_pos(1,1)/SM1_UserData.dts)*SM1_UserData.dts;
            if ~SM1_UserData.flag
                num_lh=length(SM1_UserData.thick_markers);
                for selc=1:num_lh
                    set(SM1_UserData.lh(selc),'Color',p_para.thick_mar_col);
                end
                SM1_UserData.marked_indy=find(SM1_UserData.lh(:) == gco);
                SM1_UserData.initial_XData=get(gco,'XData');
            else
                SM1_UserData.initial_XData=SM1_UserData.thick_markers(SM1_UserData.marked_indy);
            end
            set(SM1_UserData.fh,'WindowButtonMotionFcn',{@SM1_move_thick_markers,SM1_UserData})
            set(SM1_UserData.ah,'ButtonDownFcn','')
            for trac=1:d_para.num_trains
                set(SM1_UserData.spike_lh{trac},'ButtonDownFcn','')
            end
            set(SM1_UserData.image_mh,'ButtonDownFcn','')
            set(SM1_UserData.fh,'Userdata',SM1_UserData)
        end
    end


    function SM1_move_thick_markers(varargin)
        SM1_UserData=varargin{3};
        SM1_UserData=get(SM1_UserData.fh,'UserData');

        ax_pos=get(SM1_UserData.ah,'CurrentPoint');
        ax_x_ok=SM1_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SM1_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;
        ax_x=round(ax_pos(1,1)/SM1_UserData.dts)*SM1_UserData.dts;
        for idx=1:length(SM1_UserData.marked_indy)
            if ((SM1_UserData.initial_XData(idx)+ax_x-SM1_UserData.initial_XPos)>SM1_UserData.tmin && ...
                    (SM1_UserData.initial_XData(idx)+ax_x-SM1_UserData.initial_XPos)<SM1_UserData.tmax)
                set(SM1_UserData.lh(SM1_UserData.marked_indy(idx)),'Color',p_para.thick_mar_marked_col,...
                    'XData',(SM1_UserData.initial_XData(idx)+ax_x-SM1_UserData.initial_XPos)*ones(1,2))
            else
                set(SM1_UserData.lh(SM1_UserData.marked_indy(idx)),'Color','w')
            end
        end
        drawnow;

        if ax_x_ok && ax_y_ok
            ax_x=round(ax_pos(1,1)/SM1_UserData.dts)*SM1_UserData.dts;
            set(SM1_UserData.tx,'str',['Time: ', num2str(ax_x)]);
        else
            set(SM1_UserData.tx,'str','Out of range');
        end
        set(SM1_UserData.fh,'WindowButtonUpFcn',{@SM1_stop_move_thick_markers,SM1_UserData})
        set(SM1_UserData.fh,'Userdata',SM1_UserData)
    end


    function SM1_stop_move_thick_markers(varargin)
        SM1_UserData=varargin{3};
        SM1_UserData=get(SM1_UserData.fh,'UserData');

        ax_pos=get(SM1_UserData.ah,'CurrentPoint');
        ax_x=round(ax_pos(1,1)/SM1_UserData.dts)*SM1_UserData.dts;

        for idx=1:length(SM1_UserData.marked_indy)
            if ((SM1_UserData.initial_XData(idx)+ax_x -SM1_UserData.initial_XPos)>SM1_UserData.tmin && ...
                    (SM1_UserData.initial_XData(idx)+ax_x -SM1_UserData.initial_XPos)<SM1_UserData.tmax )
                SM1_UserData.thick_markers(SM1_UserData.marked_indy(idx))=SM1_UserData.initial_XData(idx)+ax_x-SM1_UserData.initial_XPos;
            else
                SM1_UserData.thick_markers=SM1_UserData.thick_markers(setdiff(1:length(SM1_UserData.thick_markers),SM1_UserData.marked_indy(idx)));
                SM1_UserData.marked_indy(idx+1:end)=SM1_UserData.marked_indy(idx+1:end)-1;
            end
        end
        SM1_UserData.thick_markers=unique(SM1_UserData.thick_markers);
        SM1_UserData.marked_indy=[];
        SM1_UserData.flag=0;
        for lhc=1:size(SM1_UserData.lh,2)
            if ishandle(SM1_UserData.lh(lhc))
                delete(SM1_UserData.lh(lhc))
            end
        end
        num_lh=length(SM1_UserData.thick_markers);
        SM1_UserData.lh=zeros(1,num_lh);
        for selc=1:num_lh
            SM1_UserData.lh(selc)=line(SM1_UserData.thick_markers(selc)*ones(1,2),[0.05 1.05],...
                'Visible',p_para.thick_mar_vis,'Color',p_para.thick_mar_col,'LineStyle',p_para.thick_mar_ls,'LineWidth',p_para.thick_mar_lw);
        end
        thick_mar_str=num2str(SM1_UserData.thick_markers);
        if num_lh>1
            thick_mar_str=regexprep(thick_mar_str,'\s+',' ');
        end
        set(SM1_edit,'String',thick_mar_str)
        set(SM1_UserData.fh,'Pointer','arrow')
        drawnow;

        set(SM1_UserData.fh,'Userdata',SM1_UserData)
        set(SM1_UserData.um,'CallBack',{@SM1_delete_thick_markers,SM1_UserData})
        set(SM1_UserData.fh,'WindowButtonMotionFcn',{@SM1_get_coordinates,SM1_UserData},'KeyPressFcn',{@SM1_keyboard,SM1_UserData},...
            'WindowButtonUpFcn',[])
        set(SM1_UserData.lh,'ButtonDownFcn',{@SM1_start_move_thick_markers,SM1_UserData},'UIContextMenu',SM1_UserData.cm)
        set(SM1_UserData.ah,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SM1_UserData.spike_lh{trac},'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
        end
        set(SM1_UserData.image_mh,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
        set(SM1_UserData.fh,'Userdata',SM1_UserData)
    end


    function SM1_keyboard(varargin)
        SM1_UserData=varargin{3};
        SM1_UserData=get(SM1_UserData.fh,'UserData');

        if strcmp(varargin{2}.Key,'delete')
            if (SM1_UserData.flag)
                SM1_UserData.thick_markers=setdiff(SM1_UserData.thick_markers,SM1_UserData.thick_markers(SM1_UserData.marked_indy));
                SM1_UserData.marked_indy=[];
                SM1_UserData.flag=0;
                num_lh=length(SM1_UserData.thick_markers);
                thick_mar_str=num2str(SM1_UserData.thick_markers);
                if num_lh>1
                    thick_mar_str=regexprep(thick_mar_str,'\s+',' ');
                end
                for lhc=1:length(SM1_UserData.lh)
                    if ishandle(SM1_UserData.lh(lhc))
                        delete(SM1_UserData.lh(lhc))
                    end
                end
                num_lh=length(SM1_UserData.thick_markers);
                SM1_UserData.lh=zeros(1,num_lh);
                for selc=1:num_lh
                    SM1_UserData.lh(selc)=line(SM1_UserData.thick_markers(selc)*ones(1,2),[0.05 1.05],...
                        'Visible',p_para.thick_mar_vis,'Color',p_para.thick_mar_col,'LineStyle',p_para.thick_mar_ls,'LineWidth',p_para.thick_mar_lw);
                end
                set(SM1_edit,'String',thick_mar_str)

                set(SM1_UserData.fh,'Userdata',SM1_UserData)
                set(SM1_UserData.um,'CallBack',{@SM1_delete_thick_markers,SM1_UserData})
                set(SM1_UserData.fh,'WindowButtonMotionFcn',{@SM1_get_coordinates,SM1_UserData},'KeyPressFcn',{@SM1_keyboard,SM1_UserData})
                set(SM1_UserData.lh,'ButtonDownFcn',{@SM1_start_move_thick_markers,SM1_UserData},'UIContextMenu',SM1_UserData.cm)
                set(SM1_UserData.ah,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SM1_UserData.spike_lh{trac},'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                end
                set(SM1_UserData.image_mh,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                set(SM1_UserData.fh,'Userdata',SM1_UserData)
            end
        elseif strcmp(varargin{2}.Key,'a')
            modifiers=get(SM1_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                num_lh=length(SM1_UserData.thick_markers);
                SM1_UserData.marked=SM1_UserData.thick_markers;
                SM1_UserData.marked_indy=1:num_lh;
                for selc=1:num_lh
                    set(SM1_UserData.lh(selc),'Color',p_para.thick_mar_marked_col);
                end
                SM1_UserData.flag=1;

                set(SM1_UserData.fh,'Userdata',SM1_UserData)
                set(SM1_UserData.um,'CallBack',{@SM1_delete_thick_markers,SM1_UserData})
                set(SM1_UserData.fh,'WindowButtonMotionFcn',{@SM1_get_coordinates,SM1_UserData},'KeyPressFcn',{@SM1_keyboard,SM1_UserData})
                set(SM1_UserData.lh,'ButtonDownFcn',{@SM1_start_move_thick_markers,SM1_UserData},'UIContextMenu',SM1_UserData.cm)
                set(SM1_UserData.ah,'ButtonDownFcn',{@SM1_start_pick,SM1_UserData})
                for trac=1:d_para.num_trains
                    set(SM1_UserData.spike_lh{trac},'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                end
                set(SM1_UserData.image_mh,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                set(SM1_UserData.fh,'Userdata',SM1_UserData)
            end
        elseif strcmp(varargin{2}.Key,'c')
            modifiers=get(SM1_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                num_lh=length(SM1_UserData.thick_markers);
                ax_x=SM1_UserData.thick_markers(SM1_UserData.marked_indy);
                for idx=1:length(SM1_UserData.marked_indy)
                    SM1_UserData.lh(num_lh+idx)=line(SM1_UserData.thick_markers(SM1_UserData.marked_indy(idx))*ones(1,2),[0.05 1.05],...
                        'Visible',p_para.thick_mar_vis,'Color',p_para.thick_mar_marked_col,'LineStyle',p_para.thick_mar_ls,'LineWidth',p_para.thick_mar_lw);
                end
                SM1_UserData.marked=SM1_UserData.thick_markers(SM1_UserData.marked_indy);
                SM1_UserData.marked_indy=num_lh+(1:length(SM1_UserData.marked_indy));
                SM1_UserData.thick_markers(SM1_UserData.marked_indy)=SM1_UserData.marked;
                SM1_UserData.flag=1;
                ax_pos=get(SM1_UserData.ah,'CurrentPoint');
                SM1_UserData.initial_XPos=round(ax_pos(1,1)/SM1_UserData.dts)*SM1_UserData.dts;
                SM1_UserData.initial_XData=ax_x;
                set(SM1_UserData.ah,'ButtonDownFcn','')
                for trac=1:d_para.num_trains
                    set(SM1_UserData.spike_lh{trac},'ButtonDownFcn','')
                end
                set(SM1_UserData.image_mh,'ButtonDownFcn','')
                set(SM1_UserData.fh,'WindowButtonMotionFcn',{@SM1_move_thick_markers,SM1_UserData})
                set(SM1_UserData.fh,'Userdata',SM1_UserData)
            end
        end
    end


    function SM1_Load_markers(varargin)
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
            SM1_UserData=get(f_para.num_fig,'UserData');
            data.matfile=d_para.matfile;
            data.default_variable='';
            data.content='thick markers';
            SPIKY('SPIKY_select_variable',gcbo,data,handles)
            variable=getappdata(handles.figure1,'variable');
            if ~isempty(variable) && ~strcmp(variable,'A9ZB1YC8X')
                data=getappdata(handles.figure1,'data');
                SM1_UserData.thick_markers=squeeze(data.(variable));
            end
            if ~isnumeric(SM1_UserData.thick_markers) || ndims(SM1_UserData.thick_markers)~=2 || ~any(size(SM1_UserData.thick_markers)==1)
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
            if size(SM1_UserData.thick_markers,2)<size(SM1_UserData.thick_markers,1)
                SM1_UserData.thick_markers=SM1_UserData.thick_markers';
            end
            thick_mar_str=num2str(SM1_UserData.thick_markers);
            if length(SM1_UserData.thick_markers)>1
                thick_mar_str=regexprep(thick_mar_str,'\s+',' ');
            end
            set(SM1_edit,'String',thick_mar_str)
            set(SM1_UserData.fh,'Userdata',SM1_UserData)
        end
    end


    function SM1_callback(varargin)
        d_para=getappdata(handles.figure1,'data_parameters');
        f_para=getappdata(handles.figure1,'figure_parameters');
        figure(f_para.num_fig);
        SM1_UserData=get(gcf,'Userdata');

        if gcbo==SM1_Reset_pushbutton || gcbo==SM1_Cancel_pushbutton || gcbo==SM_fig
            if isfield(SM1_UserData,'lh')
                for rc=1:size(SM1_UserData.lh,1)
                    for lhc=1:size(SM1_UserData.lh,2)
                        if ishandle(SM1_UserData.lh(lhc))
                            delete(SM1_UserData.lh(lhc))
                        end
                    end
                end
                SM1_UserData.lh=[];
            end
            if isfield(SM1_UserData,'thick_markers')
                SM1_UserData.thick_markers=[];
            end
            d_para.thick_markers=[];
            set(SM1_edit,'string',[])
            if gcbo==SM1_Reset_pushbutton
                set(SM1_UserData.fh,'Userdata',SM1_UserData)
                set(SM1_UserData.um,'CallBack',{@SM1_delete_thick_markers,SM1_UserData})
                set(SM1_UserData.fh,'WindowButtonMotionFcn',{@SM1_get_coordinates,SM1_UserData},'KeyPressFcn',{@SM1_keyboard,SM1_UserData})
                set(SM1_UserData.lh,'ButtonDownFcn',{@SM1_start_move_thick_markers,SM1_UserData},'UIContextMenu',SM1_UserData.cm)
                set(SM1_UserData.ah,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SM1_UserData.spike_lh{trac},'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                end
                set(SM1_UserData.image_mh,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                set(SM1_UserData.fh,'Userdata',SM1_UserData)
            elseif gcbo==SM1_Cancel_pushbutton || gcbo==SM_fig
                SM1_UserData.cm=[];
                SM1_UserData.um=[];
                set(SM1_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
                set(SM1_UserData.lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SM1_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SM1_UserData.spike_lh{trac},'ButtonDownFcn','','UIContextMenu',[])
                end
                set(SM1_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SM1_UserData.fh,'Userdata',SM1_UserData)
                delete(SM_fig)
                set(handles.figure1,'Visible','on')
            end
        elseif gcbo==SM1_OK_pushbutton || gcbo==SM1_Apply_pushbutton
            thick_markers_str_in=regexprep(get(SM1_edit,'String'),'\s+',' ');
            thick_markers=unique(str2num(regexprep(thick_markers_str_in,f_para.regexp_str_vector_floats,'')));
            thick_markers=thick_markers(thick_markers>=d_para.tmin & thick_markers<=d_para.tmax);
            thick_markers_str_out=regexprep(num2str(thick_markers),'\s+',' ');
            
            if ~strcmp(thick_markers_str_in,thick_markers_str_out)
                if ~isempty(thick_markers_str_out)
                    set(SM1_edit,'String',thick_markers_str_out)
                else
                    set(SM1_edit,'String',regexprep(num2str(d_para.thick_markers),'\s+',' '))
                end
                set(0,'DefaultUIControlFontSize',16);
                mbh=msgbox(sprintf('The input has been corrected !'),'Warning','warn','modal');
                htxt=findobj(mbh,'Type','text');
                set(htxt,'FontSize',12,'FontWeight','bold')
                mb_pos=get(mbh,'Position');
                set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                uiwait(mbh);
                return
            end
            SM1_UserData.thick_markers=unique(round(str2num(get(SM1_edit,'String'))/d_para.dts)*d_para.dts);
            delete(SM1_UserData.lh)
            SM1_UserData=rmfield(SM1_UserData,'lh');

            figure(f_para.num_fig);
            thick_mar_cmenu=uicontextmenu;
            SM1_UserData.lh=zeros(1,length(SM1_UserData.thick_markers));
            for lhc=1:length(SM1_UserData.thick_markers)
                SM1_UserData.lh(lhc)=line(SM1_UserData.thick_markers(lhc)*ones(1,2),[0.05 1.05],...
                    'Color',p_para.thick_mar_col,'LineStyle',p_para.thick_mar_ls,'LineWidth',p_para.thick_mar_lw,'UIContextMenu',thick_mar_cmenu);
            end
            set(SM1_UserData.fh,'Userdata',SM1_UserData)

            if gcbo==SM1_Apply_pushbutton
                set(SM1_UserData.fh,'Userdata',SM1_UserData)
                set(SM1_UserData.um,'CallBack',{@SM1_delete_thick_markers,SM1_UserData})
                set(SM1_UserData.fh,'WindowButtonMotionFcn',{@SM1_get_coordinates,SM1_UserData},'KeyPressFcn',{@SM1_keyboard,SM1_UserData})
                set(SM1_UserData.lh,'ButtonDownFcn',{@SM1_start_move_thick_markers,SM1_UserData},'UIContextMenu',SM1_UserData.cm)
                set(SM1_UserData.ah,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SM1_UserData.spike_lh{trac},'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                end
                set(SM1_UserData.image_mh,'ButtonDownFcn',{@SM1_pick_thick_markers,SM1_UserData},'UIContextMenu',[])
                set(SM1_UserData.fh,'Userdata',SM1_UserData)
            else
                d_para.thick_markers=unique(round(SM1_UserData.thick_markers/d_para.dts)*d_para.dts);
                setappdata(handles.figure1,'data_parameters',d_para)

                set(SM1_panel,'HighlightColor','w')
                set(SM1_edit,'Enable','off')
                set(SM1_Cancel_pushbutton,'Enable','off')
                set(SM1_Reset_pushbutton,'Enable','off')
                set(SM1_Apply_pushbutton,'Enable','off')
                set(SM1_Load_pushbutton,'Enable','off')
                set(SM1_OK_pushbutton,'Enable','off')
                if isfield(SM1_UserData,'lh')
                    for lhc=1:length(SM1_UserData.lh)
                        if ishandle(SM1_UserData.lh(lhc))
                            delete(SM1_UserData.lh(lhc))
                        end
                    end
                    SM1_UserData.lh=[];
                end
                SM1_UserData.lh2=zeros(2,length(SM1_UserData.thick_markers));
                for lhc=1:length(SM1_UserData.thick_markers)
                    SM1_UserData.lh2(1,lhc)=line(SM1_UserData.thick_markers(lhc)*ones(1,2),[0 0.05],'Color',p_para.thick_mar_col,...
                        'LineStyle',p_para.thick_mar_ls,'LineWidth',p_para.thick_mar_lw,'UIContextMenu',thick_mar_cmenu);
                    SM1_UserData.lh2(2,lhc)=line(SM1_UserData.thick_markers(lhc)*ones(1,2),[1.05 1.10],'Color',p_para.thick_mar_col,...
                        'LineStyle',p_para.thick_mar_ls,'LineWidth',p_para.thick_mar_lw,'UIContextMenu',thick_mar_cmenu);
                end
                SM1_UserData.marked_indy=[];
                SM1_UserData.flag=0;
                SM1_UserData.cm=[];
                SM1_UserData.um=[];
                set(SM1_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
                set(SM1_UserData.lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SM1_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SM1_UserData.spike_lh{trac},'ButtonDownFcn','','UIContextMenu',[])
                end
                set(SM1_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])

                % ########################################################

                set(SM2_panel,'Visible','on','HighlightColor','k')
                set(SM2_edit,'Visible','on')
                set(SM2_Cancel_pushbutton,'Visible','on')
                set(SM2_Reset_pushbutton,'Visible','on')
                set(SM2_Apply_pushbutton,'Visible','on')
                set(SM2_Load_pushbutton,'Visible','on')
                set(SM2_OK_pushbutton,'Visible','on','FontWeight','bold')
                uicontrol(SM2_OK_pushbutton)
                SM2_UserData=SM1_UserData;

                figure(f_para.num_fig);
                if isfield(d_para,'thin_markers')
                    set(SM2_edit,'String',regexprep(num2str(d_para.thin_markers),'\s+',' '))
                    SM2_UserData.lh=zeros(1,length(d_para.thin_markers));
                    for lhc=1:length(d_para.thin_markers)
                        SM2_UserData.lh(lhc)=line(d_para.thin_markers(lhc)*ones(1,2),[0.05 1.05],...
                            'Color',p_para.thin_mar_col,'LineStyle',p_para.thin_mar_ls,'LineWidth',p_para.thin_mar_lw);
                    end
                    SM2_UserData.thin_markers=d_para.thin_markers;
                else
                    SM2_UserData.thin_markers=[];                    
                end

                set(SM2_UserData.fh,'Userdata',SM2_UserData)
                SM2_UserData.cm=uicontextmenu;
                SM2_UserData.um=uimenu(SM2_UserData.cm,'label','Delete thin marker(s)','CallBack',{@SM2_delete_thin_markers,SM2_UserData});
                set(SM2_UserData.fh,'WindowButtonMotionFcn',{@SM2_get_coordinates,SM2_UserData},'KeyPressFcn',{@SM2_keyboard,SM2_UserData});
                set(SM2_UserData.lh,'ButtonDownFcn',{@SM2_start_move_thin_markers,SM2_UserData},'UIContextMenu',SM2_UserData.cm)
                set(SM2_UserData.ah,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SM2_UserData.spike_lh{trac},'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                end
                set(SM2_UserData.image_mh,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                set(SM2_UserData.fh,'Userdata',SM2_UserData)
            end
        end
    end


% ########################################################
% ########################################################              SM2
% ########################################################

    function SM2_get_coordinates(varargin)
        SM2_UserData=varargin{3};
        SM2_UserData=get(SM2_UserData.fh,'UserData');

        ax_pos=get(SM2_UserData.ah,'CurrentPoint');
        ax_x_ok=SM2_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SM2_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        if ax_x_ok && ax_y_ok
            ax_x=round(ax_pos(1,1)/SM2_UserData.dts)*SM2_UserData.dts;
            set(SM2_UserData.tx,'str',['Time: ', num2str(ax_x)]);
        else
            set(SM2_UserData.tx,'str','Out of range');
        end
    end


    function SM2_pick_thin_markers(varargin)                                   % SM2_marked_indy changes
        SM2_UserData=varargin{3};
        SM2_UserData=get(SM2_UserData.fh,'UserData');

        ax_pos=get(SM2_UserData.ah,'CurrentPoint');
        ax_x=round(ax_pos(1,1)/SM2_UserData.dts)*SM2_UserData.dts;
        ax_x_ok=SM2_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SM2_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        modifiers=get(SM2_UserData.fh,'CurrentModifier');
        if ax_x_ok && ax_y_ok
            seltype=get(SM2_UserData.fh,'SelectionType');            % Right-or-left click?
            ctrlIsPressed=ismember('control',modifiers);
            if strcmp(seltype,'normal') || ctrlIsPressed                      % right or middle
                if ~isempty(SM2_UserData.thin_markers)
                    num_lh=length(SM2_UserData.thin_markers);
                    for lhc=1:num_lh
                        if ishandle(SM2_UserData.lh(lhc))
                            delete(SM2_UserData.lh(lhc))
                        end
                    end
                    SM2_UserData.thin_markers=unique([SM2_UserData.thin_markers ax_x]);
                else
                    SM2_UserData.thin_markers=ax_x;
                end
                num_lh=length(SM2_UserData.thin_markers);
                SM2_UserData.lh=zeros(1,num_lh);
                for selc=1:num_lh
                    if ismember(selc,SM2_UserData.marked_indy)
                        SM2_UserData.lh(selc)=line(SM2_UserData.thin_markers(selc)*ones(1,2),[0.05 1.05],...
                            'Visible',p_para.thin_mar_vis,'Color',p_para.thin_mar_marked_col,'LineStyle',p_para.thin_mar_ls,'LineWidth',p_para.thin_mar_lw);
                    else
                        SM2_UserData.lh(selc)=line(SM2_UserData.thin_markers(selc)*ones(1,2),[0.05 1.05],...
                            'Visible',p_para.thin_mar_vis,'Color',p_para.thin_mar_col,'LineStyle',p_para.thin_mar_ls,'LineWidth',p_para.thin_mar_lw);
                    end
                end

                thin_mar_str=num2str(SM2_UserData.thin_markers);
                if length(SM2_UserData.thin_markers)>1
                    thin_mar_str=regexprep(thin_mar_str,'\s+',' ');
                end
                set(SM2_edit,'String',thin_mar_str)
            end

            shftIsPressed=ismember('shift',modifiers);
            if ctrlIsPressed
                if isfield(SM2_UserData,'marked')
                    SM2_UserData.marked=unique([SM2_UserData.marked ax_x]);
                else
                    SM2_UserData.marked=ax_x;
                end
                [dummy,this,dummy2]=intersect(SM2_UserData.thin_markers,SM2_UserData.marked);
                SM2_UserData.marked_indy=this;
                set(SM2_UserData.lh,'Color',p_para.thin_mar_col)
                set(SM2_UserData.lh(SM2_UserData.marked_indy),'Color',p_para.thin_mar_marked_col)
                SM2_UserData.flag=1;
            elseif ~shftIsPressed
                set(SM2_UserData.lh,'Color',p_para.thin_mar_col)
                SM2_UserData.marked=[];
                SM2_UserData.flag=0;
                SM2_UserData.marked_indy=[];
            end
        end

        dummy_marked=SM2_UserData.marked_indy;
        if shftIsPressed
            set(SM2_UserData.fh,'WindowButtonUpFcn',[])
            ax_pos=get(SM2_UserData.ah,'CurrentPoint');
            first_corner_x=ax_pos(1,1);
            first_corner_y=ax_pos(1,2);
            window=rectangle('Position',[first_corner_x, first_corner_y, 0.01, 0.01]);
            while shftIsPressed
                ax_pos=get(SM2_UserData.ah,'CurrentPoint');
                second_corner_x=ax_pos(1,1);
                second_corner_y=ax_pos(1,2);
                if second_corner_x ~= first_corner_x && second_corner_y ~= first_corner_y
                    set(window,'Position',[min(first_corner_x, second_corner_x), min(first_corner_y, second_corner_y), abs(second_corner_x-first_corner_x), abs(second_corner_y-first_corner_y)])
                    drawnow
                    left_mark=min(first_corner_x, second_corner_x);
                    right_mark=max(first_corner_x, second_corner_x);
                    SM2_UserData.marked_indy=unique([dummy_marked find(SM2_UserData.thin_markers>=left_mark & SM2_UserData.thin_markers<=right_mark)]);
                    SM2_UserData.flag=(~isempty(SM2_UserData.marked_indy));
                    set(SM2_UserData.lh,'Color',p_para.thin_mar_col)
                    set(SM2_UserData.lh(SM2_UserData.marked_indy),'Color',p_para.thin_mar_marked_col)
                end
                pause(0.001);
                modifiers=get(SM2_UserData.fh,'CurrentModifier');
                shftIsPressed=ismember('shift',modifiers);
            end
            delete(window)
            SM2_UserData.marked=SM2_UserData.thin_markers(SM2_UserData.marked_indy);
        end

        set(SM2_UserData.fh,'Userdata',SM2_UserData)
        set(SM2_UserData.um,'CallBack',{@SM2_delete_thin_markers,SM2_UserData})
        set(SM2_UserData.fh,'WindowButtonMotionFcn',{@SM2_get_coordinates,SM2_UserData},'KeyPressFcn',{@SM2_keyboard,SM2_UserData})
        set(SM2_UserData.lh,'ButtonDownFcn',{@SM2_start_move_thin_markers,SM2_UserData},'UIContextMenu',SM2_UserData.cm)
        set(SM2_UserData.ah,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SM2_UserData.spike_lh{trac},'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
        end
        set(SM2_UserData.image_mh,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
        set(SM2_UserData.fh,'Userdata',SM2_UserData)
    end


    function SM2_delete_thin_markers(varargin)
        SM2_UserData=varargin{3};
        SM2_UserData=get(SM2_UserData.fh,'UserData');

        if (SM2_UserData.flag)
            SM2_UserData.thin_markers=setdiff(SM2_UserData.thin_markers,SM2_UserData.thin_markers(SM2_UserData.marked_indy));
            SM2_UserData.marked_indy=[];
            SM2_UserData.flag=0;
        else
            SM2_UserData.thin_markers=setdiff(SM2_UserData.thin_markers,get(gco,'XData'));
        end
        num_lh=length(SM2_UserData.thin_markers);
        thin_mar_str=num2str(SM2_UserData.thin_markers);
        if num_lh>1
            thin_mar_str=regexprep(thin_mar_str,'\s+',' ');
        end
        for lhc=1:length(SM2_UserData.lh)
            if ishandle(SM2_UserData.lh(lhc))
                delete(SM2_UserData.lh(lhc))
            end
        end
        SM2_UserData.lh=zeros(1,num_lh);
        for selc=1:num_lh
            SM2_UserData.lh(selc)=line(SM2_UserData.thin_markers(selc)*ones(1,2),[0.05 1.05],...
                'Visible',p_para.thin_mar_vis,'Color',p_para.thin_mar_col,'LineStyle',p_para.thin_mar_ls,'LineWidth',p_para.thin_mar_lw);
        end
        set(SM2_edit,'String',thin_mar_str)

        set(SM2_UserData.fh,'Userdata',SM2_UserData)
        set(SM2_UserData.um,'CallBack',{@SM2_delete_thin_markers,SM2_UserData})
        set(SM2_UserData.fh,'WindowButtonMotionFcn',{@SM2_get_coordinates,SM2_UserData},'KeyPressFcn',{@SM2_keyboard,SM2_UserData})
        set(SM2_UserData.lh,'ButtonDownFcn',{@SM2_start_move_thin_markers,SM2_UserData},'UIContextMenu',SM2_UserData.cm)
        set(SM2_UserData.ah,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SM2_UserData.spike_lh{trac},'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
        end
        set(SM2_UserData.image_mh,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
        set(SM2_UserData.fh,'Userdata',SM2_UserData)
    end


    function SM2_start_move_thin_markers(varargin)
        SM2_UserData=varargin{3};
        SM2_UserData=get(SM2_UserData.fh,'UserData');

        seltype=get(SM2_UserData.fh,'SelectionType'); % Right-or-left click?
        ax_pos=get(SM2_UserData.ah,'CurrentPoint');
        if strcmp(seltype,'alt')
            modifiers=get(SM2_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                ax_x=get(gco,'XData');

                if isfield(SM2_UserData,'marked')
                    SM2_UserData.marked=unique([SM2_UserData.marked ax_x]);
                else
                    SM2_UserData.marked=ax_x;
                end
                [dummy,this,dummy2]=intersect(SM2_UserData.thin_markers,SM2_UserData.marked);
                SM2_UserData.marked_indy=this;
                if ~SM2_UserData.flag
                    SM2_UserData.flag=1;
                end
                set(gco,'Color',p_para.thin_mar_marked_col);

                set(SM2_UserData.fh,'Userdata',SM2_UserData)
                set(SM2_UserData.um,'CallBack',{@SM2_delete_thin_markers,SM2_UserData})
                set(SM2_UserData.fh,'WindowButtonMotionFcn',{@SM2_get_coordinates,SM2_UserData},'KeyPressFcn',{@SM2_keyboard,SM2_UserData})
                set(SM2_UserData.lh,'ButtonDownFcn',{@SM2_start_move_thin_markers,SM2_UserData},'UIContextMenu',SM2_UserData.cm)
                set(SM2_UserData.ah,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SM2_UserData.spike_lh{trac},'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                end
                set(SM2_UserData.image_mh,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                set(SM2_UserData.fh,'Userdata',SM2_UserData)
            end
        else
            SM2_UserData.initial_XPos=round(ax_pos(1,1)/SM2_UserData.dts)*SM2_UserData.dts;
            if ~SM2_UserData.flag
                num_lh=length(SM2_UserData.thin_markers);
                for selc=1:num_lh
                    set(SM2_UserData.lh(selc),'Color',p_para.thin_mar_col);
                end
                SM2_UserData.marked_indy=find(SM2_UserData.lh(:) == gco);
                SM2_UserData.initial_XData=get(gco,'XData');
            else
                SM2_UserData.initial_XData=SM2_UserData.thin_markers(SM2_UserData.marked_indy);
            end
            set(SM2_UserData.fh,'WindowButtonMotionFcn',{@SM2_move_thin_markers,SM2_UserData})
            set(SM2_UserData.ah,'ButtonDownFcn','')
            for trac=1:d_para.num_trains
                set(SM2_UserData.spike_lh{trac},'ButtonDownFcn','','UIContextMenu',[])
            end
            set(SM2_UserData.image_mh,'ButtonDownFcn','')
            set(SM2_UserData.fh,'Userdata',SM2_UserData)
        end
    end


    function SM2_move_thin_markers(varargin)
        SM2_UserData=varargin{3};
        SM2_UserData=get(SM2_UserData.fh,'UserData');

        ax_pos=get(SM2_UserData.ah,'CurrentPoint');
        ax_x_ok=SM2_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SM2_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;
        ax_x=round(ax_pos(1,1)/SM2_UserData.dts)*SM2_UserData.dts;
        for idx=1:length(SM2_UserData.marked_indy)
            if ((SM2_UserData.initial_XData(idx)+ax_x-SM2_UserData.initial_XPos)>SM2_UserData.tmin && ...
                    (SM2_UserData.initial_XData(idx)+ax_x-SM2_UserData.initial_XPos)<SM2_UserData.tmax)
                set(SM2_UserData.lh(SM2_UserData.marked_indy(idx)),'Color',p_para.thin_mar_marked_col,...
                    'XData',(SM2_UserData.initial_XData(idx)+ax_x-SM2_UserData.initial_XPos)*ones(1,2))
            else
                set(SM2_UserData.lh(SM2_UserData.marked_indy(idx)),'Color','w')
            end
        end
        drawnow;

        if ax_x_ok && ax_y_ok
            ax_x=round(ax_pos(1,1)/SM2_UserData.dts)*SM2_UserData.dts;
            set(SM2_UserData.tx,'str',['Time: ', num2str(ax_x)]);
        else
            set(SM2_UserData.tx,'str','Out of range');
        end
        set(SM2_UserData.fh,'WindowButtonUpFcn',{@SM2_stop_move_thin_markers,SM2_UserData})
        set(SM2_UserData.fh,'Userdata',SM2_UserData)
    end


    function SM2_stop_move_thin_markers(varargin)
        SM2_UserData=varargin{3};
        SM2_UserData=get(SM2_UserData.fh,'UserData');

        ax_pos=get(SM2_UserData.ah,'CurrentPoint');
        ax_x=round(ax_pos(1,1)/SM2_UserData.dts)*SM2_UserData.dts;

        for idx=1:length(SM2_UserData.marked_indy)
            if ((SM2_UserData.initial_XData(idx)+ax_x -SM2_UserData.initial_XPos)>SM2_UserData.tmin && ...
                    (SM2_UserData.initial_XData(idx)+ax_x -SM2_UserData.initial_XPos)<SM2_UserData.tmax )
                SM2_UserData.thin_markers(SM2_UserData.marked_indy(idx))=SM2_UserData.initial_XData(idx)+ax_x-SM2_UserData.initial_XPos;
            else
                SM2_UserData.thin_markers=SM2_UserData.thin_markers(setdiff(1:length(SM2_UserData.thin_markers),SM2_UserData.marked_indy(idx)));
                SM2_UserData.marked_indy(idx+1:end)=SM2_UserData.marked_indy(idx+1:end)-1;
            end
        end
        SM2_UserData.thin_markers=unique(SM2_UserData.thin_markers);
        SM2_UserData.marked_indy=[];
        SM2_UserData.flag=0;
        for lhc=1:size(SM2_UserData.lh,2)
            if ishandle(SM2_UserData.lh(lhc))
                delete(SM2_UserData.lh(lhc))
            end
        end
        num_lh=length(SM2_UserData.thin_markers);
        SM2_UserData.lh=zeros(1,num_lh);
        for selc=1:num_lh
            SM2_UserData.lh(selc)=line(SM2_UserData.thin_markers(selc)*ones(1,2),[0.05 1.05],...
                'Visible',p_para.thin_mar_vis,'Color',p_para.thin_mar_col,'LineStyle',p_para.thin_mar_ls,'LineWidth',p_para.thin_mar_lw);
        end
        thin_mar_str=num2str(SM2_UserData.thin_markers);
        if num_lh>1
            thin_mar_str=regexprep(thin_mar_str,'\s+',' ');
        end
        set(SM2_edit,'String',thin_mar_str)
        set(SM2_UserData.fh,'Pointer','arrow')
        drawnow;

        set(SM2_UserData.fh,'Userdata',SM2_UserData)
        set(SM2_UserData.um,'CallBack',{@SM2_delete_thin_markers,SM2_UserData})
        set(SM2_UserData.fh,'WindowButtonMotionFcn',{@SM2_get_coordinates,SM2_UserData},'KeyPressFcn',{@SM2_keyboard,SM2_UserData},...
            'WindowButtonUpFcn',[])
        set(SM2_UserData.lh,'ButtonDownFcn',{@SM2_start_move_thin_markers,SM2_UserData},'UIContextMenu',SM2_UserData.cm)
        set(SM2_UserData.ah,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SM2_UserData.spike_lh{trac},'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
        end
        set(SM2_UserData.image_mh,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
        set(SM2_UserData.fh,'Userdata',SM2_UserData)
    end


    function SM2_keyboard(varargin)
        SM2_UserData=varargin{3};
        SM2_UserData=get(SM2_UserData.fh,'UserData');

        if strcmp(varargin{2}.Key,'delete')
            if (SM2_UserData.flag)
                SM2_UserData.thin_markers=setdiff(SM2_UserData.thin_markers,SM2_UserData.thin_markers(SM2_UserData.marked_indy));
                SM2_UserData.marked_indy=[];
                SM2_UserData.flag=0;
                num_lh=length(SM2_UserData.thin_markers);
                thin_mar_str=num2str(SM2_UserData.thin_markers);
                if num_lh>1
                    thin_mar_str=regexprep(thin_mar_str,'\s+',' ');
                end
                for lhc=1:length(SM2_UserData.lh)
                    if ishandle(SM2_UserData.lh(lhc))
                        delete(SM2_UserData.lh(lhc))
                    end
                end
                num_lh=length(SM2_UserData.thin_markers);
                SM2_UserData.lh=zeros(1,num_lh);
                for selc=1:num_lh
                    SM2_UserData.lh(selc)=line(SM2_UserData.thin_markers(selc)*ones(1,2),[0.05 1.05],...
                        'Visible',p_para.thin_mar_vis,'Color',p_para.thin_mar_col,'LineStyle',p_para.thin_mar_ls,'LineWidth',p_para.thin_mar_lw);
                end
                set(SM2_edit,'String',thin_mar_str)

                set(SM2_UserData.fh,'Userdata',SM2_UserData)
                set(SM2_UserData.um,'CallBack',{@SM2_delete_thin_markers,SM2_UserData})
                set(SM2_UserData.fh,'WindowButtonMotionFcn',{@SM2_get_coordinates,SM2_UserData},'KeyPressFcn',{@SM2_keyboard,SM2_UserData})
                set(SM2_UserData.lh,'ButtonDownFcn',{@SM2_start_move_thin_markers,SM2_UserData},'UIContextMenu',SM2_UserData.cm)
                set(SM2_UserData.ah,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SM2_UserData.spike_lh{trac},'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                end
                set(SM2_UserData.image_mh,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                set(SM2_UserData.fh,'Userdata',SM2_UserData)
            end
        elseif strcmp(varargin{2}.Key,'a')
            modifiers=get(SM2_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                num_lh=length(SM2_UserData.thin_markers);
                SM2_UserData.marked=SM2_UserData.thin_markers;
                SM2_UserData.marked_indy=1:num_lh;
                for selc=1:num_lh
                    set(SM2_UserData.lh(selc),'Color',p_para.thin_mar_marked_col);
                end
                SM2_UserData.flag=1;

                set(SM2_UserData.fh,'Userdata',SM2_UserData)
                set(SM2_UserData.um,'CallBack',{@SM2_delete_thin_markers,SM2_UserData})
                set(SM2_UserData.fh,'WindowButtonMotionFcn',{@SM2_get_coordinates,SM2_UserData},'KeyPressFcn',{@SM2_keyboard,SM2_UserData})
                set(SM2_UserData.lh,'ButtonDownFcn',{@SM2_start_move_thin_markers,SM2_UserData},'UIContextMenu',SM2_UserData.cm)
                set(SM2_UserData.ah,'ButtonDownFcn',{@SM2_start_pick,SM2_UserData})
                for trac=1:d_para.num_trains
                    set(SM2_UserData.spike_lh{trac},'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                end
                set(SM2_UserData.image_mh,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                set(SM2_UserData.fh,'Userdata',SM2_UserData)
            end
        elseif strcmp(varargin{2}.Key,'c')
            modifiers=get(SM2_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                num_lh=length(SM2_UserData.thin_markers);
                ax_x=SM2_UserData.thin_markers(SM2_UserData.marked_indy);
                for idx=1:length(SM2_UserData.marked_indy)
                    SM2_UserData.lh(num_lh+idx)=line(SM2_UserData.thin_markers(SM2_UserData.marked_indy(idx))*ones(1,2),[0.05 1.05],...
                        'Visible',p_para.thin_mar_vis,'Color',p_para.thin_mar_marked_col,'LineStyle',p_para.thin_mar_ls,'LineWidth',p_para.thin_mar_lw);
                end
                SM2_UserData.marked=SM2_UserData.thin_markers(SM2_UserData.marked_indy);
                SM2_UserData.marked_indy=num_lh+(1:length(SM2_UserData.marked_indy));
                SM2_UserData.thin_markers(SM2_UserData.marked_indy)=SM2_UserData.marked;
                SM2_UserData.flag=1;
                ax_pos=get(SM2_UserData.ah,'CurrentPoint');
                SM2_UserData.initial_XPos=round(ax_pos(1,1)/SM2_UserData.dts)*SM2_UserData.dts;
                SM2_UserData.initial_XData=ax_x;
                set(SM2_UserData.ah,'ButtonDownFcn','')
                for trac=1:d_para.num_trains
                    set(SM2_UserData.spike_lh{trac},'ButtonDownFcn','','UIContextMenu',[])
                end
                set(SM2_UserData.image_mh,'ButtonDownFcn','')
                set(SM2_UserData.fh,'WindowButtonMotionFcn',{@SM2_move_thin_markers,SM2_UserData})
                set(SM2_UserData.fh,'Userdata',SM2_UserData)
            end
        end
    end


    function SM2_Load_markers(varargin)
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
            SM2_UserData=get(f_para.num_fig,'UserData');
            data.matfile=d_para.matfile;
            data.default_variable='';
            data.content='thin markers';
            SPIKY('SPIKY_select_variable',gcbo,data,handles)
            variable=getappdata(handles.figure1,'variable');
            if ~isempty(variable) && ~strcmp(variable,'A9ZB1YC8X')
                data=getappdata(handles.figure1,'data');
                SM2_UserData.thin_markers=squeeze(data.(variable));
            end
            if ~isnumeric(SM2_UserData.thin_markers) || ndims(SM2_UserData.thin_markers)~=2 || ~any(size(SM2_UserData.thin_markers)==1)
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
            if size(SM2_UserData.thin_markers,2)<size(SM2_UserData.thin_markers,1)
                SM2_UserData.thin_markers=SM2_UserData.thin_markers';
            end
            thin_mar_str=num2str(SM2_UserData.thin_markers);
            if length(SM2_UserData.thin_markers)>1
                thin_mar_str=regexprep(thin_mar_str,'\s+',' ');
            end
            set(SM2_edit,'String',thin_mar_str)
            set(SM2_UserData.fh,'Userdata',SM2_UserData)
        end
    end


    function SM2_callback(varargin)
        d_para=getappdata(handles.figure1,'data_parameters');
        f_para=getappdata(handles.figure1,'figure_parameters');
        figure(f_para.num_fig);
        SM2_UserData=get(gcf,'Userdata');

        if gcbo==SM2_Reset_pushbutton || gcbo==SM2_Cancel_pushbutton || gcbo==SM_fig
            if isfield(SM2_UserData,'lh')
                for rc=1:size(SM2_UserData.lh,1)
                    for lhc=1:size(SM2_UserData.lh,2)
                        if ishandle(SM2_UserData.lh(lhc))
                            delete(SM2_UserData.lh(lhc))
                        end
                    end
                end
                SM2_UserData.lh=[];
            end
            if isfield(SM2_UserData,'thin_markers')
                SM2_UserData.thin_markers=[];
            end
            d_para.thin_markers=[];
            set(SM2_edit,'string',[])
            if gcbo==SM2_Reset_pushbutton
                set(SM2_UserData.fh,'Userdata',SM2_UserData)
                set(SM2_UserData.um,'CallBack',{@SM2_delete_thin_markers,SM2_UserData})
                set(SM2_UserData.fh,'WindowButtonMotionFcn',{@SM2_get_coordinates,SM2_UserData},'KeyPressFcn',{@SM2_keyboard,SM2_UserData})
                set(SM2_UserData.lh,'ButtonDownFcn',{@SM2_start_move_thin_markers,SM2_UserData},'UIContextMenu',SM2_UserData.cm)
                set(SM2_UserData.ah,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SM2_UserData.spike_lh{trac},'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                end
                set(SM2_UserData.image_mh,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                set(SM2_UserData.fh,'Userdata',SM2_UserData)
            elseif gcbo==SM2_Cancel_pushbutton || gcbo==SM_fig
                SM2_UserData.cm=[];
                SM2_UserData.um=[];
                set(SM2_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
                set(SM2_UserData.lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SM2_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SM2_UserData.spike_lh{trac},'ButtonDownFcn',[],'UIContextMenu',[])
                end
                set(SM2_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SM2_UserData.fh,'Userdata',SM2_UserData)
                delete(SM_fig)
                set(handles.figure1,'Visible','on')
            end
        elseif gcbo==SM2_OK_pushbutton || gcbo==SM2_Apply_pushbutton
            thin_markers_str_in=regexprep(get(SM2_edit,'String'),'\s+',' ');
            thin_markers=unique(str2num(regexprep(thin_markers_str_in,f_para.regexp_str_vector_floats,'')));
            thin_markers=thin_markers(thin_markers>=d_para.tmin & thin_markers<=d_para.tmax);
            thin_markers_str_out=regexprep(num2str(thin_markers),'\s+',' ');
            if ~strcmp(thin_markers_str_in,thin_markers_str_out)
                if ~isempty(thin_markers_str_out)
                    set(SM2_edit,'String',thin_markers_str_out)
                else
                    set(SM2_edit,'String',regexprep(num2str(d_para.thin_markers),'\s+',' '))
                end
                set(0,'DefaultUIControlFontSize',16);
                mbh=msgbox(sprintf('The input has been corrected !'),'Warning','warn','modal');
                htxt=findobj(mbh,'Type','text');
                set(htxt,'FontSize',12,'FontWeight','bold')
                mb_pos=get(mbh,'Position');
                set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                uiwait(mbh);
                return
            end
            SM2_UserData.thin_markers=unique(round(str2num(get(SM2_edit,'String'))/d_para.dts)*d_para.dts);
            delete(SM2_UserData.lh)
            SM2_UserData=rmfield(SM2_UserData,'lh');

            figure(f_para.num_fig);
            if gcbo==SM2_Apply_pushbutton
                thin_mar_cmenu=uicontextmenu;
                SM2_UserData.lh=zeros(1,length(SM2_UserData.thin_markers));
                for lhc=1:length(SM2_UserData.thin_markers)
                    SM2_UserData.lh(lhc)=line(SM2_UserData.thin_markers(lhc)*ones(1,2),[0.05 1.05],...
                        'Color',p_para.thin_mar_col,'LineStyle',p_para.thin_mar_ls,'LineWidth',p_para.thin_mar_lw,'UIContextMenu',thin_mar_cmenu);
                end
                set(SM2_UserData.fh,'Userdata',SM2_UserData)
                set(SM2_UserData.fh,'Userdata',SM2_UserData)
                set(SM2_UserData.um,'CallBack',{@SM2_delete_thin_markers,SM2_UserData})
                set(SM2_UserData.fh,'WindowButtonMotionFcn',{@SM2_get_coordinates,SM2_UserData},'KeyPressFcn',{@SM2_keyboard,SM2_UserData})
                set(SM2_UserData.lh,'ButtonDownFcn',{@SM2_start_move_thin_markers,SM2_UserData},'UIContextMenu',SM2_UserData.cm)
                set(SM2_UserData.ah,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SM2_UserData.spike_lh{trac},'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                end
                set(SM2_UserData.image_mh,'ButtonDownFcn',{@SM2_pick_thin_markers,SM2_UserData},'UIContextMenu',[])
                set(SM2_UserData.fh,'Userdata',SM2_UserData)
            else
                if isfield(SM2_UserData,'lh')
                    for lhc=1:length(SM2_UserData.lh)
                        if ishandle(SM2_UserData.lh(lhc))
                            delete(SM2_UserData.lh(lhc))
                        end
                    end
                    SM2_UserData=rmfield(SM2_UserData,'lh');
                end
                SM2_UserData.marked_indy=[];
                SM2_UserData.flag=0;
                SM2_UserData.cm=[];
                SM2_UserData.um=[];
                set(SM2_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
                set(SM2_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SM2_UserData.spike_lh{trac},'ButtonDownFcn','','UIContextMenu',[])
                end
                set(SM2_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SM2_UserData.fh,'Userdata',SM2_UserData)

                d_para.thick_markers=SM2_UserData.thick_markers;
                d_para.thin_markers=SM2_UserData.thin_markers;
                setappdata(handles.figure1,'data_parameters',d_para)
                set(handles.dpara_thick_markers_edit,'String',regexprep(num2str(d_para.thick_markers),'\s+',' '))
                set(handles.dpara_thin_markers_edit,'String',regexprep(num2str(d_para.thin_markers),'\s+',' '))
                
                set(SM2_OK_pushbutton,'UserData',1)
                set(handles.figure1,'Visible','on')
                delete(SM_fig)
            end
        end
    end


    function SM_Close_callback(varargin)
        figure(f_para.num_fig);
        SM_UserData=get(gcf,'Userdata');
        if isfield(SM_UserData,'lh')
            for cc=1:length(SM_UserData.lh)
                if ishandle(SM_UserData.lh(cc))
                    delete(SM_UserData.lh(cc))
                end
            end
            SM_UserData.lh=[];
        end
        if isfield(SM_UserData,'lh2')
            for rc=1:2
                for cc=1:size(SM_UserData.lh2,2)
                    if ishandle(SM_UserData.lh2(rc,cc))
                        delete(SM_UserData.lh2(rc,cc))
                    end
                end
            end
            SM_UserData.lh2=[];
        end
        SM_UserData.cm=[];
        SM_UserData.um=[];
        set(SM_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
        set(SM_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SM_UserData.spike_lh{trac},'ButtonDownFcn','','UIContextMenu',[])
        end
        set(SM_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])
        set(SM_UserData.tx,'str','');
        set(SM_UserData.fh,'Userdata',[])
        delete(SM_fig)
        set(handles.figure1,'Visible','on')
    end

end
