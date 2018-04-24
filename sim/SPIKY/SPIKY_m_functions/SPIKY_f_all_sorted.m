% This function is called from SPIKY_calculate_distances_MEX to sort the subplots
% selected in the 'Selection: Measures' panel. It also eliminates empty subplots.

function y=SPIKY_f_all_sorted(x)

ux=unique(x(x>0));
len_ux=length(ux);
vals=1:len_ux;

y=x;
for ec=1:len_ux
   y(logical(y==ux(ec)))=vals(ec); 
end