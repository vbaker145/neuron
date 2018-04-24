  function synf=SPIKY_f_generate_surros_np(sto_profs,so_profs,all_trains,num_surros,dataset)

num_pairs=size(sto_profs,1);
num_trains=(1+sqrt(1+8*num_pairs))/2;
[seconds,firsts]=find(triu(ones(num_trains),1)');

[leader_pos,pair]=find(so_profs'==1);
[follower_pos,dummy]=find(so_profs'==-1);
ddd=sto_profs';
xxx=ddd(so_profs'==1);
num_coins=length(dummy);
num_spikes=length(all_trains);

%indies_mat=zeros(num_surros+1,5,num_coins);
indies=[pair firsts(pair).*(xxx==1)+seconds(pair).*(xxx==-1) seconds(pair).*(xxx==1)+firsts(pair).*(xxx==-1) leader_pos follower_pos]';
%indies_mat(1,1:5,1:num_coins)=indies;
%save long_test2 indies_mat
num_swaps=num_spikes;         % eliminate transients !!!!!
%num_swaps=round(num_swaps/4);
disp(['First surrogate with long transient: ',num2str(num_swaps),' swaps --- All others without transient: ',num2str(round(num_swaps/2)),' swaps'])

synf=zeros(1,num_surros);
if dataset>100
    disp([num2str(0),'  ',regexprep(num2str(synf*2/(num_trains-1)/sum(num_spikes),2),'   ',' ')])
end
for suc=1:num_surros
    %suc
    if suc==2
        num_swaps=round(num_swaps/2);
    end
    %num_swaps=1;  % ####
    
    if exist(['SPIKE_order_surro_MEX.',mexext],'file')
        [indies,error_count]=SPIKE_order_surro_MEX(indies,firsts,seconds,num_swaps);
        disp([num2str(suc),')  Error_count: ',num2str(error_count)]);
        %indies_mat(suc+1,1:5,1:num_coins)=indies;
        %save long_test2 indies_mat
    else
        sc=1;
        error_count=0;
        while sc<=num_swaps
            brk=0;
            dummy=indies;

            coin=randi(num_coins,1);
            
            train1=indies(2,coin);   % important, don't use indies directly !
            train2=indies(3,coin);
            pos1=indies(4,coin);
            pos2=indies(5,coin);
            fi11=find(indies(4,:)==pos1);
            fi21=find(indies(5,:)==pos1);
            fi12=find(indies(4,:)==pos2);
            fi22=find(indies(5,:)==pos2);
            fiu=unique([fi11 fi21 fi12 fi22]);
            indies(2,fi11)=train2;
            indies(3,fi21)=train2;
            indies(2,fi12)=train1;
            indies(3,fi22)=train1;
            for fc=fiu
                new_trains=sort(indies([2 3],fc));                                   % switch train numbers
                indies(1,fc)=find(firsts==new_trains(1) & seconds==new_trains(2));   % update pairs
            end
            %indies
            for fc=fiu
                sed=setdiff(find(indies(1,:)==indies(1,fc)),fc);    % all other coincidences from that pair of spike trains
                for sedc=1:length(sed)
                    %sed(sedc)
                    %[fc indies(1,fc) sed(sedc) indies([4 5],sed(sedc))' indies([4 5],fc)']
                    if ~isempty(intersect(indies([4 5],sed(sedc)),indies([4 5],fc)))
                        error_count=error_count+1;
                        777777777777
                        indies=dummy;
                        brk=1;
                        break
                    end
                end
                if brk==1
                    break
                end
            end
            if brk==1
                if error_count<=2*num_coins
                    continue
                else
                    sc=num_swaps;
                end
            end
            
            sc=sc+1;
            %if mod(sc,round(num_swaps/5))==0 [suc sc] end
        end
    end
    surro_sto_profs=zeros(size(sto_profs));
    for cc=1:num_coins
        surro_sto_profs(indies(1,cc),indies([4 5],cc))=(indies(2,cc)<indies(3,cc))-(indies(2,cc)>indies(3,cc))*ones(1,2);
    end
    
    surro_mat_entries=sum(surro_sto_profs,2)/2;
    surro_mat = tril(ones(num_trains),-1);
    surro_mat(~~surro_mat) = surro_mat_entries';
    surro_mat=surro_mat'-surro_mat;
    
    if exist(['SPIKE_order_sim_ann_MEX.',mexext],'file')
        [st_indy_simann,synf(suc),total_iter]=SPIKE_order_sim_ann_MEX(surro_mat);
    else
        [st_indy_simann,synf(suc),total_iter]=SPIKY_f_simann_sort(surro_mat);
    end
    if suc==num_surros || dataset>100
        disp(['S#',num2str(suc),'  ',regexprep(num2str(synf*2/(num_trains-1)/sum(num_spikes),3),'   ',' ')])
    end
end

end


