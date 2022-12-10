function cat_results = patch_cat_samples_1_2(cat_MAE_path,xval_MAE_with_ranks_path)

%%
% cat_MAE_path='/mnt/rose/shared/projects/pco_branch/gait_balance_controls/Experiments/PLSR/standard/scouting_boxcox_EO/0_30/scout/cat_MAE_1_sample.csv';
% xval_MAE_with_ranks_path='/mnt/rose/shared/projects/pco_branch/gait_balance_controls/Experiments/PLSR/standard/scouting_boxcox_EO/0_30/scout/cat_MAE_2_samples.csv';

%%
dic1=which('dictionary_MAE_1_sample.csv');
dic2=which('dictionary_MAE_2_samples.csv');

T1 = import_tidyData_with_Dictionary(dic1,cat_MAE_path);
T1.Properties.RowNames=cellstr(T1.Row);
T1(:,1)=[];

T2 = import_tidyData_with_Dictionary(dic2,xval_MAE_with_ranks_path);
T2.Properties.RowNames=cellstr(T2.Row);
T2(:,1)=[];


%%
cat_results = cat_samples_1_2(T1,T2)