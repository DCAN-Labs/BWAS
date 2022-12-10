function run_visualize_PLSR(main_table,within_headers,y,ix_to_ix_table,options)

%%
% Prep this to re-use prep scout
options.xval_left_N_out=0;

% reshape data from table to cells
[cat_local_table,cat_local_within_headers,cat_components,ROI_pair]=prep_scout(main_table, within_headers,options,ix_to_ix_table);


%%
n_components=4;

%% Extract PLSR data

%% do work
n_pairs=size(cat_local_table,1);
for i=1:n_pairs
    X=cat_local_table{i}{:,2:end};
    visualize_PLSR(X,y,n_components)
end
