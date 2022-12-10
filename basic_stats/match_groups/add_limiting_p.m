function [matched_table, ix_p_0_05]=add_limiting_p(matched_table,tidyData,matched_participants,column_to_group_by,columns_to_be_matched)

%% TO add info about the limiting (min) p_value as more participants are included
%
% Part of the match_groups_function
% Oscar Miranda Dominguez, Feb 10, 2019
n_matches=size(matched_table,1);
min_p_value=table('Size',[n_matches 3],'VariableTypes',{'double','string','string'}); 
min_p_value.Properties.VariableNames{1}='min_p_value';
min_p_value.Properties.VariableNames{2}='from_variable';
min_p_value.Properties.VariableNames{3}='from_paired_comparison';
min_p_value(:,1)=table(repmat(nan,n_matches,1));
n_per_group=[1:n_matches]';
n_per_group=table(n_per_group);
from=3;
for i=from:n_matches
    to_include=1:i;
    bivariate_table=bivariate_summary(tidyData,matched_participants(to_include,:),column_to_group_by,columns_to_be_matched);
    ix_only_ttest=1:2:size(bivariate_table,1);
    bivariate_table_only_ttest=bivariate_table(ix_only_ttest,:);
    P=table2array(bivariate_table_only_ttest);
    size_P=size(P);
    
    
    [local_min_p,ix]=min(P(:));
    [I, J]=ind2sub(size_P,ix);
    min_p_value(i,1)=table(local_min_p);
    
    min_p_value(i,2)=bivariate_table_only_ttest.Properties.RowNames(I);
    
    min_p_value{i,3}=bivariate_table_only_ttest.Properties.VariableNames(J);
end
only_p=table2array(min_p_value(from:end,1));
only_p_gt_0_05=only_p>0.05;
only_p_gt_0_05=[ones(from-1,1);only_p_gt_0_05];

ix_p_0_05=find(only_p_gt_0_05,1,'last');
matched_table=[n_per_group matched_table min_p_value];