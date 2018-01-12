function [ dummy ] = plotFirings( firings, dt)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

firings(:,1) = firings(:,1)*dt;
figure; clf; plot(firings(:,1),firings(:,2),'.');
xlabel('Time (ms)','FontSize', 12); ylabel('Neruon #', 'FontSize',12);
% tsp = find(st1>0)*dt;
% xv = [tsp; tsp]; yv = [zeros(1,length(tsp)); N*ones(1,length(tsp))];
% hold on; line(xv, yv, 'Color', 'r');

end

