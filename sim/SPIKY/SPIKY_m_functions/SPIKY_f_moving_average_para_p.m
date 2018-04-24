% This function calculates the causal moving average (including past values only)
% stretching as far as possible at the beginning. Many rows are calculated in parallel.
% Order of moving average o = window length

function z=SPIKY_f_moving_average_para_p(y,o)

if size(y,length(size(y)))==1
    y=y';
end
num_rows=size(y,1);
num_data=size(y,2);
if num_data<o
    o=num_data;
end

if o>1
    z=zeros(num_rows,num_data);
    for cc=1:o
        z(1:num_rows,cc)=sum(y(1:num_rows,1:cc),2)/cc;
    end
    for cc=o+1:num_data
        z(1:num_rows,cc)=z(1:num_rows,cc-1)+( y(1:num_rows,cc) - y(1:num_rows,cc-o) )/o;
    end
else
    z=y; 
end
