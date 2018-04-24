% This initializes the matrices (in particular the selective and triggered averages) for the frame comparison and the
% frame sequence (once the 'Plot' button is pressed and if either 'Frame comparison' or 'Frame sequence (movie)' is checked.

if d_para.num_selective_averages>0
    f_para.selective_averages=cell(1,d_para.num_selective_averages);
    for sac=1:d_para.num_selective_averages
        for selc=1:d_para.num_sel_ave(sac)
            if d_para.selective_averages{sac}(2*selc-1)<f_para.tmax && d_para.selective_averages{sac}(2*selc)>f_para.tmin
                f_para.selective_averages{sac}=[f_para.selective_averages{sac} max([d_para.selective_averages{sac}(2*selc-1) f_para.tmin]) ...
                    min([d_para.selective_averages{sac}(2*selc) f_para.tmax])];
            end
        end
    end
    f_para.selective_averages=f_para.selective_averages(cellfun('length',f_para.selective_averages)>0);
    f_para.num_selective_averages=length(f_para.selective_averages);
else
    f_para.num_selective_averages=0;
end

if m_para.num_sel_cont_bi_measures>0
    if d_para.num_instants>0
        f_para.instants=d_para.instants(d_para.instants>=f_para.tmin & d_para.instants<=f_para.tmax);
        f_para.num_instants=length(f_para.instants);
    else
        f_para.instants=[];
        f_para.num_instants=0;
    end
    
    if d_para.num_triggered_averages>0
        f_para.triggered_averages=cell(1,d_para.num_triggered_averages);
        for tac=1:d_para.num_triggered_averages
            f_para.triggered_averages{tac}=d_para.triggered_averages{tac}(d_para.triggered_averages{tac}>=f_para.tmin & ...
                d_para.triggered_averages{tac}<=f_para.tmax);
        end
        f_para.triggered_averages=f_para.triggered_averages(cellfun('length',f_para.triggered_averages)>0);
        f_para.num_triggered_averages=length(f_para.triggered_averages);
    else
        f_para.num_triggered_averages=0;
    end
else
    f_para.instants=[];
    f_para.num_instants=0;
    f_para.num_triggered_averages=0;
end

ret=0;
f_para.num_frames=f_para.num_instants+f_para.num_selective_averages+f_para.num_triggered_averages;
if f_para.num_frames>0
    if f_para.num_selective_averages>0
        m_res.movie_vects_sa=zeros(m_para.num_sel_bi_measures,f_para.num_select_pairs,f_para.num_selective_averages);
        if m_para.num_disc_measures>0
            m_res.movie_vects_sa_disc_norm=zeros(f_para.num_select_pairs,f_para.num_selective_averages);
        end
        if m_para.num_pili_measures>0
            m_res.movie_vects_sa_pili_weight=zeros(f_para.num_selective_averages,r_para.num_runs);
        end
        if m_para.num_pico_measures>0
            m_res.movie_vects_sa_pico_weight=zeros(f_para.num_selective_averages,r_para.num_runs);
        end
        f_para.num_sel_ave=zeros(1,f_para.num_selective_averages);
        for sac=1:f_para.num_selective_averages
            f_para.num_sel_ave(sac)=length(f_para.selective_averages{sac})/2;
        end
        sel_ave_weight=zeros(f_para.num_selective_averages,max(f_para.num_sel_ave));
        for sac=1:f_para.num_selective_averages
            for selc=1:f_para.num_sel_ave(sac)
                sel_ave_weight(sac,selc)=diff(f_para.selective_averages{sac}(2*selc-1:2*selc));
            end
        end
    end
    
    if m_para.num_sel_cont_bi_measures>0
        if f_para.num_instants>0
            m_res.movie_vects=zeros(m_para.num_sel_bi_measures,f_para.num_select_pairs,f_para.num_instants);
        end
        
        if f_para.num_triggered_averages>0
            m_res.movie_vects_ta=zeros(m_para.num_sel_bi_measures,f_para.num_select_pairs,f_para.num_triggered_averages);
            if m_para.num_pili_measures>0
                m_res.movie_vects_ta_pili_weight=zeros(f_para.num_triggered_averages,r_para.num_runs);
            end
            if m_para.num_pico_measures>0
                m_res.movie_vects_ta_pico_weight=zeros(f_para.num_triggered_averages,r_para.num_runs);
            end
        end
    end
    
    % #######################################################################################################################
    % ##################################################### pico & pili #####################################################
    % #######################################################################################################################
    
    if m_para.memo_num_measures>0                           % ##### pico & pili #####
        
        if r_para.num_runs>1
            disp(' ')
            disp(['Number of matrix loop runs: ',num2str(r_para.num_runs)])
            pwbh = waitbar(0,'Large data set. Please be patient.','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
            setappdata(pwbh,'canceling',0)
        end
        for ruc=1:r_para.num_runs
            if r_para.num_runs>1 && getappdata(pwbh,'canceling')
                delete(pwbh)
                return
            end
            if ruc~=r_para.ruc
                if min_ruc~=1 || max_ruc~=r_para.num_runs
                    disp(['Matrix-Loop-Info = ',num2str(ruc),'  (',num2str(r_para.num_runs),') --- ',...
                        num2str(ruc-min_ruc+1  ),'  (',num2str(max_ruc-min_ruc+1),')'])
                else
                    disp(['Matrix-Loop-Info = ',num2str(ruc),'  (',num2str(r_para.num_runs),')'])
                end
                if m_para.num_disc_measures>0
                    load(['SPIKY_AZBYCX', num2str(ruc)],['disc_',num2str(ruc)]);
                    eval(['m_res.disc_measures_mat = disc_',num2str(ruc),';']);
                    eval(['clear disc_',num2str(ruc),';']);
                end
                if m_para.num_pico_measures>0
                    load(['SPIKY_AZBYCX', num2str(ruc)],['pico_',num2str(ruc)]);
                    eval(['m_res.pico_measures_mat = pico_',num2str(ruc),';']);
                    eval(['clear pico_',num2str(ruc),';']);
                end
                if m_para.num_pili_measures>0
                    load(['SPIKY_AZBYCX', num2str(ruc)],['pili_',num2str(ruc)]);
                    eval(['m_res.pili_measures_mat = pili_',num2str(ruc) ';']);
                    eval(['clear pili_',num2str(ruc),';']);
                end
                r_para.ruc=ruc;
                waitbar(ruc/r_para.num_runs,pwbh,['Matrix-Loop-Info: ',num2str(ruc),'  (',num2str(r_para.num_runs),')'])
                if ruc==r_para.num_runs
                    delete(pwbh)
                end
            end
            
            % #######################################################################################################################
            % ################################################### disc ###############################################################
            % #######################################################################################################################
            
            if m_para.num_disc_measures>0 && f_para.num_selective_averages>0
                for pmatc=1:m_para.num_disc_measures
                    matc=find(m_para.select_measures==m_para.select_disc_measures(pmatc));
                    matc2=m_para.measure_bi_indy(m_para.select_measures(matc));
                    matc3=m_para.measure_indy(m_para.select_measures(matc));
                    if ruc==1
                        m_res.cum_all_isi=cumsum([d_para.tmin m_res.all_isi]);
                    end
                    for sac=1:f_para.num_selective_averages
                        for selc=1:f_para.num_sel_ave(sac)
                            pfx=m_res.cum_all_isi(r_para.run_disc_starts(ruc):r_para.run_disc_ends(ruc));
                            pfy=shiftdim(m_res.disc_measures_mat(matc3,f_para.select_pairs,1:r_para.run_disc_lengths(ruc)),1);
                            sel_indy=find(pfx>d_para.tmin & pfx>=f_para.selective_averages{sac}(2*selc-1) & pfx<=f_para.selective_averages{sac}(2*selc) & pfx<d_para.tmax);
                            m_res.movie_vects_sa(matc2,1:f_para.num_select_pairs,sac)=m_res.movie_vects_sa(matc2,1:f_para.num_select_pairs,sac)+sum(pfy(:,sel_indy),2)';
                            if pmatc==1
                                m_res.movie_vects_sa_disc_norm(:,sac)=m_res.movie_vects_sa_disc_norm(:,sac)+...
                                    sum(m_res.all_pos_spikes(ti_col,r_para.run_disc_starts(ruc)-1+sel_indy)+...
                                    m_res.all_pos_spikes(ti_row,r_para.run_disc_starts(ruc)-1+sel_indy),2);
                            end
                        end
                    end
                    clear pfx pfy
                end
            end
            
            % #######################################################################################################################
            % ################################################## pili ###############################################################
            % #######################################################################################################################
            
            if m_para.num_pili_measures>0
                if f_para.num_instants>0
                    abs_run_instants_indy=find(f_para.instants>m_res.pili_supi(r_para.run_pili_starts(ruc)) & ...
                        f_para.instants<=m_res.pili_supi(r_para.run_pili_ends(ruc)));
                    run_instants=f_para.instants(abs_run_instants_indy)-m_res.pili_supi(r_para.run_pili_starts(ruc));
                    num_run_instants=length(run_instants);
                    run_pili_supi=m_res.pili_supi(r_para.run_pili_starts(ruc):r_para.run_pili_ends(ruc))-m_res.pili_supi(r_para.run_pili_starts(ruc));
                else
                    num_run_instants=0;
                end
                
                for lmatc=1:m_para.num_pili_measures
                    matc=find(m_para.select_measures==m_para.select_pili_measures(lmatc));
                    matc2=m_para.measure_bi_indy(m_para.select_measures(matc));
                    matc3=m_para.measure_indy(m_para.select_measures(matc));
                    %lll=[lmatc matc matc2 matc3]
                    
                    if num_run_instants>0
                        if lmatc==1
                            ilind=zeros(1,num_run_instants);
                            for ric=1:num_run_instants
                                dummy=find(run_pili_supi<run_instants(ric),1,'last');
                                if ~isempty(dummy)
                                    ilind(ric)=dummy;
                                else
                                    ilind(ric)=1;
                                end
                            end
                        end
                        if ismember(m_para.select_pili_measures(lmatc),m_para.spike_pili)                % regular
                            m_res.movie_vects(matc2,1:f_para.num_select_pairs,abs_run_instants_indy)=...
                                m_res.pili_measures_mat(matc3,f_para.select_pairs,ilind)+...
                                (m_res.pili_measures_mat(matc3,f_para.select_pairs,ilind+1)-m_res.pili_measures_mat(matc3,f_para.select_pairs,ilind)).*...
                                shiftdim(repmat((run_instants-run_pili_supi(ilind))./(run_pili_supi(ilind+1)-run_pili_supi(ilind)),f_para.num_select_pairs,1),-1);
                        else                                                                            % realtime, forward
                            m_res.movie_vects(matc2,1:f_para.num_select_pairs,abs_run_instants_indy)=...
                                1./(1./m_res.pili_measures_mat(matc3,f_para.select_pairs,ilind)+...
                                (1./(m_res.pili_measures_mat(matc3,f_para.select_pairs,ilind+1)+(m_res.pili_measures_mat(matc3,f_para.select_pairs,ilind+1)==0))-...
                                1./(m_res.pili_measures_mat(matc3,f_para.select_pairs,ilind)+(m_res.pili_measures_mat(matc3,f_para.select_pairs,ilind)==0))).*...
                                shiftdim(repmat((run_instants-run_pili_supi(ilind))./(run_pili_supi(ilind+1)-run_pili_supi(ilind)),f_para.num_select_pairs,1),-1));
                        end
                    end
                    
                    if f_para.num_selective_averages>0
                        for sac=1:f_para.num_selective_averages
                            for selc=1:f_para.num_sel_ave(sac)
                                if ismember(m_para.select_pili_measures(lmatc),m_para.spike_pili)       % regular
                                    pfx=m_res.pili_supi([r_para.run_pili_starts(ruc):2:r_para.run_pili_ends(ruc)-1 r_para.run_pili_ends(ruc)]);
                                    pfy=shiftdim(m_res.pili_measures_mat(matc3,f_para.select_pairs,1:r_para.run_pili_lengths(ruc)),1);
                                    ave=SPIKY_f_selective_averaging(pfx,pfy,max([f_para.selective_averages{sac}(2*selc-1) pfx(1)]),...
                                        min([f_para.selective_averages{sac}(2*selc) pfx(end)]));
                                    m_res.movie_vects_sa_pili_weight(sac,ruc)=...
                                        min([f_para.selective_averages{sac}(2*selc) pfx(end)])-max([f_para.selective_averages{sac}(2*selc-1) pfx(1)]);
                                    m_res.movie_vects_sa(matc2,1:f_para.num_select_pairs,sac)=...   % $$$$$$$$$$$
                                        m_res.movie_vects_sa(matc2,1:f_para.num_select_pairs,sac)+...
                                        ave'*m_res.movie_vects_sa_pili_weight(sac,ruc)*sel_ave_weight(sac,selc);
                                else                                                                            % realtime, forward
                                    pfx=m_res.pili_supi(r_para.run_pili_starts(ruc):r_para.run_pili_ends(ruc));
                                    pfy=shiftdim(m_res.pili_measures_mat(matc3,f_para.select_pairs,1:r_para.run_pili_lengths(ruc)),1);
                                    first_pili_supi_ind=find(pfx(1:2:end)>=f_para.selective_averages{sac}(2*selc-1),1,'first')*2-1;  % first inside interval
                                    last_pili_supi_ind=find(pfx(2:2:end)<=f_para.selective_averages{sac}(2*selc),1,'last')*2;      % last inside interval
                                    if ~isempty(first_pili_supi_ind) && ~isempty(last_pili_supi_ind)
                                        if first_pili_supi_ind<last_pili_supi_ind
                                            dpfx=pfx(first_pili_supi_ind:last_pili_supi_ind);
                                            dpfy=pfy(:,first_pili_supi_ind:last_pili_supi_ind);
                                            if first_pili_supi_ind>1 && f_para.selective_averages{sac}(2*selc-1)<dpfx(1)-d_para.dts/999 && ...
                                                    f_para.selective_averages{sac}(2*selc-1)>=m_res.cum_isi(r_para.run_pico_starts(ruc))  % interval to first spike
                                                dpfx=[f_para.selective_averages{sac}(2*selc-1) pfx(first_pili_supi_ind-1) dpfx];
                                                dpfy_m=1./(1./m_res.pili_measures_mat(matc3,f_para.select_pairs,first_pili_supi_ind-2)+...
                                                    (1./(m_res.pili_measures_mat(matc3,f_para.select_pairs,first_pili_supi_ind-1)+...
                                                    (m_res.pili_measures_mat(matc3,f_para.select_pairs,first_pili_supi_ind-1)==0))-...
                                                    1./(m_res.pili_measures_mat(matc3,f_para.select_pairs,first_pili_supi_ind-2)+...
                                                    (m_res.pili_measures_mat(matc3,f_para.select_pairs,first_pili_supi_ind-2)==0))).*...
                                                    shiftdim(repmat((f_para.selective_averages{sac}(2*selc-1)-pfx(first_pili_supi_ind-2))./...
                                                    (pfx(first_pili_supi_ind-1)-pfx(first_pili_supi_ind-2)),f_para.num_select_pairs,1),-1))';
                                                dpfy=cat(2,dpfy_m,pfy(:,first_pili_supi_ind-1),dpfy);
                                            end
                                            if last_pili_supi_ind<length(pfx) && f_para.selective_averages{sac}(2*selc)>dpfx(end)+d_para.dts/999 && ...
                                                    f_para.selective_averages{sac}(2*selc)<=m_res.cum_isi(r_para.run_pico_ends(ruc)+1)   % interval after last spike
                                                dpfx=[dpfx pfx(last_pili_supi_ind+1) f_para.selective_averages{sac}(2*selc)];
                                                dpfy_p=1./(1./m_res.pili_measures_mat(matc3,f_para.select_pairs,last_pili_supi_ind+1)+...
                                                    (1./(m_res.pili_measures_mat(matc3,f_para.select_pairs,last_pili_supi_ind+2)+...
                                                    (m_res.pili_measures_mat(matc3,f_para.select_pairs,last_pili_supi_ind+2)==0))-...
                                                    1./(m_res.pili_measures_mat(matc3,f_para.select_pairs,last_pili_supi_ind+1)+...
                                                    (m_res.pili_measures_mat(matc3,f_para.select_pairs,last_pili_supi_ind+1)==0))).*...
                                                    shiftdim(repmat((f_para.selective_averages{sac}(2*selc)-pfx(last_pili_supi_ind+1))./...
                                                    (pfx(last_pili_supi_ind+2)-pfx(last_pili_supi_ind+1)),f_para.num_select_pairs,1),-1))';
                                                dpfy=cat(2,dpfy,pfy(:,last_pili_supi_ind+1),dpfy_p);
                                            end
                                        else
                                            first_pili_supi_ind=first_pili_supi_ind-2;
                                            last_pili_supi_ind=last_pili_supi_ind+2;
                                            dpfx=f_para.selective_averages{sac}(2*selc-1:2*selc);
                                            dpfy_m=1./(1./m_res.pili_measures_mat(matc3,f_para.select_pairs,first_pili_supi_ind)+...
                                                (1./(m_res.pili_measures_mat(matc3,f_para.select_pairs,last_pili_supi_ind)+...
                                                (m_res.pili_measures_mat(matc3,f_para.select_pairs,last_pili_supi_ind)==0))-...
                                                1./(m_res.pili_measures_mat(matc3,f_para.select_pairs,first_pili_supi_ind)+...
                                                (m_res.pili_measures_mat(matc3,f_para.select_pairs,first_pili_supi_ind)==0))).*...
                                                shiftdim(repmat((f_para.selective_averages{sac}(2*selc-1)-pfx(first_pili_supi_ind))./...
                                                (pfx(last_pili_supi_ind)-pfx(first_pili_supi_ind)),f_para.num_select_pairs,1),-1));
                                            dpfy_p=1./(1./m_res.pili_measures_mat(matc3,f_para.select_pairs,first_pili_supi_ind)+...
                                                (1./(m_res.pili_measures_mat(matc3,f_para.select_pairs,last_pili_supi_ind)+...
                                                (m_res.pili_measures_mat(matc3,f_para.select_pairs,last_pili_supi_ind)==0))-...
                                                1./(m_res.pili_measures_mat(matc3,f_para.select_pairs,first_pili_supi_ind)+...
                                                (m_res.pili_measures_mat(matc3,f_para.select_pairs,first_pili_supi_ind)==0))).*...
                                                shiftdim(repmat((f_para.selective_averages{sac}(2*selc)-pfx(first_pili_supi_ind))./...
                                                (pfx(last_pili_supi_ind)-pfx(first_pili_supi_ind)),f_para.num_select_pairs,1),-1));
                                            dpfy=cat(2,dpfy_m',dpfy_p');
                                        end
                                        if length(dpfx)>1
                                            odds=1:2:length(dpfx);
                                            evens=odds+1;
                                            isi=diff(dpfx([odds(1) evens]));
                                            aves=(log(1./dpfy(1:f_para.num_select_pairs,evens))-log(1./dpfy(1:f_para.num_select_pairs,odds)))./...
                                                (1./dpfy(1:f_para.num_select_pairs,evens)-1./dpfy(1:f_para.num_select_pairs,odds));
                                            aves(isnan(aves))=0;
                                            ave=sum(aves.*repmat(isi,f_para.num_select_pairs,1),2)/sum(isi);
                                            m_res.movie_vects_sa_pili_weight(sac,ruc)=sum(isi);
                                            m_res.movie_vects_sa(matc2,1:f_para.num_select_pairs,sac)=...
                                                m_res.movie_vects_sa(matc2,1:f_para.num_select_pairs,sac)+...
                                                ave'*m_res.movie_vects_sa_pili_weight(sac,ruc)*sel_ave_weight(sac,selc);
                                        end
                                    end
                                end
                            end
                        end
                        clear pfx; clear pfy;
                    end
                    
                    if f_para.num_triggered_averages>0
                        for tac=1:f_para.num_triggered_averages
                            trig_indy=find(f_para.triggered_averages{tac}>=m_res.pili_supi(r_para.run_pili_starts(ruc)) & ...
                                f_para.triggered_averages{tac}<=m_res.pili_supi(r_para.run_pili_ends(ruc)));
                            if ~isempty(trig_indy)
                                tlind=zeros(1,length(trig_indy));
                                for ric=1:length(trig_indy)
                                    dummy=find(m_res.pili_supi(r_para.run_pili_starts(ruc):r_para.run_pili_ends(ruc))<...
                                        f_para.triggered_averages{tac}(trig_indy(ric)),1,'last');
                                    if ~isempty(dummy)
                                        tlind(ric)=dummy;
                                    else
                                        tlind(ric)=1;
                                    end
                                end
                                m_res.movie_vects_ta_pili_weight(tac,ruc)=length(trig_indy);
                                if ismember(m_para.select_pili_measures(lmatc),m_para.spike_pili)       % regular
                                    m_res.movie_vects_ta(matc2,1:f_para.num_select_pairs,tac)=...
                                        m_res.movie_vects_ta(matc2,1:f_para.num_select_pairs,tac)+...
                                        mean( m_res.pili_measures_mat(matc3,f_para.select_pairs,tlind)+...
                                        (m_res.pili_measures_mat(matc3,f_para.select_pairs,tlind+1)-m_res.pili_measures_mat(matc3,f_para.select_pairs,tlind)).*...
                                        shiftdim(repmat((f_para.triggered_averages{tac}(trig_indy)-m_res.pili_supi(r_para.run_pili_starts(ruc)+tlind-1))./...
                                        (m_res.pili_supi(r_para.run_pili_starts(ruc)+tlind)-m_res.pili_supi(r_para.run_pili_starts(ruc)+tlind-1)),f_para.num_select_pairs,1),-1),3)*...
                                        m_res.movie_vects_ta_pili_weight(tac,ruc);
                                else                                                                            % realtime, forward
                                    m_res.movie_vects_ta(matc2,1:f_para.num_select_pairs,tac)=...
                                        m_res.movie_vects_ta(matc2,1:f_para.num_select_pairs,tac)+...
                                        mean( 1./(1./m_res.pili_measures_mat(matc3,f_para.select_pairs,tlind)+...
                                        (1./(m_res.pili_measures_mat(matc3,f_para.select_pairs,tlind+1)+(m_res.pili_measures_mat(matc3,f_para.select_pairs,tlind+1)==0))-...
                                        1./(m_res.pili_measures_mat(matc3,f_para.select_pairs,tlind)+(m_res.pili_measures_mat(matc3,f_para.select_pairs,tlind)==0))).*...
                                        shiftdim(repmat((f_para.triggered_averages{tac}(trig_indy)-m_res.pili_supi(r_para.run_pili_starts(ruc)+tlind-1))./...
                                        (m_res.pili_supi(r_para.run_pili_starts(ruc)+tlind)-m_res.pili_supi(r_para.run_pili_starts(ruc)+tlind-1)),f_para.num_select_pairs,1),-1)) ,3)*...
                                        m_res.movie_vects_ta_pili_weight(tac,ruc);
                                end
                            end
                        end
                    end
                end
            end
            
            % #######################################################################################################################
            % ################################################## pico ###############################################################
            % #######################################################################################################################
            
            if m_para.num_pico_measures>0                                            % ##### pico #####
                
                if f_para.num_instants>0
                    abs_run_instants_indy=find(f_para.instants>m_res.cum_isi(r_para.run_pico_starts(ruc)) & ...
                        f_para.instants<=m_res.cum_isi(r_para.run_pico_ends(ruc)+1));
                    run_instants=f_para.instants(abs_run_instants_indy); %-m_res.pili_supi(r_para.run_pili_starts(ruc));
                    num_run_instants=length(run_instants);
                else
                    num_run_instants=0;
                end
                
                for pmatc=1:m_para.num_pico_measures
                    matc=find(m_para.select_measures==m_para.select_pico_measures(pmatc));
                    matc2=m_para.measure_bi_indy(m_para.select_measures(matc));
                    matc3=m_para.measure_indy(m_para.select_measures(matc));
                    %ppp=[pmatc matc matc2 matc3]
                    
                    if num_run_instants>0                                           % pico not very precise for instants
                        if pmatc==1
                            ipind=zeros(1,num_run_instants);
                            for ric=1:num_run_instants
                                dummy=find(m_res.cum_isi(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc))<run_instants(ric),1,'last');
                                if ~isempty(dummy)
                                    ipind(ric)=dummy;
                                else
                                    ipind(ric)=1;
                                end
                            end
                        end
                        m_res.movie_vects(matc2,1:f_para.num_select_pairs,abs_run_instants_indy)=...
                            m_res.pico_measures_mat(matc3,f_para.select_pairs,ipind);
                    end
                    if f_para.num_selective_averages>0                              % pico not very precise for selective averages
                        for sac=1:f_para.num_selective_averages
                            for selc=1:f_para.num_sel_ave(sac)
                                pfx=m_res.cum_isi(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc)+1);
                                pfy=reshape([shiftdim(m_res.pico_measures_mat(matc3,f_para.select_pairs,1:r_para.run_pico_lengths(ruc)),1); ...
                                    shiftdim(m_res.pico_measures_mat(matc3,f_para.select_pairs,1:r_para.run_pico_lengths(ruc)),1)],...
                                    f_para.num_select_pairs,r_para.run_pico_lengths(ruc)*2);
                                ave=SPIKY_f_selective_averaging(pfx,pfy,max([f_para.selective_averages{sac}(2*selc-1) pfx(1)]),...
                                    min([f_para.selective_averages{sac}(2*selc) pfx(end)]));
                                m_res.movie_vects_sa_pico_weight(sac,ruc)=...
                                    min([f_para.selective_averages{sac}(2*selc) pfx(end)])-max([f_para.selective_averages{sac}(2*selc-1) pfx(1)]);
                                m_res.movie_vects_sa(matc2,1:f_para.num_select_pairs,sac)=...
                                    m_res.movie_vects_sa(matc2,1:f_para.num_select_pairs,sac)+...
                                    ave'*m_res.movie_vects_sa_pico_weight(sac,ruc)*sel_ave_weight(sac,selc);
                            end
                        end
                        clear pfx; clear pfy;
                    end
                    if f_para.num_triggered_averages>0                              % pico not very precise for instants
                        for tac=1:f_para.num_triggered_averages
                            trig_indy=find(f_para.triggered_averages{tac}>m_res.cum_isi(r_para.run_pico_starts(ruc)) & ...
                                f_para.triggered_averages{tac}<=m_res.cum_isi(r_para.run_pico_ends(ruc)));
                            if ~isempty(trig_indy)
                                tpind=zeros(1,length(trig_indy));
                                for ric=1:length(trig_indy)
                                    dummy=find(m_res.cum_isi(r_para.run_pico_starts(ruc):r_para.run_pico_ends(ruc))<...
                                        f_para.triggered_averages{tac}(trig_indy(ric)),1,'last');
                                    if ~isempty(dummy)
                                        tpind(ric)=dummy;
                                    else
                                        tpind(ric)=1;
                                    end
                                end
                                m_res.movie_vects_ta_pico_weight(tac,ruc)=length(trig_indy);
                                m_res.movie_vects_ta(matc2,1:f_para.num_select_pairs,tac)=...
                                    m_res.movie_vects_ta(matc2,1:f_para.num_select_pairs,tac)+...
                                    mean(m_res.pico_measures_mat(matc3,f_para.select_pairs,tpind),3)*...
                                    m_res.movie_vects_ta_pico_weight(tac,ruc);
                            end
                        end
                    end
                end
            end
        end
    end
    
    
    % #######################################################################################################################
    % ################################################## Normalizations #####################################################
    % #######################################################################################################################
    
    if f_para.num_selective_averages>0
        if m_para.num_disc_measures>0
            m_res.movie_vects_sa(m_para.disc_bi_measures_indy,1:f_para.num_select_pairs,1:f_para.num_selective_averages)=...
                m_res.movie_vects_sa(m_para.disc_bi_measures_indy,1:f_para.num_select_pairs,1:f_para.num_selective_averages)./...
                repmat(shiftdim(m_res.movie_vects_sa_disc_norm(1:f_para.num_select_pairs,1:f_para.num_selective_averages),-1),m_para.num_disc_measures,1);
            %shiftdim(m_res.movie_vects_sa(m_para.disc_bi_measures_indy,1:f_para.num_select_pairs,1:f_para.num_selective_averages),1)./...
            m_res.movie_vects_sa(m_para.disc_bi_measures_indy,isnan(m_res.movie_vects_sa(m_para.disc_bi_measures_indy,:,:)))=1;
        end
        if m_para.num_pili_measures>0
            m_res.movie_vects_sa(m_para.pili_bi_measures_indy,1:f_para.num_select_pairs,1:f_para.num_selective_averages)=...
                m_res.movie_vects_sa(m_para.pili_bi_measures_indy,1:f_para.num_select_pairs,1:f_para.num_selective_averages)./...
                repmat(shiftdim(sum(m_res.movie_vects_sa_pili_weight(1:f_para.num_selective_averages,1:r_para.num_runs),2),-2),...
                m_para.num_pili_measures,f_para.num_select_pairs);
        end
        if m_para.num_pico_measures>0
            m_res.movie_vects_sa(m_para.pico_bi_measures_indy,1:f_para.num_select_pairs,1:f_para.num_selective_averages)=...
                m_res.movie_vects_sa(m_para.pico_bi_measures_indy,1:f_para.num_select_pairs,1:f_para.num_selective_averages)./...
                repmat(shiftdim(sum(m_res.movie_vects_sa_pico_weight(1:f_para.num_selective_averages,1:r_para.num_runs),2),-2),...
                m_para.num_pico_measures,f_para.num_select_pairs);
        end
        
        for sac=1:f_para.num_selective_averages
            if m_para.num_pili_measures>0
                m_res.movie_vects_sa(m_para.pili_bi_measures_indy,1:f_para.num_select_pairs,sac)=...
                    m_res.movie_vects_sa(m_para.pili_bi_measures_indy,1:f_para.num_select_pairs,sac)/sum(sel_ave_weight(sac,1:f_para.num_sel_ave(sac)));
            end
            if m_para.num_pico_measures>0
                m_res.movie_vects_sa(m_para.pico_bi_measures_indy,1:f_para.num_select_pairs,sac)=...
                    m_res.movie_vects_sa(m_para.pico_bi_measures_indy,1:f_para.num_select_pairs,sac)/sum(sel_ave_weight(sac,1:f_para.num_sel_ave(sac)));
            end
        end
    end
    if f_para.num_triggered_averages>0
        if m_para.num_pili_measures>0
            m_res.movie_vects_ta(m_para.pili_bi_measures_indy,1:f_para.num_select_pairs,1:f_para.num_triggered_averages)=...
                m_res.movie_vects_ta(m_para.pili_bi_measures_indy,1:f_para.num_select_pairs,1:f_para.num_triggered_averages)./...
                repmat(shiftdim(sum(m_res.movie_vects_ta_pili_weight(1:f_para.num_triggered_averages,1:r_para.num_runs),2),-2),...
                m_para.num_pili_measures,f_para.num_select_pairs);
        end
        if m_para.num_pico_measures>0
            m_res.movie_vects_ta(m_para.pico_bi_measures_indy,1:f_para.num_select_pairs,1:f_para.num_triggered_averages)=...
                m_res.movie_vects_ta(m_para.pico_bi_measures_indy,1:f_para.num_select_pairs,1:f_para.num_triggered_averages)./...
                repmat(shiftdim(sum(m_res.movie_vects_ta_pico_weight(1:f_para.num_triggered_averages,1:r_para.num_runs),2),-2),...
                m_para.num_pico_measures,f_para.num_select_pairs);
        end
    end
    
    if f_para.group_matrices && f_para.num_select_train_groups>1 && f_para.num_select_train_groups<f_para.num_trains
        if f_para.num_instants>0
            m_res.group_movie_mat=zeros(m_para.num_sel_bi_measures,f_para.num_select_train_groups,f_para.num_select_train_groups,f_para.num_instants);
            for sgc=1:f_para.num_select_train_groups
                for sgc2=sgc:f_para.num_select_train_groups
                    if sgc~=sgc2
                        m_res.group_movie_mat(1:m_para.num_sel_bi_measures,sgc,sgc2,1:f_para.num_instants)=...
                            mean(m_res.movie_vects(1:m_para.num_sel_bi_measures,f_para.select_group_vect(ti_row2)==f_para.select_train_groups(sgc) & ...
                            f_para.select_group_vect(ti_col2)==f_para.select_train_groups(sgc2),1:f_para.num_instants),2);
                        m_res.group_movie_mat(1:m_para.num_sel_bi_measures,sgc2,sgc,1:f_para.num_instants)=...
                            m_res.group_movie_mat(1:m_para.num_sel_bi_measures,sgc,sgc2,1:f_para.num_instants);
                        if any(m_para.measure_bi_indy(m_para.asym_bi_measures))
                            m_res.group_movie_mat(m_para.measure_bi_indy(m_para.asym_bi_measures),sgc2,sgc,1:f_para.num_instants)=...
                                -m_res.group_movie_mat(m_para.measure_bi_indy(m_para.asym_bi_measures),sgc,sgc2,1:f_para.num_instants);
                        end
                    else
                        if f_para.num_select_group_trains(sgc)>1
                            m_res.group_movie_mat(1:m_para.num_sel_bi_measures,sgc,sgc2,1:f_para.num_instants)=...
                                mean(m_res.movie_vects(1:m_para.num_sel_bi_measures,f_para.select_group_vect(ti_row2)==f_para.select_train_groups(sgc2) & ...
                                f_para.select_group_vect(ti_col2)==f_para.select_train_groups(sgc),1:f_para.num_instants),2);
                            if any(m_para.measure_bi_indy(m_para.asym_bi_measures))
                                m_res.group_movie_mat(m_para.measure_bi_indy(m_para.asym_bi_measures),sgc,sgc2,1:f_para.num_instants)=0;
                            end
                        end
                    end
                end
            end
        end
        
        if f_para.num_selective_averages>0
            m_res.group_movie_mat_sa=zeros(m_para.num_sel_bi_measures,f_para.num_select_train_groups,f_para.num_select_train_groups,f_para.num_selective_averages);
            for sgc=1:f_para.num_select_train_groups
                for sgc2=sgc:f_para.num_select_train_groups
                    if sgc~=sgc2
                        m_res.group_movie_mat_sa(1:m_para.num_sel_bi_measures,sgc,sgc2,1:f_para.num_selective_averages)=...
                            mean(m_res.movie_vects_sa(1:m_para.num_sel_bi_measures,f_para.select_group_vect(ti_row2)==f_para.select_train_groups(sgc) & ...
                            f_para.select_group_vect(ti_col2)==f_para.select_train_groups(sgc2),1:f_para.num_selective_averages),2);
                        m_res.group_movie_mat_sa(1:m_para.num_sel_bi_measures,sgc2,sgc,1:f_para.num_selective_averages)=...
                            m_res.group_movie_mat_sa(1:m_para.num_sel_bi_measures,sgc,sgc2,1:f_para.num_selective_averages);
                        if any(m_para.measure_bi_indy(m_para.asym_bi_measures))
                            m_res.group_movie_mat_sa(m_para.measure_bi_indy(m_para.asym_bi_measures),sgc2,sgc,1:f_para.num_selective_averages)=...
                                -m_res.group_movie_mat_sa(m_para.measure_bi_indy(m_para.asym_bi_measures),sgc,sgc2,1:f_para.num_selective_averages);
                        end
                    else
                        if f_para.num_select_group_trains(sgc)>1
                            m_res.group_movie_mat_sa(1:m_para.num_sel_bi_measures,sgc,sgc2,1:f_para.num_selective_averages)=...
                                mean(m_res.movie_vects_sa(1:m_para.num_sel_bi_measures,f_para.select_group_vect(ti_row2)==f_para.select_train_groups(sgc2) & ...
                                f_para.select_group_vect(ti_col2)==f_para.select_train_groups(sgc),1:f_para.num_selective_averages),2);
                            if any(m_para.measure_bi_indy(m_para.asym_bi_measures))
                                m_res.group_movie_mat_sa(m_para.measure_bi_indy(m_para.asym_bi_measures),sgc,sgc2,1:f_para.num_selective_averages)=0;
                            end
                        end
                    end
                end
            end
        end
        
        if f_para.num_triggered_averages>0
            m_res.group_movie_mat_ta=zeros(m_para.num_sel_bi_measures,f_para.num_select_train_groups,f_para.num_select_train_groups,f_para.num_triggered_averages);
            for sgc=1:f_para.num_select_train_groups
                for sgc2=sgc:f_para.num_select_train_groups
                    if sgc~=sgc2
                        m_res.group_movie_mat_ta(1:m_para.num_sel_bi_measures,sgc,sgc2,1:f_para.num_triggered_averages)=...
                            mean(m_res.movie_vects_ta(1:m_para.num_sel_bi_measures,f_para.select_group_vect(ti_row2)==f_para.select_train_groups(sgc) & ...
                            f_para.select_group_vect(ti_col2)==f_para.select_train_groups(sgc2),1:f_para.num_triggered_averages),2);
                        m_res.group_movie_mat_ta(1:m_para.num_sel_bi_measures,sgc2,sgc,1:f_para.num_triggered_averages)=...
                            m_res.group_movie_mat_ta(1:m_para.num_sel_bi_measures,sgc,sgc2,1:f_para.num_triggered_averages);
                        if any(m_para.measure_bi_indy(m_para.asym_bi_measures))
                            m_res.group_movie_mat_ta(m_para.measure_bi_indy(m_para.asym_bi_measures),sgc2,sgc,1:f_para.num_triggered_averages)=...
                                -m_res.group_movie_mat_ta(m_para.measure_bi_indy(m_para.asym_bi_measures),sgc,sgc2,1:f_para.num_triggered_averages);
                        end
                    else
                        if f_para.num_select_group_trains(sgc)>1
                            m_res.group_movie_mat_ta(1:m_para.num_sel_bi_measures,sgc,sgc2,1:f_para.num_triggered_averages)=...
                                mean(m_res.movie_vects_ta(1:m_para.num_sel_bi_measures,f_para.select_group_vect(ti_row2)==f_para.select_train_groups(sgc2) & ...
                                f_para.select_group_vect(ti_col2)==f_para.select_train_groups(sgc),1:f_para.num_triggered_averages),2);
                            if any(m_para.measure_bi_indy(m_para.asym_bi_measures))
                                m_res.group_movie_mat_ta(m_para.measure_bi_indy(m_para.asym_bi_measures),sgc,sgc2,1:f_para.num_triggered_averages)=0;
                            end
                        end
                    end
                end
            end
        end
    end
    
    for mac=1:m_para.num_sel_bi_measures
        if isfield(m_res,'movie_vects') && ismember(m_para.select_bi_measures(mac),m_para.select_cont_bi_measures)
            movie_vects=shiftdim(m_res.movie_vects(m_para.measure_bi_indy(m_para.select_bi_measures(mac)),:,:),1);
            movie_mat=zeros(f_para.num_instants,f_para.num_trains,f_para.num_trains);
            for ic=1:f_para.num_instants
                plot_mat=zeros(f_para.num_trains,f_para.num_trains);
                plot_mat(sub2ind([f_para.num_trains f_para.num_trains],f_para.mat_indy(:,1),f_para.mat_indy(:,2)))=movie_vects(:,ic);
                if ~ismember(mac,m_para.measure_bi_indy(m_para.asym_bi_measures))
                    movie_mat(ic,:,:)=plot_mat+plot_mat'+eye(f_para.num_trains)*ismember(mac,m_para.measure_bi_indy(m_para.inv_bi_measures));
                else
                    movie_mat(ic,:,:)=plot_mat-plot_mat';
                end
            end
            eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
                '.instants=squeeze(permute(movie_mat,[2 3 1]));'])
        end
        if isfield(m_res,'movie_vects_sa')
            movie_vects=shiftdim(m_res.movie_vects_sa(m_para.measure_bi_indy(m_para.select_bi_measures(mac)),:,:),1);
            movie_mat=zeros(f_para.num_selective_averages,f_para.num_trains,f_para.num_trains);
            for sc=1:f_para.num_selective_averages
                plot_mat=zeros(f_para.num_trains,f_para.num_trains);
                plot_mat(sub2ind([f_para.num_trains f_para.num_trains],f_para.mat_indy(:,1),f_para.mat_indy(:,2)))=movie_vects(:,sc);
                if ~ismember(mac,m_para.measure_bi_indy(m_para.asym_bi_measures))
                    movie_mat(sc,:,:)=plot_mat+plot_mat'+eye(f_para.num_trains)*ismember(mac,m_para.measure_bi_indy(m_para.inv_bi_measures));
                else
                    movie_mat(sc,:,:)=plot_mat-plot_mat';
                end
            end
            eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
                '.selective_averages=squeeze(permute(movie_mat,[2 3 1]));'])
        end
        if isfield(m_res,'movie_vects_ta') && ismember(m_para.select_bi_measures(mac),m_para.select_cont_bi_measures)
            movie_vects=shiftdim(m_res.movie_vects_ta(m_para.measure_bi_indy(m_para.select_bi_measures(mac)),:,:),1);
            movie_mat=zeros(f_para.num_triggered_averages,f_para.num_trains,f_para.num_trains);
            for tc=1:f_para.num_triggered_averages
                plot_mat=zeros(f_para.num_trains,f_para.num_trains);
                plot_mat(sub2ind([f_para.num_trains f_para.num_trains],f_para.mat_indy(:,1),f_para.mat_indy(:,2)))=movie_vects(:,tc);
                if ~ismember(mac,m_para.measure_bi_indy(m_para.asym_bi_measures))
                    movie_mat(tc,:,:)=plot_mat+plot_mat'+eye(f_para.num_trains)*ismember(mac,m_para.measure_bi_indy(m_para.inv_bi_measures));
                else
                    movie_mat(tc,:,:)=plot_mat-plot_mat';
                end
            end
            eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
                '.triggered_averages=squeeze(permute(movie_mat,[2 3 1]));'])
        end
        if isfield(m_res,'group_movie_mat') && f_para.num_instants>0 && ismember(m_para.select_bi_measures(mac),m_para.select_cont_bi_measures)
            eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
                '.group_instants=squeeze(permute(shiftdim(m_res.group_movie_mat(m_para.measure_bi_indy(m_para.select_bi_measures(mac)),:,:,1:f_para.num_instants),1),[3 1 2]));'])
        end
        if isfield(m_res,'group_movie_mat_sa')
            eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
                '.group_selective_averages=squeeze(permute(shiftdim(m_res.group_movie_mat_sa(m_para.measure_bi_indy(m_para.select_bi_measures(mac)),:,:,:),1),[3 1 2]));'])
        end
        if isfield(m_res,'group_movie_mat_ta') && ismember(m_para.select_bi_measures(mac),m_para.select_cont_bi_measures)
            eval(['results.',char(m_para.all_measures_string(m_para.select_bi_measures(mac))),...
                '.group_triggered_averages=squeeze(permute(shiftdim(m_res.group_movie_mat_ta(m_para.measure_bi_indy(m_para.select_bi_measures(mac)),:,:,:),1),[3 1 2]));'])
        end
    end
end


