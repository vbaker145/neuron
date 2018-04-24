% This function extracts the best estimate of the sampling interval from 
% the spike dataset itself in case none is provided by the user.

function dt = SPIKY_f_get_dt(spikes)

if size(spikes,2)>size(spikes,1)
    spikes=spikes';
end

if length(spikes)>1000
    spikes=spikes([1:300 unique(round(301:(length(spikes)-600)/400:length(spikes)-300)) length(spikes)-299:length(spikes)]);
end
rems=unique(rem(abs(spikes),1));
rems3=rems(rems~=0);
if isempty(rems3)
    dt=1;
else
    s3=num2str(rems3);
    [r,c]=find(s3=='e');
    if ~isempty(r)
        dt=zeros(1,length(r));
         for ec=1:length(r)
            dt(ec)=str2num(s3(r(ec),size(s3,2)-2:size(s3,2)))+4;
         end
         dt=10^-(max(dt));
    else
        dt=10^-(size(s3,2)-2);    
    end
end

lower_limit_dt=10^floor(log10(((max(spikes)-min(spikes))/10000000000000000)));
if dt<lower_limit_dt || dt>min(spikes)
    dt=lower_limit_dt;
end
