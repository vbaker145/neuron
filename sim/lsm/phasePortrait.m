%Phase portrait of 2D model
clear; close all

%dv = 0.04v^2+5v+140+I
%du = a(bv-u)
a = 0.02;
b = 0.2;
vv = -65:30;
uu = -20:10;
[v u] = meshgrid(vv, vv);

dv = 0.04*v.^2+5*v+140-u;
du = a*(b*v-u);g

figure; quiver(v,u,dv,du)
