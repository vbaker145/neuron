function synf=SPIKY_f_generate_surros(sto_profs,so_profs,all_trains,num_surros,dataset,event_seps,fin)

surro_plot=0;       % 1-only final permutation,2-individual swaps
histo_one_plot=0;   % Surrogate analysis (subplot F), with surro_plot=1

num_pairs=size(sto_profs,1);
num_trains=(1+sqrt(1+8*num_pairs))/2;
[seconds,firsts]=find(triu(ones(num_trains),1)');

[leader_pos,pair]=find(so_profs'==1);
[follower_pos,dummy]=find(so_profs'==-1);
ddd=sto_profs';
xxx=ddd(so_profs'==1);
num_coins=length(dummy);
num_all_spikes=length(all_trains);

%indies_mat=zeros(num_surros+1,5,num_coins);
indies=[pair firsts(pair).*(xxx==1)+seconds(pair).*(xxx==-1) seconds(pair).*(xxx==1)+firsts(pair).*(xxx==-1) leader_pos follower_pos]';
%indies_mat(1,1:5,1:num_coins)=indies;
%save long_test2 indies_mat
num_swaps=num_all_spikes;         % eliminate transients !!!!!
%num_swaps=round(num_swaps/4);
disp(['First surrogate with long transient: ',num2str(num_swaps),' swaps --- All others without transient: ',num2str(round(num_swaps/2)),' swaps'])

if surro_plot>0
    multi_figure=0;
    %cols='br'; symb='xo';
    cols='kr'; symb='xo';
    
    mat_entries=sum(sto_profs,2)/2;
    mat = tril(ones(num_trains),-1);
    mat(~~mat) = mat_entries';
    mat=mat'-mat;
    ini_synfire=sum(sum(triu(mat)));
    %ini_final=ini_synfire*2/(num_trains-1)/num_all_spikes;
    ori_all_trains=all_trains;
    if surro_plot==1 
        fs=15; ms=5;
        if num_trains<20 lw=1.5; else lw=1; end
    elseif num_swaps<20 
        fs=20; ms=15; lw=2;
    else
        fs=12; ms=10; lw=1;
    end
    num_all_spikes=length(all_trains);
    old_synfire=ini_synfire;
end


synf=zeros(1,num_surros);
if dataset>100
    disp([num2str(0),'  ',regexprep(num2str(synf*2/(num_trains-1)/sum(num_all_spikes),2),'   ',' ')])
end
for suc=1:num_surros
    if surro_plot>0 % && num_all_spikes<55
        figure(100+multi_figure*suc); clf
        if histo_one_plot==1
            subplot(1,2,1);
        end
        hold on
        set(gcf,'Units','normalized','Position',[0 0.0044 1.0000 0.8900])
        plot(num_trains+1-ori_all_trains,[cols(1),symb(1)],'LineWidth',1,'MarkerSize',ms+5)  % #########
        if histo_one_plot==1
            axis square
            for ec=1:9
               plot((ec-1)*num_trains+(1:num_trains-(ec==9)),num_trains+1-ori_all_trains((ec-1)*num_trains+(1:num_trains-(ec==9))),[cols(1),symb(1),'-'],'LineWidth',1,'MarkerSize',ms+5)
            end
            xlim([0 24.5])
        else
            xlim([0 length(all_trains)+1])
        end
        if num_all_spikes<10
            set(gca,'XTick',1:num_all_spikes)
        else
            set(gca,'XTick',[num_trains:num_trains:num_all_spikes num_all_spikes])            
        end
        if surro_plot==1
            ylim([0 num_trains+1])
            %set(gca,'YTick',(0:1)*(num_trains+1)-num_trains/2-0.5,'YTickLabel',[1 0],'FontSize',fs-1)
            if num_trains<10
                set(gca,'YTick',1:num_trains,'YTickLabel',num_trains:-1:1)
            end
        else
            ylim([-(num_swaps+1)*(num_trains+1) num_trains+1])
            if num_swaps<20
                set(gca,'YTick',-(num_swaps-1:-1:0)*(num_trains+1)-num_trains/2-0.5,'YTickLabel',num_swaps:-1:1)
            else
                set(gca,'YTick',-(num_swaps-1:-1:0)*(num_trains+1)-num_trains/2-0.5,'YTickLabel',num_swaps:-1:1)
            end
        end
        set(gca,'FontSize',fs-4)
        xl=xlim; yl=ylim;
        for ec=1:length(event_seps)
            line(event_seps(ec)*ones(1,2),yl,'Color','k','LineStyle',':')
        end
        %text(xl(2)-0.12*(xl(2)-xl(1)),yl(2)-0.05*(yl(2)-yl(1)),num2str(ini_synfire),'Color',cols(1),'FontWeight','bold','FontSize',fs-2)
        %text(xl(2)-0.07*(xl(2)-xl(1)),yl(2)-0.05*(yl(2)-yl(1)),num2str(ini_synfire*2/(num_trains-1)/num_all_spikes,3),'Color',cols(1),'FontWeight','bold','FontSize',fs-2)
        xlabel('Time index','FontSize',fs-3,'FontWeight','bold')
        ylabel('Spike trains','FontSize',fs-3,'FontWeight','bold')
    end
    %suc
    if suc==2
        num_swaps=round(num_swaps/2);
    end
    %num_swaps=1;  % ####
    
    if exist(['SPIKE_order_surro_MEX.',mexext],'file') && surro_plot==0
        [indies,error_count]=SPIKE_order_surro_MEX(indies,firsts,seconds,num_swaps);
        %disp([num2str(suc),')  Error_count: ',num2str(error_count)]);
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
            
            if surro_plot>0
                all_trains(indies([4 5],coin))=all_trains(indies([5 4],coin));
            end
            if surro_plot==2
                surro_sto_profs=zeros(size(sto_profs));
                for cc=1:num_coins
                    surro_sto_profs(indies(1,cc),indies([4 5],cc))=(indies(2,cc)<indies(3,cc))-(indies(2,cc)>indies(3,cc))*ones(1,2);
                end
                surro_mat_entries=sum(surro_sto_profs,2)/2;
                surro_mat = tril(ones(num_trains),-1);
                surro_mat(~~surro_mat) = surro_mat_entries';
                surro_mat=surro_mat'-surro_mat;
                synfire=sum(sum(triu(surro_mat)));
                delta=synfire-old_synfire;
                overall_delta=synfire-ini_synfire;
                plot(-(sc-1)*(num_trains+1)-all_trains,'r*','LineWidth',2,'MarkerSize',ms)
                plot(indies([4 5],coin),-(sc-1)*(num_trains+1)-all_trains(indies([4 5],coin)),'bo','LineWidth',lw,'MarkerSize',ms+5)
                line(xl,(-(sc-1)*(num_trains+1))*ones(1,2),'Color','k','LineWidth',2,'LineStyle',':')
                text(xl(2)-0.15*(xl(2)-xl(1)),-(sc-1)*(num_trains+1)-num_trains/2-0.5,num2str(synfire),'Color','k','FontWeight','bold','FontSize',fs)
                text(xl(2)-0.1*(xl(2)-xl(1)),-(sc-1)*(num_trains+1)-num_trains/2-0.5,num2str(delta),'Color','k','FontWeight','bold','FontSize',fs)
                text(xl(2)-0.05*(xl(2)-xl(1)),-(sc-1)*(num_trains+1)-num_trains/2-0.5,num2str(overall_delta),'Color','k','FontWeight','bold','FontSize',fs)
                old_synfire=synfire;
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
    
    if surro_plot>0
        if surro_plot==1
            sc=0;
        end
        overall_delta=synf(suc)-ini_synfire;
        plot(-(sc-1)*(num_trains+1)-all_trains,[cols(2),symb(2)],'LineWidth',lw,'MarkerSize',ms)
        if histo_one_plot==1
            for ec=1:9
                plot((ec-1)*num_trains+(1:num_trains-(ec==9)),num_trains+1-all_trains((ec-1)*num_trains+(1:num_trains-(ec==9))),[cols(2),symb(2),'--'],'LineWidth',1,'MarkerSize',ms)
            end
        end
        %text(xl(2)-0.12*(xl(2)-xl(1)),yl(1)+0.05*(yl(2)-yl(1)),num2str(synf(suc)),'Color',cols(2),'FontWeight','bold','FontSize',fs-2)
        %text(xl(2)-0.07*(xl(2)-xl(1)),yl(1)+0.05*(yl(2)-yl(1)),num2str(synf(suc)*2/(num_trains-1)/num_all_spikes,3),'Color',cols(2),'FontWeight','bold','FontSize',fs-2)
        final=synf(suc)*2/(num_trains-1)/num_all_spikes;
        %title(['Original: ',num2str(fin,3),'   ---   Surrogate #',num2str(suc),': ',num2str(final,3)],'FontWeight','bold','FontSize',fs-1)
        title(['F_{Or} = ',num2str(fin,3),'  ;  F_{S',num2str(suc),'} = ',num2str(final,3)],'FontWeight','bold','FontSize',fs-1)
        text(xl(1)-0.15*(xl(2)-xl(1)),yl(2)+0.05*(yl(2)-yl(1)),'(a)','Color','k','FontSize',fs,'FontWeight','bold')
        box on
        printing=0;
        if printing>0
            set(gcf,'PaperOrientation','Portrait'); set(gcf,'PaperType','A4');
            set(gcf,'PaperUnits','Normalized','PaperPosition',[0 0.05 1.0 0.9]);
            psname=['SPIKE_order_surro_',num2str(dataset),'_',num2str(suc),'.ps'];
            print(gcf,'-dpsc',psname)
        end
    end
    if suc==num_surros || dataset>100
        disp(['Ori:   ',num2str(fin,3),'   ---   S#',num2str(suc),'  ',regexprep(num2str(synf*2/(num_trains-1)/num_all_spikes,3),'   ',' ')])
        %disp(['Ori:   ',num2str(fin,3),'   ---   S#',num2str(suc),'  ',regexprep(num2str(synf,3),'   ',' ')])
    end
end

end


