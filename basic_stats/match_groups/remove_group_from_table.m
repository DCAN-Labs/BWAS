function updated_table=remove_group_from_table(input_table,group_column,group_to_be_removed)

%% function updated_table=remove_group_from_table(input_table,group_column,group_to_be_removed)

%% Oscar Miranda-Dominguez
% First line of code, Sept 12, 2019
% This function removes data from a given group. It was made to make make
% match_groups function work when more than 2 groups are reported in
% input_table
updated_table=input_table; % preallocating

n_group_to_be_removed=size(group_to_be_removed,1);
for j=1:n_group_to_be_removed
    all=updated_table(:,group_column);
    ix=find(ismember(table2array(all),group_to_be_removed,'rows'));
    updated_table(ix,:)=[];
end