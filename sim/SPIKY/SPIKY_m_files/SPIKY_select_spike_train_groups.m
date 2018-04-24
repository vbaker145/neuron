% This function provides an input mask (for keyboard and mouse) for selecting spike train groups (their names and their sizes).

function SPIKY_select_spike_train_groups(hObject, eventdata, handles)

set(handles.figure1,'Visible','off')

d_para=getappdata(handles.figure1,'data_parameters');
f_para=getappdata(handles.figure1,'figure_parameters');
p_para=getappdata(handles.figure1,'plot_parameters');
s_para=getappdata(handles.figure1,'subplot_parameters');

SG_fig=figure('units','normalized','menubar','none','position',[0.05 0.17 0.4 0.66],'Name','Select group separators',...
    'NumberTitle','off','Color',[0.9294 0.9176 0.851],'DeleteFcn',{@SG_Close_callback}); % ,'WindowStyle','modal'

SGS_panel=uipanel('units','normalized','position',[0.03 0.66 0.94 0.3],'Title','Group separators','FontSize',15,...
    'FontWeight','bold','HighlightColor','k');
SGS_edit=uicontrol('style','edit','units','normalized','position',[0.06 0.845 0.88 0.05],...
    'FontSize',15,'FontUnits','normalized','BackgroundColor','w');
SGS_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.1 0.765 0.22 0.05],'string','Cancel',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SGS_callback});
SGS_Reset_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.39 0.765 0.22 0.05],'string','Reset',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SGS_callback});
SGS_Apply_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.68 0.765 0.22 0.05],'string','Apply',...
    'FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SGS_callback});
SGS_Load_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.19 0.69 0.28 0.05],'string','Load from file',...
    'FontSize',15,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SGS_Load_group_separators});
SGS_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.53 0.69 0.28 0.05],'string','OK',...
    'FontSize',15,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],'CallBack',{@SGS_callback});
uicontrol(SGS_OK_pushbutton)

SGN_panel=uipanel('units','normalized','position',[0.03 0.05 0.94 0.58],'Title','Group names','FontSize',15,...
    'FontWeight','bold','Visible','off');
SGN_edit=uicontrol('style','edit','units','normalized','position',[0.06 0.51 0.88 0.05],...
    'FontSize',15,'FontUnits','normalized','BackgroundColor','w','Visible','off');
SGN_Down_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.1 0.425 0.22 0.05],...
    'string','Down','FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SGN_ListBox_callback},'Visible','off');
SGN_Up_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.39 0.425 0.22 0.05],...
    'string','Up','FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SGN_ListBox_callback},'Visible','off');
SGN_Replace_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.68 0.425 0.22 0.05],...
    'string','Replace','FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SGN_ListBox_callback},'Visible','off');
SGN_groups_listbox=uicontrol('style','listbox','units','normalized','position',[0.08 0.17 0.4 0.22],...
    'FontSize',15,'FontUnits','normalized','BackgroundColor','w','min',0,'max',1,'Visible','off','Enable','off');
SGN_names_listbox=uicontrol('style','listbox','units','normalized','position',[0.52 0.17 0.4 0.22],...
    'FontSize',15,'FontUnits','normalized','BackgroundColor','w','CallBack',{@SGN_ListBox_callback},'min',0,'max',1,'Visible','off');
SGN_Load_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.06 0.085 0.22 0.05],...
    'string','Load from file','FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SGN_Load_group_names},'Visible','off');
SGN_Cancel_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.3 0.085 0.2 0.05],...
    'string','Cancel','FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SGN_callback},'Visible','off');
SGN_Reset_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.52 0.085 0.2 0.05],...
    'string','Reset','FontSize',15,'FontUnits','normalized','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SGN_callback},'Visible','off');
SGN_OK_pushbutton=uicontrol('style','pushbutton','units','normalized','position',[0.74 0.085 0.2 0.05],...
    'string','OK','FontSize',15,'FontUnits','normalized','FontWeight','bold','BackgroundColor',[0.8353 0.8235 0.7922],...
    'CallBack',{@SGN_callback},'Visible','off');
uicontrol(SGN_OK_pushbutton)

figure(f_para.num_fig);
SGS_UserData.fh=gcf;
SGS_UserData.ah=gca;
set(SGS_UserData.fh,'Units','Normalized')
SGS_UserData.num_trains=d_para.num_trains;
SGS_UserData.xlim=xlim;
SGS_UserData.tmin=d_para.tmin;
SGS_UserData.tmax=d_para.tmax;
SGS_UserData.flag=0;
SGS_UserData.marked_indy=[];

if isfield(d_para,'all_train_group_sizes')
    SGS_UserData.group_sizes=d_para.all_train_group_sizes;
    SGS_UserData.group_separators=cumsum(SGS_UserData.group_sizes);
    SGS_UserData.group_separators=unique(round(SGS_UserData.group_separators(SGS_UserData.group_separators>0 & SGS_UserData.group_separators<SGS_UserData.num_trains)));
    set(SGS_edit,'String',regexprep(num2str(SGS_UserData.group_separators),'\s+',' '))
    SGS_UserData.lh=zeros(1,length(SGS_UserData.group_separators));
    for lhc=1:length(SGS_UserData.group_separators)
        SGS_UserData.lh(lhc)=line([SGS_UserData.tmin SGS_UserData.tmax],(0.05+((SGS_UserData.num_trains-SGS_UserData.group_separators(lhc))/SGS_UserData.num_trains))*ones(1,2),...
            'Color',p_para.sgs_col,'LineStyle',p_para.sgs_ls,'LineWidth',p_para.sgs_lw);
    end
else
    SGS_UserData.group_separators=[];
end
SGS_UserData.tx=uicontrol('style','tex','String','','unit','normalized','backg',get(SGS_UserData.fh,'Color'),...
    'position',[0.36 0.907 0.4 0.04],'FontSize',18,'FontWeight','bold','HorizontalAlignment','left');
SGS_UserData.spike_lh=getappdata(handles.figure1,'spike_lh');
SGS_UserData.image_mh=getappdata(handles.figure1,'image_mh');

