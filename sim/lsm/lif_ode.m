function udot=lif_ode(t,u,flag,theta,tau,I_ext)
% odefile for recurrent network
 tau_inv = 1.;      % inverse of membrane time constant
 s=u>theta
 udot=tau_inv*(-u+sum+I_ext);
return

