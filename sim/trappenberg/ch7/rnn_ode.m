function udot=rnn_ode(t,u,flag,nn,dx,w,I_ext)
% odefile for recurrent network
 tau_inv = 1.;      % inverse of membrane time constant
 r=1./(1+exp(-u)); 
 sum=w*r*dx;
 udot=tau_inv*(-u+sum+I_ext);
return
