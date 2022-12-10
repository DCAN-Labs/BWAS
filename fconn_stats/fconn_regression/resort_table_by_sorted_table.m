function [resorted_cat_local_table2,resorted_cat_local_within_headers2]=resort_table_by_sorted_table(cat_local_table2,cat_local_within_headers2,cat_MAE)

target_row_names=cat_MAE.Properties.RowNames;
n_target=size(target_row_names,1);

n_unsorted=size(cat_local_within_headers2,1);
unsorted_row_names=cell(n_unsorted,1);

for i=1:n_unsorted
    local_system_pair=unique(cat_local_within_headers2{i});
    unsorted_row_names(i)=local_system_pair{1,1};
end

ix=nan(n_target,1);
for i=1:n_target
    local_system_pair=target_row_names{i};
    ix(i)=find(ismember(unsorted_row_names,local_system_pair));
end

resorted_cat_local_table2=cat_local_table2(ix);
resorted_cat_local_within_headers2=cat_local_within_headers2(ix);