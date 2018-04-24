% This function calculates the selective averages for both piecewise
% constant (e.g. ISI) and piecewise linear (e.g. SPIKE) functions.
%
% Input:
% fx: cumulative ISI-values (one value more than number of ISIs)
% fy: for piecewise constant: one value for each ISI
%     for piecewise linear: two values for each ISI

function ave=SPIKY_f_selective_averaging(fx,fy,wmin,wmax)

if length(fx)==size(fy,2)
    fx=fx([1:2:end-1 end]);
end

num_isi=length(fx)-1;
if wmax>wmin
    if size(fy,2)==num_isi    % piecewise constant (e.g. ISI)
        first_winspike_ind=find(fx>wmin,1,'first');   % index of first spike after start of interval
        last_winspike_ind=find(fx<wmax,1,'last');     % index of last spike before end of interval
        if ~isempty(first_winspike_ind) && ~isempty(last_winspike_ind)
            if first_winspike_ind==1 && last_winspike_ind==length(fx)
                wmin=fx(1);
                wmax=fx(end);
            end
            if first_winspike_ind<=last_winspike_ind
                dfx=fx(first_winspike_ind:last_winspike_ind);
                dfy=fy(:,first_winspike_ind:last_winspike_ind-1);
                if wmin<dfx(1)              % interval to first spike
                    dfx=[wmin dfx];
                    dfy=[fy(:,first_winspike_ind-1) dfy];
                end
                if wmax>dfx(end)            % interval after last spike
                    dfx=[dfx wmax];
                    dfy=[dfy fy(:,last_winspike_ind)];
                end
                win_isi=diff(dfx);
                ave=sum(dfy.*repmat(win_isi,size(fy,1),1),2)/sum(win_isi);
            else
                ave=fy(:,last_winspike_ind);
            end
        end
    elseif size(fy,2)==num_isi*2    % piecewise linear (e.g. SPIKE)
        first_winspike_ind=find(fx>wmin,1,'first');   % index of first spike after start of interval
        last_winspike_ind=find(fx<wmax,1,'last');     % index of last spike before end of interval
        if ~isempty(first_winspike_ind) && ~isempty(last_winspike_ind)
            if first_winspike_ind==1 && last_winspike_ind==length(fx)
                wmin=fx(1);
                wmax=fx(end);
            end
            if first_winspike_ind<=last_winspike_ind
                dfx=fx(first_winspike_ind:last_winspike_ind);
                dfy=fy(:,max([1 (first_winspike_ind-1)*2]):min([num_isi*2 last_winspike_ind*2-1]));
                if wmin<dfx(1)              % interval to first spike
                    dfx=[wmin dfx];
                    dfy=[interp1(fx(first_winspike_ind-[1 0]),fy(:,first_winspike_ind*2-([3 2]))',wmin)' dfy];
                end
                if wmax>dfx(end)            % interval after last spike
                    dfx=[dfx wmax];
                    dfy=[dfy interp1(fx(last_winspike_ind+[0 1]),fy(:,last_winspike_ind*2-[1 0])',wmax)'];     % ########
                end
                win_isi=diff(dfx);
                odds=1:2:size(dfy,2);
                evens=odds+1;
                ave=sum((dfy(:,odds)+dfy(:,evens))/2.*repmat(win_isi,size(fy,1),1),2)/sum(win_isi);
            else
                ave=fy(:,last_winspike_ind);
            end
        end
    else
    end
else
    ave=zeros(size(fy,1),1);
end
