function [T,T_p_closed_form,T_p_by_null_cummulative_dist]=scout_components_two_samples(resorted_cat_local_table,resorted_cat_local_within_headers,cat_optimal_components,local_y,fconn_reg_options,resorted_cat_local_table2,local_y2)

%%
wd=pwd;

%%
path_dictionary_mae_performance_p_=which('dictionary_mae_performance_p_.csv');
path_dictionary_R_p_from_zscores=which('dictionary_R_p_from_zscores.csv');
%%

%%
n_NN=size(resorted_cat_local_table,1);
cat_mae=cell(n_NN,1);
cat_n_comp=cell(n_NN,1);
max_comp_per_NN=size(cat_optimal_components,2);
Network_Network=cell(n_NN,1);
labels=cell(n_NN,1);
CAT_tidyData=[];
CAT_tidyData_p_closed_form=[];
CAT_tidyData_p_by_null_cummulative_dist=[];

rank_from_1_sample_d=nan(sum(~isnan(cat_optimal_components(:))),1);
k=0;
for i=1:n_NN
    local_main_table=resorted_cat_local_table{i};
    validation_table=resorted_cat_local_table2{i};
    local_within_headers=resorted_cat_local_within_headers{i};
    comp_to_explore=cat_optimal_components(i,:);
    comp_to_explore(isnan(comp_to_explore))=[];
    
    
    local_n_comp=numel(comp_to_explore);
    local_mae=nan(local_n_comp,1);
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
        [performance,Weights,labels,P,Y]=fconn_regression_two_samples(local_main_table, local_within_headers,local_y,fconn_reg_options,validation_table,local_y2);
        
        local_folder=[wd filesep lab '_' num2str(n_comp) '_components'];
        mkdir(local_folder);
        cd(local_folder);
        plot_only_R_two_samples(performance,Weights,labels,P,Y)
        close all
        filename=[local_folder filesep 'mae' filesep 'mae_performance_p_.csv'];
        [tidyData, Dictionary] = import_tidyData_with_Dictionary(path_dictionary_mae_performance_p_,filename);
        tidyData(:,end)=[];
        %         R=performance{1}.alt.R;
        
        R_p_from_zscores_filename=[local_folder filesep 'R_p_from_zscores.csv'];
        getP=import_tidyData_with_Dictionary(path_dictionary_R_p_from_zscores,R_p_from_zscores_filename);
        getP.Properties.VariableNames{4}=[getP.Properties.VariableNames{4} '_R'];
        
        tidyData=[tidyData table(n_comp) getP(:,[2 4])];
        tidyData=tidyData(:,[1 4 2 3 5 6]);
        CAT_tidyData=[CAT_tidyData;tidyData];
        %%
        filename=[local_folder filesep 'mae' filesep 'mae_performance_p_.csv'];
        [tidyData, Dictionary] = import_tidyData_with_Dictionary(path_dictionary_mae_performance_p_,filename);
        tidyData(:,end)=[];
        %         R=performance{1}.alt.R;
        
        R_p_closed_form_filename=[local_folder filesep 'R_p_closed_form.csv'];
        getP=import_tidyData_with_Dictionary(path_dictionary_R_p_from_zscores,R_p_closed_form_filename);
        getP.Properties.VariableNames{4}=[getP.Properties.VariableNames{4} '_R'];
        
        tidyData=[tidyData table(n_comp) getP(:,[2 4])];
        tidyData=tidyData(:,[1 4 2 3 5 6]);
        CAT_tidyData_p_closed_form=[CAT_tidyData_p_closed_form;tidyData];
        %%
        
        filename=[local_folder filesep 'mae' filesep 'mae_performance_p_.csv'];
        [tidyData, Dictionary] = import_tidyData_with_Dictionary(path_dictionary_mae_performance_p_,filename);
        tidyData(:,end)=[];
        %         R=performance{1}.alt.R;
        
        R_p_null_cummulative_distribution_filename=[local_folder filesep 'R_p_null_cummulative_distribution.csv'];
        getP=import_tidyData_with_Dictionary(path_dictionary_R_p_from_zscores,R_p_null_cummulative_distribution_filename);
        getP.Properties.VariableNames{4}=[getP.Properties.VariableNames{4} '_R'];
        
        tidyData=[tidyData table(n_comp) getP(:,[2 4])];
        tidyData=tidyData(:,[1 4 2 3 5 6]);
        CAT_tidyData_p_by_null_cummulative_dist=[CAT_tidyData_p_by_null_cummulative_dist;tidyData];
        %%
        
        filename='pred_results.mat';
        save(filename,'performance')
        save(filename,'Weights','-append')
        save(filename,'labels','-append')
        save(filename,'P','-append')
        save(filename,'Y','-append')
        
    end
    
end
cd(wd);
%% adding rank from 1 sample
CAT_tidyData=[CAT_tidyData table(rank_from_1_sample_d)];
CAT_tidyData_p_closed_form=[CAT_tidyData_p_closed_form table(rank_from_1_sample_d)];
CAT_tidyData_p_by_null_cummulative_dist=[CAT_tidyData_p_by_null_cummulative_dist table(rank_from_1_sample_d)];
%% Resorting

CAT_tidyData=CAT_tidyData(:,[1 7 2:6]);
CAT_tidyData_p_closed_form=CAT_tidyData_p_closed_form(:,[1 7 2:6]);
CAT_tidyData_p_by_null_cummulative_dist=CAT_tidyData_p_by_null_cummulative_dist(:,[1 7 2:6]);
%%
for i=1:size(CAT_tidyData,1)
    CAT_tidyData.Properties.RowNames{i}=char(CAT_tidyData{i,1});
    CAT_tidyData_p_closed_form.Properties.RowNames{i}=char(CAT_tidyData_p_closed_form{i,1});
    CAT_tidyData_p_by_null_cummulative_dist.Properties.RowNames{i}=char(CAT_tidyData_p_by_null_cummulative_dist{i,1});
end

CAT_tidyData(:,1)=[];
CAT_tidyData_p_closed_form(:,1)=[];
CAT_tidyData_p_by_null_cummulative_dist(:,1)=[];
%%
T=CAT_tidyData;
T_p_closed_form=CAT_tidyData_p_closed_form;
T_p_by_null_cummulative_dist=CAT_tidyData_p_by_null_cummulative_dist;
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


