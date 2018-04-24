% This checks the input spikes, e.g., it eliminates spikes outside limits as well as double spikes.
% It also converts the input to the format used in SPIKY, e.g., cell arrays with spike times.

ret=0;
if isfield(d_para,'matfile')
    warning('off','MATLAB:load:variableNotFound')
    
    load(d_para.matfile,'spikes')
    if ~exist('spikes','var') || isempty(spikes)
        load(d_para.matfile,'SPIKY_spikes')
        if exist('SPIKY_spikes','var')
            spikes=SPIKY_spikes;
        else
            load(d_para.matfile,'allspikes')
            if exist('allspikes','var')
                spikes=allspikes;
            else
                load(d_para.matfile,'times','indices')
                if exist('times','var') && exist('indices','var')
                    uindices=unique(indices);
                    num_trains=length(uindices);
                    spikes=cell(1,num_trains);
                    for trac=1:num_trains
                        spikes{trac}=times(indices==uindices(trac));
                    end
                else
                    data.matfile=d_para.matfile;
                    data.default_variable=d_para.spikes_variable;
                    data.content='spike times';
                    matfile_data=load(d_para.matfile); 
                    variables=fieldnames(matfile_data);
                    if length(variables)==1 && ~isstruct(matfile_data.(variables{1}))
                        variable=variables{1};
                        data=matfile_data;
                    else
                        SPIKY('SPIKY_select_variable',gcbo,data,guidata(gcbo))
                        handy=guidata(gcbo);
                        variable=getappdata(handy.figure1,'variable');
                        data=getappdata(handy.figure1,'data');
                    end

                    if ~isempty(variable) && ~strcmp(variable,'A9ZB1YC8X')
                        variable=['data.',variable];
                        if iscell(eval(variable)) && size(eval(variable),2)>1
                            spikes=squeeze(eval(variable));
                        else
                            lp=find(variable=='.',1,'last');
                            if ~isempty(lp)
                                spik_var=variable(1:lp-1);
                                %disp([ 'num_trains=size(',spik_var,',2);' ])
                                eval([ 'num_trains=size(',spik_var,',2);' ])
                            end
                            %disp([ '[spikes{1:num_trains}] = deal(',variable,');' ]);
                            clear spikes
                            if exist('num_trains','var')
                                eval([ '[spikes{1:num_trains}] = deal(',variable,');' ]);
                            end
                        end
                    end
                end
            end
        end
    end
    
    if ~exist('spikes','var') || isempty(spikes) || ~((iscell(spikes) && length(spikes)>1 && isnumeric(spikes{1})) || ...
            (isnumeric(spikes) && ndims(spikes)==2 && size(spikes,1)>1) || ...
            (iscell(spikes) && length(spikes)==1 && ndims(spikes{1})==2 && size(spikes{1},1)>1 && isnumeric(spikes{1})))
        if ~strcmp(variable,'A9ZB1YC8X')
            set(0,'DefaultUIControlFontSize',16);
            mbh=msgbox(sprintf('No variable with spikes has been specified. Please try again!'),'Warning','warn','modal');
            htxt = findobj(mbh,'Type','text');
            set(htxt,'FontSize',12,'FontWeight','bold')
            mb_pos=get(mbh,'Position');
            set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
            uiwait(mbh);
        end
        ret=1;
        return
    end
    
    dummy=load(d_para.matfile,'d_para');
    if ~isempty(fieldnames(dummy))
        dn=fieldnames(dummy.d_para);
        for fnc=1:size(dn)
            if strcmp(dn{fnc},'dt')
                d_para.dts=dummy.d_para.(dn{fnc});
            else
                d_para.(dn{fnc})=dummy.d_para.(dn{fnc});
            end
        end
    else
        load(d_para.matfile,'tmin')
        if exist('tmin','var') && isnumeric(tmin) && numel(tmin)==1
            d_para.tmin=tmin;
        end
        load(d_para.matfile,'tmax')
        if exist('tmax','var') && isnumeric(tmax) && numel(tmax)==1
            d_para.tmax=tmax;
        end
        load(d_para.matfile,'dts')
        if exist('dts','var') && isnumeric(dts) && numel(dts)==1
            d_para.dts=dts;
        end
        load(d_para.matfile,'thick_markers')
        if exist('thick_markers','var')
            dummy=squeeze(thick_markers);
            if isnumeric(dummy) && ndims(dummy)==2 && max(size(dummy))==numel(dummy)
                d_para.thick_markers=dummy;
            end
        end
        load(d_para.matfile,'thin_markers')
        if exist('thin_markers','var')
            dummy=squeeze(thin_markers);
            if isnumeric(dummy) && ndims(dummy)==2 && max(size(dummy))==numel(dummy)
                d_para.thin_markers=dummy;
            end
        end
        load(d_para.matfile,'thick_separators')
        if exist('thick_separators','var')
            dummy=squeeze(thick_separators);
            if isnumeric(dummy) && ndims(dummy)==2 && max(size(dummy))==numel(dummy)
                d_para.thick_separators=dummy;
            end
        end
        load(d_para.matfile,'thin_separators')
        if exist('thin_separators','var')
            dummy=squeeze(thin_separators);
            if isnumeric(dummy) && ndims(dummy)==2 && max(size(dummy))==numel(dummy)
                d_para.thin_separators=dummy;
            end
        end
        load(d_para.matfile,'all_train_group_sizes')
        if exist('all_train_group_sizes','var')
            dummy=squeeze(all_train_group_sizes);
            if isnumeric(dummy) && ndims(dummy)==2 && max(size(dummy))==numel(dummy)
                d_para.all_train_group_sizes=dummy;
            end
        end
        load(d_para.matfile,'all_train_group_names')
        if exist('all_train_group_names','var')
            d_para.all_train_group_names=all_train_group_names;
        end
        load(d_para.matfile,'instants')
        if exist('instants','var')
            dummy=squeeze(instants);
            if isnumeric(dummy) && ndims(dummy)==2 && max(size(dummy))==numel(dummy)
                d_para.instants=dummy;
            end
        end
        load(d_para.matfile,'selective_averages')
        if exist('selective_averages','var')
            d_para.selective_averages=selective_averages;
        end
        load(d_para.matfile,'triggered_averages')
        if exist('triggered_averages','var')
            d_para.triggered_averages=triggered_averages;
        end
        load(d_para.matfile,'interval_divisions')
        if exist('interval_divisions','var')
            dummy=squeeze(interval_divisions);
            if isnumeric(dummy) && ndims(dummy)==2 && max(size(dummy))==numel(dummy)
                d_para.interval_divisions=dummy;
            end
        end
        load(d_para.matfile,'interval_names')
        if exist('interval_names','var')
            d_para.interval_names=interval_names;
        end
    end
    
    warning('on','MATLAB:load:variableNotFound')    
