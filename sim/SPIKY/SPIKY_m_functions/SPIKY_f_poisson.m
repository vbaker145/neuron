% This function creates a Poisson spike train with a given length, firing rate and refractory time.

function  poiss = SPIKY_f_poisson(len,rate,refrac)

uniform=rand(1,len);
poiss=refrac-log(1-uniform)/rate;