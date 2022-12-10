function comp_to_explore=get_comp_to_explore(cat_optimal_components)

n_rows=size(cat_optimal_components,1);
n_comp_to_explore=cellfun(@numel,cat_optimal_components);


comp_to_explore=nan(n_rows,max(n_comp_to_explore));

for i=1:n_rows
    local_comp=cat_optimal_components{i};
    for j=1:n_comp_to_explore(i)
        comp_to_explore(i,j)=local_comp(j);
    end
end
