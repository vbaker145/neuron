% This function calculates the anti-causal moving average (including future values only)
% with asymmetric inwards averaging at the edges.
% Order of moving average o = window length

function z=SPIKY_f_moving_average_weighted_f(y,x,o)

if size(y,length(size(y)))==1 
    y=y';
end
if size(x,length(size(x)))==1 
    x=x';
end

num_data=length(y);
if num_data<o
    o=num_data;
end

if o>1
    z=zeros(1,num_data);
    y2=zeros(o,num_data-o+1);
    x2=zeros(o,num_data-o+1);
    for rc=1:o
        y2(rc,1:num_data-o+1)=y((o:num_data)-rc+1);
        x2(rc,1:num_data-o+1)=x((o:num_data)-rc+1);
    end
    z(1:num_data-o+1)=sum(y2.*x2)./sum(x2);
    for cc=1:o-1
        z(num_data-cc+1)=sum(y(num_data-cc+1:num_data).*x(num_data-cc+1:num_data))/sum(x(num_data-cc+1:num_data));
    end
else
    z=y; 
end