set(SGS_UserData.fh,'Userdata',SGS_UserData)
SGS_UserData.cm=uicontextmenu;
SGS_UserData.um=uimenu(SGS_UserData.cm,'label','Delete group separator(s)','CallBack',{@SGS_delete_group_separators,SGS_UserData});
set(SGS_UserData.fh,'WindowButtonMotionFcn',{@SGS_get_coordinates,SGS_UserData},'KeyPressFcn',{@SGS_keyboard,SGS_UserData});
set(SGS_UserData.lh,'ButtonDownFcn',{@SGS_start_move_group_separators,SGS_UserData},'UIContextMenu',SGS_UserData.cm)
set(SGS_UserData.ah,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
for trac=1:d_para.num_trains
    set(SGS_UserData.spike_lh{trac},'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
end
set(SGS_UserData.image_mh,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
set(SGS_UserData.fh,'Userdata',SGS_UserData)

    function SGS_get_coordinates(varargin)
        SGS_UserData=varargin{3};
        SGS_UserData=get(SGS_UserData.fh,'UserData');

        ax_pos=get(SGS_UserData.ah,'CurrentPoint');
        ax_x_ok=SGS_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SGS_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        if ax_x_ok && ax_y_ok
            ax_y=SGS_UserData.num_trains-round((ax_pos(1,2)-0.05)*SGS_UserData.num_trains);
            ax_y(ax_y==0 && ax_y_ok)=1;
            ax_y(ax_y==SGS_UserData.num_trains && ax_y_ok)=SGS_UserData.num_trains-1;            
            set(SGS_UserData.tx,'str',['After spike train: ',num2str(ax_y)]);
        else
            set(SGS_UserData.tx,'str','Out of range');
        end
    end


    function SGS_pick_group_separators(varargin)                                   % SGS_marked_indy changes
        SGS_UserData=varargin{3};
        SGS_UserData=get(SGS_UserData.fh,'UserData');

        ax_pos=get(SGS_UserData.ah,'CurrentPoint');
        ax_x_ok=SGS_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SGS_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;
        ax_y=SGS_UserData.num_trains-round((ax_pos(1,2)-0.05)*SGS_UserData.num_trains);
        ax_y(ax_y==0 && ax_y_ok)=1;
        ax_y(ax_y==SGS_UserData.num_trains && ax_y_ok)=SGS_UserData.num_trains-1;

        modifiers=get(SGS_UserData.fh,'CurrentModifier');
        if ax_x_ok && ax_y_ok
            seltype=get(SGS_UserData.fh,'SelectionType');            % Right-or-left click?
            ctrlIsPressed=ismember('control',modifiers);
            if strcmp(seltype,'normal') || ctrlIsPressed                      % right or middle
                if ~isempty(SGS_UserData.group_separators)
                    num_lh=length(SGS_UserData.group_separators);
                    for lhc=1:num_lh
                        if ishandle(SGS_UserData.lh(lhc))
                            delete(SGS_UserData.lh(lhc))
                        end
                    end
                    SGS_UserData.group_separators=unique([SGS_UserData.group_separators ax_y]);
                else
                    SGS_UserData.group_separators=ax_y;
                end
                num_lh=length(SGS_UserData.group_separators);
                SGS_UserData.lh=zeros(1,num_lh);
                for selc=1:num_lh
                    if ismember(selc,SGS_UserData.marked_indy)
                        SGS_UserData.lh(selc)=line([SGS_UserData.tmin SGS_UserData.tmax],(0.05+((SGS_UserData.num_trains-SGS_UserData.group_separators(selc))/SGS_UserData.num_trains))*ones(1,2),...
                            'Visible',p_para.sgs_vis,'Color',p_para.sgs_marked_col,'LineStyle',p_para.sgs_ls,'LineWidth',p_para.sgs_lw);
                    else
                        SGS_UserData.lh(selc)=line([SGS_UserData.tmin SGS_UserData.tmax],(0.05+((SGS_UserData.num_trains-SGS_UserData.group_separators(selc))/SGS_UserData.num_trains))*ones(1,2),...
                            'Visible',p_para.sgs_vis,'Color',p_para.sgs_col,'LineStyle',p_para.sgs_ls,'LineWidth',p_para.sgs_lw);
                    end
                end

                sgs_str=num2str(SGS_UserData.group_separators);
                if length(SGS_UserData.group_separators)>1
                    sgs_str=regexprep(sgs_str,'\s+',' ');
                end
                set(SGS_edit,'String',sgs_str)
            end

            shftIsPressed=ismember('shift',modifiers);
            if ctrlIsPressed
                if isfield(SGS_UserData,'marked')
                    SGS_UserData.marked=unique([SGS_UserData.marked ax_y]);
                else
                    SGS_UserData.marked=ax_y;
                end
                [dummy,this,dummy2]=intersect(SGS_UserData.group_separators,SGS_UserData.marked);
                SGS_UserData.marked_indy=this;
                set(SGS_UserData.lh,'Color',p_para.sgs_col)
                set(SGS_UserData.lh(SGS_UserData.marked_indy),'Color',p_para.sgs_marked_col)
                SGS_UserData.flag=1;
            elseif ~shftIsPressed
                set(SGS_UserData.lh,'Color',p_para.sgs_col)
                SGS_UserData.marked=[];
                SGS_UserData.flag=0;
                SGS_UserData.marked_indy=[];
            end
        end

        shftIsPressed=ismember('shift',modifiers);
        dummy_marked=SGS_UserData.marked_indy;
        if shftIsPressed
            set(SGS_UserData.fh,'WindowButtonUpFcn',[])
            ax_pos=get(SGS_UserData.ah,'CurrentPoint');
            first_corner_x=ax_pos(1,1);
            first_corner_y=ax_pos(1,2);
            window=rectangle('Position',[first_corner_x, first_corner_y, 0.01, 0.01]);
            group_seps=(0.05+((SGS_UserData.num_trains-SGS_UserData.group_separators)/SGS_UserData.num_trains));
            while shftIsPressed
                ax_pos=get(SGS_UserData.ah,'CurrentPoint');
                second_corner_x=ax_pos(1,1);
                second_corner_y=ax_pos(1,2);
                if second_corner_x ~= first_corner_x && second_corner_y ~= first_corner_y
                    set(window,'Position',[min(first_corner_x, second_corner_x), min(first_corner_y, second_corner_y), abs(second_corner_x-first_corner_x), abs(second_corner_y-first_corner_y)])
                    drawnow
                    bottom_mark=min(first_corner_y, second_corner_y);
                    top_mark=max(first_corner_y, second_corner_y);
                    SGS_UserData.marked_indy=unique([dummy_marked find(group_seps>=bottom_mark & group_seps<=top_mark)]);
                    SGS_UserData.flag=(~isempty(SGS_UserData.marked_indy));
                    set(SGS_UserData.lh,'Color',p_para.sgs_col)
                    set(SGS_UserData.lh(SGS_UserData.marked_indy),'Color',p_para.sgs_marked_col)
                end
                pause(0.001);
                modifiers=get(SGS_UserData.fh,'CurrentModifier');
                shftIsPressed=ismember('shift',modifiers);
            end
            delete(window)
            SGS_UserData.marked=SGS_UserData.group_separators(SGS_UserData.marked_indy);
        end
        
        %pick_marky=SGS_UserData.marked
        %pick_marky_indy=SGS_UserData.marked_indy

        set(SGS_UserData.fh,'Userdata',SGS_UserData)
        set(SGS_UserData.um,'CallBack',{@SGS_delete_group_separators,SGS_UserData})
        set(SGS_UserData.fh,'WindowButtonMotionFcn',{@SGS_get_coordinates,SGS_UserData},'KeyPressFcn',{@SGS_keyboard,SGS_UserData})
        set(SGS_UserData.lh,'ButtonDownFcn',{@SGS_start_move_group_separators,SGS_UserData},'UIContextMenu',SGS_UserData.cm)
        set(SGS_UserData.ah,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SGS_UserData.spike_lh{trac},'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
        end
        set(SGS_UserData.image_mh,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
        set(SGS_UserData.fh,'Userdata',SGS_UserData)
    end


    function SGS_delete_group_separators(varargin)
        SGS_UserData=varargin{3};
        SGS_UserData=get(SGS_UserData.fh,'UserData');
        
        %delete_marky=SGS_UserData.marked
        %delete_marky_indy=SGS_UserData.marked_indy

        if (SGS_UserData.flag)
            SGS_UserData.group_separators=setdiff(SGS_UserData.group_separators,SGS_UserData.group_separators(SGS_UserData.marked_indy));
            SGS_UserData.marked_indy=[];
            SGS_UserData.flag=0;
        else
            ax_y=get(gco,'YData');
            SGS_UserData.group_separators=setdiff(SGS_UserData.group_separators,SGS_UserData.num_trains-ceil((ax_y(1)-0.05)*SGS_UserData.num_trains));
        end
        for lhc=1:length(SGS_UserData.lh)
            if ishandle(SGS_UserData.lh(lhc))
                delete(SGS_UserData.lh(lhc))
            end
        end
        num_lh=length(SGS_UserData.group_separators);
        SGS_UserData.lh=zeros(1,num_lh);
        for selc=1:num_lh
            SGS_UserData.lh(selc)=line([SGS_UserData.tmin SGS_UserData.tmax],(0.05+((SGS_UserData.num_trains-SGS_UserData.group_separators(selc))/SGS_UserData.num_trains))*ones(1,2),...
                'Visible',p_para.sgs_vis,'Color',p_para.sgs_col,'LineStyle',p_para.sgs_ls,'LineWidth',p_para.sgs_lw);
        end
        sgs_str=num2str(SGS_UserData.group_separators);
        if num_lh>1
            sgs_str=regexprep(sgs_str,'\s+',' ');
        end
        set(SGS_edit,'String',sgs_str)

        set(SGS_UserData.fh,'Userdata',SGS_UserData)
        set(SGS_UserData.um,'CallBack',{@SGS_delete_group_separators,SGS_UserData})
        set(SGS_UserData.fh,'WindowButtonMotionFcn',{@SGS_get_coordinates,SGS_UserData},'KeyPressFcn',{@SGS_keyboard,SGS_UserData})
        set(SGS_UserData.lh,'ButtonDownFcn',{@SGS_start_move_group_separators,SGS_UserData},'UIContextMenu',SGS_UserData.cm)
        set(SGS_UserData.ah,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SGS_UserData.spike_lh{trac},'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
        end
        set(SGS_UserData.image_mh,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
        set(SGS_UserData.fh,'Userdata',SGS_UserData)
    end


    function SGS_start_move_group_separators(varargin)
        SGS_UserData=varargin{3};
        SGS_UserData=get(SGS_UserData.fh,'UserData');

        seltype=get(SGS_UserData.fh,'SelectionType'); % Right-or-left click?
        %ax_pos=get(SGS_UserData.ah,'CurrentPoint');
        if strcmp(seltype,'alt')
            modifiers=get(SGS_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                ax_y=get(gco,'YData');

                if isfield(SGS_UserData,'marked')
                    SGS_UserData.marked=unique([SGS_UserData.marked ax_y]);
                else
                    SGS_UserData.marked=ax_y;
                end
                [dummy,this,dummy2]=intersect(SGS_UserData.group_separators,SGS_UserData.marked);
                SGS_UserData.marked_indy=this;
                if ~SGS_UserData.flag
                    SGS_UserData.flag=1;
                end
                set(gco,'Color',p_para.sgs_marked_col);

                set(SGS_UserData.fh,'Userdata',SGS_UserData)
                set(SGS_UserData.um,'CallBack',{@SGS_delete_group_separators,SGS_UserData})
                set(SGS_UserData.fh,'WindowButtonMotionFcn',{@SGS_get_coordinates,SGS_UserData},'KeyPressFcn',{@SGS_keyboard,SGS_UserData})
                set(SGS_UserData.lh,'ButtonDownFcn',{@SGS_start_move_group_separators,SGS_UserData},'UIContextMenu',SGS_UserData.cm)
                set(SGS_UserData.ah,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SGS_UserData.spike_lh{trac},'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                end
                set(SGS_UserData.image_mh,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                set(SGS_UserData.fh,'Userdata',SGS_UserData)
            end
        else
            if ~SGS_UserData.flag
                num_lh=length(SGS_UserData.group_separators);
                for selc=1:num_lh
                    set(SGS_UserData.lh(selc),'Color',p_para.sgs_col);
                end
                SGS_UserData.marked_indy=find(SGS_UserData.lh(:) == gco);
                dummy=get(gco,'YData');
                SGS_UserData.initial_ST=SGS_UserData.num_trains-floor((dummy(1)-0.05)*SGS_UserData.num_trains);
                SGS_UserData.initial_YPos=SGS_UserData.initial_ST;
            else
                %SGS_UserData.initial_YPos=SGS_UserData.num_trains-floor((ax_pos(1,2)-0.05)*SGS_UserData.num_trains);
                SGS_UserData.initial_ST=SGS_UserData.group_separators(SGS_UserData.marked_indy);
                SGS_UserData.initial_YPos=SGS_UserData.initial_ST(1);
            end
            set(SGS_UserData.fh,'WindowButtonMotionFcn',{@SGS_move_group_separators,SGS_UserData})
            set(SGS_UserData.ah,'ButtonDownFcn','')
            for trac=1:d_para.num_trains
                set(SGS_UserData.spike_lh{trac},'ButtonDownFcn','')
            end
            set(SGS_UserData.image_mh,'ButtonDownFcn','')
            set(SGS_UserData.fh,'Userdata',SGS_UserData)
        end        
    end


    function SGS_move_group_separators(varargin)
        SGS_UserData=varargin{3};
        SGS_UserData=get(SGS_UserData.fh,'UserData');

        ax_pos=get(SGS_UserData.ah,'CurrentPoint');
        ax_x_ok=SGS_UserData.tmin<=ax_pos(1,1)&& ax_pos(1,1)<=SGS_UserData.tmax;
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;
        
        ax_y=SGS_UserData.num_trains-round((ax_pos(1,2)-0.05)*SGS_UserData.num_trains);
        ax_y(ax_y==0 && ax_y_ok)=1;
        ax_y(ax_y==SGS_UserData.num_trains && ax_y_ok)=SGS_UserData.num_trains-1;
        
        for idx=1:length(SGS_UserData.marked_indy)
            if SGS_UserData.initial_ST(idx)+ax_y-SGS_UserData.initial_YPos>0 && ...
                    SGS_UserData.initial_ST(idx)+ax_y-SGS_UserData.initial_YPos<SGS_UserData.num_trains
                set(SGS_UserData.lh(SGS_UserData.marked_indy(idx)),'Color',p_para.sgs_marked_col,...
                    'YData',(0.05+((SGS_UserData.num_trains-(SGS_UserData.initial_ST(idx)+ax_y-SGS_UserData.initial_YPos))/...
                    SGS_UserData.num_trains))*ones(1,2),'LineWidth',2)
            else
                set(SGS_UserData.lh(SGS_UserData.marked_indy(idx)),'YData',(0.05+((SGS_UserData.num_trains-(SGS_UserData.initial_ST(idx)+ax_y-SGS_UserData.initial_YPos))/...
                    SGS_UserData.num_trains))*ones(1,2),'Color','w')
            end
        end
        drawnow;

        if ax_x_ok && ax_y_ok
            %set(SGS_UserData.tx,'str',['After spike train: ',num2str(ax_y)]);
            ax_y(ax_y==0 && ax_y_ok)=1;
            ax_y(ax_y==SGS_UserData.num_trains && ax_y_ok)=SGS_UserData.num_trains-1;
            set(SGS_UserData.tx,'str',['After spike train: ',num2str(ax_y)]);
        else
            set(SGS_UserData.tx,'str','Out of range');
        end
        set(SGS_UserData.fh,'WindowButtonUpFcn',{@SGS_stop_move_group_separators,SGS_UserData})
        set(SGS_UserData.fh,'Userdata',SGS_UserData)
    end


    function SGS_stop_move_group_separators(varargin)
        SGS_UserData=varargin{3};
        SGS_UserData=get(SGS_UserData.fh,'UserData');

        ax_pos=get(SGS_UserData.ah,'CurrentPoint');
        ax_y_ok=0.05<=ax_pos(1,2) && ax_pos(1,2)<=1.05;

        ax_y=SGS_UserData.num_trains-round((ax_pos(1,2)-0.05)*SGS_UserData.num_trains);
        ax_y(ax_y==0 && ax_y_ok)=1;
        ax_y(ax_y==SGS_UserData.num_trains && ax_y_ok)=SGS_UserData.num_trains-1;

        for idx=1:length(SGS_UserData.marked_indy)
            if SGS_UserData.initial_ST(idx)+ax_y-SGS_UserData.initial_YPos>0 && ...
                    SGS_UserData.initial_ST(idx)+ax_y-SGS_UserData.initial_YPos<SGS_UserData.num_trains
                SGS_UserData.group_separators(SGS_UserData.marked_indy(idx))=SGS_UserData.initial_ST(idx)+ax_y-SGS_UserData.initial_YPos;
            else
                SGS_UserData.group_separators=SGS_UserData.group_separators(setdiff(1:length(SGS_UserData.group_separators),SGS_UserData.marked_indy(idx)));
                SGS_UserData.marked_indy(idx+1:end)=SGS_UserData.marked_indy(idx+1:end)-1;
            end
        end
        SGS_UserData.group_separators=unique(SGS_UserData.group_separators);
        SGS_UserData.marked_indy=[];
        SGS_UserData.flag=0;
        for lhc=1:size(SGS_UserData.lh,2)
            if ishandle(SGS_UserData.lh(lhc))
                delete(SGS_UserData.lh(lhc))
            end
        end
        num_lh=length(SGS_UserData.group_separators);
        SGS_UserData.lh=zeros(1,num_lh);
        for selc=1:num_lh
            SGS_UserData.lh(selc)=line([SGS_UserData.tmin SGS_UserData.tmax],(0.05+((SGS_UserData.num_trains-SGS_UserData.group_separators(selc))/SGS_UserData.num_trains))*ones(1,2),...
                'Visible',p_para.sgs_vis,'Color',p_para.sgs_col,'LineStyle',p_para.sgs_ls,'LineWidth',p_para.sgs_lw);
        end
        sgs_str=num2str(SGS_UserData.group_separators);
        if num_lh>1
            sgs_str=regexprep(sgs_str,'\s+',' ');
        end
        set(SGS_edit,'String',sgs_str)
        set(SGS_UserData.fh,'Pointer','arrow')
        drawnow;

        set(SGS_UserData.fh,'Userdata',SGS_UserData)
        set(SGS_UserData.um,'CallBack',{@SGS_delete_group_separators,SGS_UserData})
        set(SGS_UserData.fh,'WindowButtonMotionFcn',{@SGS_get_coordinates,SGS_UserData},'KeyPressFcn',{@SGS_keyboard,SGS_UserData},...
            'WindowButtonUpFcn',[])
        set(SGS_UserData.lh,'ButtonDownFcn',{@SGS_start_move_group_separators,SGS_UserData},'UIContextMenu',SGS_UserData.cm)
        set(SGS_UserData.ah,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SGS_UserData.spike_lh{trac},'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
        end
        set(SGS_UserData.image_mh,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
        set(SGS_UserData.fh,'Userdata',SGS_UserData)
    end


    function SGS_keyboard(varargin)
        SGS_UserData=varargin{3};
        SGS_UserData=get(SGS_UserData.fh,'UserData');

        if strcmp(varargin{2}.Key,'delete')
            if (SGS_UserData.flag)
                SGS_UserData.group_separators=setdiff(SGS_UserData.group_separators,SGS_UserData.group_separators(SGS_UserData.marked_indy));
                SGS_UserData.marked_indy=[];
                SGS_UserData.flag=0;
                for lhc=1:length(SGS_UserData.lh)
                    if ishandle(SGS_UserData.lh(lhc))
                        delete(SGS_UserData.lh(lhc))
                    end
                end
                num_lh=length(SGS_UserData.group_separators);
                SGS_UserData.lh=zeros(1,num_lh);
                for selc=1:num_lh
                    SGS_UserData.lh(selc)=line([SGS_UserData.tmin SGS_UserData.tmax],(0.05+((SGS_UserData.num_trains-SGS_UserData.group_separators(selc))/SGS_UserData.num_trains))*ones(1,2),...
                        'Visible',p_para.sgs_vis,'Color',p_para.sgs_col,'LineStyle',p_para.sgs_ls,'LineWidth',p_para.sgs_lw);
                end
                sgs_str=num2str(SGS_UserData.group_separators);
                if num_lh>1
                    sgs_str=regexprep(sgs_str,'\s+',' ');
                end
                set(SGS_edit,'String',sgs_str)

                set(SGS_UserData.fh,'Userdata',SGS_UserData)
                set(SGS_UserData.um,'CallBack',{@SGS_delete_group_separators,SGS_UserData})
                set(SGS_UserData.fh,'WindowButtonMotionFcn',{@SGS_get_coordinates,SGS_UserData},'KeyPressFcn',{@SGS_keyboard,SGS_UserData})
                set(SGS_UserData.lh,'ButtonDownFcn',{@SGS_start_move_group_separators,SGS_UserData},'UIContextMenu',SGS_UserData.cm)
                set(SGS_UserData.ah,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SGS_UserData.spike_lh{trac},'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                end
                set(SGS_UserData.image_mh,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                set(SGS_UserData.fh,'Userdata',SGS_UserData)
            end
        elseif strcmp(varargin{2}.Key,'a')
            modifiers=get(SGS_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                num_lh=length(SGS_UserData.group_separators);
                SGS_UserData.marked=SGS_UserData.group_separators;
                SGS_UserData.marked_indy=1:num_lh;
                for selc=1:num_lh
                    set(SGS_UserData.lh(selc),'Color',p_para.sgs_marked_col);
                end
                SGS_UserData.flag=1;

                set(SGS_UserData.fh,'Userdata',SGS_UserData)
                set(SGS_UserData.um,'CallBack',{@SGS_delete_group_separators,SGS_UserData})
                set(SGS_UserData.fh,'WindowButtonMotionFcn',{@SGS_get_coordinates,SGS_UserData},'KeyPressFcn',{@SGS_keyboard,SGS_UserData})
                set(SGS_UserData.lh,'ButtonDownFcn',{@SGS_start_move_group_separators,SGS_UserData},'UIContextMenu',SGS_UserData.cm)
                set(SGS_UserData.ah,'ButtonDownFcn',{@SGS_start_pick,SGS_UserData})
                for trac=1:d_para.num_trains
                    set(SGS_UserData.spike_lh{trac},'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                end
                set(SGS_UserData.image_mh,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                set(SGS_UserData.fh,'Userdata',SGS_UserData)
            end
        elseif strcmp(varargin{2}.Key,'c')
            modifiers=get(SGS_UserData.fh,'CurrentModifier');
            ctrlIsPressed=ismember('control',modifiers);
            if ctrlIsPressed
                num_lh=length(SGS_UserData.group_separators);
                ax_y=SGS_UserData.group_separators(SGS_UserData.marked_indy);
                for idx=1:length(SGS_UserData.marked_indy)
                    SGS_UserData.lh(num_lh+idx)=line([SGS_UserData.tmin SGS_UserData.tmax],(0.05+((SGS_UserData.num_trains-SGS_UserData.group_separators(SGS_UserData.marked_indy(idx)))/SGS_UserData.num_trains))*ones(1,2),...
                        'Visible',p_para.sgs_vis,'Color',p_para.sgs_marked_col,'LineStyle',p_para.sgs_ls,'LineWidth',p_para.sgs_lw);
                end
                SGS_UserData.marked=SGS_UserData.group_separators(SGS_UserData.marked_indy);
                SGS_UserData.marked_indy=num_lh+(1:length(SGS_UserData.marked_indy));
                SGS_UserData.group_separators(SGS_UserData.marked_indy)=SGS_UserData.marked;
                SGS_UserData.flag=1;
                ax_pos=get(SGS_UserData.ah,'CurrentPoint');
                SGS_UserData.initial_YPos=SGS_UserData.num_trains-floor((ax_pos(1,2)-0.05)*SGS_UserData.num_trains);
                SGS_UserData.initial_ST=ax_y;
                set(SGS_UserData.ah,'ButtonDownFcn','')
                for trac=1:d_para.num_trains
                    set(SGS_UserData.spike_lh{trac},'ButtonDownFcn','')
                end
                set(SGS_UserData.image_mh,'ButtonDownFcn','')
                set(SGS_UserData.fh,'WindowButtonMotionFcn',{@SGS_move_group_separators,SGS_UserData})
                set(SGS_UserData.fh,'Userdata',SGS_UserData)
            end
        end
    end


    function SGS_Load_group_separators(varargin)
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
            SGS_UserData=get(f_para.num_fig,'UserData');
            data.matfile=d_para.matfile;
            data.default_variable='';
            data.content='group separators';
            SPIKY('SPIKY_select_variable',gcbo,data,handles)
            variable=getappdata(handles.figure1,'variable');
            if ~isempty(variable) && ~strcmp(variable,'A9ZB1YC8X')
                data=getappdata(handles.figure1,'data');
                SGS_UserData.group_separators=squeeze(data.(variable));
            end
            if ~isnumeric(SGS_UserData.group_separators) || ndims(SGS_UserData.group_separators)~=2 || ~any(size(SGS_UserData.group_separators)==1)
                if ~strcmp(variable,'A9ZB1YC8X')
                    set(0,'DefaultUIControlFontSize',16);
                    mbh=msgbox(sprintf('No vector has been chosen.\nPlease try again!'),'Warning','warn','modal');
                    htxt = findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                    uiwait(mbh);
                end
                ret=1;
                return
            end
            if sum(SGS_UserData.group_separators)==d_para.num_trains
                SGS_UserData.group_separators=cumsum(SGS_UserData.group_separators);
                SGS_UserData.group_separators=SGS_UserData.group_separators(1:end-1);
            end
            if size(SGS_UserData.group_separators,2)<size(SGS_UserData.group_separators,1)
                SGS_UserData.group_separators=SGS_UserData.group_separators';
            end
            group_sep_str=num2str(SGS_UserData.group_separators);
            if length(SGS_UserData.group_separators)>1
                group_sep_str=regexprep(group_sep_str,'\s+',' ');
            end
            set(SGS_edit,'String',group_sep_str)
            set(SGS_UserData.fh,'Userdata',SGS_UserData)
        end
    end


    function SGS_callback(varargin)
        d_para=getappdata(handles.figure1,'data_parameters');
        f_para=getappdata(handles.figure1,'figure_parameters');
        figure(f_para.num_fig);
        SGS_UserData=get(gcf,'Userdata');

        if gcbo==SGS_Reset_pushbutton || gcbo==SGS_Cancel_pushbutton || gcbo==SG_fig
            if isfield(SGS_UserData,'lh')
                for rc=1:size(SGS_UserData.lh,1)
                    for lhc=1:size(SGS_UserData.lh,2)
                        if ishandle(SGS_UserData.lh(lhc))
                            delete(SGS_UserData.lh(lhc))
                        end
                    end
                end
                SGS_UserData.lh=[];
            end
            if isfield(SGS_UserData,'group_separators')
                SGS_UserData.group_separators=[];
            end
            d_para.group_separators=[];
            set(SGS_edit,'string',[])
            if gcbo==SGS_Reset_pushbutton
                set(SGS_UserData.fh,'Userdata',SGS_UserData)
                set(SGS_UserData.um,'CallBack',{@SGS_delete_group_separators,SGS_UserData})
                set(SGS_UserData.fh,'WindowButtonMotionFcn',{@SGS_get_coordinates,SGS_UserData},'KeyPressFcn',{@SGS_keyboard,SGS_UserData})
                set(SGS_UserData.lh,'ButtonDownFcn',{@SGS_start_move_group_separators,SGS_UserData},'UIContextMenu',SGS_UserData.cm)
                set(SGS_UserData.ah,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SGS_UserData.spike_lh{trac},'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                end
                set(SGS_UserData.image_mh,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                set(SGS_UserData.fh,'Userdata',SGS_UserData)
            elseif gcbo==SGS_Cancel_pushbutton || gcbo==SG_fig
                SGS_UserData.cm=[];
                SGS_UserData.um=[];
                set(SGS_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
                set(SGS_UserData.lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SGS_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SGS_UserData.spike_lh{trac},'ButtonDownFcn',[],'UIContextMenu',[])
                end
                set(SGS_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SGS_UserData.fh,'Userdata',SGS_UserData)
                delete(SG_fig)
                set(handles.figure1,'Visible','on')
            end
        elseif gcbo==SGS_OK_pushbutton || gcbo==SGS_Apply_pushbutton
            group_separators_str_in=regexprep(get(SGS_edit,'String'),'\s+',' ');
            group_separators=unique(str2num(regexprep(group_separators_str_in,f_para.regexp_str_vector_integers,'')));
            group_separators=group_separators(group_separators>0 & group_separators<d_para.num_trains);
            group_separators_str_out=regexprep(num2str(group_separators),'\s+',' ');
            if ~strcmp(group_separators_str_in,group_separators_str_out)
                if ~isempty(group_separators_str_out)
                    set(SGS_edit,'String',group_separators_str_out)
                else
                    set(SGS_edit,'String',regexprep(num2str(SGS_UserData.group_separators),'\s+',' '))
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
            SGS_UserData.group_separators=unique(str2num(get(SGS_edit,'String')));
            delete(SGS_UserData.lh)
            SGS_UserData=rmfield(SGS_UserData,'lh');

            figure(f_para.num_fig);
            sgs_cmenu=uicontextmenu;
            SGS_UserData.lh=zeros(1,length(SGS_UserData.group_separators));
            for lhc=1:length(SGS_UserData.group_separators)
                SGS_UserData.lh(lhc)=line([SGS_UserData.tmin SGS_UserData.tmax],(0.05+((SGS_UserData.num_trains-SGS_UserData.group_separators(lhc))/SGS_UserData.num_trains))*ones(1,2),...
                    'Color',p_para.sgs_col,'LineStyle',p_para.sgs_ls,'LineWidth',p_para.sgs_lw,'UIContextMenu',sgs_cmenu);
            end
            set(SGS_UserData.fh,'Userdata',SGS_UserData)

            if gcbo==SGS_Apply_pushbutton
                set(SGS_UserData.fh,'Userdata',SGS_UserData)
                set(SGS_UserData.um,'CallBack',{@SGS_delete_group_separators,SGS_UserData})
                set(SGS_UserData.fh,'WindowButtonMotionFcn',{@SGS_get_coordinates,SGS_UserData},'KeyPressFcn',{@SGS_keyboard,SGS_UserData})
                set(SGS_UserData.lh,'ButtonDownFcn',{@SGS_start_move_group_separators,SGS_UserData},'UIContextMenu',SGS_UserData.cm)
                set(SGS_UserData.ah,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SGS_UserData.spike_lh{trac},'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                end
                set(SGS_UserData.image_mh,'ButtonDownFcn',{@SGS_pick_group_separators,SGS_UserData},'UIContextMenu',[])
                set(SGS_UserData.fh,'Userdata',SGS_UserData)
            else
                set(SGS_panel,'HighlightColor','w')
                set(SGS_edit,'Enable','off')
                set(SGS_Cancel_pushbutton,'Enable','off')
                set(SGS_Reset_pushbutton,'Enable','off')
                set(SGS_Apply_pushbutton,'Enable','off')
                set(SGS_Load_pushbutton,'Enable','off')
                set(SGS_OK_pushbutton,'Enable','off')
                set(SGS_UserData.tx,'str','');
                SGS_UserData.marked_indy=[];
                SGS_UserData.flag=0;
                SGS_UserData.cm=[];
                SGS_UserData.um=[];
                set(SGS_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
                set(SGS_UserData.lh,'ButtonDownFcn',[],'UIContextMenu',[])
                set(SGS_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
                for trac=1:d_para.num_trains
                    set(SGS_UserData.spike_lh{trac},'ButtonDownFcn',[],'UIContextMenu',[])
                end
                set(SGS_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])

                % ########################################################

                SGN_UserData=SGS_UserData;

                set(SGN_panel,'Visible','on','HighlightColor','k')
                set(SGN_edit,'Visible','on')
                set(SGN_Down_pushbutton,'Visible','on')
                set(SGN_Up_pushbutton,'Visible','on')
                set(SGN_Replace_pushbutton,'Visible','on')
                set(SGN_groups_listbox,'Visible','on')
                set(SGN_names_listbox,'Visible','on')
                set(SGN_Load_pushbutton,'Visible','on')
                set(SGN_Cancel_pushbutton,'Visible','on')
                set(SGN_Reset_pushbutton,'Visible','on')
                set(SGN_OK_pushbutton,'Visible','on','FontWeight','bold')
                uicontrol(SGN_OK_pushbutton)

                set(SGS_edit,'String',num2str(SGN_UserData.group_separators))
                SGN_UserData.group_separators=unique(SGN_UserData.group_separators);
                sep_vect=[0 SGN_UserData.group_separators d_para.num_trains];
                SGN_UserData.all_train_group_sizes=diff(sep_vect);
                
                SGN_UserData.num_all_train_groups=length(SGN_UserData.all_train_group_sizes);
                SGN_UserData.group_first=sep_vect(1:SGN_UserData.num_all_train_groups)+1;
                SGN_UserData.group_last=sep_vect(2:SGN_UserData.num_all_train_groups+1);
                SGN_UserData.groups_str=cell(1,SGN_UserData.num_all_train_groups);
                for stgc=1:SGN_UserData.num_all_train_groups
                    if SGN_UserData.group_first(stgc)==SGN_UserData.group_last(stgc)
                        SGN_UserData.groups_str{stgc}=num2str(SGN_UserData.group_first(stgc));
                    else
                        SGN_UserData.groups_str{stgc}=[num2str(SGN_UserData.group_first(stgc)),' - ',num2str(SGN_UserData.group_last(stgc))];
                    end
                end
                set(SGN_groups_listbox,'string',SGN_UserData.groups_str)
                if length(d_para.all_train_group_names)==SGN_UserData.num_all_train_groups
                    set(SGN_names_listbox,'string',d_para.all_train_group_names)
                    set(SGN_edit,'String',d_para.all_train_group_names{1});
                end
                set(SGN_names_listbox,'value',1)
                set(SGN_UserData.fh,'Userdata',SGN_UserData)
            end
        end
    end


    function SGN_ListBox_callback(varargin)
        figure(f_para.num_fig);
        SGN_UserData=get(gcf,'Userdata');
        SGN_UserData=get(SGN_UserData.fh,'UserData');

        lb_pos=get(SGN_names_listbox,'Value');
        lb_num_strings=length(get(SGN_groups_listbox,'String'));
        lb_strings=get(SGN_names_listbox,'String');
        if isempty(lb_strings)
            lb_strings=cell(1,lb_num_strings);
        end
        if gcbo==SGN_names_listbox
            set(SGN_edit,'String',lb_strings{lb_pos});            
            set(SGN_groups_listbox,'Value',lb_pos);            
        elseif gcbo==SGN_Down_pushbutton
            if lb_pos<lb_num_strings
                dummy=lb_strings{lb_pos+1};
                lb_strings{lb_pos+1}=lb_strings{lb_pos};
                lb_strings{lb_pos}=dummy;
                set(SGN_groups_listbox,'Value',lb_pos+1)
                set(SGN_names_listbox,'Value',lb_pos+1)
            end
        elseif gcbo==SGN_Up_pushbutton
            if lb_pos>1 && ~isempty(lb_strings{lb_pos})
                dummy=lb_strings{lb_pos-1};
                lb_strings{lb_pos-1}=lb_strings{lb_pos};
                lb_strings{lb_pos}=dummy;
                set(SGN_groups_listbox,'Value',lb_pos-1)
                set(SGN_names_listbox,'Value',lb_pos-1)
            end
        elseif gcbo==SGN_Replace_pushbutton
            SGN_str=get(SGN_edit,'String');
            if ~isempty(SGN_str)
                lb_strings{lb_pos}=SGN_str;
            end
        end
        set(SGN_names_listbox,'String',lb_strings)
        lb_pos=get(SGN_names_listbox,'Value');
        if lb_pos>0
            set(SGN_edit,'String',lb_strings{lb_pos})
        else
            lb_pos=1;
            set(SGN_groups_listbox,'Value',lb_pos);
            set(SGN_names_listbox,'Value',lb_pos);
            set(SGN_edit,'String','')
        end
        set(SGN_UserData.fh,'Userdata',SGN_UserData)
    end


    function SGN_Load_group_names(varargin)
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
            SGN_UserData=get(f_para.num_fig,'UserData');
            data.matfile=d_para.matfile;
            data.default_variable='';
            data.content='group names';
            SPIKY('SPIKY_select_variable',gcbo,data,handles)
            variable=getappdata(handles.figure1,'variable');
            if ~isempty(variable) && ~strcmp(variable,'A9ZB1YC8X')
                data=getappdata(handles.figure1,'data');
                SGN_UserData.group_names=data.(variable);
            end
            if ~iscell(SGN_UserData.group_names) || length(SGN_UserData.group_names)~=SGN_UserData.num_all_train_groups
                if ~strcmp(variable,'A9ZB1YC8X')
                    set(0,'DefaultUIControlFontSize',16);
                    if ~iscell(SGN_UserData.group_names)
                        mbh=msgbox(sprintf('No string array has been chosen.\nPlease try again!'),'Warning','warn','modal');
                    else
                        mbh=msgbox(sprintf('The selected string array does not have\n the correct size. Please try again!'),'Warning','warn','modal');
                    end
                    htxt = findobj(mbh,'Type','text');
                    set(htxt,'FontSize',12,'FontWeight','bold')
                    mb_pos=get(mbh,'Position');
                    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
                    uiwait(mbh);
                end
                ret=1;
                return
            end
            set(SGN_names_listbox,'String',SGN_UserData.group_names,'Value',1)
            set(SGN_edit,'String',SGN_UserData.group_names{1})
            set(SGN_UserData.fh,'Userdata',SGN_UserData)
        end
    end


    function SGN_callback(varargin)
        d_para=getappdata(handles.figure1,'data_parameters');
        f_para=getappdata(handles.figure1,'figure_parameters');
        figure(f_para.num_fig);
        SGN_UserData=get(gcf,'Userdata');
        if gcbo==SGN_Reset_pushbutton || gcbo==SGN_Cancel_pushbutton || gcbo==SG_fig
            set(SGN_edit,'string',[])
            set(SGN_names_listbox,'String',[])
            if gcbo==SGN_Reset_pushbutton
                set(SGN_UserData.fh,'Userdata',SGN_UserData)
            elseif gcbo==SGN_Cancel_pushbutton || gcbo==SG_fig
                set(SGN_UserData.fh,'Userdata',SGN_UserData)
                delete(SG_fig)
                set(handles.figure1,'Visible','on')
            end
        elseif gcbo==SGN_OK_pushbutton
            figure(f_para.num_fig);
            set(SGN_UserData.fh,'Userdata',SGN_UserData)
            
            d_para.group_separators=SGN_UserData.group_separators;
            d_para.all_train_group_sizes=diff([0 d_para.group_separators d_para.num_trains]);
            d_para.num_all_train_groups=length(d_para.all_train_group_sizes);
            setappdata(handles.figure1,'data_parameters',d_para)
            set(handles.dpara_group_sizes_edit,'String',regexprep(num2str(d_para.all_train_group_sizes),'\s+',' '))
            d_para_all_train_group_names=get(SGN_names_listbox,'String');
            if d_para.num_all_train_groups>1
                d_para_all_train_group_names_str='';
                for strc=1:numel(d_para.all_train_group_sizes)
                    d_para_all_train_group_names_str=[d_para_all_train_group_names_str,char(d_para_all_train_group_names{strc}),'; '];
                end
                set(handles.dpara_group_names_edit,'String',d_para_all_train_group_names_str)
            end

            set(SGN_OK_pushbutton,'UserData',1)
            set(handles.figure1,'Visible','on')
            delete(SG_fig)
        end
    end


    function SG_Close_callback(varargin)
        figure(f_para.num_fig);
        xlim([s_para.itmin-0.02*s_para.itrange s_para.itmax+0.02*s_para.itrange])
        SG_UserData=get(gcf,'Userdata');
        if isfield(SG_UserData,'lh')
            for cc=1:length(SG_UserData.lh)
                if ishandle(SG_UserData.lh(cc))
                    delete(SG_UserData.lh(cc))
                end
            end
            SG_UserData.lh=[];
        end
        if isfield(SG_UserData,'lh2')
            for rc=1:2
                for cc=1:size(SG_UserData.lh2,2)
                    if ishandle(SG_UserData.lh2(rc,cc))
                        delete(SG_UserData.lh2(rc,cc))
                    end
                end
            end
            SG_UserData.lh2=[];
        end
        SG_UserData.cm=[];
        SG_UserData.um=[];
        set(SG_UserData.fh,'WindowButtonMotionFcn',[],'WindowButtonUpFcn',[],'KeyPressFcn',[])
        set(SG_UserData.ah,'ButtonDownFcn',[],'UIContextMenu',[])
        for trac=1:d_para.num_trains
            set(SGS_UserData.spike_lh{trac},'ButtonDownFcn',[],'UIContextMenu',[])
        end
        set(SG_UserData.image_mh,'ButtonDownFcn',[],'UIContextMenu',[])
        set(SG_UserData.tx,'str','');
        set(SG_UserData.fh,'Userdata',[])
        delete(SG_fig)
        set(handles.figure1,'Visible','on')
    end
end
