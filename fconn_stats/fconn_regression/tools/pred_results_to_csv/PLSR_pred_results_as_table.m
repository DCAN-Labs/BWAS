function T = PLSR_pred_results_as_table(path_until_scout)

%% T = PLSR_pred_results_as_table(path_until_scout)
% Oscar Miranda-Dominguez
% First line of code: Aug 5, 2022
%% Dor sctratch/dabuging
addpath(genpath('/home/faird/shared/code/stable/utilities/BWAS_PNRS_package/v2/codebase/'))


% path_until_scout = '/panfs/jay/groups/4/miran045/shared/projects/polyneuro_risk_score/experiments/Mike_manuscript/Gordon/FD_0_20_time_10_mins/PLSR_ABCD_OHSU_base/case1_no_covariates/top_features/scout';

%% Find paths to pred_results files
to_look=[path_until_scout filesep 'optimized_2_samples'];
depth=1;
string_to_match='pred_results.mat';
path_pred_results=get_path_to_file(to_look,depth,string_to_match);

%% Count and pre-allocate

n=numel(path_pred_results);
i=1;
local_path=path_pred_results{i};
T = read_ys(local_path);

rows=size(T,1);

Y=nan(rows,n);
Y(:,i)=T.y_pred;
%% do it as a for loop

for i=2:n
    local_path=path_pred_results{i};
    T = read_ys(local_path);
    Y(:,i)=T.y_pred;
end
T_pred=T(:,1);
%% Get the header names

nested_folder_name=extract_nested_folder_name(path_pred_results);
temp=nested_folder_name(:,end-1);
newStr = split(temp,'_');
header_names=newStr(:,1);

%% Make the table
T=array2table(Y);
T.Properties.VariableNames=header_names;
T=[T_pred T];