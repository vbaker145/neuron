function [v, vall, u, uall, firings] = izzy_net(v, u, dt, nsteps, a, b, c, d, S, delays, stim)
%Izhikevich model

n = size(S,1);
Dmax = max(max(delays));
PSP = zeros(n, Dmax);
background_current = 0;
firings=[];             % spike timings
vall = [];
uall = [];

synRespLambda = floor(4/dt);
synResp = exp(-(0:synRespLambda).^2./synRespLambda);
  
for t=1:nsteps          % simulation of 1000 ms
  I = stim(:,t)+background_current;
  
  fired=find(v>=30);    % indices of spikes
  firings=[firings; t+0*fired,fired];
  v(fired)=c(fired);
  u(fired)=u(fired)+d(fired);
   
  %PSP(:,mod(D(fired,:)+t, Dmax)) = 1;
  for ii=1:length(fired)
     pst = delays(:,fired(ii)); 
     for jj=1:n
        idx = mod((t:t+synRespLambda)-1+pst(jj),Dmax)+1;
        PSP(jj, idx) = PSP(jj,idx)+S(jj,fired(ii))*synResp;
        %idx = mod(t-1+pst(jj),Dmax)+1;
        %PSP(jj, idx) = PSP(jj,idx)+S(jj,fired(ii));
     end
  end

  I=I+PSP(:,mod(t-1,Dmax)+1);
  PSP(:,mod(t-1,Dmax)+1) = 0;
  
  v=v+0.5*dt*(0.04*v.^2+5*v+140-u+I); % step 0.5 ms
  v=v+0.5*dt*(0.04*v.^2+5*v+140-u+I); % for numerical
  u=u+dt*a.*(b.*v-u);                 % stability
  
  v(v>30) = 30;
  
  vall =[vall v];
  uall = [uall u];
end


end

