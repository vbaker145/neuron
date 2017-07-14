%% Dynamic Neural Field Model (1D) 
 clear; clf; hold on;
 nn = 100; dx=2*pi/nn; sig = 2*pi/10; C=0.5; 

%% Training weight matrix
 for loc=1:nn;  
     i=(1:nn)'; dis=min(abs(i-loc),nn-abs(i-loc)); 
     pat(:,loc)=exp(-(dis*dx).^2/(2*sig^2));
 end
 w=pat*pat'; w=w/w(1,1); w=4*(w-C);
%% Update with localised input 
 tall = []; rall = [];
 I_ext=zeros(nn,1); I_ext(nn/2-floor(nn/10):nn/2+floor(nn/10))=1;
 [t,u]=ode45('rnn_ode',[0 10],zeros(1,nn),[],nn,dx,w,I_ext);
 r=1./(1+exp(-u)); tall=[tall;t]; rall=[rall;r];
%% Update without input 
 I_ext=zeros(nn,1); 
 [t,u]=ode45('rnn_ode',[10 20],u(size(u,1),:),[],nn,dx,w,I_ext);
 r=1./(1+exp(-u)); tall=[tall;t]; rall=[rall;r];
%% Plotting results
 surf(tall',1:nn,rall','linestyle','none'); view(0,90);