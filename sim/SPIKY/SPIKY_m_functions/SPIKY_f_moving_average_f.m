% This function calculates the anti-causal moving average (including future values only).
% Order of moving average o = window length

function z=SPIKY_f_moving_average_f(y,o)

if size(y,length(size(y)))==1
    y=y'; 
end
num_data=length(y);
if num_data<o
    o=num_data;
end

if o>1
    z=zeros(1,num_data);
    dummy=zeros(o,num_data-o+1);
    for rc=1:o
        dummy(rc,1:num_data-o+1)=y((o:num_data)-rc+1);
    end
    z(1:num_data-o+1)=mean(dummy);
    for cc=1:o-1
        z(num_data-cc+1)=sum(y(num_data-cc+1:num_data))/cc;
    end
else
    z=y; 
end
