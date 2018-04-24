% This function calculates the average profile for piecewise linear profiles (such as SPIKE).
% This includes piecewise constant profiles (such as ISI) which should first be transformed via the function
% SPIKY_f_pico to a format suitable for plotting.

function [x_ave,y_ave]=SPIKY_f_average_pi(x2,y2,dts)

if iscell(x2)                                       % transform x2 to matrix x, find lengths of individual profiles
    num_trains=length(x2);
    num_sup=cellfun('length',x2);
    max_num_sup=max(num_sup);
    x=zeros(num_trains,max_num_sup);
    y=x;
    for trac=1:num_trains
        x(trac,1:num_sup(trac))=x2{trac};
        y(trac,1:num_sup(trac))=y2{trac};
    end
    num_trains=size(x,1);
else
    x=x2;
    num_trains=size(x,1);
    num_sup=zeros(1,num_trains);
    for trac=1:num_trains
        num_sup(trac)=find(x(trac,:),1,'last');
    end
    y=y2;
end
    
x3=x;
x_all=zeros(1,sum(num_sup));
for trac=1:num_trains
    x_all(sum(num_sup(1:trac-1))+(1:num_sup(trac)))=x3(trac,1:num_sup(trac));           % pooled x-values
    if any(x3(trac,2:2:num_sup(trac)-2)==x3(trac,3:2:num_sup(trac)-1))
        if num_sup(trac)>2
            while any(x3(trac,2:2:num_sup(trac)-2)==x3(trac,3:2:num_sup(trac)-1))
                x3(trac,2:2:num_sup(trac)-2)=x3(trac,2:2:num_sup(trac)-2)-dts/4;        % equal values are separated since for the interpolation
                x3(trac,3:2:num_sup(trac)-1)=x3(trac,3:2:num_sup(trac)-1)+dts/4;        % all values have to be distinct (two values for each spike ot possible)
            end
        end
    end
end

[x_ave,ind1,ind2]=unique(x_all);                                            % x_ave - unique support points of average
indy=zeros(size(x));                                                        % and their indices in the individual profiles
for trac=1:num_trains
    dummy=ind2(sum(num_sup(1:trac-1))+(1:num_sup(trac)));
    dummy(1:2:end-1)=dummy(1:2:end-1)*2-1;
    dummy(2:2:end)=dummy(2:2:end)*2-2;
    indy(trac,1:num_sup(trac))=dummy;
end
x_ave=x_ave(sort([1 2:end-1 2:end-1 end]));                                 % create support points for average profile (now again with two points at each spike)
num_vals=length(x_ave);

y_all=zeros(num_trains,num_vals);
for trac=1:num_trains
    y_all(trac,indy(trac,1:num_sup(trac)))=y(trac,1:num_sup(trac));
    dindy=setdiff(1:num_vals,indy(trac,1:num_sup(trac)));
    y_all(trac,dindy)=interp1(x3(trac,1:num_sup(trac)),y(trac,1:num_sup(trac)),x_ave(dindy));   % do the interpolation for the individual profiles
end
y_ave=mean(y_all,1);

return

plotting=1;                                                                 % plotting, just for testing
if plotting==1 && num_trains==2
    cols='br';
    figure(148); clf; hold on
    for trac=1:num_trains
        plot(x(trac,1:num_sup(trac)),y(trac,1:num_sup(trac)),['-+',cols(trac)])
    end
    plot(x_ave,y_ave,'kx-','LineWidth',2)
end

