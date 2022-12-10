function [IX,unique_names]=grupify_T(T)

all_names=T{:,1};
unique_names=unique(all_names,'rows');
n_unique_names=numel(unique_names);

IX=cell(n_unique_names,1);
for i=1:n_unique_names
    ix=find(ismember(all_names,unique_names{i}));
    IX{i}=ix;
    unique_names{i}=[unique_names{i} '_n_' num2str(numel(ix))];
end