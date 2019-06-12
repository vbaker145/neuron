function h = plotMultiError( x, y, errP, errM )
%Plot error bars on multi-data plot
% Don't put error bars in legend
%x - x values
%y - matrix of data series
%errP - upper error bounds
%errM - lower error bounds

h = figure(20);

plot(x,y,'.-');
hold on;
nDataPoints = size(y,2);

for jj=1:length(errP)
    h = line(x(jj)*ones(2,nDataPoints),[errP(jj,:); errM(jj,:)]);
    for kk=1:length(h)
        set(get(get(h(kk),'Annotation'),'LegendInformation'), 'IconDisplayStyle','off');
    end
end

end
