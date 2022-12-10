function cat_optimal_components = get_cat_components_from_cat_MAE(cat_MAE)

n=size(cat_MAE,1);

cat_optimal_components=cell(n,1);
for i=1:n
    temp=cat_MAE{i,end};
    cat_optimal_components{i}=temp{:};
end

cat_optimal_components=get_comp_to_explore(cat_optimal_components);