%Mandelbrot zoom
clear all
bounds = 2;
bpp = 1024;
center = [-0.76 -0.05];
figure(10); 
for jj=1:20
    scale = 2*bounds/bpp;
    sv = -bounds:scale:bounds;
    svx = sv+center(1);
    svy = sv+center(2);
    [x y] = meshgrid(svx,svy);
    c = x + 1i.*y;
    ci = c;
    for kk=1:400
        ci = ci.^2 + c;
    end
    ci(abs(ci)<=2000) = 0;
    ci(abs(ci)>2000) = 1;
    imagesc(svx,svy,abs(ci)); 
    colormap('gray')
    set(gca, 'YDir', 'Normal')
    bounds = bounds/1.25;
    pause(0.2)
end
