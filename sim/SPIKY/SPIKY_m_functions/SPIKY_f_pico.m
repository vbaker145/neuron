% This function can be used to obtain from piecewise constant measure profiles
% (that can be extracted via the red mouse button while hovering over a profile)
% the average value as well as the x- and y-vectors for plotting.

function [ave,plot_x_values,plot_y_values]=SPIKY_f_pico(isi,pico,tmin)

cum_isi=cumsum([0 isi]);
if size(pico,1)>size(pico,2)
    pico=pico';
end
num_profs=size(pico,1);
num_isi=size(pico,2);
plot_y_values=zeros(num_profs,num_isi*2);
ave=sum(pico.*repmat(isi,num_profs,1),2)/cum_isi(end);
plot_x_values=tmin+sort([cum_isi(1:end) cum_isi(2:end-1)]);
for rc=1:num_profs
    plot_y_values(rc,:)=reshape([pico(rc,:); pico(rc,:)],1,num_isi*2);
end

