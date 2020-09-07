function [v, vall, u, uall, firings] = izzy_net(v, u, dt, nsteps, a, b, c, d, S, delays, stim)
%Izhikevich model

n = size(S,1);
ExpSize = 4;  %Length of synaptic response in milliseconds
Dmax = max(max(delays))+ceil(ExpSize/dt);
PSP = zeros(n, Dmax);
background_current = 0;
firings=[];             % spike timings
vall = [];
uall = [];

synRespLambda = floor(ExpSize/dt);
synResp = exp(-((0:synRespLambda-1)./synRespLambda).^2);
  
for t=1:nsteps          % simulation of 1000 ms
  sim_t = (t-1)*dt;
  I = stim(:,t)+background_current;
  
  fired=find(v>=30);    % indices of spikes
  firings=[firings; sim_t+0*fired,fired];
  v(fired)=c(fired);
  u(fired)=u(fired)+d(fired);
   
  %PSP(:,mod(D(fired,:)+t, Dmax)) = 1;
  for ii=1:length(fired)
     pst = delays(:,fired(ii)); 
     ConIdx = find(abs(S(:,fired(ii)))>0);
     for jj=1:length(ConIdx)
        jIdx = ConIdx(jj);
        idx = mod((t:t+synRespLambda-1)-1+pst(jIdx),Dmax)+1;
        PSP(jIdx, idx) = PSP(jIdx,idx)+S(jIdx,fired(ii))*synResp;
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

