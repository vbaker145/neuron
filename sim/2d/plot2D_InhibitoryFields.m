function mv = plot2D_InhibitoryFields( f, pos, ecn, b )

x = pos.x(:); y = pos.y(:); z = pos.z(:);

inhibIdx = find(ecn==0);
ninhib = length(inhibIdx);

xi = x(inhibIdx);
yi = y(inhibIdx);

figure(20); ksdensity([xi yi]);
l = caxis; caxis([l(2)*0.9 l(2)]);
xlim( [min(x) max(x)] ); ylim([min(y) max(y)]);
view([0 90])
xlabel('X', 'FontWeight', 'bold');
ylabel('Y', 'FontWeight', 'bold');
axis square;

end