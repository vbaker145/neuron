% This function automatically sets the range and the spacing of the axis ticks.
% origin: set to 1 if zero should be included as value otherwise 0
% cut: set to 1 if only values within the range covered by vect2 can be used

function lab=SPIKY_f_lab(vect,num_values,origin,cut)  

if origin==1
    vect2=unique([0 vect]);
else
    vect2=vect;
end
range=max(vect2)-min(vect2);
interval=range/num_values;
min_unit=fix(interval*10^(ceil(-log10(interval))))/10^(ceil(-log10(interval)));

xsep=round((range+min_unit)/num_values/min_unit)*min_unit;
lab=round(min(vect2)/min_unit)*min_unit+(0:xsep:(range+min_unit));
if origin==1
    lab=unique([0 lab]);
end

if cut==1
    %lab=lab(lab>=min(vect2) & lab<=max(vect2));
    lab=lab(lab>=min(vect2)*0.999 & lab<=max(vect2)*1.001);
end
