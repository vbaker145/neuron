function valMap = density2D(pos, val)

val2d = reshape(val, size(pos.x,1), size(pos.x,2), size(pos.x,3));
val2d = (val2d>0.24);
val2d = sum(val2d,3);

cmin = min(val2d(:)); cmax = max(val2d(:));

smoother = 0.5*ones(9);
smoother(41) = 1;
smoother = smoother ./ sum(smoother(:));
val2df = conv2(val2d, smoother, 'same');

figure(50); imagesc(val2df); colormap('jet'); 
l=caxis;
caxis([cmin l(2)]);

valMap = val2d;

end

