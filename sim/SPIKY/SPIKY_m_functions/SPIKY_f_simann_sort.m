% Uses simulated annealing to find the sorting that yields the highest synfire indicator

function [p,A,total_iter]=SPIKY_f_simann_sort(D)

N=size(D,1);
A=sum(sum(triu(D,1)));
p=1:N;             % initial permutation
T=2*max(max(D));   % starting temperature
T_end=1e-5*T;      % final temperature
alpha=0.9;         % cooling factor
total_iter=0;
while T>T_end
    iterations=0;
    succ_iter=0;
    while iterations<100*N && succ_iter<10*N
        % exchange two rows and cols
        ind1=randi(N-1,1);
        delta_A = -2*D(p(ind1),p(ind1+1));
        if delta_A>0 || exp(delta_A/T)>rand(1)
            % swap indices
            dummy=p(ind1);
            p(ind1)=p(ind1+1);
            p(ind1+1)=dummy;
            A=A+delta_A;
            succ_iter=succ_iter+1;
        end
        iterations=iterations+1;
    end
    total_iter=total_iter+iterations;
    T=T*alpha;   % cool down
    if succ_iter==0
        break;
    end
end