end

if ~isfield(d_para,'dts')
    d_para.dts=[];
end
if ~isfield(d_para,'tmin')
    d_para.tmin=[];
end

spikes=SPIKY_f_convert_matrix(spikes,d_para.dts,d_para.tmin);

sizes=cellfun(@size,spikes,'un',0);
mindim=cellfun(@min,sizes,'un',0);
if (prod([mindim{:}]) == 1)
    spikes(cellfun('size',spikes,1)>1)=cellfun(@transpose,spikes(cellfun('size',spikes,1)>1),'un',0); %transposition of nx1 elements
    % spikes=cellfun(@transpose,spikes,'un',0); % all cells are transformed
end

if ~isfield(d_para,'dts') || isempty(d_para.dts)
    d_para.dts=SPIKY_f_get_dt(unique([spikes{:}])');
end
if ~isfield(d_para,'max_total_spikes') || isempty(d_para.max_total_spikes)
    d_para.max_total_spikes=100000;
end
dummy=0;
if ~isfield(d_para,'tmin') || isempty(d_para.tmin)
    d_para.tmin=min([spikes{:}]);
    dummy=dummy+1;
end
if ~isfield(d_para,'tmax') || isempty(d_para.tmax)
    d_para.tmax=max([spikes{:}]);
    dummy=dummy+2;
end
if dummy==3
    d_para.tmin=d_para.tmin-0.001*(d_para.tmax-d_para.tmin);
    d_para.tmax=d_para.tmax+0.001*(d_para.tmax-d_para.tmin);
end
d_para.tmin=round(d_para.tmin/d_para.dts)*d_para.dts;
d_para.tmax=round(d_para.tmax/d_para.dts)*d_para.dts;

for trac=1:length(spikes)
    if isfield(d_para,'tmin') && ~isempty(d_para.tmin)
        spikes{trac}=spikes{trac}(spikes{trac}>=d_para.tmin-1e-14);  % ####
    end
    if isfield(d_para,'tmax') && ~isempty(d_para.tmax)
        spikes{trac}=spikes{trac}(spikes{trac}<=d_para.tmax+1e-14);  % ####
    end
    if isfield(d_para,'dts') && ~isempty(d_para.dts)
        spikes{trac}=unique(round(spikes{trac}/d_para.dts)*d_para.dts);
    end
end

d_para.num_all_trains=length(spikes);
d_para.num_trains=d_para.num_all_trains;
d_para.preselect_trains=1:d_para.num_trains;

if d_para.num_trains<2
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('At least two spike trains are needed in order to\n quantify spike train synchrony!'),'Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    ret=1;
    return
end

if d_para.tmin>=d_para.tmax
    set(0,'DefaultUIControlFontSize',16);
    mbh=msgbox(sprintf('T_min must be larger than T_max!'),'Warning','warn','modal');
    htxt = findobj(mbh,'Type','text');
    set(htxt,'FontSize',12,'FontWeight','bold')
    mb_pos=get(mbh,'Position');
    set(mbh,'Position',[mb_pos(1:2) mb_pos(3)*1.5 mb_pos(4)])
    uiwait(mbh);
    ret=1;
    return
end

num_spikes=cellfun('length',spikes);
d_para.num_total_spikes=sum(num_spikes);
if d_para.num_total_spikes>d_para.max_total_spikes && exist('f_para','var')
    data.spikes=spikes;
    SPIKY('SPIKY_select_spikes',gcbo,data,d_para,guidata(gcbo))
    handy=guidata(gcbo);
    ss_para=getappdata(handy.figure1,'ss_para');
    if isempty(ss_para.select_trains)
        ret=1;
        return
    end
    spikes=spikes(ss_para.select_trains);
    if ss_para.wmin>d_para.tmin || ss_para.wmax<d_para.tmax
        for trac=1:length(spikes)
            spikes{trac}=spikes{trac}(spikes{trac}>=ss_para.wmin & spikes{trac}<=ss_para.wmax)-ss_para.wmin;
        end
    end
    spikes=spikes(cellfun('length',spikes)>0);
    d_para.tmin=0;
    d_para.tmax=ss_para.wmax-ss_para.wmin;
    num_spikes=cellfun('length',spikes);
    d_para.num_total_spikes=sum(num_spikes);
end

d_para.num_all_trains=length(spikes);
d_para.num_trains=d_para.num_all_trains;
d_para.preselect_trains=1:d_para.num_trains;
