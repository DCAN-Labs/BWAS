function xval_MAE_with_ranks=add_ranks_MAE(cat_MAE_tidy,xval_MAE)

tbl1 = sortrows( cat_MAE_tidy ,'RowNames');
tbl2 = sortrows( xval_MAE ,'RowNames');
tbl2(:,1)=[];
T=[tbl1 tbl2];
n=size(T,1);

T1=sortrows(T,1);
T1=[T1 table([1:n]')];
T1.Properties.VariableNames{end}='rank_from_1_sample_mae';
% 
T2=sortrows(T1,3,'descend');
T2=[T2 table([1:n]')];
T2.Properties.VariableNames{end}='rank_from_1_sample_d';
T2(:,1:4)=[];

T3=sortrows(T2,2);
T3=[T3 table([1:n]')];
T3.Properties.VariableNames{end}='rank_from_2_samples_mae';

T4=sortrows(T3,3);
T4=[T4 table([1:n]')];
T4.Properties.VariableNames{end}='rank_from_2_samples_p';

T4=sortrows(T4,7);
xval_MAE_with_ranks=T4;