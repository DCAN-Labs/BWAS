function [subgroup_names, n_subgroups_per_factor, header_ix]=count_subgroups(T,group_column)
%%

if ~iscell(group_column)
    if ~isempty(group_column)
        
        group_column=cellstr(group_column);
    end
end

headers=T.Properties.VariableNames;
n_factors=size(group_column,1);

subgroup_names=cell(n_factors,1);
n_subgroups_per_factor=zeros(n_factors,1);
header_ix=zeros(n_factors,1);

for i=1:n_factors
    ix_header=find(ismember(headers,group_column{i}));
    header_ix(i)=ix_header;
    temp_subgroup_names=unique(T{:,ix_header},'rows');
    if ~isnumeric(temp_subgroup_names)
        temp_subgroup_names=char(temp_subgroup_names);
    end
    subgroup_names{i}=temp_subgroup_names;
    n_subgroups_per_factor(i)=size(subgroup_names{i},1);
end