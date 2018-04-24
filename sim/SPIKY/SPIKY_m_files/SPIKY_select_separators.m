% This function provides an input mask (for keyboard and mouse) for selecting thick and thin spike train separators
% (lines dividing the spike trains).

function SPIKY_select_separators(hObject, eventdata, handles)

set(handles.figure1,'Visible','off')

d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
p_para=getappdata(handles.figure1,'plot_parameters');
s_para=getappdata(handles.figure1,'subplot_parameters');

SS_fig=figure('units','normalized','menubar','none','position',[0.05 0.17 0.4 0.66],'Name','Select thick and thin separators',...
    'NumberTitle','off','Color',[0.9294 0.9176 0.851],'DeleteFcn',{@SS_Close_callback}); % ,'WindowStyle','modal'

SS1_panel=uipanel('units','normalized','position',[0.05 0.56 0.9 0.38],'Title','Thick separators','FontSize',15,...
    'FontWeight','bold','HighlightColor','k');
SS1_edit=uicontrol('style','edit','units','normalized','position',[0.08 0.8 0.84 0.06],...
    'FontSize',15,'FontUnits','normalized','BackgroundColor','w');
SS1_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.15 0.69 0.2 0.05],'string','Cancel',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SS1_callback});
SS1_Reset_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.4 0.69 0.2 0.05],'string','Reset',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SS1_callback});
SS1_Apply_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.69 0.2 0.05],'string','Apply',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SS1_callback});
SS1_Load_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.2 0.6 0.25 0.05],'string','Load from file',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SS1_Load_separators});
SS1_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.6 0.25 0.05],'string','OK',...
    'FontSize',15,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SS1_callback});
uicontrol(SS1_OK_pushbutton)

SS2_panel=uipanel('units','normalized','position',[0.05 0.06 0.9 0.38],'Title','Thin separators','FontSize',15,...
    'FontWeight','bold','HighlightColor','k','Visible','off');
SS2_edit=uicontrol('style','edit','units','normalized','position',[0.08 0.3 0.84 0.06],...
    'FontSize',15,'FontUnits','normalized','BackgroundColor','w','Visible','off');
SS2_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.15 0.19 0.2 0.05],'string','Cancel',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SS2_callback},'Visible','off');
SS2_Reset_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.4 0.19 0.2 0.05],'string','Reset',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SS2_callback},'Visible','off');
SS2_Apply_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.65 0.19 0.2 0.05],'string','Apply',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SS2_callback},'Visible','off');
SS2_Load_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.2 0.1 0.25 0.05],'string','Load from file',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SS2_Load_separators},'Visible','off');
SS2_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.55 0.1 0.25 0.05],'string','OK',...
    'FontSize',15,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SS2_callback},...
    'Visible','off');
uicontrol(SS2_OK_pushbutton)

figure(f_para.num_fig);
SS1_UserData.fh=gcf;
SS1_UserData.ah=gca;
set(SS1_UserData.fh,'Units','Normalized')
SS1_UserData.num_trains=d_para.num_trains;
SS1_UserData.xlim=xlim;
SS1_UserData.tmin=d_para.tmin;
SS1_UserData.tmax=d_para.tmax;
SS1_UserData.flag=0;
SS1_UserData.marked_indy=[];

if isfield(d_para,'thick_separators')
    if ~isempty(d_para.thick_separators)
        thick_sep_lh=getappdata(handles.figure1,'thick_sep_lh');
        for lhc=1:length(thick_sep_lh)
            set(thick_sep_lh,'Visible','off')
        end
    end
    set(SS1_edit,'String',regexprep(num2str(d_para.thick_separators),'\s+',' '))
    SS1_UserData.lh=zeros(1,length(d_para.thick_separators));
    for lhc=1:length(d_para.thick_separators)
        SS1_UserData.lh(lhc)=line([SS1_UserData.tmin SS1_UserData.tmax],(0.05+((SS1_UserData.num_trains-d_para.thick_separators(lhc))/SS1_UserData.num_trains))*ones(1,2),...
            'Color',p_para.thick_sep_col,'LineStyle',p_para.thick_sep_ls,'LineWidth',p_para.thick_sep_lw);
    end
    SS1_UserData.thick_separators=d_para.thick_separators;
else
    SS1_UserData.thick_separators=[];
end
if isfield(d_para,'thin_separators') && ~isempty(d_para.thin_separators)
    thin_sep_lh=getappdata(handles.figure1,'thin_sep_lh');
    for lhc=1:length(thin_sep_lh)
        set(thin_sep_lh,'Visible','off')
    end
end
SS1_UserData.tx=uicontrol('style','tex','String','','unit','normalized','backg',get(SS1_UserData.fh,'Color'),...
    'position',[0.36 0.907 0.4 0.04],'FontSize',18,'FontWeight','bold','HorizontalAlignment','left');
SS1_UserData.spike_lh=getappdata(handles.figure1,'spike_lh');
SS1_UserData.image_mh=getappdata(handles.figure1,'image_mh');

