function cat_results = cat_samples_1_2(cat_MAE,xval_MAE_with_ranks)
%%

T1=cat_MAE;
T2=xval_MAE_with_ranks;

old_header={'mae'};
new_header={'mae_2_samples'};
T2=rename_table_header(T2,old_header,new_header);

old_header={'p_uncorrected'};
new_header={'p_uncorrected_mae_2_samples'};
T2=rename_table_header(T2,old_header,new_header);

old_header={'n_comp'};
new_header={'n_comp_2_samples'};
T2=rename_table_header(T2,old_header,new_header);

%%

T1=sortrows(T1,'RowNames');
T2=sortrows(T2,'RowNames');
cat_results=[T1 T2];
% cat_results(:,[3 4 6])=[];
cat_results=sortrows(cat_results,1,'ascend');