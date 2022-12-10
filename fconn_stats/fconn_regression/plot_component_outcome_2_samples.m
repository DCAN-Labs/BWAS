function plot_component_outcome_2_samples(resorted_cat_local_table,resorted_cat_local_within_headers,cat_optimal_components,local_y,fconn_reg_options,resorted_cat_local_table2,local_y2)
% function [T]=scout_components_two_samples(resorted_cat_local_table,resorted_cat_local_within_headers,cat_optimal_components,local_y,fconn_reg_options,resorted_cat_local_table2,local_y2)

%%
wd=pwd;

%%
% path_dictionary_mae_performance_p_=which('dictionary_mae_performance_p_.csv');
% path_dictionary_R_p_from_zscores=which('dictionary_R_p_from_zscores.csv');
%%
%%

Y=cell(2,1);
Y{1}=local_y;
Y{2}=local_y2;
n_NN=size(resorted_cat_local_table,1);
% cat_mae=cell(n_NN,1);
% cat_n_comp=cell(n_NN,1);
max_comp_per_NN=size(cat_optimal_components,2);
Network_Network=cell(n_NN,1);
labels=cell(n_NN,1);
% CAT_tidyData=[];
% rank_from_1_sample_d=nan(sum(~isnan(cat_optimal_components(:))),1);
k=0;
for i=1:n_NN
    local_main_table=resorted_cat_local_table{i};
    validation_table=resorted_cat_local_table2{i};
    local_within_headers=resorted_cat_local_within_headers{i};
    comp_to_explore=cat_optimal_components(i,:);
    comp_to_explore(isnan(comp_to_explore))=[];
    
    
    local_n_comp=numel(comp_to_explore);
    %     local_mae=nan(local_n_comp,1);
    lab=char(local_within_headers{1,1});
    lab=strrep(lab,' ','_');
    Network_Network{i}=lab;
    %     comp_to_explore=cat_optimal_components{i};
    %     if iscell(comp_to_explore)
    %         comp_to_explore=cell2mat(comp_to_explore);
    %     end
    
    for n_comp=comp_to_explore
        
        k=k+1;
        rank_from_1_sample_d(k)=i;
        fconn_reg_options.components=n_comp;
        % Get componets
        [Xscores1,labels,PCTVAR1]=get_first_component_fconn_regression(local_main_table, local_within_headers,local_y,fconn_reg_options);
        [Xscores2,labels,PCTVAR2]=get_first_component_fconn_regression(validation_table, local_within_headers,local_y2,fconn_reg_options);
        
        pVAR=cell(2,1);
        pVAR{1}=PCTVAR1;
        pVAR{2}=PCTVAR2;
        
        lmt=cell(2,1);
        lmt{1}=local_main_table;
        lmt{2}=validation_table;
        
        Xscores=cell(2,1);
        Xscores{1}=Xscores1{1};
        Xscores{2}=Xscores2{1};
        %
        [X1, labels]=get_fconn_labels(local_main_table, local_within_headers);
        [X2, labels]=get_fconn_labels(validation_table, local_within_headers);
        
        mean_fconn=cell(2,1);
        mean_fconn{1}=X1{1};
        mean_fconn{2}=X2{1};
        
        % COmbined data 
%         j=1;
%         first_component=[Xscores1{1}(:,j); Xscores2{1}(:,j)];
%         outcome=[local_y;local_y2];
%         g=[repmat({'Sample 1'},n(1),1);repmat({'Sample 2'},n(2),1)];
        
        
%         [performance,Weights,labels,P,Y]=fconn_regression_two_samples(local_main_table, local_within_headers,local_y,fconn_reg_options,validation_table,local_y2);
        for j=1:2
            local_folder=[wd filesep lab '_' num2str(n_comp) '_components' filesep 'sample_' num2str(j)];
            mkdir(local_folder);
            cd(local_folder);
            
            explained_variance=pVAR{j};
            explained_variance=explained_variance(end,:);
            if iscell(explained_variance)
                explained_variance=cell2mat(explained_variance);
                explained_variance=explained_variance(end,:);
            end
            [h,T]=explained_variance_plot(explained_variance);
            up_to=find(T{:,end}>80,1);
            scatter_comp_outcome_mean_fconn(Xscores{j},Y{j},mean_fconn{j},'up_to',up_to);
            writetable(T,'explained_variance.csv');
            
%             explore_parameters_fconn_regression_plot_first_component(lmt{j},local_within_headers,Y{j},fconn_reg_options,y_color)
        
        end
        close all
        
        
        %% Plot sample 1

        
        
        
    end
    
end
cd(wd);

%% find best p from2 samples

% T=sortrows(CAT_tidyData,5)
% mae_2s=CAT_tidyData.mae;
% [B, rank_from_2_samples]=sort(mae_2s);
%
% %% adding rank from 2 samples
% CAT_tidyData=[CAT_tidyData table(rank_from_2_samples)];
% %%
% T=CAT_tidyData;
% CAT_tidyData=sortrows(CAT_tidyData,3);


