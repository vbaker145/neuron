% This function calculates the triggered averages for both piecewise
% constant (e.g. ISI) and piecewise linear (e.g. SPIKE) functions.
%
% Input:
% fx: cumulative ISI-values (one value more than number of ISIs)
% fy: for piecewise constant: one value for each ISI
%     for piecewise linear: two values for each ISI

function [y,ave]=SPIKY_f_triggered_averaging(fx,fy,x)

num_isi=length(fx)-1;
if size(fy,2)==num_isi    % piecewise constant (e.g. ISI)
    trig_indy=find(x>fx(1) & x<=fx(num_isi+1));
    if ~isempty(trig_indy)
        tpind=zeros(1,length(trig_indy));
        for ric=1:length(trig_indy)
            dummy=find(fx<x(trig_indy(ric)),1,'last');
            if ~isempty(dummy)
                tpind(ric)=dummy;
            else
                tpind(ric)=1;
            end
        end
    end
    y=fy(:,tpind);
    
    m_res.movie_vects_ta(matc2,1:f_para.num_select_pairs,tac)=...
        m_res.movie_vects_ta(matc2,1:f_para.num_select_pairs,tac)+...
        mean(m_res.pico_measures_mat(matc3,f_para.select_pairs,tpind),3)*...
        m_res.movie_vects_ta_pico_weight(tac,pi_ruc);
elseif size(fy,2)==num_isi*2    % piecewise linear (e.g. SPIKE)
    
    trig_indy=find(x>=fx(1) & x<=fx(num_isi+1));
    if ~isempty(trig_indy)
        tlind=zeros(1,length(trig_indy));
        y=zeros(size(fy,1),length(trig_indy));
        for ric=1:length(trig_indy)
            dummy=find(fx<x(trig_indy(ric)),1,'last');
            if ~isempty(dummy)
                tlind(ric)=dummy;
            else
                tlind(ric)=1;
            end
            y(:,ric)=interp1(fx(tlind(ric)+[0 1]),fy(:,tlind(ric)*2-[1 0])',x(trig_indy(ric)));
        end
    end
end
ave=mean(y,2);

