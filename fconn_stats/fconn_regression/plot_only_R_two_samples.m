function plot_only_R_two_samples(performance,Weights,labels,P,Y)

n=size(labels,1);
local_P=zeros(n,1);

R=zeros(n,1);
R_null=zeros(n,1);
n_alt_null=zeros(n,2);

p_unc=zeros(n,1);
p_unc_closed=zeros(n,1);
p_unc_cummulative=zeros(n,1);

tails=1;
for k=1:n
    y_alt_obv_pred=[Y{k}.alt.observed Y{k}.alt.predicted];
    %     R(k)=corr(y_alt_obv_pred(:,1),y_alt_obv_pred(:,2));
    
    h1=y_alt_obv_pred(:,1:end/2);
    h2=y_alt_obv_pred(:,end/2+1:end);
    [R(k), p_unc_closed(k)]=corr(h1(:),h2(:));
    n1=numel(h1);
    
    y_null_obv_pred=[Y{k}.null.observed Y{k}.null.predicted];
    h1=y_null_obv_pred(:,1:end/2);
    h2=y_null_obv_pred(:,end/2+1:end);
    R_null(k)=corr(h1(:),h2(:));
    n2=numel(h1);
    %     n_alt_null(k,:)=[size(y_alt_obv_pred,1) size(y_null_obv_pred,1)];
    
    r1=R(k);
    r2=R_null(k);
    %     n1=n_alt_null(k,1);
    %     n2=n_alt_null(k,2);
    
    p_unc(k)=get_p_from_rs(r1,r2,n1,n2,tails);
    p_unc_cummulative(k)=P{1}{1}.c;
end

[b ix]=sort(R,'descend');
% [b ix]=sort(p_unc,'ascend');
%% Correct for multiple comparisons
[foo foo p_cor]=fdr_bh(p_unc);
[foo foo p_cor_closed]=fdr_bh(p_unc_closed);
[foo foo p_cor_cummulative]=fdr_bh(p_unc_cummulative);

%% make summary table | P cummulative

R_table=table(labels(ix),R(ix),R_null(ix),p_unc_cummulative(ix),p_cor_cummulative(ix));
R_table.Properties.VariableNames{1}='Network_Network';
R_table.Properties.VariableNames{2}='R_alt';
R_table.Properties.VariableNames{3}='R_null';
R_table.Properties.VariableNames{4}='p_uncorrected';
R_table.Properties.VariableNames{5}='p_corrected';

writetable(R_table,['R_p_null_cummulative_distribution.csv'])
%% make summary table | P closed form

R_table=table(labels(ix),R(ix),R_null(ix),p_unc_closed(ix),p_cor_closed(ix));
R_table.Properties.VariableNames{1}='Network_Network';
R_table.Properties.VariableNames{2}='R_alt';
R_table.Properties.VariableNames{3}='R_null';
R_table.Properties.VariableNames{4}='p_uncorrected';
R_table.Properties.VariableNames{5}='p_corrected';

writetable(R_table,['R_p_closed_form.csv'])
%% make summary table

R_table=table(labels(ix),R(ix),R_null(ix),p_unc(ix),p_cor(ix));
R_table.Properties.VariableNames{1}='Network_Network';
R_table.Properties.VariableNames{2}='R_alt';
R_table.Properties.VariableNames{3}='R_null';
R_table.Properties.VariableNames{4}='p_uncorrected';
R_table.Properties.VariableNames{5}='p_corrected';

writetable(R_table,['R_p_from_zscores.csv'])
%% make summary table

p_table=table(labels(ix),R(ix),R_null(ix),p_unc(ix),p_cor(ix));

%%
output_folder=[pwd filesep 'R_p_by_z_scores'];
show_scatters_different_p(n,Y,R,ix,p_unc,p_cor,labels,output_folder)

output_folder=[pwd filesep 'R_p_by_closed_form'];
show_scatters_different_p(n,Y,R,ix,p_unc_closed,p_cor_closed,labels,output_folder)

output_folder=[pwd filesep 'R_p_by_null_cummulative_distribution'];
show_scatters_different_p(n,Y,R,ix,P{1}{1}.c,P{1}{1}.c,labels,output_folder)

%% Plot distributions



fig_size=[8 8 24 8];% cm
vis_flag='on';
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
for k=1:n
    
    
    if R(ix(k))>0
        
        perf=performance{ix(k)};
        nn_label=labels{ix(k)};
        p=P{ix(k)};
        show_dists_performance(perf,nn_label,p)
        
        f.InvertHardcopy = 'off';
        %     print(fig_name,'-dtiffn','-r300')
        
        fig_name=[num2str(k) '_Distributions_' labels{ix(k)} ];
        fig_name(fig_name==' ')='_';
        set(f,'name',fig_name);
        
        saveas(gcf,fig_name)
        img = getframe(gcf);
        imwrite(img.cdata, [fig_name, '.png']);
        
        %         print(fig_name,'-dpng','-r300')
        
        
        
    end
end
%%
%% Plot distributions per cost function

fig_size=[8 8 6 8];% cm
fig_size=[8 8 6 6];% cm
vis_flag='on';
f = figure('Visible',vis_flag,...
    'Units','centimeters',...
    'PaperUnits','centimeters',...
    'PaperPosition',fig_size,...
    'Position',fig_size,...
    'color',[1 1 1]);
for i=1:3
    all_perf=zeros(n,1);
    all_p=zeros(n,1);
    for j=1:n
        
        local_str=performance{j}.alt;
        local_str=struct2cell(local_str);
        all_perf(j)=local_str{i};
        
        
        all_p(j)=P{j}{i}.c;
    end
    fnames=fieldnames(performance{j}.alt);
    local_dir=fnames{i};
    mkdir(local_dir);
    cd (local_dir)
    
    [B I]=sort(all_perf,'ascend');
    
    
    [foo foo all_p_corrected]=fdr_bh(all_p);
    
    
    p_table=table(labels(I),all_perf(I),all_p(I),all_p_corrected(I));
    p_table.Properties.VariableNames{1}='Network_Network';
    p_table.Properties.VariableNames{2}=fnames{i};
    p_table.Properties.VariableNames{3}='p_uncorrected';
    p_table.Properties.VariableNames{4}='p_corrected';
    
    writetable(p_table,[fnames{i} '_performance_p_.csv'])
    
    counter=0;
    for k=I'
        
        
        if R(k)>0
            
            perf=performance{k};
            nn_label=labels{k};
            p=P{k};
            
            
            
            %             show_1_dist_performance(perf,nn_label,p,i)
            show_1_dist_performance_compact(perf,nn_label,p,i)
            
            f.InvertHardcopy = 'off';
            %     print(fig_name,'-dtiffn','-r300')
            
            counter=counter+1;
            fig_name=[num2str(counter) '_' labels{k} ];
            fig_name(fig_name==' ')='_';
            set(f,'name',fig_name);
            
            saveas(gcf,fig_name)
            img = getframe(gcf);
            imwrite(img.cdata, [fig_name, '.png']);
            
            %         pause
            
            
            
        end
    end
    cd ..
end
%%
