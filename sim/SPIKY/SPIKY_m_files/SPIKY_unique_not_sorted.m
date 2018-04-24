% This function transform a vector into a vector which contains all its
% unique elements but keeps these elements in the order of their first / last
% appearance (i.e. without sorting)

function out=SPIKY_unique_not_sorted(in,str)

if nargin<2
    str='first';
end
[b,c,d]=unique(in,str);  % str: first / last
[e,f]=sort(c);
out=in(c(f));

