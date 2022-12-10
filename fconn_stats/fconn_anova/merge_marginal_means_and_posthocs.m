function T = merge_marginal_means_and_posthocs(path_marginal_means,path_posthocs)


%% load tables

T_marg=readtable(path_marginal_means);
T_post=readtable(path_posthocs);

%% Identify the variable with the name factor_1, factor_2
startPat='_for_';
endPat='_BY_';
if ~contains(path_posthocs,endPat)
    endPat='_corrected_';
end
factor_= extractBetween(path_posthocs,startPat,endPat);
%% Find the column with the name factor_1, factor_2
if iscell(factor_)
    factor_=factor_{1};
end
header_names=[factor_ '_1'];
IX=find_ix_in_header(T_post,header_names);

%% Identify the first block for T

T_preffix=T_post(:,1:IX-1);
%% Identify last block

T_suffix=T_post(:,end-4:end);


%% get the factor_1, factor_2 values
local_T1=[T_preffix T_post(:,IX)];
T_factor_1=add_group_mean_values(local_T1,T_marg);


local_T2=[T_preffix T_post(:,IX+1)];
T_factor_2=add_group_mean_values(local_T2,T_marg);

%% COncatenate the tables

T=[T_preffix T_factor_1(:,2:end) T_factor_2(:,2:end) T_suffix];