set(SS1_UserData.fh,'Userdata',SS1_UserData)
SS1_UserData.cm=uicontextmenu;
SS1_UserData.um=uimenu(SS1_UserData.cm,'label','Delete thick separator(s)','CallBack',{@SS1_delete_thick_separators,SS1_UserData});
set(SS1_UserData.fh,'WindowButtonMotionFcn',{@SS1_get_coordinates,SS1_UserData},'KeyPressFcn',{@SS1_keyboard,SS1_UserData});
set(SS1_UserData.lh,'ButtonDownFcn',{@SS1_start_move_thick_separators,SS1_UserData},'UIContextMenu',SS1_UserData.cm)
set(SS1_UserData.ah,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
for trac=1:d_para.num_trains
    set(SS1_UserData.spike_lh{trac},'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
end
set(SS1_UserData.image_mh,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
set(SS1_UserData.fh,'Userdata',SS1_UserData)

    function SS1_get_coordinates(varargin)
        SS1_UserData=varargin{3};
        SS1_UserData=get(SS1_UserData.fh,'UserData');

        ax_pos=get(SS1_UserData.ah,'CurrentPoint');
        ax_x_ok=SS1_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SS1_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        if ax_x_ok && ax_y_ok
            ax_y=SS1_UserData.num_trains-round((ax_pos(1,2)-0.05)*SS1_UserData.num_trains);
            ax_y(ax_y==0 && ax_y_ok)=1;
            ax_y(ax_y==SS1_UserData.num_trains && ax_y_ok)=SS1_UserData.num_trains-1;            
            set(SS1_UserData.tx,'str',['After spike train: ',num2str(ax_y)]);
        else
            set(SS1_UserData.tx,'str','Out of range');
        end
    end


    function SS1_pick_thick_separators(varargin)                                   % SS1_marked_indy changes
        SS1_UserData=varargin{3};
        SS1_UserData=get(SS1_UserData.fh,'UserData');

        ax_pos=get(SS1_UserData.ah,'CurrentPoint');
        ax_x_ok=SS1_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SS1_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;
        ax_y=SS1_UserData.num_trains-round((ax_pos(1,2)-0.05)*SS1_UserData.num_trains);
        ax_y(ax_y==0 && ax_y_ok)=1;
        ax_y(ax_y==SS1_UserData.num_trains && ax_y_ok)=SS1_UserData.num_trains-1;

        modifiers=get(SS1_UserData.fh,'CurrentModifier');
        if ax_x_ok && ax_y_ok
            seltype=get(SS1_UserData.fh,'SelectionType');            % Right-or-left click?
            ctrlIsPressed=ismember('control',modifiers);
            if strcmp(seltype,'normal') || ctrlIsPressed                      % right or middle
                if ~isempty(SS1_UserData.thick_separators)
                    num_lh=length(SS1_UserData.thick_separators);
                    for lhc=1:num_lh
                        if ishandle(SS1_UserData.lh(lhc))
                            delete(SS1_UserData.lh(lhc))
                        end
                    end
                    SS1_UserData.thick_separators=unique([SS1_UserData.thick_separators ax_y]);
                else
                    SS1_UserData.thick_separators=ax_y;
                end
                num_lh=length(SS1_UserData.thick_separators);
                SS1_UserData.lh=zeros(1,num_lh);
                for selc=1:num_lh
                    if ismember(selc,SS1_UserData.marked_indy)
                        SS1_UserData.lh(selc)=line([SS1_UserData.tmin SS1_UserData.tmax],(0.05+((SS1_UserData.num_trains-SS1_UserData.thick_separators(selc))/SS1_UserData.num_trains))*ones(1,2),...
                            'Visible',p_para.thick_sep_vis,'Color',p_para.thick_sep_marked_col,'LineStyle',p_para.thick_sep_ls,'LineWidth',p_para.thick_sep_lw);
                    else
                        SS1_UserData.lh(selc)=line([SS1_UserData.tmin SS1_UserData.tmax],(0.05+((SS1_UserData.num_trains-SS1_UserData.thick_separators(selc))/SS1_UserData.num_trains))*ones(1,2),...
                            'Visible',p_para.thick_sep_vis,'Color',p_para.thick_sep_col,'LineStyle',p_para.thick_sep_ls,'LineWidth',p_para.thick_sep_lw);
                    end
                end

                thick_sep_str=num2str(SS1_UserData.thick_separators);
                if length(SS1_UserData.thick_separators)>1
                    thick_sep_str=regexprep(thick_sep_str,'\s+',' ');
                end
                set(SS1_edit,'String',thick_sep_str)
            end

            shftIsPressed=ismember('shift',modifiers);
            if ctrlIsPressed
                if isfield(SS1_UserData,'marked')
                    SS1_UserData.marked=unique([SS1_UserData.marked ax_y]);
                else
                    SS1_UserData.marked=ax_y;
                end
                [dummy,this,dummy2]=intersect(SS1_UserData.thick_separators,SS1_UserData.marked);
                SS1_UserData.marked_indy=this;
                set(SS1_UserData.lh,'Color',p_para.thick_sep_col)
                set(SS1_UserData.lh(SS1_UserData.marked_indy),'Color',p_para.thick_sep_marked_col)
                SS1_UserData.flag=1;
            elseif ~shftIsPressed
                set(SS1_UserData.lh,'Color',p_para.thick_sep_col)
                SS1_UserData.marked=[];
                SS1_UserData.flag=0;
                SS1_UserData.marked_indy=[];
            end
        end

        shftIsPressed=ismember('shift',modifiers);
        dummy_marked=SS1_UserData.marked_indy;
        if shftIsPressed
            set(SS1_UserData.fh,'WindowButtonUpFcn',[])
            ax_pos=get(SS1_UserData.ah,'CurrentPoint');
            first_corner_x=ax_pos(1,1);
            first_corner_y=ax_pos(1,2);
            window=rectangle('Position',[first_corner_x, first_corner_y, 0.01, 0.01]);
            thick_seps=(0.05+((SS1_UserData.num_trains-SS1_UserData.thick_separators)/SS1_UserData.num_trains));
            while shftIsPressed
                ax_pos=get(SS1_UserData.ah,'CurrentPoint');
                second_corner_x=ax_pos(1,1);
                second_corner_y=ax_pos(1,2);
                if second_corner_x ~= first_corner_x && second_corner_y ~= first_corner_y
                    set(window,'Position',[min(first_corner_x, second_corner_x), min(first_corner_y, second_corner_y), abs(second_corner_x-first_corner_x), abs(second_corner_y-first_corner_y)])
                    drawnow
                    bottom_mark=min(first_corner_y, second_corner_y);
                    top_mark=max(first_corner_y, second_corner_y);
                    SS1_UserData.marked_indy=unique([dummy_marked find(thick_seps>=bottom_mark & thick_seps<=top_mark)]);
                    SS1_UserData.flag=(~isempty(SS1_UserData.marked_indy));
                    set(SS1_UserData.lh,'Color',p_para.thick_sep_col)
                    set(SS1_UserData.lh(SS1_UserData.marked_indy),'Color',p_para.thick_sep_marked_col)
                end
                pause(0.001);
                modifiers=get(SS1_UserData.fh,'CurrentModifier');
                shftIsPressed=ismember('shift',modifiers);
            end
            delete(window)
            SS1_UserData.marked=SS1_UserData.thick_separators(SS1_UserData.marked_indy);
        end
        
        %pick_marky=SS1_UserData.marked
        %pick_marky_indy=SS1_UserData.marked_indy

        set(SS1_UserData.fh,'Userdata',SS1_UserData)
        set(SS1_UserData.um,'CallBack',{@SS1_delete_thick_separators,SS1_UserData})
        set(SS1_UserData.fh,'WindowButtonMotionFcn',{@SS1_get_coordinates,SS1_UserData},'KeyPressFcn',{@SS1_keyboard,SS1_UserData})
        set(SS1_UserData.lh,'ButtonDownFcn',{@SS1_start_move_thick_separators,SS1_UserData},'UIContextMenu',SS1_UserData.cm)
        set(SS1_UserData.ah,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SS1_UserData.spike_lh{trac},'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
        end
        set(SS1_UserData.image_mh,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
        set(SS1_UserData.fh,'Userdata',SS1_UserData)
    end


    function SS1_delete_thick_separators(varargin)
        SS1_UserData=varargin{3};
        SS1_UserData=get(SS1_UserData.fh,'UserData');
        
        delete_marky=SS1_UserData.marked
        delete_marky_indy=SS1_UserData.marked_indy

        if (SS1_UserData.flag)
            SS1_UserData.thick_separators=setdiff(SS1_UserData.thick_separators,SS1_UserData.thick_separators(SS1_UserData.marked_indy));
            SS1_UserData.marked_indy=[];
            SS1_UserData.flag=0;
        else
            ax_y=get(gco,'YData');
            SS1_UserData.thick_separators=setdiff(SS1_UserData.thick_separators,SS1_UserData.num_trains-ceil((ax_y(1)-0.05)*SS1_UserData.num_trains));
        end
        for lhc=1:length(SS1_UserData.lh)
            if ishandle(SS1_UserData.lh(lhc))
                delete(SS1_UserData.lh(lhc))
            end
        end
        num_lh=length(SS1_UserData.thick_separators);
        SS1_UserData.lh=zeros(1,num_lh);
        for selc=1:num_lh
            SS1_UserData.lh(selc)=line([SS1_UserData.tmin SS1_UserData.tmax],(0.05+((SS1_UserData.num_trains-SS1_UserData.thick_separators(selc))/SS1_UserData.num_trains))*ones(1,2),...
                'Visible',p_para.thick_sep_vis,'Color',p_para.thick_sep_col,'LineStyle',p_para.thick_sep_ls,'LineWidth',p_para.thick_sep_lw);
        end
        thick_sep_str=num2str(SS1_UserData.thick_separators);
        if num_lh>1
            thick_sep_str=regexprep(thick_sep_str,'\s+',' ');
        end
        set(SS1_edit,'String',thick_sep_str)

        set(SS1_UserData.fh,'Userdata',SS1_UserData)
        set(SS1_UserData.um,'CallBack',{@SS1_delete_thick_separators,SS1_UserData})
        set(SS1_UserData.fh,'WindowButtonMotionFcn',{@SS1_get_coordinates,SS1_UserData},'KeyPressFcn',{@SS1_keyboard,SS1_UserData})
        set(SS1_UserData.lh,'ButtonDownFcn',{@SS1_start_move_thick_separators,SS1_UserData},'UIContextMenu',SS1_UserData.cm)
        set(SS1_UserData.ah,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SS1_UserData.spike_lh{trac},'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
        end
        set(SS1_UserData.image_mh,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
        set(SS1_UserData.fh,'Userdata',SS1_UserData)
    end


    function SS1_start_move_thick_separators(varargin)
        SS1_UserData=varargin{3};
        SS1_UserData=get(SS1_UserData.fh,'UserData');

        seltype=get(SS1_UserData.fh,'SelectionType'); % Right-or-left click?
        ax_pos=get(SS1_UserData.ah,'CurrentPoint');
        if strcmp(seltype,'alt')
            modifiers=get(SS1_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                ax_y=get(gco,'YData');

                if isfield(SS1_UserData,'marked')
                    SS1_UserData.marked=unique([SS1_UserData.marked ax_y]);
                else
                    SS1_UserData.marked=ax_y;
                end
                [dummy,this,dummy2]=intersect(SS1_UserData.thick_separators,SS1_UserData.marked);
                SS1_UserData.marked_indy=this;
                if ~SS1_UserData.flag
                    SS1_UserData.flag=1;
                end
                set(gco,'Color',p_para.thick_sep_marked_col);

                set(SS1_UserData.fh,'Userdata',SS1_UserData)
                set(SS1_UserData.um,'CallBack',{@SS1_delete_thick_separators,SS1_UserData})
                set(SS1_UserData.fh,'WindowButtonMotionFcn',{@SS1_get_coordinates,SS1_UserData},'KeyPressFcn',{@SS1_keyboard,SS1_UserData})
                set(SS1_UserData.lh,'ButtonDownFcn',{@SS1_start_move_thick_separators,SS1_UserData},'UIContextMenu',SS1_UserData.cm)
                set(SS1_UserData.ah,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SS1_UserData.spike_lh{trac},'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                end
                set(SS1_UserData.image_mh,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                set(SS1_UserData.fh,'Userdata',SS1_UserData)
            end
        else
            if ~SS1_UserData.flag
                num_lh=length(SS1_UserData.thick_separators);
                for selc=1:num_lh
                    set(SS1_UserData.lh(selc),'Color',p_para.thick_sep_col);
                end
                SS1_UserData.marked_indy=find(SS1_UserData.lh(:) == gco);
                dummy=get(gco,'YData');
                SS1_UserData.initial_ST=SS1_UserData.num_trains-floor((dummy(1)-0.05)*SS1_UserData.num_trains);
                SS1_UserData.initial_YPos=SS1_UserData.initial_ST;
            else
                %SS1_UserData.initial_YPos=SS1_UserData.num_trains-floor((ax_pos(1,2)-0.05)*SS1_UserData.num_trains);
                SS1_UserData.initial_ST=SS1_UserData.thick_separators(SS1_UserData.marked_indy);
                SS1_UserData.initial_YPos=SS1_UserData.initial_ST(1);
            end
            set(SS1_UserData.fh,'WindowButtonMotionFcn',{@SS1_move_thick_separators,SS1_UserData})
            set(SS1_UserData.ah,'ButtonDownFcn','')
            for trac=1:d_para.num_trains
                set(SS1_UserData.spike_lh{trac},'ButtonDownFcn','')
            end
            set(SS1_UserData.image_mh,'ButtonDownFcn','')
            set(SS1_UserData.fh,'Userdata',SS1_UserData)
        end

        start_move_initial_YPos=SS1_UserData.initial_YPos
        start_move_initial_ST=SS1_UserData.initial_ST
        
    end


    function SS1_move_thick_separators(varargin)
        SS1_UserData=varargin{3};
        SS1_UserData=get(SS1_UserData.fh,'UserData');

        ax_pos=get(SS1_UserData.ah,'CurrentPoint');
        ax_x_ok=SS1_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SS1_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;
        
        ax_y=SS1_UserData.num_trains-round((ax_pos(1,2)-0.05)*SS1_UserData.num_trains);
        ax_y(ax_y==0 && ax_y_ok)=1;
        ax_y(ax_y==SS1_UserData.num_trains && ax_y_ok)=SS1_UserData.num_trains-1;
        
        for idx=1:length(SS1_UserData.marked_indy)
            if SS1_UserData.initial_ST(idx)+ax_y-SS1_UserData.initial_YPos>0 && ...
                    SS1_UserData.initial_ST(idx)+ax_y-SS1_UserData.initial_YPos<SS1_UserData.num_trains
                set(SS1_UserData.lh(SS1_UserData.marked_indy(idx)),'Color',p_para.thick_sep_marked_col,...
                    'YData',(0.05+((SS1_UserData.num_trains-(SS1_UserData.initial_ST(idx)+ax_y-SS1_UserData.initial_YPos))/...
                    SS1_UserData.num_trains))*ones(1,2),'LineWidth',2)
            else
                set(SS1_UserData.lh(SS1_UserData.marked_indy(idx)),'YData',(0.05+((SS1_UserData.num_trains-(SS1_UserData.initial_ST(idx)+ax_y-SS1_UserData.initial_YPos))/...
                    SS1_UserData.num_trains))*ones(1,2),'Color','w')
            end
        end
        drawnow;

        if ax_x_ok && ax_y_ok
            %set(SS1_UserData.tx,'str',['After spike train: ',num2str(ax_y)]);
            ax_y(ax_y==0 && ax_y_ok)=1;
            ax_y(ax_y==SS1_UserData.num_trains && ax_y_ok)=SS1_UserData.num_trains-1;
            set(SS1_UserData.tx,'str',['After spike train: ',num2str(ax_y)]);
        else
            set(SS1_UserData.tx,'str','Out of range');
        end
        set(SS1_UserData.fh,'WindowButtonUpFcn',{@SS1_stop_move_thick_separators,SS1_UserData})
        set(SS1_UserData.fh,'Userdata',SS1_UserData)
    end


    function SS1_stop_move_thick_separators(varargin)
        SS1_UserData=varargin{3};
        SS1_UserData=get(SS1_UserData.fh,'UserData');

        ax_pos=get(SS1_UserData.ah,'CurrentPoint');
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        ax_y=SS1_UserData.num_trains-round((ax_pos(1,2)-0.05)*SS1_UserData.num_trains);
        ax_y(ax_y==0 && ax_y_ok)=1;
        ax_y(ax_y==SS1_UserData.num_trains && ax_y_ok)=SS1_UserData.num_trains-1;

        for idx=1:length(SS1_UserData.marked_indy)
            if SS1_UserData.initial_ST(idx)+ax_y-SS1_UserData.initial_YPos>0 && ...
                    SS1_UserData.initial_ST(idx)+ax_y-SS1_UserData.initial_YPos<SS1_UserData.num_trains
                SS1_UserData.thick_separators(SS1_UserData.marked_indy(idx))=SS1_UserData.initial_ST(idx)+ax_y-SS1_UserData.initial_YPos;
            else
                SS1_UserData.thick_separators=SS1_UserData.thick_separators(setdiff(1:length(SS1_UserData.thick_separators),SS1_UserData.marked_indy(idx)));
                SS1_UserData.marked_indy(idx+1:end)=SS1_UserData.marked_indy(idx+1:end)-1;
            end
        end
        SS1_UserData.thick_separators=unique(SS1_UserData.thick_separators);
        SS1_UserData.marked_indy=[];
        SS1_UserData.flag=0;
        for lhc=1:size(SS1_UserData.lh,2)
            if ishandle(SS1_UserData.lh(lhc))
                delete(SS1_UserData.lh(lhc))
            end
        end
        num_lh=length(SS1_UserData.thick_separators);
        SS1_UserData.lh=zeros(1,num_lh);
        for selc=1:num_lh
            SS1_UserData.lh(selc)=line([SS1_UserData.tmin SS1_UserData.tmax],(0.05+((SS1_UserData.num_trains-SS1_UserData.thick_separators(selc))/SS1_UserData.num_trains))*ones(1,2),...
                'Visible',p_para.thick_sep_vis,'Color',p_para.thick_sep_col,'LineStyle',p_para.thick_sep_ls,'LineWidth',p_para.thick_sep_lw);
        end
        thick_sep_str=num2str(SS1_UserData.thick_separators);
        if num_lh>1
            thick_sep_str=regexprep(thick_sep_str,'\s+',' ');
        end
        set(SS1_edit,'String',thick_sep_str)
        set(SS1_UserData.fh,'Pointer','arrow')
        drawnow;

        set(SS1_UserData.fh,'Userdata',SS1_UserData)
        set(SS1_UserData.um,'CallBack',{@SS1_delete_thick_separators,SS1_UserData})
        set(SS1_UserData.fh,'WindowButtonMotionFcn',{@SS1_get_coordinates,SS1_UserData},'KeyPressFcn',{@SS1_keyboard,SS1_UserData},...
            'WindowButtonUpFcn',[])
        set(SS1_UserData.lh,'ButtonDownFcn',{@SS1_start_move_thick_separators,SS1_UserData},'UIContextMenu',SS1_UserData.cm)
        set(SS1_UserData.ah,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SS1_UserData.spike_lh{trac},'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
        end
        set(SS1_UserData.image_mh,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
        set(SS1_UserData.fh,'Userdata',SS1_UserData)
    end


    function SS1_keyboard(varargin)
        SS1_UserData=varargin{3};
        SS1_UserData=get(SS1_UserData.fh,'UserData');

        if strcmp(varargin{2}.Key,'delete')
            if (SS1_UserData.flag)
                SS1_UserData.thick_separators=setdiff(SS1_UserData.thick_separators,SS1_UserData.thick_separators(SS1_UserData.marked_indy));
                SS1_UserData.marked_indy=[];
                SS1_UserData.flag=0;
                for lhc=1:length(SS1_UserData.lh)
                    if ishandle(SS1_UserData.lh(lhc))
                        delete(SS1_UserData.lh(lhc))
                    end
                end
                num_lh=length(SS1_UserData.thick_separators);
                SS1_UserData.lh=zeros(1,num_lh);
                for selc=1:num_lh
                    SS1_UserData.lh(selc)=line([SS1_UserData.tmin SS1_UserData.tmax],(0.05+((SS1_UserData.num_trains-SS1_UserData.thick_separators(selc))/SS1_UserData.num_trains))*ones(1,2),...
                        'Visible',p_para.thick_sep_vis,'Color',p_para.thick_sep_col,'LineStyle',p_para.thick_sep_ls,'LineWidth',p_para.thick_sep_lw);
                end
                thick_sep_str=num2str(SS1_UserData.thick_separators);
                if num_lh>1
                    thick_sep_str=regexprep(thick_sep_str,'\s+',' ');
                end
                set(SS1_edit,'String',thick_sep_str)

                set(SS1_UserData.fh,'Userdata',SS1_UserData)
                set(SS1_UserData.um,'CallBack',{@SS1_delete_thick_separators,SS1_UserData})
                set(SS1_UserData.fh,'WindowButtonMotionFcn',{@SS1_get_coordinates,SS1_UserData},'KeyPressFcn',{@SS1_keyboard,SS1_UserData})
                set(SS1_UserData.lh,'ButtonDownFcn',{@SS1_start_move_thick_separators,SS1_UserData},'UIContextMenu',SS1_UserData.cm)
                set(SS1_UserData.ah,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SS1_UserData.spike_lh{trac},'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                end
                set(SS1_UserData.image_mh,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                set(SS1_UserData.fh,'Userdata',SS1_UserData)
            end
        elseif strcmp(varargin{2}.Key,'a')
            modifiers=get(SS1_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                num_lh=length(SS1_UserData.thick_separators);
                SS1_UserData.marked=SS1_UserData.thick_separators;
                SS1_UserData.marked_indy=1:num_lh;
                for selc=1:num_lh
                    set(SS1_UserData.lh(selc),'Color',p_para.thick_sep_marked_col);
                end
                SS1_UserData.flag=1;

                set(SS1_UserData.fh,'Userdata',SS1_UserData)
                set(SS1_UserData.um,'CallBack',{@SS1_delete_thick_separators,SS1_UserData})
                set(SS1_UserData.fh,'WindowButtonMotionFcn',{@SS1_get_coordinates,SS1_UserData},'KeyPressFcn',{@SS1_keyboard,SS1_UserData})
                set(SS1_UserData.lh,'ButtonDownFcn',{@SS1_start_move_thick_separators,SS1_UserData},'UIContextMenu',SS1_UserData.cm)
                set(SS1_UserData.ah,'ButtonDownFcn',{@SS1_start_pick,SS1_UserData})
                for trac=1:d_para.num_trains
                    set(SS1_UserData.spike_lh{trac},'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                end
                set(SS1_UserData.image_mh,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                set(SS1_UserData.fh,'Userdata',SS1_UserData)
            end
        elseif strcmp(varargin{2}.Key,'c')
            modifiers=get(SS1_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                num_lh=length(SS1_UserData.thick_separators);
                ax_y=SS1_UserData.thick_separators(SS1_UserData.marked_indy);
                for idx=1:length(SS1_UserData.marked_indy)
                    SS1_UserData.lh(num_lh+idx)=line([SS1_UserData.tmin SS1_UserData.tmax],(0.05+((SS1_UserData.num_trains-SS1_UserData.thick_separators(SS1_UserData.marked_indy(idx)))/SS1_UserData.num_trains))*ones(1,2),...
                        'Visible',p_para.thick_sep_vis,'Color',p_para.thick_sep_marked_col,'LineStyle',p_para.thick_sep_ls,'LineWidth',p_para.thick_sep_lw);
                end
                SS1_UserData.marked=SS1_UserData.thick_separators(SS1_UserData.marked_indy);
                SS1_UserData.marked_indy=num_lh+(1:length(SS1_UserData.marked_indy));
                SS1_UserData.thick_separators(SS1_UserData.marked_indy)=SS1_UserData.marked;
                SS1_UserData.flag=1;
                ax_pos=get(SS1_UserData.ah,'CurrentPoint');
                SS1_UserData.initial_YPos=SS1_UserData.num_trains-floor((ax_pos(1,2)-0.05)*SS1_UserData.num_trains);
                SS1_UserData.initial_ST=ax_y;
                set(SS1_UserData.ah,'ButtonDownFcn','')
                for trac=1:d_para.num_trains
                    set(SS1_UserData.spike_lh{trac},'ButtonDownFcn','')
                end
                set(SS1_UserData.image_mh,'ButtonDownFcn','')
                set(SS1_UserData.fh,'WindowButtonMotionFcn',{@SS1_move_thick_separators,SS1_UserData})
                set(SS1_UserData.fh,'Userdata',SS1_UserData)
            end
        end
    end


    function SS1_Load_separators(varargin)
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
            SS1_UserData=get(f_para.num_fig,'UserData');
            data.matfile=d_para.matfile;
            data.default_variable='';
            data.content='thick separators';
            SPIKY('SPIKY_select_variable',gcbo,data,handles)
            variable=getappdata(handles.figure1,'variable');
            if ~isempty(variable) && ~strcmp(variable,'A9ZB1YC8X')
                data=getappdata(handles.figure1,'data');
                SS1_UserData.thick_separators=squeeze(data.(variable));
            end
            if ~isnumeric(SS1_UserData.thick_separators) || ndims(SS1_UserData.thick_separators)~=2 || ~any(size(SS1_UserData.thick_separators)==1)
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
            if size(SS1_UserData.thick_separators,2)<size(SS1_UserData.thick_separators,1)
                SS1_UserData.thick_separators=SS1_UserData.thick_separators';
            end
            thick_sep_str=num2str(SS1_UserData.thick_separators);
            if length(SS1_UserData.thick_separators)>1
                thick_sep_str=regexprep(thick_sep_str,'\s+',' ');
            end
            set(SS1_edit,'String',thick_sep_str)
            set(SS1_UserData.fh,'Userdata',SS1_UserData)
        end
    end


    function SS1_callback(varargin)
        d_para=getappdata(handles.figure1,'data_parameters');
        f_para=getappdata(handles.figure1,'figure_parameters');
        figure(f_para.num_fig);
        SS1_UserData=get(gcf,'Userdata');

        if gcbo==SS1_Reset_pushbutton || gcbo==SS1_Cancel_pushbutton || gcbo==SS_fig
            if isfield(SS1_UserData,'lh')
                for rc=1:size(SS1_UserData.lh,1)
                    for lhc=1:size(SS1_UserData.lh,2)
                        if ishandle(SS1_UserData.lh(lhc))
                            delete(SS1_UserData.lh(lhc))
                        end
                    end
                end
                SS1_UserData.lh=[];
            end
            if isfield(SS1_UserData,'thick_separators')
                SS1_UserData.thick_separators=[];
            end
            d_para.thick_separators=[];
            set(SS1_edit,'string',[])
            if gcbo==SS1_Reset_pushbutton
                set(SS1_UserData.fh,'Userdata',SS1_UserData)
                set(SS1_UserData.um,'CallBack',{@SS1_delete_thick_separators,SS1_UserData})
                set(SS1_UserData.fh,'WindowButtonMotionFcn',{@SS1_get_coordinates,SS1_UserData},'KeyPressFcn',{@SS1_keyboard,SS1_UserData})
                set(SS1_UserData.lh,'ButtonDownFcn',{@SS1_start_move_thick_separators,SS1_UserData},'UIContextMenu',SS1_UserData.cm)
                set(SS1_UserData.ah,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SS1_UserData.spike_lh{trac},'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                end
                set(SS1_UserData.image_mh,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                set(SS1_UserData.fh,'Userdata',SS1_UserData)
            elseif gcbo==SS1_Cancel_pushbutton || gcbo==SS_fig
                SS1_UserData.cm=[];
                SS1_UserData.um=[];
                set(SS1_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
                set(SS1_UserData.lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SS1_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SS1_UserData.spike_lh{trac},'ButtonDownFcn',[],'UIContextMenu',[])
                end
                set(SS1_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SS1_UserData.fh,'Userdata',SS1_UserData)
                delete(SS_fig)
                set(handles.figure1,'Visible','on')
            end
        elseif gcbo==SS1_OK_pushbutton || gcbo==SS1_Apply_pushbutton
            thick_separators_str_in=regexprep(get(SS1_edit,'String'),'\s+',' ');
            thick_separators=unique(str2num(regexprep(thick_separators_str_in,f_para.regexp_str_vector_integers,'')));
            thick_separators=thick_separators(thick_separators>0 & thick_separators<d_para.num_trains);
            thick_separators_str_out=regexprep(num2str(thick_separators),'\s+',' ');
            if ~strcmp(thick_separators_str_in,thick_separators_str_out)
                if ~isempty(thick_separators_str_out)
                    set(SS1_edit,'String',thick_separators_str_out)
                else
                    set(SS1_edit,'String',regexprep(num2str(d_para.thick_separators),'\s+',' '))
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
            SS1_UserData.thick_separators=unique(str2num(get(SS1_edit,'String')));
            delete(SS1_UserData.lh)
            SS1_UserData=rmfield(SS1_UserData,'lh');

            figure(f_para.num_fig);
            thick_sep_cmenu=uicontextmenu;
            SS1_UserData.lh=zeros(1,length(SS1_UserData.thick_separators));
            for lhc=1:length(SS1_UserData.thick_separators)
                SS1_UserData.lh(lhc)=line([SS1_UserData.tmin SS1_UserData.tmax],(0.05+((SS1_UserData.num_trains-SS1_UserData.thick_separators(lhc))/SS1_UserData.num_trains))*ones(1,2),...
                    'Color',p_para.thick_sep_col,'LineStyle',p_para.thick_sep_ls,'LineWidth',p_para.thick_sep_lw,'UIContextMenu',thick_sep_cmenu);
            end
            set(SS1_UserData.fh,'Userdata',SS1_UserData)

            if gcbo==SS1_Apply_pushbutton
                set(SS1_UserData.fh,'Userdata',SS1_UserData)
                set(SS1_UserData.um,'CallBack',{@SS1_delete_thick_separators,SS1_UserData})
                set(SS1_UserData.fh,'WindowButtonMotionFcn',{@SS1_get_coordinates,SS1_UserData},'KeyPressFcn',{@SS1_keyboard,SS1_UserData})
                set(SS1_UserData.lh,'ButtonDownFcn',{@SS1_start_move_thick_separators,SS1_UserData},'UIContextMenu',SS1_UserData.cm)
                set(SS1_UserData.ah,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SS1_UserData.spike_lh{trac},'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                end
                set(SS1_UserData.image_mh,'ButtonDownFcn',{@SS1_pick_thick_separators,SS1_UserData},'UIContextMenu',[])
                set(SS1_UserData.fh,'Userdata',SS1_UserData)
            else
                set(SS1_edit,'String',num2str(SS1_UserData.thick_separators))
                d_para.thick_separators=unique(SS1_UserData.thick_separators);
                setappdata(handles.figure1,'data_parameters',d_para)

                set(SS1_panel,'HighlightColor','w')
                set(SS1_edit,'Enable','off')
                set(SS1_Cancel_pushbutton,'Enable','off')
                set(SS1_Reset_pushbutton,'Enable','off')
                set(SS1_Apply_pushbutton,'Enable','off')
                set(SS1_Load_pushbutton,'Enable','off')
                set(SS1_OK_pushbutton,'Enable','off')
                if isfield(SS1_UserData,'lh')
                    for lhc=1:length(SS1_UserData.lh)
                        if ishandle(SS1_UserData.lh(lhc))
                            delete(SS1_UserData.lh(lhc))
                        end
                    end
                    SS1_UserData.lh=[];
                end
                SS1_UserData.lh2=zeros(2,length(SS1_UserData.thick_separators));
                for lhc=1:length(SS1_UserData.thick_separators)
                    SS1_UserData.lh2(1,lhc)=line([SS1_UserData.xlim(1) SS1_UserData.tmin],(0.05+((SS1_UserData.num_trains-SS1_UserData.thick_separators(lhc))/SS1_UserData.num_trains))*ones(1,2),'Color',p_para.thick_sep_col,...
                        'LineStyle',p_para.thick_sep_ls,'LineWidth',p_para.thick_sep_lw,'UIContextMenu',thick_sep_cmenu);
                    SS1_UserData.lh2(2,lhc)=line([SS1_UserData.tmax SS1_UserData.xlim(2)],(0.05+((SS1_UserData.num_trains-SS1_UserData.thick_separators(lhc))/SS1_UserData.num_trains))*ones(1,2),'Color',p_para.thick_sep_col,...
                        'LineStyle',p_para.thick_sep_ls,'LineWidth',p_para.thick_sep_lw,'UIContextMenu',thick_sep_cmenu);
                end
                SS1_UserData.marked_indy=[];
                SS1_UserData.flag=0;
                SS1_UserData.cm=[];
                SS1_UserData.um=[];
                set(SS1_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
                set(SS1_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SS1_UserData.lh,'ButtonDownFcn',[],'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SS1_UserData.spike_lh{trac},'ButtonDownFcn',[],'UIContextMenu',[])
                end
                set(SS1_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])

                % ########################################################

                set(SS2_panel,'Visible','on','HighlightColor','k')
                set(SS2_edit,'Visible','on')
                set(SS2_Cancel_pushbutton,'Visible','on')
                set(SS2_Reset_pushbutton,'Visible','on')
                set(SS2_Apply_pushbutton,'Visible','on')
                set(SS2_Load_pushbutton,'Visible','on')
                set(SS2_OK_pushbutton,'Visible','on','FontWeight','bold')
                uicontrol(SS2_OK_pushbutton)
                SS2_UserData=SS1_UserData;

                figure(f_para.num_fig);
                if isfield(d_para,'thin_separators')
                    SS2_UserData.thin_separators=d_para.thin_separators;
                    set(SS2_edit,'String',regexprep(num2str(SS2_UserData.thin_separators),'\s+',' '))
                    SS2_UserData.lh=zeros(1,length(SS2_UserData.thin_separators));
                    for lhc=1:length(SS2_UserData.thin_separators)
                        SS2_UserData.lh(lhc)=line([SS2_UserData.tmin SS2_UserData.tmax],(0.05+((SS2_UserData.num_trains-SS2_UserData.thin_separators(lhc))/SS2_UserData.num_trains))*ones(1,2),...
                            'Color',p_para.thin_sep_col,'LineStyle',p_para.thin_sep_ls,'LineWidth',p_para.thin_sep_lw);
                    end
                else
                    SS2_UserData.thin_separators=[];                    
                end

                set(SS2_UserData.fh,'Userdata',SS2_UserData)
                SS2_UserData.cm=uicontextmenu;
                SS2_UserData.um=uimenu(SS2_UserData.cm,'label','Delete thin marker(s)','CallBack',{@SS2_delete_thin_separators,SS2_UserData});
                set(SS2_UserData.fh,'WindowButtonMotionFcn',{@SS2_get_coordinates,SS2_UserData},'KeyPressFcn',{@SS2_keyboard,SS2_UserData});
                set(SS2_UserData.lh,'ButtonDownFcn',{@SS2_start_move_thin_separators,SS2_UserData},'UIContextMenu',SS2_UserData.cm)
                set(SS2_UserData.ah,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SS2_UserData.spike_lh{trac},'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                end
                set(SS2_UserData.image_mh,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                set(SS2_UserData.fh,'Userdata',SS2_UserData)
            end
        end
    end


% ########################################################
% ########################################################              SS2
% ########################################################

    function SS2_get_coordinates(varargin)
        SS2_UserData=varargin{3};
        SS2_UserData=get(SS2_UserData.fh,'UserData');

        ax_pos=get(SS2_UserData.ah,'CurrentPoint');
        ax_x_ok=SS2_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SS2_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        if ax_x_ok && ax_y_ok
            ax_y=SS2_UserData.num_trains-round((ax_pos(1,2)-0.05)*SS2_UserData.num_trains);
            ax_y(ax_y==0 && ax_y_ok)=1;
            ax_y(ax_y==SS2_UserData.num_trains && ax_y_ok)=SS2_UserData.num_trains-1;            
            set(SS2_UserData.tx,'str',['After spike train: ',num2str(ax_y)]);
        else
            set(SS2_UserData.tx,'str','Out of range');
        end
    end


    function SS2_pick_thin_separators(varargin)                                   % SS2_marked_indy changes
        SS2_UserData=varargin{3};
        SS2_UserData=get(SS2_UserData.fh,'UserData');

        ax_pos=get(SS2_UserData.ah,'CurrentPoint');
        ax_x_ok=SS2_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SS2_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;
        
        ax_y=SS2_UserData.num_trains-round((ax_pos(1,2)-0.05)*SS2_UserData.num_trains);
        ax_y(ax_y==0 && ax_y_ok)=1;
        ax_y(ax_y==SS2_UserData.num_trains && ax_y_ok)=SS2_UserData.num_trains-1;
        
        modifiers=get(SS2_UserData.fh,'CurrentModifier');
        if ax_x_ok && ax_y_ok
            seltype=get(SS2_UserData.fh,'SelectionType');            % Right-or-left click?
            ctrlIsPressed=ismember('control',modifiers);
            if strcmp(seltype,'normal') || ctrlIsPressed                      % right or middle
                if ~isempty(SS2_UserData.thin_separators)
                    num_lh=length(SS2_UserData.thin_separators);
                    for lhc=1:num_lh
                        if ishandle(SS2_UserData.lh(lhc))
                            delete(SS2_UserData.lh(lhc))
                        end
                    end
                    SS2_UserData.thin_separators=unique([SS2_UserData.thin_separators ax_y]);
                else
                    SS2_UserData.thin_separators=ax_y;
                end
                num_lh=length(SS2_UserData.thin_separators);
                SS2_UserData.lh=zeros(1,num_lh);
                for selc=1:num_lh
                    if ismember(selc,SS2_UserData.marked_indy)
                        SS2_UserData.lh(selc)=line([SS2_UserData.tmin SS2_UserData.tmax],(0.05+((SS2_UserData.num_trains-SS2_UserData.thin_separators(selc))/SS2_UserData.num_trains))*ones(1,2),...
                            'Visible',p_para.thin_sep_vis,'Color',p_para.thin_sep_marked_col,'LineStyle',p_para.thin_sep_ls,'LineWidth',p_para.thin_sep_lw);
                    else
                        SS2_UserData.lh(selc)=line([SS2_UserData.tmin SS2_UserData.tmax],(0.05+((SS2_UserData.num_trains-SS2_UserData.thin_separators(selc))/SS2_UserData.num_trains))*ones(1,2),...
                            'Visible',p_para.thin_sep_vis,'Color',p_para.thin_sep_col,'LineStyle',p_para.thin_sep_ls,'LineWidth',p_para.thin_sep_lw);
                    end
                end
                thin_sep_str=num2str(SS2_UserData.thin_separators);
                if num_lh>1
                    thin_sep_str=regexprep(thin_sep_str,'\s+',' ');
                end
                set(SS2_edit,'String',thin_sep_str)
            end

            shftIsPressed=ismember('shift',modifiers);
            if ctrlIsPressed
                if isfield(SS2_UserData,'marked')
                    SS2_UserData.marked=unique([SS2_UserData.marked ax_y]);
                else
                    SS2_UserData.marked=ax_y;
                end
                [dummy,this,dummy2]=intersect(SS2_UserData.thin_separators,SS2_UserData.marked);
                SS2_UserData.marked_indy=this;
                set(SS2_UserData.lh,'Color',p_para.thin_sep_col)
                set(SS2_UserData.lh(SS2_UserData.marked_indy),'Color',p_para.thin_sep_marked_col)
                SS2_UserData.flag=1;
            elseif ~shftIsPressed
                set(SS2_UserData.lh,'Color',p_para.thin_sep_col)
                SS2_UserData.marked=[];
                SS2_UserData.flag=0;
                SS2_UserData.marked_indy=[];
            end
        end

        dummy_marked=SS2_UserData.marked_indy;
        if shftIsPressed
            set(SS2_UserData.fh,'WindowButtonUpFcn',[])
            ax_pos=get(SS2_UserData.ah,'CurrentPoint');
            first_corner_x=ax_pos(1,1);
            first_corner_y=ax_pos(1,2);
            window=rectangle('Position',[first_corner_x, first_corner_y, 0.01, 0.01]);
            thin_seps=(0.05+((SS2_UserData.num_trains-SS2_UserData.thin_separators)/SS2_UserData.num_trains));
            while shftIsPressed
                ax_pos=get(SS2_UserData.ah,'CurrentPoint');
                second_corner_x=ax_pos(1,1);
                second_corner_y=ax_pos(1,2);
                if second_corner_x ~= first_corner_x && second_corner_y ~= first_corner_y
                    set(window,'Position',[min(first_corner_x, second_corner_x), min(first_corner_y, second_corner_y), abs(second_corner_x-first_corner_x), abs(second_corner_y-first_corner_y)])
                    drawnow
                    bottom_mark=min(first_corner_y, second_corner_y);
                    top_mark=max(first_corner_y, second_corner_y);
                    SS2_UserData.marked_indy=unique([dummy_marked find(thin_seps>=bottom_mark & thin_seps<=top_mark)]);
                    SS2_UserData.flag=(~isempty(SS2_UserData.marked_indy));
                    set(SS2_UserData.lh,'Color',p_para.thin_sep_col)
                    set(SS2_UserData.lh(SS2_UserData.marked_indy),'Color',p_para.thin_sep_marked_col)
                end
                pause(0.001);
                modifiers=get(SS2_UserData.fh,'CurrentModifier');
                shftIsPressed=ismember('shift',modifiers);
            end
            delete(window)
            SS2_UserData.marked=SS2_UserData.thin_separators(SS2_UserData.marked_indy);
        end

        set(SS2_UserData.fh,'Userdata',SS2_UserData)
        set(SS2_UserData.um,'CallBack',{@SS2_delete_thin_separators,SS2_UserData})
        set(SS2_UserData.fh,'WindowButtonMotionFcn',{@SS2_get_coordinates,SS2_UserData},'KeyPressFcn',{@SS2_keyboard,SS2_UserData})
        set(SS2_UserData.lh,'ButtonDownFcn',{@SS2_start_move_thin_separators,SS2_UserData},'UIContextMenu',SS2_UserData.cm)
        set(SS2_UserData.ah,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SS2_UserData.spike_lh{trac},'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
        end
        set(SS2_UserData.image_mh,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
        set(SS2_UserData.fh,'Userdata',SS2_UserData)
    end


    function SS2_delete_thin_separators(varargin)
        SS2_UserData=varargin{3};
        SS2_UserData=get(SS2_UserData.fh,'UserData');

        if (SS2_UserData.flag)
            SS2_UserData.thin_separators=setdiff(SS2_UserData.thin_separators,SS2_UserData.thin_separators(SS2_UserData.marked_indy));
            SS2_UserData.marked_indy=[];
            SS2_UserData.flag=0;
        else
            ax_y=get(gco,'YData');
            SS2_UserData.thin_separators=setdiff(SS2_UserData.thin_separators,SS2_UserData.num_trains-ceil((ax_y(1)-0.05)*SS2_UserData.num_trains));
        end
        for lhc=1:length(SS2_UserData.lh)
            if ishandle(SS2_UserData.lh(lhc))
                delete(SS2_UserData.lh(lhc))
            end
        end
        num_lh=length(SS2_UserData.thin_separators);
        SS2_UserData.lh=zeros(1,num_lh);
        for selc=1:num_lh
            SS2_UserData.lh(selc)=line([SS2_UserData.tmin SS2_UserData.tmax],(0.05+((SS2_UserData.num_trains-SS2_UserData.thin_separators(selc))/SS2_UserData.num_trains))*ones(1,2),...
                'Visible',p_para.thin_sep_vis,'Color',p_para.thin_sep_col,'LineStyle',p_para.thin_sep_ls,'LineWidth',p_para.thin_sep_lw);
        end
        thin_sep_str=num2str(SS2_UserData.thin_separators);
        if num_lh>1
            thin_sep_str=regexprep(thin_sep_str,'\s+',' ');
        end
        set(SS2_edit,'String',thin_sep_str)

        set(SS2_UserData.fh,'Userdata',SS2_UserData)
        set(SS2_UserData.um,'CallBack',{@SS2_delete_thin_separators,SS2_UserData})
        set(SS2_UserData.fh,'WindowButtonMotionFcn',{@SS2_get_coordinates,SS2_UserData},'KeyPressFcn',{@SS2_keyboard,SS2_UserData})
        set(SS2_UserData.lh,'ButtonDownFcn',{@SS2_start_move_thin_separators,SS2_UserData},'UIContextMenu',SS2_UserData.cm)
        set(SS2_UserData.ah,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SS2_UserData.spike_lh{trac},'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
        end
        set(SS2_UserData.image_mh,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
        set(SS2_UserData.fh,'Userdata',SS2_UserData)
    end


    function SS2_start_move_thin_separators(varargin)
        SS2_UserData=varargin{3};
        SS2_UserData=get(SS2_UserData.fh,'UserData');

        seltype=get(SS2_UserData.fh,'SelectionType'); % Right-or-left click?
        ax_pos=get(SS2_UserData.ah,'CurrentPoint');
        if strcmp(seltype,'alt')
            modifiers=get(SS2_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                ax_y=get(gco,'YData');

                if isfield(SS2_UserData,'marked')
                    SS2_UserData.marked=unique([SS2_UserData.marked ax_y]);
                else
                    SS2_UserData.marked=ax_y;
                end
                [dummy,this,dummy2]=intersect(SS2_UserData.thin_separators,SS2_UserData.marked);
                SS2_UserData.marked_indy=this;
                if ~SS2_UserData.flag
                    SS2_UserData.flag=1;
                end
                set(gco,'Color',p_para.thin_sep_marked_col);

                set(SS2_UserData.fh,'Userdata',SS2_UserData)
                set(SS2_UserData.um,'CallBack',{@SS2_delete_thin_separators,SS2_UserData})
                set(SS2_UserData.fh,'WindowButtonMotionFcn',{@SS2_get_coordinates,SS2_UserData},'KeyPressFcn',{@SS2_keyboard,SS2_UserData})
                set(SS2_UserData.lh,'ButtonDownFcn',{@SS2_start_move_thin_separators,SS2_UserData},'UIContextMenu',SS2_UserData.cm)
                set(SS2_UserData.ah,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SS2_UserData.spike_lh{trac},'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                end
                set(SS2_UserData.image_mh,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                set(SS2_UserData.fh,'Userdata',SS2_UserData)
            end
        else
            if ~SS2_UserData.flag
                num_lh=length(SS2_UserData.thin_separators);
                for selc=1:num_lh
                    set(SS2_UserData.lh(selc),'Color',p_para.thin_sep_col);
                end
                SS2_UserData.marked_indy=find(SS2_UserData.lh(:) == gco);
                SS2_UserData.initial_ST=get(gco,'YData');
                SS2_UserData.initial_YPos=SS2_UserData.initial_ST;
            else
                SS2_UserData.initial_ST=SS2_UserData.thin_separators(SS2_UserData.marked_indy);
                %SS2_UserData.initial_YPos=SS2_UserData.num_trains-floor((ax_pos(1,2)-0.05)*SS2_UserData.num_trains);
                SS2_UserData.initial_YPos=SS2_UserData.initial_ST(1);
            end
            set(SS2_UserData.fh,'WindowButtonMotionFcn',{@SS2_move_thin_separators,SS2_UserData})
            set(SS2_UserData.ah,'ButtonDownFcn','')
            for trac=1:d_para.num_trains
                set(SS2_UserData.spike_lh{trac},'ButtonDownFcn','','UIContextMenu',[])
            end
            set(SS2_UserData.image_mh,'ButtonDownFcn','')
            set(SS2_UserData.fh,'Userdata',SS2_UserData)
        end
    end


    function SS2_move_thin_separators(varargin)
        SS2_UserData=varargin{3};
        SS2_UserData=get(SS2_UserData.fh,'UserData');

        ax_pos=get(SS2_UserData.ah,'CurrentPoint');
        ax_x_ok=SS2_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SS2_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;
        ax_y=SS2_UserData.num_trains-floor((ax_pos(1,2)-0.05)*SS2_UserData.num_trains);
        ax_y(ax_y==0 && ax_y_ok)=1;
        ax_y(ax_y==SS2_UserData.num_trains && ax_y_ok)=SS2_UserData.num_trains-1;
        for idx=1:length(SS2_UserData.marked_indy)
            if SS2_UserData.initial_ST(idx)+ax_y-SS2_UserData.initial_YPos>0 && ...
                    SS2_UserData.initial_ST(idx)+ax_y-SS2_UserData.initial_YPos<SS2_UserData.num_trains
                set(SS2_UserData.lh(SS2_UserData.marked_indy(idx)),'Color',p_para.thin_sep_marked_col,...
                    'YData',(0.05+((SS2_UserData.num_trains-(SS2_UserData.initial_ST(idx)+ax_y-SS2_UserData.initial_YPos))/...
                    SS2_UserData.num_trains))*ones(1,2))
            else
                set(SS2_UserData.lh(SS2_UserData.marked_indy(idx)),'YData',(0.05+((SS2_UserData.num_trains-(SS2_UserData.initial_ST(idx)+ax_y-SS2_UserData.initial_YPos))/...
                    SS2_UserData.num_trains))*ones(1,2),'Color','w')
            end
        end
        drawnow;

        if ax_x_ok && ax_y_ok
            ax_y=SS2_UserData.num_trains-round((ax_pos(1,2)-0.05)*SS2_UserData.num_trains);
            ax_y(ax_y==0 && ax_y_ok)=1;
            ax_y(ax_y==SS2_UserData.num_trains && ax_y_ok)=SS2_UserData.num_trains-1;            
            set(SS2_UserData.tx,'str',['After spike train: ',num2str(ax_y)]);
        else
            set(SS2_UserData.tx,'str','Out of range');
        end
        set(SS2_UserData.fh,'WindowButtonUpFcn',{@SS2_stop_move_thin_separators,SS2_UserData})
        set(SS2_UserData.fh,'Userdata',SS2_UserData)
    end


    function SS2_stop_move_thin_separators(varargin)
        SS2_UserData=varargin{3};
        SS2_UserData=get(SS2_UserData.fh,'UserData');

        ax_pos=get(SS2_UserData.ah,'CurrentPoint');
        ax_y=SS2_UserData.num_trains-floor((ax_pos(1,2)-0.05)*SS2_UserData.num_trains);

        for idx=1:length(SS2_UserData.marked_indy)
            if SS2_UserData.initial_ST(idx)+ax_y-SS2_UserData.initial_YPos>0 && ...
                    SS2_UserData.initial_ST(idx)+ax_y-SS2_UserData.initial_YPos<SS2_UserData.num_trains
                SS2_UserData.thin_separators(SS2_UserData.marked_indy(idx))=SS2_UserData.initial_ST(idx)+ax_y-SS2_UserData.initial_YPos;
            else
                SS2_UserData.thin_separators=SS2_UserData.thin_separators(setdiff(1:length(SS2_UserData.thin_separators),SS2_UserData.marked_indy(idx)));
                SS2_UserData.marked_indy(idx+1:end)=SS2_UserData.marked_indy(idx+1:end)-1;
            end
        end
        SS2_UserData.thin_separators=unique(SS2_UserData.thin_separators);
        SS2_UserData.marked_indy=[];
        SS2_UserData.flag=0;
        for lhc=1:size(SS2_UserData.lh,2)
            if ishandle(SS2_UserData.lh(lhc))
                delete(SS2_UserData.lh(lhc))
            end
        end
        num_lh=length(SS2_UserData.thin_separators);
        SS2_UserData.lh=zeros(1,num_lh);
        for selc=1:num_lh
            SS2_UserData.lh(selc)=line([SS2_UserData.tmin SS2_UserData.tmax],(0.05+((SS2_UserData.num_trains-SS2_UserData.thin_separators(selc))/SS2_UserData.num_trains))*ones(1,2),...
                'Visible',p_para.thin_sep_vis,'Color',p_para.thin_sep_col,'LineStyle',p_para.thin_sep_ls,'LineWidth',p_para.thin_sep_lw);
        end
        thin_sep_str=num2str(SS2_UserData.thin_separators);
        if num_lh>1
            thin_sep_str=regexprep(thin_sep_str,'\s+',' ');
        end
        set(SS2_edit,'String',thin_sep_str)
        set(SS2_UserData.fh,'Pointer','arrow')
        drawnow;

        set(SS2_UserData.fh,'Userdata',SS2_UserData)
        set(SS2_UserData.um,'CallBack',{@SS2_delete_thin_separators,SS2_UserData})
        set(SS2_UserData.fh,'WindowButtonMotionFcn',{@SS2_get_coordinates,SS2_UserData},'KeyPressFcn',{@SS2_keyboard,SS2_UserData},...
            'WindowButtonUpFcn',[])
        set(SS2_UserData.lh,'ButtonDownFcn',{@SS2_start_move_thin_separators,SS2_UserData},'UIContextMenu',SS2_UserData.cm)
        set(SS2_UserData.ah,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SS2_UserData.spike_lh{trac},'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
        end
        set(SS2_UserData.image_mh,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
        set(SS2_UserData.fh,'Userdata',SS2_UserData)
    end


    function SS2_keyboard(varargin)
        SS2_UserData=varargin{3};
        SS2_UserData=get(SS2_UserData.fh,'UserData');

        if strcmp(varargin{2}.Key,'delete')
            if (SS2_UserData.flag)
                SS2_UserData.thin_separators=setdiff(SS2_UserData.thin_separators,SS2_UserData.thin_separators(SS2_UserData.marked_indy));
                SS2_UserData.marked_indy=[];
                SS2_UserData.flag=0;
                for lhc=1:length(SS2_UserData.lh)
                    if ishandle(SS2_UserData.lh(lhc))
                        delete(SS2_UserData.lh(lhc))
                    end
                end
                num_lh=length(SS2_UserData.thin_separators);
                SS2_UserData.lh=zeros(1,num_lh);
                for selc=1:num_lh
                    SS2_UserData.lh(selc)=line([SS2_UserData.tmin SS2_UserData.tmax],(0.05+((SS2_UserData.num_trains-SS2_UserData.thin_separators(selc))/SS2_UserData.num_trains))*ones(1,2),...
                        'Visible',p_para.thin_sep_vis,'Color',p_para.thin_sep_col,'LineStyle',p_para.thin_sep_ls,'LineWidth',p_para.thin_sep_lw);
                end
                thin_sep_str=num2str(SS2_UserData.thin_separators);
                if num_lh>1
                    thin_sep_str=regexprep(thin_sep_str,'\s+',' ');
                end
                set(SS2_edit,'String',thin_sep_str)

                set(SS2_UserData.fh,'Userdata',SS2_UserData)
                set(SS2_UserData.um,'CallBack',{@SS2_delete_thin_separators,SS2_UserData})
                set(SS2_UserData.fh,'WindowButtonMotionFcn',{@SS2_get_coordinates,SS2_UserData},'KeyPressFcn',{@SS2_keyboard,SS2_UserData})
                set(SS2_UserData.lh,'ButtonDownFcn',{@SS2_start_move_thin_separators,SS2_UserData},'UIContextMenu',SS2_UserData.cm)
                set(SS2_UserData.ah,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SS2_UserData.spike_lh{trac},'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                end
                set(SS2_UserData.image_mh,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                set(SS2_UserData.fh,'Userdata',SS2_UserData)
            end
        elseif strcmp(varargin{2}.Key,'a')
            modifiers=get(SS2_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                num_lh=length(SS2_UserData.thin_separators);
                SS2_UserData.marked=SS2_UserData.thin_separators;
                SS2_UserData.marked_indy=1:num_lh;
                for selc=1:num_lh
                    set(SS2_UserData.lh(selc),'Color',p_para.thin_sep_marked_col);
                end
                SS2_UserData.flag=1;

                set(SS2_UserData.fh,'Userdata',SS2_UserData)
                set(SS2_UserData.um,'CallBack',{@SS2_delete_thin_separators,SS2_UserData})
                set(SS2_UserData.fh,'WindowButtonMotionFcn',{@SS2_get_coordinates,SS2_UserData},'KeyPressFcn',{@SS2_keyboard,SS2_UserData})
                set(SS2_UserData.lh,'ButtonDownFcn',{@SS2_start_move_thin_separators,SS2_UserData},'UIContextMenu',SS2_UserData.cm)
                set(SS2_UserData.ah,'ButtonDownFcn',{@SS2_start_pick,SS2_UserData})
                for trac=1:d_para.num_trains
                    set(SS2_UserData.spike_lh{trac},'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                end
                set(SS2_UserData.image_mh,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                set(SS2_UserData.fh,'Userdata',SS2_UserData)
            end
        elseif strcmp(varargin{2}.Key,'c')
            modifiers=get(SS2_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                num_lh=length(SS2_UserData.thin_separators);
                ax_y=SS2_UserData.thin_separators(SS2_UserData.marked_indy);
                for idx=1:length(SS2_UserData.marked_indy)
                    SS2_UserData.lh(num_lh+idx)=line([SS2_UserData.tmin SS2_UserData.tmax],(0.05+((SS2_UserData.num_trains-SS2_UserData.thin_separators(SS2_UserData.marked_indy(idx)))/SS2_UserData.num_trains))*ones(1,2),...
                        'Visible',p_para.thin_sep_vis,'Color',p_para.thin_sep_marked_col,'LineStyle',p_para.thin_sep_ls,'LineWidth',p_para.thin_sep_lw);
                end
                SS2_UserData.marked=SS2_UserData.thin_separators(SS2_UserData.marked_indy);
                SS2_UserData.marked_indy=num_lh+(1:length(SS2_UserData.marked_indy));
                SS2_UserData.thin_separators(SS2_UserData.marked_indy)=SS2_UserData.marked;
                SS2_UserData.flag=1;
                ax_pos=get(SS2_UserData.ah,'CurrentPoint');
                SS2_UserData.initial_YPos=SS2_UserData.num_trains-floor((ax_pos(1,2)-0.05)*SS2_UserData.num_trains);
                SS2_UserData.initial_ST=ax_y;
                set(SS2_UserData.ah,'ButtonDownFcn','')
                for trac=1:d_para.num_trains
                    set(SS2_UserData.spike_lh{trac},'ButtonDownFcn','')
                end
                set(SS2_UserData.image_mh,'ButtonDownFcn','')
                set(SS2_UserData.fh,'WindowButtonMotionFcn',{@SS2_move_thin_separators,SS2_UserData})
                set(SS2_UserData.fh,'Userdata',SS2_UserData)
            end
        end
    end


    function SS2_Load_separators(varargin)
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
            SS2_UserData=get(f_para.num_fig,'UserData');
            data.matfile=d_para.matfile;
            data.default_variable='';
            data.content='thin separators';
            SPIKY('SPIKY_select_variable',gcbo,data,handles)
            variable=getappdata(handles.figure1,'variable');
            if ~isempty(variable) && ~strcmp(variable,'A9ZB1YC8X')
                data=getappdata(handles.figure1,'data');
                SS2_UserData.thin_separators=squeeze(data.(variable));
            end
            if ~isnumeric(SS2_UserData.thin_separators) || ndims(SS2_UserData.thin_separators)~=2 || ~any(size(SS2_UserData.thin_separators)==1)
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
            if size(SS2_UserData.thin_separators,2)<size(SS2_UserData.thin_separators,1)
                SS2_UserData.thin_separators=SS2_UserData.thin_separators';
            end
            thin_sep_str=num2str(SS2_UserData.thin_separators);
            if length(SS2_UserData.thin_separators)>1
                thin_sep_str=regexprep(thin_sep_str,'\s+',' ');
            end
            set(SS2_edit,'String',thin_sep_str)
            set(SS2_UserData.fh,'Userdata',SS2_UserData)
        end
    end


    function SS2_callback(varargin)
        d_para=getappdata(handles.figure1,'data_parameters');
        f_para=getappdata(handles.figure1,'figure_parameters');
        figure(f_para.num_fig);
        SS2_UserData=get(gcf,'Userdata');

        if gcbo==SS2_Reset_pushbutton || gcbo==SS2_Cancel_pushbutton || gcbo==SS_fig
            if isfield(SS2_UserData,'lh')
                for rc=1:size(SS2_UserData.lh,1)
                    for lhc=1:size(SS2_UserData.lh,2)
                        if ishandle(SS2_UserData.lh(lhc))
                            delete(SS2_UserData.lh(lhc))
                        end
                    end
                end
                SS2_UserData.lh=[];
            end
            if isfield(SS2_UserData,'thin_separators')
                SS2_UserData.thin_separators=[];
            end
            d_para.thin_separators=[];
            set(SS2_edit,'string',[])
            if gcbo==SS2_Reset_pushbutton
                set(SS2_UserData.fh,'Userdata',SS2_UserData)
                set(SS2_UserData.um,'CallBack',{@SS2_delete_thin_separators,SS2_UserData})
                set(SS2_UserData.fh,'WindowButtonMotionFcn',{@SS2_get_coordinates,SS2_UserData},'KeyPressFcn',{@SS2_keyboard,SS2_UserData})
                set(SS2_UserData.lh,'ButtonDownFcn',{@SS2_start_move_thin_separators,SS2_UserData},'UIContextMenu',SS2_UserData.cm)
                set(SS2_UserData.ah,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SS2_UserData.spike_lh{trac},'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                end
                set(SS2_UserData.image_mh,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                set(SS2_UserData.fh,'Userdata',SS2_UserData)
            elseif gcbo==SS2_Cancel_pushbutton || gcbo==SS_fig
                SS2_UserData.cm=[];
                SS2_UserData.um=[];
                set(SS2_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
                set(SS2_UserData.lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SS2_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SS2_UserData.spike_lh{trac},'ButtonDownFcn','','UIContextMenu',[])
                end
                set(SS2_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SS2_UserData.fh,'Userdata',SS2_UserData)
                delete(SS_fig)
                set(handles.figure1,'Visible','on')
            end
        elseif gcbo==SS2_OK_pushbutton || gcbo==SS2_Apply_pushbutton
            thin_separators_str_in=regexprep(get(SS2_edit,'String'),'\s+',' ');
            thin_separators=unique(str2num(regexprep(thin_separators_str_in,f_para.regexp_str_vector_integers,'')));
            thin_separators=thin_separators(thin_separators>0 & thin_separators<d_para.num_trains);
            thin_separators_str_out=regexprep(num2str(thin_separators),'\s+',' ');
            if ~strcmp(thin_separators_str_in,thin_separators_str_out)
                if ~isempty(thin_separators_str_out)
                    set(SS2_edit,'String',thin_separators_str_out)
                else
                    set(SS2_edit,'String',regexprep(num2str(d_para.thin_separators),'\s+',' '))
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
            SS2_UserData.thin_separators=unique(str2num(get(SS2_edit,'String')));
            delete(SS2_UserData.lh)
            SS2_UserData=rmfield(SS2_UserData,'lh');

            figure(f_para.num_fig);
            if gcbo==SS2_Apply_pushbutton
                thin_sep_cmenu=uicontextmenu;
                SS2_UserData.lh=zeros(1,length(SS2_UserData.thin_separators));
                for lhc=1:length(SS2_UserData.thin_separators)
                    SS2_UserData.lh(lhc)=line([SS2_UserData.tmin SS2_UserData.tmax],(0.05+((SS2_UserData.num_trains-SS2_UserData.thin_separators(lhc))/SS2_UserData.num_trains))*ones(1,2),...
                        'Color',p_para.thin_sep_col,'LineStyle',p_para.thin_sep_ls,'LineWidth',p_para.thin_sep_lw,'UIContextMenu',thin_sep_cmenu);
                end
                set(SS2_UserData.fh,'Userdata',SS2_UserData)
                set(SS2_UserData.fh,'Userdata',SS2_UserData)
                set(SS2_UserData.um,'CallBack',{@SS2_delete_thin_separators,SS2_UserData})
                set(SS2_UserData.fh,'WindowButtonMotionFcn',{@SS2_get_coordinates,SS2_UserData},'KeyPressFcn',{@SS2_keyboard,SS2_UserData})
                set(SS2_UserData.lh,'ButtonDownFcn',{@SS2_start_move_thin_separators,SS2_UserData},'UIContextMenu',SS2_UserData.cm)
                set(SS2_UserData.ah,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SS2_UserData.spike_lh{trac},'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                end
                set(SS2_UserData.image_mh,'ButtonDownFcn',{@SS2_pick_thin_separators,SS2_UserData},'UIContextMenu',[])
                set(SS2_UserData.fh,'Userdata',SS2_UserData)
            else
                if isfield(SS2_UserData,'lh')
                    for lhc=1:length(SS2_UserData.lh)
                        if ishandle(SS2_UserData.lh(lhc))
                            delete(SS2_UserData.lh(lhc))
                        end
                    end
                    SS2_UserData=rmfield(SS2_UserData,'lh');
                end
                SS2_UserData.marked_indy=[];
                SS2_UserData.flag=0;
                SS2_UserData.cm=[];
                SS2_UserData.um=[];
                set(SS2_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
                set(SS2_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SS2_UserData.spike_lh{trac},'ButtonDownFcn',[],'UIContextMenu',[])
                end
                set(SS2_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SS2_UserData.fh,'Userdata',SS2_UserData)

                d_para.thick_separators=unique(SS2_UserData.thick_separators);
                d_para.thin_separators=unique(SS2_UserData.thin_separators);
                setappdata(handles.figure1,'data_parameters',d_para)
                set(handles.dpara_thick_separators_edit,'String',regexprep(num2str(d_para.thick_separators),'\s+',' '))
                set(handles.dpara_thin_separators_edit,'String',regexprep(num2str(d_para.thin_separators),'\s+',' '))

                set(SS2_OK_pushbutton,'UserData',1)
                set(handles.figure1,'Visible','on')
                delete(SS_fig)
            end
        end
    end


    function SS_Close_callback(varargin)
        figure(f_para.num_fig);
        xlim([s_para.itmin-0.02*s_para.itrange s_para.itmax+0.02*s_para.itrange])
        SS_UserData=get(gcf,'Userdata');
        if isfield(SS_UserData,'lh')
            for cc=1:length(SS_UserData.lh)
                if ishandle(SS_UserData.lh(cc))
                    delete(SS_UserData.lh(cc))
                end
            end
            SS_UserData.lh=[];
        end
        if isfield(SS_UserData,'lh2')
            for rc=1:2
                for cc=1:size(SS_UserData.lh2,2)
                    if ishandle(SS_UserData.lh2(rc,cc))
                        delete(SS_UserData.lh2(rc,cc))
                    end
                end
            end
            SS_UserData.lh2=[];
        end
        SS_UserData.cm=[];
        SS_UserData.um=[];
        set(SS_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
        set(SS_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SS_UserData.spike_lh{trac},'ButtonDownFcn',[],'UIContextMenu',[])
        end
        set(SS_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])
        set(SS_UserData.tx,'str','');
        set(SS_UserData.fh,'Userdata',[])
        delete(SS_fig)
        set(handles.figure1,'Visible','on')
    end

end
